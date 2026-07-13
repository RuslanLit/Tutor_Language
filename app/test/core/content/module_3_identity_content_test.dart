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
    'C2D Module 3 is ordered as personal identity production content',
    () async {
      final course = await CurriculumLoader(
        assetBundle: rootBundle,
      ).loadCourse();
      final module = course.modules.singleWhere(
        (module) => module.id == 'es.a0.m03',
      );

      expect(module.title, 'Origin, Languages and Personal Identity');
      expect(module.lessonIds, [
        'es.a0.m03.l013',
        'es.a0.m03.l014',
        'es.a0.m03.l015',
        'es.a0.m03.l016',
        'es.a0.m03.l017',
        'es.a0.m03.l018',
        'es.a0.m03.l019',
      ]);

      final lessons = module.lessonIds.map((id) {
        return course.lessons.singleWhere((lesson) => lesson.id == id);
      }).toList();
      expect(lessons.every((lesson) => lesson.moduleId == 'es.a0.m03'), isTrue);
      expect(
        module.lessonIds.every((lessonId) => lessonId.startsWith('es.a0.m03.')),
        isTrue,
      );
      expect(lessons.last.title, 'Module 3 Foundations Checkpoint');
    },
  );

  test('C2D-Fix preserves existing module ownership boundaries', () async {
    final course = await CurriculumLoader(
      assetBundle: rootBundle,
    ).loadCourse();

    final module2 = course.modules.singleWhere(
      (module) => module.id == 'es.a0.m02',
    );
    final module3 = course.modules.singleWhere(
      (module) => module.id == 'es.a0.m03',
    );
    final module5 = course.modules.singleWhere(
      (module) => module.id == 'es.a0.m05',
    );

    expect(module2.lessonIds, [
      'es.a0.m02.l004',
      'es.a0.m02.l007',
      'es.a0.m06.l017',
      'es.a0.m02.l008',
      'es.a0.m02.l009',
      'es.a0.m05.l013',
    ]);
    expect(module5.lessonIds, ['es.a0.m05.l014', 'es.a0.m05.l015']);
    expect(module3.lessonIds, isNot(contains('es.a0.m02.l005')));
    expect(module3.lessonIds, isNot(contains('es.a0.m05.l015')));
    expect(module3.lessonIds.last, 'es.a0.m03.l019');

    final referencedLessonIds = [
      for (final module in course.modules) ...module.lessonIds,
    ];
    expect(referencedLessonIds.toSet(), hasLength(referencedLessonIds.length));

    for (final lessonId in module3.lessonIds) {
      final lesson = course.lessons.singleWhere(
        (lesson) => lesson.id == lessonId,
      );
      expect(lesson.moduleId, 'es.a0.m03');
      expect(lesson.id.startsWith('es.a0.m03.'), isTrue);
    }

    final restoredModule5Checkpoint = course.lessons.singleWhere(
      (lesson) => lesson.id == 'es.a0.m05.l015',
    );
    expect(restoredModule5Checkpoint.title, 'A0 Checkpoint');
    expect(restoredModule5Checkpoint.moduleId, 'es.a0.m05');
  });

  test(
    'C2D Module 3 lessons assemble with recall and application coverage',
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
        (module) => module.id == 'es.a0.m03',
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
        referencedIds.addAll(templateIds);
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
        'grammar.es.a0.m03.origin_soy_de.v1',
        'grammar.es.a0.m03.residence_vivo_en.v1',
        'grammar.es.a0.m03.languages_hablo.v1',
        'grammar.es.a0.m03.languages_un_poco.v1',
        'grammar.es.a0.m03.identity_profile.v1',
        'template.es.a0.m03.l014.type_de_donde_eres.v1',
        'template.es.a0.m03.l015.type_donde_vives.v1',
        'template.es.a0.m03.l016.type_que_idiomas_hablas.v1',
        'template.es.a0.m03.l018.type_profile_elena.v1',
        'template.es.a0.m03.checkpoint.type_profile.v1',
      ]) {
        expect(referencedIds, contains(requiredId));
      }

      expect(
        referencedTemplates
            .where((template) => template.exerciseType == 'text_entry')
            .length,
        greaterThanOrEqualTo(15),
      );
      expect(
        referencedTemplates
            .where((template) => template.authoredMisconceptions.isNotEmpty)
            .length,
        greaterThanOrEqualTo(10),
      );
    },
  );

  test(
    'C2D Module 3 answer evaluation preserves meaning distinctions',
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
          'template.es.a0.m03.l013.type_soy_de_ucrania.v1',
          'Soy de Ucrania',
        ).status,
        ActivityResultStatus.correct,
      );
      expect(
        evaluate(
          'template.es.a0.m03.l014.type_de_donde_eres.v1',
          'De donde eres?',
        ).status,
        ActivityResultStatus.acceptedWithFeedback,
      );
      expect(
        evaluate(
          'template.es.a0.m03.l013.type_soy_de_ucrania.v1',
          'Vivo en Ucrania',
        ).feedbackKey,
        'spanish.origin.use_soy_de',
      );
      expect(
        evaluate(
          'template.es.a0.m03.l015.type_vivo_en_kyiv.v1',
          'Soy de Kyiv',
        ).feedbackKey,
        'spanish.residence.use_vivo_en',
      );
      expect(
        evaluate(
          'template.es.a0.m03.l016.type_hablo_espanol.v1',
          'Vivo español',
        ).feedbackKey,
        'spanish.languages.use_hablo',
      );
      expect(
        evaluate(
          'template.es.a0.m03.l016.type_hablo_un_poco_espanol.v1',
          'Hablo un poco español',
        ).feedbackKey,
        'spanish.languages.keep_de_after_un_poco',
      );
    },
  );

  test(
    'production Module 3 competency resolves diagnostic and recovery steps',
    () async {
      const registry = CompetencyDefinitionRegistry();
      final definition = registry.lookup(
        moduleId: 'es.a0.m03',
        competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
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

      final introTask = catalog.task('task.es.a0.introduce_self');
      final introRecovery =
          introTask.recoveryMappings.single.recoveryStepReferences.single;
      expect(introRecovery.sourceModuleId, 'es.a0.m02');
      expect(
        introRecovery.sourceStepId,
        'template.es.a0.m02.l004.name_pattern_choice.v1',
      );
    },
  );
}
