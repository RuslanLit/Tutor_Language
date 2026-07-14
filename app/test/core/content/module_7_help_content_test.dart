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
    'C2H Module 7 uses canonical help lesson IDs and preserves course order',
    () async {
      final course = await CurriculumLoader(
        assetBundle: rootBundle,
      ).loadCourse();
      final module6 = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m06',
      );
      final module7 = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m07',
      );
      final module8 = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m08',
      );

      expect(module7.title, 'Asking for Help');
      expect(module7.lessonIds, [
        'es.a0.m07.l044',
        'es.a0.m07.l045',
        'es.a0.m07.l046',
        'es.a0.m07.l047',
        'es.a0.m07.l048',
        'es.a0.m07.l049',
        'es.a0.m07.l050',
        'es.a0.m07.l051',
      ]);
      expect(module6.lessonIds.last, 'es.a0.m06.l043');
      expect(module8.lessonIds.first, 'es.a0.m08.l026');

      final activeLessonIds = [
        for (final module in course.modules) ...module.lessonIds,
      ];
      expect(activeLessonIds.toSet(), hasLength(activeLessonIds.length));
      expect(activeLessonIds, isNot(contains('es.a0.m07.l021')));
      expect(activeLessonIds, isNot(contains('es.a0.m07.l022')));
      expect(activeLessonIds, isNot(contains('es.a0.m07.l023')));
      expect(activeLessonIds, isNot(contains('es.a0.m07.l024')));
      expect(activeLessonIds, isNot(contains('es.a0.m07.l025')));

      for (final lessonId in module7.lessonIds) {
        final lesson = course.lessons.singleWhere(
          (lesson) => lesson.id == lessonId,
        );
        expect(lesson.moduleId, 'es.a0.m07');
        expect(lesson.communicativeOutcome, isNotNull);
        expect(lesson.activities, isNotEmpty);
      }
    },
  );

  test(
    'C2H Module 7 assets parse and lessons assemble with typed recall',
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
        (module) => module.id == 'es.a0.m07',
      );

      final requiredCoverage = <String>{
        'grammar.es.a0.m07.polite_attention.v1',
        'grammar.es.a0.m07.puede_ayudarme.v1',
        'grammar.es.a0.m07.necesito.v1',
        'grammar.es.a0.m07.communication_repair.v1',
        'grammar.es.a0.m07.service_location_questions.v1',
        'grammar.es.a0.m07.emergency_requests.v1',
        'template.es.a0.m07.l044.type_disculpe_question.v1',
        'template.es.a0.m07.l045.type_puede_ayudarme.v1',
        'template.es.a0.m07.l046.type_hable_mas_despacio.v1',
        'template.es.a0.m07.l047.type_donde_bano.v1',
        'template.es.a0.m07.l048.type_necesito_medico.v1',
        'template.es.a0.m07.checkpoint.type_integrated_help.v1',
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
        greaterThanOrEqualTo(28),
      );
      expect(
        templates
            .where((template) => template.authoredMisconceptions.isNotEmpty)
            .length,
        greaterThanOrEqualTo(7),
      );
      expect(
        templates
            .where((template) => template.reviewTemplateIds.isNotEmpty)
            .length,
        greaterThanOrEqualTo(8),
      );
    },
  );

  test('C2H help answer evaluation preserves task distinctions', () async {
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
        'template.es.a0.m07.l045.type_puede_ayudarme.v1',
        '¿Puede ayudarme?',
      ).status,
      ActivityResultStatus.correct,
    );
    expect(
      evaluate(
        'template.es.a0.m07.l045.type_puede_ayudarme.v1',
        'Puede ayudarme?',
      ).status,
      ActivityResultStatus.acceptedWithFeedback,
    );
    expect(
      evaluate(
        'template.es.a0.m07.l045.type_puede_ayudarme.v1',
        'Necesito ayuda',
      ).feedbackKey,
      'response.question_expected_statement_provided',
    );
    expect(
      evaluate(
        'template.es.a0.m07.l045.type_necesito_ayuda.v1',
        '¿Puede ayudarme?',
      ).feedbackKey,
      'response.statement_expected_question_provided',
    );
    expect(
      evaluate(
        'template.es.a0.m07.l047.type_donde_bano.v1',
        'Está aquí',
      ).feedbackKey,
      'response.question_expected_answer',
    );
    expect(
      evaluate(
        'template.es.a0.m07.l049.type_service_help_sequence.v1',
        '¿Dónde está la farmacia? Disculpe',
      ).feedbackKey,
      'spanish.help.polite_opening_first',
    );
    expect(
      evaluate(
        'template.es.a0.m07.competency.complete_help_exchange.v1',
        'Necesito un médico',
      ).feedbackKey,
      'spanish.help.include_polite_attention',
    );
  });

  test(
    'production Module 7 competency resolves diagnostics and recovery flow',
    () async {
      const registry = CompetencyDefinitionRegistry();
      final definition = registry.lookup(
        moduleId: 'es.a0.m07',
        competencyId: 'competency.es.a0.m07.ask_for_basic_help',
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
        'task.es.a0.m07.complete_help_exchange',
      );
      final centralTemplate = contentCatalog.lookupAs<ExerciseTemplate>(
        'template.es.a0.m07.competency.complete_help_exchange.v1',
      )!;
      final missingAttention = const ActivityEngine().evaluate(
        template: centralTemplate,
        submission: const ActivitySubmission(
          submittedAnswer: 'Necesito un médico',
        ),
      );
      expect(
        missingAttention.feedbackKey,
        'spanish.help.include_polite_attention',
      );

      final recoverySources = centralTask.recoveryMappings
          .expand((mapping) => mapping.recoveryStepReferences)
          .map((reference) => reference.sourceModuleId)
          .toSet();
      expect(recoverySources, contains('es.a0.m07'));
      expect(recoverySources, contains('es.a0.m04'));

      const coordinator = CommunicativeCompetencyCoordinator();
      var state = coordinator.startAssessment(
        competencyId: definition.competency.competencyId,
      );
      for (final taskId in definition.competency.assessmentTaskIds.take(3)) {
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
        taskId: 'task.es.a0.m07.find_service',
        result: _incorrect('task.es.a0.m07.find_service'),
      );
      expect(
        failure.type,
        CompetencyAssessmentDecisionType.insertRecoverySteps,
      );
      expect(failure.recoveryInsertions.single.sourceModuleId, 'es.a0.m07');

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
            taskId: 'task.es.a0.m07.find_service',
            result: _correct('task.es.a0.m07.find_service'),
          )
          .updatedState;

      for (final taskId in definition.competency.assessmentTaskIds.skip(4)) {
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
