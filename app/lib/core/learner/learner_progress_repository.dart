import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'lesson_attempt.dart';
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

  Future<void> recordCompletedLessonAttempt(
    CompletedLessonAttemptCommand command,
  ) async {
    await _database.transaction(() async {
      await _database
          .into(_database.lessonAttempts)
          .insertOnConflictUpdate(_attemptCompanion(command.attempt));

      for (final stepResult in command.stepResults) {
        if (stepResult.attemptId != command.attempt.attemptId ||
            stepResult.lessonId != command.attempt.lessonId) {
          throw const LessonAttemptValidationException(
            'Step result provenance must match the lesson attempt.',
          );
        }
        await _database
            .into(_database.lessonAttemptStepResults)
            .insertOnConflictUpdate(_stepResultCompanion(stepResult));
      }

      final progress = await readTopicProgress(command.attempt.lessonId);
      if (!progress.hasBeenCompleted) {
        await _recordEvent(
          ProgressEvent.create(
            eventType: ProgressEventType.lessonCompleted,
            topicId: command.attempt.lessonId,
            now: command.attempt.completedAt,
          ),
        );
      }
    });
  }

  Future<List<DurableLessonAttempt>> getLessonAttempts(String lessonId) async {
    final rows =
        await (_database.select(_database.lessonAttempts)
              ..where((table) => table.lessonId.equals(lessonId))
              ..orderBy([
                (table) => OrderingTerm.asc(table.completedAt),
                (table) => OrderingTerm.asc(table.attemptId),
              ]))
            .get();

    return rows.map(_attemptFromRow).toList(growable: false);
  }

  Future<DurableLessonAttempt?> getLatestLessonAttempt(String lessonId) async {
    final rows =
        await (_database.select(_database.lessonAttempts)
              ..where((table) => table.lessonId.equals(lessonId))
              ..orderBy([
                (table) => OrderingTerm.desc(table.completedAt),
                (table) => OrderingTerm.desc(table.attemptId),
              ])
              ..limit(1))
            .get();

    if (rows.isEmpty) {
      return null;
    }
    return _attemptFromRow(rows.single);
  }

  Future<List<DurableLessonAttempt>> getCourseLessonAttempts(
    String courseId,
  ) async {
    final rows =
        await (_database.select(_database.lessonAttempts)
              ..where((table) => table.courseId.equals(courseId))
              ..orderBy([
                (table) => OrderingTerm.asc(table.completedAt),
                (table) => OrderingTerm.asc(table.attemptId),
              ]))
            .get();

    return rows.map(_attemptFromRow).toList(growable: false);
  }

  Future<List<DurableStepResult>> getAttemptStepResults(
    String attemptId,
  ) async {
    final rows =
        await (_database.select(_database.lessonAttemptStepResults)
              ..where((table) => table.attemptId.equals(attemptId))
              ..orderBy([(table) => OrderingTerm.asc(table.stepId)]))
            .get();

    return rows.map(_stepResultFromRow).toList(growable: false);
  }

  Future<List<LessonAttemptSummary>> getCourseLessonAttemptSummaries(
    String courseId,
  ) async {
    final attempts = await getCourseLessonAttempts(courseId);
    return attempts
        .map(
          (attempt) => LessonAttemptSummary(
            attemptId: attempt.attemptId,
            lessonId: attempt.lessonId,
            courseId: attempt.courseId,
            completedAt: attempt.completedAt,
            outcomeStatus: attempt.outcomeStatus,
            masteredStepCount: attempt.masteredStepCount,
            fragileStepCount: attempt.fragileStepCount,
            canonicalCheckableStepCount: attempt.canonicalCheckableStepCount,
          ),
        )
        .toList(growable: false);
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

  Future<void> _recordEvent(ProgressEvent event) async {
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

  LessonAttemptsCompanion _attemptCompanion(DurableLessonAttempt attempt) {
    return LessonAttemptsCompanion(
      attemptId: Value(attempt.attemptId),
      lessonId: Value(attempt.lessonId),
      courseId: Value(attempt.courseId),
      startedAt: Value(attempt.startedAt),
      completedAt: Value(attempt.completedAt),
      outcomeStatus: Value(attempt.outcomeStatus.code),
      outcomeReasonCode: Value(attempt.outcomeReasonCode.code),
      assessedStepCount: Value(attempt.assessedStepCount),
      masteredStepCount: Value(attempt.masteredStepCount),
      fragileStepCount: Value(attempt.fragileStepCount),
      notMasteredStepCount: Value(attempt.notMasteredStepCount),
      unassessedStepCount: Value(attempt.unassessedStepCount),
      canonicalCheckableStepCount: Value(attempt.canonicalCheckableStepCount),
      totalSubmissionCount: Value(attempt.totalSubmissionCount),
      learningPolicyVersion: Value(attempt.learningPolicyVersion),
    );
  }

  LessonAttemptStepResultsCompanion _stepResultCompanion(
    DurableStepResult stepResult,
  ) {
    return LessonAttemptStepResultsCompanion(
      attemptId: Value(stepResult.attemptId),
      lessonId: Value(stepResult.lessonId),
      stepId: Value(stepResult.stepId),
      masteryStatus: Value(stepResult.masteryStatus.code),
      masteryReasonCode: Value(stepResult.masteryReasonCode.code),
      attemptCount: Value(stepResult.attemptCount),
      successfulSubmissionCount: Value(stepResult.successfulSubmissionCount),
      latestEvaluationOutcome: Value(stepResult.latestEvaluationOutcome.code),
      remediationWasRequired: Value(stepResult.remediationWasRequired),
      reviewWasRequired: Value(stepResult.reviewWasRequired),
      confirmationSucceeded: Value(stepResult.confirmationSucceeded),
    );
  }

  DurableLessonAttempt _attemptFromRow(LessonAttemptRow row) {
    return DurableLessonAttempt(
      attemptId: row.attemptId,
      lessonId: row.lessonId,
      courseId: row.courseId,
      startedAt: row.startedAt?.toUtc(),
      completedAt: row.completedAt.toUtc(),
      outcomeStatus: DurableLessonOutcomeStatus.fromCode(row.outcomeStatus),
      outcomeReasonCode: DurableLessonOutcomeReasonCode.fromCode(
        row.outcomeReasonCode,
      ),
      assessedStepCount: row.assessedStepCount,
      masteredStepCount: row.masteredStepCount,
      fragileStepCount: row.fragileStepCount,
      notMasteredStepCount: row.notMasteredStepCount,
      unassessedStepCount: row.unassessedStepCount,
      canonicalCheckableStepCount: row.canonicalCheckableStepCount,
      totalSubmissionCount: row.totalSubmissionCount,
      learningPolicyVersion: row.learningPolicyVersion,
    );
  }

  DurableStepResult _stepResultFromRow(LessonAttemptStepResultRow row) {
    return DurableStepResult(
      attemptId: row.attemptId,
      lessonId: row.lessonId,
      stepId: row.stepId,
      masteryStatus: DurableStepMasteryStatus.fromCode(row.masteryStatus),
      masteryReasonCode: DurableStepMasteryReasonCode.fromCode(
        row.masteryReasonCode,
      ),
      attemptCount: row.attemptCount,
      successfulSubmissionCount: row.successfulSubmissionCount,
      latestEvaluationOutcome: DurableActivityResultStatus.fromCode(
        row.latestEvaluationOutcome,
      ),
      remediationWasRequired: row.remediationWasRequired,
      reviewWasRequired: row.reviewWasRequired,
      confirmationSucceeded: row.confirmationSucceeded,
    );
  }
}
