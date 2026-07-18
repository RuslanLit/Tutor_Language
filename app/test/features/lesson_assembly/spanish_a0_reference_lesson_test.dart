import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/educational_content_validator.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_assembly_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Spanish A0 starter content loads, validates, and assembles', () async {
    final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    const validator = EducationalContentValidator();

    final contentBundle = await contentLoader.loadSpanishContent();
    final catalog = EducationalContentCatalog(contentBundle);
    final lesson = await curriculumLoader.loadLesson(
      path: 'assets/languages/spanish/curriculum/lessons/es.a0.u01.l01.json',
    );

    expect(validator.validate(contentBundle), isEmpty);
    expect(
      validator.validateLessonReferences(lesson: lesson, catalog: catalog),
      isEmpty,
    );

    final service = LessonAssemblyService(
      curriculumLoader: curriculumLoader,
      contentLoader: contentLoader,
    );
    final assembled = await service.assembleLesson('es.a0.m06.l016');
    final resolvedContent = assembled.activities
        .expand((activity) => activity.resolvedContent)
        .toList();
    final vocabulary = resolvedContent.whereType<VocabularyItem>().toList();
    final grammar = resolvedContent.whereType<GrammarTopic>().toList();
    final dialogues = resolvedContent.whereType<Dialogue>().toList();
    final readings = resolvedContent.whereType<ReadingText>().toList();
    final templates = resolvedContent.whereType<ExerciseTemplate>().toList();

    expect(assembled.lesson.id, 'es.a0.m06.l016');
    expect(assembled.lesson.title, 'First Spanish Hello');
    expect(assembled.lesson.description, 'Read, understand, and type Hola.');
    expect(
      assembled.lesson.communicativeOutcome,
      'Produce a first Spanish hello.',
    );
    expect(assembled.activities.map((activity) => activity.activity.type), [
      'grammar',
      'grammar',
      'exercise_template',
      'exercise_template',
    ]);
    expect(vocabulary, isEmpty);
    expect(grammar.map((topic) => topic.id), [
      'grammar.es.a0.m01.l001.first_encounter.v1',
      'grammar.es.a0.m01.l001.read_hola.v1',
    ]);
    expect(dialogues, isEmpty);
    expect(readings, isEmpty);
    expect(templates.map((template) => template.id), [
      'template.es.a0.m01.l001.focus_hola.v1',
      'template.es.a0.m01.l001.meaning_hola.v1',
      'template.es.a0.m01.l001.decode_hola.v1',
      'template.es.a0.m01.l001.context_arrival_hola.v1',
      'template.es.a0.m01.l001.guided_type_hola.v1',
      'template.es.a0.m01.l001.independent_type_hola.v1',
    ]);
    expect(
      templates.map((template) => template.id),
      isNot(
        contains(
          'template.es.a0.m01.l001.interference_greeting_or_farewell.v1',
        ),
      ),
    );
    expect(templates.map((template) => template.exerciseType).toSet(), {
      'multiple_choice',
      'text_entry',
    });
    expect(
      templates
          .singleWhere(
            (template) =>
                template.id ==
                'template.es.a0.m01.l001.independent_type_hola.v1',
          )
          .promptTemplate,
      isNot(contains('Hola')),
    );
    expect(
      resolvedContent
          .map(
            (content) => switch (content) {
              GrammarTopic() => [
                content.title,
                content.explanation,
                ...content.examples,
              ],
              ExerciseTemplate() => [
                content.promptTemplate,
                ...content.answerOptions.map((option) => option.label),
              ],
              _ => const <String>[],
            },
          )
          .expand((text) => text)
          .join('\n'),
      allOf(
        isNot(contains('Adiós')),
        isNot(contains('Hasta luego')),
        isNot(contains('Gracias')),
        isNot(contains('Por favor')),
        isNot(contains('Ana')),
        isNot(contains('farewell')),
      ),
    );
  });

  test(
    'Spanish A0 early modules resolve across implemented production lessons',
    () async {
      final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
      final contentLoader = ContentLoader(assetBundle: rootBundle);
      final catalog = EducationalContentCatalog(
        await contentLoader.loadSpanishContent(),
      );
      const validator = EducationalContentValidator();

      final course = await curriculumLoader.loadCourse();
      final lessonIds = [
        'es.a0.m01.l001',
        'es.a0.m01.l002',
        'es.a0.m01.l003',
        'es.a0.m02.l004',
        'es.a0.m03.l013',
        'es.a0.m03.l014',
        'es.a0.m03.l015',
        'es.a0.m03.l016',
        'es.a0.m03.l017',
        'es.a0.m03.l018',
        'es.a0.m04.l010',
      ];

      for (final lessonId in lessonIds) {
        final lesson = course.lessons.singleWhere(
          (lesson) => lesson.id == lessonId,
        );

        expect(
          validator.validateLessonReferences(lesson: lesson, catalog: catalog),
          isEmpty,
        );
        expect(
          lesson.activities.expand((activity) => activity.contentReferences),
          isNotEmpty,
        );
      }

      final nameLesson = course.lessons.singleWhere(
        (lesson) => lesson.id == 'es.a0.m02.l004',
      );
      final nameReferenceIds = nameLesson.activities
          .expand((activity) => activity.contentReferences)
          .map((reference) => reference.referenceId)
          .whereType<String>()
          .toSet();

      expect(nameReferenceIds, contains('vocab.es.a0.unit1.me_llamo.v1'));
      expect(
        nameReferenceIds,
        contains('grammar.es.a0.m02.me_llamo_transfer.v1'),
      );
      expect(nameReferenceIds, contains('dialogue.es.a0.m02.school_names.v1'));

      final originLesson = course.lessons.singleWhere(
        (lesson) => lesson.id == 'es.a0.m03.l013',
      );
      final originReferenceIds = originLesson.activities
          .expand((activity) => activity.contentReferences)
          .map((reference) => reference.referenceId)
          .whereType<String>()
          .toSet();

      expect(originReferenceIds, contains('vocab.es.a0.m03.ucrania.v1'));
      expect(
        originReferenceIds,
        contains('grammar.es.a0.m03.origin_soy_de.v1'),
      );
      expect(originReferenceIds, contains('reading.es.a0.m03.origin_cards.v1'));

      final questionLesson = course.lessons.singleWhere(
        (lesson) => lesson.id == 'es.a0.m03.l014',
      );
      final questionReferenceIds = questionLesson.activities
          .expand((activity) => activity.contentReferences)
          .map((reference) => reference.referenceId)
          .whereType<String>()
          .toSet();

      expect(questionReferenceIds, contains('vocab.es.a0.m03.de_donde.v1'));
      expect(
        questionReferenceIds,
        contains('template.es.a0.m03.l014.type_de_donde_eres.v1'),
      );

      final languageLesson = course.lessons.singleWhere(
        (lesson) => lesson.id == 'es.a0.m03.l016',
      );
      final languageReferenceIds = languageLesson.activities
          .expand((activity) => activity.contentReferences)
          .map((reference) => reference.referenceId)
          .whereType<String>()
          .toSet();

      expect(languageReferenceIds, contains('vocab.es.a0.m03.espanol.v1'));
      expect(languageReferenceIds, contains('vocab.es.a0.m03.un_poco_de.v1'));

      final reviewLesson = course.lessons.singleWhere(
        (lesson) => lesson.id == 'es.a0.m04.l010',
      );
      final reviewReferenceIds = reviewLesson.activities
          .expand((activity) => activity.contentReferences)
          .map((reference) => reference.referenceId)
          .whereType<String>()
          .toSet();

      expect(
        reviewReferenceIds,
        contains('dialogue.es.a0.m01.review_first_words.v1'),
      );
      expect(
        reviewReferenceIds,
        contains('reading.es.a0.m01.review_first_words.v1'),
      );
      expect(
        reviewReferenceIds,
        contains('template.es.a0.m01.review.type_no_entiendo.v1'),
      );
    },
  );
}
