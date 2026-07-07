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

    final lessonContent = await service.assembleLesson('es.a0.m01.l001');

    expect(lessonContent.lesson.id, 'es.a0.m01.l001');
    expect(lessonContent.sections, hasLength(1));
    expect(lessonContent.activities, hasLength(4));
  });

  test('resolves vocabulary, grammar, dialogue, and reading content', () async {
    final service = LessonAssemblyService(
      curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
      contentLoader: ContentLoader(assetBundle: rootBundle),
    );

    final lessonContent = await service.assembleLesson('es.a0.m01.l001');

    expect(
      _activity(lessonContent, 'activity.vocabulary.greetings').resolvedContent,
      everyElement(isA<VocabularyItem>()),
    );
    expect(
      _activity(
        lessonContent,
        'activity.grammar.llamarse',
      ).resolvedContent.single,
      isA<GrammarTopic>(),
    );
    expect(
      _activity(
        lessonContent,
        'activity.dialogue.greetings',
      ).resolvedContent.single,
      isA<Dialogue>(),
    );
    expect(
      _activity(
        lessonContent,
        'activity.reading.basic_greeting',
      ).resolvedContent.single,
      isA<ReadingText>(),
    );
  });

  test('preserves declared lesson and content order', () async {
    final service = LessonAssemblyService(
      curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
      contentLoader: ContentLoader(assetBundle: rootBundle),
    );

    final lessonContent = await service.assembleLesson('es.a0.m01.l001');

    expect(lessonContent.activities.map((activity) => activity.activity.id), [
      'activity.vocabulary.greetings',
      'activity.dialogue.greetings',
      'activity.grammar.llamarse',
      'activity.reading.basic_greeting',
    ]);

    final vocabulary = _activity(
      lessonContent,
      'activity.vocabulary.greetings',
    ).resolvedContent.cast<VocabularyItem>();

    expect(vocabulary.map((item) => item.id), [
      'vocab.hola.v1',
      'vocab.buenos_dias.v1',
      'vocab.buenas_tardes.v1',
      'vocab.buenas_noches.v1',
      'vocab.gracias.v1',
      'vocab.por_favor.v1',
      'vocab.adios.v1',
      'vocab.me_llamo.v1',
      'vocab.soy.v1',
      'vocab.mucho_gusto.v1',
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
