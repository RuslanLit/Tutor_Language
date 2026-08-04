import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_document.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/activity_engine/activity_engine.dart';
import 'package:tutor_language/features/activity_engine/activity_result.dart';
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
    expect(lessonContent.activities, hasLength(1));
  });

  test('resolves the canonical Lesson 1 content', () async {
    final service = LessonAssemblyService(
      curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
      contentLoader: ContentLoader(assetBundle: rootBundle),
    );

    final lessonContent = await service.assembleLesson('es.a0.m01.l001');

    final firstResolved = _activity(
      lessonContent,
      'es.a0.m01.l001.activity.first_contact_exchange',
    ).resolvedContent;
    expect(firstResolved, hasLength(13));
    expect(firstResolved.take(3), [
      isA<GrammarTopic>(),
      isA<Dialogue>(),
      isA<GrammarTopic>(),
    ]);
    expect(firstResolved.skip(3), everyElement(isA<ExerciseTemplate>()));
  });

  test('resolves the canonical Lesson 2 content', () async {
    final service = LessonAssemblyService(
      curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
      contentLoader: ContentLoader(assetBundle: rootBundle),
    );

    final lessonContent = await service.assembleLesson('es.a0.m01.l002');

    expect(
      _activity(
        lessonContent,
        'es.a0.m01.l002.activity.about_myself_exchange',
      ).resolvedContent,
      [
        isA<ExerciseTemplate>(),
        isA<Dialogue>(),
        isA<GrammarTopic>(),
        isA<Dialogue>(),
        isA<GrammarTopic>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
        isA<ExerciseTemplate>(),
      ],
    );
  });

  test('resolves the canonical Lessons 3 to 5 content', () async {
    final service = LessonAssemblyService(
      curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
      contentLoader: ContentLoader(assetBundle: rootBundle),
    );
    final expected = <String, ({String activityId, int contentCount})>{
      'es.a0.m01.l003': (
        activityId: 'es.a0.m01.l003.activity.polite_conversation',
        contentCount: 20,
      ),
      'es.a0.m01.l004': (
        activityId: 'es.a0.m01.l004.activity.introduce_other_person',
        contentCount: 21,
      ),
      'es.a0.m01.l005': (
        activityId: 'es.a0.m01.l005.activity.talk_about_person',
        contentCount: 21,
      ),
    };

    for (final entry in expected.entries) {
      final lessonContent = await service.assembleLesson(entry.key);
      final resolved = _activity(
        lessonContent,
        entry.value.activityId,
      ).resolvedContent;

      expect(resolved, hasLength(entry.value.contentCount));
      expect(resolved.whereType<GrammarTopic>(), isNotEmpty);
      expect(resolved.whereType<Dialogue>(), isNotEmpty);
      expect(resolved.whereType<ExerciseTemplate>(), isNotEmpty);
    }
  });

  test('preserves declared lesson and content order', () async {
    final service = LessonAssemblyService(
      curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
      contentLoader: ContentLoader(assetBundle: rootBundle),
    );

    final lessonContent = await service.assembleLesson('es.a0.m01.l001');

    expect(lessonContent.activities.map((activity) => activity.activity.id), [
      'es.a0.m01.l001.activity.first_contact_exchange',
    ]);

    final grammar = lessonContent.activities
        .expand((activity) => activity.resolvedContent)
        .whereType<GrammarTopic>();

    expect(grammar.map((item) => item.id), [
      'grammar.es.a0.m01.l001.first_meeting_goal',
      'grammar.es.a0.m01.l001.reading_support',
    ]);

    final templates = lessonContent.activities
        .expand((activity) => activity.resolvedContent)
        .whereType<ExerciseTemplate>();

    expect(templates.map((item) => item.id), [
      'template.es.a0.m01.l001.identify_morning_greeting',
      'template.es.a0.m01.l001.identify_opening_function',
      'template.es.a0.m01.l001.choose_identity_next_line',
      'template.es.a0.m01.l001.restore_identity_lines',
      'template.es.a0.m01.l001.choose_name_question',
      'template.es.a0.m01.l001.understand_answer',
      'template.es.a0.m01.l001.choose_next_message',
      'template.es.a0.m01.l001.choose_closing_line',
      'template.es.a0.m01.l001.guided_full_contact',
      'template.es.a0.m01.l001.independent_full_contact',
    ]);

    final finalTemplate = templates.singleWhere(
      (item) => item.id == 'template.es.a0.m01.l001.independent_full_contact',
    );
    expect(
      finalTemplate.expectedAnswer,
      'Hola. Buenos días.\n'
      'Me llamo Marta.\n'
      '¿Cómo te llamas?\n'
      'Me llamo Ana.\n'
      'Mucho gusto.\n'
      'Hasta luego.',
    );
    expect(finalTemplate.productionContract?.mode, 'ordered_functions');
    expect(finalTemplate.productionContract?.functions.map((item) => item.id), [
      'greeting',
      'self_introduction',
      'ask_name',
      'name_response',
      'polite_reaction',
      'farewell',
    ]);
    final guidedTemplate = templates.singleWhere(
      (item) => item.id == 'template.es.a0.m01.l001.guided_full_contact',
    );
    expect(guidedTemplate.productionContract, isNotNull);

    final punctuationVariant = const ActivityEngine().evaluate(
      template: finalTemplate,
      submission: const ActivitySubmission(
        submittedAnswer:
            'Hola! Buenos días.\n'
            'Me llamo Marta.\n'
            '¿Cómo te llamas?\n'
            'Me llamo Ana.\n'
            'Mucho gusto.\n'
            'Hasta luego!',
      ),
    );
    expect(punctuationVariant.isCorrect, isTrue);
    expect(
      punctuationVariant.status,
      ActivityResultStatus.acceptedWithFeedback,
    );
  });

  test('canonical Lesson 1 restore step evaluates authored answer', () async {
    final service = LessonAssemblyService(
      curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
      contentLoader: ContentLoader(assetBundle: rootBundle),
    );
    final lessonContent = await service.assembleLesson('es.a0.m01.l001');
    final template = lessonContent.activities
        .expand((activity) => activity.resolvedContent)
        .whereType<ExerciseTemplate>()
        .singleWhere(
          (item) => item.id == 'template.es.a0.m01.l001.restore_identity_lines',
        );

    expect(template.exerciseType, 'fill_gap');
    expect(template.expectedAnswer, 'Me llamo Marta.');
    expect(template.acceptedWithFeedbackAnswers, hasLength(1));

    for (final answer in [
      'Me llamo Marta.',
      'Me llamo Marta',
      'me llamo marta.',
      'me llamo marta',
    ]) {
      final result = const ActivityEngine().evaluate(
        template: template,
        submission: ActivitySubmission(submittedAnswer: answer),
      );
      expect(result.status, ActivityResultStatus.correct, reason: answer);
    }

    final obsolete = const ActivityEngine().evaluate(
      template: template,
      submission: const ActivitySubmission(
        submittedAnswer: 'Me llamo Marta. Soy de Ucrania. Vivo en Kyiv.',
      ),
    );
    expect(obsolete.status, ActivityResultStatus.acceptedWithFeedback);
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
