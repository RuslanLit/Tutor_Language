import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/educational_content_validator.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';
import 'package:tutor_language/features/activity_engine/activity_engine.dart';
import 'package:tutor_language/features/activity_engine/activity_result.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_assembly_service.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_step.dart';

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
      (lesson) => lesson.id == 'es.a0.m06.l016',
    );

    final references = lesson.activities.expand(
      (activity) => activity.contentReferences,
    );
    final referenceIds = references
        .map((reference) => reference.referenceId)
        .whereType<String>()
        .toSet();

    expect(referenceIds, contains('grammar.es.a0.m01.l001.first_encounter.v1'));
    expect(referenceIds, contains('grammar.es.a0.m01.l001.read_hola.v1'));
    expect(referenceIds, contains('template.es.a0.m01.l001.focus_hola.v1'));
    expect(referenceIds, contains('template.es.a0.m01.l001.meaning_hola.v1'));
    expect(referenceIds, contains('template.es.a0.m01.l001.decode_hola.v1'));
    expect(
      referenceIds,
      contains('template.es.a0.m01.l001.context_arrival_hola.v1'),
    );
    expect(
      referenceIds,
      contains('template.es.a0.m01.l001.guided_type_hola.v1'),
    );
    expect(
      referenceIds,
      contains('template.es.a0.m01.l001.independent_type_hola.v1'),
    );
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
        'es.a0.m03.l018',
        'es.a0.m03.l019',
        'es.a0.m04.l026',
        'es.a0.m04.l027',
        'es.a0.m05.l013',
        'es.a0.m05.l034',
        'es.a0.m05.l035',
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

  test(
    'lesson player exposes one checkable exercise per runtime step',
    () async {
      final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
      final contentLoader = ContentLoader(assetBundle: rootBundle);
      final service = LessonAssemblyService(
        curriculumLoader: curriculumLoader,
        contentLoader: contentLoader,
      );
      const stepBuilder = LessonPlayerStepBuilder();

      final course = await curriculumLoader.loadCourse();

      for (final lesson in course.lessons) {
        final assembled = await service.assembleLesson(lesson.id);
        final steps = stepBuilder.buildSteps(assembled);

        expect(steps, isNotEmpty, reason: 'No player steps for ${lesson.id}');

        for (final step in steps) {
          final templates = step.content.whereType<ExerciseTemplate>().toList();
          expect(
            templates.length,
            lessThanOrEqualTo(1),
            reason: 'Step ${step.id} contains multiple exercise templates.',
          );

          if (templates.isNotEmpty) {
            expect(
              templates,
              hasLength(1),
              reason: 'Exercise step ${step.id} lacks one exercise template.',
            );
            expect(
              _isCheckable(templates.single),
              isTrue,
              reason: 'Uncheckable template ${templates.single.id}.',
            );
            expect(
              step.isCheckable,
              isTrue,
              reason: 'Exercise step ${step.id} is not marked checkable.',
            );
          }
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

    final checkpoint = await service.assembleLesson('es.a0.m03.l019');
    final assessment = checkpoint.activities.singleWhere(
      (activity) => activity.activity.id == 'es.a0.m03.l019.activity.practice',
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

  test(
    'C2 Spanish A0 expansion has substantial varied recall coverage',
    () async {
      final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
      final contentLoader = ContentLoader(assetBundle: rootBundle);
      final course = await curriculumLoader.loadCourse();
      final contentBundle = await contentLoader.loadSpanishContent();
      final catalog = EducationalContentCatalog(contentBundle);

      final vocabularyCount = contentBundle.contents
          .whereType<VocabularyContent>()
          .expand((content) => content.entries)
          .length;
      final dialogueCount = contentBundle.contents
          .whereType<DialogueContent>()
          .expand((content) => content.dialogues)
          .length;
      final readingCount = contentBundle.contents
          .whereType<ReadingContent>()
          .expand((content) => content.texts)
          .length;
      final templateCount = contentBundle.contents
          .whereType<ExerciseTemplateContent>()
          .expand((content) => content.templates)
          .length;

      final referencedTemplates = <ExerciseTemplate>[];
      for (final lesson in course.lessons) {
        for (final activity in lesson.activities) {
          for (final reference in activity.contentReferences) {
            if (reference.type != 'exercise_template' ||
                reference.referenceId == null) {
              continue;
            }
            final template = catalog.lookupAs<ExerciseTemplate>(
              reference.referenceId!,
            );
            expect(template, isNotNull, reason: reference.referenceId);
            referencedTemplates.add(template!);
          }
        }
      }

      expect(course.lessons, hasLength(greaterThanOrEqualTo(24)));
      expect(course.lessons, hasLength(lessThanOrEqualTo(70)));
      expect(vocabularyCount, inInclusiveRange(150, 410));
      expect(dialogueCount, greaterThanOrEqualTo(25));
      expect(readingCount, greaterThanOrEqualTo(18));
      expect(templateCount, greaterThanOrEqualTo(100));
      expect(
        referencedTemplates
            .where((template) => template.exerciseType == 'text_entry')
            .length,
        greaterThanOrEqualTo(40),
      );
      expect(
        referencedTemplates
            .where((template) => template.authoredMisconceptions.isNotEmpty)
            .length,
        greaterThanOrEqualTo(5),
      );
      expect(
        referencedTemplates
            .where((template) => template.reviewTemplateIds.isNotEmpty)
            .length,
        greaterThanOrEqualTo(8),
      );

      final reviewAndCheckpointLessons = course.lessons.where(
        (lesson) =>
            lesson.title.toLowerCase().contains('review') ||
            lesson.title.toLowerCase().contains('checkpoint'),
      );

      for (final lesson in reviewAndCheckpointLessons) {
        final templates = lesson.activities
            .expand((activity) => activity.contentReferences)
            .where((reference) => reference.type == 'exercise_template')
            .map((reference) => reference.referenceId)
            .whereType<String>()
            .map(catalog.lookupAs<ExerciseTemplate>)
            .whereType<ExerciseTemplate>()
            .toList();

        expect(
          templates.any((template) => template.exerciseType == 'text_entry'),
          isTrue,
          reason: '${lesson.id} should include typed recall.',
        );
      }

      final allTemplateText = referencedTemplates
          .map(
            (template) =>
                '${template.promptTemplate} ${template.expectedAnswer ?? ''}',
          )
          .join('\n');
      expect(_occurrences(allTemplateText, 'Me llamo Ana'), lessThan(10));
      expect(_occurrences(allTemplateText, 'Soy de Madrid'), lessThan(10));
      expect(_occurrences(allTemplateText, 'Tengo un libro'), lessThan(10));
    },
  );

  test('C2B Module 1 follows first-words pedagogical targets', () async {
    final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    final service = LessonAssemblyService(
      curriculumLoader: curriculumLoader,
      contentLoader: contentLoader,
    );
    final course = await curriculumLoader.loadCourse();
    final contentBundle = await contentLoader.loadSpanishContent();
    final catalog = EducationalContentCatalog(contentBundle);

    final module = course.modules.singleWhere(
      (module) => module.id == 'es.a0.m01',
    );
    expect(module.title, 'First Words and Reading');
    expect(module.lessonIds, [
      'es.a0.m06.l016',
      'es.a0.m01.l001',
      'es.a0.m06.l017',
      'es.a0.m01.l002',
      'es.a0.m01.l003',
      'es.a0.m01.l006',
      'es.a0.m04.l010',
    ]);

    final referencedLessonIds = course.modules
        .expand((module) => module.lessonIds)
        .toList();
    expect(referencedLessonIds.toSet(), hasLength(referencedLessonIds.length));
    expect(
      course.modules
          .singleWhere((module) => module.id == 'es.a0.m04')
          .lessonIds,
      isNot(contains('es.a0.m04.l010')),
    );
    expect(
      course.modules
          .singleWhere((module) => module.id == 'es.a0.m06')
          .lessonIds,
      isNot(contains('es.a0.m06.l016')),
    );
    expect(
      course.modules.expand((module) => module.lessonIds).toSet(),
      hasLength(referencedLessonIds.length),
    );

    final templates = <ExerciseTemplate>[];
    final misconceptionTemplates = <ExerciseTemplate>[];
    final reviewReferenceTemplates = <ExerciseTemplate>[];

    for (final lessonId in module.lessonIds) {
      final assembled = await service.assembleLesson(lessonId);
      expect(assembled.activities, isNotEmpty);

      final lesson = course.lessons.singleWhere(
        (lesson) => lesson.id == lessonId,
      );
      expect(lesson.moduleId, 'es.a0.m01');
      expect(lesson.communicativeOutcome, isNotNull);

      final lessonTemplates = lesson.activities
          .expand((activity) => activity.contentReferences)
          .where((reference) => reference.type == 'exercise_template')
          .map((reference) => reference.referenceId)
          .whereType<String>()
          .map(catalog.lookupAs<ExerciseTemplate>)
          .whereType<ExerciseTemplate>()
          .toList();

      expect(
        lessonTemplates.any(
          (template) => template.exerciseType == 'text_entry',
        ),
        isTrue,
        reason: '$lessonId should include typed recall.',
      );
      templates.addAll(lessonTemplates);
      misconceptionTemplates.addAll(
        lessonTemplates.where(
          (template) => template.authoredMisconceptions.isNotEmpty,
        ),
      );
      reviewReferenceTemplates.addAll(
        lessonTemplates.where(
          (template) => template.reviewTemplateIds.isNotEmpty,
        ),
      );
    }

    final typeCounts = <String, int>{};
    for (final template in templates) {
      typeCounts.update(
        template.exerciseType,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    final total = templates.length;
    final typedShare = (typeCounts['text_entry'] ?? 0) / total;
    final fillShare = (typeCounts['fill_gap'] ?? 0) / total;
    final recognitionShare = (typeCounts['multiple_choice'] ?? 0) / total;

    expect(total, 32);
    expect(typedShare, inInclusiveRange(0.40, 0.50));
    expect(fillShare, inInclusiveRange(0.18, 0.30));
    expect(recognitionShare, inInclusiveRange(0.30, 0.36));
    expect(misconceptionTemplates, hasLength(greaterThanOrEqualTo(4)));
    expect(reviewReferenceTemplates, hasLength(greaterThanOrEqualTo(8)));

    final reviewLesson = course.lessons.singleWhere(
      (lesson) => lesson.id == 'es.a0.m04.l010',
    );
    final reviewIds = reviewLesson.activities
        .expand((activity) => activity.contentReferences)
        .map((reference) => reference.referenceId)
        .whereType<String>()
        .toSet();
    expect(reviewIds, contains('vocab.es.a0.unit1.hola.v1'));
    expect(reviewIds, contains('vocab.es.a0.unit1.por_favor.v1'));
    expect(reviewIds, contains('vocab.es.a0.unit1.no_entiendo.v1'));
    expect(reviewIds, contains('vocab.es.a0.unit1.buenos_dias.v1'));
    expect(reviewIds, contains('dialogue.es.a0.m01.review_first_words.v1'));
    expect(reviewIds, contains('reading.es.a0.m01.review_first_words.v1'));
    expect(reviewIds, contains('template.es.a0.m01.review.type_hola.v1'));
  });

  test('C2C Module 2 teaches varied names and introductions', () async {
    final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    final service = LessonAssemblyService(
      curriculumLoader: curriculumLoader,
      contentLoader: contentLoader,
    );
    final course = await curriculumLoader.loadCourse();
    final contentBundle = await contentLoader.loadSpanishContent();
    final catalog = EducationalContentCatalog(contentBundle);

    final module = course.modules.singleWhere(
      (module) => module.id == 'es.a0.m02',
    );
    expect(module.title, 'Names and Introductions');
    expect(module.lessonIds, [
      'es.a0.m02.l004',
      'es.a0.m02.l007',
      'es.a0.m02.l008',
      'es.a0.m02.l009',
      'es.a0.m05.l013',
    ]);
    expect(module.lessonIds, isNot(contains('es.a0.m02.l005')));
    expect(module.lessonIds, isNot(contains('es.a0.m02.l006')));

    final templates = <ExerciseTemplate>[];
    final moduleText = StringBuffer();

    for (final lessonId in module.lessonIds) {
      final assembled = await service.assembleLesson(lessonId);
      expect(assembled.activities, isNotEmpty);

      final lesson = course.lessons.singleWhere(
        (lesson) => lesson.id == lessonId,
      );
      expect(lesson.moduleId, 'es.a0.m02');
      expect(lesson.communicativeOutcome, isNotNull);

      final lessonTemplates = lesson.activities
          .expand((activity) => activity.contentReferences)
          .where((reference) => reference.type == 'exercise_template')
          .map((reference) => reference.referenceId)
          .whereType<String>()
          .map(catalog.lookupAs<ExerciseTemplate>)
          .whereType<ExerciseTemplate>()
          .toList();

      expect(
        lessonTemplates.any(
          (template) => template.exerciseType == 'text_entry',
        ),
        isTrue,
        reason: '$lessonId should include typed recall.',
      );
      templates.addAll(lessonTemplates);

      for (final content in assembled.activities.expand(
        (activity) => activity.resolvedContent,
      )) {
        switch (content) {
          case VocabularyItem():
            moduleText.writeln(content.spanish);
          case GrammarTopic():
            moduleText.writeln(
              '${content.explanation} ${content.examples.join(' ')}',
            );
          case Dialogue():
            for (final line in content.lines) {
              moduleText.writeln(line.spanish);
            }
          case ReadingText():
            moduleText.writeln(content.text);
          case ExerciseTemplate():
            moduleText.writeln(
              '${content.promptTemplate} ${content.expectedAnswer ?? ''}',
            );
        }
      }
    }

    final typeCounts = <String, int>{};
    for (final template in templates) {
      typeCounts.update(
        template.exerciseType,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    final total = templates.length;
    expect(total, 22);
    expect(
      (typeCounts['text_entry'] ?? 0) / total,
      inInclusiveRange(0.40, 0.50),
    );
    expect((typeCounts['fill_gap'] ?? 0) / total, inInclusiveRange(0.20, 0.30));
    expect(
      (typeCounts['multiple_choice'] ?? 0) / total,
      inInclusiveRange(0.20, 0.30),
    );
    expect(
      templates.where((template) => template.authoredMisconceptions.isNotEmpty),
      hasLength(greaterThanOrEqualTo(5)),
    );
    expect(
      templates.where((template) => template.reviewTemplateIds.isNotEmpty),
      hasLength(greaterThanOrEqualTo(10)),
    );

    final text = moduleText.toString();
    expect(text, isNot(contains('Me llamo Ana')));
    expect(text, isNot(contains('Soy de Madrid')));

    const variedNames = [
      'María',
      'Carlos',
      'Sofía',
      'Elena',
      'Javier',
      'Laura',
      'Diego',
      'Marta',
      'Carmen',
    ];
    expect(
      variedNames.where((name) => text.contains(name)).length,
      greaterThanOrEqualTo(8),
    );
    expect(_occurrences(text, 'Carlos'), lessThanOrEqualTo(6));
    expect(_occurrences(text, 'Valencia'), lessThanOrEqualTo(6));

    final reviewLesson = course.lessons.singleWhere(
      (lesson) => lesson.id == 'es.a0.m05.l013',
    );
    final reviewIds = reviewLesson.activities
        .expand((activity) => activity.contentReferences)
        .map((reference) => reference.referenceId)
        .whereType<String>()
        .toSet();
    expect(reviewIds, contains('vocab.es.a0.unit1.hola.v1'));
    expect(reviewIds, contains('vocab.es.a0.unit1.como_te_llamas.v1'));
    expect(reviewIds, contains('vocab.es.a0.m02.marta.v1'));
    expect(reviewIds, contains('dialogue.es.a0.m02.review_introductions.v1'));
    expect(reviewIds, contains('reading.es.a0.m02.review_directory.v1'));
    expect(reviewIds, contains('template.es.a0.m02.review.type_question.v1'));
  });

  test('QA1 Modules 1-4 active recall and answer acceptance audit', () async {
    final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    final course = await curriculumLoader.loadCourse();
    final contentBundle = await contentLoader.loadSpanishContent();
    final catalog = EducationalContentCatalog(contentBundle);

    final auditedLessonIds = course.modules
        .where(
          (module) => const {
            'es.a0.m01',
            'es.a0.m02',
            'es.a0.m03',
            'es.a0.m04',
          }.contains(module.id),
        )
        .expand((module) => module.lessonIds)
        .toSet();
    final auditedTemplates = <ExerciseTemplate>[];
    final reviewTemplates = <ExerciseTemplate>[];

    for (final lesson in course.lessons.where(
      (lesson) => auditedLessonIds.contains(lesson.id),
    )) {
      final isReviewOrCheckpoint =
          lesson.title.toLowerCase().contains('review') ||
          lesson.title.toLowerCase().contains('checkpoint');
      for (final reference
          in lesson.activities
              .expand((activity) => activity.contentReferences)
              .where((reference) => reference.type == 'exercise_template')) {
        final template = catalog.lookupAs<ExerciseTemplate>(
          reference.referenceId!,
        );
        expect(template, isNotNull, reason: reference.referenceId);
        auditedTemplates.add(template!);
        if (isReviewOrCheckpoint) {
          reviewTemplates.add(template);
        }
      }
    }

    expect(auditedLessonIds, hasLength(27));
    expect(auditedTemplates, hasLength(greaterThanOrEqualTo(100)));
    expect(
      auditedTemplates.where(
        (template) =>
            template.exerciseType == 'text_entry' ||
            template.exerciseType == 'fill_gap',
      ),
      hasLength(greaterThanOrEqualTo(55)),
    );
    expect(reviewTemplates, isNotEmpty);
    expect(
      reviewTemplates.every(
        (template) =>
            template.exerciseType == 'text_entry' ||
            template.exerciseType == 'fill_gap' ||
            template.exerciseType == 'multiple_choice' ||
            (template.exerciseType == 'matching' &&
                _matchingPairs(template).isNotEmpty),
      ),
      isTrue,
    );
    expect(
      reviewTemplates.any((template) => template.exerciseType == 'text_entry'),
      isTrue,
    );
    for (final template in reviewTemplates) {
      expect(
        template.promptTemplate,
        isNot(contains(template.expectedAnswer ?? '__never__')),
        reason: 'Review/checkpoint prompt exposes ${template.id}',
      );
    }
  });

  test(
    'QA1 controlled support equivalents work on authored Module 1 tasks',
    () async {
      final contentLoader = ContentLoader(assetBundle: rootBundle);
      final catalog = EducationalContentCatalog(
        await contentLoader.loadSpanishContent(),
      );

      final repeatTemplate = catalog.lookupAs<ExerciseTemplate>(
        'template.es.a0.m01.l003.type_repite_por_favor.v1',
      )!;
      final matchingTemplate = catalog.lookupAs<ExerciseTemplate>(
        'template.es.a0.m01.review.match_first_words.v1',
      )!;
      final guidedHelloTemplate = catalog.lookupAs<ExerciseTemplate>(
        'template.es.a0.m01.l001.guided_type_hola.v1',
      )!;
      final independentHelloTemplate = catalog.lookupAs<ExerciseTemplate>(
        'template.es.a0.m01.l001.independent_type_hola.v1',
      )!;

      final repeatResult = const ActivityEngine().evaluate(
        template: repeatTemplate,
        submission: const ActivitySubmission(
          submittedAnswer: 'repite por favor',
        ),
      );
      final matchingResult = const ActivityEngine().evaluate(
        template: matchingTemplate,
        submission: const ActivitySubmission(
          matchedPairs: {
            'hola': 'hello',
            'gracias': 'thank you',
            'no entiendo': "I don't understand",
          },
        ),
      );
      final copiedSourceResult = const ActivityEngine().evaluate(
        template: guidedHelloTemplate,
        submission: const ActivitySubmission(submittedAnswer: 'hello'),
      );
      final missingSilentHResult = const ActivityEngine().evaluate(
        template: guidedHelloTemplate,
        submission: const ActivitySubmission(submittedAnswer: 'ola'),
      );
      final independentResult = const ActivityEngine().evaluate(
        template: independentHelloTemplate,
        submission: const ActivitySubmission(submittedAnswer: 'hola'),
      );

      expect(repeatResult.isCorrect, isTrue);
      expect(matchingResult.isCorrect, isTrue);
      expect(
        copiedSourceResult.feedbackKey,
        'response.translation_expected_source_language',
      );
      expect(missingSilentHResult.feedbackKey, 'spanish.silent_h.hola');
      expect(independentResult.isCorrect, isTrue);
    },
  );

  test('QA2 Modules 1-4 authored prompts match expected answer type', () async {
    final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    final course = await curriculumLoader.loadCourse();
    final catalog = EducationalContentCatalog(
      await contentLoader.loadSpanishContent(),
    );

    final auditedTemplates = <ExerciseTemplate>[];
    final auditedLessonIds = course.modules
        .where((module) => _qaAuditedModuleIds.contains(module.id))
        .expand((module) => module.lessonIds)
        .toSet();

    for (final lesson in course.lessons.where(
      (lesson) => auditedLessonIds.contains(lesson.id),
    )) {
      for (final reference
          in lesson.activities
              .expand((activity) => activity.contentReferences)
              .where((reference) => reference.type == 'exercise_template')) {
        final template = catalog.lookupAs<ExerciseTemplate>(
          reference.referenceId!,
        );
        expect(template, isNotNull, reason: reference.referenceId);
        auditedTemplates.add(template!);
      }
    }

    for (final template in auditedTemplates.where(_isTypedRecallTemplate)) {
      final expectedAnswer = template.expectedAnswer!;
      expect(
        _promptExposesExpectedAnswer(template.promptTemplate, expectedAnswer),
        isFalse,
        reason: 'Prompt exposes expected answer in ${template.id}',
      );

      final promptAsksForQuestion = _promptRequestsQuestion(
        template.promptTemplate,
      );
      final promptAsksForStatement = _promptRequestsStatementOrAnswer(
        template.promptTemplate,
      );
      final expectedIsQuestion = _isSpanishQuestion(expectedAnswer);

      if (promptAsksForQuestion) {
        expect(
          expectedIsQuestion,
          isTrue,
          reason:
              'Prompt asks for a question but expected is not: '
              '${template.id}',
        );
      }
      if (promptAsksForStatement) {
        expect(
          expectedIsQuestion,
          isFalse,
          reason:
              'Prompt asks for an answer/statement but expected is a '
              'question: ${template.id}',
        );
      }

      for (final acceptedAnswer in template.acceptedAnswers) {
        expect(
          _isSpanishQuestion(acceptedAnswer),
          expectedIsQuestion,
          reason:
              'accepted_answers must match expected answer type in '
              '${template.id}',
        );
      }
    }
  });
}

const _qaAuditedModuleIds = {
  'es.a0.m01',
  'es.a0.m02',
  'es.a0.m03',
  'es.a0.m04',
};

bool _isCheckable(ExerciseTemplate template) {
  return switch (template.exerciseType) {
    'multiple_choice' =>
      template.correctOptionId != null && template.answerOptions.isNotEmpty,
    'fill_gap' || 'text_entry' => template.expectedAnswer != null,
    'matching' => template.expectedAnswer != null,
    _ => false,
  };
}

bool _isTypedRecallTemplate(ExerciseTemplate template) {
  return (template.exerciseType == 'fill_gap' ||
          template.exerciseType == 'text_entry') &&
      template.expectedAnswer != null;
}

bool _promptExposesExpectedAnswer(String prompt, String expectedAnswer) {
  final normalizedPrompt = _normalizeForAuthoringAudit(prompt);
  final normalizedExpected = _normalizeForAuthoringAudit(expectedAnswer);
  if (normalizedExpected.length < 6) {
    return false;
  }
  return normalizedPrompt.contains(normalizedExpected);
}

bool _promptRequestsQuestion(String prompt) {
  final normalized = prompt.toLowerCase();
  return normalized.contains('type the spanish question') ||
      normalized.contains('write the spanish question') ||
      normalized.contains('ask the spanish question') ||
      normalized.contains('ask where') ||
      normalized.contains('ask which') ||
      normalized.contains('ask who') ||
      normalized.contains('ask what');
}

bool _promptRequestsStatementOrAnswer(String prompt) {
  final normalized = prompt.toLowerCase();
  return normalized.contains('answer ') ||
      normalized.contains('respond ') ||
      normalized.contains('reply ') ||
      normalized.contains('state ') ||
      normalized.contains('say where') ||
      normalized.contains('say which') ||
      normalized.contains('say your') ||
      normalized.contains('say someone') ||
      normalized.contains('describe ');
}

bool _isSpanishQuestion(String answer) {
  final trimmed = answer.trim();
  return trimmed.contains('?') || trimmed.startsWith('¿');
}

String _normalizeForAuthoringAudit(String value) {
  return value
      .replaceAll('\u00A0', ' ')
      .replaceAll('¿', '')
      .replaceAll('?', '')
      .replaceAll('¡', '')
      .replaceAll('!', '')
      .replaceAll(RegExp(r'[.,:;"“”]'), ' ')
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
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
    'Spanish word/name',
    'Spanish name',
    'Spanish verb form',
    'Spanish phrase',
    'Spanish pattern',
    'Spanish command',
    'Spanish sentence',
    'Spanish form',
    'Spanish introduction',
    'Spanish location',
    'Spanish origin phrase',
    'Spanish origin pattern word',
    'Spanish residence pattern word',
    'Spanish question word',
    'Spanish question',
    'Spanish answer',
    'Spanish article',
    'Spanish request',
    'Spanish greeting',
    'Spanish spelling group',
    'Spanish room word',
    'fixed Spanish pattern',
    'first word',
    'form of tener',
    'location word',
    'word that finishes',
  ];

  return constraintMarkers.any(prompt.contains);
}

int _occurrences(String text, String pattern) {
  var count = 0;
  var index = 0;
  while (true) {
    index = text.indexOf(pattern, index);
    if (index == -1) {
      return count;
    }
    count += 1;
    index += pattern.length;
  }
}

Map<String, String> _matchingPairs(ExerciseTemplate template) {
  final expectedAnswer = template.expectedAnswer;
  if (expectedAnswer == null || expectedAnswer.trim().isEmpty) {
    return const {};
  }
  final pairs = <String, String>{};
  for (final rawPair in expectedAnswer.split(RegExp(r'[;\n]'))) {
    final separator = rawPair.contains('=>')
        ? '=>'
        : rawPair.contains('=')
        ? '='
        : rawPair.contains(':')
        ? ':'
        : null;
    if (separator == null) {
      continue;
    }
    final parts = rawPair.split(separator);
    if (parts.length < 2) {
      continue;
    }
    final left = parts.first.trim();
    final right = parts.sublist(1).join(separator).trim();
    if (left.isNotEmpty && right.isNotEmpty) {
      pairs[left] = right;
    }
  }
  return Map.unmodifiable(pairs);
}
