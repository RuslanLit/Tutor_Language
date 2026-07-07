import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/learner/learner_progress.dart';
import 'package:tutor_language/core/learner/learner_progress_repository.dart';

void main() {
  late AppDatabase database;
  late LearnerProgressRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = LearnerProgressRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('progress event serializes round trip', () {
    final event = ProgressEvent.create(
      eventType: ProgressEventType.answerChecked,
      topicId: 'topic.greetings.v1',
      sectionId: 'section.greetings.v1',
      contentReference:
          'assets/languages/spanish/templates/multiple_choice_basic.json',
      metadataJson: '{"itemId":"item.1"}',
      now: DateTime.utc(2026),
    );

    expect(ProgressEvent.fromJson(event.toJson()), event);
  });

  test('repository records topicViewed', () async {
    final event = ProgressEvent.create(
      eventType: ProgressEventType.topicViewed,
      topicId: 'topic.greetings.v1',
      now: DateTime.utc(2026),
    );

    await repository.recordEvent(event);

    final events = await repository.readEventsForTopic('topic.greetings.v1');
    final progress = await repository.readTopicProgress('topic.greetings.v1');

    expect(events, [event]);
    expect(progress.hasBeenViewed, isTrue);
    expect(progress.viewedAt, DateTime.utc(2026));
  });

  test('repository records answerChecked', () async {
    final event = ProgressEvent.create(
      eventType: ProgressEventType.answerChecked,
      topicId: 'topic.greetings.v1',
      sectionId: 'section.greeting_words.v1',
      contentReference:
          'assets/languages/spanish/templates/multiple_choice_basic.json',
      now: DateTime.utc(2026, 7),
    );

    await repository.recordEvent(event);

    final events = await repository.readEventsForTopic('topic.greetings.v1');
    final progress = await repository.readTopicProgress('topic.greetings.v1');

    expect(events.single.eventType, ProgressEventType.answerChecked);
    expect(progress.hasBeenViewed, isFalse);
    expect(progress.lastActivityAt, DateTime.utc(2026, 7));
  });

  test('repository reads completed topic progress', () async {
    final event = ProgressEvent.create(
      eventType: ProgressEventType.topicCompleted,
      topicId: 'topic.greetings.v1',
      now: DateTime.utc(2026, 8),
    );

    await repository.recordEvent(event);

    final progress = await repository.readTopicProgress('topic.greetings.v1');

    expect(progress.hasBeenCompleted, isTrue);
    expect(progress.completedAt, DateTime.utc(2026, 8));
  });
}
