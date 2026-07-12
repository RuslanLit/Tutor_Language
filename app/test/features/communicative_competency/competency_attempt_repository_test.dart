import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/features/communicative_competency/communicative_competency.dart';

void main() {
  late AppDatabase database;
  late CompetencyAttemptRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = CompetencyAttemptRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('starts and resumes an active competency attempt', () async {
    final attempt = _attempt();

    final created = await repository.startCompetencyAttempt(
      StartCompetencyAttemptCommand(attempt: attempt),
    );
    final duplicate = await repository.startCompetencyAttempt(
      StartCompetencyAttemptCommand(attempt: attempt),
    );
    final active = await repository.loadActiveCompetencyAttempt(
      attempt.competencyId,
    );

    expect(created.status, CompetencyPersistenceStatus.created);
    expect(
      duplicate.status,
      CompetencyPersistenceStatus.alreadyRecordedIdentically,
    );
    expect(active?.attempt.attemptId, attempt.attemptId);
    expect(active?.taskResults, isEmpty);
  });

  test('conflicting duplicate start is rejected', () async {
    final attempt = _attempt();
    await repository.startCompetencyAttempt(
      StartCompetencyAttemptCommand(attempt: attempt),
    );

    final conflict = await repository.startCompetencyAttempt(
      StartCompetencyAttemptCommand(
        attempt: DurableCompetencyAttempt(
          attemptId: attempt.attemptId,
          competencyId: attempt.competencyId,
          moduleId: 'M99',
          startedAt: attempt.startedAt,
          status: CompetencyAttemptStatus.inProgress,
          definitionFingerprint: attempt.definitionFingerprint,
        ),
      ),
    );

    expect(conflict.status, CompetencyPersistenceStatus.conflict);
  });

  test('records task result, gap, recovery, retry and completion', () async {
    final attempt = _attempt();
    await repository.startCompetencyAttempt(
      StartCompetencyAttemptCommand(attempt: attempt),
    );

    final firstResult = _taskResult(
      resultId: 'result.initial',
      phase: CompetencyTaskResultPhase.initialAssessment,
      activityResultStatus: 'incorrect',
    );
    final firstWrite = await repository.recordTaskResult(firstResult);
    final firstDuplicate = await repository.recordTaskResult(firstResult);

    final gap = _gap();
    final gapWrite = await repository.recordGap(gap);

    final recovery = _recovery();
    final recoveryWrite = await repository.recordRecoveryExecution(recovery);
    final resolved = await repository.resolveGap(
      attemptId: attempt.attemptId,
      gapId: gap.gapId,
      resolvedAt: _now(4),
    );

    final retry = _taskResult(
      resultId: 'result.retry',
      phase: CompetencyTaskResultPhase.retry,
      activityResultStatus: 'correct',
      sequence: 2,
      at: _now(5),
    );
    final retryWrite = await repository.recordTaskResult(retry);
    final completed = await repository.completeCompetencyAttempt(
      CompleteCompetencyAttemptCommand(
        attemptId: attempt.attemptId,
        completedAt: _now(6),
        finalOutcome: CompetencyOutcomeStatus.achievedWithReinforcement,
      ),
    );

    final snapshot = await repository.loadCompetencyAttempt(attempt.attemptId);
    final latest = await repository.loadLatestCompetencyOutcome(
      attempt.competencyId,
    );

    expect(firstWrite.status, CompetencyPersistenceStatus.created);
    expect(
      firstDuplicate.status,
      CompetencyPersistenceStatus.alreadyRecordedIdentically,
    );
    expect(gapWrite.status, CompetencyPersistenceStatus.created);
    expect(recoveryWrite.status, CompetencyPersistenceStatus.created);
    expect(resolved.status, CompetencyPersistenceStatus.updated);
    expect(retryWrite.status, CompetencyPersistenceStatus.created);
    expect(completed.status, CompetencyPersistenceStatus.updated);
    expect(snapshot?.taskResults, hasLength(2));
    expect(
      snapshot?.gaps.single.resolutionStatus,
      CompetencyGapResolutionStatus.resolved,
    );
    expect(
      snapshot?.recoveryExecutions.single.recoveryStepId,
      'step.recovery.m02.me_llamo',
    );
    expect(
      latest?.finalOutcome,
      CompetencyOutcomeStatus.achievedWithReinforcement,
    );
  });

  test('conflicting immutable task result is rejected', () async {
    final attempt = _attempt();
    await repository.startCompetencyAttempt(
      StartCompetencyAttemptCommand(attempt: attempt),
    );
    final original = _taskResult(resultId: 'result.same');
    await repository.recordTaskResult(original);

    final conflict = await repository.recordTaskResult(
      _taskResult(resultId: 'result.same', activityResultStatus: 'correct'),
    );

    expect(conflict.status, CompetencyPersistenceStatus.conflict);
  });

  test(
    'duplicate completion is idempotent but changed outcome conflicts',
    () async {
      final attempt = _attempt();
      await repository.startCompetencyAttempt(
        StartCompetencyAttemptCommand(attempt: attempt),
      );
      final command = CompleteCompetencyAttemptCommand(
        attemptId: attempt.attemptId,
        completedAt: _now(10),
        finalOutcome: CompetencyOutcomeStatus.achieved,
      );

      final completed = await repository.completeCompetencyAttempt(command);
      final duplicate = await repository.completeCompetencyAttempt(command);
      final conflict = await repository.completeCompetencyAttempt(
        CompleteCompetencyAttemptCommand(
          attemptId: attempt.attemptId,
          completedAt: _now(10),
          finalOutcome: CompetencyOutcomeStatus.notYetAchieved,
        ),
      );

      expect(completed.status, CompetencyPersistenceStatus.updated);
      expect(
        duplicate.status,
        CompetencyPersistenceStatus.alreadyRecordedIdentically,
      );
      expect(conflict.status, CompetencyPersistenceStatus.conflict);
    },
  );

  test('new retry attempt does not erase previous history', () async {
    final first = _attempt(attemptId: 'attempt.first');
    final second = _attempt(attemptId: 'attempt.second', startOffset: 20);
    await repository.startCompetencyAttempt(
      StartCompetencyAttemptCommand(attempt: first),
    );
    await repository.completeCompetencyAttempt(
      CompleteCompetencyAttemptCommand(
        attemptId: first.attemptId,
        completedAt: _now(10),
        finalOutcome: CompetencyOutcomeStatus.notYetAchieved,
      ),
    );

    await repository.startCompetencyAttempt(
      StartCompetencyAttemptCommand(attempt: second),
    );

    final history = await repository.loadCompetencyAttemptHistory(
      first.competencyId,
    );
    final active = await repository.loadActiveCompetencyAttempt(
      first.competencyId,
    );

    expect(history.map((snapshot) => snapshot.attempt.attemptId), [
      'attempt.first',
      'attempt.second',
    ]);
    expect(active?.attempt.attemptId, 'attempt.second');
  });
}

DurableCompetencyAttempt _attempt({
  String attemptId = 'attempt.competency.1',
  int startOffset = 0,
}) {
  return DurableCompetencyAttempt(
    attemptId: attemptId,
    competencyId: 'competency.es.a0.m03.personal_profile',
    moduleId: 'M03',
    startedAt: _now(startOffset),
    status: CompetencyAttemptStatus.inProgress,
    definitionFingerprint: 'fixture-v1',
  );
}

DurableCompetencyTaskResult _taskResult({
  required String resultId,
  CompetencyTaskResultPhase phase = CompetencyTaskResultPhase.initialAssessment,
  String activityResultStatus = 'incorrect',
  int sequence = 1,
  DateTime? at,
}) {
  return DurableCompetencyTaskResult(
    resultId: resultId,
    attemptId: 'attempt.competency.1',
    assessmentTaskId: 'task.introduce_self',
    microCompetencyIds: const ['micro.introduce_self'],
    attemptSequence: sequence,
    phase: phase,
    activityResultStatus: activityResultStatus,
    reasonCode: 'prerequisite_not_retained',
    createdAt: at ?? _now(1),
  );
}

DurableCompetencyGap _gap() {
  return DurableCompetencyGap(
    gapId: 'gap.introduce_self',
    attemptId: 'attempt.competency.1',
    assessmentTaskId: 'task.introduce_self',
    microCompetencyId: 'micro.introduce_self',
    reasonCode: 'prerequisite_not_retained',
    sourceModuleId: 'M02',
    sourceLessonId: 'lesson.m02.me_llamo',
    sourceStepId: 'step.recovery.m02.me_llamo',
    detectedAt: _now(2),
    resolutionStatus: CompetencyGapResolutionStatus.unresolved,
  );
}

DurableCompetencyRecoveryExecution _recovery() {
  return DurableCompetencyRecoveryExecution(
    recoveryExecutionId: 'recovery.introduce_self.1',
    attemptId: 'attempt.competency.1',
    gapId: 'gap.introduce_self',
    recoveryStepId: 'step.recovery.m02.me_llamo',
    sourceModuleId: 'M02',
    sourceLessonId: 'lesson.m02.me_llamo',
    sourceStepId: 'step.recovery.m02.me_llamo',
    status: CompetencyRecoveryExecutionStatus.completed,
    startedAt: _now(3),
    completedAt: _now(4),
    succeeded: true,
    retryOccurred: true,
  );
}

DateTime _now(int offset) {
  return DateTime.utc(2026, 1, 1, 12, 0, offset);
}
