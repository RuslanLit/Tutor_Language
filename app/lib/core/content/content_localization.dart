import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../features/curriculum/curriculum_models.dart';
import '../content/content_document.dart';
import 'semantic_localization.dart';
import 'topic_content.dart';

enum LocalizedFieldRole {
  targetLanguage,
  supportLanguage,
  localeIndependent,
  uiLocalization,
  technicalInternal,
}

class SupportLocale {
  const SupportLocale(this.code);

  static const english = SupportLocale('en');
  static const ukrainian = SupportLocale('uk');
  static const russian = SupportLocale('ru');
  static const polish = SupportLocale('pl');
  static const german = SupportLocale('de');

  static const supported = {
    'en': english,
    'uk': ukrainian,
    'ru': russian,
    'pl': polish,
    'de': german,
  };

  final String code;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SupportLocale && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;
}

class SupportLocaleResolver {
  const SupportLocaleResolver();

  SupportLocale resolveLocale(Locale locale) {
    return resolveLanguageCode(locale.languageCode);
  }

  SupportLocale resolveLanguageCode(String languageCode) {
    return SupportLocale.supported[languageCode.toLowerCase()] ??
        SupportLocale.english;
  }
}

enum EducationalLocalizationState { available, rebuilding, unavailable }

enum EducationalContentSource { source, englishSourceFallback, none }

class EducationalLocaleReadinessManifest {
  const EducationalLocaleReadinessManifest({
    required this.schemaVersion,
    required this.targetLanguage,
    required this.sourceSupportLocale,
    required this.locales,
  });

  factory EducationalLocaleReadinessManifest.fromJson(
    Map<String, Object?> json,
  ) {
    final localesJson = json['locales'];
    if (localesJson is! List) {
      throw const FormatException('Readiness manifest locales must be a list');
    }

    return EducationalLocaleReadinessManifest(
      schemaVersion: _requiredInt(json, 'schemaVersion'),
      targetLanguage: _requiredString(json, 'targetLanguage'),
      sourceSupportLocale: _requiredString(json, 'sourceSupportLocale'),
      locales: Map.unmodifiable({
        for (final locale in localesJson.map((entry) {
          if (entry is Map<String, Object?>) {
            return EducationalLocaleReadiness.fromJson(entry);
          }
          if (entry is Map) {
            return EducationalLocaleReadiness.fromJson(
              Map<String, Object?>.from(entry),
            );
          }
          throw const FormatException('Readiness locale must be an object');
        }))
          locale.locale: locale,
      }),
    );
  }

  final int schemaVersion;
  final String targetLanguage;
  final String sourceSupportLocale;
  final Map<String, EducationalLocaleReadiness> locales;

  EducationalLocaleReadiness forLocale(String locale) {
    return locales[locale] ?? locales[sourceSupportLocale]!;
  }
}

class EducationalLocaleReadiness {
  const EducationalLocaleReadiness({
    required this.locale,
    required this.uiAvailable,
    required this.educationalLocalizationState,
    required this.educationalContentSource,
    required this.semanticProductionReady,
    required this.allowedFallbackLocale,
    required this.crossLocaleFallbackProhibited,
    required this.completedModules,
    required this.releaseEligible,
  });

  factory EducationalLocaleReadiness.fromJson(Map<String, Object?> json) {
    return EducationalLocaleReadiness(
      locale: _requiredString(json, 'locale'),
      uiAvailable: _requiredBool(json, 'uiAvailable'),
      educationalLocalizationState: _enumByName(
        EducationalLocalizationState.values,
        _requiredString(json, 'educationalLocalizationState'),
        'educationalLocalizationState',
      ),
      educationalContentSource: _enumByName(
        EducationalContentSource.values,
        _requiredString(json, 'educationalContentSource'),
        'educationalContentSource',
      ),
      semanticProductionReady: _requiredBool(json, 'semanticProductionReady'),
      allowedFallbackLocale: _optionalString(json, 'allowedFallbackLocale'),
      crossLocaleFallbackProhibited: _requiredBool(
        json,
        'crossLocaleFallbackProhibited',
      ),
      completedModules: _requiredStringList(json, 'completedModules'),
      releaseEligible: _requiredBool(json, 'releaseEligible'),
    );
  }

  final String locale;
  final bool uiAvailable;
  final EducationalLocalizationState educationalLocalizationState;
  final EducationalContentSource educationalContentSource;
  final bool semanticProductionReady;
  final String? allowedFallbackLocale;
  final bool crossLocaleFallbackProhibited;
  final List<String> completedModules;
  final bool releaseEligible;

  bool get isEducationalProductionReady =>
      educationalLocalizationState == EducationalLocalizationState.available &&
      semanticProductionReady &&
      releaseEligible;
}

class EducationalLocaleReadinessRepository {
  EducationalLocaleReadinessRepository({
    AssetBundle? assetBundle,
    this.assetPath =
        'assets/languages/spanish/localization/semantic/manifests/educational_locales.json',
  }) : _assetBundle = assetBundle ?? rootBundle;

  final AssetBundle _assetBundle;
  final String assetPath;
  EducationalLocaleReadinessManifest? _cachedManifest;

  Future<EducationalLocaleReadinessManifest> loadManifest() async {
    final cached = _cachedManifest;
    if (cached != null) {
      return cached;
    }

    final rawJson = await _assetBundle.loadString(assetPath);
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map) {
      throw const FormatException('Readiness manifest must be an object');
    }

    return _cachedManifest = EducationalLocaleReadinessManifest.fromJson(
      Map<String, Object?>.from(decoded),
    );
  }
}

class EducationalContentLocalizationBundle {
  const EducationalContentLocalizationBundle({
    required this.schemaVersion,
    required this.targetLanguage,
    required this.sourceSupportLocale,
    required this.supportLocales,
    required this.entries,
  });

  factory EducationalContentLocalizationBundle.fromJson(
    Map<String, Object?> json,
  ) {
    final entries = json['entries'];
    if (entries is! List) {
      throw const FormatException('Localization bundle entries must be a list');
    }

    return EducationalContentLocalizationBundle(
      schemaVersion: _requiredInt(json, 'schemaVersion'),
      targetLanguage: _requiredString(json, 'targetLanguage'),
      sourceSupportLocale: _requiredString(json, 'sourceSupportLocale'),
      supportLocales: _requiredStringList(json, 'supportLocales'),
      entries: List.unmodifiable(
        entries.map((entry) {
          if (entry is Map<String, Object?>) {
            return LocalizedEducationalEntry.fromJson(entry);
          }
          if (entry is Map) {
            return LocalizedEducationalEntry.fromJson(
              Map<String, Object?>.from(entry),
            );
          }
          throw const FormatException('Localization entry must be an object');
        }),
      ),
    );
  }

  final int schemaVersion;
  final String targetLanguage;
  final String sourceSupportLocale;
  final List<String> supportLocales;
  final List<LocalizedEducationalEntry> entries;
}

class LocalizedEducationalEntry {
  const LocalizedEducationalEntry({
    required this.type,
    required this.id,
    required this.fields,
  });

  factory LocalizedEducationalEntry.fromJson(Map<String, Object?> json) {
    final fieldsJson = json['fields'];
    if (fieldsJson is! Map) {
      throw const FormatException(
        'Localization entry fields must be an object',
      );
    }

    return LocalizedEducationalEntry(
      type: _requiredString(json, 'type'),
      id: _requiredString(json, 'id'),
      fields: Map<String, Map<String, String>>.unmodifiable(
        fieldsJson.map((key, value) {
          if (value is! Map) {
            throw FormatException(
              'Localized field $key must be keyed by locale',
            );
          }
          final localizedValues = <String, String>{};
          for (final entry in value.entries) {
            final text = entry.value;
            if (text is! String) {
              throw FormatException(
                'Localized field $key for ${entry.key} must be a string',
              );
            }
            localizedValues['${entry.key}'] = text;
          }
          return MapEntry(
            '$key',
            Map<String, String>.unmodifiable(localizedValues),
          );
        }),
      ),
    );
  }

  final String type;
  final String id;
  final Map<String, Map<String, String>> fields;
}

class EducationalContentLocalizationRepository {
  EducationalContentLocalizationRepository({
    AssetBundle? assetBundle,
    this.assetPath =
        'assets/languages/spanish/localization/support_localizations.json',
  }) : _assetBundle = assetBundle ?? rootBundle;

  final AssetBundle _assetBundle;
  final String assetPath;
  EducationalContentLocalizationBundle? _cachedBundle;

  Future<EducationalContentLocalizationBundle> loadBundle() async {
    final cached = _cachedBundle;
    if (cached != null) {
      return cached;
    }

    final rawJson = await _assetBundle.loadString(assetPath);
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map) {
      throw const FormatException('Localization bundle must be an object');
    }

    return _cachedBundle = EducationalContentLocalizationBundle.fromJson(
      Map<String, Object?>.from(decoded),
    );
  }
}

class SemanticLocalizationRepository {
  SemanticLocalizationRepository({
    AssetBundle? assetBundle,
    List<String>? assetPaths,
  }) : _assetBundle = assetBundle ?? rootBundle,
       assetPaths =
           assetPaths ??
           const [
             'assets/languages/spanish/localization/semantic/uk/shared.json',
             'assets/languages/spanish/localization/semantic/uk/module_01.json',
             'assets/languages/spanish/localization/semantic/ru/shared.json',
           ];

  final AssetBundle _assetBundle;
  final List<String> assetPaths;
  SemanticLocalizationBundle? _cachedBundle;

  Future<SemanticLocalizationBundle> loadBundle() async {
    final cached = _cachedBundle;
    if (cached != null) {
      return cached;
    }

    final bundles = <SemanticLocalizationBundle>[];
    for (final assetPath in assetPaths) {
      final String rawJson;
      try {
        rawJson = await _assetBundle.loadString(assetPath);
      } on FlutterError catch (error) {
        if (_isMissingAsset(error)) {
          continue;
        }
        rethrow;
      }
      if (rawJson.trim().isEmpty) {
        continue;
      }
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map) {
        throw const FormatException(
          'Semantic localization bundle must be an object',
        );
      }
      bundles.add(
        SemanticLocalizationBundle.fromJson(Map<String, Object?>.from(decoded)),
      );
    }

    if (bundles.isEmpty) {
      return _cachedBundle = const SemanticLocalizationBundle(
        schemaVersion: 1,
        targetLanguage: 'es',
        sourceSupportLocale: 'uk',
        supportLocales: ['uk'],
        units: [],
      );
    }
    final first = bundles.first;
    return _cachedBundle = SemanticLocalizationBundle(
      schemaVersion: first.schemaVersion,
      targetLanguage: first.targetLanguage,
      sourceSupportLocale: first.sourceSupportLocale,
      supportLocales: List.unmodifiable(
        {for (final bundle in bundles) ...bundle.supportLocales}.toList()
          ..sort(),
      ),
      requiredSemanticFields: Set.unmodifiable({
        for (final bundle in bundles) ...bundle.requiredSemanticFields,
      }),
      units: List.unmodifiable([for (final bundle in bundles) ...bundle.units]),
    );
  }

  bool _isMissingAsset(FlutterError error) {
    final message = error.toString();
    return message.contains('Unable to load asset') ||
        message.contains('does not exist or has empty data');
  }
}

class EducationalContentLocalizationResolver {
  EducationalContentLocalizationResolver(this.bundle, {this.semanticBundle})
    : _entriesByKey = {
        for (final entry in bundle.entries) '${entry.type}|${entry.id}': entry,
      },
      _semanticResolver = semanticBundle == null
          ? null
          : SemanticLocalizationResolver(semanticBundle);

  final EducationalContentLocalizationBundle bundle;
  final SemanticLocalizationBundle? semanticBundle;
  final Map<String, LocalizedEducationalEntry> _entriesByKey;
  final SemanticLocalizationResolver? _semanticResolver;

  Course resolveCourse(Course course, SupportLocale locale) {
    return Course(
      id: course.id,
      languageId: course.languageId,
      title:
          _localizedField(course.id, 'title', locale) ??
          _field('course', course.id, 'title', locale) ??
          course.title,
      level: course.level,
      version: course.version,
      modules: List.unmodifiable(
        course.modules.map((module) => resolveModule(module, locale)),
      ),
      lessons: List.unmodifiable(
        course.lessons.map((lesson) => resolveLesson(lesson, locale)),
      ),
    );
  }

  Module resolveModule(Module module, SupportLocale locale) {
    return Module(
      id: module.id,
      title:
          _localizedField(module.id, 'title', locale) ??
          _field('module', module.id, 'title', locale) ??
          module.title,
      lessonIds: module.lessonIds,
    );
  }

  Lesson resolveLesson(Lesson lesson, SupportLocale locale) {
    final metadata = lesson.metadata;
    if (metadata == null) {
      return lesson;
    }
    final lessonId = _safeLessonId(lesson);
    return Lesson(
      metadata: LessonMetadata(
        id: metadata.id,
        title:
            _localizedField(lessonId, 'title', locale) ??
            _field('lesson', lessonId, 'title', locale) ??
            metadata.title,
        description:
            _localizedField(lessonId, 'description', locale) ??
            _field('lesson', lessonId, 'description', locale) ??
            metadata.description,
        moduleId: metadata.moduleId,
        courseId: metadata.courseId,
        estimatedDurationMinutes: metadata.estimatedDurationMinutes,
        difficulty: metadata.difficulty,
        tags: metadata.tags,
        version: metadata.version,
        prerequisites: metadata.prerequisites,
        introducedReadingRuleIds: metadata.introducedReadingRuleIds,
        requiredReadingRuleIds: metadata.requiredReadingRuleIds,
        reviewedReadingRuleIds: metadata.reviewedReadingRuleIds,
      ),
      objectives: List.unmodifiable(
        lesson.objectives.map((objective) {
          return LessonObjective(
            id: objective.id,
            description:
                _localizedField(
                  lessonId == null ? null : '$lessonId.${objective.id}',
                  'description',
                  locale,
                ) ??
                _field(
                  'lesson_objective',
                  lessonId == null ? null : '$lessonId.${objective.id}',
                  'description',
                  locale,
                ) ??
                objective.description,
          );
        }),
      ),
      communicativeOutcome:
          _localizedField(lessonId, 'communicativeOutcome', locale) ??
          _field('lesson', lessonId, 'communicativeOutcome', locale) ??
          lesson.communicativeOutcome,
      sections: List.unmodifiable(
        lesson.sections.map((section) {
          return LessonSection(
            id: section.id,
            title:
                _localizedField(section.id, 'title', locale) ??
                _field('lesson_section', section.id, 'title', locale) ??
                section.title,
            order: section.order,
            activities: List.unmodifiable(
              section.activities.map((activity) {
                return LessonActivity(
                  id: activity.id,
                  title:
                      _localizedField(activity.id, 'title', locale) ??
                      _field('lesson_activity', activity.id, 'title', locale) ??
                      activity.title,
                  type: activity.type,
                  order: activity.order,
                  references: activity.references,
                  introducedReadingRuleIds: activity.introducedReadingRuleIds,
                  requiredReadingRuleIds: activity.requiredReadingRuleIds,
                  reviewedReadingRuleIds: activity.reviewedReadingRuleIds,
                  spokenPractice: activity.spokenPractice == null
                      ? null
                      : SpokenPracticeDefinition(
                          mode: activity.spokenPractice!.mode,
                          audioReferenceId:
                              activity.spokenPractice!.audioReferenceId,
                          prompt:
                              _localizedField(
                                activity.id,
                                'spokenPractice.prompt',
                                locale,
                              ) ??
                              _field(
                                'lesson_activity',
                                activity.id,
                                'spokenPractice.prompt',
                                locale,
                              ) ??
                              activity.spokenPractice!.prompt,
                          targetText: activity.spokenPractice!.targetText,
                          focusCue:
                              _localizedField(
                                activity.id,
                                'spokenPractice.focusCue',
                                locale,
                              ) ??
                              _field(
                                'lesson_activity',
                                activity.id,
                                'spokenPractice.focusCue',
                                locale,
                              ) ??
                              activity.spokenPractice!.focusCue,
                        ),
                );
              }),
            ),
          );
        }),
      ),
      summary: lesson.summary == null
          ? null
          : LessonSummary(
              id: lesson.summary!.id,
              reviewPrompt:
                  _localizedField(lesson.summary!.id, 'reviewPrompt', locale) ??
                  _field(
                    'lesson_summary',
                    lesson.summary!.id,
                    'reviewPrompt',
                    locale,
                  ) ??
                  lesson.summary!.reviewPrompt,
              referenceIds: lesson.summary!.referenceIds,
            ),
      completionCriteria: lesson.completionCriteria,
      references: lesson.references,
    );
  }

  Object resolveContentObject(Object content, SupportLocale locale) {
    return switch (content) {
      VocabularyItem item => resolveVocabularyItem(item, locale),
      GrammarTopic topic => resolveGrammarTopic(topic, locale),
      Dialogue dialogue => resolveDialogue(dialogue, locale),
      ReadingText reading => resolveReading(reading, locale),
      ExerciseTemplate template => resolveExerciseTemplate(template, locale),
      _ => content,
    };
  }

  VocabularyItem resolveVocabularyItem(
    VocabularyItem item,
    SupportLocale locale,
  ) {
    return VocabularyItem(
      id: item.id,
      spanish: _localizedField(item.id, 'spanish', locale) ?? item.spanish,
      nativeTranslation:
          _localizedField(item.id, 'native_translation', locale) ??
          _field('vocabulary', item.id, 'native_translation', locale) ??
          item.nativeTranslation,
      cefr: item.cefr,
      example: _localizedField(item.id, 'example', locale) ?? item.example,
      audioReferenceId: item.audioReferenceId,
      pronunciationUnitId: item.pronunciationUnitId,
      pronunciation: item.pronunciation,
      notes:
          _localizedField(item.id, 'notes', locale) ??
          _field('vocabulary', item.id, 'notes', locale) ??
          item.notes,
    );
  }

  GrammarTopic resolveGrammarTopic(GrammarTopic topic, SupportLocale locale) {
    return GrammarTopic(
      id: topic.id,
      title:
          _localizedField(topic.id, 'title', locale) ??
          _field('grammar', topic.id, 'title', locale) ??
          topic.title,
      explanation:
          _localizedField(topic.id, 'explanation', locale) ??
          _field('grammar', topic.id, 'explanation', locale) ??
          topic.explanation,
      examples: _listFields(
        'grammar',
        topic.id,
        'examples',
        topic.examples,
        locale,
      ),
      prerequisiteIds: topic.prerequisiteIds,
    );
  }

  Dialogue resolveDialogue(Dialogue dialogue, SupportLocale locale) {
    return Dialogue(
      id: dialogue.id,
      title:
          _localizedField(dialogue.id, 'title', locale) ??
          _field('dialogue', dialogue.id, 'title', locale) ??
          dialogue.title,
      vocabularyIds: dialogue.vocabularyIds,
      grammarIds: dialogue.grammarIds,
      lines: List.unmodifiable([
        for (var index = 0; index < dialogue.lines.length; index += 1)
          DialogueLine(
            speaker: dialogue.lines[index].speaker,
            spanish:
                _localizedField(dialogue.id, 'lines.$index.spanish', locale) ??
                dialogue.lines[index].spanish,
            nativeTranslation:
                _localizedField(
                  dialogue.id,
                  'lines.$index.native_translation',
                  locale,
                ) ??
                _field(
                  'dialogue',
                  dialogue.id,
                  'lines.$index.native_translation',
                  locale,
                ) ??
                dialogue.lines[index].nativeTranslation,
            audioReferenceId: dialogue.lines[index].audioReferenceId,
          ),
      ]),
    );
  }

  ReadingText resolveReading(ReadingText reading, SupportLocale locale) {
    return ReadingText(
      id: reading.id,
      title:
          _localizedField(reading.id, 'title', locale) ??
          _field('reading', reading.id, 'title', locale) ??
          reading.title,
      vocabularyIds: reading.vocabularyIds,
      grammarIds: reading.grammarIds,
      text: _localizedField(reading.id, 'text', locale) ?? reading.text,
      nativeTranslation:
          _localizedField(reading.id, 'native_translation', locale) ??
          _field('reading', reading.id, 'native_translation', locale) ??
          reading.nativeTranslation,
    );
  }

  ExerciseTemplate resolveExerciseTemplate(
    ExerciseTemplate template,
    SupportLocale locale,
  ) {
    return ExerciseTemplate(
      id: template.id,
      exerciseType: template.exerciseType,
      supportedGoalTypes: template.supportedGoalTypes,
      requiredObjectTypes: template.requiredObjectTypes,
      promptTemplate:
          _localizedField(template.id, 'prompt_template', locale) ??
          _field('exercise_template', template.id, 'prompt_template', locale) ??
          template.promptTemplate,
      answerOptions: List.unmodifiable(
        template.answerOptions.map((option) {
          final shouldLocalize = shouldLocalizeSupportAnswerOption(
            promptTemplate: template.promptTemplate,
            optionLabel: option.label,
          );
          final semanticLabel = _localizedField(
            template.id,
            'answer_options.${option.id}.label',
            locale,
          );
          return ExerciseTemplateOption(
            id: option.id,
            label:
                semanticLabel ??
                (shouldLocalize
                    ? _localizedField(
                            template.id,
                            'answer_options.${option.id}.label',
                            locale,
                          ) ??
                          _field(
                            'exercise_template',
                            template.id,
                            'answer_options.${option.id}.label',
                            locale,
                          ) ??
                          option.label
                    : option.label),
          );
        }),
      ),
      correctOptionId: template.correctOptionId,
      expectedAnswer:
          _localizedField(template.id, 'expected_answer', locale) ??
          template.expectedAnswer,
      acceptedAnswers: template.acceptedAnswers,
      acceptedWithFeedbackAnswers: template.acceptedWithFeedbackAnswers,
      requiresExactAnswer: template.requiresExactAnswer,
      authoredMisconceptions: template.authoredMisconceptions,
      reviewTemplateIds: template.reviewTemplateIds,
      productionContract: template.productionContract,
      guidedDialogue: template.guidedDialogue,
    );
  }

  String? _localizedField(String? id, String fieldName, SupportLocale locale) {
    if (id == null) {
      return null;
    }
    return _semanticResolver?.approvedValueForField(
      contentObjectId: id,
      fieldPath: fieldName,
      supportLocale: locale.code,
    );
  }

  String? _field(
    String type,
    String? id,
    String fieldName,
    SupportLocale locale,
  ) {
    if (id == null) {
      return null;
    }
    final values = _entriesByKey['$type|$id']?.fields[fieldName];
    if (values == null) {
      return null;
    }

    return values[locale.code] ?? values[bundle.sourceSupportLocale];
  }

  List<String> _listFields(
    String type,
    String id,
    String fieldPrefix,
    List<String> fallback,
    SupportLocale locale,
  ) {
    final values = <String>[];
    for (var index = 0; index < fallback.length; index += 1) {
      values.add(
        _localizedField(id, '$fieldPrefix.$index', locale) ??
            _field(type, id, '$fieldPrefix.$index', locale) ??
            fallback[index],
      );
    }
    return List.unmodifiable(values);
  }

  String? _safeLessonId(Lesson lesson) {
    try {
      return lesson.id;
    } on TypeError {
      return lesson.metadata?.id;
    }
  }
}

class EducationalContentLocalizationValidationIssue {
  const EducationalContentLocalizationValidationIssue({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;

  @override
  String toString() => '$code: $message';
}

class EducationalContentLocalizationInventoryField {
  const EducationalContentLocalizationInventoryField({
    required this.type,
    required this.id,
    required this.fieldName,
    required this.category,
    required this.sourceText,
  });

  final String type;
  final String id;
  final String fieldName;
  final String category;
  final String sourceText;

  String get entryKey => '$type|$id';
  String get fieldKey => '$entryKey|$fieldName';
}

class EducationalContentLocalizationInventorySummary {
  const EducationalContentLocalizationInventorySummary({
    required this.category,
    required this.totalLocalizableFields,
    required this.englishSourceFields,
    required this.missingEnglishSourceFields,
    required this.invalidFields,
  });

  final String category;
  final int totalLocalizableFields;
  final int englishSourceFields;
  final int missingEnglishSourceFields;
  final int invalidFields;

  double get coveragePercentage => totalLocalizableFields == 0
      ? 100
      : englishSourceFields / totalLocalizableFields * 100;
}

class EducationalContentLocalizationInventory {
  const EducationalContentLocalizationInventory();

  List<EducationalContentLocalizationInventoryField> build({
    required Course course,
    required EducationalContentBundle contentBundle,
  }) {
    final fields = <EducationalContentLocalizationInventoryField>[];

    void add({
      required String category,
      required String type,
      required String id,
      required String fieldName,
      required String? sourceText,
    }) {
      final text = sourceText?.trim();
      if (text == null || text.isEmpty) {
        return;
      }
      fields.add(
        EducationalContentLocalizationInventoryField(
          type: type,
          id: id,
          fieldName: fieldName,
          category: category,
          sourceText: sourceText!,
        ),
      );
    }

    add(
      category: 'course metadata',
      type: 'course',
      id: course.id,
      fieldName: 'title',
      sourceText: course.title,
    );

    for (final module in course.modules) {
      add(
        category: 'module metadata',
        type: 'module',
        id: module.id,
        fieldName: 'title',
        sourceText: module.title,
      );
    }

    for (final lesson in course.lessons) {
      add(
        category: 'lesson metadata',
        type: 'lesson',
        id: lesson.id,
        fieldName: 'title',
        sourceText: lesson.title,
      );
      add(
        category: 'lesson metadata',
        type: 'lesson',
        id: lesson.id,
        fieldName: 'description',
        sourceText: lesson.metadata?.description,
      );
      add(
        category: 'lesson metadata',
        type: 'lesson',
        id: lesson.id,
        fieldName: 'communicativeOutcome',
        sourceText: lesson.communicativeOutcome,
      );
      for (final objective in lesson.objectives) {
        add(
          category: 'lesson objectives',
          type: 'lesson_objective',
          id: '${lesson.id}.${objective.id}',
          fieldName: 'description',
          sourceText: objective.description,
        );
      }
      for (final section in lesson.sections) {
        add(
          category: 'lesson sections',
          type: 'lesson_section',
          id: section.id,
          fieldName: 'title',
          sourceText: section.title,
        );
        for (final activity in section.activities) {
          add(
            category: 'lesson activities',
            type: 'lesson_activity',
            id: activity.id,
            fieldName: 'title',
            sourceText: activity.title,
          );
        }
      }
      if (lesson.summary != null) {
        add(
          category: 'lesson summaries',
          type: 'lesson_summary',
          id: lesson.summary!.id,
          fieldName: 'reviewPrompt',
          sourceText: lesson.summary!.reviewPrompt,
        );
      }
    }

    for (final content in contentBundle.contents) {
      switch (content) {
        case VocabularyContent(:final entries):
          for (final item in entries) {
            add(
              category: 'vocabulary',
              type: 'vocabulary',
              id: item.id,
              fieldName: 'native_translation',
              sourceText: item.nativeTranslation,
            );
            add(
              category: 'vocabulary',
              type: 'vocabulary',
              id: item.id,
              fieldName: 'notes',
              sourceText: item.notes,
            );
          }
        case GrammarContent(:final topics):
          for (final topic in topics) {
            add(
              category: 'grammar',
              type: 'grammar',
              id: topic.id,
              fieldName: 'title',
              sourceText: topic.title,
            );
            add(
              category: 'grammar',
              type: 'grammar',
              id: topic.id,
              fieldName: 'explanation',
              sourceText: topic.explanation,
            );
            for (var index = 0; index < topic.examples.length; index += 1) {
              add(
                category: 'grammar',
                type: 'grammar',
                id: topic.id,
                fieldName: 'examples.$index',
                sourceText: topic.examples[index],
              );
            }
          }
        case DialogueContent(:final dialogues):
          for (final dialogue in dialogues) {
            add(
              category: 'dialogues',
              type: 'dialogue',
              id: dialogue.id,
              fieldName: 'title',
              sourceText: dialogue.title,
            );
            for (var index = 0; index < dialogue.lines.length; index += 1) {
              add(
                category: 'dialogues',
                type: 'dialogue',
                id: dialogue.id,
                fieldName: 'lines.$index.native_translation',
                sourceText: dialogue.lines[index].nativeTranslation,
              );
            }
          }
        case ReadingContent(:final texts):
          for (final reading in texts) {
            add(
              category: 'readings',
              type: 'reading',
              id: reading.id,
              fieldName: 'title',
              sourceText: reading.title,
            );
            add(
              category: 'readings',
              type: 'reading',
              id: reading.id,
              fieldName: 'native_translation',
              sourceText: reading.nativeTranslation,
            );
          }
        case ExerciseTemplateContent(:final templates):
          for (final template in templates) {
            add(
              category: 'exercise prompts',
              type: 'exercise_template',
              id: template.id,
              fieldName: 'prompt_template',
              sourceText: template.promptTemplate,
            );
            for (final option in template.answerOptions) {
              if (shouldLocalizeSupportAnswerOption(
                promptTemplate: template.promptTemplate,
                optionLabel: option.label,
              )) {
                add(
                  category: 'support-language answer options',
                  type: 'exercise_template',
                  id: template.id,
                  fieldName: 'answer_options.${option.id}.label',
                  sourceText: option.label,
                );
              }
            }
          }
        default:
          break;
      }
    }

    fields.sort((a, b) => a.fieldKey.compareTo(b.fieldKey));
    return List.unmodifiable(fields);
  }

  List<EducationalContentLocalizationInventorySummary> summarize({
    required List<EducationalContentLocalizationInventoryField> inventory,
    required EducationalContentLocalizationBundle localization,
  }) {
    final localizedFields = {
      for (final entry in localization.entries)
        for (final field in entry.fields.entries)
          '${entry.type}|${entry.id}|${field.key}': field.value,
    };
    final categories = <String>{for (final field in inventory) field.category};

    return List.unmodifiable([
      for (final category in categories)
        _summaryFor(
          category: category,
          inventory: inventory.where((field) => field.category == category),
          localizedFields: localizedFields,
          sourceSupportLocale: localization.sourceSupportLocale,
        ),
    ]);
  }

  EducationalContentLocalizationInventorySummary _summaryFor({
    required String category,
    required Iterable<EducationalContentLocalizationInventoryField> inventory,
    required Map<String, Map<String, String>> localizedFields,
    required String sourceSupportLocale,
  }) {
    var total = 0;
    var source = 0;
    var invalid = 0;
    for (final field in inventory) {
      total += 1;
      final localized = localizedFields[field.fieldKey];
      final sourceText = localized?[sourceSupportLocale];
      if (sourceText == null || sourceText.trim().isEmpty) {
        continue;
      }
      source += 1;
      if (sourceText.trim() != field.sourceText.trim()) {
        invalid += 1;
      }
    }

    return EducationalContentLocalizationInventorySummary(
      category: category,
      totalLocalizableFields: total,
      englishSourceFields: source,
      missingEnglishSourceFields: total - source,
      invalidFields: invalid,
    );
  }
}

bool shouldLocalizeSupportAnswerOption({
  required String promptTemplate,
  required String optionLabel,
}) {
  final label = optionLabel.trim();
  if (label.isEmpty || _looksLikeTargetSpanish(label)) {
    return false;
  }

  final lowerPrompt = promptTemplate.toLowerCase();
  if (lowerPrompt.contains('meaning') ||
      lowerPrompt.contains('translation') ||
      lowerPrompt.contains('what does') ||
      lowerPrompt.contains('which letter') ||
      lowerPrompt.contains('what is') ||
      lowerPrompt.contains('who is') ||
      lowerPrompt.contains('where ') ||
      lowerPrompt.contains('what transport') ||
      lowerPrompt.contains('which answer fits')) {
    return true;
  }

  return _looksLikeSupportEnglish(label);
}

bool _looksLikeTargetSpanish(String value) {
  final lower = value.toLowerCase();
  if (RegExp(r'[¿¡áéíóúñü]').hasMatch(lower)) {
    return true;
  }

  final tokens = RegExp(r"[a-z]+").allMatches(lower).map((match) {
    return match.group(0)!;
  }).toSet();
  const spanishMarkers = {
    'adios',
    'agua',
    'ahora',
    'al',
    'amigo',
    'amiga',
    'anos',
    'autobus',
    'ayuda',
    'bano',
    'bien',
    'buenas',
    'buenos',
    'cafe',
    'casa',
    'cerca',
    'como',
    'de',
    'derecha',
    'donde',
    'el',
    'ella',
    'en',
    'eres',
    'es',
    'espana',
    'espanol',
    'esta',
    'estoy',
    'favor',
    'gira',
    'gracias',
    'hablo',
    'hola',
    'hospital',
    'izquierda',
    'la',
    'llego',
    'llamo',
    'luego',
    'mal',
    'me',
    'medico',
    'mucho',
    'necesito',
    'no',
    'pan',
    'pero',
    'policia',
    'por',
    'que',
    'recto',
    'repite',
    'se',
    'si',
    'sigue',
    'soy',
    'tal',
    'te',
    'tengo',
    'tiene',
    'tienes',
    'toma',
    'un',
    'una',
    'vivo',
    'voy',
  };

  return tokens.any(spanishMarkers.contains);
}

bool _looksLikeSupportEnglish(String value) {
  final lower = value.toLowerCase();
  final tokens = RegExp(r"[a-z]+").allMatches(lower).map((match) {
    return match.group(0)!;
  }).toSet();
  const englishMarkers = {
    'a',
    'about',
    'afternoon',
    'am',
    'and',
    'answer',
    'are',
    'bad',
    'book',
    'bus',
    'do',
    'doctor',
    'does',
    'eight',
    'evening',
    'far',
    'fine',
    'for',
    'four',
    'friend',
    'from',
    'go',
    'good',
    'goodbye',
    'hello',
    'help',
    'how',
    'hungry',
    'i',
    'is',
    'key',
    'language',
    'left',
    'like',
    'little',
    'lives',
    'meaning',
    'morning',
    'mother',
    'my',
    'name',
    'near',
    'not',
    'of',
    'person',
    'please',
    'question',
    'right',
    'sixteen',
    'speak',
    'speaks',
    'straight',
    'student',
    'teacher',
    'thank',
    'thanks',
    'the',
    'to',
    'train',
    'turn',
    'very',
    'welcome',
    'what',
    'where',
    'which',
    'who',
    'you',
    'your',
  };

  return tokens.any(englishMarkers.contains);
}

class EducationalContentLocalizationValidator {
  const EducationalContentLocalizationValidator();

  List<EducationalContentLocalizationValidationIssue> validate({
    required EducationalContentLocalizationBundle localization,
    required Course course,
    required EducationalContentBundle contentBundle,
  }) {
    final issues = <EducationalContentLocalizationValidationIssue>[];
    final knownIdsByType = _knownIdsByType(course, contentBundle);
    final requiredFields = {
      for (final field in const EducationalContentLocalizationInventory().build(
        course: course,
        contentBundle: contentBundle,
      ))
        field.fieldKey: field,
    };
    final localizedFieldKeys = <String>{};
    final seen = <String>{};

    for (final locale in localization.supportLocales) {
      if (!SupportLocale.supported.containsKey(locale)) {
        issues.add(
          EducationalContentLocalizationValidationIssue(
            code: 'unsupported_locale',
            message: 'Unsupported support locale: $locale',
          ),
        );
      }
    }

    for (final entry in localization.entries) {
      final key = '${entry.type}|${entry.id}';
      if (!seen.add(key)) {
        issues.add(
          EducationalContentLocalizationValidationIssue(
            code: 'duplicate_localization_entry',
            message: 'Duplicate localization entry: $key',
          ),
        );
      }

      if (!(knownIdsByType[entry.type]?.contains(entry.id) ?? false)) {
        issues.add(
          EducationalContentLocalizationValidationIssue(
            code: 'unknown_localized_id',
            message: 'Localized ${entry.type} id is unknown: ${entry.id}',
          ),
        );
      }

      for (final field in entry.fields.entries) {
        final fieldKey = '$key|${field.key}';
        localizedFieldKeys.add(fieldKey);
        if (!requiredFields.containsKey(fieldKey)) {
          issues.add(
            EducationalContentLocalizationValidationIssue(
              code: 'unknown_localized_field',
              message: 'Localized field is not in inventory: $fieldKey',
            ),
          );
        }

        final source = field.value[localization.sourceSupportLocale];
        if (source == null || source.trim().isEmpty) {
          issues.add(
            EducationalContentLocalizationValidationIssue(
              code: 'missing_source_support_text',
              message:
                  'Missing ${localization.sourceSupportLocale} source for '
                  '$key ${field.key}',
            ),
          );
        }

        for (final locale in field.value.keys) {
          if (!SupportLocale.supported.containsKey(locale)) {
            issues.add(
              EducationalContentLocalizationValidationIssue(
                code: 'unsupported_locale',
                message: 'Unsupported locale $locale in $key ${field.key}',
              ),
            );
          }
        }
      }
    }

    for (final field in requiredFields.values) {
      if (!localizedFieldKeys.contains(field.fieldKey)) {
        issues.add(
          EducationalContentLocalizationValidationIssue(
            code: 'missing_required_source_field',
            message:
                'Missing required ${localization.sourceSupportLocale} source '
                'for ${field.entryKey} ${field.fieldName}',
          ),
        );
      }
    }

    return List.unmodifiable(issues);
  }

  Map<String, Set<String>> _knownIdsByType(
    Course course,
    EducationalContentBundle contentBundle,
  ) {
    return {
      'course': {course.id},
      'module': {for (final module in course.modules) module.id},
      'lesson': {for (final lesson in course.lessons) lesson.id},
      'lesson_objective': {
        for (final lesson in course.lessons)
          for (final objective in lesson.objectives)
            '${lesson.id}.${objective.id}',
      },
      'lesson_section': {
        for (final lesson in course.lessons)
          for (final section in lesson.sections) section.id,
      },
      'lesson_activity': {
        for (final lesson in course.lessons)
          for (final activity in lesson.activities) activity.id,
      },
      'lesson_summary': {
        for (final lesson in course.lessons)
          if (lesson.summary != null) lesson.summary!.id,
      },
      'vocabulary': {
        for (final content in contentBundle.contents)
          if (content is VocabularyContent)
            for (final item in content.entries) item.id,
      },
      'grammar': {
        for (final content in contentBundle.contents)
          if (content is GrammarContent)
            for (final topic in content.topics) topic.id,
      },
      'dialogue': {
        for (final content in contentBundle.contents)
          if (content is DialogueContent)
            for (final dialogue in content.dialogues) dialogue.id,
      },
      'reading': {
        for (final content in contentBundle.contents)
          if (content is ReadingContent)
            for (final reading in content.texts) reading.id,
      },
      'exercise_template': {
        for (final content in contentBundle.contents)
          if (content is ExerciseTemplateContent)
            for (final template in content.templates) template.id,
      },
    };
  }
}

class EducationalContentLocalizationCoverage {
  const EducationalContentLocalizationCoverage({
    required this.locale,
    required this.totalFields,
    required this.translatedFields,
    required this.missingFields,
    required this.fallbackFields,
  });

  final SupportLocale locale;
  final int totalFields;
  final int translatedFields;
  final int missingFields;
  final int fallbackFields;

  double get coverage => totalFields == 0 ? 1 : translatedFields / totalFields;
}

class EducationalContentLocalizationCoverageReporter {
  const EducationalContentLocalizationCoverageReporter();

  List<EducationalContentLocalizationCoverage> report(
    EducationalContentLocalizationBundle bundle,
  ) {
    final fields = [for (final entry in bundle.entries) ...entry.fields.values];

    return List.unmodifiable([
      for (final locale in SupportLocale.supported.values)
        _coverageFor(locale, fields, bundle.sourceSupportLocale),
    ]);
  }

  EducationalContentLocalizationCoverage _coverageFor(
    SupportLocale locale,
    List<Map<String, String>> fields,
    String sourceSupportLocale,
  ) {
    var translated = 0;
    var missing = 0;
    var fallback = 0;

    for (final field in fields) {
      if (field.containsKey(locale.code)) {
        translated += 1;
      } else if (field.containsKey(sourceSupportLocale)) {
        fallback += 1;
      } else {
        missing += 1;
      }
    }

    return EducationalContentLocalizationCoverage(
      locale: locale,
      totalFields: fields.length,
      translatedFields: translated,
      missingFields: missing,
      fallbackFields: fallback,
    );
  }
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is String) {
    return value;
  }
  throw FormatException('Missing required string field: $key');
}

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is int) {
    return value;
  }
  throw FormatException('Missing required int field: $key');
}

bool _requiredBool(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is bool) {
    return value;
  }
  throw FormatException('Missing required bool field: $key');
}

String? _optionalString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is String) {
    return value;
  }
  throw FormatException('Invalid optional string field: $key');
}

List<String> _requiredStringList(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! List) {
    throw FormatException('Missing required string list field: $key');
  }
  return List.unmodifiable(
    value.map((item) {
      if (item is String) {
        return item;
      }
      throw FormatException('Expected string item in list field: $key');
    }),
  );
}

T _enumByName<T extends Enum>(List<T> values, String name, String fieldName) {
  for (final value in values) {
    if (value.name == name) {
      return value;
    }
  }
  throw FormatException('Invalid $fieldName: $name');
}
