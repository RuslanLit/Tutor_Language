import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'lesson_attempt.dart';
import 'learner_progress.dart';

class LearnerProgressRepository {
  LearnerProgressRepository(this._database);

  final AppDatabase _database;
  Future<void> _resumeWriteQueue = Future<void>.value();

  Future<void> saveLessonResumeCursor(LessonResumeCursor cursor) {
    final previous = _resumeWriteQueue;
    final next = previous.then((_) async {
      final event = ProgressEvent(
        id: 'lesson.resume.${cursor.attemptId}',
        eventType: ProgressEventType.lessonResumePosition,
        topicId: cursor.lessonId,
        contentReference: cursor.stepId,
        createdAt: cursor.savedAt,
        metadataJson: jsonEncode(cursor.toJson()),
      );
      await _database
          .into(_database.learnerProgressEvents)
          .insertOnConflictUpdate(
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
    });
    _resumeWriteQueue = next.catchError((_) {});
    return next;
  }

  Future<LessonResumeCursor?> getLessonResumeCursor(
    String lessonId,
    LessonAttemptPurpose purpose,
  ) async {
    final rows =
        await (_database.select(_database.learnerProgressEvents)
              ..where(
                (table) =>
                    table.topicId.equals(lessonId) &
                    table.eventType.equals(
                      ProgressEventType.lessonResumePosition.name,
                    ),
              )
              ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
            .get();
    for (final row in rows) {
      final metadata = row.metadataJson;
      if (metadata == null) continue;
      try {
        final decoded = jsonDecode(metadata);
        if (decoded is Map) {
          final cursor = LessonResumeCursor.fromJson(
            Map<String, Object?>.from(decoded),
          );
          if (cursor.lessonId == lessonId && cursor.attemptPurpose == purpose) {
            return cursor;
          }
        }
      } on Object {
        // A stale/corrupt cursor is ignored; lesson launch falls back safely.
      }
    }
    return null;
  }

  Future<void> clearLessonResumeCursor(String attemptId) async {
    final previous = _resumeWriteQueue;
    final next = previous.then((_) async {
      await (_database.delete(
        _database.learnerProgressEvents,
      )..where((table) => table.id.equals('lesson.resume.$attemptId'))).go();
    });
    _resumeWriteQueue = next.catchError((_) {});
    await next;
  }

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

  Future<CompletedLessonAttemptPersistenceResult> recordCompletedLessonAttempt(
    CompletedLessonAttemptCommand command,
  ) async {
    try {
      return await _database.transaction(() async {
        _validateAttemptAggregate(command);

        final existingRows =
            await (_database.select(_database.lessonAttempts)
                  ..where(
                    (table) =>
                        table.attemptId.equals(command.attempt.attemptId),
                  )
                  ..limit(1))
                .get();

        if (existingRows.isEmpty) {
          await _database
              .into(_database.lessonAttempts)
              .insert(_attemptCompanion(command.attempt));

          for (final stepResult in command.stepResults) {
            await _database
                .into(_database.lessonAttemptStepResults)
                .insert(_stepResultCompanion(stepResult));
          }
          await clearLessonResumeCursor(command.attempt.attemptId);

          await _ensureLessonCompletionProgress(command.attempt);
          return CompletedLessonAttemptPersistenceResult.created(
            attemptId: command.attempt.attemptId,
            lessonId: command.attempt.lessonId,
          );
        }

        final existingAttempt = _attemptFromRow(existingRows.single);
        final existingSteps = await getAttemptStepResults(
          command.attempt.attemptId,
        );

        if (_attemptAggregatesMatch(
          existingAttempt: existingAttempt,
          existingSteps: existingSteps,
          incomingAttempt: command.attempt,
          incomingSteps: command.stepResults,
        )) {
          await clearLessonResumeCursor(existingAttempt.attemptId);
          await _ensureLessonCompletionProgress(existingAttempt);
          return CompletedLessonAttemptPersistenceResult.alreadyRecordedIdentically(
            attemptId: command.attempt.attemptId,
            lessonId: command.attempt.lessonId,
          );
        }

        return CompletedLessonAttemptPersistenceResult.conflict(
          attemptId: command.attempt.attemptId,
          lessonId: command.attempt.lessonId,
          message:
              'A different durable lesson attempt already exists for this '
              'attempt ID.',
        );
      });
    } on Exception catch (error) {
      return CompletedLessonAttemptPersistenceResult.failure(
        attemptId: command.attempt.attemptId,
        lessonId: command.attempt.lessonId,
        message: error.toString(),
      );
    }
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
    final rows =
        await (_database.select(_database.lessonAttempts)
              ..where((table) => table.courseId.equals(courseId))
              ..orderBy([
                (table) => OrderingTerm.asc(table.completedAt),
                (table) => OrderingTerm.asc(table.attemptId),
              ]))
            .get();

    final summaries = <LessonAttemptSummary>[];
    for (final row in rows) {
      try {
        final attempt = _attemptFromRow(row);
        summaries.add(
          LessonAttemptSummary(
            attemptId: attempt.attemptId,
            lessonId: attempt.lessonId,
            courseId: attempt.courseId,
            purpose: attempt.purpose,
            completedAt: attempt.completedAt,
            outcomeStatus: attempt.outcomeStatus,
            masteredStepCount: attempt.masteredStepCount,
            fragileStepCount: attempt.fragileStepCount,
            canonicalCheckableStepCount: attempt.canonicalCheckableStepCount,
            learningPolicyVersion: attempt.learningPolicyVersion,
          ),
        );
      } on LessonAttemptDecodeException {
        // Corrupt durable detail is isolated so legacy progress and other
        // attempts remain usable. Explicit reads still keep strict decoding.
      }
    }
    return List.unmodifiable(summaries);
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

  Future<void> _ensureLessonCompletionProgress(
    DurableLessonAttempt attempt,
  ) async {
    final progress = await readTopicProgress(attempt.lessonId);
    if (progress.hasBeenCompleted) {
      return;
    }

    await _recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.lessonCompleted,
        topicId: attempt.lessonId,
        now: attempt.completedAt,
      ),
    );
  }

  void _validateAttemptAggregate(CompletedLessonAttemptCommand command) {
    final attempt = command.attempt;
    if (attempt.learningPolicyVersion.isEmpty) {
      throw const LessonAttemptValidationException(
        'Learning policy version must be non-empty.',
      );
    }
    if (attempt.outcomeStatus == DurableLessonOutcomeStatus.incomplete) {
      throw const LessonAttemptValidationException(
        'Completed attempts cannot persist an incomplete lesson outcome.',
      );
    }
    if (attempt.canonicalCheckableStepCount != command.stepResults.length) {
      throw const LessonAttemptValidationException(
        'Canonical step count must match persisted step rows.',
      );
    }

    final stepIds = <String>{};
    var mastered = 0;
    var fragile = 0;
    var notMastered = 0;
    var unassessed = 0;
    var totalSubmissions = 0;

    for (final stepResult in command.stepResults) {
      if (stepResult.attemptId != attempt.attemptId ||
          stepResult.lessonId != attempt.lessonId) {
        throw const LessonAttemptValidationException(
          'Step result provenance must match the lesson attempt.',
        );
      }
      if (!stepIds.add(stepResult.stepId)) {
        throw const LessonAttemptValidationException(
          'Step result IDs must be unique.',
        );
      }
      if (stepResult.stepId.startsWith('review::')) {
        throw const LessonAttemptValidationException(
          'Runtime inserted review step IDs cannot be persisted directly.',
        );
      }

      totalSubmissions += stepResult.attemptCount;
      switch (stepResult.masteryStatus) {
        case DurableStepMasteryStatus.mastered:
          mastered += 1;
        case DurableStepMasteryStatus.fragile:
          fragile += 1;
        case DurableStepMasteryStatus.notMastered:
          notMastered += 1;
        case DurableStepMasteryStatus.notAssessed:
          unassessed += 1;
      }
    }

    if (attempt.masteredStepCount != mastered ||
        attempt.fragileStepCount != fragile ||
        attempt.notMasteredStepCount != notMastered ||
        attempt.unassessedStepCount != unassessed ||
        attempt.assessedStepCount != mastered + fragile + notMastered ||
        attempt.totalSubmissionCount != totalSubmissions) {
      throw const LessonAttemptValidationException(
        'Attempt summary counts must match step evidence.',
      );
    }
    if (attempt.outcomeStatus == DurableLessonOutcomeStatus.mastered &&
        (fragile > 0 || notMastered > 0 || unassessed > 0)) {
      throw const LessonAttemptValidationException(
        'Mastered attempts cannot contain non-mastered step evidence.',
      );
    }
  }

  bool _attemptAggregatesMatch({
    required DurableLessonAttempt existingAttempt,
    required List<DurableStepResult> existingSteps,
    required DurableLessonAttempt incomingAttempt,
    required List<DurableStepResult> incomingSteps,
  }) {
    if (!_attemptsMatch(existingAttempt, incomingAttempt)) {
      return false;
    }
    if (existingSteps.length != incomingSteps.length) {
      return false;
    }

    final incomingByStepId = {
      for (final step in incomingSteps) step.stepId: step,
    };
    if (incomingByStepId.length != incomingSteps.length) {
      return false;
    }

    for (final existingStep in existingSteps) {
      final incomingStep = incomingByStepId[existingStep.stepId];
      if (incomingStep == null || !_stepsMatch(existingStep, incomingStep)) {
        return false;
      }
    }
    return true;
  }

  bool _attemptsMatch(DurableLessonAttempt left, DurableLessonAttempt right) {
    return left.attemptId == right.attemptId &&
        left.lessonId == right.lessonId &&
        left.courseId == right.courseId &&
        left.purpose == right.purpose &&
        _sameDateTime(left.startedAt, right.startedAt) &&
        _sameDateTime(left.completedAt, right.completedAt) &&
        left.outcomeStatus == right.outcomeStatus &&
        left.outcomeReasonCode == right.outcomeReasonCode &&
        left.assessedStepCount == right.assessedStepCount &&
        left.masteredStepCount == right.masteredStepCount &&
        left.fragileStepCount == right.fragileStepCount &&
        left.notMasteredStepCount == right.notMasteredStepCount &&
        left.unassessedStepCount == right.unassessedStepCount &&
        left.canonicalCheckableStepCount == right.canonicalCheckableStepCount &&
        left.totalSubmissionCount == right.totalSubmissionCount &&
        left.learningPolicyVersion == right.learningPolicyVersion;
  }

  bool _stepsMatch(DurableStepResult left, DurableStepResult right) {
    return left.attemptId == right.attemptId &&
        left.lessonId == right.lessonId &&
        left.stepId == right.stepId &&
        left.masteryStatus == right.masteryStatus &&
        left.masteryReasonCode == right.masteryReasonCode &&
        left.attemptCount == right.attemptCount &&
        left.successfulSubmissionCount == right.successfulSubmissionCount &&
        left.latestEvaluationOutcome == right.latestEvaluationOutcome &&
        left.remediationWasRequired == right.remediationWasRequired &&
        left.reviewWasRequired == right.reviewWasRequired &&
        left.confirmationSucceeded == right.confirmationSucceeded;
  }

  bool _sameDateTime(DateTime? left, DateTime? right) {
    if (left == null || right == null) {
      return left == right;
    }
    return left.toUtc().microsecondsSinceEpoch ==
        right.toUtc().microsecondsSinceEpoch;
  }

  LessonAttemptsCompanion _attemptCompanion(DurableLessonAttempt attempt) {
    return LessonAttemptsCompanion(
      attemptId: Value(attempt.attemptId),
      lessonId: Value(attempt.lessonId),
      courseId: Value(attempt.courseId),
      attemptPurpose: Value(attempt.purpose.code),
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
      purpose: LessonAttemptPurpose.fromCode(row.attemptPurpose),
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
