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
    expect(lessonContent.activities, hasLength(5));
  });

  test(
    'resolves vocabulary, grammar, dialogue, reading, and practice content',
    () async {
      final service = LessonAssemblyService(
        curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
        contentLoader: ContentLoader(assetBundle: rootBundle),
      );

      final lessonContent = await service.assembleLesson('es.a0.m01.l001');

      expect(
        _activity(
          lessonContent,
          'activity.vocabulary.unit1_first_contact',
        ).resolvedContent,
        everyElement(isA<VocabularyItem>()),
      );
      expect(
        _activity(
          lessonContent,
          'activity.grammar.unit1_first_contact',
        ).resolvedContent,
        everyElement(isA<GrammarTopic>()),
      );
      expect(
        _activity(
          lessonContent,
          'activity.dialogue.unit1_first_contact',
        ).resolvedContent.single,
        isA<Dialogue>(),
      );
      expect(
        _activity(
          lessonContent,
          'activity.reading.unit1_first_contact',
        ).resolvedContent.single,
        isA<ReadingText>(),
      );
      expect(
        _activity(
          lessonContent,
          'activity.practice.unit1_first_contact',
        ).resolvedContent,
        everyElement(isA<ExerciseTemplate>()),
      );
    },
  );

  test('preserves declared lesson and content order', () async {
    final service = LessonAssemblyService(
      curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
      contentLoader: ContentLoader(assetBundle: rootBundle),
    );

    final lessonContent = await service.assembleLesson('es.a0.m01.l001');

    expect(lessonContent.activities.map((activity) => activity.activity.id), [
      'activity.vocabulary.unit1_first_contact',
      'activity.grammar.unit1_first_contact',
      'activity.dialogue.unit1_first_contact',
      'activity.reading.unit1_first_contact',
      'activity.practice.unit1_first_contact',
    ]);

    final vocabulary = _activity(
      lessonContent,
      'activity.vocabulary.unit1_first_contact',
    ).resolvedContent.cast<VocabularyItem>();

    expect(vocabulary.map((item) => item.id), [
      'vocab.es.a0.unit1.hola.v1',
      'vocab.es.a0.unit1.buenos_dias.v1',
      'vocab.es.a0.unit1.buenas_tardes.v1',
      'vocab.es.a0.unit1.buenas_noches.v1',
      'vocab.es.a0.unit1.adios.v1',
      'vocab.es.a0.unit1.hasta_luego.v1',
      'vocab.es.a0.unit1.gracias.v1',
      'vocab.es.a0.unit1.por_favor.v1',
      'vocab.es.a0.unit1.si.v1',
      'vocab.es.a0.unit1.no.v1',
      'vocab.es.a0.unit1.perdon.v1',
      'vocab.es.a0.unit1.de_nada.v1',
      'vocab.es.a0.unit1.no_entiendo.v1',
      'vocab.es.a0.unit1.repite.v1',
      'vocab.es.a0.unit1.mas_despacio.v1',
      'vocab.es.a0.unit1.mucho_gusto.v1',
      'vocab.es.a0.unit1.igualmente.v1',
      'vocab.es.a0.unit1.senor.v1',
      'vocab.es.a0.unit1.senora.v1',
      'vocab.es.a0.unit1.yo.v1',
      'vocab.es.a0.unit1.tu.v1',
      'vocab.es.a0.unit1.soy.v1',
      'vocab.es.a0.unit1.eres.v1',
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
