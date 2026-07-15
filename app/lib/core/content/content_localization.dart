import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';

import '../../features/curriculum/curriculum_models.dart';
import '../content/content_document.dart';
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

class EducationalContentLocalizationResolver {
  EducationalContentLocalizationResolver(this.bundle)
    : _entriesByKey = {
        for (final entry in bundle.entries) '${entry.type}|${entry.id}': entry,
      };

  final EducationalContentLocalizationBundle bundle;
  final Map<String, LocalizedEducationalEntry> _entriesByKey;

  Course resolveCourse(Course course, SupportLocale locale) {
    return Course(
      id: course.id,
      languageId: course.languageId,
      title: _field('course', course.id, 'title', locale) ?? course.title,
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
      title: _field('module', module.id, 'title', locale) ?? module.title,
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
        title: _field('lesson', lessonId, 'title', locale) ?? metadata.title,
        description:
            _field('lesson', lessonId, 'description', locale) ??
            metadata.description,
        moduleId: metadata.moduleId,
        courseId: metadata.courseId,
        estimatedDurationMinutes: metadata.estimatedDurationMinutes,
        difficulty: metadata.difficulty,
        tags: metadata.tags,
        version: metadata.version,
        prerequisites: metadata.prerequisites,
      ),
      objectives: List.unmodifiable(
        lesson.objectives.map((objective) {
          return LessonObjective(
            id: objective.id,
            description:
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
          _field('lesson', lessonId, 'communicativeOutcome', locale) ??
          lesson.communicativeOutcome,
      sections: List.unmodifiable(
        lesson.sections.map((section) {
          return LessonSection(
            id: section.id,
            title:
                _field('lesson_section', section.id, 'title', locale) ??
                section.title,
            order: section.order,
            activities: List.unmodifiable(
              section.activities.map((activity) {
                return LessonActivity(
                  id: activity.id,
                  title:
                      _field('lesson_activity', activity.id, 'title', locale) ??
                      activity.title,
                  type: activity.type,
                  order: activity.order,
                  references: activity.references,
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
      spanish: item.spanish,
      nativeTranslation:
          _field('vocabulary', item.id, 'native_translation', locale) ??
          item.nativeTranslation,
      cefr: item.cefr,
      example: item.example,
      pronunciation: item.pronunciation,
      notes: _field('vocabulary', item.id, 'notes', locale) ?? item.notes,
    );
  }

  GrammarTopic resolveGrammarTopic(GrammarTopic topic, SupportLocale locale) {
    return GrammarTopic(
      id: topic.id,
      title: _field('grammar', topic.id, 'title', locale) ?? topic.title,
      explanation:
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
      title: _field('dialogue', dialogue.id, 'title', locale) ?? dialogue.title,
      vocabularyIds: dialogue.vocabularyIds,
      grammarIds: dialogue.grammarIds,
      lines: List.unmodifiable([
        for (var index = 0; index < dialogue.lines.length; index += 1)
          DialogueLine(
            speaker: dialogue.lines[index].speaker,
            spanish: dialogue.lines[index].spanish,
            nativeTranslation:
                _field(
                  'dialogue',
                  dialogue.id,
                  'lines.$index.native_translation',
                  locale,
                ) ??
                dialogue.lines[index].nativeTranslation,
          ),
      ]),
    );
  }

  ReadingText resolveReading(ReadingText reading, SupportLocale locale) {
    return ReadingText(
      id: reading.id,
      title: _field('reading', reading.id, 'title', locale) ?? reading.title,
      vocabularyIds: reading.vocabularyIds,
      grammarIds: reading.grammarIds,
      text: reading.text,
      nativeTranslation:
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
          _field('exercise_template', template.id, 'prompt_template', locale) ??
          template.promptTemplate,
      answerOptions: List.unmodifiable(
        template.answerOptions.map((option) {
          return ExerciseTemplateOption(
            id: option.id,
            label:
                _field(
                  'exercise_template',
                  template.id,
                  'answer_options.${option.id}.label',
                  locale,
                ) ??
                option.label,
          );
        }),
      ),
      correctOptionId: template.correctOptionId,
      expectedAnswer: template.expectedAnswer,
      acceptedAnswers: template.acceptedAnswers,
      acceptedWithFeedbackAnswers: template.acceptedWithFeedbackAnswers,
      requiresExactAnswer: template.requiresExactAnswer,
      authoredMisconceptions: template.authoredMisconceptions,
      reviewTemplateIds: template.reviewTemplateIds,
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
        _field(type, id, '$fieldPrefix.$index', locale) ?? fallback[index],
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

class EducationalContentLocalizationValidator {
  const EducationalContentLocalizationValidator();

  List<EducationalContentLocalizationValidationIssue> validate({
    required EducationalContentLocalizationBundle localization,
    required Course course,
    required EducationalContentBundle contentBundle,
  }) {
    final issues = <EducationalContentLocalizationValidationIssue>[];
    final knownIdsByType = _knownIdsByType(course, contentBundle);
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
