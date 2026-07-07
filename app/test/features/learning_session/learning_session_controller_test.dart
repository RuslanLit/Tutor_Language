import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/learner/learner_progress.dart';
import 'package:tutor_language/core/learner/learner_progress_repository.dart';
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
      contentReference: 'assets/spanish/templates/multiple_choice_basic.json',
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
      contentReference: 'assets/spanish/templates/multiple_choice_basic.json',
    );

    final events = await progressRepository.readEventsForTopic(
      'topic.greetings.v1',
    );

    expect(controller.session!.checkedAnswerCount, 1);
    expect(events.last.eventType, ProgressEventType.answerChecked);
  });
}
