import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/educational_content_validator.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_assembly_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'every curriculum content reference resolves to matching content',
    () async {
      final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
      final contentLoader = ContentLoader(assetBundle: rootBundle);
      const validator = EducationalContentValidator();

      final course = await curriculumLoader.loadCourse();
      final contentBundle = await contentLoader.loadSpanishContent();
      final catalog = EducationalContentCatalog(contentBundle);

      expect(validator.validate(contentBundle), isEmpty);

      for (final lesson in course.lessons) {
        expect(
          validator.validateLessonReferences(lesson: lesson, catalog: catalog),
          isEmpty,
        );

        for (final activity in lesson.activities) {
          for (final reference in activity.contentReferences) {
            expect(reference.assetPath, isNotEmpty);
            expect(catalog.canResolve(reference), isTrue);

            final content = await contentLoader.loadContent(
              reference.assetPath,
            );

            expect(content.assetPath, reference.assetPath);
            expect(content.type, reference.type);
          }
        }
      }
    },
  );

  test('first lesson references concrete educational content ids', () async {
    final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    final catalog = EducationalContentCatalog(
      await contentLoader.loadSpanishContent(),
    );

    final course = await curriculumLoader.loadCourse();
    final lesson = course.lessons.firstWhere(
      (lesson) => lesson.id == 'es.a0.m01.l001',
    );

    final references = lesson.activities.expand(
      (activity) => activity.contentReferences,
    );
    final referenceIds = references
        .map((reference) => reference.referenceId)
        .whereType<String>()
        .toSet();

    expect(referenceIds, contains('vocab.es.a0.unit1.hola.v1'));
    expect(referenceIds, contains('vocab.es.a0.unit1.hasta_luego.v1'));
    expect(referenceIds, contains('dialogue.es.a0.unit1.hello_goodbye.v1'));
    expect(
      referenceIds,
      contains('reading.es.a0.unit1.greeting_recognition.v1'),
    );
    expect(referenceIds, contains('template.es.a0.unit1.greeting_choice.v1'));
    expect(references.every(catalog.canResolve), isTrue);
  });

  test(
    'E15 review and checkpoint lessons are concrete and checkable',
    () async {
      final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
      final contentLoader = ContentLoader(assetBundle: rootBundle);
      final service = LessonAssemblyService(
        curriculumLoader: curriculumLoader,
        contentLoader: contentLoader,
      );

      const completedLessonIds = [
        'es.a0.m04.l011',
        'es.a0.m04.l012',
        'es.a0.m05.l013',
        'es.a0.m05.l014',
        'es.a0.m05.l015',
      ];
      const placeholderActivityTitles = {
        'grammar',
        'exercise',
        'review',
        'checkpoint',
        'exercise_template',
      };

      for (final lessonId in completedLessonIds) {
        final assembled = await service.assembleLesson(lessonId);

        expect(assembled.activities, isNotEmpty);
        for (final activity in assembled.activities) {
          expect(
            placeholderActivityTitles,
            isNot(contains(activity.activity.title)),
            reason: 'Placeholder title in $lessonId/${activity.activity.id}',
          );
          expect(
            activity.activity.contentReferences,
            isNotEmpty,
            reason: 'Empty references in $lessonId/${activity.activity.id}',
          );
          expect(
            activity.resolvedContent,
            isNotEmpty,
            reason: 'No resolved content in $lessonId/${activity.activity.id}',
          );
        }

        final templates = assembled.activities
            .expand((activity) => activity.resolvedContent)
            .whereType<ExerciseTemplate>();

        for (final template in templates) {
          expect(
            _isCheckable(template),
            isTrue,
            reason: 'Uncheckable template ${template.id} in $lessonId',
          );
        }
      }
    },
  );

  test('referenced fill-gap and text-entry prompts are constrained', () async {
    final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    final catalog = EducationalContentCatalog(
      await contentLoader.loadSpanishContent(),
    );
    final course = await curriculumLoader.loadCourse();

    for (final lesson in course.lessons) {
      for (final activity in lesson.activities) {
        for (final reference in activity.contentReferences) {
          if (reference.type != 'exercise_template') {
            continue;
          }

          final referenceId = reference.referenceId;
          if (referenceId == null) {
            continue;
          }

          final template = catalog.lookupAs<ExerciseTemplate>(referenceId);
          expect(template, isNotNull);
          if (template == null ||
              (template.exerciseType != 'fill_gap' &&
                  template.exerciseType != 'text_entry')) {
            continue;
          }

          expect(
            _hasKnownAmbiguousShape(template.promptTemplate),
            isFalse,
            reason: 'Ambiguous prompt in ${template.id}',
          );
          expect(
            _hasExplicitPromptConstraint(template.promptTemplate),
            isTrue,
            reason: 'Missing prompt constraint in ${template.id}',
          );
        }
      }
    }
  });

  test('checkpoint assessment is separated from source material', () async {
    final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    final service = LessonAssemblyService(
      curriculumLoader: curriculumLoader,
      contentLoader: contentLoader,
    );

    final checkpoint = await service.assembleLesson('es.a0.m05.l015');
    final assessment = checkpoint.activities.singleWhere(
      (activity) => activity.activity.id == 'activity.practice.a0_checkpoint',
    );

    expect(
      assessment.resolvedContent,
      everyElement(isA<ExerciseTemplate>()),
      reason: 'Checkpoint assessment should not show source reading/dialogue.',
    );

    final typedTemplates = assessment.resolvedContent
        .whereType<ExerciseTemplate>()
        .where((template) => template.exerciseType == 'text_entry');

    for (final template in typedTemplates) {
      final expected = template.expectedAnswer;
      expect(expected, isNotNull);
      expect(
        template.promptTemplate.toLowerCase(),
        isNot(contains(expected!.toLowerCase())),
        reason: 'Typed checkpoint prompt exposes ${template.id}',
      );
    }
  });
}

bool _isCheckable(ExerciseTemplate template) {
  return switch (template.exerciseType) {
    'multiple_choice' =>
      template.correctOptionId != null && template.answerOptions.isNotEmpty,
    'fill_gap' || 'text_entry' => template.expectedAnswer != null,
    'matching' => template.expectedAnswer != null,
    _ => false,
  };
}

bool _hasKnownAmbiguousShape(String prompt) {
  const ambiguousSnippets = [
    'Complete the greeting:',
    'Complete the polite request:',
    'Complete the request:',
    'Complete the introduction:',
    'Complete the origin phrase:',
    'Complete the question:',
    'Complete the phrase:',
    'Complete the answer:',
    'Complete: "____ hambre."',
    'Complete: "Bien, ____."',
    'Complete: "Soy __ Madrid."',
    'Complete the sentence: "Tengo un ____."',
    'Complete the farewell:',
  ];

  return ambiguousSnippets.any(prompt.contains);
}

bool _hasExplicitPromptConstraint(String prompt) {
  const constraintMarkers = [
    'Spanish word',
    'Spanish phrase',
    'Spanish command',
    'Spanish sentence',
    'Spanish introduction',
    'Spanish origin phrase',
    'Spanish question word',
    'Spanish request',
    'fixed Spanish pattern',
    'first word',
    'form of tener',
    'word that finishes',
  ];

  return constraintMarkers.any(prompt.contains);
}
