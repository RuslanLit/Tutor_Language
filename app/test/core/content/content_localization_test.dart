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
        ]),
      );
    },
  );

  test(
    'coverage report distinguishes translated fields from fallback fields',
    () async {
      final localization = await _loadLocalization();
      final coverage = const EducationalContentLocalizationCoverageReporter()
          .report(localization);
      final russian = coverage.firstWhere(
        (entry) => entry.locale == SupportLocale.russian,
      );
      final ukrainian = coverage.firstWhere(
        (entry) => entry.locale == SupportLocale.ukrainian,
      );

      expect(russian.totalFields, greaterThan(0));
      expect(russian.translatedFields, russian.totalFields);
      expect(russian.fallbackFields, 0);
      expect(ukrainian.totalFields, russian.totalFields);
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
