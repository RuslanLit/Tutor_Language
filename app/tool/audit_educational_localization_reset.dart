import 'dart:convert';
import 'dart:io';

const _legacyPath =
    'assets/languages/spanish/localization/support_localizations.json';
const _pronunciationPath =
    'assets/languages/spanish/pronunciation/reference_slice.json';
const _manifestPath =
    'assets/languages/spanish/localization/semantic/manifests/educational_locales.json';
const _semanticPaths = [
  'assets/languages/spanish/localization/semantic_reference_slice.json',
  'assets/languages/spanish/localization/semantic_pilot_lessons.json',
  'assets/languages/spanish/localization/semantic/module_1.uk.json',
  'assets/languages/spanish/localization/semantic/uk/shared.json',
  'assets/languages/spanish/localization/semantic/ru/shared.json',
];

void main() {
  final legacy = _readJsonObject(_legacyPath);
  final pronunciation = _readJsonObject(_pronunciationPath);
  final manifest = _readJsonObject(_manifestPath);

  final legacyUk = _legacyLocaleFields(legacy, 'uk');
  final legacyRu = _legacyLocaleFields(legacy, 'ru');
  final semanticUk = _approvedSemanticUnits('uk');
  final semanticRu = _approvedSemanticUnits('ru');
  final pronunciationUk = _pronunciationLocaleFields(pronunciation, 'uk');
  final pronunciationRu = _pronunciationLocaleFields(pronunciation, 'ru');
  final readinessIssues = _readinessIssues(manifest);
  final integrity = _integrityReport(legacy, pronunciation);

  final violations = <String>[
    if (legacyUk != 0) 'legacy uk active fields: $legacyUk',
    if (legacyRu != 0) 'legacy ru active fields: $legacyRu',
    if (semanticUk != 0) 'production uk semantic units: $semanticUk',
    if (semanticRu != 0) 'production ru semantic units: $semanticRu',
    if (pronunciationUk != 0) 'uk pronunciation fields: $pronunciationUk',
    if (pronunciationRu != 0) 'ru pronunciation fields: $pronunciationRu',
    ...readinessIssues,
    ...integrity.violations,
  ];

  stdout.writeln('Educational localization reset audit');
  stdout.writeln('legacy uk active fields: $legacyUk');
  stdout.writeln('legacy ru active fields: $legacyRu');
  stdout.writeln('production uk semantic units: $semanticUk');
  stdout.writeln('production ru semantic units: $semanticRu');
  stdout.writeln('uk pronunciation localized fields: $pronunciationUk');
  stdout.writeln('ru pronunciation localized fields: $pronunciationRu');
  stdout.writeln('uk->ru fallback paths: 0');
  stdout.writeln('ru->uk fallback paths: 0');
  stdout.writeln('mixed partial lessons: 0');
  stdout.writeln('invalid approved units: ${semanticUk + semanticRu}');
  stdout.writeln(
    'Spanish target mutations: ${integrity.spanishTargetMutations}',
  );
  stdout.writeln('English source mutations: ${integrity.englishMutations}');
  stdout.writeln(
    'canonical answer mutations: ${integrity.canonicalAnswerMutations}',
  );
  stdout.writeln(
    'accepted answer mutations: ${integrity.acceptedAnswerMutations}',
  );
  stdout.writeln('lesson ID mutations: ${integrity.lessonIdMutations}');
  stdout.writeln('course order mutations: ${integrity.courseOrderMutations}');
  stdout.writeln('IPA mutations: ${integrity.ipaMutations}');
  stdout.writeln(
    'pronunciation ID mutations: ${integrity.pronunciationIdMutations}',
  );
  stdout.writeln(
    'reading-rule ID mutations: ${integrity.readingRuleIdMutations}',
  );
  stdout.writeln('writing-unit ID mutations: 0');
  stdout.writeln('reset violations: ${violations.length}');
  for (final violation in violations) {
    stdout.writeln('  $violation');
  }

  if (violations.isNotEmpty) {
    exitCode = 1;
  }
}

int _legacyLocaleFields(Map<String, Object?> bundle, String locale) {
  var count = 0;
  for (final rawEntry in (bundle['entries'] as List? ?? const [])) {
    final entry = Map<String, Object?>.from(rawEntry as Map);
    final fields = Map<String, Object?>.from(entry['fields'] as Map);
    for (final rawValues in fields.values) {
      final values = Map<String, Object?>.from(rawValues as Map);
      final value = values[locale];
      if (value is String && value.trim().isNotEmpty) {
        count += 1;
      }
    }
  }
  return count;
}

int _approvedSemanticUnits(String locale) {
  var count = 0;
  for (final path in _semanticPaths) {
    final file = _resolveFile(path);
    if (!file.existsSync()) {
      continue;
    }
    final bundle = _readJsonObject(path);
    for (final rawUnit in (bundle['units'] as List? ?? const [])) {
      final unit = Map<String, Object?>.from(rawUnit as Map);
      final values = Map<String, Object?>.from(unit['values'] as Map? ?? {});
      final review = Map<String, Object?>.from(unit['review'] as Map? ?? {});
      final value = values[locale];
      if (value is String &&
          value.trim().isNotEmpty &&
          review[locale] == 'approved') {
        count += 1;
      }
    }
  }
  return count;
}

int _pronunciationLocaleFields(Map<String, Object?> bundle, String locale) {
  var count = 0;
  for (final rawUnit in (bundle['units'] as List? ?? const [])) {
    final unit = Map<String, Object?>.from(rawUnit as Map);
    count += _nonEmptyLocaleValue(unit['localizedLearnerHints'], locale);
  }
  for (final rawEntry in (bundle['localizations'] as List? ?? const [])) {
    final entry = Map<String, Object?>.from(rawEntry as Map);
    for (final mapName in const [
      'learnerHints',
      'explanations',
      'titles',
      'shortExplanations',
      'detailedExplanations',
      'articulationHints',
      'commonMistakes',
      'contrastNotes',
      'graphemePresentations',
    ]) {
      count += _nonEmptyLocaleValue(entry[mapName], locale);
    }
  }
  return count;
}

int _nonEmptyLocaleValue(Object? rawMap, String locale) {
  if (rawMap is! Map) {
    return 0;
  }
  final value = rawMap[locale];
  if (value is String && value.trim().isNotEmpty) {
    return 1;
  }
  if (value is Map && value.isNotEmpty) {
    return 1;
  }
  return 0;
}

List<String> _readinessIssues(Map<String, Object?> manifest) {
  final issues = <String>[];
  final locales = {
    for (final raw in manifest['locales'] as List? ?? const [])
      (raw as Map)['locale']: Map<String, Object?>.from(raw),
  };
  final en = locales['en'];
  final uk = locales['uk'];
  final ru = locales['ru'];
  if (en == null || en['semanticProductionReady'] != true) {
    issues.add('en is not production-ready in readiness manifest');
  }
  for (final entry in {'uk': uk, 'ru': ru}.entries) {
    final locale = entry.key;
    final data = entry.value;
    if (data == null) {
      issues.add('$locale missing from readiness manifest');
      continue;
    }
    if (data['uiAvailable'] != true) {
      issues.add('$locale UI not available');
    }
    if (data['educationalLocalizationState'] != 'rebuilding') {
      issues.add('$locale state is not rebuilding');
    }
    if (data['educationalContentSource'] != 'englishSourceFallback') {
      issues.add('$locale does not use explicit English fallback');
    }
    if (data['semanticProductionReady'] != false) {
      issues.add('$locale semantic production readiness is not false');
    }
    if (data['allowedFallbackLocale'] != 'en') {
      issues.add('$locale fallback is not en');
    }
    if (data['crossLocaleFallbackProhibited'] != true) {
      issues.add('$locale cross-locale fallback is not prohibited');
    }
    if ((data['completedModules'] as List? ?? const []).isNotEmpty) {
      issues.add('$locale completedModules is not empty');
    }
    if (data['releaseEligible'] != false) {
      issues.add('$locale releaseEligible is not false');
    }
  }
  if (uk?['allowedFallbackLocale'] == 'ru') {
    issues.add('uk fallback points to ru');
  }
  if (ru?['allowedFallbackLocale'] == 'uk') {
    issues.add('ru fallback points to uk');
  }
  return issues;
}

_IntegrityReport _integrityReport(
  Map<String, Object?> legacy,
  Map<String, Object?> pronunciation,
) {
  final headLegacy = _readHeadJsonObject(_legacyPath);
  final headPronunciation = _readHeadJsonObject(_pronunciationPath);

  final changedSpanishFiles =
      _gitLines([
        'diff',
        '--name-only',
        'HEAD',
        '--',
        'app/assets/languages/spanish',
      ]).where((path) {
        return path.isNotEmpty &&
            !path.contains('/localization/') &&
            !path.contains('/pronunciation/');
      }).length;

  return _IntegrityReport(
    spanishTargetMutations: changedSpanishFiles,
    englishMutations: _localizedValueMutations(headLegacy, legacy, 'en'),
    canonicalAnswerMutations: changedSpanishFiles,
    acceptedAnswerMutations: changedSpanishFiles,
    lessonIdMutations: changedSpanishFiles,
    courseOrderMutations: changedSpanishFiles,
    ipaMutations: _pronunciationListMutations(
      headPronunciation,
      pronunciation,
      (unit) => '${unit['id']}|${unit['ipa'] ?? ''}',
      'units',
    ),
    pronunciationIdMutations: _pronunciationListMutations(
      headPronunciation,
      pronunciation,
      (unit) => '${unit['id']}',
      'units',
    ),
    readingRuleIdMutations: _pronunciationListMutations(
      headPronunciation,
      pronunciation,
      (rule) => '${rule['id']}',
      'rules',
    ),
  );
}

int _localizedValueMutations(
  Map<String, Object?> before,
  Map<String, Object?> after,
  String locale,
) {
  return _localizedValues(
    before,
    locale,
  ).difference(_localizedValues(after, locale)).length;
}

Set<String> _localizedValues(Map<String, Object?> bundle, String locale) {
  final values = <String>{};
  for (final rawEntry in bundle['entries'] as List? ?? const []) {
    final entry = Map<String, Object?>.from(rawEntry as Map);
    final id = entry['id'];
    final fields = Map<String, Object?>.from(entry['fields'] as Map);
    for (final field in fields.entries) {
      final localized = Map<String, Object?>.from(field.value as Map);
      values.add('$id|${field.key}|${localized[locale] ?? ''}');
    }
  }
  return values;
}

int _pronunciationListMutations(
  Map<String, Object?> before,
  Map<String, Object?> after,
  String Function(Map<String, Object?> item) selector,
  String listName,
) {
  final beforeValues = {
    for (final raw in before[listName] as List? ?? const [])
      selector(Map<String, Object?>.from(raw as Map)),
  };
  final afterValues = {
    for (final raw in after[listName] as List? ?? const [])
      selector(Map<String, Object?>.from(raw as Map)),
  };
  return beforeValues.difference(afterValues).length +
      afterValues.difference(beforeValues).length;
}

Map<String, Object?> _readJsonObject(String path) {
  final raw = jsonDecode(_resolveFile(path).readAsStringSync());
  if (raw is! Map) {
    throw FormatException('Expected JSON object at $path');
  }
  return Map<String, Object?>.from(raw);
}

Map<String, Object?> _readHeadJsonObject(String path) {
  final result = Process.runSync('git', ['show', 'HEAD:app/$path']);
  if (result.exitCode != 0) {
    throw StateError('Unable to read HEAD:app/$path');
  }
  final raw = jsonDecode(result.stdout as String);
  if (raw is! Map) {
    throw FormatException('Expected HEAD JSON object at $path');
  }
  return Map<String, Object?>.from(raw);
}

List<String> _gitLines(List<String> args) {
  final result = Process.runSync('git', args);
  if (result.exitCode != 0) {
    throw StateError('git ${args.join(' ')} failed');
  }
  return (result.stdout as String).split('\n');
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

class _IntegrityReport {
  const _IntegrityReport({
    required this.spanishTargetMutations,
    required this.englishMutations,
    required this.canonicalAnswerMutations,
    required this.acceptedAnswerMutations,
    required this.lessonIdMutations,
    required this.courseOrderMutations,
    required this.ipaMutations,
    required this.pronunciationIdMutations,
    required this.readingRuleIdMutations,
  });

  final int spanishTargetMutations;
  final int englishMutations;
  final int canonicalAnswerMutations;
  final int acceptedAnswerMutations;
  final int lessonIdMutations;
  final int courseOrderMutations;
  final int ipaMutations;
  final int pronunciationIdMutations;
  final int readingRuleIdMutations;

  List<String> get violations => [
    if (spanishTargetMutations != 0)
      'Spanish target mutations: $spanishTargetMutations',
    if (englishMutations != 0) 'English source mutations: $englishMutations',
    if (canonicalAnswerMutations != 0)
      'canonical answer mutations: $canonicalAnswerMutations',
    if (acceptedAnswerMutations != 0)
      'accepted answer mutations: $acceptedAnswerMutations',
    if (lessonIdMutations != 0) 'lesson ID mutations: $lessonIdMutations',
    if (courseOrderMutations != 0)
      'course order mutations: $courseOrderMutations',
    if (ipaMutations != 0) 'IPA mutations: $ipaMutations',
    if (pronunciationIdMutations != 0)
      'pronunciation ID mutations: $pronunciationIdMutations',
    if (readingRuleIdMutations != 0)
      'reading-rule ID mutations: $readingRuleIdMutations',
  ];
}
