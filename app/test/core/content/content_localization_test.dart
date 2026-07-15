import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/content_localization.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'support locale follows supported UI language with English fallback',
    () {
      const resolver = SupportLocaleResolver();

      expect(resolver.resolveLanguageCode('en'), SupportLocale.english);
      expect(resolver.resolveLanguageCode('uk'), SupportLocale.ukrainian);
      expect(resolver.resolveLanguageCode('ru'), SupportLocale.russian);
      expect(resolver.resolveLanguageCode('pl'), SupportLocale.polish);
      expect(resolver.resolveLanguageCode('de'), SupportLocale.german);
      expect(resolver.resolveLanguageCode('fr'), SupportLocale.english);
      expect(
        resolver.resolveLocale(const Locale('ru', 'UA')),
        SupportLocale.russian,
      );
      expect(
        resolver.resolveLocale(const Locale('uk', 'UA')),
        SupportLocale.ukrainian,
      );
      expect(
        resolver.resolveLocale(const Locale('de', 'DE')),
        SupportLocale.german,
      );
      expect(
        resolver.resolveLocale(const Locale('pl', 'PL')),
        SupportLocale.polish,
      );
    },
  );

  test(
    'localized reference slice preserves stable ids and Spanish target text',
    () async {
      final localization = await _loadLocalization();
      final course = await CurriculumLoader().loadCourse();
      final content = await ContentLoader().loadLanguagePackContent();
      final resolver = EducationalContentLocalizationResolver(localization);

      final russianCourse = resolver.resolveCourse(
        course,
        SupportLocale.russian,
      );
      expect(russianCourse.id, course.id);
      expect(russianCourse.title, 'Испанский A0');
      expect(russianCourse.modules.first.id, course.modules.first.id);
      expect(russianCourse.modules.first.title, 'Первые слова и чтение');
      expect(russianCourse.lessons.first.id, course.lessons.first.id);
      expect(russianCourse.lessons.first.title, 'Приветствие и прощание');
      expect(
        russianCourse.lessons.first.description,
        'Поздоровайтесь и попрощайтесь короткими испанскими фразами.',
      );

      final vocab = content.contents
          .whereType<VocabularyContent>()
          .expand((content) => content.entries)
          .firstWhere((item) => item.id == 'vocab.es.a0.unit1.hola.v1');
      final localizedVocab = resolver.resolveVocabularyItem(
        vocab,
        SupportLocale.russian,
      );

      expect(localizedVocab.id, vocab.id);
      expect(localizedVocab.spanish, 'hola');
      expect(localizedVocab.nativeTranslation, 'привет');
      expect(localizedVocab.example, 'Hola, Ana.');

      final template = content.contents
          .whereType<ExerciseTemplateContent>()
          .expand((content) => content.templates)
          .firstWhere(
            (template) =>
                template.id == 'template.es.a0.unit1.greeting_choice.v1',
          );
      final localizedTemplate = resolver.resolveExerciseTemplate(
        template,
        SupportLocale.russian,
      );

      expect(localizedTemplate.id, template.id);
      expect(localizedTemplate.promptTemplate, 'Выберите значение «hola».');
      expect(localizedTemplate.correctOptionId, template.correctOptionId);
      expect(localizedTemplate.answerOptions.first.id, 'option.hello');
      expect(localizedTemplate.answerOptions.first.label, 'привет');
    },
  );

  test(
    'missing requested localization falls back to English at runtime',
    () async {
      final localization = await _loadLocalization();
      final course = await CurriculumLoader().loadCourse();
      final resolver = EducationalContentLocalizationResolver(localization);

      final germanCourse = resolver.resolveCourse(course, SupportLocale.german);

      expect(germanCourse.id, course.id);
      expect(germanCourse.title, 'Spanish A0');
      expect(germanCourse.lessons.first.title, 'Hello and Goodbye');
    },
  );

  test(
    'localization validation detects unknown ids, duplicates, source gaps',
    () async {
      final course = await CurriculumLoader().loadCourse();
      final content = await ContentLoader().loadLanguagePackContent();
      final invalid = EducationalContentLocalizationBundle(
        schemaVersion: 1,
        targetLanguage: 'es',
        sourceSupportLocale: 'en',
        supportLocales: const ['en', 'zz'],
        entries: const [
          LocalizedEducationalEntry(
            type: 'vocabulary',
            id: 'vocab.es.a0.unit1.hola.v1',
            fields: {
              'native_translation': {'ru': 'привет'},
            },
          ),
          LocalizedEducationalEntry(
            type: 'vocabulary',
            id: 'vocab.es.a0.unit1.hola.v1',
            fields: {
              'native_translation': {'en': 'hello'},
            },
          ),
          LocalizedEducationalEntry(
            type: 'vocabulary',
            id: 'missing.vocab',
            fields: {
              'native_translation': {'en': 'missing'},
            },
          ),
        ],
      );

      final issues = const EducationalContentLocalizationValidator().validate(
        localization: invalid,
        course: course,
        contentBundle: content,
      );

      expect(
        issues.map((issue) => issue.code),
        containsAll([
          'unsupported_locale',
          'missing_source_support_text',
          'duplicate_localization_entry',
          'unknown_localized_id',
          'unknown_localized_field',
        ]),
      );
    },
  );

  test(
    'English source inventory covers every localizable educational field',
    () async {
      final localization = await _loadLocalization();
      final course = await CurriculumLoader().loadCourse();
      final content = await ContentLoader().loadLanguagePackContent();
      final inventory = const EducationalContentLocalizationInventory().build(
        course: course,
        contentBundle: content,
      );
      final issues = const EducationalContentLocalizationValidator().validate(
        localization: localization,
        course: course,
        contentBundle: content,
      );
      final summaries = const EducationalContentLocalizationInventory()
          .summarize(inventory: inventory, localization: localization);

      expect(inventory.length, 2741);
      expect(
        summaries.map(
          (summary) => (
            summary.category,
            summary.totalLocalizableFields,
            summary.englishSourceFields,
            summary.missingEnglishSourceFields,
            summary.invalidFields,
          ),
        ),
        containsAll([
          ('course metadata', 1, 1, 0, 0),
          ('module metadata', 9, 9, 0, 0),
          ('lesson metadata', 210, 210, 0, 0),
          ('lesson objectives', 70, 70, 0, 0),
          ('lesson sections', 70, 70, 0, 0),
          ('lesson activities', 311, 311, 0, 0),
          ('lesson summaries', 70, 70, 0, 0),
          ('vocabulary', 515, 515, 0, 0),
          ('grammar', 374, 374, 0, 0),
          ('dialogues', 353, 353, 0, 0),
          ('readings', 152, 152, 0, 0),
          ('exercise prompts', 495, 495, 0, 0),
          ('support-language answer options', 111, 111, 0, 0),
        ]),
      );
      expect(issues, isEmpty);
    },
  );

  test(
    'inventory localizes support answer options without translating Spanish choices',
    () async {
      final course = await CurriculumLoader().loadCourse();
      final content = await ContentLoader().loadLanguagePackContent();
      final inventory = const EducationalContentLocalizationInventory().build(
        course: course,
        contentBundle: content,
      );
      final fieldKeys = inventory.map((field) => field.fieldKey).toSet();

      expect(
        fieldKeys,
        contains(
          'exercise_template|template.es.a0.unit1.greeting_choice.v1|'
          'answer_options.option.hello.label',
        ),
      );
      expect(
        fieldKeys,
        isNot(
          contains(
            'exercise_template|template.es.a0.m09.l061.condition_choice.v1|'
            'answer_options.bien.label',
          ),
        ),
      );
    },
  );

  test(
    'coverage report distinguishes source fields from fallback fields',
    () async {
      final localization = await _loadLocalization();
      final coverage = const EducationalContentLocalizationCoverageReporter()
          .report(localization);
      final english = coverage.firstWhere(
        (entry) => entry.locale == SupportLocale.english,
      );
      final russian = coverage.firstWhere(
        (entry) => entry.locale == SupportLocale.russian,
      );
      final ukrainian = coverage.firstWhere(
        (entry) => entry.locale == SupportLocale.ukrainian,
      );

      expect(english.totalFields, 2741);
      expect(english.translatedFields, english.totalFields);
      expect(english.fallbackFields, 0);
      expect(russian.totalFields, english.totalFields);
      expect(russian.translatedFields, greaterThan(0));
      expect(russian.fallbackFields, greaterThan(0));
      expect(ukrainian.totalFields, english.totalFields);
      expect(ukrainian.translatedFields, 0);
      expect(ukrainian.fallbackFields, ukrainian.totalFields);
    },
  );
}

Future<EducationalContentLocalizationBundle> _loadLocalization() {
  return EducationalContentLocalizationRepository(
    assetBundle: rootBundle,
  ).loadBundle();
}
