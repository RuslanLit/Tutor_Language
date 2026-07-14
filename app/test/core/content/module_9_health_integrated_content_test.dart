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

  test('C2J Module 9 uses canonical health/integration lesson IDs', () async {
    final course = await CurriculumLoader(assetBundle: rootBundle).loadCourse();
    final module8 = course.modules.singleWhere(
      (module) => module.id == 'es.a0.m08',
    );
    final module9 = course.modules.singleWhere(
      (module) => module.id == 'es.a0.m09',
    );

    expect(module8.lessonIds.last, 'es.a0.m08.l060');
    expect(module9.title, 'Health and Integrated Communication');
    expect(module9.lessonIds, [
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
    ]);

    final activeLessonIds = [
      for (final module in course.modules) ...module.lessonIds,
    ];
    expect(activeLessonIds, hasLength(70));
    expect(activeLessonIds.toSet(), hasLength(activeLessonIds.length));
    for (final retiredId in {
      'es.a0.m08.l030',
      'es.a0.m08.l031',
      'es.a0.m08.l032',
    }) {
      expect(activeLessonIds, isNot(contains(retiredId)));
    }
  });

  test('C2J Module 9 assets resolve and lessons assemble', () async {
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
      (module) => module.id == 'es.a0.m09',
    );

    final referencedIds = <String>{};
    final templates = <ExerciseTemplate>[];

    for (final lessonId in module.lessonIds) {
      final assembled = await service.assembleLesson(lessonId);
      expect(assembled.activities, isNotEmpty, reason: lessonId);
      final lesson = course.lessons.singleWhere(
        (lesson) => lesson.id == lessonId,
      );
      expect(lesson.moduleId, 'es.a0.m09');
      expect(lesson.communicativeOutcome, isNotNull);

      for (final activity in lesson.activities) {
        expect(activity.contentReferences, isNotEmpty, reason: activity.id);
        for (final reference in activity.contentReferences) {
          expect(catalog.canResolve(reference), isTrue, reason: lessonId);
          final referenceId = reference.referenceId;
          if (referenceId != null) {
            referencedIds.add(referenceId);
          }
          if (reference.type == 'exercise_template' && referenceId != null) {
            final template = catalog.lookupAs<ExerciseTemplate>(referenceId);
            expect(template, isNotNull, reason: referenceId);
            templates.add(template!);
          }
        }
      }
    }

    expect(
      referencedIds,
      containsAll({
        'grammar.es.a0.m09.estar_condition.v1',
        'grammar.es.a0.m09.tener_fever.v1',
        'grammar.es.a0.m09.me_duele.v1',
        'grammar.es.a0.m09.service_requests.v1',
        'grammar.es.a0.m09.integrated_health_exchange.v1',
        'dialogue.es.a0.m09.integrated_help.v1',
        'reading.es.a0.m09.final_profile.v1',
        'template.es.a0.m09.checkpoint.type_integrated_final.v1',
      }),
    );
    expect(
      templates.where((template) => template.exerciseType == 'text_entry'),
      hasLength(greaterThanOrEqualTo(24)),
    );
    expect(
      templates.where((template) => template.authoredMisconceptions.isNotEmpty),
      hasLength(greaterThanOrEqualTo(20)),
    );
  });

  test('C2J health content remains bounded and non-diagnostic', () async {
    final content = await ContentLoader(
      assetBundle: rootBundle,
    ).loadSpanishContent();
    final module9Text = StringBuffer();

    for (final contentFile in content.contents) {
      switch (contentFile) {
        case VocabularyContent(assetPath: final path, entries: final entries)
            when path.contains('module_9_health_integrated'):
          for (final entry in entries) {
            module9Text.writeln('${entry.spanish} ${entry.nativeTranslation}');
          }
        case GrammarContent(assetPath: final path, topics: final topics)
            when path.contains('module_9_health_integrated'):
          for (final topic in topics) {
            module9Text.writeln('${topic.explanation} ${topic.examples}');
          }
        case DialogueContent(assetPath: final path, dialogues: final dialogues)
            when path.contains('module_9_health_integrated'):
          for (final dialogue in dialogues) {
            for (final line in dialogue.lines) {
              module9Text.writeln(line.spanish);
            }
          }
        case ReadingContent(assetPath: final path, texts: final readings)
            when path.contains('module_9_health_integrated'):
          for (final reading in readings) {
            module9Text.writeln(reading.text);
          }
        case ExerciseTemplateContent(
              assetPath: final path,
              templates: final templates,
            )
            when path.contains('module_9_health_integrated'):
          for (final template in templates) {
            module9Text.writeln(
              '${template.promptTemplate} ${template.expectedAnswer ?? ''}',
            );
          }
        default:
          break;
      }
    }

    final text = module9Text.toString().toLowerCase();
    for (final forbidden in [
      'dosage',
      'dose',
      'medicine dosage',
      'diagnosis',
      'diagnose',
      'treatment',
      'prescription',
      'insurance',
      'pregnancy',
      'chronic',
      'mental health',
    ]) {
      expect(text, isNot(contains(forbidden)), reason: forbidden);
    }
  });

  test('C2J health answer evaluation preserves key distinctions', () async {
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
  });

  test(
    'production Module 9 competency resolves diagnostics and recovery',
    () async {
      const registry = CompetencyDefinitionRegistry();
      final definition = registry.lookup(
        moduleId: 'es.a0.m09',
        competencyId:
            'competency.es.a0.m09.handle_basic_health_and_help_exchange',
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
        expect(
          contentCatalog.lookupAs<ExerciseTemplate>(reference.referenceId!),
          isNotNull,
          reason: templateId,
        );
      }

      final centralTask = competencyCatalog.task(
        'task.es.a0.m09.integrated_a0_exchange',
      );
      final recoverySources = centralTask.recoveryMappings
          .expand((mapping) => mapping.recoveryStepReferences)
          .map((reference) => reference.sourceModuleId)
          .toSet();
      expect(recoverySources, contains('es.a0.m09'));
      expect(recoverySources, contains('es.a0.m03'));
      expect(recoverySources, contains('es.a0.m06'));
      expect(recoverySources, contains('es.a0.m08'));

      const coordinator = CommunicativeCompetencyCoordinator();
      var state = coordinator.startAssessment(
        competencyId: definition.competency.competencyId,
      );
      for (final taskId in definition.competency.assessmentTaskIds) {
        state = coordinator
            .recordTaskResult(
              catalog: competencyCatalog,
              state: state,
              taskId: taskId,
              result: ActivityResult(
                exerciseId: taskId,
                isCorrect: true,
                status: ActivityResultStatus.correct,
                feedbackKey: 'answer.correct',
              ),
            )
            .updatedState;
      }
      expect(
        coordinator
            .evaluateOutcome(catalog: competencyCatalog, state: state)
            .status,
        CompetencyOutcomeStatus.achieved,
      );
    },
  );
}
