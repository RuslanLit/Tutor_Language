import '../activity_engine/activity_result.dart';
import '../lesson_session/lesson_session_engine.dart';
import 'communicative_competency_coordinator.dart';
import 'communicative_competency_models.dart';
import 'competency_attempt.dart';
import 'competency_attempt_repository.dart';

class CompetencySessionController {
  CompetencySessionController({
    required this.catalog,
    required this.repository,
    this.coordinator = const CommunicativeCompetencyCoordinator(),
    this.lessonSessionEngine = const LessonSessionEngine(),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final CommunicativeCompetencyCatalog catalog;
  final CompetencyAttemptRepository repository;
  final CommunicativeCompetencyCoordinator coordinator;
  final LessonSessionEngine lessonSessionEngine;
  final DateTime Function() _now;

  Future<CompetencyRuntimeState> startOrResume({
    required String competencyId,
    required String attemptId,
  }) async {
    final active = await repository.loadActiveCompetencyAttempt(competencyId);
    if (active != null) {
      return _runtimeFromSnapshot(active);
    }

    final competency = catalog.competency(competencyId);
    final attempt = DurableCompetencyAttempt(
      attemptId: attemptId,
      competencyId: competencyId,
      moduleId: competency.moduleId,
      startedAt: _now().toUtc(),
      status: CompetencyAttemptStatus.inProgress,
      definitionFingerprint: competencyDefinitionFingerprint(
        competency: competency,
        tasks: catalog.assessmentTasks,
      ),
    );
    final result = await repository.startCompetencyAttempt(
      StartCompetencyAttemptCommand(attempt: attempt),
    );
    if (!result.isSuccess) {
      throw CompetencySessionException(result.message ?? 'Start failed.');
    }
    return CompetencyRuntimeState(
      attemptId: attemptId,
      competencyState: coordinator.startAssessment(competencyId: competencyId),
      lessonSessionStateByTaskId: const {},
      nextTaskId: competency.assessmentTaskIds.first,
    );
  }

  Future<CompetencyRuntimeDecision> submitDiagnosticResult({
    required CompetencyRuntimeState state,
    required String taskId,
    required ActivityResult result,
  }) async {
    final task = catalog.task(taskId);
    final sessionDecision = _submitThroughSessionEngine(
      state: state,
      task: task,
      result: result,
    );
    final phase =
        state.competencyState.detectedGaps.values.any(
          (gap) => gap.assessmentTaskId == taskId,
        )
        ? CompetencyTaskResultPhase.retry
        : CompetencyTaskResultPhase.initialAssessment;
    await _recordTaskResult(
      state: state,
      task: task,
      result: result,
      phase: phase,
    );

    final competencyDecision = coordinator.recordTaskResult(
      catalog: catalog,
      state: state.competencyState,
      taskId: taskId,
      result: result,
    );
    var nextState = _withSessionState(
      state.copyWith(competencyState: competencyDecision.updatedState),
      taskId,
      sessionDecision.updatedState,
    );

    for (final gap in competencyDecision.gaps) {
      await repository.recordGap(
        DurableCompetencyGap(
          gapId: gap.gapId,
          attemptId: state.attemptId,
          assessmentTaskId: gap.assessmentTaskId,
          microCompetencyId: gap.microCompetencyId,
          reasonCode: gap.reasonCode.name,
          sourceModuleId: gap.sourceModuleId,
          sourceLessonId: gap.recoveryStepReferences.isEmpty
              ? gap.sourceModuleId
              : gap.recoveryStepReferences.first.sourceLessonId,
          sourceStepId: gap.recoveryStepReferences.isEmpty
              ? gap.assessmentTaskId
              : gap.recoveryStepReferences.first.sourceStepId,
          detectedAt: _now().toUtc(),
          resolutionStatus: CompetencyGapResolutionStatus.unresolved,
        ),
      );
    }

    for (final insertion in competencyDecision.recoveryInsertions) {
      await repository.recordRecoveryExecution(
        DurableCompetencyRecoveryExecution(
          recoveryExecutionId: insertion.runtimeStepId,
          attemptId: state.attemptId,
          gapId: insertion.gapId,
          recoveryStepId: insertion.sourceStepId,
          sourceModuleId: insertion.sourceModuleId,
          sourceLessonId: insertion.sourceLessonId,
          sourceStepId: insertion.sourceStepId,
          status: CompetencyRecoveryExecutionStatus.inserted,
        ),
      );
    }

    if (competencyDecision.outcome != null) {
      await _completeAttempt(state.attemptId, competencyDecision.outcome!);
    }

    nextState = nextState.copyWith(nextTaskId: _nextTaskId(nextState, taskId));
    return CompetencyRuntimeDecision(
      competencyDecision: competencyDecision,
      sessionDecision: sessionDecision,
      updatedState: nextState,
    );
  }

  Future<CompetencyRuntimeDecision> completeRecovery({
    required CompetencyRuntimeState state,
    required String gapId,
  }) async {
    final decision = coordinator.recordRecoveryCompleted(
      catalog: catalog,
      state: state.competencyState,
      gapId: gapId,
    );
    await repository.resolveGap(
      attemptId: state.attemptId,
      gapId: gapId,
      resolvedAt: _now().toUtc(),
    );
    final updated = state.copyWith(
      competencyState: decision.updatedState,
      nextTaskId: decision.assessmentTaskId,
    );
    return CompetencyRuntimeDecision(
      competencyDecision: decision,
      sessionDecision: null,
      updatedState: updated,
    );
  }

  Future<CompetencyOutcome> finishIfReady(CompetencyRuntimeState state) async {
    final outcome = coordinator.evaluateOutcome(
      catalog: catalog,
      state: state.competencyState,
    );
    await _completeAttempt(state.attemptId, outcome);
    return outcome;
  }

  LessonSessionDecision _submitThroughSessionEngine({
    required CompetencyRuntimeState state,
    required CompetencyAssessmentTask task,
    required ActivityResult result,
  }) {
    final sessionState =
        state.lessonSessionStateByTaskId[task.taskId] ??
        lessonSessionEngine
            .startSession(
              lessonId: 'competency::${state.competencyState.competencyId}',
              steps: [
                LessonSessionStep(
                  id: task.lessonStepReference,
                  isCheckable: true,
                ),
              ],
            )
            .updatedState;
    return lessonSessionEngine.submitStepResult(
      state: sessionState,
      result: result,
    );
  }

  Future<void> _recordTaskResult({
    required CompetencyRuntimeState state,
    required CompetencyAssessmentTask task,
    required ActivityResult result,
    required CompetencyTaskResultPhase phase,
  }) async {
    final sequence = _taskSequence(state, task.taskId, phase);
    final persistence = await repository.recordTaskResult(
      DurableCompetencyTaskResult(
        resultId:
            '${state.attemptId}::${task.taskId}::${phase.code}::$sequence',
        attemptId: state.attemptId,
        assessmentTaskId: task.taskId,
        microCompetencyIds: task.assessedMicroCompetencyIds,
        attemptSequence: sequence,
        phase: phase,
        activityResultStatus: result.status.name,
        reasonCode: result.feedbackKey,
        createdAt: _now().toUtc(),
      ),
    );
    if (!persistence.isSuccess) {
      throw CompetencySessionException(
        persistence.message ?? 'Task result persistence failed.',
      );
    }
  }

  int _taskSequence(
    CompetencyRuntimeState state,
    String taskId,
    CompetencyTaskResultPhase phase,
  ) {
    final retryOffset = phase == CompetencyTaskResultPhase.retry ? 2 : 1;
    return state.competencyState.retrySucceededTaskIds.contains(taskId)
        ? retryOffset + 1
        : retryOffset;
  }

  Future<void> _completeAttempt(
    String attemptId,
    CompetencyOutcome outcome,
  ) async {
    final persistence = await repository.completeCompetencyAttempt(
      CompleteCompetencyAttemptCommand(
        attemptId: attemptId,
        completedAt: _now().toUtc(),
        finalOutcome: outcome.status,
      ),
    );
    if (!persistence.isSuccess) {
      throw CompetencySessionException(
        persistence.message ?? 'Completion persistence failed.',
      );
    }
  }

  String? _nextTaskId(CompetencyRuntimeState state, String currentTaskId) {
    final competency = catalog.competency(state.competencyState.competencyId);
    final index = competency.assessmentTaskIds.indexOf(currentTaskId);
    if (index < 0) {
      return null;
    }
    for (var i = index + 1; i < competency.assessmentTaskIds.length; i++) {
      final id = competency.assessmentTaskIds[i];
      if (!state.competencyState.succeededTaskIds.contains(id)) {
        return id;
      }
    }
    return null;
  }

  CompetencyRuntimeState _runtimeFromSnapshot(
    CompetencyAttemptSnapshot snapshot,
  ) {
    var competencyState = coordinator.startAssessment(
      competencyId: snapshot.attempt.competencyId,
    );
    final succeeded = <String>{};
    final failed = <String>{};
    final gaps = <String, CompetencyGap>{};
    final inserted = <String>{};
    final completed = <String>{};
    final retrySucceeded = <String>{};

    for (final result in snapshot.taskResults) {
      if (result.activityResultStatus == ActivityResultStatus.correct.name ||
          result.activityResultStatus ==
              ActivityResultStatus.acceptedWithFeedback.name) {
        succeeded.add(result.assessmentTaskId);
        failed.remove(result.assessmentTaskId);
        if (result.phase == CompetencyTaskResultPhase.retry) {
          retrySucceeded.add(result.assessmentTaskId);
        }
      } else {
        failed.add(result.assessmentTaskId);
      }
    }

    for (final gap in snapshot.gaps) {
      final recoveryRefs = snapshot.recoveryExecutions
          .where((recovery) => recovery.gapId == gap.gapId)
          .map(
            (recovery) => CompetencyRecoveryStepReference(
              stepId: recovery.recoveryStepId,
              sourceModuleId: recovery.sourceModuleId,
              sourceLessonId: recovery.sourceLessonId,
              sourceStepId: recovery.sourceStepId,
            ),
          )
          .toList(growable: false);
      gaps[gap.gapId] = CompetencyGap(
        gapId: gap.gapId,
        competencyId: snapshot.attempt.competencyId,
        assessmentTaskId: gap.assessmentTaskId,
        microCompetencyId: gap.microCompetencyId,
        reasonCode: CompetencyGapReasonCode.values.byName(gap.reasonCode),
        sourceModuleId: gap.sourceModuleId,
        recoveryStepReferences: recoveryRefs,
      );
      if (gap.resolutionStatus == CompetencyGapResolutionStatus.resolved) {
        completed.add(gap.gapId);
      }
    }

    inserted.addAll(
      snapshot.recoveryExecutions.map((recovery) => recovery.gapId),
    );
    competencyState = competencyState.copyWith(
      succeededTaskIds: Set.unmodifiable(succeeded),
      failedTaskIds: Set.unmodifiable(failed),
      detectedGaps: Map.unmodifiable(gaps),
      insertedRecoveryGapIds: Set.unmodifiable(inserted),
      completedRecoveryGapIds: Set.unmodifiable(completed),
      retrySucceededTaskIds: Set.unmodifiable(retrySucceeded),
    );
    return CompetencyRuntimeState(
      attemptId: snapshot.attempt.attemptId,
      competencyState: competencyState,
      lessonSessionStateByTaskId: const {},
      nextTaskId: _nextUnfinishedTask(competencyState),
    );
  }

  String? _nextUnfinishedTask(CompetencyAssessmentState state) {
    final competency = catalog.competency(state.competencyId);
    for (final taskId in competency.assessmentTaskIds) {
      if (!state.succeededTaskIds.contains(taskId)) {
        return taskId;
      }
    }
    return null;
  }

  CompetencyRuntimeState _withSessionState(
    CompetencyRuntimeState state,
    String taskId,
    LessonSessionState sessionState,
  ) {
    final sessions = Map<String, LessonSessionState>.from(
      state.lessonSessionStateByTaskId,
    );
    sessions[taskId] = sessionState;
    return state.copyWith(
      lessonSessionStateByTaskId: Map.unmodifiable(sessions),
    );
  }
}

class CompetencyRuntimeState {
  const CompetencyRuntimeState({
    required this.attemptId,
    required this.competencyState,
    required this.lessonSessionStateByTaskId,
    this.nextTaskId,
  });

  final String attemptId;
  final CompetencyAssessmentState competencyState;
  final Map<String, LessonSessionState> lessonSessionStateByTaskId;
  final String? nextTaskId;

  CompetencyRuntimeState copyWith({
    CompetencyAssessmentState? competencyState,
    Map<String, LessonSessionState>? lessonSessionStateByTaskId,
    Object? nextTaskId = _unset,
  }) {
    return CompetencyRuntimeState(
      attemptId: attemptId,
      competencyState: competencyState ?? this.competencyState,
      lessonSessionStateByTaskId:
          lessonSessionStateByTaskId ?? this.lessonSessionStateByTaskId,
      nextTaskId: nextTaskId == _unset
          ? this.nextTaskId
          : nextTaskId as String?,
    );
  }
}

class CompetencyRuntimeDecision {
  const CompetencyRuntimeDecision({
    required this.competencyDecision,
    required this.updatedState,
    this.sessionDecision,
  });

  final CompetencyAssessmentDecision competencyDecision;
  final LessonSessionDecision? sessionDecision;
  final CompetencyRuntimeState updatedState;
}

class CompetencySessionException implements Exception {
  const CompetencySessionException(this.message);

  final String message;

  @override
  String toString() => message;
}

const _unset = Object();
