import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/activity_engine/activity_engine.dart';
import 'package:tutor_language/features/activity_engine/activity_result.dart';
import 'package:tutor_language/features/answer_evaluation/answer_normalizer.dart';
import 'package:tutor_language/features/communicative_competency/communicative_competency.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_assembly_service.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_step.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'C2J active Modules 1-9 curriculum ownership and ordering are valid',
    () async {
      final course = await CurriculumLoader(
        assetBundle: rootBundle,
      ).loadCourse();
      final modules = _productionModules(course);

      expect(modules.map((module) => module.id), _moduleIds);
      expect(modules[6].lessonIds.last, 'es.a0.m07.l051');
      expect(modules[7].lessonIds.first, 'es.a0.m08.l052');
      expect(modules[7].lessonIds.last, 'es.a0.m08.l060');
      expect(modules[8].lessonIds.first, 'es.a0.m09.l061');
      expect(modules[8].lessonIds.last, 'es.a0.m09.l070');
      expect(modules[0].lessonIds, _module1Lessons);
      expect(modules[1].lessonIds, _module2Lessons);
      expect(modules[2].lessonIds, _module3Lessons);
      expect(modules[3].lessonIds, _module4Lessons);
      expect(modules[4].lessonIds, _module5Lessons);
      expect(modules[5].lessonIds, _module6Lessons);
      expect(modules[6].lessonIds, _module7Lessons);
      expect(modules[7].lessonIds, _module8Lessons);
      expect(modules[8].lessonIds, _module9Lessons);

      final lessonById = {
        for (final lesson in course.lessons) lesson.id: lesson,
      };
      final activeLessonIds = [
        for (final module in modules) ...module.lessonIds,
      ];

      expect(activeLessonIds, hasLength(70));
      expect(activeLessonIds.toSet(), hasLength(activeLessonIds.length));
      expect(activeLessonIds, isNot(containsAll(_retiredModule7LessonIds)));
      expect(activeLessonIds, isNot(containsAll(_retiredModule8LessonIds)));

      for (final module in modules) {
        for (final lessonId in module.lessonIds) {
          final lesson = lessonById[lessonId];
          expect(lesson, isNotNull, reason: lessonId);
          expect(lesson!.moduleId, module.id, reason: lessonId);
          expect(lesson.activities, isNotEmpty, reason: lessonId);
        }
      }

      for (final module in modules.take(2)) {
        final lastLesson = lessonById[module.lessonIds.last]!;
        expect(
          lastLesson.title.toLowerCase(),
          contains('review'),
          reason: module.id,
        );
      }

      for (final module in modules.skip(2)) {
        final review =
            lessonById[module.lessonIds[module.lessonIds.length - 2]]!;
        final checkpoint = lessonById[module.lessonIds.last]!;
        expect(
          review.title.toLowerCase(),
          contains('review'),
          reason: module.id,
        );
        expect(
          checkpoint.title.toLowerCase(),
          contains('checkpoint'),
          reason: module.id,
        );
      }
    },
  );

  test(
    'C2J active Modules 1-9 content resolves and assembles into checkable steps',
    () async {
      final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
      final contentLoader = ContentLoader(assetBundle: rootBundle);
      final catalog = EducationalContentCatalog(
        await contentLoader.loadSpanishContent(),
      );
      final service = LessonAssemblyService(
        curriculumLoader: curriculumLoader,
        contentLoader: contentLoader,
      );
      const stepBuilder = LessonPlayerStepBuilder();

      final course = await curriculumLoader.loadCourse();

      for (final lesson in _productionLessons(course)) {
        final assembled = await service.assembleLesson(lesson.id);
        final steps = stepBuilder.buildSteps(assembled);

        expect(assembled.activities, isNotEmpty, reason: lesson.id);
        expect(steps, isNotEmpty, reason: lesson.id);

        final templates = <ExerciseTemplate>[];
        for (final activity in lesson.activities) {
          expect(activity.title.trim(), isNotEmpty, reason: activity.id);
          if (activity.type == 'reading_rule') {
            expect(
              [
                ...activity.introducedReadingRuleIds,
                ...activity.reviewedReadingRuleIds,
              ],
              isNotEmpty,
              reason: activity.id,
            );
          } else {
            expect(activity.contentReferences, isNotEmpty, reason: activity.id);
          }

          for (final reference in activity.contentReferences) {
            expect(catalog.canResolve(reference), isTrue, reason: lesson.id);
            if (reference.type != 'exercise_template' ||
                reference.referenceId == null) {
              continue;
            }

            final template = catalog.lookupAs<ExerciseTemplate>(
              reference.referenceId!,
            );
            expect(template, isNotNull, reason: reference.referenceId);
            templates.add(template!);
            _expectTemplateContract(template);
          }
        }

        expect(
          templates.any((template) => template.exerciseType == 'text_entry'),
          isTrue,
          reason: '${lesson.id} lacks typed recall.',
        );

        for (final step in steps) {
          final stepTemplates = step.content.whereType<ExerciseTemplate>();
          expect(stepTemplates.length, lessThanOrEqualTo(1), reason: step.id);
          if (stepTemplates.isNotEmpty) {
            expect(step.isCheckable, isTrue, reason: step.id);
          }
        }
      }
    },
  );

  test(
    'C2J active Modules 1-9 lessons are distinct and review/checkpoint active',
    () async {
      final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
      final contentLoader = ContentLoader(assetBundle: rootBundle);
      final catalog = EducationalContentCatalog(
        await contentLoader.loadSpanishContent(),
      );
      final course = await curriculumLoader.loadCourse();
      final sequenceOwner = <String, String>{};

      for (final lesson in _productionLessons(course)) {
        final sequence = lesson.activities
            .expand((activity) => activity.contentReferences)
            .map(
              (reference) =>
                  '${reference.type}:${reference.referenceId ?? reference.assetPath}',
            )
            .join('|');
        final previous = sequenceOwner[sequence];
        expect(
          previous,
          isNull,
          reason:
              '${lesson.id} duplicates full reference sequence from $previous',
        );
        sequenceOwner[sequence] = lesson.id;

        final templates = _lessonTemplates(lesson, catalog);
        expect(templates, isNotEmpty, reason: lesson.id);

        if (_isReviewOrCheckpoint(lesson)) {
          expect(
            templates.where(
              (template) => template.exerciseType == 'text_entry',
            ),
            isNotEmpty,
            reason: '${lesson.id} review/checkpoint lacks typed recall.',
          );
          for (final template in templates.where(_isTypedTemplate)) {
            _expectPromptDoesNotRevealAnswer(template);
          }
        }
      }
    },
  );

  test(
    'C2J active Modules 1-9 answer contracts reject false positives',
    () async {
      final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
      final contentLoader = ContentLoader(assetBundle: rootBundle);
      final catalog = EducationalContentCatalog(
        await contentLoader.loadSpanishContent(),
      );
      final course = await curriculumLoader.loadCourse();
      const engine = ActivityEngine();

      for (final lesson in _productionLessons(course)) {
        for (final template in _lessonTemplates(lesson, catalog)) {
          switch (template.exerciseType) {
            case 'multiple_choice':
              final correct = engine.evaluate(
                template: template,
                submission: ActivitySubmission(
                  selectedAnswerId: template.correctOptionId,
                ),
              );
              expect(correct.status, ActivityResultStatus.correct);

              final wrongOption = template.answerOptions
                  .where((option) => option.id != template.correctOptionId)
                  .firstOrNull;
              if (wrongOption != null) {
                final wrong = engine.evaluate(
                  template: template,
                  submission: ActivitySubmission(
                    selectedAnswerId: wrongOption.id,
                  ),
                );
                expect(wrong.status, ActivityResultStatus.incorrect);
              }
            case 'fill_gap' || 'text_entry':
              final expected = template.expectedAnswer;
              expect(expected, isNotNull, reason: template.id);
              final canonical = engine.evaluate(
                template: template,
                submission: ActivitySubmission(submittedAnswer: expected),
              );
              expect(canonical.isCorrect, isTrue, reason: template.id);

              for (final answer in template.acceptedAnswers) {
                final result = engine.evaluate(
                  template: template,
                  submission: ActivitySubmission(submittedAnswer: answer),
                );
                expect(result.status, ActivityResultStatus.correct);
              }

              for (final answer in template.acceptedWithFeedbackAnswers) {
                final result = engine.evaluate(
                  template: template,
                  submission: ActivitySubmission(
                    submittedAnswer: answer.answer,
                  ),
                );
                expect(
                  result.status,
                  ActivityResultStatus.acceptedWithFeedback,
                  reason: template.id,
                );
              }

              for (final misconception in template.authoredMisconceptions) {
                for (final answer in misconception.matchingAnswers) {
                  final result = engine.evaluate(
                    template: template,
                    submission: ActivitySubmission(submittedAnswer: answer),
                  );
                  expect(result.status, ActivityResultStatus.incorrect);
                  expect(
                    result.feedbackKey,
                    misconception.feedbackKey,
                    reason: '${template.id}/${misconception.id}',
                  );
                }
              }

              final sentinel = engine.evaluate(
                template: template,
                submission: const ActivitySubmission(
                  submittedAnswer: '__qa7_invalid_answer__',
                ),
              );
              expect(sentinel.status, ActivityResultStatus.incorrect);
            case 'matching':
              final pairs = engine.expectedMatchingPairs(template);
              expect(pairs, isNotEmpty, reason: template.id);
              final correct = engine.evaluate(
                template: template,
                submission: ActivitySubmission(matchedPairs: pairs),
              );
              expect(correct.status, ActivityResultStatus.correct);
            default:
              fail('Unsupported exercise type ${template.exerciseType}');
          }
        }
      }
    },
  );

  test(
    'C2I question punctuation variants remain accepted with correction',
    () async {
      final catalog = EducationalContentCatalog(
        await ContentLoader(assetBundle: rootBundle).loadSpanishContent(),
      );
      const engine = ActivityEngine();

      for (final entry in {
        'template.es.a0.m05.l033.type_price_question_and_close.v1':
            'Cuánto cuesta? Nada más, gracias',
        'template.es.a0.m05.review.type_availability_and_request.v1':
            'Tiene agua? Quiero una botella',
      }.entries) {
        final template = catalog.lookupAs<ExerciseTemplate>(entry.key);
        expect(template, isNotNull);
        final result = engine.evaluate(
          template: template!,
          submission: ActivitySubmission(submittedAnswer: entry.value),
        );
        expect(
          result.status,
          ActivityResultStatus.acceptedWithFeedback,
          reason: entry.key,
        );
      }
    },
  );

  test(
    'C2J active Modules 1-9 authored answer variants are deterministic',
    () async {
      final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
      final contentLoader = ContentLoader(assetBundle: rootBundle);
      final catalog = EducationalContentCatalog(
        await contentLoader.loadSpanishContent(),
      );
      final course = await curriculumLoader.loadCourse();
      const normalizer = AnswerNormalizer();

      for (final lesson in _productionLessons(course)) {
        for (final template in _lessonTemplates(lesson, catalog)) {
          if (!_isTypedTemplate(template)) {
            continue;
          }

          final normalizedAnswers = <String, String>{};
          for (final entry in _answerEntries(template)) {
            final normalized = normalizer.normalize(entry.value).value;
            final previous = normalizedAnswers[normalized];
            expect(
              previous,
              isNull,
              reason:
                  '${template.id} duplicates normalized answer "$normalized" in '
                  '$previous and ${entry.kind}.',
            );
            normalizedAnswers[normalized] = entry.kind;
          }

          final expected = template.expectedAnswer;
          if (expected != null && expected.trim().startsWith('¿')) {
            for (final accepted in template.acceptedAnswers) {
              expect(
                accepted.trim().startsWith('¿'),
                isTrue,
                reason:
                    '${template.id} accepts a question variant as fully correct '
                    'without opening ¿.',
              );
            }
          }
        }
      }
    },
  );

  test('C2I Module 8 family, home and location distinctions hold', () async {
    final catalog = EducationalContentCatalog(
      await ContentLoader(assetBundle: rootBundle).loadSpanishContent(),
    );
    const engine = ActivityEngine();

    ActivityResult evaluate(String templateId, String answer) {
      final template = catalog.lookupAs<ExerciseTemplate>(templateId);
      expect(template, isNotNull, reason: templateId);
      return engine.evaluate(
        template: template!,
        submission: ActivitySubmission(submittedAnswer: answer),
      );
    }

    expect(
      evaluate(
        'template.es.a0.m08.l052.type_este_es_mi_padre.v1',
        'Este es mi padre',
      ).status,
      ActivityResultStatus.correct,
    );
    expect(
      evaluate(
        'template.es.a0.m08.l052.type_este_es_mi_padre.v1',
        'Esta es mi padre',
      ).feedbackKey,
      'spanish.family.use_este_with_padre',
    );
    expect(
      evaluate(
        'template.es.a0.m08.l054.type_tienes_hermanos.v1',
        'Tengo un hermano',
      ).feedbackKey,
      'response.question_expected_answer',
    );
    expect(
      evaluate(
        'template.es.a0.m08.l056.type_la_mesa_esta_cocina.v1',
        'La mesa es en la cocina',
      ).feedbackKey,
      'spanish.location.use_esta_for_location',
    );
    expect(
      evaluate(
        'template.es.a0.m08.l056.type_hay_mesa_cocina.v1',
        'La mesa está en la cocina',
      ).feedbackKey,
      'spanish.location.use_hay_for_existence',
    );
    expect(
      evaluate(
        'template.es.a0.m08.l058.type_ask_and_answer_location.v1',
        'Está en el salón',
      ).feedbackKey,
      'response.question_expected_answer',
    );
  });

  test('C2J Module 9 health and integration distinctions hold', () async {
    final catalog = EducationalContentCatalog(
      await ContentLoader(assetBundle: rootBundle).loadSpanishContent(),
    );
    const engine = ActivityEngine();

    ActivityResult evaluate(String templateId, String answer) {
      final template = catalog.lookupAs<ExerciseTemplate>(templateId);
      expect(template, isNotNull, reason: templateId);
      return engine.evaluate(
        template: template!,
        submission: ActivitySubmission(submittedAnswer: answer),
      );
    }

    expect(
      evaluate(
        'template.es.a0.m09.l061.type_no_estoy_bien.v1',
        'No estoy bien',
      ).status,
      ActivityResultStatus.correct,
    );
    expect(
      evaluate(
        'template.es.a0.m09.l061.type_no_estoy_bien.v1',
        'No soy bien',
      ).feedbackKey,
      'spanish.health.use_estoy_for_condition',
    );
    expect(
      evaluate(
        'template.es.a0.m09.l062.type_tengo_fiebre.v1',
        'Estoy fiebre',
      ).feedbackKey,
      'spanish.health.use_tengo_fiebre',
    );
    expect(
      evaluate(
        'template.es.a0.m09.l062.type_me_duele_cabeza.v1',
        'Me tengo la cabeza',
      ).feedbackKey,
      'spanish.health.use_me_duele_for_pain',
    );
    expect(
      evaluate(
        'template.es.a0.m09.l064.type_necesito_medico.v1',
        'Necesito medicina',
      ).feedbackKey,
      'spanish.health.medico_not_medicina',
    );
    expect(
      evaluate(
        'template.es.a0.m09.l064.type_donde_hospital.v1',
        'Necesito un hospital',
      ).feedbackKey,
      'response.question_expected_answer',
    );
    expect(
      evaluate(
        'template.es.a0.m09.l068.type_integrated_a0_identity_help.v1',
        'Soy de Perú. Me llamo Ana. Necesito ayuda',
      ).status,
      ActivityResultStatus.acceptedWithFeedback,
    );
  });

  test('C2J Modules 3-9 production competencies resolve and recover', () async {
    const registry = CompetencyDefinitionRegistry();
    const coordinator = CommunicativeCompetencyCoordinator();
    final contentCatalog = EducationalContentCatalog(
      await ContentLoader(assetBundle: rootBundle).loadSpanishContent(),
    );

    for (final moduleId in _moduleIds.skip(2)) {
      final definitions = registry.definitionsForModule(moduleId);
      expect(definitions, isNotEmpty, reason: moduleId);

      for (final definition in definitions) {
        final catalog = registry.catalogFor(definition);
        final validation = const CommunicativeCompetencyValidator().validate(
          catalog,
        );
        expect(
          validation.errors,
          isEmpty,
          reason: definition.competency.competencyId,
        );

        for (final templateId in [
          ...definition.diagnosticTaskTemplateIds.values,
          ...definition.recoveryTemplateIds.values,
        ]) {
          final reference = templateReference(templateId);
          expect(
            contentCatalog.lookupAs<ExerciseTemplate>(reference.referenceId!),
            isNotNull,
            reason: templateId,
          );
        }

        for (final taskId in definition.competency.assessmentTaskIds) {
          final task = catalog.task(taskId);
          for (final mapping in task.recoveryMappings) {
            for (final reference in mapping.recoveryStepReferences) {
              expect(
                _moduleIds.indexOf(reference.sourceModuleId),
                lessThanOrEqualTo(_moduleIds.indexOf(moduleId)),
                reason:
                    '${definition.competency.competencyId} has future recovery '
                    '${reference.sourceModuleId}',
              );
            }
          }
        }

        var successState = coordinator.startAssessment(
          competencyId: definition.competency.competencyId,
        );
        for (final taskId in definition.competency.assessmentTaskIds) {
          successState = coordinator
              .recordTaskResult(
                catalog: catalog,
                state: successState,
                taskId: taskId,
                result: _correct(taskId),
              )
              .updatedState;
        }
        expect(
          coordinator
              .evaluateOutcome(catalog: catalog, state: successState)
              .status,
          CompetencyOutcomeStatus.achieved,
        );

        final recoverableTaskId = definition.competency.assessmentTaskIds
            .firstWhere(
              (taskId) => catalog.task(taskId).recoveryMappings.isNotEmpty,
            );
        var recoveryState = coordinator.startAssessment(
          competencyId: definition.competency.competencyId,
        );
        final failure = coordinator.recordTaskResult(
          catalog: catalog,
          state: recoveryState,
          taskId: recoverableTaskId,
          result: _incorrect(recoverableTaskId),
        );
        expect(
          failure.type,
          CompetencyAssessmentDecisionType.insertRecoverySteps,
          reason: definition.competency.competencyId,
        );

        final recovered = coordinator.recordRecoveryCompleted(
          catalog: catalog,
          state: failure.updatedState,
          gapId: failure.gaps.single.gapId,
        );
        expect(
          recovered.type,
          CompetencyAssessmentDecisionType.retryAssessmentTask,
        );

        recoveryState = coordinator
            .recordTaskResult(
              catalog: catalog,
              state: recovered.updatedState,
              taskId: recoverableTaskId,
              result: _correct(recoverableTaskId),
            )
            .updatedState;

        for (final taskId in definition.competency.assessmentTaskIds) {
          if (taskId == recoverableTaskId) {
            continue;
          }
          recoveryState = coordinator
              .recordTaskResult(
                catalog: catalog,
                state: recoveryState,
                taskId: taskId,
                result: _correct(taskId),
              )
              .updatedState;
        }

        expect(
          coordinator
              .evaluateOutcome(catalog: catalog, state: recoveryState)
              .status,
          CompetencyOutcomeStatus.achievedWithReinforcement,
          reason: definition.competency.competencyId,
        );
      }
    }
  });
}

const _moduleIds = [
  'es.a0.m01',
  'es.a0.m02',
  'es.a0.m03',
  'es.a0.m04',
  'es.a0.m05',
  'es.a0.m06',
  'es.a0.m07',
  'es.a0.m08',
  'es.a0.m09',
];

const _module1Lessons = [
  'es.a0.m06.l016',
  'es.a0.m01.l001',
  'es.a0.m06.l017',
  'es.a0.m01.l002',
  'es.a0.m01.l003',
  'es.a0.m01.l006',
  'es.a0.m04.l010',
];

const _module2Lessons = [
  'es.a0.m02.l004',
  'es.a0.m02.l007',
  'es.a0.m02.l008',
  'es.a0.m02.l009',
  'es.a0.m05.l013',
];

const _module3Lessons = [
  'es.a0.m03.l013',
  'es.a0.m03.l014',
  'es.a0.m03.l015',
  'es.a0.m03.l016',
  'es.a0.m03.l017',
  'es.a0.m03.l018',
  'es.a0.m03.l019',
];

const _module4Lessons = [
  'es.a0.m04.l020',
  'es.a0.m04.l021',
  'es.a0.m04.l022',
  'es.a0.m04.l023',
  'es.a0.m04.l024',
  'es.a0.m04.l025',
  'es.a0.m04.l026',
  'es.a0.m04.l027',
];

const _module5Lessons = [
  'es.a0.m05.l028',
  'es.a0.m05.l029',
  'es.a0.m05.l030',
  'es.a0.m05.l031',
  'es.a0.m05.l032',
  'es.a0.m05.l033',
  'es.a0.m05.l034',
  'es.a0.m05.l035',
];

const _module6Lessons = [
  'es.a0.m06.l036',
  'es.a0.m06.l037',
  'es.a0.m06.l038',
  'es.a0.m06.l039',
  'es.a0.m06.l040',
  'es.a0.m06.l041',
  'es.a0.m06.l042',
  'es.a0.m06.l043',
];

const _module7Lessons = [
  'es.a0.m07.l044',
  'es.a0.m07.l045',
  'es.a0.m07.l046',
  'es.a0.m07.l047',
  'es.a0.m07.l048',
  'es.a0.m07.l049',
  'es.a0.m07.l050',
  'es.a0.m07.l051',
];

const _module8Lessons = [
  'es.a0.m08.l052',
  'es.a0.m08.l053',
  'es.a0.m08.l054',
  'es.a0.m08.l055',
  'es.a0.m08.l056',
  'es.a0.m08.l057',
  'es.a0.m08.l058',
  'es.a0.m08.l059',
  'es.a0.m08.l060',
];

const _module9Lessons = [
  'es.a0.m09.l061',
  'es.a0.m09.l062',
  'es.a0.m09.l063',
  'es.a0.m09.l064',
  'es.a0.m09.l065',
  'es.a0.m09.l066',
  'es.a0.m09.l067',
  'es.a0.m09.l068',
  'es.a0.m09.l069',
  'es.a0.m09.l070',
];

const _retiredModule7LessonIds = {
  'es.a0.m07.l021',
  'es.a0.m07.l022',
  'es.a0.m07.l023',
  'es.a0.m07.l024',
  'es.a0.m07.l025',
};

const _retiredModule8LessonIds = {
  'es.a0.m08.l026',
  'es.a0.m08.l027',
  'es.a0.m08.l028',
  'es.a0.m08.l029',
  'es.a0.m08.l030',
  'es.a0.m08.l031',
  'es.a0.m08.l032',
};

List<Module> _productionModules(Course course) {
  return _moduleIds
      .map(
        (moduleId) =>
            course.modules.singleWhere((module) => module.id == moduleId),
      )
      .toList(growable: false);
}

List<Lesson> _productionLessons(Course course) {
  final activeIds = _productionModules(
    course,
  ).expand((module) => module.lessonIds).toSet();
  return course.lessons
      .where((lesson) => activeIds.contains(lesson.id))
      .toList(growable: false);
}

List<ExerciseTemplate> _lessonTemplates(
  Lesson lesson,
  EducationalContentCatalog catalog,
) {
  return lesson.activities
      .expand((activity) => activity.contentReferences)
      .where((reference) => reference.type == 'exercise_template')
      .map((reference) => reference.referenceId)
      .whereType<String>()
      .map(catalog.lookupAs<ExerciseTemplate>)
      .whereType<ExerciseTemplate>()
      .toList(growable: false);
}

void _expectTemplateContract(ExerciseTemplate template) {
  expect(template.promptTemplate.trim(), isNotEmpty, reason: template.id);
  expect(
    {'multiple_choice', 'fill_gap', 'text_entry', 'matching'},
    contains(template.exerciseType),
    reason: template.id,
  );

  if (template.exerciseType == 'multiple_choice') {
    expect(template.answerOptions, isNotEmpty, reason: template.id);
    expect(template.correctOptionId, isNotNull, reason: template.id);
    expect(
      template.answerOptions.map((option) => option.id),
      contains(template.correctOptionId),
      reason: template.id,
    );
  }

  if (_isTypedTemplate(template)) {
    expect(template.expectedAnswer?.trim(), isNotEmpty, reason: template.id);
    expect(
      _hasKnownAmbiguousShape(template.promptTemplate),
      isFalse,
      reason: template.id,
    );
    expect(
      _hasExplicitPromptConstraint(template.promptTemplate),
      isTrue,
      reason: template.id,
    );
  }

  if (template.exerciseType == 'matching') {
    expect(template.expectedAnswer?.trim(), isNotEmpty, reason: template.id);
  }
}

void _expectPromptDoesNotRevealAnswer(ExerciseTemplate template) {
  final prompt = template.promptTemplate.toLowerCase();
  final answers = [
    if (template.expectedAnswer != null) template.expectedAnswer!,
    ...template.acceptedAnswers,
  ];

  for (final answer in answers) {
    if (answer.trim().length <= 2) {
      continue;
    }
    expect(
      prompt,
      isNot(contains(answer.toLowerCase())),
      reason: '${template.id} reveals "$answer" in review/checkpoint prompt.',
    );
  }
}

bool _isTypedTemplate(ExerciseTemplate template) {
  return template.exerciseType == 'fill_gap' ||
      template.exerciseType == 'text_entry';
}

bool _isReviewOrCheckpoint(Lesson lesson) {
  final title = lesson.title.toLowerCase();
  return title.contains('review') || title.contains('checkpoint');
}

Iterable<_AnswerEntry> _answerEntries(ExerciseTemplate template) sync* {
  if (template.expectedAnswer != null) {
    yield _AnswerEntry('expected_answer', template.expectedAnswer!);
  }
  for (final answer in template.acceptedAnswers) {
    yield _AnswerEntry('accepted_answers', answer);
  }
  for (final answer in template.acceptedWithFeedbackAnswers) {
    yield _AnswerEntry('accepted_with_feedback_answers', answer.answer);
  }
}

class _AnswerEntry {
  const _AnswerEntry(this.kind, this.value);

  final String kind;
  final String value;
}

bool _hasKnownAmbiguousShape(String prompt) {
  final normalized = prompt.toLowerCase();
  return normalized.contains('tengo un ____.') ||
      normalized.contains('____ hambre.') ||
      normalized.trim() == 'complete the greeting.';
}

bool _hasExplicitPromptConstraint(String prompt) {
  final normalized = prompt.toLowerCase();
  const markers = [
    'spanish word',
    'spanish phrase',
    'spanish sentence',
    'spanish question',
    'spanish answer',
    'spanish command',
    'spanish greeting',
    'spanish introduction',
    'spanish location',
    'spanish reply',
    'spanish request',
    'spanish direction',
    'spanish name',
    'spanish line',
    'english meaning',
    'english translation',
    'support-language',
    'from the dialogue',
    'from the reading',
    'from the sign',
    'from the pattern',
    'for "',
    'with the',
    'word for',
    'form of',
    'question:',
    'answer:',
    'sentence:',
    'means',
    'complete:',
    'type this',
    'type the two',
    'type the full',
    'type the short',
    'greet',
    'introduce',
    'include',
    'state that',
    'ask where',
    'ask how',
    'ask whether',
    'ask the',
    'request',
    'respond',
    'say that',
    'write the',
    'fill the gap',
    'complete the sentence',
  ];

  return markers.any(normalized.contains);
}

ActivityResult _correct(String id) => ActivityResult(
  exerciseId: id,
  isCorrect: true,
  status: ActivityResultStatus.correct,
  feedbackKey: 'answer.correct',
);

ActivityResult _incorrect(String id) => ActivityResult(
  exerciseId: id,
  isCorrect: false,
  status: ActivityResultStatus.incorrect,
  feedbackKey: 'answer.incorrect',
);
