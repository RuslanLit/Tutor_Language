import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/learner/learner_progress.dart';
import 'package:tutor_language/core/learner/learner_progress_repository.dart';
import 'package:tutor_language/features/exercise_runtime/answer_check_models.dart';
import 'package:tutor_language/features/learning_session/completion_evaluator.dart';
import 'package:tutor_language/features/learning_session/learning_session_controller.dart';

void main() {
  late AppDatabase database;
  late LearnerProgressRepository progressRepository;
  late LearningSessionController controller;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    progressRepository = LearnerProgressRepository(database);
    controller = LearningSessionController(
      progressRepository: progressRepository,
      now: () => DateTime.utc(2026),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('session creation records topic viewed', () async {
    final session = await controller.startSession('topic.greetings.v1');
    final events = await progressRepository.readEventsForTopic(
      'topic.greetings.v1',
    );

    expect(session.topicId, 'topic.greetings.v1');
    expect(session.interactionCount, 0);
    expect(session.checkedAnswerCount, 0);
    expect(session.finishedAt, isNull);
    expect(events.single.eventType, ProgressEventType.topicViewed);
  });

  test('session finish sets finishedAt', () async {
    await controller.startSession('topic.greetings.v1');
    await controller.finishSession();

    expect(controller.session!.finishedAt, DateTime.utc(2026));
  });

  test('recordInteraction increments interaction counter', () async {
    await controller.startSession('topic.greetings.v1');
    await controller.recordInteraction(
      sectionId: 'section.greetings.v1',
      contentReference:
          'assets/languages/spanish/templates/multiple_choice_basic.json',
    );

    final events = await progressRepository.readEventsForTopic(
      'topic.greetings.v1',
    );

    expect(controller.session!.interactionCount, 1);
    expect(events.last.eventType, ProgressEventType.exerciseAnswered);
  });

  test('recordAnswerChecked increments checked answer counter', () async {
    await controller.startSession('topic.greetings.v1');
    await controller.recordAnswerChecked(
      sectionId: 'section.greetings.v1',
      contentReference:
          'assets/languages/spanish/templates/multiple_choice_basic.json',
      answerCheckStatus: AnswerCheckStatus.correct,
    );

    final events = await progressRepository.readEventsForTopic(
      'topic.greetings.v1',
    );

    expect(controller.session!.checkedAnswerCount, 1);
    expect(controller.session!.checkedAnswerStatuses, [
      AnswerCheckStatus.correct,
    ]);
    expect(events.last.eventType, ProgressEventType.answerChecked);
  });

  test(
    'LearningSessionController uses CompletionEvaluator on finish',
    () async {
      final evaluator = _RecordingCompletionEvaluator();
      controller = LearningSessionController(
        progressRepository: progressRepository,
        completionEvaluator: evaluator,
        now: () => DateTime.utc(2026),
      );

      await controller.startSession('topic.greetings.v1');
      await controller.recordAnswerChecked(
        sectionId: 'section.greetings.v1',
        contentReference:
            'assets/languages/spanish/templates/multiple_choice_basic.json',
        answerCheckStatus: AnswerCheckStatus.correct,
      );
      await controller.finishSession();

      final events = await progressRepository.readEventsForTopic(
        'topic.greetings.v1',
      );

      expect(evaluator.evaluateCount, 1);
      expect(events.last.eventType, ProgressEventType.topicCompleted);
    },
  );

  test('incorrect checked answer does not record completion event', () async {
    await controller.startSession('topic.greetings.v1');
    await controller.recordAnswerChecked(
      sectionId: 'section.greetings.v1',
      contentReference:
          'assets/languages/spanish/templates/multiple_choice_basic.json',
      answerCheckStatus: AnswerCheckStatus.incorrect,
    );
    await controller.finishSession();

    final events = await progressRepository.readEventsForTopic(
      'topic.greetings.v1',
    );

    expect(
      events.map((event) => event.eventType),
      isNot(contains(ProgressEventType.topicCompleted)),
    );
  });
}

class _RecordingCompletionEvaluator extends CompletionEvaluator {
  int evaluateCount = 0;

  @override
  CompletionDecision evaluate(CompletionEvaluation evaluation) {
    evaluateCount += 1;
    return super.evaluate(evaluation);
  }
}
