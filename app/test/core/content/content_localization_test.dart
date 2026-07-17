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
    'reset educational locales preserve stable ids and Spanish target text',
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
      expect(russianCourse.title, 'Spanish A0');
      expect(russianCourse.modules.first.id, course.modules.first.id);
      expect(russianCourse.modules.first.title, 'First Words and Reading');
      expect(russianCourse.lessons.first.id, course.lessons.first.id);
      expect(russianCourse.lessons.first.title, 'Hello and Goodbye');
      expect(
        russianCourse.lessons.first.description,
        course.lessons.first.description,
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
      expect(localizedVocab.nativeTranslation, 'hello');
      expect(localizedVocab.example, 'Hola.');

      final template = content.contents
          .whereType<ExerciseTemplateContent>()
          .expand((content) => content.templates)
          .firstWhere(
            (template) =>
                template.id == 'template.es.a0.m01.l001.meaning_hola.v1',
          );
      final localizedTemplate = resolver.resolveExerciseTemplate(
        template,
        SupportLocale.russian,
      );

      expect(localizedTemplate.id, template.id);
      expect(localizedTemplate.promptTemplate, 'What does Hola mean?');
      expect(localizedTemplate.correctOptionId, template.correctOptionId);
      expect(localizedTemplate.answerOptions.first.id, 'option.hello');
      expect(localizedTemplate.answerOptions.first.label, 'hello');
    },
  );

  test(
    'Russian support localization is reset to explicit English fallback',
    () async {
      final localization = await _loadLocalization();
      final course = await CurriculumLoader().loadCourse();
      final content = await ContentLoader().loadLanguagePackContent();
      final resolver = EducationalContentLocalizationResolver(localization);

      final russianCourse = resolver.resolveCourse(
        course,
        SupportLocale.russian,
      );

      expect(russianCourse.modules.first.title, 'First Words and Reading');

      final profileReading = content.contents
          .whereType<ReadingContent>()
          .expand((content) => content.readings)
          .firstWhere(
            (reading) => reading.id == 'reading.es.a0.m02.profile_cards.v1',
          );
      final localizedReading = resolver.resolveReading(
        profileReading,
        SupportLocale.russian,
      );

      expect(localizedReading.title, 'Profile Cards');
      expect(localizedReading.text, profileReading.text);

      final originTemplate = content.contents
          .whereType<ExerciseTemplateContent>()
          .expand((content) => content.templates)
          .firstWhere(
            (template) =>
                template.id == 'template.es.a0.m03.l014.type_de_donde_eres.v1',
          );
      final localizedOriginTemplate = resolver.resolveExerciseTemplate(
        originTemplate,
        SupportLocale.russian,
      );

      expect(
        localizedOriginTemplate.promptTemplate,
        'Type the Spanish question: "Where are you from?"',
      );
      expect(
        localizedOriginTemplate.correctOptionId,
        originTemplate.correctOptionId,
      );
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

      expect(inventory.length, 2759);
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
          ('lesson activities', 312, 312, 0, 0),
          ('lesson summaries', 70, 70, 0, 0),
          ('vocabulary', 515, 515, 0, 0),
          ('grammar', 379, 379, 0, 0),
          ('dialogues', 353, 353, 0, 0),
          ('readings', 152, 152, 0, 0),
          ('exercise prompts', 502, 502, 0, 0),
          ('support-language answer options', 116, 116, 0, 0),
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
          'exercise_template|template.es.a0.m01.l001.meaning_hola.v1|'
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

      expect(english.totalFields, 2759);
      expect(english.translatedFields, english.totalFields);
      expect(english.fallbackFields, 0);
      expect(russian.totalFields, english.totalFields);
      expect(russian.translatedFields, 0);
      expect(russian.fallbackFields, russian.totalFields);
      expect(ukrainian.totalFields, english.totalFields);
      expect(ukrainian.translatedFields, 0);
      expect(ukrainian.fallbackFields, ukrainian.totalFields);
    },
  );

  test('Russian legacy educational fields are inactive', () async {
    final localization = await _loadLocalization();
    expect(_activeLocaleFields(localization, 'ru'), 0);
  });

  test('Ukrainian legacy educational fields are inactive', () async {
    final localization = await _loadLocalization();
    expect(_activeLocaleFields(localization, 'uk'), 0);
  });
}

Future<EducationalContentLocalizationBundle> _loadLocalization() {
  return EducationalContentLocalizationRepository(
    assetBundle: rootBundle,
  ).loadBundle();
}

int _activeLocaleFields(
  EducationalContentLocalizationBundle bundle,
  String locale,
) {
  var count = 0;
  for (final entry in bundle.entries) {
    for (final field in entry.fields.values) {
      if (field[locale]?.trim().isNotEmpty ?? false) {
        count += 1;
      }
    }
  }
  return count;
}
