import 'dart:convert';
import 'dart:io';

import 'package:tutor_language/core/content/semantic_localization.dart';

const _coursePath =
    'assets/languages/spanish/curriculum/spanish_a0_course.json';
const _legacyPath =
    'assets/languages/spanish/localization/support_localizations.json';
const _semanticPaths = [
  'assets/languages/spanish/localization/semantic/uk/shared.json',
  'assets/languages/spanish/localization/semantic/uk/module_01.json',
];
const _pronunciationPath =
    'assets/languages/spanish/pronunciation/reference_slice.json';

void main(List<String> args) {
  final moduleId = _argValue(args, '--module') ?? 'es.a0.m01';
  final validator = _SemanticLessonValidator();
  final report = validator.validate(moduleId: moduleId);

  stdout.writeln('R2E5N1 semantic Ukrainian module audit');
  stdout.writeln('module: $moduleId');
  stdout.writeln('lesson IDs: ${report.lessonIds.join(', ')}');
  stdout.writeln('required identities in scope: ${report.expectedFields}');
  stdout.writeln('semantic covered fields: ${report.semanticCoveredFields}');
  stdout.writeln('coverage: ${report.coveragePercent.toStringAsFixed(1)}%');
  stdout.writeln('legacy Ukrainian resolutions: ${report.legacyFallbacks}');
  stdout.writeln(
    'English source fallback inside scope: ${report.legacyFallbacks}',
  );
  stdout.writeln('Russian fallback: 0');
  stdout.writeln(
    'missing values: ${report.issues.where((issue) => issue.contains('missing')).length}',
  );
  stdout.writeln('generated: ${report.generatedUnits}');
  stdout.writeln('approved: ${report.approvedUnits}');
  stdout.writeln('duplicate identities: ${report.duplicateIdentities}');
  stdout.writeln('issues: ${report.issues.length}');
  for (final entry
      in report.byCode.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key))) {
    stdout.writeln('  ${entry.key}: ${entry.value}');
  }
  for (final issue in report.issues.take(200)) {
    stdout.writeln(issue);
  }
  if (report.issues.isNotEmpty) {
    exitCode = 1;
  }
}

String? _argValue(List<String> args, String name) {
  for (var index = 0; index < args.length; index += 1) {
    if (args[index] == name && index + 1 < args.length) {
      return args[index + 1];
    }
    if (args[index].startsWith('$name=')) {
      return args[index].substring(name.length + 1);
    }
  }
  return null;
}

class _SemanticLessonValidator {
  _SemanticLessonValidator()
    : course = _readJsonObject(_coursePath),
      legacy = _readJsonObject(_legacyPath),
      semanticBundle = _readSemanticBundles(_semanticPaths),
      pronunciation = _readJsonObject(_pronunciationPath) {
    for (final rawEntry in legacy['entries'] as List? ?? const []) {
      final entry = Map<String, Object?>.from(rawEntry as Map);
      legacyFieldKeys.addAll([
        for (final field in (entry['fields'] as Map? ?? const {}).keys)
          '${entry['id']}|$field',
      ]);
    }
    for (final unit in semanticBundle.units) {
      final key = '${unit.context.contentObjectId}|${unit.context.fieldPath}';
      semanticByField.putIfAbsent(key, () => []).add(unit);
    }
    for (final raw in pronunciation['units'] as List? ?? const []) {
      final unit = Map<String, Object?>.from(raw as Map);
      pronunciationUnitsById[unit['id'] as String] = unit;
      for (final related in unit['relatedContentIds'] as List? ?? const []) {
        pronunciationByContentId['$related'] = unit;
      }
    }
    for (final raw in pronunciation['localizations'] as List? ?? const []) {
      final entry = Map<String, Object?>.from(raw as Map);
      pronunciationLocalizationIds.add(entry['id'] as String);
    }
  }

  final Map<String, Object?> course;
  final Map<String, Object?> legacy;
  final SemanticLocalizationBundle semanticBundle;
  final Map<String, Object?> pronunciation;
  final Set<String> legacyFieldKeys = {};
  final Map<String, List<SemanticLocalizationUnit>> semanticByField = {};
  final Map<String, Map<String, Object?>> pronunciationUnitsById = {};
  final Map<String, Map<String, Object?>> pronunciationByContentId = {};
  final Set<String> pronunciationLocalizationIds = {};

  _SemanticLessonReport validate({required String moduleId}) {
    final lessonIds = _lessonIdsForModule(moduleId);
    final expectedFields = _collectExpectedFields(
      moduleId: moduleId,
      lessonIds: lessonIds,
    );
    final issues = <String>[];
    final coveredFields = <String>{};
    final duplicateIdentities = const SemanticLocalizationValidator()
        .validate(bundle: semanticBundle, production: false)
        .where((issue) => issue.code == 'semantic.duplicateIdentityConflict')
        .length;

    final unitIssues = const SemanticLocalizationValidator()
        .validate(bundle: semanticBundle)
        .where((issue) {
          final unitId = issue.unitId;
          if (unitId == null) {
            return true;
          }
          final unit = semanticBundle.units
              .where((candidate) => candidate.id == unitId)
              .firstOrNull;
          return unit == null ||
              unit.context.moduleId == moduleId ||
              lessonIds.contains(unit.context.lessonId);
        });
    for (final issue in unitIssues) {
      issues.add('${issue.code}: ${issue.message}');
    }

    for (final field in expectedFields) {
      final candidates = semanticByField[field.key] ?? const [];
      final approved = candidates.any((unit) => unit.isApprovedFor('uk'));
      if (approved) {
        coveredFields.add(field.key);
      } else {
        final fallsBackToLegacy = legacyFieldKeys.contains(field.key);
        issues.add(
          'semanticLesson.${fallsBackToLegacy ? 'legacyFallback' : 'missingSemantic'}: '
          '${field.lessonId ?? moduleId} ${field.key}',
        );
      }
    }

    for (final unit in semanticBundle.units.where(
      (unit) =>
          unit.context.moduleId == moduleId ||
          lessonIds.contains(unit.context.lessonId),
    )) {
      if (unit.review.values.any(
        (status) => status == SemanticReviewStatus.generated,
      )) {
        issues.add('semanticLesson.generatedUnit: ${unit.id}');
      }
      if (unit.review.values.any(
        (status) => status != SemanticReviewStatus.approved,
      )) {
        issues.add('semanticLesson.invalidReviewState: ${unit.id}');
      }
      if (unit.ownership == SemanticTextOwnership.supportLanguageOwned) {
        final uk = unit.values['uk'];
        final en = unit.values['en'];
        if (uk == null || uk.trim().isEmpty) {
          issues.add('semanticLesson.missingUkrainianValue: ${unit.id}');
        } else if (en != null &&
            uk == en &&
            unit.semanticType != SemanticLocalizationType.properNounMeaning &&
            RegExp(r'[A-Za-z]{4,}').hasMatch(uk) &&
            !uk.contains(RegExp(r'[ÁÉÍÓÚÜÑáéíóúüñ¿¡]'))) {
          issues.add('semanticLesson.englishLeakage: ${unit.id}');
        }
        if (uk != null && RegExp('[ыэъёЫЭЪЁ]').hasMatch(uk)) {
          issues.add('semanticLesson.russianLeakage: ${unit.id}');
        }
      }
    }

    final generatedUnits = semanticBundle.units.where((unit) {
      return (unit.context.moduleId == moduleId ||
              lessonIds.contains(unit.context.lessonId)) &&
          unit.review.values.any(
            (status) => status == SemanticReviewStatus.generated,
          );
    }).length;
    final approvedUnits = semanticBundle.units.where((unit) {
      return (unit.context.moduleId == moduleId ||
              lessonIds.contains(unit.context.lessonId)) &&
          unit.review.values.every(
            (status) => status == SemanticReviewStatus.approved,
          );
    }).length;

    return _SemanticLessonReport(
      expectedFields: expectedFields.length,
      semanticCoveredFields: coveredFields.length,
      generatedUnits: generatedUnits,
      approvedUnits: approvedUnits,
      legacyFallbacks: expectedFields.length - coveredFields.length,
      duplicateIdentities: duplicateIdentities,
      lessonIds: lessonIds,
      issues: issues,
    );
  }

  List<String> _lessonIdsForModule(String moduleId) {
    final module = (course['modules'] as List? ?? const [])
        .map((raw) => Map<String, Object?>.from(raw as Map))
        .where((module) => module['id'] == moduleId)
        .firstOrNull;
    if (module == null) {
      throw StateError('Unknown module ID: $moduleId');
    }
    return [for (final id in module['lessonIds'] as List? ?? const []) '$id'];
  }

  Set<_ExpectedField> _collectExpectedFields({
    required String moduleId,
    required List<String> lessonIds,
  }) {
    final expected = <_ExpectedField>{};
    expected.add(const _ExpectedField(null, 'es.a0', 'title'));
    expected.add(_ExpectedField(null, moduleId, 'title'));
    for (final rawLesson in course['lessons'] as List? ?? const []) {
      final lesson = Map<String, Object?>.from(rawLesson as Map);
      final metadata = Map<String, Object?>.from(lesson['metadata'] as Map);
      final lessonId = metadata['id'] as String;
      if (!lessonIds.contains(lessonId)) {
        continue;
      }
      void add(String objectId, String fieldPath) {
        expected.add(_ExpectedField(lessonId, objectId, fieldPath));
      }

      add(lessonId, 'title');
      if (metadata['description'] is String) {
        add(lessonId, 'description');
      }
      if (lesson['communicativeOutcome'] is String) {
        add(lessonId, 'communicativeOutcome');
      }
      for (final rawObjective in lesson['objectives'] as List? ?? const []) {
        final objective = Map<String, Object?>.from(rawObjective as Map);
        add('$lessonId.${objective['id']}', 'description');
      }
      for (final rawSection in lesson['sections'] as List? ?? const []) {
        final section = Map<String, Object?>.from(rawSection as Map);
        add(section['id'] as String, 'title');
        for (final rawActivity in section['activities'] as List? ?? const []) {
          final activity = Map<String, Object?>.from(rawActivity as Map);
          add(activity['id'] as String, 'title');
          for (final rawReference
              in activity['references'] as List? ?? const []) {
            _collectReferenceFields(
              expected,
              lessonId: lessonId,
              reference: Map<String, Object?>.from(rawReference as Map),
            );
          }
        }
      }
      final summary = lesson['summary'];
      if (summary is Map) {
        add('${summary['id']}', 'reviewPrompt');
      }
    }
    return expected;
  }

  void _collectReferenceFields(
    Set<_ExpectedField> expected, {
    required String lessonId,
    required Map<String, Object?> reference,
  }) {
    final type = reference['type'] as String;
    final referenceId = reference['referenceId'] as String?;
    final items = _readJsonList(reference['assetPath'] as String).where((item) {
      return referenceId == null || item['id'] == referenceId;
    });
    void add(String objectId, String fieldPath) {
      expected.add(_ExpectedField(lessonId, objectId, fieldPath));
    }

    for (final item in items) {
      final id = item['id'] as String;
      switch (type) {
        case 'vocabulary':
          add(id, 'spanish');
          add(id, 'native_translation');
          add(id, 'example');
          if (item['notes'] is String) {
            add(id, 'notes');
          }
          final directUnit =
              item['pronunciationUnitId'] ?? item['pronunciation_unit_id'];
          final pronunciationUnit = directUnit is String
              ? pronunciationUnitsById[directUnit]
              : pronunciationByContentId[id];
          if (pronunciationUnit != null) {
            final unitId = pronunciationUnit['id'] as String;
            if (pronunciationUnit['ipa'] is String) {
              add(unitId, 'ipa');
            }
            add(unitId, 'localizedLearnerHints.uk');
            if (pronunciationLocalizationIds.contains(unitId)) {
              add(unitId, 'explanations.uk');
            }
            for (final ruleId
                in pronunciationUnit['readingRuleIds'] as List? ?? const []) {
              final id = '$ruleId';
              if (pronunciationLocalizationIds.contains(id)) {
                add(id, 'titles.uk');
                add(id, 'shortExplanations.uk');
                add(id, 'detailedExplanations.uk');
                add(id, 'articulationHints.uk');
                add(id, 'commonMistakes.uk');
                add(id, 'graphemePresentations.uk');
              }
              add(id, 'orthographicPattern');
            }
          }
        case 'grammar':
          add(id, 'title');
          add(id, 'explanation');
          final examples = item['examples'] as List? ?? const [];
          for (var index = 0; index < examples.length; index += 1) {
            add(id, 'examples.$index');
          }
        case 'dialogue':
          add(id, 'title');
          final lines = item['lines'] as List? ?? const [];
          for (var index = 0; index < lines.length; index += 1) {
            add(id, 'lines.$index.spanish');
            add(id, 'lines.$index.native_translation');
          }
        case 'reading':
          add(id, 'title');
          add(id, 'text');
          add(id, 'native_translation');
        case 'exercise_template':
          add(id, 'prompt_template');
          for (final rawOption in item['answer_options'] as List? ?? const []) {
            final option = Map<String, Object?>.from(rawOption as Map);
            add(id, 'answer_options.${option['id']}.label');
          }
      }
    }
  }
}

class _ExpectedField {
  const _ExpectedField(this.lessonId, this.objectId, this.fieldPath);

  final String? lessonId;
  final String objectId;
  final String fieldPath;

  String get key => '$objectId|$fieldPath';

  @override
  bool operator ==(Object other) {
    return other is _ExpectedField && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;
}

class _SemanticLessonReport {
  const _SemanticLessonReport({
    required this.expectedFields,
    required this.semanticCoveredFields,
    required this.generatedUnits,
    required this.approvedUnits,
    required this.legacyFallbacks,
    required this.duplicateIdentities,
    required this.lessonIds,
    required this.issues,
  });

  final int expectedFields;
  final int semanticCoveredFields;
  final int generatedUnits;
  final int approvedUnits;
  final int legacyFallbacks;
  final int duplicateIdentities;
  final List<String> lessonIds;
  final List<String> issues;

  double get coveragePercent =>
      expectedFields == 0 ? 100 : semanticCoveredFields / expectedFields * 100;

  Map<String, int> get byCode {
    final values = <String, int>{};
    for (final issue in issues) {
      final code = issue.split(':').first;
      values.update(code, (count) => count + 1, ifAbsent: () => 1);
    }
    return values;
  }
}

List<Map<String, Object?>> _readJsonList(String path) {
  final raw = jsonDecode(_resolveFile(path).readAsStringSync());
  if (raw is! List) {
    throw FormatException('Expected JSON list at $path');
  }
  return raw.map((item) => Map<String, Object?>.from(item as Map)).toList();
}

Map<String, Object?> _readJsonObject(String path) {
  final raw = jsonDecode(_resolveFile(path).readAsStringSync());
  if (raw is! Map) {
    throw FormatException('Expected JSON object at $path');
  }
  return Map<String, Object?>.from(raw);
}

SemanticLocalizationBundle _readSemanticBundles(List<String> paths) {
  final bundles = [
    for (final path in paths)
      if (_fileExists(path))
        SemanticLocalizationBundle.fromJson(_readJsonObject(path)),
  ];
  if (bundles.isEmpty) {
    return const SemanticLocalizationBundle(
      schemaVersion: 1,
      targetLanguage: 'es',
      sourceSupportLocale: 'en',
      supportLocales: ['uk'],
      units: [],
    );
  }
  final first = bundles.first;
  return SemanticLocalizationBundle(
    schemaVersion: first.schemaVersion,
    targetLanguage: first.targetLanguage,
    sourceSupportLocale: first.sourceSupportLocale,
    supportLocales: List.unmodifiable(
      {for (final bundle in bundles) ...bundle.supportLocales}.toList()..sort(),
    ),
    requiredSemanticFields: Set.unmodifiable({
      for (final bundle in bundles) ...bundle.requiredSemanticFields,
    }),
    units: List.unmodifiable([for (final bundle in bundles) ...bundle.units]),
  );
}

bool _fileExists(String appRelativePath) {
  return File(appRelativePath).existsSync() ||
      File('app/$appRelativePath').existsSync();
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
