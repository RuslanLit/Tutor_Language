import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'learner_progress.dart';

class LearnerProgressRepository {
  LearnerProgressRepository(this._database);

  final AppDatabase _database;

  Future<void> recordEvent(ProgressEvent event) async {
    await _database
        .into(_database.learnerProgressEvents)
        .insert(
          LearnerProgressEventsCompanion(
            id: Value(event.id),
            eventType: Value(event.eventType.name),
            topicId: Value(event.topicId),
            sectionId: Value(event.sectionId),
            contentReference: Value(event.contentReference),
            createdAt: Value(event.createdAt),
            metadataJson: Value(event.metadataJson),
          ),
        );
  }

  Future<void> recordLessonCompleted(String lessonId) async {
    final progress = await readTopicProgress(lessonId);
    if (progress.hasBeenCompleted) {
      return;
    }

    await recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.lessonCompleted,
        topicId: lessonId,
      ),
    );
  }

  Future<List<ProgressEvent>> readEventsForTopic(String topicId) async {
    final rows =
        await (_database.select(_database.learnerProgressEvents)
              ..where((table) => table.topicId.equals(topicId))
              ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]))
            .get();

    return rows.map(_eventFromRow).toList(growable: false);
  }

  Future<List<ProgressEvent>> readEvents() async {
    final rows = await (_database.select(
      _database.learnerProgressEvents,
    )..orderBy([(table) => OrderingTerm.asc(table.createdAt)])).get();

    return rows.map(_eventFromRow).toList(growable: false);
  }

  Future<TopicProgress> readTopicProgress(String topicId) async {
    final events = await readEventsForTopic(topicId);
    DateTime? viewedAt;
    DateTime? lastActivityAt;
    DateTime? completedAt;

    for (final event in events) {
      if (event.eventType == ProgressEventType.topicViewed) {
        viewedAt ??= event.createdAt;
      }
      if (event.eventType == ProgressEventType.topicCompleted ||
          event.eventType == ProgressEventType.lessonCompleted) {
        completedAt ??= event.createdAt;
      }

      if (lastActivityAt == null || event.createdAt.isAfter(lastActivityAt)) {
        lastActivityAt = event.createdAt;
      }
    }

    return TopicProgress(
      topicId: topicId,
      viewedAt: viewedAt,
      lastActivityAt: lastActivityAt,
      completedAt: completedAt,
    );
  }

  ProgressEvent _eventFromRow(LearnerProgressEventRow row) {
    return ProgressEvent(
      id: row.id,
      eventType: ProgressEventType.values.byName(row.eventType),
      topicId: row.topicId,
      sectionId: row.sectionId,
      contentReference: row.contentReference,
      createdAt: row.createdAt.toUtc(),
      metadataJson: row.metadataJson,
    );
  }
}
