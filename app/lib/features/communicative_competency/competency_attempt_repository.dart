import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';
import 'communicative_competency_models.dart';
import 'competency_attempt.dart';

class CompetencyAttemptRepository {
  CompetencyAttemptRepository(this._database);

  final AppDatabase _database;

  Future<CompetencyPersistenceResult> startCompetencyAttempt(
    StartCompetencyAttemptCommand command,
  ) async {
    try {
      _validateAttempt(command.attempt, allowCompleted: false);
      final existing = await _attemptRow(command.attempt.attemptId);
      if (existing == null) {
        await _database
            .into(_database.competencyAttempts)
            .insert(_attemptCompanion(command.attempt));
        return CompetencyPersistenceResult(
          status: CompetencyPersistenceStatus.created,
          attemptId: command.attempt.attemptId,
        );
      }

      final existingAttempt = _attemptFromRow(existing);
      if (_attemptsMatch(existingAttempt, command.attempt)) {
        return CompetencyPersistenceResult(
          status: CompetencyPersistenceStatus.alreadyRecordedIdentically,
          attemptId: command.attempt.attemptId,
        );
      }

      return CompetencyPersistenceResult(
        status: CompetencyPersistenceStatus.conflict,
        attemptId: command.attempt.attemptId,
        message: 'A different competency attempt already exists.',
      );
    } on Exception catch (error) {
      return CompetencyPersistenceResult(
        status: CompetencyPersistenceStatus.failure,
        attemptId: command.attempt.attemptId,
        message: error.toString(),
      );
    }
  }

  Future<CompetencyPersistenceResult> recordTaskResult(
    DurableCompetencyTaskResult result,
  ) async {
    try {
      _validateTaskResult(result);
      final existing =
          await (_database.select(_database.competencyTaskResults)
                ..where((table) => table.resultId.equals(result.resultId))
                ..limit(1))
              .getSingleOrNull();
      if (existing == null) {
        await _database
            .into(_database.competencyTaskResults)
            .insert(_taskResultCompanion(result));
        return CompetencyPersistenceResult(
          status: CompetencyPersistenceStatus.created,
          attemptId: result.attemptId,
        );
      }

      final existingResult = _taskResultFromRow(existing);
      if (_taskResultsMatch(existingResult, result)) {
        return CompetencyPersistenceResult(
          status: CompetencyPersistenceStatus.alreadyRecordedIdentically,
          attemptId: result.attemptId,
        );
      }

      return CompetencyPersistenceResult(
        status: CompetencyPersistenceStatus.conflict,
        attemptId: result.attemptId,
        message: 'A different competency task result already exists.',
      );
    } on Exception catch (error) {
      return CompetencyPersistenceResult(
        status: CompetencyPersistenceStatus.failure,
        attemptId: result.attemptId,
        message: error.toString(),
      );
    }
  }

  Future<CompetencyPersistenceResult> recordGap(
    DurableCompetencyGap gap,
  ) async {
    try {
      _validateGap(gap);
      final existing =
          await (_database.select(_database.competencyGaps)
                ..where(
                  (table) =>
                      table.attemptId.equals(gap.attemptId) &
                      table.gapId.equals(gap.gapId),
                )
                ..limit(1))
              .getSingleOrNull();
      if (existing == null) {
        await _database
            .into(_database.competencyGaps)
            .insert(_gapCompanion(gap));
        return CompetencyPersistenceResult(
          status: CompetencyPersistenceStatus.created,
          attemptId: gap.attemptId,
        );
      }

      final existingGap = _gapFromRow(existing);
      if (_gapsMatch(existingGap, gap)) {
        return CompetencyPersistenceResult(
          status: CompetencyPersistenceStatus.alreadyRecordedIdentically,
          attemptId: gap.attemptId,
        );
      }

      return CompetencyPersistenceResult(
        status: CompetencyPersistenceStatus.conflict,
        attemptId: gap.attemptId,
        message: 'A different competency gap already exists.',
      );
    } on Exception catch (error) {
      return CompetencyPersistenceResult(
        status: CompetencyPersistenceStatus.failure,
        attemptId: gap.attemptId,
        message: error.toString(),
      );
    }
  }

  Future<CompetencyPersistenceResult> recordRecoveryExecution(
    DurableCompetencyRecoveryExecution recovery,
  ) async {
    try {
      _validateRecovery(recovery);
      final existing =
          await (_database.select(_database.competencyRecoveryExecutions)
                ..where(
                  (table) => table.recoveryExecutionId.equals(
                    recovery.recoveryExecutionId,
                  ),
                )
                ..limit(1))
              .getSingleOrNull();
      if (existing == null) {
        await _database
            .into(_database.competencyRecoveryExecutions)
            .insert(_recoveryCompanion(recovery));
        return CompetencyPersistenceResult(
          status: CompetencyPersistenceStatus.created,
          attemptId: recovery.attemptId,
        );
      }

      final existingRecovery = _recoveryFromRow(existing);
      if (_recoveriesMatch(existingRecovery, recovery)) {
        return CompetencyPersistenceResult(
          status: CompetencyPersistenceStatus.alreadyRecordedIdentically,
          attemptId: recovery.attemptId,
        );
      }

      return CompetencyPersistenceResult(
        status: CompetencyPersistenceStatus.conflict,
        attemptId: recovery.attemptId,
        message: 'A different competency recovery already exists.',
      );
    } on Exception catch (error) {
      return CompetencyPersistenceResult(
        status: CompetencyPersistenceStatus.failure,
        attemptId: recovery.attemptId,
        message: error.toString(),
      );
    }
  }

  Future<CompetencyPersistenceResult> resolveGap({
    required String attemptId,
    required String gapId,
    required DateTime resolvedAt,
  }) async {
    final count =
        await (_database.update(_database.competencyGaps)..where(
              (table) =>
                  table.attemptId.equals(attemptId) &
                  table.gapId.equals(gapId) &
                  table.resolutionStatus.equals(
                    CompetencyGapResolutionStatus.unresolved.code,
                  ),
            ))
            .write(
              CompetencyGapsCompanion(
                resolvedAt: Value(resolvedAt),
                resolutionStatus: Value(
                  CompetencyGapResolutionStatus.resolved.code,
                ),
              ),
            );

    return CompetencyPersistenceResult(
      status: count == 0
          ? CompetencyPersistenceStatus.alreadyRecordedIdentically
          : CompetencyPersistenceStatus.updated,
      attemptId: attemptId,
    );
  }

  Future<CompetencyPersistenceResult> completeCompetencyAttempt(
    CompleteCompetencyAttemptCommand command,
  ) async {
    try {
      final row = await _attemptRow(command.attemptId);
      if (row == null) {
        return CompetencyPersistenceResult(
          status: CompetencyPersistenceStatus.failure,
          attemptId: command.attemptId,
          message: 'Competency attempt does not exist.',
        );
      }

      final existing = _attemptFromRow(row);
      if (existing.status == CompetencyAttemptStatus.completed) {
        if (existing.finalOutcome == command.finalOutcome &&
            _sameDateTime(existing.completedAt, command.completedAt)) {
          return CompetencyPersistenceResult(
            status: CompetencyPersistenceStatus.alreadyRecordedIdentically,
            attemptId: command.attemptId,
          );
        }
        return CompetencyPersistenceResult(
          status: CompetencyPersistenceStatus.conflict,
          attemptId: command.attemptId,
          message: 'Competency attempt already completed differently.',
        );
      }

      await (_database.update(
        _database.competencyAttempts,
      )..where((table) => table.attemptId.equals(command.attemptId))).write(
        CompetencyAttemptsCompanion(
          status: Value(CompetencyAttemptStatus.completed.code),
          completedAt: Value(command.completedAt),
          finalOutcome: Value(command.finalOutcome.name),
        ),
      );

      return CompetencyPersistenceResult(
        status: CompetencyPersistenceStatus.updated,
        attemptId: command.attemptId,
      );
    } on Exception catch (error) {
      return CompetencyPersistenceResult(
        status: CompetencyPersistenceStatus.failure,
        attemptId: command.attemptId,
        message: error.toString(),
      );
    }
  }

  Future<CompetencyAttemptSnapshot?> loadActiveCompetencyAttempt(
    String competencyId,
  ) async {
    final row =
        await (_database.select(_database.competencyAttempts)
              ..where(
                (table) =>
                    table.competencyId.equals(competencyId) &
                    table.status.equals(
                      CompetencyAttemptStatus.inProgress.code,
                    ),
              )
              ..orderBy([(table) => OrderingTerm.desc(table.startedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      return null;
    }
    return loadCompetencyAttempt(row.attemptId);
  }

  Future<CompetencyAttemptSnapshot?> loadCompetencyAttempt(
    String attemptId,
  ) async {
    final row = await _attemptRow(attemptId);
    if (row == null) {
      return null;
    }
    final taskRows =
        await (_database.select(_database.competencyTaskResults)
              ..where((table) => table.attemptId.equals(attemptId))
              ..orderBy([
                (table) => OrderingTerm.asc(table.createdAt),
                (table) => OrderingTerm.asc(table.resultId),
              ]))
            .get();
    final gapRows =
        await (_database.select(_database.competencyGaps)
              ..where((table) => table.attemptId.equals(attemptId))
              ..orderBy([(table) => OrderingTerm.asc(table.detectedAt)]))
            .get();
    final recoveryRows =
        await (_database.select(_database.competencyRecoveryExecutions)
              ..where((table) => table.attemptId.equals(attemptId))
              ..orderBy([
                (table) => OrderingTerm.asc(table.recoveryExecutionId),
              ]))
            .get();

    return CompetencyAttemptSnapshot(
      attempt: _attemptFromRow(row),
      taskResults: taskRows.map(_taskResultFromRow).toList(growable: false),
      gaps: gapRows.map(_gapFromRow).toList(growable: false),
      recoveryExecutions: recoveryRows
          .map(_recoveryFromRow)
          .toList(growable: false),
    );
  }

  Future<List<CompetencyAttemptSnapshot>> loadCompetencyAttemptHistory(
    String competencyId,
  ) async {
    final rows =
        await (_database.select(_database.competencyAttempts)
              ..where((table) => table.competencyId.equals(competencyId))
              ..orderBy([
                (table) => OrderingTerm.asc(table.startedAt),
                (table) => OrderingTerm.asc(table.attemptId),
              ]))
            .get();
    final snapshots = <CompetencyAttemptSnapshot>[];
    for (final row in rows) {
      final snapshot = await loadCompetencyAttempt(row.attemptId);
      if (snapshot != null) {
        snapshots.add(snapshot);
      }
    }
    return List.unmodifiable(snapshots);
  }

  Future<DurableCompetencyAttempt?> loadLatestCompetencyOutcome(
    String competencyId,
  ) async {
    final row =
        await (_database.select(_database.competencyAttempts)
              ..where(
                (table) =>
                    table.competencyId.equals(competencyId) &
                    table.status.equals(CompetencyAttemptStatus.completed.code),
              )
              ..orderBy([
                (table) => OrderingTerm.desc(table.completedAt),
                (table) => OrderingTerm.desc(table.attemptId),
              ])
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _attemptFromRow(row);
  }

  Future<CompetencyAttemptRow?> _attemptRow(String attemptId) {
    return (_database.select(_database.competencyAttempts)
          ..where((table) => table.attemptId.equals(attemptId))
          ..limit(1))
        .getSingleOrNull();
  }

  void _validateAttempt(
    DurableCompetencyAttempt attempt, {
    required bool allowCompleted,
  }) {
    if (attempt.attemptId.isEmpty ||
        attempt.competencyId.isEmpty ||
        attempt.moduleId.isEmpty ||
        attempt.definitionFingerprint.isEmpty) {
      throw const CompetencyAttemptValidationException(
        'Competency attempt identifiers and definition fingerprint are required.',
      );
    }
    if (!allowCompleted &&
        attempt.status != CompetencyAttemptStatus.inProgress) {
      throw const CompetencyAttemptValidationException(
        'New competency attempts must start in progress.',
      );
    }
  }

  void _validateTaskResult(DurableCompetencyTaskResult result) {
    if (result.resultId.isEmpty ||
        result.attemptId.isEmpty ||
        result.assessmentTaskId.isEmpty ||
        result.microCompetencyIds.isEmpty ||
        result.attemptSequence < 1 ||
        result.activityResultStatus.isEmpty) {
      throw const CompetencyAttemptValidationException(
        'Competency task result is incomplete.',
      );
    }
  }

  void _validateGap(DurableCompetencyGap gap) {
    if (gap.gapId.isEmpty ||
        gap.attemptId.isEmpty ||
        gap.assessmentTaskId.isEmpty ||
        gap.microCompetencyId.isEmpty ||
        gap.reasonCode.isEmpty ||
        gap.sourceModuleId.isEmpty ||
        gap.sourceLessonId.isEmpty ||
        gap.sourceStepId.isEmpty) {
      throw const CompetencyAttemptValidationException(
        'Competency gap provenance is incomplete.',
      );
    }
  }

  void _validateRecovery(DurableCompetencyRecoveryExecution recovery) {
    if (recovery.recoveryExecutionId.isEmpty ||
        recovery.attemptId.isEmpty ||
        recovery.gapId.isEmpty ||
        recovery.recoveryStepId.isEmpty ||
        recovery.sourceModuleId.isEmpty ||
        recovery.sourceLessonId.isEmpty ||
        recovery.sourceStepId.isEmpty) {
      throw const CompetencyAttemptValidationException(
        'Competency recovery provenance is incomplete.',
      );
    }
  }

  CompetencyAttemptsCompanion _attemptCompanion(
    DurableCompetencyAttempt attempt,
  ) {
    return CompetencyAttemptsCompanion(
      attemptId: Value(attempt.attemptId),
      competencyId: Value(attempt.competencyId),
      moduleId: Value(attempt.moduleId),
      startedAt: Value(attempt.startedAt),
      completedAt: Value(attempt.completedAt),
      status: Value(attempt.status.code),
      finalOutcome: Value(attempt.finalOutcome?.name),
      definitionFingerprint: Value(attempt.definitionFingerprint),
    );
  }

  CompetencyTaskResultsCompanion _taskResultCompanion(
    DurableCompetencyTaskResult result,
  ) {
    return CompetencyTaskResultsCompanion(
      resultId: Value(result.resultId),
      attemptId: Value(result.attemptId),
      assessmentTaskId: Value(result.assessmentTaskId),
      microCompetencyIdsJson: Value(jsonEncode(result.microCompetencyIds)),
      attemptSequence: Value(result.attemptSequence),
      phase: Value(result.phase.code),
      activityResultStatus: Value(result.activityResultStatus),
      reasonCode: Value(result.reasonCode),
      createdAt: Value(result.createdAt),
    );
  }

  CompetencyGapsCompanion _gapCompanion(DurableCompetencyGap gap) {
    return CompetencyGapsCompanion(
      gapId: Value(gap.gapId),
      attemptId: Value(gap.attemptId),
      assessmentTaskId: Value(gap.assessmentTaskId),
      microCompetencyId: Value(gap.microCompetencyId),
      reasonCode: Value(gap.reasonCode),
      sourceModuleId: Value(gap.sourceModuleId),
      sourceLessonId: Value(gap.sourceLessonId),
      sourceStepId: Value(gap.sourceStepId),
      detectedAt: Value(gap.detectedAt),
      resolvedAt: Value(gap.resolvedAt),
      resolutionStatus: Value(gap.resolutionStatus.code),
    );
  }

  CompetencyRecoveryExecutionsCompanion _recoveryCompanion(
    DurableCompetencyRecoveryExecution recovery,
  ) {
    return CompetencyRecoveryExecutionsCompanion(
      recoveryExecutionId: Value(recovery.recoveryExecutionId),
      attemptId: Value(recovery.attemptId),
      gapId: Value(recovery.gapId),
      recoveryStepId: Value(recovery.recoveryStepId),
      sourceModuleId: Value(recovery.sourceModuleId),
      sourceLessonId: Value(recovery.sourceLessonId),
      sourceStepId: Value(recovery.sourceStepId),
      status: Value(recovery.status.code),
      startedAt: Value(recovery.startedAt),
      completedAt: Value(recovery.completedAt),
      succeeded: Value(recovery.succeeded),
      retryOccurred: Value(recovery.retryOccurred),
    );
  }

  DurableCompetencyAttempt _attemptFromRow(CompetencyAttemptRow row) {
    return DurableCompetencyAttempt(
      attemptId: row.attemptId,
      competencyId: row.competencyId,
      moduleId: row.moduleId,
      startedAt: row.startedAt.toUtc(),
      completedAt: row.completedAt?.toUtc(),
      status: CompetencyAttemptStatus.fromCode(row.status),
      finalOutcome: row.finalOutcome == null
          ? null
          : CompetencyOutcomeStatus.values.byName(row.finalOutcome!),
      definitionFingerprint: row.definitionFingerprint,
    );
  }

  DurableCompetencyTaskResult _taskResultFromRow(CompetencyTaskResultRow row) {
    return DurableCompetencyTaskResult(
      resultId: row.resultId,
      attemptId: row.attemptId,
      assessmentTaskId: row.assessmentTaskId,
      microCompetencyIds: (jsonDecode(row.microCompetencyIdsJson) as List)
          .cast<String>(),
      attemptSequence: row.attemptSequence,
      phase: CompetencyTaskResultPhase.fromCode(row.phase),
      activityResultStatus: row.activityResultStatus,
      reasonCode: row.reasonCode,
      createdAt: row.createdAt.toUtc(),
    );
  }

  DurableCompetencyGap _gapFromRow(CompetencyGapRow row) {
    return DurableCompetencyGap(
      gapId: row.gapId,
      attemptId: row.attemptId,
      assessmentTaskId: row.assessmentTaskId,
      microCompetencyId: row.microCompetencyId,
      reasonCode: row.reasonCode,
      sourceModuleId: row.sourceModuleId,
      sourceLessonId: row.sourceLessonId,
      sourceStepId: row.sourceStepId,
      detectedAt: row.detectedAt.toUtc(),
      resolvedAt: row.resolvedAt?.toUtc(),
      resolutionStatus: CompetencyGapResolutionStatus.fromCode(
        row.resolutionStatus,
      ),
    );
  }

  DurableCompetencyRecoveryExecution _recoveryFromRow(
    CompetencyRecoveryExecutionRow row,
  ) {
    return DurableCompetencyRecoveryExecution(
      recoveryExecutionId: row.recoveryExecutionId,
      attemptId: row.attemptId,
      gapId: row.gapId,
      recoveryStepId: row.recoveryStepId,
      sourceModuleId: row.sourceModuleId,
      sourceLessonId: row.sourceLessonId,
      sourceStepId: row.sourceStepId,
      status: CompetencyRecoveryExecutionStatus.fromCode(row.status),
      startedAt: row.startedAt?.toUtc(),
      completedAt: row.completedAt?.toUtc(),
      succeeded: row.succeeded,
      retryOccurred: row.retryOccurred,
    );
  }

  bool _attemptsMatch(
    DurableCompetencyAttempt left,
    DurableCompetencyAttempt right,
  ) {
    return left.attemptId == right.attemptId &&
        left.competencyId == right.competencyId &&
        left.moduleId == right.moduleId &&
        _sameDateTime(left.startedAt, right.startedAt) &&
        _sameDateTime(left.completedAt, right.completedAt) &&
        left.status == right.status &&
        left.finalOutcome == right.finalOutcome &&
        left.definitionFingerprint == right.definitionFingerprint;
  }

  bool _taskResultsMatch(
    DurableCompetencyTaskResult left,
    DurableCompetencyTaskResult right,
  ) {
    return left.resultId == right.resultId &&
        left.attemptId == right.attemptId &&
        left.assessmentTaskId == right.assessmentTaskId &&
        _listEquals(left.microCompetencyIds, right.microCompetencyIds) &&
        left.attemptSequence == right.attemptSequence &&
        left.phase == right.phase &&
        left.activityResultStatus == right.activityResultStatus &&
        left.reasonCode == right.reasonCode &&
        _sameDateTime(left.createdAt, right.createdAt);
  }

  bool _gapsMatch(DurableCompetencyGap left, DurableCompetencyGap right) {
    return left.gapId == right.gapId &&
        left.attemptId == right.attemptId &&
        left.assessmentTaskId == right.assessmentTaskId &&
        left.microCompetencyId == right.microCompetencyId &&
        left.reasonCode == right.reasonCode &&
        left.sourceModuleId == right.sourceModuleId &&
        left.sourceLessonId == right.sourceLessonId &&
        left.sourceStepId == right.sourceStepId &&
        _sameDateTime(left.detectedAt, right.detectedAt) &&
        _sameDateTime(left.resolvedAt, right.resolvedAt) &&
        left.resolutionStatus == right.resolutionStatus;
  }

  bool _recoveriesMatch(
    DurableCompetencyRecoveryExecution left,
    DurableCompetencyRecoveryExecution right,
  ) {
    return left.recoveryExecutionId == right.recoveryExecutionId &&
        left.attemptId == right.attemptId &&
        left.gapId == right.gapId &&
        left.recoveryStepId == right.recoveryStepId &&
        left.sourceModuleId == right.sourceModuleId &&
        left.sourceLessonId == right.sourceLessonId &&
        left.sourceStepId == right.sourceStepId &&
        left.status == right.status &&
        _sameDateTime(left.startedAt, right.startedAt) &&
        _sameDateTime(left.completedAt, right.completedAt) &&
        left.succeeded == right.succeeded &&
        left.retryOccurred == right.retryOccurred;
  }

  bool _sameDateTime(DateTime? left, DateTime? right) {
    if (left == null || right == null) {
      return left == right;
    }
    return left.toUtc().microsecondsSinceEpoch ==
        right.toUtc().microsecondsSinceEpoch;
  }

  bool _listEquals(List<String> left, List<String> right) {
    if (left.length != right.length) {
      return false;
    }
    for (var i = 0; i < left.length; i++) {
      if (left[i] != right[i]) {
        return false;
      }
    }
    return true;
  }
}
