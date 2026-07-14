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

  test('C2E Module 4 uses canonical people-conversation lesson IDs', () async {
    final course = await CurriculumLoader(assetBundle: rootBundle).loadCourse();
    final module3 = course.modules.singleWhere(
      (module) => module.id == 'es.a0.m03',
    );
    final module4 = course.modules.singleWhere(
      (module) => module.id == 'es.a0.m04',
    );
    final module5 = course.modules.singleWhere(
      (module) => module.id == 'es.a0.m05',
    );

    expect(module4.title, 'People and Everyday Conversation');
    expect(module4.lessonIds, [
      'es.a0.m04.l020',
      'es.a0.m04.l021',
      'es.a0.m04.l022',
      'es.a0.m04.l023',
      'es.a0.m04.l024',
      'es.a0.m04.l025',
      'es.a0.m04.l026',
      'es.a0.m04.l027',
    ]);
    expect(
      module4.lessonIds.every((lessonId) => lessonId.startsWith('es.a0.m04.')),
      isTrue,
    );
    expect(module3.lessonIds, [
      'es.a0.m03.l013',
      'es.a0.m03.l014',
      'es.a0.m03.l015',
      'es.a0.m03.l016',
      'es.a0.m03.l017',
      'es.a0.m03.l018',
      'es.a0.m03.l019',
    ]);
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

    final referencedLessonIds = [
      for (final module in course.modules) ...module.lessonIds,
    ];
    expect(referencedLessonIds.toSet(), hasLength(referencedLessonIds.length));

    for (final lessonId in module4.lessonIds) {
      final lesson = course.lessons.singleWhere(
        (lesson) => lesson.id == lessonId,
      );
      expect(lesson.moduleId, 'es.a0.m04');
    }
  });

  test('C2E Module 4 lessons assemble with recall coverage', () async {
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
      (module) => module.id == 'es.a0.m04',
    );

    final referencedIds = <String>{};
    final referencedTemplates = <ExerciseTemplate>[];
    for (final lessonId in module.lessonIds) {
      final assembled = await service.assembleLesson(lessonId);
      expect(assembled.activities, isNotEmpty, reason: lessonId);

      final lesson = course.lessons.singleWhere(
        (lesson) => lesson.id == lessonId,
      );
      final templateIds = lesson.activities
          .expand((activity) => activity.contentReferences)
          .where((reference) => reference.type == 'exercise_template')
          .map((reference) => reference.referenceId)
          .whereType<String>()
          .toList();
      expect(templateIds, isNotEmpty, reason: lessonId);

      final templates = templateIds
          .map(catalog.lookupAs<ExerciseTemplate>)
          .whereType<ExerciseTemplate>()
          .toList();
      referencedTemplates.addAll(templates);
      referencedIds.addAll(
        lesson.activities
            .expand((activity) => activity.contentReferences)
            .map((reference) => reference.referenceId)
            .whereType<String>(),
      );

      expect(
        templates.any((template) => template.exerciseType == 'text_entry'),
        isTrue,
        reason: '$lessonId should include typed recall.',
      );
    }

    for (final requiredId in [
      'grammar.es.a0.m04.who_is_person.v1',
      'grammar.es.a0.m04.third_person_identity.v1',
      'grammar.es.a0.m04.basic_gender_agreement.v1',
      'template.es.a0.m04.l020.type_se_llama_marta.v1',
      'template.es.a0.m04.l023.type_vive_en_lima.v1',
      'template.es.a0.m04.l025.type_everyday_answer.v1',
      'template.es.a0.m04.checkpoint.type_conversation_questions.v1',
    ]) {
      expect(referencedIds, contains(requiredId));
    }

    expect(
      referencedTemplates
          .where((template) => template.exerciseType == 'text_entry')
          .length,
      greaterThanOrEqualTo(20),
    );
    expect(
      referencedTemplates
          .where((template) => template.authoredMisconceptions.isNotEmpty)
          .length,
      greaterThanOrEqualTo(15),
    );
  });

  test(
    'C2E Module 4 answer evaluation preserves person distinctions',
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
          'template.es.a0.m04.l020.type_se_llama_marta.v1',
          'Se llama Marta',
        ).status,
        ActivityResultStatus.correct,
      );
      expect(
        evaluate(
          'template.es.a0.m04.l020.type_se_llama_marta.v1',
          'Me llamo Marta',
        ).feedbackKey,
        'spanish.people.use_se_llama',
      );
      expect(
        evaluate(
          'template.es.a0.m04.l023.type_vive_en_lima.v1',
          'Vivo en Lima',
        ).feedbackKey,
        'spanish.people.use_vive_for_other',
      );
      expect(
        evaluate(
          'template.es.a0.m04.l023.type_habla_ingles.v1',
          'Hablo inglés',
        ).feedbackKey,
        'spanish.people.use_habla_for_other',
      );
      expect(
        evaluate(
          'template.es.a0.m04.l021.type_es_mi_amiga.v1',
          'Es mi amigo',
        ).feedbackKey,
        'spanish.people.use_feminine_role',
      );
      expect(
        evaluate(
          'template.es.a0.m04.l022.type_como_es.v1',
          '¿Quién es?',
        ).feedbackKey,
        'spanish.people.question_como_not_quien',
      );
    },
  );

  test(
    'production Module 4 competency resolves diagnostics and recovery',
    () async {
      const registry = CompetencyDefinitionRegistry();
      final definition = registry.lookup(
        moduleId: 'es.a0.m04',
        competencyId:
            'competency.es.a0.m04.describe_person_and_hold_basic_conversation',
      );
      expect(definition, isNotNull);

      final catalog = registry.catalogFor(definition!);
      final validation = const CommunicativeCompetencyValidator().validate(
        catalog,
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
        final template = contentCatalog.lookupAs<ExerciseTemplate>(
          reference.referenceId!,
        );
        expect(template, isNotNull, reason: templateId);
        expect(reference.assetPath, contains('/templates/'));
      }

      final factsTask = catalog.task('task.es.a0.m04.state_person_facts');
      final recoverySources = factsTask.recoveryMappings
          .expand((mapping) => mapping.recoveryStepReferences)
          .map((reference) => reference.sourceModuleId)
          .toSet();
      expect(recoverySources, contains('es.a0.m03'));

      final identifyTemplate = contentCatalog.lookupAs<ExerciseTemplate>(
        'template.es.a0.m04.competency.identify_person.v1',
      )!;
      final reverseIdentity = const ActivityEngine().evaluate(
        template: identifyTemplate,
        submission: const ActivitySubmission(
          submittedAnswer: 'Se llama Marta. Es Marta',
        ),
      );
      expect(reverseIdentity.status, ActivityResultStatus.acceptedWithFeedback);

      final wrongPerson = const ActivityEngine().evaluate(
        template: identifyTemplate,
        submission: const ActivitySubmission(
          submittedAnswer: 'Me llamo Marta. Es Marta',
        ),
      );
      expect(wrongPerson.status, ActivityResultStatus.incorrect);

      final exchangeTemplate = contentCatalog.lookupAs<ExerciseTemplate>(
        'template.es.a0.m04.competency.everyday_exchange.v1',
      )!;
      final reverseExchange = const ActivityEngine().evaluate(
        template: exchangeTemplate,
        submission: const ActivitySubmission(
          submittedAnswer: 'Habla español. Es mi profesora',
        ),
      );
      expect(reverseExchange.status, ActivityResultStatus.acceptedWithFeedback);
    },
  );
}
