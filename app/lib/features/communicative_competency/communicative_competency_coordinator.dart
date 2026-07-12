import '../activity_engine/activity_result.dart';
import 'communicative_competency_models.dart';

class CommunicativeCompetencyCoordinator {
  const CommunicativeCompetencyCoordinator();

  CompetencyAssessmentState startAssessment({required String competencyId}) {
    return CompetencyAssessmentState(competencyId: competencyId);
  }

  CompetencyAssessmentDecision recordTaskResult({
    required CommunicativeCompetencyCatalog catalog,
    required CompetencyAssessmentState state,
    required String taskId,
    required ActivityResult result,
  }) {
    final task = catalog.task(taskId);
    final competency = catalog.competency(state.competencyId);
    final taskSucceeded = competencyTaskSucceeded(result);

    if (taskSucceeded) {
      final hadGap = state.detectedGaps.values.any(
        (gap) => gap.assessmentTaskId == taskId,
      );
      final nextSucceeded = Set<String>.from(state.succeededTaskIds)
        ..add(taskId);
      final nextFailed = Set<String>.from(state.failedTaskIds)..remove(taskId);
      final nextRetrySucceeded = Set<String>.from(state.retrySucceededTaskIds);
      if (hadGap) {
        nextRetrySucceeded.add(taskId);
      }
      final updatedState = state.copyWith(
        succeededTaskIds: Set.unmodifiable(nextSucceeded),
        failedTaskIds: Set.unmodifiable(nextFailed),
        retrySucceededTaskIds: Set.unmodifiable(nextRetrySucceeded),
      );

      if (_allTasksSucceeded(competency, updatedState)) {
        final outcome = evaluateOutcome(catalog: catalog, state: updatedState);
        return CompetencyAssessmentDecision(
          type: CompetencyAssessmentDecisionType.assessmentComplete,
          reasonCode: CompetencyAssessmentReasonCode.outcomeCalculated,
          updatedState: updatedState,
          assessmentTaskId: taskId,
          outcome: outcome,
        );
      }

      return CompetencyAssessmentDecision(
        type: CompetencyAssessmentDecisionType.continueAssessment,
        reasonCode: result.status == ActivityResultStatus.acceptedWithFeedback
            ? CompetencyAssessmentReasonCode.acceptedWithFeedbackSucceeded
            : CompetencyAssessmentReasonCode.taskSucceeded,
        updatedState: updatedState,
        assessmentTaskId: taskId,
      );
    }

    final nextFailed = Set<String>.from(state.failedTaskIds)..add(taskId);
    final nextSucceeded = Set<String>.from(state.succeededTaskIds)
      ..remove(taskId);
    final nextGaps = Map<String, CompetencyGap>.from(state.detectedGaps);
    final newGaps = <CompetencyGap>[];
    final insertions = <CompetencyRecoveryInsertion>[];
    final nextInsertedGapIds = Set<String>.from(state.insertedRecoveryGapIds);

    for (final mapping in task.recoveryMappings) {
      final gap = _gapFor(catalog: catalog, task: task, mapping: mapping);
      nextGaps.putIfAbsent(gap.gapId, () => gap);
      newGaps.add(gap);
      if (!nextInsertedGapIds.contains(gap.gapId) &&
          gap.recoveryStepReferences.isNotEmpty) {
        nextInsertedGapIds.add(gap.gapId);
        insertions.addAll(
          gap.recoveryStepReferences.map(
            (reference) => CompetencyRecoveryInsertion(
              runtimeStepId:
                  'competency_recovery::${gap.gapId}::${reference.stepId}',
              gapId: gap.gapId,
              originCompetencyId: gap.competencyId,
              originAssessmentTaskId: gap.assessmentTaskId,
              originMicroCompetencyId: gap.microCompetencyId,
              sourceModuleId: reference.sourceModuleId,
              sourceLessonId: reference.sourceLessonId,
              sourceStepId: reference.sourceStepId,
            ),
          ),
        );
      }
    }

    final updatedState = state.copyWith(
      succeededTaskIds: Set.unmodifiable(nextSucceeded),
      failedTaskIds: Set.unmodifiable(nextFailed),
      detectedGaps: Map.unmodifiable(nextGaps),
      insertedRecoveryGapIds: Set.unmodifiable(nextInsertedGapIds),
    );

    if (insertions.isNotEmpty) {
      return CompetencyAssessmentDecision(
        type: CompetencyAssessmentDecisionType.insertRecoverySteps,
        reasonCode: CompetencyAssessmentReasonCode.recoveryInserted,
        updatedState: updatedState,
        assessmentTaskId: taskId,
        gaps: List.unmodifiable(newGaps),
        recoveryInsertions: List.unmodifiable(insertions),
      );
    }

    return CompetencyAssessmentDecision(
      type: CompetencyAssessmentDecisionType.continueAssessment,
      reasonCode: newGaps.isEmpty
          ? CompetencyAssessmentReasonCode.recoveryUnavailable
          : CompetencyAssessmentReasonCode.gapDetected,
      updatedState: updatedState,
      assessmentTaskId: taskId,
      gaps: List.unmodifiable(newGaps),
    );
  }

  CompetencyAssessmentDecision recordRecoveryCompleted({
    required CommunicativeCompetencyCatalog catalog,
    required CompetencyAssessmentState state,
    required String gapId,
  }) {
    final gap = state.detectedGaps[gapId];
    if (gap == null) {
      return CompetencyAssessmentDecision(
        type: CompetencyAssessmentDecisionType.continueAssessment,
        reasonCode: CompetencyAssessmentReasonCode.recoveryUnavailable,
        updatedState: state,
      );
    }

    final completed = Set<String>.from(state.completedRecoveryGapIds)
      ..add(gapId);
    final updatedState = state.copyWith(
      completedRecoveryGapIds: Set.unmodifiable(completed),
    );

    return CompetencyAssessmentDecision(
      type: CompetencyAssessmentDecisionType.retryAssessmentTask,
      reasonCode: CompetencyAssessmentReasonCode.recoveryCompleted,
      updatedState: updatedState,
      assessmentTaskId: gap.assessmentTaskId,
      gaps: [gap],
    );
  }

  CompetencyOutcome evaluateOutcome({
    required CommunicativeCompetencyCatalog catalog,
    required CompetencyAssessmentState state,
  }) {
    final competency = catalog.competency(state.competencyId);
    final requiredTasks = competency.assessmentTaskIds.toSet();
    final succeededRequired = state.succeededTaskIds.intersection(
      requiredTasks,
    );
    final unresolvedGapIds = state.detectedGaps.values
        .where(
          (gap) => !state.retrySucceededTaskIds.contains(gap.assessmentTaskId),
        )
        .map((gap) => gap.gapId)
        .toSet();
    final recoveryWasRequired = state.detectedGaps.isNotEmpty;
    final centralTaskFailed = catalog.assessmentTasks.any(
      (task) =>
          task.competencyId == competency.competencyId &&
          task.isCentralTask &&
          state.failedTaskIds.contains(task.taskId) &&
          !state.succeededTaskIds.contains(task.taskId),
    );

    final status = _statusFor(
      requiredTasks: requiredTasks,
      succeededRequired: succeededRequired,
      unresolvedGapIds: unresolvedGapIds,
      recoveryWasRequired: recoveryWasRequired,
      centralTaskFailed: centralTaskFailed,
    );

    return CompetencyOutcome(
      competencyId: state.competencyId,
      status: status,
      succeededTaskIds: Set.unmodifiable(succeededRequired),
      unresolvedGapIds: Set.unmodifiable(unresolvedGapIds),
      recoveryWasRequired: recoveryWasRequired,
    );
  }

  CompetencyOutcomeStatus _statusFor({
    required Set<String> requiredTasks,
    required Set<String> succeededRequired,
    required Set<String> unresolvedGapIds,
    required bool recoveryWasRequired,
    required bool centralTaskFailed,
  }) {
    if (centralTaskFailed) {
      return CompetencyOutcomeStatus.notYetAchieved;
    }
    if (succeededRequired.length == requiredTasks.length &&
        unresolvedGapIds.isEmpty) {
      return recoveryWasRequired
          ? CompetencyOutcomeStatus.achievedWithReinforcement
          : CompetencyOutcomeStatus.achieved;
    }
    if (succeededRequired.isNotEmpty) {
      return CompetencyOutcomeStatus.partiallyAchieved;
    }
    return CompetencyOutcomeStatus.notYetAchieved;
  }

  bool _allTasksSucceeded(
    CommunicativeCompetencyDefinition competency,
    CompetencyAssessmentState state,
  ) {
    return competency.assessmentTaskIds.every(state.succeededTaskIds.contains);
  }

  CompetencyGap _gapFor({
    required CommunicativeCompetencyCatalog catalog,
    required CompetencyAssessmentTask task,
    required CompetencyRecoveryMapping mapping,
  }) {
    final micro = catalog.microCompetencies.singleWhere(
      (micro) => micro.microCompetencyId == mapping.microCompetencyId,
    );
    return CompetencyGap(
      gapId:
          '${task.competencyId}::${task.taskId}::${mapping.microCompetencyId}',
      competencyId: task.competencyId,
      assessmentTaskId: task.taskId,
      microCompetencyId: mapping.microCompetencyId,
      reasonCode: mapping.reasonCode,
      sourceModuleId: micro.introducedInModuleId,
      recoveryStepReferences: List.unmodifiable(mapping.recoveryStepReferences),
    );
  }
}
