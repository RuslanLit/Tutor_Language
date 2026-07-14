import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/activity_engine/activity_engine.dart';
import 'package:tutor_language/features/activity_engine/activity_result.dart';
import 'package:tutor_language/features/communicative_competency/communicative_competency.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_assembly_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'C2G Module 6 uses canonical transport lesson IDs and preserves course order',
    () async {
      final course = await CurriculumLoader(
        assetBundle: rootBundle,
      ).loadCourse();
      final module5 = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m05',
      );
      final module6 = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m06',
      );
      final module7 = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m07',
      );

      expect(module6.title, 'Transport and Directions');
      expect(module6.lessonIds, [
        'es.a0.m06.l036',
        'es.a0.m06.l037',
        'es.a0.m06.l038',
        'es.a0.m06.l039',
        'es.a0.m06.l040',
        'es.a0.m06.l041',
        'es.a0.m06.l042',
        'es.a0.m06.l043',
      ]);
      expect(module5.lessonIds.last, 'es.a0.m05.l035');
      expect(module7.lessonIds.first, 'es.a0.m07.l021');

      final activeLessonIds = [
        for (final module in course.modules) ...module.lessonIds,
      ];
      expect(activeLessonIds.toSet(), hasLength(activeLessonIds.length));
      expect(activeLessonIds, isNot(contains('es.a0.m06.l018')));
      expect(activeLessonIds, isNot(contains('es.a0.m06.l019')));
      expect(activeLessonIds, isNot(contains('es.a0.m06.l020')));

      for (final lessonId in module6.lessonIds) {
        final lesson = course.lessons.singleWhere(
          (lesson) => lesson.id == lessonId,
        );
        expect(lesson.moduleId, 'es.a0.m06');
        expect(lesson.communicativeOutcome, isNotNull);
        expect(lesson.activities, isNotEmpty);
      }
    },
  );

  test(
    'C2G Module 6 assets parse and lessons assemble with typed recall',
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
      final course = await curriculumLoader.loadCourse();
      final module = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m06',
      );

      final requiredCoverage = <String>{
        'grammar.es.a0.m06.location_with_estar.v1',
        'grammar.es.a0.m06.where_questions.v1',
        'grammar.es.a0.m06.how_to_get_questions.v1',
        'grammar.es.a0.m06.simple_directions.v1',
        'grammar.es.a0.m06.transport_method.v1',
        'template.es.a0.m06.l036.type_voy_en_metro.v1',
        'template.es.a0.m06.l037.type_donde_esta_estacion.v1',
        'template.es.a0.m06.l038.type_gira_izquierda.v1',
        'template.es.a0.m06.l039.type_esta_lejos.v1',
        'template.es.a0.m06.l040.type_como_llego_hotel.v1',
        'template.es.a0.m06.l041.type_que_transporte_tomo.v1',
        'template.es.a0.m06.checkpoint.type_route_exchange.v1',
      };
      final referencedIds = <String>{};
      final templates = <ExerciseTemplate>[];

      for (final lessonId in module.lessonIds) {
        final assembled = await service.assembleLesson(lessonId);
        expect(assembled.activities, isNotEmpty, reason: lessonId);
        final lesson = course.lessons.singleWhere(
          (lesson) => lesson.id == lessonId,
        );
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
          reason: lessonId,
        );
        templates.addAll(lessonTemplates);
        referencedIds.addAll(
          lesson.activities
              .expand((activity) => activity.contentReferences)
              .map((reference) => reference.referenceId)
              .whereType<String>(),
        );
      }

      expect(referencedIds, containsAll(requiredCoverage));
      expect(
        templates
            .where((template) => template.exerciseType == 'text_entry')
            .length,
        greaterThanOrEqualTo(24),
      );
      expect(
        templates
            .where((template) => template.authoredMisconceptions.isNotEmpty)
            .length,
        greaterThanOrEqualTo(8),
      );
      expect(
        templates
            .where((template) => template.reviewTemplateIds.isNotEmpty)
            .length,
        greaterThanOrEqualTo(5),
      );
    },
  );

  test(
    'C2G transport answer evaluation preserves route and question distinctions',
    () async {
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
          'template.es.a0.m06.l037.type_donde_esta_estacion.v1',
          '¿Dónde está la estación?',
        ).status,
        ActivityResultStatus.correct,
      );
      expect(
        evaluate(
          'template.es.a0.m06.l040.type_como_llego_hotel.v1',
          'Como llego al hotel?',
        ).status,
        ActivityResultStatus.acceptedWithFeedback,
      );
      expect(
        evaluate(
          'template.es.a0.m06.l037.type_donde_esta_estacion.v1',
          '¿Cómo llego a la estación?',
        ).feedbackKey,
        'spanish.directions.use_donde_for_location',
      );
      expect(
        evaluate(
          'template.es.a0.m06.l037.type_esta_cerca.v1',
          'Es cerca',
        ).feedbackKey,
        'spanish.directions.use_esta_for_location',
      );
      expect(
        evaluate(
          'template.es.a0.m06.l036.type_voy_a_pie.v1',
          'Voy en pie',
        ).feedbackKey,
        'spanish.transport.use_a_pie',
      );
      expect(
        evaluate(
          'template.es.a0.m06.l038.type_gira_izquierda.v1',
          'Gira a la derecha',
        ).feedbackKey,
        'spanish.directions.left_not_right',
      );
      expect(
        evaluate(
          'template.es.a0.m06.l040.type_route_sequence.v1',
          'Gira a la derecha. Sigue recto.',
        ).feedbackKey,
        'spanish.directions.route_order_matters',
      );
      expect(
        evaluate(
          'template.es.a0.m06.checkpoint.type_strict_route.v1',
          'Gira a la izquierda. Sigue recto.',
        ).status,
        ActivityResultStatus.incorrect,
      );
    },
  );

  test(
    'production Module 6 competency resolves diagnostics and recovery flow',
    () async {
      const registry = CompetencyDefinitionRegistry();
      final definition = registry.lookup(
        moduleId: 'es.a0.m06',
        competencyId: 'competency.es.a0.m06.ask_and_follow_basic_directions',
      );
      expect(definition, isNotNull);

      final competencyCatalog = registry.catalogFor(definition!);
      final validation = const CommunicativeCompetencyValidator().validate(
        competencyCatalog,
      );
      expect(validation.errors, isEmpty);

      final contentCatalog = EducationalContentCatalog(
        await ContentLoader(assetBundle: rootBundle).loadSpanishContent(),
      );
      for (final templateId in [
        ...definition.diagnosticTaskTemplateIds.values,
        ...definition.recoveryTemplateIds.values,
      ]) {
        final reference = templateReference(templateId);
        expect(reference.assetPath, contains('/templates/'));
        expect(
          contentCatalog.lookupAs<ExerciseTemplate>(reference.referenceId!),
          isNotNull,
          reason: templateId,
        );
      }

      final centralTask = competencyCatalog.task(
        'task.es.a0.m06.complete_route_exchange',
      );
      final centralTemplate = contentCatalog.lookupAs<ExerciseTemplate>(
        'template.es.a0.m06.competency.route_exchange.v1',
      )!;
      final locationOnlyAnswer = const ActivityEngine().evaluate(
        template: centralTemplate,
        submission: const ActivitySubmission(submittedAnswer: 'Está allí'),
      );
      expect(
        locationOnlyAnswer.feedbackKey,
        'spanish.directions.direction_not_location',
      );

      final recoverySources = centralTask.recoveryMappings
          .expand((mapping) => mapping.recoveryStepReferences)
          .map((reference) => reference.sourceModuleId)
          .toSet();
      expect(recoverySources, contains('es.a0.m06'));
      expect(recoverySources, contains('es.a0.m04'));

      const coordinator = CommunicativeCompetencyCoordinator();
      var state = coordinator.startAssessment(
        competencyId: definition.competency.competencyId,
      );
      for (final taskId in definition.competency.assessmentTaskIds.take(4)) {
        final decision = coordinator.recordTaskResult(
          catalog: competencyCatalog,
          state: state,
          taskId: taskId,
          result: _correct(taskId),
        );
        state = decision.updatedState;
      }

      final failure = coordinator.recordTaskResult(
        catalog: competencyCatalog,
        state: state,
        taskId: 'task.es.a0.m06.give_simple_directions',
        result: _incorrect('task.es.a0.m06.give_simple_directions'),
      );
      expect(
        failure.type,
        CompetencyAssessmentDecisionType.insertRecoverySteps,
      );
      expect(failure.recoveryInsertions.single.sourceModuleId, 'es.a0.m06');

      final recovered = coordinator.recordRecoveryCompleted(
        catalog: competencyCatalog,
        state: failure.updatedState,
        gapId: failure.gaps.single.gapId,
      );
      expect(
        recovered.type,
        CompetencyAssessmentDecisionType.retryAssessmentTask,
      );

      state = coordinator
          .recordTaskResult(
            catalog: competencyCatalog,
            state: recovered.updatedState,
            taskId: 'task.es.a0.m06.give_simple_directions',
            result: _correct('task.es.a0.m06.give_simple_directions'),
          )
          .updatedState;

      for (final taskId in definition.competency.assessmentTaskIds.skip(5)) {
        final decision = coordinator.recordTaskResult(
          catalog: competencyCatalog,
          state: state,
          taskId: taskId,
          result: _correct(taskId),
        );
        state = decision.updatedState;
      }

      final outcome = coordinator.evaluateOutcome(
        catalog: competencyCatalog,
        state: state,
      );
      expect(outcome.status, CompetencyOutcomeStatus.achievedWithReinforcement);
    },
  );
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
