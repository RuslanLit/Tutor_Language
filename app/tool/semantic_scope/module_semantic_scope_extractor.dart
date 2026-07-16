import 'dart:convert';
import 'dart:io';

import 'semantic_scope_models.dart';

const coursePath = 'assets/languages/spanish/curriculum/spanish_a0_course.json';
const pronunciationPath =
    'assets/languages/spanish/pronunciation/reference_slice.json';

class ModuleSemanticScopeExtractor {
  ModuleSemanticScopeExtractor({this.rootPrefix = ''})
    : course = _readJsonObject(_resolve('$rootPrefix$coursePath')),
      pronunciation = _readJsonObject(
        _resolve('$rootPrefix$pronunciationPath'),
      ) {
    for (final raw in pronunciation['units'] as List? ?? const []) {
      final unit = Map<String, Object?>.from(raw as Map);
      pronunciationUnitsById[unit['id'] as String] = unit;
      for (final related in unit['relatedContentIds'] as List? ?? const []) {
        pronunciationByContentId.putIfAbsent('$related', () => unit);
      }
    }
    for (final raw in pronunciation['localizations'] as List? ?? const []) {
      final entry = Map<String, Object?>.from(raw as Map);
      pronunciationLocalizationsById[entry['id'] as String] = entry;
    }
    for (final raw in pronunciation['rules'] as List? ?? const []) {
      final rule = Map<String, Object?>.from(raw as Map);
      readingRulesById[rule['id'] as String] = rule;
    }
  }

  final String rootPrefix;
  final Map<String, Object?> course;
  final Map<String, Object?> pronunciation;
  final Map<String, Map<String, Object?>> pronunciationUnitsById = {};
  final Map<String, Map<String, Object?>> pronunciationByContentId = {};
  final Map<String, Map<String, Object?>> pronunciationLocalizationsById = {};
  final Map<String, Map<String, Object?>> readingRulesById = {};

  SemanticScope extract(String moduleId) {
    final module = _module(moduleId);
    final lessonIds = [
      for (final id in module['lessonIds'] as List? ?? const []) '$id',
    ];
    final identities = <String, SemanticRequiredIdentity>{};
    final dependencies = <ReusableDependency>[];
    final unresolved = <String>[];
    final validationIssues = <String>[];

    void add(SemanticRequiredIdentity identity) {
      final previous = identities[identity.stableIdentity];
      if (previous != null &&
          previous.englishSource != identity.englishSource) {
        validationIssues.add(
          'conflictingIdentitySource: ${identity.stableIdentity}',
        );
      }
      identities[identity.stableIdentity] = identity;
    }

    add(
      _identity(
        moduleId: moduleId,
        lessonIds: const [],
        sourceAssetPath: coursePath,
        sourceObjectId: '${course['id']}',
        fieldPath: 'title',
        contentKind: 'course',
        semanticType: 'courseTitle',
        ownership: 'supportLanguageOwned',
        pedagogicalRole: 'course title',
        englishSource: '${course['title']}',
        reason: 'shared course metadata',
        extractorLayer: 'course metadata',
        proposedExtractionRule: 'Include learner-facing course title.',
      ),
    );
    add(
      _identity(
        moduleId: moduleId,
        lessonIds: const [],
        sourceAssetPath: coursePath,
        sourceObjectId: moduleId,
        fieldPath: 'title',
        contentKind: 'module',
        semanticType: 'moduleTitle',
        ownership: 'supportLanguageOwned',
        pedagogicalRole: 'module title',
        englishSource: '${module['title']}',
        reason: 'module metadata',
        extractorLayer: 'module metadata',
        proposedExtractionRule: 'Include learner-facing module title.',
      ),
    );

    for (final rawLesson in course['lessons'] as List? ?? const []) {
      final lesson = Map<String, Object?>.from(rawLesson as Map);
      final metadata = Map<String, Object?>.from(lesson['metadata'] as Map);
      final lessonId = metadata['id'] as String;
      if (!lessonIds.contains(lessonId)) {
        continue;
      }
      _addLessonFields(add, moduleId, lessonId, metadata, lesson);
      for (final rawSection in lesson['sections'] as List? ?? const []) {
        final section = Map<String, Object?>.from(rawSection as Map);
        _addSimple(
          add,
          moduleId: moduleId,
          lessonId: lessonId,
          sourceAssetPath: coursePath,
          sourceObjectId: section['id'] as String,
          fieldPath: 'title',
          contentKind: 'lesson_section',
          semanticType: 'metadataLabel',
          pedagogicalRole: 'lesson section title',
          source: section['title'],
          reason: 'lesson section metadata',
        );
        for (final rawActivity in section['activities'] as List? ?? const []) {
          final activity = Map<String, Object?>.from(rawActivity as Map);
          _addSimple(
            add,
            moduleId: moduleId,
            lessonId: lessonId,
            sourceAssetPath: coursePath,
            sourceObjectId: activity['id'] as String,
            fieldPath: 'title',
            contentKind: 'lesson_activity',
            semanticType: 'metadataLabel',
            pedagogicalRole: 'activity title',
            source: activity['title'],
            reason: 'activity metadata',
          );
          for (final rawReference
              in activity['references'] as List? ?? const []) {
            final reference = Map<String, Object?>.from(rawReference as Map);
            final dependency = ReusableDependency(
              lessonId: lessonId,
              type: reference['type'] as String,
              assetPath: reference['assetPath'] as String,
              referenceId: '${reference['referenceId']}',
            );
            dependencies.add(dependency);
            _collectReference(
              add,
              moduleId: moduleId,
              lessonId: lessonId,
              dependency: dependency,
              unresolved: unresolved,
            );
          }
        }
      }
      final summary = lesson['summary'];
      if (summary is Map) {
        _addSimple(
          add,
          moduleId: moduleId,
          lessonId: lessonId,
          sourceAssetPath: coursePath,
          sourceObjectId: '${summary['id']}',
          fieldPath: 'reviewPrompt',
          contentKind: 'lesson_summary',
          semanticType: 'learnerInstruction',
          pedagogicalRole: 'review prompt',
          source: summary['reviewPrompt'],
          reason: 'review content',
        );
      }
    }

    return SemanticScope(
      courseId: '${course['id']}',
      moduleId: moduleId,
      lessonIds: List.unmodifiable(lessonIds),
      requiredIdentities: List.unmodifiable(
        identities.values.toList()
          ..sort((a, b) => a.stableIdentity.compareTo(b.stableIdentity)),
      ),
      reusableDependencies: List.unmodifiable(
        dependencies..sort(
          (a, b) => '${a.lessonId}|${a.type}|${a.referenceId}'.compareTo(
            '${b.lessonId}|${b.type}|${b.referenceId}',
          ),
        ),
      ),
      unresolvedFields: List.unmodifiable(unresolved..sort()),
      validationIssues: List.unmodifiable(validationIssues..sort()),
    );
  }

  void _addLessonFields(
    void Function(SemanticRequiredIdentity) add,
    String moduleId,
    String lessonId,
    Map<String, Object?> metadata,
    Map<String, Object?> lesson,
  ) {
    _addSimple(
      add,
      moduleId: moduleId,
      lessonId: lessonId,
      sourceAssetPath: coursePath,
      sourceObjectId: lessonId,
      fieldPath: 'title',
      contentKind: 'lesson',
      semanticType: 'lessonTitle',
      pedagogicalRole: 'lesson title',
      source: metadata['title'],
      reason: 'lesson metadata',
    );
    _addSimple(
      add,
      moduleId: moduleId,
      lessonId: lessonId,
      sourceAssetPath: coursePath,
      sourceObjectId: lessonId,
      fieldPath: 'description',
      contentKind: 'lesson',
      semanticType: 'lessonDescription',
      pedagogicalRole: 'lesson description',
      source: metadata['description'],
      reason: 'lesson metadata',
    );
    _addSimple(
      add,
      moduleId: moduleId,
      lessonId: lessonId,
      sourceAssetPath: coursePath,
      sourceObjectId: lessonId,
      fieldPath: 'communicativeOutcome',
      contentKind: 'lesson',
      semanticType: 'communicativeOutcome',
      pedagogicalRole: 'communicative outcome',
      source: lesson['communicativeOutcome'],
      reason: 'lesson metadata',
    );
    for (final rawObjective in lesson['objectives'] as List? ?? const []) {
      final objective = Map<String, Object?>.from(rawObjective as Map);
      _addSimple(
        add,
        moduleId: moduleId,
        lessonId: lessonId,
        sourceAssetPath: coursePath,
        sourceObjectId: '$lessonId.${objective['id']}',
        fieldPath: 'description',
        contentKind: 'lesson_objective',
        semanticType: 'lessonObjective',
        pedagogicalRole: 'lesson objective',
        source: objective['description'],
        reason: 'lesson objective',
      );
    }
  }

  void _collectReference(
    void Function(SemanticRequiredIdentity) add, {
    required String moduleId,
    required String lessonId,
    required ReusableDependency dependency,
    required List<String> unresolved,
  }) {
    final items = _readJsonList(
      _resolve('$rootPrefix${dependency.assetPath}'),
    ).where((item) => item['id'] == dependency.referenceId).toList();
    if (items.isEmpty) {
      unresolved.add(
        'missingDependency: ${dependency.assetPath} ${dependency.referenceId}',
      );
      return;
    }
    for (final item in items) {
      final id = item['id'] as String;
      switch (dependency.type) {
        case 'vocabulary':
          _addSimple(
            add,
            moduleId: moduleId,
            lessonId: lessonId,
            sourceAssetPath: dependency.assetPath,
            sourceObjectId: id,
            fieldPath: 'native_translation',
            contentKind: 'vocabulary',
            semanticType: 'vocabularyMeaning',
            pedagogicalRole: 'vocabulary meaning',
            source: item['native_translation'],
            reason: 'vocabulary',
          );
          _addSimple(
            add,
            moduleId: moduleId,
            lessonId: lessonId,
            sourceAssetPath: dependency.assetPath,
            sourceObjectId: id,
            fieldPath: 'notes',
            contentKind: 'vocabulary',
            semanticType: 'vocabularyUsageNote',
            pedagogicalRole: 'vocabulary usage note',
            source: item['notes'],
            reason: 'vocabulary',
          );
          _addPronunciation(
            add,
            moduleId: moduleId,
            lessonId: lessonId,
            contentId: id,
            directUnitId:
                item['pronunciationUnitId'] ?? item['pronunciation_unit_id'],
          );
        case 'grammar':
          _addSimple(
            add,
            moduleId: moduleId,
            lessonId: lessonId,
            sourceAssetPath: dependency.assetPath,
            sourceObjectId: id,
            fieldPath: 'title',
            contentKind: 'grammar',
            semanticType: 'grammarTitle',
            pedagogicalRole: 'grammar title',
            source: item['title'],
            reason: 'grammar',
          );
          _addSimple(
            add,
            moduleId: moduleId,
            lessonId: lessonId,
            sourceAssetPath: dependency.assetPath,
            sourceObjectId: id,
            fieldPath: 'explanation',
            contentKind: 'grammar',
            semanticType: 'grammarExplanation',
            pedagogicalRole: 'grammar explanation',
            source: item['explanation'],
            reason: 'grammar',
          );
        case 'dialogue':
          _addSimple(
            add,
            moduleId: moduleId,
            lessonId: lessonId,
            sourceAssetPath: dependency.assetPath,
            sourceObjectId: id,
            fieldPath: 'title',
            contentKind: 'dialogue',
            semanticType: 'dialogueTitle',
            pedagogicalRole: 'dialogue title',
            source: item['title'],
            reason: 'dialogue',
          );
          final lines = item['lines'] as List? ?? const [];
          for (var index = 0; index < lines.length; index += 1) {
            final line = Map<String, Object?>.from(lines[index] as Map);
            _addSimple(
              add,
              moduleId: moduleId,
              lessonId: lessonId,
              sourceAssetPath: dependency.assetPath,
              sourceObjectId: id,
              fieldPath: 'lines.$index.native_translation',
              contentKind: 'dialogue',
              semanticType: 'dialogueTranslation',
              pedagogicalRole: 'dialogue support',
              source: line['native_translation'],
              reason: 'dialogue',
            );
          }
        case 'reading':
          _addSimple(
            add,
            moduleId: moduleId,
            lessonId: lessonId,
            sourceAssetPath: dependency.assetPath,
            sourceObjectId: id,
            fieldPath: 'title',
            contentKind: 'reading',
            semanticType: 'readingTitle',
            pedagogicalRole: 'reading title',
            source: item['title'],
            reason: 'reading',
          );
          _addSimple(
            add,
            moduleId: moduleId,
            lessonId: lessonId,
            sourceAssetPath: dependency.assetPath,
            sourceObjectId: id,
            fieldPath: 'native_translation',
            contentKind: 'reading',
            semanticType: 'readingTranslation',
            pedagogicalRole: 'reading translation',
            source: item['native_translation'],
            reason: 'reading',
          );
        case 'exercise_template':
          _addSimple(
            add,
            moduleId: moduleId,
            lessonId: lessonId,
            sourceAssetPath: dependency.assetPath,
            sourceObjectId: id,
            fieldPath: 'prompt_template',
            contentKind: 'exercise_template',
            semanticType: 'exercisePrompt',
            pedagogicalRole: 'exercise prompt',
            source: item['prompt_template'],
            reason: 'exercise prompt',
          );
          for (final rawOption in item['answer_options'] as List? ?? const []) {
            final option = Map<String, Object?>.from(rawOption as Map);
            final label = option['label'];
            if (_isSupportAnswerOption(label)) {
              _addSimple(
                add,
                moduleId: moduleId,
                lessonId: lessonId,
                sourceAssetPath: dependency.assetPath,
                sourceObjectId: id,
                fieldPath: 'answer_options.${option['id']}.label',
                contentKind: 'exercise_template',
                semanticType: 'answerOptionLabel',
                ownership: 'mixedStructured',
                pedagogicalRole: 'answer option support label',
                source: label,
                reason: 'answer option labels',
              );
            }
          }
      }
    }
  }

  void _addPronunciation(
    void Function(SemanticRequiredIdentity) add, {
    required String moduleId,
    required String lessonId,
    required String contentId,
    required Object? directUnitId,
  }) {
    final unit = directUnitId is String
        ? pronunciationUnitsById[directUnitId]
        : pronunciationByContentId[contentId];
    if (unit == null) {
      return;
    }
    final unitId = unit['id'] as String;
    final hintSource =
        _pronunciationEnglishSource(unitId, unit, 'learnerHints') ??
        unit['targetOrthography'] as String? ??
        unitId;
    add(
      _identity(
        moduleId: moduleId,
        lessonIds: [lessonId],
        sourceAssetPath: pronunciationPath,
        sourceObjectId: unitId,
        fieldPath: 'localizedLearnerHints',
        contentKind: 'pronunciation_unit',
        semanticType: 'pronunciationHint',
        ownership: 'supportLanguageOwned',
        pedagogicalRole: 'pronunciation learner hint',
        englishSource: hintSource,
        protectedSpans: _pronunciationProtectedSpans(unit),
        reason: 'pronunciation hints',
        extractorLayer: 'pronunciation graph',
        proposedExtractionRule:
            'Include support-locale learner hint for each referenced PronunciationUnit.',
      ),
    );
    final explanation = _pronunciationEnglishSource(
      unitId,
      unit,
      'explanations',
    );
    if (explanation != null) {
      add(
        _identity(
          moduleId: moduleId,
          lessonIds: [lessonId],
          sourceAssetPath: pronunciationPath,
          sourceObjectId: unitId,
          fieldPath: 'explanations',
          contentKind: 'pronunciation_unit',
          semanticType: 'pronunciationExplanation',
          ownership: 'supportLanguageOwned',
          pedagogicalRole: 'pronunciation explanation',
          englishSource: explanation,
          protectedSpans: _pronunciationProtectedSpans(unit),
          reason: 'pronunciation explanations',
          extractorLayer: 'pronunciation graph',
          proposedExtractionRule:
              'Include support-locale pronunciation explanation when English source exists.',
        ),
      );
    }
    for (final ruleId in unit['readingRuleIds'] as List? ?? const []) {
      _addReadingRule(
        add,
        moduleId: moduleId,
        lessonId: lessonId,
        ruleId: '$ruleId',
      );
    }
  }

  void _addReadingRule(
    void Function(SemanticRequiredIdentity) add, {
    required String moduleId,
    required String lessonId,
    required String ruleId,
  }) {
    final localization = pronunciationLocalizationsById[ruleId];
    final rule = readingRulesById[ruleId];
    if (localization == null || rule == null) {
      return;
    }
    const fields = <String, String>{
      'titles': 'readingRuleTitle',
      'shortExplanations': 'readingRuleShortExplanation',
      'detailedExplanations': 'readingRuleDetailedExplanation',
      'articulationHints': 'articulationHint',
      'commonMistakes': 'commonMistakeExplanation',
      'contrastNotes': 'contrastNote',
    };
    for (final entry in fields.entries) {
      final source = _localizedMap(localization[entry.key])['en'];
      if (source == null || source.trim().isEmpty) {
        continue;
      }
      add(
        _identity(
          moduleId: moduleId,
          lessonIds: [lessonId],
          sourceAssetPath: pronunciationPath,
          sourceObjectId: ruleId,
          fieldPath: entry.key,
          contentKind: 'reading_rule',
          semanticType: entry.value,
          ownership: 'supportLanguageOwned',
          pedagogicalRole: 'reading rule localization',
          englishSource: source,
          protectedSpans: [
            ProtectedSpanSpec(
              id: 'pattern',
              type: 'targetText',
              text: '${rule['orthographicPattern']}',
            ),
            if (rule['ipa'] is String)
              ProtectedSpanSpec(id: 'ipa', type: 'ipa', text: '${rule['ipa']}'),
          ],
          reason: 'ReadingRule localization',
          extractorLayer: 'reading rule graph',
          proposedExtractionRule:
              'Include learner-facing ReadingRule localized prose fields.',
        ),
      );
    }
    final presentations = localization['graphemePresentations'];
    if (presentations is Map && presentations['en'] is Map) {
      final en = Map<String, Object?>.from(presentations['en'] as Map);
      for (final field in [
        'canonicalDescription',
        'confusableDescription',
        'accessibilityDescription',
      ]) {
        final source = en[field];
        _addSimple(
          add,
          moduleId: moduleId,
          lessonId: lessonId,
          sourceAssetPath: pronunciationPath,
          sourceObjectId: ruleId,
          fieldPath: 'graphemePresentations.$field',
          contentKind: 'reading_rule',
          semanticType: field == 'accessibilityDescription'
              ? 'accessibilityDescription'
              : 'graphemeExplanation',
          pedagogicalRole: 'grapheme presentation',
          source: source,
          protectedSpans: [
            ProtectedSpanSpec(
              id: 'pattern',
              type: 'targetText',
              text: '${rule['orthographicPattern']}',
            ),
          ],
          reason: 'WritingUnit/grapheme explanations',
        );
      }
    }
  }

  void _addSimple(
    void Function(SemanticRequiredIdentity) add, {
    required String moduleId,
    required String lessonId,
    required String sourceAssetPath,
    required String sourceObjectId,
    required String fieldPath,
    required String contentKind,
    required String semanticType,
    required String pedagogicalRole,
    required Object? source,
    required String reason,
    String ownership = 'supportLanguageOwned',
    List<ProtectedSpanSpec> protectedSpans = const [],
  }) {
    if (source is! String || source.trim().isEmpty) {
      return;
    }
    add(
      _identity(
        moduleId: moduleId,
        lessonIds: [lessonId],
        sourceAssetPath: sourceAssetPath,
        sourceObjectId: sourceObjectId,
        fieldPath: fieldPath,
        contentKind: contentKind,
        semanticType: semanticType,
        ownership: ownership,
        pedagogicalRole: pedagogicalRole,
        englishSource: source,
        protectedSpans: protectedSpans.isEmpty
            ? _protectedSpans(source)
            : protectedSpans,
        reason: reason,
        extractorLayer: contentKind,
        proposedExtractionRule:
            'Include learner-facing $contentKind $fieldPath when referenced by canonical module graph.',
      ),
    );
  }

  SemanticRequiredIdentity _identity({
    required String moduleId,
    required List<String> lessonIds,
    required String sourceAssetPath,
    required String sourceObjectId,
    required String fieldPath,
    required String contentKind,
    required String semanticType,
    required String ownership,
    required String pedagogicalRole,
    required String englishSource,
    required String reason,
    required String extractorLayer,
    required String proposedExtractionRule,
    List<ProtectedSpanSpec> protectedSpans = const [],
  }) {
    final stableIdentity = '$sourceObjectId|$fieldPath|$semanticType';
    return SemanticRequiredIdentity(
      stableIdentity: stableIdentity,
      sourceAssetPath: sourceAssetPath,
      sourceObjectId: sourceObjectId,
      fieldPath: fieldPath,
      contentKind: contentKind,
      semanticType: semanticType,
      ownership: ownership,
      moduleId: moduleId,
      lessonIds: List.unmodifiable(lessonIds),
      pedagogicalRole: pedagogicalRole,
      englishSource: englishSource,
      protectedSpans: protectedSpans,
      requiredness: 'requiredWhenReferenced',
      sourceLanguage: 'en',
      targetLanguage: 'es',
      reason: reason,
      extractorLayer: extractorLayer,
      proposedExtractionRule: proposedExtractionRule,
    );
  }

  Map<String, Object?> _module(String moduleId) {
    return (course['modules'] as List? ?? const [])
        .map((raw) => Map<String, Object?>.from(raw as Map))
        .firstWhere((module) => module['id'] == moduleId);
  }

  String? _pronunciationEnglishSource(
    String id,
    Map<String, Object?> unit,
    String field,
  ) {
    final localization = pronunciationLocalizationsById[id];
    if (localization != null) {
      final value = _localizedMap(localization[field])['en'];
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    }
    if (field == 'learnerHints') {
      return _localizedMap(unit['localizedLearnerHints'])['en'];
    }
    return null;
  }
}

List<ProtectedSpanSpec> _pronunciationProtectedSpans(
  Map<String, Object?> unit,
) {
  return [
    if (unit['targetOrthography'] is String)
      ProtectedSpanSpec(
        id: 'target',
        type: 'targetText',
        text: '${unit['targetOrthography']}',
      ),
    if (unit['ipa'] is String)
      ProtectedSpanSpec(id: 'ipa', type: 'ipa', text: '${unit['ipa']}'),
  ];
}

bool _isSupportAnswerOption(Object? label) {
  if (label is! String || label.trim().isEmpty) {
    return false;
  }
  if (RegExp(r'^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ¿¡.,!?\s]+$').hasMatch(label) &&
      !label.contains(' ')) {
    final lower = label.toLowerCase();
    const targetWords = {
      'hola',
      'adiós',
      'adios',
      'gracias',
      'perdón',
      'perdon',
      'repite',
      'sí',
      'si',
      'no',
      'h',
      'l',
      'o',
    };
    if (targetWords.contains(lower)) {
      return false;
    }
  }
  return true;
}

Map<String, String> _localizedMap(Object? value) {
  if (value is! Map) {
    return const {};
  }
  return {
    for (final entry in value.entries)
      if (entry.value is String) '${entry.key}': entry.value as String,
  };
}

List<ProtectedSpanSpec> _protectedSpans(String source) {
  final spans = <ProtectedSpanSpec>[];
  var index = 0;
  for (final match in RegExp(
    r'\{[^}]+\}|[¿¡]?[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+(?:\s+de\s+[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)?',
  ).allMatches(source)) {
    final text = match.group(0)!;
    if (!_looksSpanishOrPlaceholder(text)) {
      continue;
    }
    index += 1;
    spans.add(
      ProtectedSpanSpec(
        id: 'span_$index',
        type: text.startsWith('{') ? 'placeholder' : 'targetText',
        text: text,
      ),
    );
  }
  return List.unmodifiable(spans);
}

bool _looksSpanishOrPlaceholder(String text) {
  if (text.startsWith('{')) {
    return true;
  }
  final lower = text.toLowerCase();
  const spanishTerms = {
    'hola',
    'adiós',
    'adios',
    'hasta',
    'luego',
    'gracias',
    'por',
    'favor',
    'perdón',
    'perdon',
    'de nada',
    'no entiendo',
    'repite',
    'más despacio',
    'mas despacio',
    'buenos días',
    'buenos dias',
    'buenas tardes',
    'buenas noches',
    'ana',
    'luis',
    'hache',
  };
  return spanishTerms.contains(lower) ||
      RegExp(r'[áéíóúñüÁÉÍÓÚÑÜ¿¡]').hasMatch(text);
}

Map<String, Object?> _readJsonObject(String path) {
  final raw = jsonDecode(File(path).readAsStringSync());
  if (raw is! Map) {
    throw FormatException('Expected JSON object at $path');
  }
  return Map<String, Object?>.from(raw);
}

List<Map<String, Object?>> _readJsonList(String path) {
  final raw = jsonDecode(File(path).readAsStringSync());
  if (raw is! List) {
    throw FormatException('Expected JSON list at $path');
  }
  return raw.map((item) => Map<String, Object?>.from(item as Map)).toList();
}

String _resolve(String path) {
  if (File(path).existsSync()) {
    return path;
  }
  if (File('app/$path').existsSync()) {
    return 'app/$path';
  }
  return path;
}
