// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';

import 'package:tutor_language/core/content/semantic_pilot_scope.dart';

const _coursePath =
    'assets/languages/spanish/curriculum/spanish_a0_course.json';
const _legacyPath =
    'assets/languages/spanish/localization/support_localizations.json';
const _referenceSemanticPath =
    'assets/languages/spanish/localization/semantic_reference_slice.json';
const _module1SemanticPath =
    'assets/languages/spanish/localization/semantic/module_1.uk.json';
const _pronunciationPath =
    'assets/languages/spanish/pronunciation/reference_slice.json';
const _outputPath =
    'assets/languages/spanish/localization/semantic_pilot_lessons.json';

Never main() {
  throw UnsupportedError(
    'This semantic pilot generator is archived by R2E5R for production '
    'authoring. Use create_semantic_localization_scaffold.dart and reviewed '
    'semantic units instead.',
  );
}

class _PilotBundleGenerator {
  _PilotBundleGenerator()
    : course = _readJsonObject(_coursePath),
      legacy = _readJsonObject(_legacyPath),
      referenceSemantic = _readJsonObject(_referenceSemanticPath),
      module1Semantic = _readJsonObject(_module1SemanticPath),
      pronunciation = _readJsonObject(_pronunciationPath) {
    for (final raw in legacy['entries'] as List? ?? const []) {
      final entry = Map<String, Object?>.from(raw as Map);
      legacyByKey['${entry['type']}|${entry['id']}'] = entry;
    }
    for (final raw in referenceSemantic['units'] as List? ?? const []) {
      final unit = Map<String, Object?>.from(raw as Map);
      final context = Map<String, Object?>.from(unit['context'] as Map);
      knownIdentities.add(
        '${context['contentObjectId']}|${context['fieldPath']}|${unit['semanticType']}',
      );
    }
    for (final raw in module1Semantic['units'] as List? ?? const []) {
      final unit = Map<String, Object?>.from(raw as Map);
      final context = Map<String, Object?>.from(unit['context'] as Map);
      knownIdentities.add(
        '${context['contentObjectId']}|${context['fieldPath']}|${unit['semanticType']}',
      );
    }
    for (final raw in pronunciation['units'] as List? ?? const []) {
      final unit = Map<String, Object?>.from(raw as Map);
      pronunciationUnitsById[unit['id'] as String] = unit;
      for (final related in unit['relatedContentIds'] as List? ?? const []) {
        pronunciationUnitByContentId['$related'] = unit;
      }
    }
    for (final raw in pronunciation['rules'] as List? ?? const []) {
      final rule = Map<String, Object?>.from(raw as Map);
      readingRulesById[rule['id'] as String] = rule;
    }
    for (final raw in pronunciation['localizations'] as List? ?? const []) {
      final entry = Map<String, Object?>.from(raw as Map);
      pronunciationLocalizationsById[entry['id'] as String] = entry;
    }
  }

  final Map<String, Object?> course;
  final Map<String, Object?> legacy;
  final Map<String, Object?> referenceSemantic;
  final Map<String, Object?> module1Semantic;
  final Map<String, Object?> pronunciation;
  final Map<String, Map<String, Object?>> legacyByKey = {};
  final Map<String, Map<String, Object?>> pronunciationUnitsById = {};
  final Map<String, Map<String, Object?>> pronunciationUnitByContentId = {};
  final Map<String, Map<String, Object?>> readingRulesById = {};
  final Map<String, Map<String, Object?>> pronunciationLocalizationsById = {};
  final Set<String> knownIdentities = {};
  final List<Map<String, Object?>> units = [];

  Map<String, Object?> generate() {
    final lessons = (course['lessons'] as List)
        .map((raw) => Map<String, Object?>.from(raw as Map))
        .where((lesson) {
          final metadata = Map<String, Object?>.from(lesson['metadata'] as Map);
          return semanticPilotLessonIds.contains(metadata['id']);
        })
        .toList(growable: false);

    for (final lesson in lessons) {
      _addLesson(lesson);
    }

    units.sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));
    return {
      'schemaVersion': 1,
      'targetLanguage': 'es',
      'sourceSupportLocale': 'en',
      'supportLocales': ['en', 'uk'],
      'pilot': {
        'phase': 'R2E4C',
        'lessonIds': semanticPilotLessonIds,
        'legacyFallbackAllowed': false,
      },
      'units': units,
    };
  }

  void _addLesson(Map<String, Object?> lesson) {
    final metadata = Map<String, Object?>.from(lesson['metadata'] as Map);
    final lessonId = metadata['id'] as String;
    final moduleId = metadata['moduleId'] as String;
    _supportUnit(
      id: lessonId,
      fieldPath: 'title',
      contentKind: 'lesson',
      semanticType: 'lessonTitle',
      role: 'lessonTitle',
      sourceText: metadata['title'] as String,
      legacyType: 'lesson',
      lessonId: lessonId,
      moduleId: moduleId,
    );
    final description = metadata['description'];
    if (description is String) {
      _supportUnit(
        id: lessonId,
        fieldPath: 'description',
        contentKind: 'lesson',
        semanticType: 'lessonDescription',
        role: 'lessonDescription',
        sourceText: description,
        legacyType: 'lesson',
        lessonId: lessonId,
        moduleId: moduleId,
      );
    }
    final outcome = lesson['communicativeOutcome'];
    if (outcome is String) {
      _supportUnit(
        id: lessonId,
        fieldPath: 'communicativeOutcome',
        contentKind: 'lesson',
        semanticType: 'communicativeOutcome',
        role: 'communicativeOutcome',
        sourceText: outcome,
        legacyType: 'lesson',
        lessonId: lessonId,
        moduleId: moduleId,
      );
    }
    for (final rawObjective in lesson['objectives'] as List? ?? const []) {
      final objective = Map<String, Object?>.from(rawObjective as Map);
      _supportUnit(
        id: '$lessonId.${objective['id']}',
        fieldPath: 'description',
        contentKind: 'lessonObjective',
        semanticType: 'lessonObjective',
        role: 'lessonObjective',
        sourceText: objective['description'] as String,
        legacyType: 'lesson_objective',
        lessonId: lessonId,
        moduleId: moduleId,
      );
    }
    for (final rawSection in lesson['sections'] as List? ?? const []) {
      final section = Map<String, Object?>.from(rawSection as Map);
      _supportUnit(
        id: section['id'] as String,
        fieldPath: 'title',
        contentKind: 'lessonSection',
        semanticType: 'metadataLabel',
        role: 'sectionTitle',
        sourceText: section['title'] as String,
        legacyType: 'lesson_section',
        lessonId: lessonId,
        moduleId: moduleId,
      );
      for (final rawActivity in section['activities'] as List? ?? const []) {
        final activity = Map<String, Object?>.from(rawActivity as Map);
        final activityId = activity['id'] as String;
        _supportUnit(
          id: activityId,
          fieldPath: 'title',
          contentKind: 'lessonActivity',
          semanticType: 'metadataLabel',
          role: 'activityTitle',
          sourceText: activity['title'] as String,
          legacyType: 'lesson_activity',
          lessonId: lessonId,
          moduleId: moduleId,
          activityId: activityId,
        );
        for (final rawReference
            in activity['references'] as List? ?? const []) {
          _addReferencedContent(
            Map<String, Object?>.from(rawReference as Map),
            lessonId: lessonId,
            moduleId: moduleId,
            activityId: activityId,
          );
        }
      }
    }
    final summary = lesson['summary'];
    if (summary is Map) {
      final summaryMap = Map<String, Object?>.from(summary);
      _supportUnit(
        id: summaryMap['id'] as String,
        fieldPath: 'reviewPrompt',
        contentKind: 'lessonSummary',
        semanticType: 'remediation',
        role: 'reviewPrompt',
        sourceText: summaryMap['reviewPrompt'] as String,
        legacyType: 'lesson_summary',
        lessonId: lessonId,
        moduleId: moduleId,
      );
    }
  }

  void _addReferencedContent(
    Map<String, Object?> reference, {
    required String lessonId,
    required String moduleId,
    required String activityId,
  }) {
    final assetPath = reference['assetPath'] as String;
    final type = reference['type'] as String;
    final referenceId = reference['referenceId'] as String?;
    final content = _readJsonList(assetPath).where((item) {
      return referenceId == null || item['id'] == referenceId;
    });
    for (final item in content) {
      final id = item['id'] as String;
      switch (type) {
        case 'vocabulary':
          _targetUnit(
            id: id,
            fieldPath: 'spanish',
            contentKind: 'vocabulary',
            semanticType: 'metadataLabel',
            role: 'targetTerm',
            sourceText: item['spanish'] as String,
            lessonId: lessonId,
            moduleId: moduleId,
            activityId: activityId,
          );
          _supportUnit(
            id: id,
            fieldPath: 'native_translation',
            contentKind: 'vocabulary',
            semanticType: _entitySemanticType(item['spanish'] as String),
            role: 'meaning',
            sourceText: item['native_translation'] as String,
            legacyType: 'vocabulary',
            lessonId: lessonId,
            moduleId: moduleId,
            activityId: activityId,
            namedEntityType: _entityType(item['spanish'] as String),
          );
          _targetUnit(
            id: id,
            fieldPath: 'example',
            contentKind: 'vocabulary',
            semanticType: 'exampleTranslation',
            role: 'targetExample',
            sourceText: item['example'] as String,
            lessonId: lessonId,
            moduleId: moduleId,
            activityId: activityId,
          );
          if (item['notes'] is String) {
            _supportUnit(
              id: id,
              fieldPath: 'notes',
              contentKind: 'vocabulary',
              semanticType: 'vocabularyUsageNote',
              role: 'usageNote',
              sourceText: item['notes'] as String,
              legacyType: 'vocabulary',
              lessonId: lessonId,
              moduleId: moduleId,
              activityId: activityId,
            );
          }
          _addPronunciationForVocabulary(
            item,
            lessonId: lessonId,
            moduleId: moduleId,
            activityId: activityId,
          );
        case 'grammar':
          _supportUnit(
            id: id,
            fieldPath: 'title',
            contentKind: 'grammar',
            semanticType: 'grammarTitle',
            role: 'grammarTitle',
            sourceText: item['title'] as String,
            legacyType: 'grammar',
            lessonId: lessonId,
            moduleId: moduleId,
            activityId: activityId,
          );
          _supportUnit(
            id: id,
            fieldPath: 'explanation',
            contentKind: 'grammar',
            semanticType: 'grammarExplanation',
            role: 'grammarExplanation',
            sourceText: item['explanation'] as String,
            legacyType: 'grammar',
            lessonId: lessonId,
            moduleId: moduleId,
            activityId: activityId,
          );
          final examples = item['examples'] as List? ?? const [];
          for (var index = 0; index < examples.length; index += 1) {
            _targetUnit(
              id: id,
              fieldPath: 'examples.$index',
              contentKind: 'grammar',
              semanticType: 'exampleTranslation',
              role: 'grammarExample',
              sourceText: '${examples[index]}',
              lessonId: lessonId,
              moduleId: moduleId,
              activityId: activityId,
            );
          }
        case 'dialogue':
          _supportUnit(
            id: id,
            fieldPath: 'title',
            contentKind: 'dialogue',
            semanticType: 'dialogueTitle',
            role: 'dialogueTitle',
            sourceText: item['title'] as String,
            legacyType: 'dialogue',
            lessonId: lessonId,
            moduleId: moduleId,
            activityId: activityId,
          );
          final lines = item['lines'] as List? ?? const [];
          for (var index = 0; index < lines.length; index += 1) {
            final line = Map<String, Object?>.from(lines[index] as Map);
            _targetUnit(
              id: id,
              fieldPath: 'lines.$index.spanish',
              contentKind: 'dialogue',
              semanticType: 'exampleTranslation',
              role: 'dialogueTargetLine',
              sourceText: line['spanish'] as String,
              lessonId: lessonId,
              moduleId: moduleId,
              activityId: activityId,
            );
            _supportUnit(
              id: id,
              fieldPath: 'lines.$index.native_translation',
              contentKind: 'dialogue',
              semanticType: 'dialogueTranslation',
              role: 'dialogueTranslation',
              sourceText: line['native_translation'] as String,
              legacyType: 'dialogue',
              lessonId: lessonId,
              moduleId: moduleId,
              activityId: activityId,
            );
          }
        case 'reading':
          _supportUnit(
            id: id,
            fieldPath: 'title',
            contentKind: 'reading',
            semanticType: 'readingTitle',
            role: 'readingTitle',
            sourceText: item['title'] as String,
            legacyType: 'reading',
            lessonId: lessonId,
            moduleId: moduleId,
            activityId: activityId,
          );
          _targetUnit(
            id: id,
            fieldPath: 'text',
            contentKind: 'reading',
            semanticType: 'exampleTranslation',
            role: 'readingTargetText',
            sourceText: item['text'] as String,
            lessonId: lessonId,
            moduleId: moduleId,
            activityId: activityId,
          );
          _supportUnit(
            id: id,
            fieldPath: 'native_translation',
            contentKind: 'reading',
            semanticType: 'readingTranslation',
            role: 'readingTranslation',
            sourceText: item['native_translation'] as String,
            legacyType: 'reading',
            lessonId: lessonId,
            moduleId: moduleId,
            activityId: activityId,
          );
        case 'exercise_template':
          _supportUnit(
            id: id,
            fieldPath: 'prompt_template',
            contentKind: 'exerciseTemplate',
            semanticType: 'exercisePrompt',
            role: 'exercisePrompt',
            sourceText: item['prompt_template'] as String,
            legacyType: 'exercise_template',
            lessonId: lessonId,
            moduleId: moduleId,
            activityId: activityId,
          );
          final options = item['answer_options'] as List? ?? const [];
          for (final rawOption in options) {
            final option = Map<String, Object?>.from(rawOption as Map);
            final fieldPath = 'answer_options.${option['id']}.label';
            final legacyValues = _legacyValues(
              'exercise_template',
              id,
              fieldPath,
            );
            if (legacyValues == null) {
              _targetUnit(
                id: id,
                fieldPath: fieldPath,
                contentKind: 'exerciseTemplate',
                semanticType: 'answerOptionLabel',
                role: 'answerOptionTargetLabel',
                sourceText: option['label'] as String,
                lessonId: lessonId,
                moduleId: moduleId,
                activityId: activityId,
              );
            } else {
              _supportUnit(
                id: id,
                fieldPath: fieldPath,
                contentKind: 'exerciseTemplate',
                semanticType: 'answerOptionLabel',
                role: 'answerOptionLabel',
                sourceText: option['label'] as String,
                legacyType: 'exercise_template',
                lessonId: lessonId,
                moduleId: moduleId,
                activityId: activityId,
              );
            }
          }
      }
    }
  }

  void _addPronunciationForVocabulary(
    Map<String, Object?> item, {
    required String lessonId,
    required String moduleId,
    required String activityId,
  }) {
    final directId =
        item['pronunciationUnitId'] ?? item['pronunciation_unit_id'];
    final unit = directId is String
        ? pronunciationUnitsById[directId]
        : pronunciationUnitByContentId[item['id']];
    if (unit == null) {
      return;
    }
    final unitId = unit['id'] as String;
    final localization = pronunciationLocalizationsById[unitId];
    final hints =
        _stringMap(localization?['learnerHints']) ??
        _stringMap(unit['localizedLearnerHints']) ??
        const {};
    final explanations = _stringMap(localization?['explanations']) ?? const {};
    if (unit['ipa'] is String) {
      _targetUnit(
        id: unitId,
        fieldPath: 'ipa',
        contentKind: 'pronunciationUnit',
        semanticType: 'metadataLabel',
        role: 'ipa',
        sourceText: unit['ipa'] as String,
        lessonId: lessonId,
        moduleId: moduleId,
        activityId: activityId,
        protectedType: 'ipa',
      );
    }
    if (hints['uk'] != null || hints['en'] != null) {
      _rawUnit(
        objectId: unitId,
        fieldPath: 'localizedLearnerHints.uk',
        contentKind: 'pronunciationUnit',
        semanticType: 'pronunciationHint',
        ownership: 'supportLanguageOwned',
        role: 'pronunciationHint',
        sourceText: hints['en'] ?? hints['uk']!,
        values: {'uk': hints['uk'] ?? hints['en']!},
        lessonId: lessonId,
        moduleId: moduleId,
        activityId: activityId,
      );
    }
    final explanation =
        explanations['uk'] ??
        explanations['en'] ??
        _pronunciationExplanation(
          hint: hints['uk'] ?? hints['en'],
          ipa: unit['ipa'] as String?,
        );
    _rawUnit(
      objectId: unitId,
      fieldPath: 'explanations.uk',
      contentKind: 'pronunciationUnit',
      semanticType: 'pronunciationExplanation',
      ownership: 'supportLanguageOwned',
      role: 'pronunciationExplanation',
      sourceText: explanations['en'] ?? explanation,
      values: {'uk': explanation},
      lessonId: lessonId,
      moduleId: moduleId,
      activityId: activityId,
    );
    for (final ruleId in unit['readingRuleIds'] as List? ?? const []) {
      _addReadingRule(
        '$ruleId',
        lessonId: lessonId,
        moduleId: moduleId,
        activityId: activityId,
      );
    }
  }

  void _addReadingRule(
    String ruleId, {
    required String lessonId,
    required String moduleId,
    required String activityId,
  }) {
    final rule = readingRulesById[ruleId];
    final localization = pronunciationLocalizationsById[ruleId];
    if (rule == null || localization == null) {
      return;
    }
    final fields = {
      'titles.uk': ['readingRuleTitle', 'readingRuleTitle', 'titles'],
      'shortExplanations.uk': [
        'readingRuleShortExplanation',
        'readingRuleShortExplanation',
        'shortExplanations',
      ],
      'detailedExplanations.uk': [
        'readingRuleDetailedExplanation',
        'readingRuleDetailedExplanation',
        'detailedExplanations',
      ],
      'articulationHints.uk': [
        'articulationHint',
        'articulationHint',
        'articulationHints',
      ],
      'commonMistakes.uk': [
        'commonMistakeExplanation',
        'commonMistakeExplanation',
        'commonMistakes',
      ],
      'graphemePresentations.uk': [
        'graphemeExplanation',
        'graphemePresentation',
        'graphemePresentations',
      ],
    };
    for (final entry in fields.entries) {
      final values = _stringMap(localization[entry.value[2]]);
      final fallback = _readingRuleFallback(
        fieldPath: entry.key,
        pattern: (rule['orthographicPattern'] ?? rule['symbol']) as String,
      );
      final value = values?['uk'] ?? values?['en'] ?? fallback;
      final sourceText = values?['en'] ?? value;
      final pattern = (rule['orthographicPattern'] ?? rule['symbol']) as String;
      _rawUnit(
        objectId: ruleId,
        fieldPath: entry.key,
        contentKind: 'readingRule',
        semanticType: entry.value[0],
        ownership: 'supportLanguageOwned',
        role: entry.value[1],
        sourceText: sourceText,
        values: {'uk': value},
        protectedSpans: sourceText.contains(pattern)
            ? [
                {
                  'id': _slug('span.$ruleId.${entry.key}'),
                  'type': 'targetText',
                  'text': pattern,
                },
              ]
            : const [],
        lessonId: lessonId,
        moduleId: moduleId,
        activityId: activityId,
      );
    }
    _targetUnit(
      id: ruleId,
      fieldPath: 'orthographicPattern',
      contentKind: 'readingRule',
      semanticType: 'graphemeDesignation',
      role: 'orthographicPattern',
      sourceText: (rule['orthographicPattern'] ?? rule['symbol']) as String,
      lessonId: lessonId,
      moduleId: moduleId,
      activityId: activityId,
    );
  }

  void _supportUnit({
    required String id,
    required String fieldPath,
    required String contentKind,
    required String semanticType,
    required String role,
    required String sourceText,
    required String legacyType,
    required String lessonId,
    required String moduleId,
    String? activityId,
    String? namedEntityType,
  }) {
    final values = _legacyValues(legacyType, id, fieldPath);
    _rawUnit(
      objectId: id,
      fieldPath: fieldPath,
      contentKind: contentKind,
      semanticType: semanticType,
      ownership: 'supportLanguageOwned',
      role: role,
      sourceText: values?['en'] ?? sourceText,
      values: {
        'en': values?['en'] ?? sourceText,
        'uk': _ukOverride(id, fieldPath) ?? values?['uk'] ?? sourceText,
      },
      lessonId: lessonId,
      moduleId: moduleId,
      activityId: activityId,
      namedEntityType: namedEntityType,
    );
  }

  void _targetUnit({
    required String id,
    required String fieldPath,
    required String contentKind,
    required String semanticType,
    required String role,
    required String sourceText,
    required String lessonId,
    required String moduleId,
    String? activityId,
    String protectedType = 'targetText',
  }) {
    _rawUnit(
      objectId: id,
      fieldPath: fieldPath,
      contentKind: contentKind,
      semanticType: semanticType,
      ownership: 'targetLanguageOwned',
      role: role,
      sourceText: sourceText,
      values: {'en': sourceText, 'uk': sourceText},
      protectedSpans: [
        {
          'id': _slug('span.$id.$fieldPath'),
          'type': protectedType,
          'text': sourceText,
        },
      ],
      lessonId: lessonId,
      moduleId: moduleId,
      activityId: activityId,
    );
  }

  void _rawUnit({
    required String objectId,
    required String fieldPath,
    required String contentKind,
    required String semanticType,
    required String ownership,
    required String role,
    required String sourceText,
    required Map<String, String> values,
    required String lessonId,
    required String moduleId,
    String? activityId,
    String? namedEntityType,
    List<Map<String, Object?>> protectedSpans = const [],
  }) {
    final identity = '$objectId|$fieldPath|$semanticType';
    if (!knownIdentities.add(identity)) {
      return;
    }
    units.add({
      'id':
          'semantic.pilot.${_slug(objectId)}.${_slug(fieldPath)}.$semanticType.v1',
      'semanticType': semanticType,
      'ownership': ownership,
      'sourceText': sourceText,
      'values': values,
      'review': {
        for (final locale in values.keys) locale: 'productionApproved',
      },
      'protectedSpans': protectedSpans,
      'context': {
        'courseId': 'es.a0',
        'moduleId': moduleId,
        'lessonId': lessonId,
        if (activityId != null) ...{'activityId': activityId},
        'contentObjectId': objectId,
        'fieldPath': fieldPath,
        'contentKind': contentKind,
        'pedagogicalRole': role,
        'targetLanguage': 'es',
        'supportLocale': 'uk',
        if (namedEntityType != null) ...{'namedEntityType': namedEntityType},
      },
    });
  }

  Map<String, String>? _legacyValues(String type, String id, String fieldPath) {
    final entry = legacyByKey['$type|$id'];
    final fields = entry?['fields'];
    if (fields is! Map) {
      return null;
    }
    final values = fields[fieldPath];
    if (values is! Map) {
      return null;
    }
    return {
      for (final entry in values.entries)
        if (entry.value is String) '${entry.key}': entry.value as String,
    };
  }

  String? _ukOverride(String id, String fieldPath) {
    return const {
      'es.a0.m02.l004|communicativeOutcome':
          'Назвати своє імʼя за допомогою me llamo.',
      'es.a0.m02.l004|description':
          'Використовуйте me llamo з різними іменами, щоб представитися.',
      'es.a0.m06.l036|communicativeOutcome':
          'Розпізнавати транспорт і сказати, як ви пересуваєтеся.',
      'es.a0.m06.l036|description':
          'Розпізнавайте поширені види транспорту й кажіть, як ви пересуваєтеся.',
    }['$id|$fieldPath'];
  }
}

String _pronunciationExplanation({String? hint, String? ipa}) {
  final parts = [
    if (hint != null && hint.trim().isNotEmpty) 'підказка $hint',
    if (ipa != null && ipa.trim().isNotEmpty) 'IPA $ipa',
  ];
  return 'Вимова: ${parts.join(', ')}.';
}

String _readingRuleFallback({
  required String fieldPath,
  required String pattern,
}) {
  if (fieldPath.startsWith('articulationHints')) {
    return 'Стежте за вимовою графеми $pattern у слові.';
  }
  if (fieldPath.startsWith('commonMistakes')) {
    return 'Не читайте $pattern за англійськими або українськими правилами.';
  }
  if (fieldPath.startsWith('graphemePresentations')) {
    return 'Графема: $pattern.';
  }
  return 'Правило для графеми $pattern.';
}

String _entitySemanticType(String value) {
  if (const {'España', 'Chile', 'México'}.contains(value)) {
    return 'countryName';
  }
  if (const {
    'Madrid',
    'Valencia',
    'Sevilla',
    'Ciudad de México',
  }.contains(value)) {
    return 'cityName';
  }
  return RegExp(r'^[A-ZÁÉÍÓÚÜÑ]').hasMatch(value)
      ? 'properNounMeaning'
      : 'vocabularyMeaning';
}

String? _entityType(String value) {
  if (const {'España', 'Chile', 'México'}.contains(value)) {
    return 'country';
  }
  if (const {
    'Madrid',
    'Valencia',
    'Sevilla',
    'Ciudad de México',
  }.contains(value)) {
    return 'city';
  }
  return RegExp(r'^[A-ZÁÉÍÓÚÜÑ]').hasMatch(value) ? 'person' : null;
}

Map<String, String>? _stringMap(Object? value) {
  if (value is! Map) {
    return null;
  }
  return {
    for (final entry in value.entries)
      if (entry.value is String) '${entry.key}': entry.value as String,
  };
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

File _resolveFile(String appRelativePath) {
  final candidates = [File(appRelativePath), File('app/$appRelativePath')];
  for (final candidate in candidates) {
    if (candidate.existsSync()) {
      return candidate;
    }
  }
  final first = candidates.first;
  first.parent.createSync(recursive: true);
  return first;
}

String _slug(String value) {
  return value
      .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '')
      .toLowerCase();
}
