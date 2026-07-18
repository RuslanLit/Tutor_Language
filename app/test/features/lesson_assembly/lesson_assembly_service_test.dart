import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_document.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_assembly_service.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('assembles first lesson from bundled content', () async {
    final service = LessonAssemblyService(
      curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
      contentLoader: ContentLoader(assetBundle: rootBundle),
    );

    final lessonContent = await service.assembleLesson('es.a0.m06.l016');

    expect(lessonContent.lesson.id, 'es.a0.m06.l016');
    expect(lessonContent.sections, hasLength(1));
    expect(lessonContent.activities, hasLength(4));
  });

  test(
    'assembles early Spanish A0 production lessons from bundled content',
    () async {
      final service = LessonAssemblyService(
        curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
        contentLoader: ContentLoader(assetBundle: rootBundle),
      );

      for (final lessonId in [
        'es.a0.m06.l016',
        'es.a0.m01.l002',
        'es.a0.m01.l003',
        'es.a0.m02.l004',
        'es.a0.m03.l013',
        'es.a0.m03.l014',
        'es.a0.m03.l015',
        'es.a0.m03.l016',
        'es.a0.m03.l017',
        'es.a0.m03.l018',
        'es.a0.m04.l010',
      ]) {
        final lessonContent = await service.assembleLesson(lessonId);

        expect(lessonContent.lesson.id, lessonId);
        expect(lessonContent.activities, isNotEmpty);
        expect(
          lessonContent.activities.expand(
            (activity) => activity.resolvedContent,
          ),
          isNotEmpty,
        );
      }
    },
  );

  test('resolves the Lesson 1 scenario content', () async {
    final service = LessonAssemblyService(
      curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
      contentLoader: ContentLoader(assetBundle: rootBundle),
    );

    final lessonContent = await service.assembleLesson('es.a0.m06.l016');

    expect(
      _activity(
        lessonContent,
        'es.a0.m06.l016.activity.vocabulary',
      ).resolvedContent,
      [isA<GrammarTopic>(), isA<ExerciseTemplate>(), isA<ExerciseTemplate>()],
    );
    expect(
      _activity(
        lessonContent,
        'es.a0.m06.l016.activity.grammar',
      ).resolvedContent,
      [isA<GrammarTopic>(), isA<ExerciseTemplate>()],
    );
    expect(
      _activity(
        lessonContent,
        'es.a0.m06.l016.activity.practice',
      ).resolvedContent,
      everyElement(isA<ExerciseTemplate>()),
    );
  });

  test('preserves declared lesson and content order', () async {
    final service = LessonAssemblyService(
      curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
      contentLoader: ContentLoader(assetBundle: rootBundle),
    );

    final lessonContent = await service.assembleLesson('es.a0.m06.l016');

    expect(lessonContent.activities.map((activity) => activity.activity.id), [
      'es.a0.m06.l016.activity.vocabulary',
      'es.a0.m06.l016.activity.grammar',
      'es.a0.m06.l016.activity.reading',
      'es.a0.m06.l016.activity.practice',
    ]);

    final templates = lessonContent.activities
        .expand((activity) => activity.resolvedContent)
        .whereType<ExerciseTemplate>();

    expect(templates.map((template) => template.id), [
      'template.es.a0.m01.l001.focus_hola.v1',
      'template.es.a0.m01.l001.meaning_hola.v1',
      'template.es.a0.m01.l001.decode_hola.v1',
      'template.es.a0.m01.l001.context_arrival_hola.v1',
      'template.es.a0.m01.l001.guided_type_hola.v1',
      'template.es.a0.m01.l001.independent_type_hola.v1',
    ]);

    final grammar = _activity(
      lessonContent,
      'es.a0.m06.l016.activity.vocabulary',
    ).resolvedContent.whereType<GrammarTopic>();

    expect(grammar.map((item) => item.id), [
      'grammar.es.a0.m01.l001.first_encounter.v1',
    ]);
  });

  test('missing asset fails assembly', () {
    final service = LessonAssemblyService();

    expect(
      () => service.assembleLessonDefinition(
        lesson: _lessonWithReference(
          const LessonContentReference(
            type: 'vocabulary',
            assetPath: 'assets/languages/spanish/vocabulary/missing.json',
            referenceId: 'vocab.hola.v1',
          ),
        ),
        catalog: _catalog,
      ),
      throwsA(isA<LessonAssemblyException>()),
    );
  });

  test('invalid referenceId fails assembly', () {
    final service = LessonAssemblyService();

    expect(
      () => service.assembleLessonDefinition(
        lesson: _lessonWithReference(
          const LessonContentReference(
            type: 'vocabulary',
            assetPath: _vocabularyAssetPath,
            referenceId: 'vocab.missing.v1',
          ),
        ),
        catalog: _catalog,
      ),
      throwsA(isA<LessonAssemblyException>()),
    );
  });

  test('incorrect content type fails assembly', () {
    final service = LessonAssemblyService();

    expect(
      () => service.assembleLessonDefinition(
        lesson: _lessonWithReference(
          const LessonContentReference(
            type: 'grammar',
            assetPath: _vocabularyAssetPath,
            referenceId: 'vocab.hola.v1',
          ),
        ),
        catalog: _catalog,
      ),
      throwsA(isA<LessonAssemblyException>()),
    );
  });
}

LessonContentActivity _activity(
  LessonContent lessonContent,
  String activityId,
) {
  return lessonContent.activities.singleWhere(
    (activity) => activity.activity.id == activityId,
  );
}

Lesson _lessonWithReference(LessonContentReference reference) {
  return Lesson(
    id: 'lesson.test.v1',
    moduleId: 'module.test.v1',
    title: 'Test Lesson',
    primaryObjective: const LessonObjective(
      id: 'objective.test.v1',
      description: 'Resolve content.',
    ),
    activities: [
      LessonActivity(
        id: 'activity.test.v1',
        title: 'Test Activity',
        type: reference.type,
        contentReferences: [reference],
      ),
    ],
    prerequisites: const [],
    estimatedDurationMinutes: 10,
    completionCriteria: const LessonCompletionCriteria(
      minimumCompletedActivities: 1,
    ),
  );
}

const _vocabularyAssetPath = 'assets/languages/spanish/vocabulary/test.json';

final _catalog = EducationalContentCatalog(
  const EducationalContentBundle(
    contents: [
      VocabularyContent(
        assetPath: _vocabularyAssetPath,
        entries: [
          VocabularyItem(
            id: 'vocab.hola.v1',
            spanish: 'hola',
            nativeTranslation: 'hello',
            cefr: 'A0',
            example: 'Hola.',
          ),
        ],
      ),
    ],
  ),
);
