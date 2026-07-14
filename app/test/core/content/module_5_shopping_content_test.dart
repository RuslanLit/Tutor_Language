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
    'C2F Module 5 uses canonical shopping lesson IDs and preserves earlier modules',
    () async {
      final course = await CurriculumLoader(
        assetBundle: rootBundle,
      ).loadCourse();
      final module4 = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m04',
      );
      final module5 = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m05',
      );
      final module6 = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m06',
      );

      expect(module5.title, 'Shopping and Everyday Objects');
      expect(module5.lessonIds, [
        'es.a0.m05.l028',
        'es.a0.m05.l029',
        'es.a0.m05.l030',
        'es.a0.m05.l031',
        'es.a0.m05.l032',
        'es.a0.m05.l033',
        'es.a0.m05.l034',
        'es.a0.m05.l035',
      ]);
      expect(
        module5.lessonIds.every((id) => id.startsWith('es.a0.m05.')),
        isTrue,
      );
      expect(module4.lessonIds.last, 'es.a0.m04.l027');
      expect(module6.lessonIds.first, 'es.a0.m06.l018');

      final activeLessonIds = [
        for (final module in course.modules) ...module.lessonIds,
      ];
      expect(activeLessonIds.toSet(), hasLength(activeLessonIds.length));
      expect(activeLessonIds, isNot(contains('es.a0.m05.l014')));
      expect(activeLessonIds, isNot(contains('es.a0.m05.l015')));

      for (final lessonId in module5.lessonIds) {
        final lesson = course.lessons.singleWhere(
          (lesson) => lesson.id == lessonId,
        );
        expect(lesson.moduleId, 'es.a0.m05');
        expect(lesson.communicativeOutcome, isNotNull);
      }
    },
  );

  test(
    'C2F Module 5 assets parse and lessons assemble with typed recall',
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
        (module) => module.id == 'es.a0.m05',
      );

      final requiredCoverage = <String>{
        'grammar.es.a0.m05.que_es_esto.v1',
        'grammar.es.a0.m05.polite_availability.v1',
        'grammar.es.a0.m05.price_question.v1',
        'grammar.es.a0.m05.caro_barato_gender.v1',
        'grammar.es.a0.m05.purchase_request.v1',
        'template.es.a0.m05.l028.type_que_es_esto.v1',
        'template.es.a0.m05.l029.type_tiene_agua.v1',
        'template.es.a0.m05.l030.type_cuanto_cuesta.v1',
        'template.es.a0.m05.l031.type_la_bolsa_es_barata.v1',
        'template.es.a0.m05.l032.type_quiero_una_botella.v1',
        'template.es.a0.m05.l033.type_basic_purchase_exchange.v1',
        'template.es.a0.m05.checkpoint.type_short_exchange.v1',
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
        greaterThanOrEqualTo(20),
      );
      expect(
        templates
            .where((template) => template.authoredMisconceptions.isNotEmpty)
            .length,
        greaterThanOrEqualTo(10),
      );
      expect(
        templates
            .where((template) => template.reviewTemplateIds.isNotEmpty)
            .length,
        greaterThanOrEqualTo(10),
      );
    },
  );

  test(
    'C2F shopping answer evaluation preserves function and price distinctions',
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
          'template.es.a0.m05.l028.type_que_es_esto.v1',
          '¿Qué es esto?',
        ).status,
        ActivityResultStatus.correct,
      );
      expect(
        evaluate(
          'template.es.a0.m05.l028.type_que_es_esto.v1',
          'Que es esto?',
        ).status,
        ActivityResultStatus.acceptedWithFeedback,
      );
      expect(
        evaluate(
          'template.es.a0.m05.l030.type_cuanto_cuesta.v1',
          '¿Qué es esto?',
        ).feedbackKey,
        'spanish.shopping.use_cuanto_for_price',
      );
      expect(
        evaluate(
          'template.es.a0.m05.l030.type_cuesta_cinco_euros.v1',
          'Es cinco euros',
        ).feedbackKey,
        'spanish.shopping.use_cuesta_for_price',
      );
      expect(
        evaluate(
          'template.es.a0.m05.l032.type_quiero_una_botella.v1',
          'Tengo una botella',
        ).feedbackKey,
        'spanish.shopping.use_quiero_for_purchase',
      );
      expect(
        evaluate(
          'template.es.a0.m05.l032.type_quiero_una_botella.v1',
          'Quiero un botella',
        ).feedbackKey,
        'spanish.shopping.use_una_feminine',
      );
      expect(
        evaluate(
          'template.es.a0.m05.l032.type_este_libro.v1',
          'Esta libro por favor',
        ).feedbackKey,
        'spanish.shopping.use_este_masculine',
      );
      expect(
        evaluate(
          'template.es.a0.m05.l031.type_la_bolsa_es_barata.v1',
          'La bolsa es barato',
        ).feedbackKey,
        'spanish.shopping.use_feminine_price_adjective',
      );
      expect(
        evaluate(
          'template.es.a0.m05.checkpoint.type_price_answer.v1',
          'Cuesta dos euros',
        ).status,
        ActivityResultStatus.incorrect,
      );
    },
  );

  test(
    'production Module 5 competency resolves diagnostics and recovery flow',
    () async {
      const registry = CompetencyDefinitionRegistry();
      final definition = registry.lookup(
        moduleId: 'es.a0.m05',
        competencyId: 'competency.es.a0.m05.complete_basic_shopping_exchange',
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
        'task.es.a0.m05.basic_purchase_exchange',
      );
      final centralTemplate = contentCatalog.lookupAs<ExerciseTemplate>(
        'template.es.a0.m05.competency.basic_purchase_exchange.v1',
      )!;
      expect(centralTemplate.acceptedWithFeedbackAnswers, isEmpty);
      final wrongShoppingOrder = const ActivityEngine().evaluate(
        template: centralTemplate,
        submission: const ActivitySubmission(
          submittedAnswer:
              'Nada más, gracias. Hola. ¿Tiene agua? ¿Cuánto cuesta? Quiero una botella, por favor',
        ),
      );
      expect(wrongShoppingOrder.status, ActivityResultStatus.incorrect);

      final recoverySources = centralTask.recoveryMappings
          .expand((mapping) => mapping.recoveryStepReferences)
          .map((reference) => reference.sourceModuleId)
          .toSet();
      expect(recoverySources, contains('es.a0.m04'));
      expect(
        definition.recoveryTemplateIds['micro.es.a0.respond_to_seller'],
        startsWith('template.es.a0.m01.'),
      );

      const coordinator = CommunicativeCompetencyCoordinator();
      var state = coordinator.startAssessment(
        competencyId: definition.competency.competencyId,
      );
      for (final taskId in definition.competency.assessmentTaskIds.take(2)) {
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
        taskId: 'task.es.a0.m05.ask_price',
        result: _incorrect('task.es.a0.m05.ask_price'),
      );
      expect(
        failure.type,
        CompetencyAssessmentDecisionType.insertRecoverySteps,
      );
      expect(failure.recoveryInsertions.single.sourceModuleId, 'es.a0.m05');

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
            taskId: 'task.es.a0.m05.ask_price',
            result: _correct('task.es.a0.m05.ask_price'),
          )
          .updatedState;

      for (final taskId in definition.competency.assessmentTaskIds.skip(3)) {
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
