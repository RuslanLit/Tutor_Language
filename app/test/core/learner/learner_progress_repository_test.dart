import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/learner/lesson_attempt.dart';
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

  test('lesson attempt purpose uses stable strict codes', () {
    expect(LessonAttemptPurpose.normal.code, 'normal');
    expect(
      LessonAttemptPurpose.reinforcementRepeat.code,
      'reinforcement_repeat',
    );
    expect(LessonAttemptPurpose.manualRepeat.code, 'manual_repeat');

    expect(
      LessonAttemptPurpose.fromCode('normal'),
      LessonAttemptPurpose.normal,
    );
    expect(
      LessonAttemptPurpose.fromCode('reinforcement_repeat'),
      LessonAttemptPurpose.reinforcementRepeat,
    );
    expect(
      LessonAttemptPurpose.fromCode('manual_repeat'),
      LessonAttemptPurpose.manualRepeat,
    );
    expect(
      () => LessonAttemptPurpose.fromCode('unknown'),
      throwsA(isA<LessonAttemptDecodeException>()),
    );
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

  test('repository reads all progress events in chronological order', () async {
    final later = ProgressEvent.create(
      eventType: ProgressEventType.topicCompleted,
      topicId: 'topic.second.v1',
      now: DateTime.utc(2026, 8),
    );
    final earlier = ProgressEvent.create(
      eventType: ProgressEventType.topicViewed,
      topicId: 'topic.first.v1',
      now: DateTime.utc(2026, 7),
    );

    await repository.recordEvent(later);
    await repository.recordEvent(earlier);

    final events = await repository.readEvents();

    expect(events.map((event) => event.topicId), [
      'topic.first.v1',
      'topic.second.v1',
    ]);
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

  test('repository records lesson completion idempotently', () async {
    await repository.recordLessonCompleted('lesson.greetings.v1');
    await repository.recordLessonCompleted('lesson.greetings.v1');

    final events = await repository.readEventsForTopic('lesson.greetings.v1');
    final progress = await repository.readTopicProgress('lesson.greetings.v1');

    expect(events, hasLength(1));
    expect(events.single.eventType, ProgressEventType.lessonCompleted);
    expect(progress.hasBeenCompleted, isTrue);
  });

  test(
    'lesson completion preserves existing topicCompleted compatibility',
    () async {
      await repository.recordEvent(
        ProgressEvent.create(
          eventType: ProgressEventType.topicCompleted,
          topicId: 'lesson.legacy.v1',
          now: DateTime.utc(2026, 9),
        ),
      );

      await repository.recordLessonCompleted('lesson.legacy.v1');

      final events = await repository.readEventsForTopic('lesson.legacy.v1');
      final progress = await repository.readTopicProgress('lesson.legacy.v1');

      expect(events, hasLength(1));
      expect(events.single.eventType, ProgressEventType.topicCompleted);
      expect(progress.hasBeenCompleted, isTrue);
    },
  );

  test(
    'repository writes and reads completed lesson attempts atomically',
    () async {
      final command = _attemptCommand(
        attemptId: 'attempt.001',
        lessonId: 'lesson.greetings.v1',
        courseId: 'course.spanish.a0',
        completedAt: DateTime.utc(2026, 7, 11),
      );

      final result = await repository.recordCompletedLessonAttempt(command);

      final attempts = await repository.getLessonAttempts(
        'lesson.greetings.v1',
      );
      final latest = await repository.getLatestLessonAttempt(
        'lesson.greetings.v1',
      );
      final steps = await repository.getAttemptStepResults('attempt.001');
      final progress = await repository.readTopicProgress(
        'lesson.greetings.v1',
      );

      expect(attempts, hasLength(1));
      expect(result.status, CompletedLessonAttemptPersistenceStatus.created);
      expect(latest?.attemptId, 'attempt.001');
      expect(latest?.outcomeStatus, DurableLessonOutcomeStatus.mastered);
      expect(latest?.learningPolicyVersion, 'e20-v1');
      expect(steps, hasLength(1));
      expect(steps.single.stepId, 'step.practice');
      expect(steps.single.masteryStatus, DurableStepMasteryStatus.mastered);
      expect(progress.hasBeenCompleted, isTrue);
    },
  );

  test('multiple attempts for the same lesson remain separate', () async {
    await repository.recordCompletedLessonAttempt(
      _attemptCommand(
        attemptId: 'attempt.001',
        lessonId: 'lesson.repeat',
        courseId: 'course.spanish.a0',
        completedAt: DateTime.utc(2026, 7, 11),
        outcomeStatus: DurableLessonOutcomeStatus.completedWithReinforcement,
      ),
    );
    await repository.recordCompletedLessonAttempt(
      _attemptCommand(
        attemptId: 'attempt.002',
        lessonId: 'lesson.repeat',
        courseId: 'course.spanish.a0',
        completedAt: DateTime.utc(2026, 7, 12),
      ),
    );

    final attempts = await repository.getLessonAttempts('lesson.repeat');
    final latest = await repository.getLatestLessonAttempt('lesson.repeat');
    final courseSummaries = await repository.getCourseLessonAttemptSummaries(
      'course.spanish.a0',
    );

    expect(attempts.map((attempt) => attempt.attemptId), [
      'attempt.001',
      'attempt.002',
    ]);
    expect(latest?.attemptId, 'attempt.002');
    expect(courseSummaries.map((summary) => summary.attemptId), [
      'attempt.001',
      'attempt.002',
    ]);
  });

  test(
    'multiple completed repeats preserve attempts without duplicate completion progress',
    () async {
      await repository.recordCompletedLessonAttempt(
        _attemptCommand(
          attemptId: 'attempt.original',
          lessonId: 'lesson.repeat.progress',
          courseId: 'course.spanish.a0',
          completedAt: DateTime.utc(2026, 7, 11),
          purpose: LessonAttemptPurpose.normal,
        ),
      );
      await repository.recordCompletedLessonAttempt(
        _attemptCommand(
          attemptId: 'attempt.repeat.001',
          lessonId: 'lesson.repeat.progress',
          courseId: 'course.spanish.a0',
          completedAt: DateTime.utc(2026, 7, 12),
          purpose: LessonAttemptPurpose.manualRepeat,
        ),
      );
      await repository.recordCompletedLessonAttempt(
        _attemptCommand(
          attemptId: 'attempt.repeat.002',
          lessonId: 'lesson.repeat.progress',
          courseId: 'course.spanish.a0',
          completedAt: DateTime.utc(2026, 7, 13),
          purpose: LessonAttemptPurpose.manualRepeat,
        ),
      );

      final attempts = await repository.getLessonAttempts(
        'lesson.repeat.progress',
      );
      final events = await repository.readEventsForTopic(
        'lesson.repeat.progress',
      );

      expect(attempts.map((attempt) => attempt.attemptId), [
        'attempt.original',
        'attempt.repeat.001',
        'attempt.repeat.002',
      ]);
      expect(attempts.map((attempt) => attempt.purpose), [
        LessonAttemptPurpose.normal,
        LessonAttemptPurpose.manualRepeat,
        LessonAttemptPurpose.manualRepeat,
      ]);
      expect(
        events
            .where(
              (event) => event.eventType == ProgressEventType.lessonCompleted,
            )
            .length,
        1,
      );
      expect(
        await repository.getAttemptStepResults('attempt.original'),
        hasLength(1),
      );
      expect(
        await repository.getAttemptStepResults('attempt.repeat.001'),
        hasLength(1),
      );
      expect(
        await repository.getAttemptStepResults('attempt.repeat.002'),
        hasLength(1),
      );
    },
  );

  test('duplicate attempt id is idempotent', () async {
    final command = _attemptCommand(
      attemptId: 'attempt.same',
      lessonId: 'lesson.same',
      courseId: 'course.spanish.a0',
      completedAt: DateTime.utc(2026, 7, 11),
    );

    final created = await repository.recordCompletedLessonAttempt(command);
    final duplicate = await repository.recordCompletedLessonAttempt(command);

    final attempts = await repository.getLessonAttempts('lesson.same');
    final steps = await repository.getAttemptStepResults('attempt.same');
    final events = await repository.readEventsForTopic('lesson.same');

    expect(attempts, hasLength(1));
    expect(created.status, CompletedLessonAttemptPersistenceStatus.created);
    expect(
      duplicate.status,
      CompletedLessonAttemptPersistenceStatus.alreadyRecordedIdentically,
    );
    expect(steps, hasLength(1));
    expect(
      events.where(
        (event) => event.eventType == ProgressEventType.lessonCompleted,
      ),
      hasLength(1),
    );
  });

  test('duplicate attempt id with changed outcome is rejected', () async {
    final original = _attemptCommand(
      attemptId: 'attempt.conflict',
      lessonId: 'lesson.conflict',
      courseId: 'course.spanish.a0',
      completedAt: DateTime.utc(2026, 7, 11),
    );
    final changed = _attemptCommand(
      attemptId: 'attempt.conflict',
      lessonId: 'lesson.conflict',
      courseId: 'course.spanish.a0',
      completedAt: DateTime.utc(2026, 7, 11),
      outcomeStatus: DurableLessonOutcomeStatus.completedWithReinforcement,
    );

    await repository.recordCompletedLessonAttempt(original);
    final conflict = await repository.recordCompletedLessonAttempt(changed);

    final latest = await repository.getLatestLessonAttempt('lesson.conflict');
    final steps = await repository.getAttemptStepResults('attempt.conflict');

    expect(conflict.status, CompletedLessonAttemptPersistenceStatus.conflict);
    expect(latest?.outcomeStatus, DurableLessonOutcomeStatus.mastered);
    expect(steps.single.masteryStatus, DurableStepMasteryStatus.mastered);
  });

  test('duplicate attempt id with changed timestamp is rejected', () async {
    final original = _attemptCommand(
      attemptId: 'attempt.timestamp',
      lessonId: 'lesson.timestamp',
      courseId: 'course.spanish.a0',
      completedAt: DateTime.utc(2026, 7, 11),
    );
    final changed = _attemptCommand(
      attemptId: 'attempt.timestamp',
      lessonId: 'lesson.timestamp',
      courseId: 'course.spanish.a0',
      completedAt: DateTime.utc(2026, 7, 12),
    );

    await repository.recordCompletedLessonAttempt(original);
    final conflict = await repository.recordCompletedLessonAttempt(changed);

    final latest = await repository.getLatestLessonAttempt('lesson.timestamp');

    expect(conflict.status, CompletedLessonAttemptPersistenceStatus.conflict);
    expect(latest?.completedAt, DateTime.utc(2026, 7, 11));
  });

  test(
    'duplicate attempt id with changed policy version is rejected',
    () async {
      final original = _attemptCommand(
        attemptId: 'attempt.policy',
        lessonId: 'lesson.policy',
        courseId: 'course.spanish.a0',
        completedAt: DateTime.utc(2026, 7, 11),
      );
      final changed = CompletedLessonAttemptCommand(
        attempt: _copyAttempt(
          original.attempt,
          learningPolicyVersion: 'different-policy',
        ),
        stepResults: original.stepResults,
      );

      await repository.recordCompletedLessonAttempt(original);
      final conflict = await repository.recordCompletedLessonAttempt(changed);

      final latest = await repository.getLatestLessonAttempt('lesson.policy');

      expect(conflict.status, CompletedLessonAttemptPersistenceStatus.conflict);
      expect(latest?.learningPolicyVersion, 'e20-v1');
    },
  );

  test('duplicate attempt id with changed purpose is rejected', () async {
    final original = _attemptCommand(
      attemptId: 'attempt.purpose',
      lessonId: 'lesson.purpose',
      courseId: 'course.spanish.a0',
      completedAt: DateTime.utc(2026, 7, 11),
      purpose: LessonAttemptPurpose.normal,
    );
    final changed = CompletedLessonAttemptCommand(
      attempt: _copyAttempt(
        original.attempt,
        purpose: LessonAttemptPurpose.manualRepeat,
      ),
      stepResults: original.stepResults,
    );

    await repository.recordCompletedLessonAttempt(original);
    final conflict = await repository.recordCompletedLessonAttempt(changed);

    final latest = await repository.getLatestLessonAttempt('lesson.purpose');

    expect(conflict.status, CompletedLessonAttemptPersistenceStatus.conflict);
    expect(latest?.purpose, LessonAttemptPurpose.normal);
  });

  test('duplicate attempt id with changed step mastery is rejected', () async {
    final original = _attemptCommand(
      attemptId: 'attempt.step',
      lessonId: 'lesson.step',
      courseId: 'course.spanish.a0',
      completedAt: DateTime.utc(2026, 7, 11),
    );
    final changed = CompletedLessonAttemptCommand(
      attempt: _copyAttempt(
        original.attempt,
        outcomeStatus: DurableLessonOutcomeStatus.completedWithReinforcement,
        outcomeReasonCode: DurableLessonOutcomeReasonCode.fragileMasteryPresent,
        masteredStepCount: 0,
        fragileStepCount: 1,
      ),
      stepResults: [
        _copyStep(
          original.stepResults.single,
          masteryStatus: DurableStepMasteryStatus.fragile,
          masteryReasonCode:
              DurableStepMasteryReasonCode.acceptedWithCorrection,
        ),
      ],
    );

    await repository.recordCompletedLessonAttempt(original);
    final conflict = await repository.recordCompletedLessonAttempt(changed);

    final steps = await repository.getAttemptStepResults('attempt.step');

    expect(conflict.status, CompletedLessonAttemptPersistenceStatus.conflict);
    expect(steps.single.masteryStatus, DurableStepMasteryStatus.mastered);
  });

  test(
    'duplicate attempt id with missing or additional step rows is rejected',
    () async {
      final original = _attemptCommand(
        attemptId: 'attempt.rows',
        lessonId: 'lesson.rows',
        courseId: 'course.spanish.a0',
        completedAt: DateTime.utc(2026, 7, 11),
        additionalStep: true,
      );
      final missingStep = CompletedLessonAttemptCommand(
        attempt: _copyAttempt(
          original.attempt,
          assessedStepCount: 1,
          masteredStepCount: 1,
          canonicalCheckableStepCount: 1,
          totalSubmissionCount: 1,
        ),
        stepResults: [original.stepResults.first],
      );
      final additionalStep = _attemptCommand(
        attemptId: 'attempt.single',
        lessonId: 'lesson.single',
        courseId: 'course.spanish.a0',
        completedAt: DateTime.utc(2026, 7, 11),
      );
      final additionalStepConflict = _attemptCommand(
        attemptId: 'attempt.single',
        lessonId: 'lesson.single',
        courseId: 'course.spanish.a0',
        completedAt: DateTime.utc(2026, 7, 11),
        additionalStep: true,
      );

      await repository.recordCompletedLessonAttempt(original);
      final missingConflict = await repository.recordCompletedLessonAttempt(
        missingStep,
      );
      await repository.recordCompletedLessonAttempt(additionalStep);
      final extraConflict = await repository.recordCompletedLessonAttempt(
        additionalStepConflict,
      );

      expect(
        missingConflict.status,
        CompletedLessonAttemptPersistenceStatus.conflict,
      );
      expect(
        extraConflict.status,
        CompletedLessonAttemptPersistenceStatus.conflict,
      );
      expect(
        await repository.getAttemptStepResults('attempt.rows'),
        hasLength(2),
      );
      expect(
        await repository.getAttemptStepResults('attempt.single'),
        hasLength(1),
      );
    },
  );

  test('invalid aggregate leaves no partial attempt or progress', () async {
    final command = _attemptCommand(
      attemptId: 'attempt.invalid',
      lessonId: 'lesson.invalid',
      courseId: 'course.spanish.a0',
      completedAt: DateTime.utc(2026, 7, 11),
    );
    final invalid = CompletedLessonAttemptCommand(
      attempt: command.attempt,
      stepResults: [
        _copyStep(command.stepResults.single, attemptId: 'attempt.other'),
      ],
    );

    final result = await repository.recordCompletedLessonAttempt(invalid);

    expect(result.status, CompletedLessonAttemptPersistenceStatus.failure);
    expect(await repository.getLessonAttempts('lesson.invalid'), isEmpty);
    expect(await repository.getAttemptStepResults('attempt.invalid'), isEmpty);
    expect(
      (await repository.readTopicProgress('lesson.invalid')).hasBeenCompleted,
      isFalse,
    );
  });

  test('step insert failure rolls back attempt and progress', () async {
    await database.customStatement('''
      CREATE TRIGGER fail_lesson_step_insert
      BEFORE INSERT ON lesson_attempt_step_results
      BEGIN
        SELECT RAISE(ABORT, 'forced step insert failure');
      END;
    ''');
    final command = _attemptCommand(
      attemptId: 'attempt.rollback',
      lessonId: 'lesson.rollback',
      courseId: 'course.spanish.a0',
      completedAt: DateTime.utc(2026, 7, 11),
    );

    final result = await repository.recordCompletedLessonAttempt(command);

    expect(result.status, CompletedLessonAttemptPersistenceStatus.failure);
    expect(await repository.getLessonAttempts('lesson.rollback'), isEmpty);
    expect(await repository.getAttemptStepResults('attempt.rollback'), isEmpty);
    expect(
      (await repository.readTopicProgress('lesson.rollback')).hasBeenCompleted,
      isFalse,
    );

    await database.customStatement('DROP TRIGGER fail_lesson_step_insert');
    final retry = await repository.recordCompletedLessonAttempt(command);

    expect(retry.status, CompletedLessonAttemptPersistenceStatus.created);
    expect(await repository.getLessonAttempts('lesson.rollback'), hasLength(1));
  });

  test('malformed attempt summaries are skipped locally', () async {
    await repository.recordCompletedLessonAttempt(
      _attemptCommand(
        attemptId: 'attempt.valid',
        lessonId: 'lesson.valid',
        courseId: 'course.spanish.a0',
        completedAt: DateTime.utc(2026, 7, 11),
      ),
    );
    await database
        .into(database.lessonAttempts)
        .insert(
          LessonAttemptsCompanion(
            attemptId: const Value('attempt.bad'),
            lessonId: const Value('lesson.bad'),
            courseId: const Value('course.spanish.a0'),
            attemptPurpose: const Value('not_a_known_purpose'),
            completedAt: Value(DateTime.utc(2026, 7, 12)),
            outcomeStatus: const Value('mastered'),
            outcomeReasonCode: const Value('all_steps_mastered'),
            assessedStepCount: const Value(1),
            masteredStepCount: const Value(1),
            fragileStepCount: const Value(0),
            notMasteredStepCount: const Value(0),
            unassessedStepCount: const Value(0),
            canonicalCheckableStepCount: const Value(1),
            totalSubmissionCount: const Value(1),
            learningPolicyVersion: const Value('e20-v1'),
          ),
        );

    final summaries = await repository.getCourseLessonAttemptSummaries(
      'course.spanish.a0',
    );

    expect(summaries.map((summary) => summary.attemptId), ['attempt.valid']);
  });

  test('deleting an attempt cascades to step results', () async {
    await repository.recordCompletedLessonAttempt(
      _attemptCommand(
        attemptId: 'attempt.delete',
        lessonId: 'lesson.delete',
        courseId: 'course.spanish.a0',
        completedAt: DateTime.utc(2026, 7, 11),
      ),
    );

    await (database.delete(
      database.lessonAttempts,
    )..where((table) => table.attemptId.equals('attempt.delete'))).go();

    expect(await repository.getAttemptStepResults('attempt.delete'), isEmpty);
  });

  test('attempt survives database close and reopen', () async {
    final file = File(
      '${Directory.systemTemp.path}/'
      'tutor_language_attempt_test_${DateTime.now().microsecondsSinceEpoch}.sqlite',
    );
    if (file.existsSync()) {
      file.deleteSync();
    }
    addTearDown(() {
      if (file.existsSync()) {
        file.deleteSync();
      }
    });

    final firstDatabase = AppDatabase(NativeDatabase(file));
    final firstRepository = LearnerProgressRepository(firstDatabase);
    await firstRepository.recordCompletedLessonAttempt(
      _attemptCommand(
        attemptId: 'attempt.restart',
        lessonId: 'lesson.restart',
        courseId: 'course.spanish.a0',
        completedAt: DateTime.utc(2026, 7, 11),
        purpose: LessonAttemptPurpose.reinforcementRepeat,
      ),
    );
    await firstDatabase.close();

    final secondDatabase = AppDatabase(NativeDatabase(file));
    addTearDown(secondDatabase.close);
    final secondRepository = LearnerProgressRepository(secondDatabase);

    final latest = await secondRepository.getLatestLessonAttempt(
      'lesson.restart',
    );
    final steps = await secondRepository.getAttemptStepResults(
      'attempt.restart',
    );

    expect(latest?.outcomeStatus, DurableLessonOutcomeStatus.mastered);
    expect(latest?.purpose, LessonAttemptPurpose.reinforcementRepeat);
    expect(latest?.masteredStepCount, 1);
    expect(latest?.learningPolicyVersion, 'e20-v1');
    expect(
      steps.single.masteryReasonCode,
      DurableStepMasteryReasonCode.firstAttemptCorrect,
    );
  });
}

CompletedLessonAttemptCommand _attemptCommand({
  required String attemptId,
  required String lessonId,
  required String courseId,
  required DateTime completedAt,
  DurableLessonOutcomeStatus outcomeStatus =
      DurableLessonOutcomeStatus.mastered,
  bool additionalStep = false,
  LessonAttemptPurpose purpose = LessonAttemptPurpose.normal,
}) {
  final mastered = outcomeStatus == DurableLessonOutcomeStatus.mastered ? 1 : 0;
  final fragile = outcomeStatus == DurableLessonOutcomeStatus.mastered ? 0 : 1;
  final outcomeReason = outcomeStatus == DurableLessonOutcomeStatus.mastered
      ? DurableLessonOutcomeReasonCode.allStepsMastered
      : DurableLessonOutcomeReasonCode.fragileMasteryPresent;
  final stepStatus = outcomeStatus == DurableLessonOutcomeStatus.mastered
      ? DurableStepMasteryStatus.mastered
      : DurableStepMasteryStatus.fragile;
  final stepReason = outcomeStatus == DurableLessonOutcomeStatus.mastered
      ? DurableStepMasteryReasonCode.firstAttemptCorrect
      : DurableStepMasteryReasonCode.acceptedWithCorrection;

  final stepResults = [
    DurableStepResult(
      attemptId: attemptId,
      lessonId: lessonId,
      stepId: 'step.practice',
      masteryStatus: stepStatus,
      masteryReasonCode: stepReason,
      attemptCount: 1,
      successfulSubmissionCount: 1,
      latestEvaluationOutcome: DurableActivityResultStatus.correct,
      remediationWasRequired: false,
      reviewWasRequired: false,
      confirmationSucceeded: false,
    ),
    if (additionalStep)
      DurableStepResult(
        attemptId: attemptId,
        lessonId: lessonId,
        stepId: 'step.practice.2',
        masteryStatus: stepStatus,
        masteryReasonCode: stepReason,
        attemptCount: 1,
        successfulSubmissionCount: 1,
        latestEvaluationOutcome: DurableActivityResultStatus.correct,
        remediationWasRequired: false,
        reviewWasRequired: false,
        confirmationSucceeded: false,
      ),
  ];

  return CompletedLessonAttemptCommand(
    attempt: DurableLessonAttempt(
      attemptId: attemptId,
      lessonId: lessonId,
      courseId: courseId,
      purpose: purpose,
      completedAt: completedAt,
      outcomeStatus: outcomeStatus,
      outcomeReasonCode: outcomeReason,
      assessedStepCount: stepResults.length,
      masteredStepCount: mastered * stepResults.length,
      fragileStepCount: fragile * stepResults.length,
      notMasteredStepCount: 0,
      unassessedStepCount: 0,
      canonicalCheckableStepCount: stepResults.length,
      totalSubmissionCount: stepResults.length,
      learningPolicyVersion: 'e20-v1',
    ),
    stepResults: stepResults,
  );
}

DurableLessonAttempt _copyAttempt(
  DurableLessonAttempt attempt, {
  String? attemptId,
  String? lessonId,
  String? courseId,
  LessonAttemptPurpose? purpose,
  DateTime? completedAt,
  DurableLessonOutcomeStatus? outcomeStatus,
  DurableLessonOutcomeReasonCode? outcomeReasonCode,
  int? assessedStepCount,
  int? masteredStepCount,
  int? fragileStepCount,
  int? notMasteredStepCount,
  int? unassessedStepCount,
  int? canonicalCheckableStepCount,
  int? totalSubmissionCount,
  String? learningPolicyVersion,
}) {
  return DurableLessonAttempt(
    attemptId: attemptId ?? attempt.attemptId,
    lessonId: lessonId ?? attempt.lessonId,
    courseId: courseId ?? attempt.courseId,
    purpose: purpose ?? attempt.purpose,
    startedAt: attempt.startedAt,
    completedAt: completedAt ?? attempt.completedAt,
    outcomeStatus: outcomeStatus ?? attempt.outcomeStatus,
    outcomeReasonCode: outcomeReasonCode ?? attempt.outcomeReasonCode,
    assessedStepCount: assessedStepCount ?? attempt.assessedStepCount,
    masteredStepCount: masteredStepCount ?? attempt.masteredStepCount,
    fragileStepCount: fragileStepCount ?? attempt.fragileStepCount,
    notMasteredStepCount: notMasteredStepCount ?? attempt.notMasteredStepCount,
    unassessedStepCount: unassessedStepCount ?? attempt.unassessedStepCount,
    canonicalCheckableStepCount:
        canonicalCheckableStepCount ?? attempt.canonicalCheckableStepCount,
    totalSubmissionCount: totalSubmissionCount ?? attempt.totalSubmissionCount,
    learningPolicyVersion:
        learningPolicyVersion ?? attempt.learningPolicyVersion,
  );
}

DurableStepResult _copyStep(
  DurableStepResult step, {
  String? attemptId,
  String? lessonId,
  String? stepId,
  DurableStepMasteryStatus? masteryStatus,
  DurableStepMasteryReasonCode? masteryReasonCode,
  int? attemptCount,
  int? successfulSubmissionCount,
  DurableActivityResultStatus? latestEvaluationOutcome,
  bool? remediationWasRequired,
  bool? reviewWasRequired,
  bool? confirmationSucceeded,
}) {
  return DurableStepResult(
    attemptId: attemptId ?? step.attemptId,
    lessonId: lessonId ?? step.lessonId,
    stepId: stepId ?? step.stepId,
    masteryStatus: masteryStatus ?? step.masteryStatus,
    masteryReasonCode: masteryReasonCode ?? step.masteryReasonCode,
    attemptCount: attemptCount ?? step.attemptCount,
    successfulSubmissionCount:
        successfulSubmissionCount ?? step.successfulSubmissionCount,
    latestEvaluationOutcome:
        latestEvaluationOutcome ?? step.latestEvaluationOutcome,
    remediationWasRequired:
        remediationWasRequired ?? step.remediationWasRequired,
    reviewWasRequired: reviewWasRequired ?? step.reviewWasRequired,
    confirmationSucceeded: confirmationSucceeded ?? step.confirmationSucceeded,
  );
}
