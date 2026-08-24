import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:tutor_language/core/content/content_document.dart';
import 'package:tutor_language/core/content/content_localization.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

void main() {
  late EducationalContentLocalizationBundle bundle;
  late EducationalContentLocalizationResolver resolver;
  late Map<String, ExerciseTemplate> templates;
  late Course course;
  late EducationalContentBundle contentBundle;

  setUpAll(() {
    bundle = _loadLocalizationBundle();
    resolver = EducationalContentLocalizationResolver(bundle);
    templates = _loadExerciseTemplates();
    course = _loadCourse();
    contentBundle = _loadEducationalContentBundle();
  });

  group('Lesson 40 explicit answer-option localization', () {
    test('resolves Russian prompts and option labels', () {
      _expectLocalizedTemplate(
        resolver: resolver,
        templates: templates,
        templateId: 'template.es.a1.m10.l040.reading_sequence',
        locale: SupportLocale.russian,
        prompt:
            'Прочитай последовательность. Что человек делает после завтрака?',
        labels: const {
          'work': 'Работает.',
          'sleep': 'Спит.',
          'dinner': 'Ужинает.',
        },
      );
      _expectLocalizedTemplate(
        resolver: resolver,
        templates: templates,
        templateId: 'template.es.a1.m10.l040.listening_sequence_morning',
        locale: SupportLocale.russian,
        prompt:
            'Послушай всю последовательность без текстовой подсказки. Что происходит после подъёма?',
        labels: const {
          'breakfast': 'Завтрак.',
          'work': 'Работа.',
          'home': 'Возвращение домой.',
        },
      );
    });

    test('resolves English prompts and option labels', () {
      _expectLocalizedTemplate(
        resolver: resolver,
        templates: templates,
        templateId: 'template.es.a1.m10.l040.reading_sequence',
        locale: SupportLocale.english,
        prompt: 'Read the sequence. What does the person do after breakfast?',
        labels: const {
          'work': 'Works.',
          'sleep': 'Sleeps.',
          'dinner': 'Has dinner.',
        },
      );
      _expectLocalizedTemplate(
        resolver: resolver,
        templates: templates,
        templateId: 'template.es.a1.m10.l040.listening_sequence_morning',
        locale: SupportLocale.english,
        prompt:
            'Listen to the whole sequence without a text prompt. What happens after getting up?',
        labels: const {
          'breakfast': 'Breakfast.',
          'work': 'Work.',
          'home': 'Returning home.',
        },
      );
    });

    test('preserves Ukrainian prompts and option labels', () {
      _expectLocalizedTemplate(
        resolver: resolver,
        templates: templates,
        templateId: 'template.es.a1.m10.l040.reading_sequence',
        locale: SupportLocale.ukrainian,
        prompt: 'Прочитай послідовність. Що людина робить після сніданку?',
        labels: const {
          'work': 'Працює.',
          'sleep': 'Спить.',
          'dinner': 'Вечеряє.',
        },
      );
      _expectLocalizedTemplate(
        resolver: resolver,
        templates: templates,
        templateId: 'template.es.a1.m10.l040.listening_sequence_morning',
        locale: SupportLocale.ukrainian,
        prompt:
            'Послухай усю послідовність без текстової підказки. Що відбувається після підйому?',
        labels: const {
          'breakfast': 'Сніданок.',
          'work': 'Робота.',
          'home': 'Повернення додому.',
        },
      );
    });
  });

  test('every explicit answer-option localization is applied at runtime', () {
    final resolved = <String, ExerciseTemplate>{};
    final localizationEntries = {
      for (final entry in bundle.entries.where(
        (entry) => entry.type == 'exercise_template',
      ))
        entry.id: entry,
    };
    var explicitFieldCount = 0;
    var sourcePreservedCount = 0;

    ExerciseTemplate localized(
      ExerciseTemplate template,
      SupportLocale locale,
    ) {
      return resolved.putIfAbsent(
        '${template.id}|${locale.code}',
        () => resolver.resolveExerciseTemplate(template, locale),
      );
    }

    for (final entry in localizationEntries.values) {
      final template = templates[entry.id];
      expect(template, isNotNull, reason: 'Missing template ${entry.id}');

      for (final field in entry.fields.entries) {
        final match = RegExp(
          r'^answer_options\.(.+)\.label$',
        ).firstMatch(field.key);
        if (match == null) {
          continue;
        }
        explicitFieldCount += 1;
        final optionId = match.group(1)!;
        final sourceOption = template!.answerOptions.singleWhere(
          (option) => option.id == optionId,
        );

        for (final locale in const [
          SupportLocale.ukrainian,
          SupportLocale.russian,
          SupportLocale.english,
        ]) {
          final expected = field.value[locale.code];
          if (expected == null) {
            continue;
          }
          final actual = localized(
            template,
            locale,
          ).answerOptions.singleWhere((option) => option.id == optionId).label;
          expect(
            actual,
            expected,
            reason: '${entry.id}|${field.key}|${locale.code}',
          );
        }

        expect(sourceOption.id, optionId);
      }
    }

    for (final template in templates.values) {
      final fields = localizationEntries[template.id]?.fields ?? const {};
      for (final option in template.answerOptions) {
        final fieldName = 'answer_options.${option.id}.label';
        if (fields.containsKey(fieldName)) {
          continue;
        }
        sourcePreservedCount += 1;
        for (final locale in const [
          SupportLocale.ukrainian,
          SupportLocale.russian,
          SupportLocale.english,
        ]) {
          final actual = localized(
            template,
            locale,
          ).answerOptions.singleWhere((item) => item.id == option.id).label;
          expect(
            actual,
            option.label,
            reason: '${template.id}|${option.id}|${locale.code}',
          );
        }
      }
    }

    expect(explicitFieldCount, greaterThan(0));
    expect(sourcePreservedCount, greaterThan(0));
  });

  test('inventory covers every Lesson Player support-educational field', () {
    final inventory = const EducationalContentLocalizationInventory().build(
      course: course,
      contentBundle: contentBundle,
    );
    final inventoryKeys = {for (final field in inventory) field.fieldKey};
    final runtimeKeys = _runtimeSupportFieldKeys(course, contentBundle);

    expect(runtimeKeys.difference(inventoryKeys), isEmpty);
    expect(
      inventory
          .where((field) => field.category == 'guided dialogue learner cues')
          .length,
      14,
    );
    expect(
      inventory.where((field) => field.category == 'spoken practice').length,
      34,
    );
  });

  test('release-locale runtime support fields are complete', () {
    final inventory = const EducationalContentLocalizationInventory().build(
      course: course,
      contentBundle: contentBundle,
    );
    final localizedFields = {
      for (final entry in bundle.entries)
        for (final field in entry.fields.entries)
          '${entry.type}|${entry.id}|${field.key}': field.value,
    };
    final missingRu = <String>[];
    final missingEn = <String>[];

    final inventoryByKey = {
      for (final field in inventory) field.fieldKey: field,
    };
    final runtimeKeys = _runtimeSupportFieldKeys(course, contentBundle);
    for (final fieldKey in runtimeKeys) {
      expect(inventoryByKey[fieldKey], isNotNull, reason: fieldKey);
      final localized = localizedFields[fieldKey];
      if (localized?['ru'] == null) missingRu.add(fieldKey);
      if (localized?['en'] == null) missingEn.add(fieldKey);
    }

    expect(runtimeKeys, isNotEmpty);
    expect(missingRu, isEmpty);
    expect(missingEn, isEmpty);
  });

  test('guided-dialogue localization changes cues only', () {
    final source = templates['template.es.a1.m10.l040.guided_sequence']!;
    final localizedBundle = EducationalContentLocalizationBundle(
      schemaVersion: bundle.schemaVersion,
      targetLanguage: bundle.targetLanguage,
      sourceSupportLocale: bundle.sourceSupportLocale,
      supportLocales: bundle.supportLocales,
      entries: [
        LocalizedEducationalEntry(
          type: 'exercise_template',
          id: source.id,
          fields: const {
            'guided_dialogue.turns.1.learner_cue': {
              'uk': 'uk-cue',
              'ru': 'ru-cue',
              'en': 'en-cue',
            },
          },
        ),
      ],
    );
    final localized = EducationalContentLocalizationResolver(
      localizedBundle,
    ).resolveExerciseTemplate(source, SupportLocale.russian);
    final sourceDialogue = source.guidedDialogue!;
    final localizedDialogue = localized.guidedDialogue!;

    expect(localizedDialogue.turns[1].learnerCue, 'ru-cue');
    expect(localizedDialogue.turns[1].text, sourceDialogue.turns[1].text);
    expect(
      localizedDialogue.turns[1].responsePatterns,
      sourceDialogue.turns[1].responsePatterns,
    );
    expect(
      localizedDialogue.turns[1].allowedSlots,
      sourceDialogue.turns[1].allowedSlots,
    );
  });

  test('every explicit runtime support value is applied', () {
    final runtimeKeys = _runtimeSupportFieldKeys(course, contentBundle);
    final explicitFields = {
      for (final entry in bundle.entries)
        for (final field in entry.fields.entries)
          '${entry.type}|${entry.id}|${field.key}': field.value,
    };

    for (final locale in const [
      SupportLocale.ukrainian,
      SupportLocale.russian,
      SupportLocale.english,
    ]) {
      final resolved = _resolvedRuntimeSupportFields(
        resolver,
        course,
        contentBundle,
        locale,
      );
      for (final key in runtimeKeys) {
        final expected = explicitFields[key]?[locale.code];
        if (expected == null) continue;
        expect(resolved[key], expected, reason: '$key|${locale.code}');
      }
    }
  });

  test('target Spanish and evaluator fields remain unchanged', () {
    for (final source in templates.values) {
      for (final locale in const [
        SupportLocale.ukrainian,
        SupportLocale.russian,
        SupportLocale.english,
      ]) {
        final localized = resolver.resolveExerciseTemplate(source, locale);
        expect(localized.expectedAnswer, source.expectedAnswer);
        expect(localized.audioTranscript, source.audioTranscript);
        expect(localized.sentenceBuilder, source.sentenceBuilder);
        final sourceDialogue = source.guidedDialogue;
        final localizedDialogue = localized.guidedDialogue;
        if (sourceDialogue != null) {
          for (var index = 0; index < sourceDialogue.turns.length; index += 1) {
            expect(
              localizedDialogue!.turns[index].text,
              sourceDialogue.turns[index].text,
            );
            expect(
              localizedDialogue.turns[index].responsePatterns,
              sourceDialogue.turns[index].responsePatterns,
            );
            expect(
              localizedDialogue.turns[index].allowedSlots,
              sourceDialogue.turns[index].allowedSlots,
            );
            expect(
              localizedDialogue.turns[index].responseMode,
              sourceDialogue.turns[index].responseMode,
            );
          }
        }
      }
    }
  });

  test('Lesson Player generic UI is localized through AppLocalizations', () {
    final localized = {
      'uk': lookupAppLocalizations(const Locale('uk')),
      'ru': lookupAppLocalizations(const Locale('ru')),
      'en': lookupAppLocalizations(const Locale('en')),
    };
    for (final entry in localized.entries) {
      final l10n = entry.value;
      final values = [
        l10n.answerLabel,
        l10n.checkAnswer,
        l10n.previous,
        l10n.next,
        l10n.finishLesson,
        l10n.dialogueProgress(1, 2),
        l10n.learnerSpeakerLabel,
        l10n.correct,
        l10n.tryAgain,
        l10n.recommendedAnswer('Hola.'),
        l10n.audioListen,
        l10n.record,
        l10n.stopRecording,
        l10n.playMyRecording,
      ];
      expect(values, everyElement(isNotEmpty), reason: entry.key);
      if (entry.key == 'en') {
        expect(values.join(' '), isNot(matches(RegExp(r'[А-Яа-яІіЇїЄєҐґ]'))));
      }
    }
    expect(localized['ru']!.answerLabel, isNot(localized['uk']!.answerLabel));
    expect(localized['en']!.answerLabel, isNot(localized['uk']!.answerLabel));
  });
}

void _expectLocalizedTemplate({
  required EducationalContentLocalizationResolver resolver,
  required Map<String, ExerciseTemplate> templates,
  required String templateId,
  required SupportLocale locale,
  required String prompt,
  required Map<String, String> labels,
}) {
  final localized = resolver.resolveExerciseTemplate(
    templates[templateId]!,
    locale,
  );
  expect(localized.promptTemplate, prompt);
  expect({
    for (final option in localized.answerOptions) option.id: option.label,
  }, labels);
}

EducationalContentLocalizationBundle _loadLocalizationBundle() {
  final decoded =
      jsonDecode(
            File(
              'assets/languages/spanish/localization/support_localizations.json',
            ).readAsStringSync(),
          )
          as Map<String, Object?>;
  return EducationalContentLocalizationBundle.fromJson(decoded);
}

Map<String, ExerciseTemplate> _loadExerciseTemplates() {
  final templates = <String, ExerciseTemplate>{};
  final files =
      Directory('assets/languages/spanish/templates')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    final decoded = jsonDecode(file.readAsStringSync()) as List<dynamic>;
    for (final value in decoded) {
      final template = ExerciseTemplate.fromJson(
        Map<String, Object?>.from(value as Map),
      );
      expect(templates[template.id], isNull, reason: template.id);
      templates[template.id] = template;
    }
  }
  return templates;
}

Course _loadCourse() {
  final decoded =
      jsonDecode(
            File(
              'assets/languages/spanish/curriculum/course.json',
            ).readAsStringSync(),
          )
          as Map<String, Object?>;
  return Course.fromJson(decoded);
}

EducationalContentBundle _loadEducationalContentBundle() {
  final contents = <EducationalContent>[];
  for (final directory in const [
    'vocabulary',
    'grammar',
    'dialogues',
    'readings',
    'templates',
  ]) {
    final files =
        Directory('assets/languages/spanish/$directory')
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.json'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final file in files) {
      final items = (jsonDecode(file.readAsStringSync()) as List<dynamic>)
          .map((value) => Map<String, Object?>.from(value as Map))
          .toList(growable: false);
      contents.add(switch (directory) {
        'vocabulary' => VocabularyContent(
          assetPath: file.path,
          entries: items.map(VocabularyItem.fromJson).toList(growable: false),
        ),
        'grammar' => GrammarContent(
          assetPath: file.path,
          topics: items.map(GrammarTopic.fromJson).toList(growable: false),
        ),
        'dialogues' => DialogueContent(
          assetPath: file.path,
          dialogues: items.map(Dialogue.fromJson).toList(growable: false),
        ),
        'readings' => ReadingContent(
          assetPath: file.path,
          texts: items.map(ReadingText.fromJson).toList(growable: false),
        ),
        'templates' => ExerciseTemplateContent(
          assetPath: file.path,
          templates: items
              .map(ExerciseTemplate.fromJson)
              .toList(growable: false),
        ),
        _ => throw StateError(directory),
      });
    }
  }
  return EducationalContentBundle(contents: List.unmodifiable(contents));
}

Set<String> _runtimeSupportFieldKeys(
  Course course,
  EducationalContentBundle contentBundle,
) {
  final keys = <String>{};
  final reachableIds = <String, Set<String>>{};
  void add(String type, String id, String field) =>
      keys.add('$type|$id|$field');

  for (final lesson in course.lessons) {
    add('lesson', lesson.id, 'title');
    add('lesson', lesson.id, 'description');
    for (final activity in lesson.activities) {
      add('lesson_activity', activity.id, 'title');
      final spoken = activity.spokenPractice;
      if (spoken != null) {
        add('lesson_activity', activity.id, 'spokenPractice.prompt');
        if (spoken.focusCue != null && spoken.focusCue!.trim().isNotEmpty) {
          add('lesson_activity', activity.id, 'spokenPractice.focusCue');
        }
      }
      for (final reference in activity.references) {
        final referenceId = reference.referenceId;
        if (referenceId != null) {
          reachableIds
              .putIfAbsent(reference.type, () => <String>{})
              .add(referenceId);
        }
      }
    }
  }

  bool reachable(String type, String id) =>
      reachableIds[type]?.contains(id) ?? false;

  for (final content in contentBundle.contents) {
    switch (content) {
      case VocabularyContent(:final entries):
        for (final item in entries.where(
          (item) => reachable('vocabulary', item.id),
        )) {
          add('vocabulary', item.id, 'native_translation');
          if (item.notes != null && item.notes!.trim().isNotEmpty) {
            add('vocabulary', item.id, 'notes');
          }
        }
      case GrammarContent(:final topics):
        for (final topic in topics.where(
          (topic) => reachable('grammar', topic.id),
        )) {
          add('grammar', topic.id, 'title');
          add('grammar', topic.id, 'explanation');
          for (var index = 0; index < topic.examples.length; index += 1) {
            add('grammar', topic.id, 'examples.$index');
          }
        }
      case DialogueContent(:final dialogues):
        for (final dialogue in dialogues.where(
          (dialogue) => reachable('dialogue', dialogue.id),
        )) {
          add('dialogue', dialogue.id, 'title');
          for (var index = 0; index < dialogue.lines.length; index += 1) {
            add('dialogue', dialogue.id, 'lines.$index.native_translation');
          }
        }
      case ReadingContent(:final texts):
        for (final reading in texts.where(
          (reading) => reachable('reading', reading.id),
        )) {
          add('reading', reading.id, 'title');
          add('reading', reading.id, 'native_translation');
        }
      case ExerciseTemplateContent(:final templates):
        for (final template in templates.where(
          (template) => reachable('exercise_template', template.id),
        )) {
          add('exercise_template', template.id, 'prompt_template');
          for (final option in template.answerOptions) {
            if (shouldLocalizeSupportAnswerOption(
              promptTemplate: template.promptTemplate,
              optionLabel: option.label,
            )) {
              add(
                'exercise_template',
                template.id,
                'answer_options.${option.id}.label',
              );
            }
          }
          final dialogue = template.guidedDialogue;
          if (dialogue != null) {
            for (var index = 0; index < dialogue.turns.length; index += 1) {
              final cue = dialogue.turns[index].learnerCue;
              if (cue != null && cue.trim().isNotEmpty) {
                add(
                  'exercise_template',
                  template.id,
                  'guided_dialogue.turns.$index.learner_cue',
                );
              }
            }
          }
        }
      default:
        break;
    }
  }
  return keys;
}

Map<String, String> _resolvedRuntimeSupportFields(
  EducationalContentLocalizationResolver resolver,
  Course course,
  EducationalContentBundle contentBundle,
  SupportLocale locale,
) {
  final values = <String, String>{};
  void add(String type, String id, String field, String? value) {
    if (value != null && value.trim().isNotEmpty) {
      values['$type|$id|$field'] = value;
    }
  }

  final localizedCourse = resolver.resolveCourse(course, locale);
  for (final lesson in localizedCourse.lessons) {
    add('lesson', lesson.id, 'title', lesson.title);
    add('lesson', lesson.id, 'description', lesson.description);
    for (final activity in lesson.activities) {
      add('lesson_activity', activity.id, 'title', activity.title);
      final spoken = activity.spokenPractice;
      if (spoken != null) {
        add(
          'lesson_activity',
          activity.id,
          'spokenPractice.prompt',
          spoken.prompt,
        );
        add(
          'lesson_activity',
          activity.id,
          'spokenPractice.focusCue',
          spoken.focusCue,
        );
      }
    }
  }

  for (final content in contentBundle.contents) {
    switch (content) {
      case VocabularyContent(:final entries):
        for (final source in entries) {
          final item = resolver.resolveVocabularyItem(source, locale);
          add(
            'vocabulary',
            item.id,
            'native_translation',
            item.nativeTranslation,
          );
          add('vocabulary', item.id, 'notes', item.notes);
        }
      case GrammarContent(:final topics):
        for (final source in topics) {
          final topic = resolver.resolveGrammarTopic(source, locale);
          add('grammar', topic.id, 'title', topic.title);
          add('grammar', topic.id, 'explanation', topic.explanation);
          for (var index = 0; index < topic.examples.length; index += 1) {
            add('grammar', topic.id, 'examples.$index', topic.examples[index]);
          }
        }
      case DialogueContent(:final dialogues):
        for (final source in dialogues) {
          final dialogue = resolver.resolveDialogue(source, locale);
          add('dialogue', dialogue.id, 'title', dialogue.title);
          for (var index = 0; index < dialogue.lines.length; index += 1) {
            add(
              'dialogue',
              dialogue.id,
              'lines.$index.native_translation',
              dialogue.lines[index].nativeTranslation,
            );
          }
        }
      case ReadingContent(:final texts):
        for (final source in texts) {
          final reading = resolver.resolveReading(source, locale);
          add('reading', reading.id, 'title', reading.title);
          add(
            'reading',
            reading.id,
            'native_translation',
            reading.nativeTranslation,
          );
        }
      case ExerciseTemplateContent(:final templates):
        for (final source in templates) {
          final template = resolver.resolveExerciseTemplate(source, locale);
          add(
            'exercise_template',
            template.id,
            'prompt_template',
            template.promptTemplate,
          );
          for (final option in template.answerOptions) {
            add(
              'exercise_template',
              template.id,
              'answer_options.${option.id}.label',
              option.label,
            );
          }
          final dialogue = template.guidedDialogue;
          if (dialogue != null) {
            for (var index = 0; index < dialogue.turns.length; index += 1) {
              add(
                'exercise_template',
                template.id,
                'guided_dialogue.turns.$index.learner_cue',
                dialogue.turns[index].learnerCue,
              );
            }
          }
        }
      default:
        break;
    }
  }
  return values;
}
