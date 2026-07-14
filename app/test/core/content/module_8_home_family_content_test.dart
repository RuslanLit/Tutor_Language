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
    'C2I Module 8 uses new home/family lesson IDs and retires legacy IDs',
    () async {
      final course = await CurriculumLoader(
        assetBundle: rootBundle,
      ).loadCourse();
      final module7 = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m07',
      );
      final module8 = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m08',
      );

      expect(module8.title, 'Home and Family');
      expect(module8.lessonIds, [
        'es.a0.m08.l052',
        'es.a0.m08.l053',
        'es.a0.m08.l054',
        'es.a0.m08.l055',
        'es.a0.m08.l056',
        'es.a0.m08.l057',
        'es.a0.m08.l058',
        'es.a0.m08.l059',
        'es.a0.m08.l060',
      ]);
      expect(module7.lessonIds.last, 'es.a0.m07.l051');

      final activeLessonIds = [
        for (final module in course.modules) ...module.lessonIds,
      ];
      expect(activeLessonIds.toSet(), hasLength(activeLessonIds.length));
      for (final retiredId in {
        'es.a0.m08.l026',
        'es.a0.m08.l027',
        'es.a0.m08.l028',
        'es.a0.m08.l029',
        'es.a0.m08.l030',
        'es.a0.m08.l031',
        'es.a0.m08.l032',
      }) {
        expect(activeLessonIds, isNot(contains(retiredId)));
      }

      for (final lessonId in module8.lessonIds) {
        final lesson = course.lessons.singleWhere(
          (lesson) => lesson.id == lessonId,
        );
        expect(lesson.moduleId, 'es.a0.m08');
        expect(lesson.communicativeOutcome, isNotNull);
        expect(lesson.activities, isNotEmpty);
      }
    },
  );

  test(
    'C2I Module 8 assets parse and lessons assemble with active recall',
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
        (module) => module.id == 'es.a0.m08',
      );

      final requiredCoverage = <String>{
        'grammar.es.a0.m08.family_identification.v1',
        'grammar.es.a0.m08.third_person_family_name.v1',
        'grammar.es.a0.m08.tener_family.v1',
        'grammar.es.a0.m08.home_rooms.v1',
        'grammar.es.a0.m08.location_with_estar_home.v1',
        'grammar.es.a0.m08.hay_vs_esta_home.v1',
        'template.es.a0.m08.l052.type_esta_es_mi_madre.v1',
        'template.es.a0.m08.l054.type_tienes_hermanos.v1',
        'template.es.a0.m08.l056.type_la_mesa_esta_cocina.v1',
        'template.es.a0.m08.l056.type_hay_mesa_cocina.v1',
        'template.es.a0.m08.l058.type_ask_and_answer_location.v1',
        'template.es.a0.m08.checkpoint.type_integrated_exchange.v1',
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
        greaterThanOrEqualTo(25),
      );
      expect(
        templates
            .where((template) => template.authoredMisconceptions.isNotEmpty)
            .length,
        greaterThanOrEqualTo(18),
      );
      expect(
        templates
            .where((template) => template.reviewTemplateIds.isNotEmpty)
            .length,
        greaterThanOrEqualTo(12),
      );
    },
  );

  test(
    'C2I family and home answer evaluation preserves distinctions',
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
          'template.es.a0.m08.l053.type_quien_es_ella.v1',
          '¿Quién es ella?',
        ).status,
        ActivityResultStatus.correct,
      );
      expect(
        evaluate(
          'template.es.a0.m08.l053.type_quien_es_ella.v1',
          'Quien es ella?',
        ).status,
        ActivityResultStatus.acceptedWithFeedback,
      );
      expect(
        evaluate(
          'template.es.a0.m08.l053.type_quien_es_ella.v1',
          'Es mi hermana',
        ).feedbackKey,
        'response.question_expected_answer',
      );
      expect(
        evaluate(
          'template.es.a0.m08.l054.type_tengo_una_hermana.v1',
          'Tiene una hermana',
        ).feedbackKey,
        'spanish.tener.use_tengo_for_self',
      );
      expect(
        evaluate(
          'template.es.a0.m08.l056.type_la_mesa_esta_cocina.v1',
          'Hay la mesa en la cocina',
        ).feedbackKey,
        'spanish.location.use_esta_for_known_item',
      );
      expect(
        evaluate(
          'template.es.a0.m08.l056.type_hay_mesa_cocina.v1',
          'La mesa está en la cocina',
        ).feedbackKey,
        'spanish.location.use_hay_for_existence',
      );
    },
  );

  test(
    'production Module 8 competency resolves diagnostics and recovery flow',
    () async {
      const registry = CompetencyDefinitionRegistry();
      final definition = registry.lookup(
        moduleId: 'es.a0.m08',
        competencyId: 'competency.es.a0.m08.describe_basic_family_and_home',
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
        'task.es.a0.m08.family_home_exchange',
      );
      final recoverySources = centralTask.recoveryMappings
          .expand((mapping) => mapping.recoveryStepReferences)
          .map((reference) => reference.sourceModuleId)
          .toSet();
      expect(recoverySources, contains('es.a0.m08'));
      expect(recoverySources, contains('es.a0.m04'));

      const coordinator = CommunicativeCompetencyCoordinator();
      var state = coordinator.startAssessment(
        competencyId: definition.competency.competencyId,
      );
      for (final taskId in definition.competency.assessmentTaskIds.take(3)) {
        state = coordinator
            .recordTaskResult(
              catalog: competencyCatalog,
              state: state,
              taskId: taskId,
              result: _correct(taskId),
            )
            .updatedState;
      }

      final failure = coordinator.recordTaskResult(
        catalog: competencyCatalog,
        state: state,
        taskId: 'task.es.a0.m08.identify_room_object',
        result: _incorrect('task.es.a0.m08.identify_room_object'),
      );
      expect(
        failure.type,
        CompetencyAssessmentDecisionType.insertRecoverySteps,
      );
      expect(failure.recoveryInsertions.single.sourceModuleId, 'es.a0.m08');

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
            taskId: 'task.es.a0.m08.identify_room_object',
            result: _correct('task.es.a0.m08.identify_room_object'),
          )
          .updatedState;

      for (final taskId in definition.competency.assessmentTaskIds.skip(4)) {
        state = coordinator
            .recordTaskResult(
              catalog: competencyCatalog,
              state: state,
              taskId: taskId,
              result: _correct(taskId),
            )
            .updatedState;
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
