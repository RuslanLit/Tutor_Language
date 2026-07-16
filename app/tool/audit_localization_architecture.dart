import 'dart:convert';
import 'dart:io';

const _supportLocalizationPath =
    'assets/languages/spanish/localization/support_localizations.json';
const _pronunciationPath =
    'assets/languages/spanish/pronunciation/reference_slice.json';
const _ukGeneratorPath = 'tool/translate_content_localization_uk.dart';
const _ukAuditPath = 'tool/audit_ukrainian_content_localization.dart';
const _runtimeLocalizationPath = 'lib/core/content/content_localization.dart';

void main() {
  final findings = <_Finding>[];
  final supportLocalization = _readJsonObject(_supportLocalizationPath);
  final pronunciation = _readJsonObject(_pronunciationPath);

  _auditSupportLocalization(supportLocalization, findings);
  _auditPronunciationArchitecture(pronunciation, supportLocalization, findings);
  _auditToolingMechanisms(findings);
  _auditRuntimeFallback(findings);

  final bySeverity = <_Severity, int>{};
  final byCode = <String, int>{};
  for (final finding in findings) {
    bySeverity.update(
      finding.severity,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
    byCode.update(finding.code, (value) => value + 1, ifAbsent: () => 1);
  }

  stdout.writeln('Localization architecture audit');
  stdout.writeln('diagnosticOnly: true');
  stdout.writeln('exitPolicy: non-zero findings do not fail this tool');
  stdout.writeln('findings: ${findings.length}');
  for (final severity in _Severity.values) {
    stdout.writeln('${severity.name}: ${bySeverity[severity] ?? 0}');
  }
  stdout.writeln('byCode:');
  for (final entry
      in byCode.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    stdout.writeln('  ${entry.key}: ${entry.value}');
  }

  stdout.writeln('firstFindings:');
  for (final finding in findings.take(250)) {
    stdout.writeln(finding.format());
  }
  if (findings.length > 250) {
    stdout.writeln('... ${findings.length - 250} additional findings omitted');
  }
}

Map<String, Object?> _readJsonObject(String path) {
  final file = _resolveFile(path);
  return Map<String, Object?>.from(jsonDecode(file.readAsStringSync()) as Map);
}

File _resolveFile(String appRelativePath) {
  final candidates = [File(appRelativePath), File('app/$appRelativePath')];
  for (final candidate in candidates) {
    if (candidate.existsSync()) {
      return candidate;
    }
  }
  throw StateError('File not found: $appRelativePath');
}

void _auditSupportLocalization(
  Map<String, Object?> bundle,
  List<_Finding> findings,
) {
  final entries = (bundle['entries'] as List? ?? const []).whereType<Map>();
  final sourceByEnglish = <String, List<_LocalizedField>>{};
  final sourceByUkrainian = <String, List<_LocalizedField>>{};

  var fieldCount = 0;
  for (final rawEntry in entries) {
    final entry = Map<String, Object?>.from(rawEntry);
    final type = entry['type'] as String? ?? '';
    final id = entry['id'] as String? ?? '';
    final fields = Map<String, Object?>.from(
      entry['fields'] as Map? ?? const {},
    );
    if (!entry.containsKey('semanticFieldTypes') &&
        !entry.containsKey('reviewStatus') &&
        !entry.containsKey('reviewedBy')) {
      findings.add(
        _Finding(
          severity: _Severity.warning,
          code: 'localization.entryUntypedUnreviewed',
          path: _supportLocalizationPath,
          type: type,
          id: id,
          field: '*',
          semanticFieldType: 'missing',
          explanation:
              'Entry has localized strings but no per-field semantic type or review metadata.',
        ),
      );
    }

    for (final fieldEntry in fields.entries) {
      final values = Map<String, Object?>.from(fieldEntry.value as Map);
      final english = values['en'];
      final ukrainian = values['uk'];
      if (english is! String || ukrainian is! String) {
        continue;
      }
      fieldCount += 1;
      final semanticType = _inferSemanticFieldType(
        type,
        fieldEntry.key,
        english,
      );
      final localizedField = _LocalizedField(
        type: type,
        id: id,
        field: fieldEntry.key,
        english: english,
        ukrainian: ukrainian,
        semanticFieldType: semanticType,
      );
      sourceByEnglish
          .putIfAbsent(_normalize(english), () => <_LocalizedField>[])
          .add(localizedField);
      sourceByUkrainian
          .putIfAbsent(_normalize(ukrainian), () => <_LocalizedField>[])
          .add(localizedField);

      _auditUkrainianValue(localizedField, findings);
    }
  }

  findings.add(
    _Finding(
      severity: _Severity.info,
      code: 'localization.fieldInventory',
      path: _supportLocalizationPath,
      type: 'bundle',
      id: bundle['targetLanguage'] as String? ?? 'unknown',
      field: 'entries',
      semanticFieldType: 'summary',
      explanation:
          'Audited $fieldCount localized fields; semantic types are inferred because the asset does not carry authoritative field ownership.',
    ),
  );

  for (final fields in sourceByEnglish.values) {
    final semanticTypes = fields
        .map((field) => field.semanticFieldType)
        .toSet();
    final ukrainianValues = fields
        .map((field) => _normalize(field.ukrainian))
        .toSet();
    if (fields.length > 1 && semanticTypes.length > 1) {
      final sample = fields.take(4).map((field) => field.location).join('; ');
      findings.add(
        _Finding(
          severity: _Severity.warning,
          code: 'localization.sameSourceDifferentContexts',
          path: _supportLocalizationPath,
          type: 'localized_field',
          id: fields.first.id,
          field: fields.first.field,
          semanticFieldType: semanticTypes.join(','),
          explanation:
              'Same English source string is reused across different inferred semantic contexts: $sample',
        ),
      );
    }
    if (ukrainianValues.length > 1 && fields.length > 1) {
      final sample = fields.take(4).map((field) => field.location).join('; ');
      findings.add(
        _Finding(
          severity: _Severity.warning,
          code: 'localization.sameSourceMultipleTargets',
          path: _supportLocalizationPath,
          type: 'localized_field',
          id: fields.first.id,
          field: fields.first.field,
          semanticFieldType: fields.first.semanticFieldType,
          explanation:
              'Same English source string has multiple Ukrainian translations, indicating context-dependent translation not modeled explicitly: $sample',
        ),
      );
    }
  }

  for (final fields in sourceByUkrainian.values) {
    final englishValues = fields
        .map((field) => _normalize(field.english))
        .toSet();
    if (englishValues.length > 3 && fields.length > 3) {
      final sample = fields.take(4).map((field) => field.location).join('; ');
      findings.add(
        _Finding(
          severity: _Severity.warning,
          code: 'localization.sameTargetManySources',
          path: _supportLocalizationPath,
          type: 'localized_field',
          id: fields.first.id,
          field: fields.first.field,
          semanticFieldType: fields.first.semanticFieldType,
          explanation:
              'Same Ukrainian string is reused for many English sources; this may be valid, but is a risk when generated by string templates: $sample',
        ),
      );
    }
  }
}

void _auditUkrainianValue(
  _LocalizedField localizedField,
  List<_Finding> findings,
) {
  final value = localizedField.ukrainian;
  if (RegExp(r'[ыэёъ]').hasMatch(value)) {
    findings.add(
      _Finding.fromField(
        severity: _Severity.error,
        code: 'uk.russianCyrillicLeak',
        localizedField: localizedField,
        explanation:
            'Ukrainian value contains Cyrillic letters specific to Russian.',
      ),
    );
  }

  final russianLexemes = [
    'утренняя',
    'испанский',
    'семья',
    'спасибо',
    'извините',
    'очень',
    'зовут',
    'меня',
    'доброе',
    'город',
    'страна',
    'встреча',
  ];
  final lower = value.toLowerCase();
  for (final lexeme in russianLexemes) {
    if (RegExp(
      '(^|[^а-яіїєґ])$lexeme([^а-яіїєґ]|\$)',
      caseSensitive: false,
    ).hasMatch(lower)) {
      findings.add(
        _Finding.fromField(
          severity: _Severity.error,
          code: 'uk.russianLexemeLeak',
          localizedField: localizedField,
          explanation:
              'Ukrainian value contains likely Russian lexeme "$lexeme".',
        ),
      );
    }
  }

  final latinWords = RegExp(
    r"[A-Za-zÁÉÍÓÚÜÑáéíóúüñ¿¡']+",
  ).allMatches(value).map((match) => match.group(0)!).toList();
  for (final word in latinWords) {
    if (!_isAllowedSpanishSpan(word) && !_isAllowedTechnicalSpan(word)) {
      findings.add(
        _Finding.fromField(
          severity: _Severity.warning,
          code: 'uk.unclassifiedLatinSpan',
          localizedField: localizedField,
          explanation:
              'Ukrainian value contains Latin span "$word" that is not classified as target-language or technical content.',
        ),
      );
    }
  }

  if (RegExp(r'[А-Яа-яІіЇїЄєҐґ]').hasMatch(value) &&
      latinWords.length >= 2 &&
      !_looksLikeQuotedTargetExample(value)) {
    findings.add(
      _Finding.fromField(
        severity: _Severity.warning,
        code: 'uk.mixedScriptNeedsSpanClassification',
        localizedField: localizedField,
        explanation:
            'String mixes Cyrillic and multiple Latin spans without explicit source/target/support segmentation.',
      ),
    );
  }
}

bool _isAllowedSpanishSpan(String word) {
  final lower = word.toLowerCase();
  const commonSpanish = {
    'hola',
    'gracias',
    'adios',
    'adiós',
    'buenos',
    'buenas',
    'dias',
    'días',
    'tardes',
    'noches',
    'como',
    'cómo',
    'eres',
    'soy',
    'me',
    'llamo',
    'llamas',
    'usted',
    'tu',
    'tú',
    'mexico',
    'méxico',
    'chile',
    'luis',
    'ana',
    'carlos',
    'lucia',
    'lucía',
    'elena',
    'sofia',
    'sofía',
  };
  return commonSpanish.contains(lower) ||
      RegExp(r'^[A-ZÁÉÍÓÚÜÑ][a-záéíóúüñ]+$').hasMatch(word);
}

bool _isAllowedTechnicalSpan(String word) {
  return RegExp(r'^[A-Z][0-9]$').hasMatch(word) ||
      const {'IPA', 'JSON', 'A0'}.contains(word);
}

bool _looksLikeQuotedTargetExample(String value) {
  return value.contains('«') || value.contains('"') || value.contains('“');
}

void _auditPronunciationArchitecture(
  Map<String, Object?> pronunciation,
  Map<String, Object?> supportLocalization,
  List<_Finding> findings,
) {
  final ruleById = <String, Map<String, Object?>>{};
  for (final rawRule
      in (pronunciation['readingRules'] as List? ?? const [])
          .whereType<Map>()) {
    final rule = Map<String, Object?>.from(rawRule);
    final id = rule['id'] as String? ?? '';
    if (id.isNotEmpty) {
      ruleById[id] = rule;
    }
  }

  final vocabUkByPronunciationId = _vocabularyUkByPronunciationId(
    supportLocalization,
  );
  final entitySurfaces = <String, List<Map<String, Object?>>>{};

  for (final rawUnit
      in (pronunciation['units'] as List? ?? const []).whereType<Map>()) {
    final unit = Map<String, Object?>.from(rawUnit);
    final id = unit['id'] as String? ?? '';
    final target = unit['targetOrthography'] as String? ?? '';
    final hint = Map<String, Object?>.from(
      unit['localizedLearnerHints'] as Map? ?? const {},
    )['uk'];
    final relatedContentIds = (unit['relatedContentIds'] as List? ?? const [])
        .whereType<String>();
    for (final contentId in relatedContentIds) {
      final vocabMeaning =
          vocabUkByPronunciationId[id] ?? vocabUkByPronunciationId[contentId];
      if (vocabMeaning != null && hint is String) {
        final comparableHint = _normalize(hint.replaceAll('\u0301', ''));
        final comparableMeaning = _normalize(vocabMeaning);
        if (comparableHint == comparableMeaning) {
          findings.add(
            _Finding(
              severity: _Severity.error,
              code: 'pronunciation.hintEqualsMeaning',
              path: _pronunciationPath,
              type: 'pronunciation_unit',
              id: id,
              field: 'localizedLearnerHints.uk',
              semanticFieldType: 'pronunciation_hint',
              explanation:
                  'Pronunciation hint equals Ukrainian meaning "$vocabMeaning"; meaning and sound guidance are conflated.',
            ),
          );
        }
      }
    }

    final lowerTarget = target.toLowerCase();
    final readingRuleIds = (unit['readingRuleIds'] as List? ?? const [])
        .whereType<String>();
    for (final ruleId in readingRuleIds) {
      final rule = ruleById[ruleId];
      if (rule == null) {
        continue;
      }
      final pattern = rule['orthographicPattern'] as String? ?? '';
      if (pattern.isEmpty) {
        continue;
      }
      final lowerPattern = pattern.toLowerCase();
      if (!lowerTarget.contains(lowerPattern)) {
        findings.add(
          _Finding(
            severity: _Severity.error,
            code: 'readingRule.patternNotInTarget',
            path: _pronunciationPath,
            type: 'pronunciation_unit',
            id: id,
            field: 'readingRuleIds',
            semanticFieldType: 'reading_rule_reference',
            explanation:
                'Unit "$target" references rule "$ruleId" with pattern "$pattern", but that pattern is not present in the target orthography.',
          ),
        );
      }
      if (lowerPattern.length == 1 &&
          _patternOnlyAppearsInsideDigraph(lowerTarget, lowerPattern)) {
        findings.add(
          _Finding(
            severity: _Severity.error,
            code: 'readingRule.singleLetterInsideDigraph',
            path: _pronunciationPath,
            type: 'pronunciation_unit',
            id: id,
            field: 'readingRuleIds',
            semanticFieldType: 'reading_rule_reference',
            explanation:
                'Unit "$target" references single-letter rule "$ruleId" for "$pattern", but every occurrence is inside a digraph context such as "ch"; this is the Chile/silent-h failure class.',
          ),
        );
      }
    }

    if (_knownEntitySurface(target)) {
      entitySurfaces.putIfAbsent(_normalize(target), () => []).add(unit);
      if (!unit.containsKey('entityType') &&
          !unit.containsKey('meaningClass') &&
          !unit.containsKey('properNounType')) {
        findings.add(
          _Finding(
            severity: _Severity.warning,
            code: 'entity.surfaceWithoutEntityType',
            path: _pronunciationPath,
            type: 'pronunciation_unit',
            id: id,
            field: 'targetOrthography',
            semanticFieldType: 'proper_noun_or_toponym',
            explanation:
                'Proper noun/toponym "$target" has no entity type metadata, so country, city, personal name, exonym, and pronunciation can collide.',
          ),
        );
      }
    }
  }

  for (final entry in entitySurfaces.entries) {
    if (entry.value.length > 1) {
      findings.add(
        _Finding(
          severity: _Severity.warning,
          code: 'entity.sameSurfaceMultipleUnits',
          path: _pronunciationPath,
          type: 'pronunciation_unit',
          id: entry.value.map((unit) => unit['id']).join(','),
          field: 'targetOrthography',
          semanticFieldType: 'proper_noun_or_toponym',
          explanation:
              'Same entity surface appears in multiple pronunciation units without an explicit disambiguation model.',
        ),
      );
    }
  }
}

Map<String, String> _vocabularyUkByPronunciationId(
  Map<String, Object?> supportLocalization,
) {
  final result = <String, String>{};
  for (final rawEntry
      in (supportLocalization['entries'] as List? ?? const [])
          .whereType<Map>()) {
    final entry = Map<String, Object?>.from(rawEntry);
    if (entry['type'] != 'vocabulary') {
      continue;
    }
    final fields = Map<String, Object?>.from(
      entry['fields'] as Map? ?? const {},
    );
    final nativeTranslation = Map<String, Object?>.from(
      fields['native_translation'] as Map? ?? const {},
    );
    final uk = nativeTranslation['uk'];
    if (uk is String && uk.trim().isNotEmpty) {
      result[entry['id'] as String? ?? ''] = uk;
    }
  }
  return result;
}

bool _patternOnlyAppearsInsideDigraph(String target, String pattern) {
  final spanishDigraphs = {'ch', 'll', 'rr', 'qu', 'gu'};
  var found = false;
  for (
    var index = target.indexOf(pattern);
    index >= 0;
    index = target.indexOf(pattern, index + 1)
  ) {
    found = true;
    final before = index > 0 ? target[index - 1] : '';
    final after = index + pattern.length < target.length
        ? target[index + pattern.length]
        : '';
    final leftPair = '$before$pattern';
    final rightPair = '$pattern$after';
    if (!spanishDigraphs.contains(leftPair) &&
        !spanishDigraphs.contains(rightPair)) {
      return false;
    }
  }
  return found;
}

bool _knownEntitySurface(String value) {
  final lower = _normalize(value);
  return const {
    'mexico',
    'méxico',
    'chile',
    'barcelona',
    'bogota',
    'bogotá',
    'lima',
    'kyiv',
    'valencia',
    'buenos aires',
    'ana',
    'luis',
    'lucia',
    'lucía',
    'carlos',
    'elena',
    'sofia',
    'sofía',
  }.contains(lower);
}

void _auditToolingMechanisms(List<_Finding> findings) {
  final generator = _resolveFile(_ukGeneratorPath).readAsStringSync();
  final audit = _resolveFile(_ukAuditPath).readAsStringSync();

  final generatorSignals = {
    'generator.russianIntermediate': ['_ukrainianFromRussian', '_ruWordToUk'],
    'generator.exactOverrideTables': ['_fieldUk', '_exactUk'],
    'generator.embeddedDictionaryReplacement': [
      '_translateEmbedded',
      '_embeddedUk',
    ],
    'generator.templateMorphology': ['Мій/моя', 'потрібен/потрібна'],
    'generator.pronunciationByCyrillicSubstitution': [
      '_ukrainianPronunciationHint',
      "replaceAll('э'",
    ],
  };
  for (final entry in generatorSignals.entries) {
    if (entry.value.any(generator.contains)) {
      findings.add(
        _Finding(
          severity: _Severity.error,
          code: entry.key,
          path: _ukGeneratorPath,
          type: 'tool',
          id: 'translate_content_localization_uk',
          field: '*',
          semanticFieldType: 'generation_mechanism',
          explanation:
              'Generator contains mechanism ${entry.value.join(' / ')}; this is deterministic string conversion, not reviewed educational localization.',
        ),
      );
    }
  }

  final auditSignals = {
    'audit.lexemeBlocklistOnly': [
      '_forbiddenEnglishWords',
      '_forbiddenRussianWords',
    ],
    'audit.allowsBroadTargetSpans': ['_allowedLatinWords', '_spanishWords'],
    'audit.skipsGrammarExamples': [
      "type == 'grammar'",
      "field.key.startsWith('examples.')",
    ],
  };
  for (final entry in auditSignals.entries) {
    if (entry.value.any(audit.contains)) {
      findings.add(
        _Finding(
          severity: _Severity.warning,
          code: entry.key,
          path: _ukAuditPath,
          type: 'tool',
          id: 'audit_ukrainian_content_localization',
          field: '*',
          semanticFieldType: 'validation_mechanism',
          explanation:
              'Audit contains mechanism ${entry.value.join(' / ')}; this catches known leaks but cannot prove semantic, grammatical, or educational correctness.',
        ),
      );
    }
  }
}

void _auditRuntimeFallback(List<_Finding> findings) {
  final runtime = _resolveFile(_runtimeLocalizationPath).readAsStringSync();
  if (runtime.contains('values[locale.code] ??') &&
      runtime.contains('values[bundle.sourceSupportLocale]')) {
    findings.add(
      _Finding(
        severity: _Severity.warning,
        code: 'runtime.sourceLocaleFallback',
        path: _runtimeLocalizationPath,
        type: 'runtime',
        id: 'ContentLocalizationRepository',
        field: '_field',
        semanticFieldType: 'fallback_policy',
        explanation:
            'Runtime can fall back from a requested support locale to the source support locale, so a screen can load even when localized educational content is absent or incomplete.',
      ),
    );
  }
}

String _inferSemanticFieldType(String type, String field, String english) {
  if (field.contains('native_translation')) {
    return 'support_language_meaning';
  }
  if (field.contains('learnerHint') || field.contains('learnerHints')) {
    return 'support_language_pronunciation_hint';
  }
  if (field.contains('explanation') ||
      field.contains('notes') ||
      field.contains('objectives') ||
      field.contains('description')) {
    return 'support_language_instructional_prose';
  }
  if (field.contains('title')) {
    return 'support_language_label';
  }
  if (type == 'grammar' && field.contains('examples')) {
    return 'target_language_example_or_mixed_sentence';
  }
  if (RegExp(r'[¿¡ÁÉÍÓÚÜÑáéíóúüñ]').hasMatch(english)) {
    return 'target_language_span_inside_support_text';
  }
  return 'support_language_text';
}

String _normalize(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), ' ')
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ');
}

enum _Severity { error, warning, info }

class _LocalizedField {
  const _LocalizedField({
    required this.type,
    required this.id,
    required this.field,
    required this.english,
    required this.ukrainian,
    required this.semanticFieldType,
  });

  final String type;
  final String id;
  final String field;
  final String english;
  final String ukrainian;
  final String semanticFieldType;

  String get location => '$type:$id:$field';
}

class _Finding {
  const _Finding({
    required this.severity,
    required this.code,
    required this.path,
    required this.type,
    required this.id,
    required this.field,
    required this.semanticFieldType,
    required this.explanation,
  });

  factory _Finding.fromField({
    required _Severity severity,
    required String code,
    required _LocalizedField localizedField,
    required String explanation,
  }) {
    return _Finding(
      severity: severity,
      code: code,
      path: _supportLocalizationPath,
      type: localizedField.type,
      id: localizedField.id,
      field: localizedField.field,
      semanticFieldType: localizedField.semanticFieldType,
      explanation: '$explanation value="${localizedField.ukrainian}"',
    );
  }

  final _Severity severity;
  final String code;
  final String path;
  final String type;
  final String id;
  final String field;
  final String semanticFieldType;
  final String explanation;

  String format() {
    return [
      severity.name.toUpperCase(),
      code,
      path,
      'type=$type',
      'id=$id',
      'field=$field',
      'semantic=$semanticFieldType',
      explanation,
    ].join(' | ');
  }
}
