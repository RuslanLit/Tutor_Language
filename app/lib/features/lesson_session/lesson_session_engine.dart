import '../activity_engine/activity_result.dart';

enum LessonSessionStatus { notStarted, inProgress, completed }

enum StepMasteryStatus { notAssessed, notMastered, fragile, mastered }

enum StepMasteryReasonCode {
  noAssessmentEvidence,
  incorrectEvidenceOnly,
  firstAttemptCorrect,
  acceptedWithCorrection,
  recoveredAfterIncorrect,
  recoveredAfterRemediation,
  recoveredAfterReview,
  confirmationRequired,
  confirmationSucceeded,
  latestSubmissionIncorrect,
}

enum LessonSessionDecisionType {
  showCurrentStep,
  showFeedback,
  showRemediation,
  insertReviewStep,
  retryCurrentStep,
  moveToNextStep,
  moveToPreviousStep,
  finishLesson,
  rejectAction,
}

enum LessonSessionReasonCode {
  sessionStarted,
  emptyStepList,
  informationalStepMayContinue,
  correctAnswerAccepted,
  acceptedWithCorrection,
  firstIncorrectAttempt,
  repeatedIncorrectAttempt,
  remediationRequested,
  remediationUnavailable,
  retryAfterRemediation,
  reviewInserted,
  reviewUnavailable,
  previousStepAvailable,
  alreadyAtFirstStep,
  nextStepLocked,
  lastStepCompleted,
  movedToNextStep,
  finalStepIncomplete,
  lessonFinished,
  lessonAlreadyCompleted,
  unknownStep,
  currentStepRestarted,
}

class LessonSessionStep {
  const LessonSessionStep({
    required this.id,
    required this.isCheckable,
    this.hasRemediation = false,
    this.reviewStepIds = const [],
  });

  final String id;
  final bool isCheckable;
  final bool hasRemediation;
  final List<String> reviewStepIds;
}

class StepMasteryEvidence {
  const StepMasteryEvidence({
    this.attemptCount = 0,
    this.correctSubmissionCount = 0,
    this.acceptedWithCorrectionCount = 0,
    this.incorrectSubmissionCount = 0,
    this.firstAttemptWasCorrect = false,
    this.remediationWasShown = false,
    this.reviewWasRequired = false,
  });

  final int attemptCount;
  final int correctSubmissionCount;
  final int acceptedWithCorrectionCount;
  final int incorrectSubmissionCount;
  final bool firstAttemptWasCorrect;
  final bool remediationWasShown;
  final bool reviewWasRequired;
}

class StepMasteryAssessment {
  const StepMasteryAssessment({
    required this.stepId,
    required this.status,
    required this.reasonCode,
    required this.evidence,
  });

  final String stepId;
  final StepMasteryStatus status;
  final StepMasteryReasonCode reasonCode;
  final StepMasteryEvidence evidence;
}

class LessonMasterySummary {
  const LessonMasterySummary({
    required this.assessedStepCount,
    required this.masteredStepCount,
    required this.fragileStepCount,
    required this.notMasteredStepCount,
    required this.unassessedStepCount,
    required this.masteryRatio,
  });

  final int assessedStepCount;
  final int masteredStepCount;
  final int fragileStepCount;
  final int notMasteredStepCount;
  final int unassessedStepCount;
  final double masteryRatio;
}

enum LessonOutcomeStatus { mastered, completedWithReinforcement, incomplete }

enum LessonOutcomeReasonCode {
  allStepsMastered,
  fragileMasteryPresent,
  lessonNotCompleted,
  noAssessableSteps,
}

class LessonOutcome {
  const LessonOutcome({
    required this.lessonId,
    required this.status,
    required this.summary,
    required this.reasonCode,
  });

  final String lessonId;
  final LessonOutcomeStatus status;
  final LessonMasterySummary summary;
  final LessonOutcomeReasonCode reasonCode;
}

class LessonOutcomePolicy {
  const LessonOutcomePolicy();

  LessonOutcome evaluate({
    required LessonSessionState state,
    required LessonMasterySummary summary,
  }) {
    if (state.status != LessonSessionStatus.completed) {
      return LessonOutcome(
        lessonId: state.lessonId,
        status: LessonOutcomeStatus.incomplete,
        summary: summary,
        reasonCode: LessonOutcomeReasonCode.lessonNotCompleted,
      );
    }

    if (summary.assessedStepCount == 0) {
      return LessonOutcome(
        lessonId: state.lessonId,
        status: LessonOutcomeStatus.completedWithReinforcement,
        summary: summary,
        reasonCode: LessonOutcomeReasonCode.noAssessableSteps,
      );
    }

    final needsReinforcement =
        summary.fragileStepCount > 0 ||
        summary.notMasteredStepCount > 0 ||
        summary.unassessedStepCount > 0;
    if (needsReinforcement) {
      return LessonOutcome(
        lessonId: state.lessonId,
        status: LessonOutcomeStatus.completedWithReinforcement,
        summary: summary,
        reasonCode: LessonOutcomeReasonCode.fragileMasteryPresent,
      );
    }

    return LessonOutcome(
      lessonId: state.lessonId,
      status: LessonOutcomeStatus.mastered,
      summary: summary,
      reasonCode: LessonOutcomeReasonCode.allStepsMastered,
    );
  }
}

class LessonSessionState {
  const LessonSessionState({
    required this.lessonId,
    this.canonicalStepIds = const [],
    this.orderedStepIds = const [],
    this.checkableStepIds = const {},
    this.remediationAvailableStepIds = const {},
    this.remediationShownByStepId = const {},
    this.reviewStepIdsByStepId = const {},
    this.insertedReviewStepIdsByOriginatingStepId = const {},
    this.originatingStepIdByReviewStepId = const {},
    this.authoredReviewStepIdByInsertedStepId = const {},
    this.currentStepId,
    this.currentStepIndex = 0,
    this.completedStepIds = const {},
    this.attemptsByStepId = const {},
    this.resultByStepId = const {},
    this.correctSubmissionCountByStepId = const {},
    this.acceptedWithCorrectionCountByStepId = const {},
    this.incorrectSubmissionCountByStepId = const {},
    this.firstAttemptCorrectStepIds = const {},
    this.masteryAssessmentByStepId = const {},
    this.status = LessonSessionStatus.notStarted,
  });

  final String lessonId;
  final List<String> canonicalStepIds;
  final List<String> orderedStepIds;
  final Set<String> checkableStepIds;
  final Set<String> remediationAvailableStepIds;
  final Set<String> remediationShownByStepId;
  final Map<String, List<String>> reviewStepIdsByStepId;
  final Map<String, String> insertedReviewStepIdsByOriginatingStepId;
  final Map<String, String> originatingStepIdByReviewStepId;
  final Map<String, String> authoredReviewStepIdByInsertedStepId;
  final String? currentStepId;
  final int currentStepIndex;
  final Set<String> completedStepIds;
  final Map<String, int> attemptsByStepId;
  final Map<String, ActivityResult> resultByStepId;
  final Map<String, int> correctSubmissionCountByStepId;
  final Map<String, int> acceptedWithCorrectionCountByStepId;
  final Map<String, int> incorrectSubmissionCountByStepId;
  final Set<String> firstAttemptCorrectStepIds;
  final Map<String, StepMasteryAssessment> masteryAssessmentByStepId;
  final LessonSessionStatus status;

  LessonSessionState copyWith({
    List<String>? canonicalStepIds,
    List<String>? orderedStepIds,
    Set<String>? checkableStepIds,
    Set<String>? remediationAvailableStepIds,
    Set<String>? remediationShownByStepId,
    Map<String, List<String>>? reviewStepIdsByStepId,
    Map<String, String>? insertedReviewStepIdsByOriginatingStepId,
    Map<String, String>? originatingStepIdByReviewStepId,
    Map<String, String>? authoredReviewStepIdByInsertedStepId,
    Object? currentStepId = _unset,
    int? currentStepIndex,
    Set<String>? completedStepIds,
    Map<String, int>? attemptsByStepId,
    Map<String, ActivityResult>? resultByStepId,
    Map<String, int>? correctSubmissionCountByStepId,
    Map<String, int>? acceptedWithCorrectionCountByStepId,
    Map<String, int>? incorrectSubmissionCountByStepId,
    Set<String>? firstAttemptCorrectStepIds,
    Map<String, StepMasteryAssessment>? masteryAssessmentByStepId,
    LessonSessionStatus? status,
  }) {
    return LessonSessionState(
      lessonId: lessonId,
      canonicalStepIds: canonicalStepIds ?? this.canonicalStepIds,
      orderedStepIds: orderedStepIds ?? this.orderedStepIds,
      checkableStepIds: checkableStepIds ?? this.checkableStepIds,
      remediationAvailableStepIds:
          remediationAvailableStepIds ?? this.remediationAvailableStepIds,
      remediationShownByStepId:
          remediationShownByStepId ?? this.remediationShownByStepId,
      reviewStepIdsByStepId:
          reviewStepIdsByStepId ?? this.reviewStepIdsByStepId,
      insertedReviewStepIdsByOriginatingStepId:
          insertedReviewStepIdsByOriginatingStepId ??
          this.insertedReviewStepIdsByOriginatingStepId,
      originatingStepIdByReviewStepId:
          originatingStepIdByReviewStepId ??
          this.originatingStepIdByReviewStepId,
      authoredReviewStepIdByInsertedStepId:
          authoredReviewStepIdByInsertedStepId ??
          this.authoredReviewStepIdByInsertedStepId,
      currentStepId: currentStepId == _unset
          ? this.currentStepId
          : currentStepId as String?,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      completedStepIds: completedStepIds ?? this.completedStepIds,
      attemptsByStepId: attemptsByStepId ?? this.attemptsByStepId,
      resultByStepId: resultByStepId ?? this.resultByStepId,
      correctSubmissionCountByStepId:
          correctSubmissionCountByStepId ?? this.correctSubmissionCountByStepId,
      acceptedWithCorrectionCountByStepId:
          acceptedWithCorrectionCountByStepId ??
          this.acceptedWithCorrectionCountByStepId,
      incorrectSubmissionCountByStepId:
          incorrectSubmissionCountByStepId ??
          this.incorrectSubmissionCountByStepId,
      firstAttemptCorrectStepIds:
          firstAttemptCorrectStepIds ?? this.firstAttemptCorrectStepIds,
      masteryAssessmentByStepId:
          masteryAssessmentByStepId ?? this.masteryAssessmentByStepId,
      status: status ?? this.status,
    );
  }
}

class LessonSessionDecision {
  const LessonSessionDecision({
    required this.type,
    required this.reasonCode,
    required this.updatedState,
    this.stepId,
    this.originatingStepId,
    this.reviewStepId,
    this.masterySummary,
    this.lessonOutcome,
  });

  final LessonSessionDecisionType type;
  final LessonSessionReasonCode reasonCode;
  final LessonSessionState updatedState;
  final String? stepId;
  final String? originatingStepId;
  final String? reviewStepId;
  final LessonMasterySummary? masterySummary;
  final LessonOutcome? lessonOutcome;
}

sealed class LessonSessionEvent {
  const LessonSessionEvent();
}

class StartLessonSession extends LessonSessionEvent {
  const StartLessonSession({required this.lessonId, required this.steps});

  final String lessonId;
  final List<LessonSessionStep> steps;
}

class SubmitLessonStepResult extends LessonSessionEvent {
  const SubmitLessonStepResult({required this.result});

  final ActivityResult result;
}

class RequestPreviousLessonStep extends LessonSessionEvent {
  const RequestPreviousLessonStep();
}

class RequestNextLessonStep extends LessonSessionEvent {
  const RequestNextLessonStep();
}

class FinishLessonSession extends LessonSessionEvent {
  const FinishLessonSession();
}

class RestartCurrentLessonStep extends LessonSessionEvent {
  const RestartCurrentLessonStep();
}

class LessonSessionEngine {
  const LessonSessionEngine();

  LessonSessionDecision handle(
    LessonSessionState state,
    LessonSessionEvent event,
  ) {
    return switch (event) {
      StartLessonSession() => startSession(
        lessonId: event.lessonId,
        steps: event.steps,
      ),
      SubmitLessonStepResult() => submitStepResult(
        state: state,
        result: event.result,
      ),
      RequestPreviousLessonStep() => requestPrevious(state),
      RequestNextLessonStep() => requestNext(state),
      FinishLessonSession() => finishSession(state),
      RestartCurrentLessonStep() => restartCurrentStep(state),
    };
  }

  LessonSessionDecision startSession({
    required String lessonId,
    required List<LessonSessionStep> steps,
  }) {
    if (steps.isEmpty) {
      return LessonSessionDecision(
        type: LessonSessionDecisionType.rejectAction,
        reasonCode: LessonSessionReasonCode.emptyStepList,
        updatedState: LessonSessionState(lessonId: lessonId),
      );
    }

    final stepIds = steps.map((step) => step.id).toList(growable: false);
    final checkableStepIds = steps
        .where((step) => step.isCheckable)
        .map((step) => step.id)
        .toSet();
    final remediationAvailableStepIds = steps
        .where((step) => step.hasRemediation)
        .map((step) => step.id)
        .toSet();
    final knownStepIds = stepIds.toSet();
    final reviewStepIdsByStepId = <String, List<String>>{
      for (final step in steps)
        if (step.reviewStepIds.any(knownStepIds.contains))
          step.id: List.unmodifiable(
            step.reviewStepIds.where(knownStepIds.contains),
          ),
    };
    final masteryAssessmentByStepId = {
      for (final stepId in stepIds) stepId: _notAssessed(stepId),
    };
    final state = LessonSessionState(
      lessonId: lessonId,
      canonicalStepIds: List.unmodifiable(stepIds),
      orderedStepIds: List.unmodifiable(stepIds),
      checkableStepIds: Set.unmodifiable(checkableStepIds),
      remediationAvailableStepIds: Set.unmodifiable(
        remediationAvailableStepIds,
      ),
      reviewStepIdsByStepId: Map.unmodifiable(reviewStepIdsByStepId),
      masteryAssessmentByStepId: Map.unmodifiable(masteryAssessmentByStepId),
      currentStepId: stepIds.first,
      status: LessonSessionStatus.inProgress,
    );

    return LessonSessionDecision(
      type: LessonSessionDecisionType.showCurrentStep,
      reasonCode: LessonSessionReasonCode.sessionStarted,
      updatedState: state,
      stepId: state.currentStepId,
    );
  }

  LessonSessionDecision submitStepResult({
    required LessonSessionState state,
    required ActivityResult result,
  }) {
    if (state.status == LessonSessionStatus.completed) {
      return _rejectCompleted(state);
    }

    final stepId = state.currentStepId;
    if (stepId == null || !state.orderedStepIds.contains(stepId)) {
      return LessonSessionDecision(
        type: LessonSessionDecisionType.rejectAction,
        reasonCode: LessonSessionReasonCode.unknownStep,
        updatedState: state,
        stepId: stepId,
      );
    }

    final nextAttempts = Map<String, int>.from(state.attemptsByStepId);
    nextAttempts[stepId] = (nextAttempts[stepId] ?? 0) + 1;
    final newAttemptCount = nextAttempts[stepId] ?? 0;

    final nextResults = Map<String, ActivityResult>.from(state.resultByStepId);
    nextResults[stepId] = result;

    final nextCorrectCounts = Map<String, int>.from(
      state.correctSubmissionCountByStepId,
    );
    final nextAcceptedWithCorrectionCounts = Map<String, int>.from(
      state.acceptedWithCorrectionCountByStepId,
    );
    final nextIncorrectCounts = Map<String, int>.from(
      state.incorrectSubmissionCountByStepId,
    );
    final nextFirstAttemptCorrect = Set<String>.from(
      state.firstAttemptCorrectStepIds,
    );
    switch (result.status) {
      case ActivityResultStatus.correct:
        nextCorrectCounts[stepId] = (nextCorrectCounts[stepId] ?? 0) + 1;
        if (newAttemptCount == 1) {
          nextFirstAttemptCorrect.add(stepId);
        }
      case ActivityResultStatus.acceptedWithFeedback:
        nextAcceptedWithCorrectionCounts[stepId] =
            (nextAcceptedWithCorrectionCounts[stepId] ?? 0) + 1;
      case ActivityResultStatus.incorrect:
        nextIncorrectCounts[stepId] = (nextIncorrectCounts[stepId] ?? 0) + 1;
      case ActivityResultStatus.unsupported:
        nextIncorrectCounts[stepId] = (nextIncorrectCounts[stepId] ?? 0) + 1;
    }

    final nextCompleted = Set<String>.from(state.completedStepIds);
    final isAccepted = _isAccepted(result);
    if (isAccepted) {
      nextCompleted.add(stepId);
    } else {
      nextCompleted.remove(stepId);
    }

    final updatedState = state.copyWith(
      attemptsByStepId: Map.unmodifiable(nextAttempts),
      resultByStepId: Map.unmodifiable(nextResults),
      correctSubmissionCountByStepId: Map.unmodifiable(nextCorrectCounts),
      acceptedWithCorrectionCountByStepId: Map.unmodifiable(
        nextAcceptedWithCorrectionCounts,
      ),
      incorrectSubmissionCountByStepId: Map.unmodifiable(nextIncorrectCounts),
      firstAttemptCorrectStepIds: Set.unmodifiable(nextFirstAttemptCorrect),
      completedStepIds: Set.unmodifiable(nextCompleted),
    );
    final updatedStateWithMastery = _updateMasteryAssessment(
      updatedState,
      stepId,
    );

    if (!isAccepted) {
      if (newAttemptCount == 1) {
        return LessonSessionDecision(
          type: LessonSessionDecisionType.retryCurrentStep,
          reasonCode: LessonSessionReasonCode.firstIncorrectAttempt,
          updatedState: updatedStateWithMastery,
          stepId: stepId,
        );
      }

      if (newAttemptCount == 3) {
        final reviewDecision = _insertReviewStepIfAvailable(
          state: updatedStateWithMastery,
          originatingStepId: stepId,
        );
        if (reviewDecision != null) {
          return reviewDecision;
        }
      }

      if (state.remediationAvailableStepIds.contains(stepId)) {
        final nextRemediationShown = Set<String>.from(
          updatedStateWithMastery.remediationShownByStepId,
        )..add(stepId);
        final remediationState = updatedStateWithMastery.copyWith(
          remediationShownByStepId: Set.unmodifiable(nextRemediationShown),
        );
        final remediationStateWithMastery = _updateMasteryAssessment(
          remediationState,
          stepId,
        );

        return LessonSessionDecision(
          type: LessonSessionDecisionType.showRemediation,
          reasonCode: LessonSessionReasonCode.remediationRequested,
          updatedState: remediationStateWithMastery,
          stepId: stepId,
        );
      }

      final reasonCode = newAttemptCount == 2
          ? LessonSessionReasonCode.remediationUnavailable
          : newAttemptCount == 3
          ? LessonSessionReasonCode.reviewUnavailable
          : LessonSessionReasonCode.repeatedIncorrectAttempt;

      return LessonSessionDecision(
        type: LessonSessionDecisionType.retryCurrentStep,
        reasonCode: reasonCode,
        updatedState: updatedStateWithMastery,
        stepId: stepId,
      );
    }

    return LessonSessionDecision(
      type: LessonSessionDecisionType.showFeedback,
      reasonCode: result.status == ActivityResultStatus.acceptedWithFeedback
          ? LessonSessionReasonCode.acceptedWithCorrection
          : LessonSessionReasonCode.correctAnswerAccepted,
      updatedState: updatedStateWithMastery,
      stepId: stepId,
    );
  }

  LessonSessionDecision requestPrevious(LessonSessionState state) {
    if (state.status == LessonSessionStatus.completed) {
      return _rejectCompleted(state);
    }

    if (state.currentStepIndex <= 0) {
      return LessonSessionDecision(
        type: LessonSessionDecisionType.rejectAction,
        reasonCode: LessonSessionReasonCode.alreadyAtFirstStep,
        updatedState: state,
        stepId: state.currentStepId,
      );
    }

    final nextIndex = state.currentStepIndex - 1;
    final stepId = state.orderedStepIds[nextIndex];
    final updatedState = state.copyWith(
      currentStepIndex: nextIndex,
      currentStepId: stepId,
    );

    return LessonSessionDecision(
      type: LessonSessionDecisionType.moveToPreviousStep,
      reasonCode: LessonSessionReasonCode.previousStepAvailable,
      updatedState: updatedState,
      stepId: stepId,
    );
  }

  LessonSessionDecision requestNext(LessonSessionState state) {
    if (state.status == LessonSessionStatus.completed) {
      return _rejectCompleted(state);
    }

    if (!_isCurrentStepComplete(state)) {
      return LessonSessionDecision(
        type: LessonSessionDecisionType.rejectAction,
        reasonCode: LessonSessionReasonCode.nextStepLocked,
        updatedState: state,
        stepId: state.currentStepId,
      );
    }

    if (state.currentStepIndex >= state.orderedStepIds.length - 1) {
      return LessonSessionDecision(
        type: LessonSessionDecisionType.rejectAction,
        reasonCode: LessonSessionReasonCode.lastStepCompleted,
        updatedState: state,
        stepId: state.currentStepId,
      );
    }

    final nextIndex = state.currentStepIndex + 1;
    final currentStepId = state.currentStepId;
    final nextCompleted = Set<String>.from(state.completedStepIds);
    if (currentStepId != null) {
      nextCompleted.add(currentStepId);
    }

    final stepId = state.orderedStepIds[nextIndex];
    final updatedState = state.copyWith(
      currentStepIndex: nextIndex,
      currentStepId: stepId,
      completedStepIds: Set.unmodifiable(nextCompleted),
    );

    return LessonSessionDecision(
      type: LessonSessionDecisionType.moveToNextStep,
      reasonCode:
          currentStepId != null &&
              !state.resultByStepId.containsKey(currentStepId)
          ? LessonSessionReasonCode.informationalStepMayContinue
          : LessonSessionReasonCode.movedToNextStep,
      updatedState: updatedState,
      stepId: stepId,
    );
  }

  LessonSessionDecision finishSession(LessonSessionState state) {
    if (state.status == LessonSessionStatus.completed) {
      return _rejectCompleted(state);
    }

    if (!_isCurrentStepComplete(state) ||
        state.currentStepIndex != state.orderedStepIds.length - 1) {
      return LessonSessionDecision(
        type: LessonSessionDecisionType.rejectAction,
        reasonCode: LessonSessionReasonCode.finalStepIncomplete,
        updatedState: state,
        stepId: state.currentStepId,
      );
    }

    final currentStepId = state.currentStepId;
    final nextCompleted = Set<String>.from(state.completedStepIds);
    if (currentStepId != null) {
      nextCompleted.add(currentStepId);
    }

    final updatedState = state.copyWith(
      completedStepIds: Set.unmodifiable(nextCompleted),
      status: LessonSessionStatus.completed,
    );

    final masterySummary = _summarizeMastery(updatedState);
    final lessonOutcome = const LessonOutcomePolicy().evaluate(
      state: updatedState,
      summary: masterySummary,
    );

    return LessonSessionDecision(
      type: LessonSessionDecisionType.finishLesson,
      reasonCode: LessonSessionReasonCode.lessonFinished,
      updatedState: updatedState,
      stepId: currentStepId,
      masterySummary: masterySummary,
      lessonOutcome: lessonOutcome,
    );
  }

  LessonSessionDecision restartCurrentStep(LessonSessionState state) {
    if (state.status == LessonSessionStatus.completed) {
      return _rejectCompleted(state);
    }

    final stepId = state.currentStepId;
    if (stepId == null) {
      return LessonSessionDecision(
        type: LessonSessionDecisionType.rejectAction,
        reasonCode: LessonSessionReasonCode.unknownStep,
        updatedState: state,
      );
    }

    final nextCompleted = Set<String>.from(state.completedStepIds)
      ..remove(stepId);
    final nextResults = Map<String, ActivityResult>.from(state.resultByStepId)
      ..remove(stepId);
    final updatedState = _updateMasteryAssessment(
      state.copyWith(
        completedStepIds: Set.unmodifiable(nextCompleted),
        resultByStepId: Map.unmodifiable(nextResults),
      ),
      stepId,
    );

    final reasonCode = state.remediationShownByStepId.contains(stepId)
        ? LessonSessionReasonCode.retryAfterRemediation
        : LessonSessionReasonCode.currentStepRestarted;

    return LessonSessionDecision(
      type: LessonSessionDecisionType.showCurrentStep,
      reasonCode: reasonCode,
      updatedState: updatedState,
      stepId: stepId,
    );
  }

  bool _isCurrentStepComplete(LessonSessionState state) {
    final stepId = state.currentStepId;
    if (stepId == null) {
      return false;
    }

    if (!state.checkableStepIds.contains(stepId)) {
      return true;
    }

    return state.completedStepIds.contains(stepId);
  }

  LessonSessionState _updateMasteryAssessment(
    LessonSessionState state,
    String stepId,
  ) {
    final nextAssessments = Map<String, StepMasteryAssessment>.from(
      state.masteryAssessmentByStepId,
    )..[stepId] = _assessStepMastery(state, stepId);

    return state.copyWith(
      masteryAssessmentByStepId: Map.unmodifiable(nextAssessments),
    );
  }

  StepMasteryAssessment _assessStepMastery(
    LessonSessionState state,
    String stepId,
  ) {
    final evidence = _masteryEvidenceFor(state, stepId);
    final latestResult = state.resultByStepId[stepId];

    if (evidence.attemptCount == 0 && latestResult == null) {
      return _notAssessed(stepId);
    }

    if (latestResult == null) {
      return StepMasteryAssessment(
        stepId: stepId,
        status: StepMasteryStatus.notMastered,
        reasonCode: StepMasteryReasonCode.latestSubmissionIncorrect,
        evidence: evidence,
      );
    }

    if (latestResult.status == ActivityResultStatus.incorrect ||
        latestResult.status == ActivityResultStatus.unsupported) {
      final reasonCode =
          evidence.correctSubmissionCount == 0 &&
              evidence.acceptedWithCorrectionCount == 0
          ? StepMasteryReasonCode.incorrectEvidenceOnly
          : StepMasteryReasonCode.latestSubmissionIncorrect;
      return StepMasteryAssessment(
        stepId: stepId,
        status: StepMasteryStatus.notMastered,
        reasonCode: reasonCode,
        evidence: evidence,
      );
    }

    if (latestResult.status == ActivityResultStatus.acceptedWithFeedback) {
      return StepMasteryAssessment(
        stepId: stepId,
        status: StepMasteryStatus.fragile,
        reasonCode: StepMasteryReasonCode.acceptedWithCorrection,
        evidence: evidence,
      );
    }

    if (evidence.firstAttemptWasCorrect) {
      return StepMasteryAssessment(
        stepId: stepId,
        status: StepMasteryStatus.mastered,
        reasonCode: StepMasteryReasonCode.firstAttemptCorrect,
        evidence: evidence,
      );
    }

    final needsConfirmation =
        evidence.incorrectSubmissionCount > 0 ||
        evidence.acceptedWithCorrectionCount > 0 ||
        evidence.remediationWasShown ||
        evidence.reviewWasRequired;
    if (needsConfirmation && evidence.correctSubmissionCount >= 2) {
      return StepMasteryAssessment(
        stepId: stepId,
        status: StepMasteryStatus.mastered,
        reasonCode: StepMasteryReasonCode.confirmationSucceeded,
        evidence: evidence,
      );
    }

    if (evidence.reviewWasRequired) {
      return StepMasteryAssessment(
        stepId: stepId,
        status: StepMasteryStatus.fragile,
        reasonCode: StepMasteryReasonCode.recoveredAfterReview,
        evidence: evidence,
      );
    }

    if (evidence.remediationWasShown) {
      return StepMasteryAssessment(
        stepId: stepId,
        status: StepMasteryStatus.fragile,
        reasonCode: StepMasteryReasonCode.recoveredAfterRemediation,
        evidence: evidence,
      );
    }

    if (evidence.incorrectSubmissionCount > 0) {
      return StepMasteryAssessment(
        stepId: stepId,
        status: StepMasteryStatus.fragile,
        reasonCode: StepMasteryReasonCode.recoveredAfterIncorrect,
        evidence: evidence,
      );
    }

    return StepMasteryAssessment(
      stepId: stepId,
      status: StepMasteryStatus.fragile,
      reasonCode: StepMasteryReasonCode.confirmationRequired,
      evidence: evidence,
    );
  }

  StepMasteryEvidence _masteryEvidenceFor(
    LessonSessionState state,
    String stepId,
  ) {
    return StepMasteryEvidence(
      attemptCount: state.attemptsByStepId[stepId] ?? 0,
      correctSubmissionCount: state.correctSubmissionCountByStepId[stepId] ?? 0,
      acceptedWithCorrectionCount:
          state.acceptedWithCorrectionCountByStepId[stepId] ?? 0,
      incorrectSubmissionCount:
          state.incorrectSubmissionCountByStepId[stepId] ?? 0,
      firstAttemptWasCorrect: state.firstAttemptCorrectStepIds.contains(stepId),
      remediationWasShown: state.remediationShownByStepId.contains(stepId),
      reviewWasRequired: state.insertedReviewStepIdsByOriginatingStepId
          .containsKey(stepId),
    );
  }

  StepMasteryAssessment _notAssessed(String stepId) {
    return StepMasteryAssessment(
      stepId: stepId,
      status: StepMasteryStatus.notAssessed,
      reasonCode: StepMasteryReasonCode.noAssessmentEvidence,
      evidence: const StepMasteryEvidence(),
    );
  }

  LessonMasterySummary _summarizeMastery(LessonSessionState state) {
    final canonicalCheckableStepIds = state.canonicalStepIds
        .where(state.checkableStepIds.contains)
        .toList(growable: false);
    var mastered = 0;
    var fragile = 0;
    var notMastered = 0;
    var unassessed = 0;

    for (final stepId in canonicalCheckableStepIds) {
      final status =
          state.masteryAssessmentByStepId[stepId]?.status ??
          StepMasteryStatus.notAssessed;
      switch (status) {
        case StepMasteryStatus.mastered:
          mastered += 1;
        case StepMasteryStatus.fragile:
          fragile += 1;
        case StepMasteryStatus.notMastered:
          notMastered += 1;
        case StepMasteryStatus.notAssessed:
          unassessed += 1;
      }
    }

    final assessed = mastered + fragile + notMastered;
    final denominator = canonicalCheckableStepIds.length;
    return LessonMasterySummary(
      assessedStepCount: assessed,
      masteredStepCount: mastered,
      fragileStepCount: fragile,
      notMasteredStepCount: notMastered,
      unassessedStepCount: unassessed,
      masteryRatio: denominator == 0 ? 0 : mastered / denominator,
    );
  }

  bool _isAccepted(ActivityResult result) {
    return result.status == ActivityResultStatus.correct ||
        result.status == ActivityResultStatus.acceptedWithFeedback ||
        result.isCorrect;
  }

  LessonSessionDecision? _insertReviewStepIfAvailable({
    required LessonSessionState state,
    required String originatingStepId,
  }) {
    if (state.insertedReviewStepIdsByOriginatingStepId.containsKey(
      originatingStepId,
    )) {
      return null;
    }

    final reviewSourceStepIds =
        state.reviewStepIdsByStepId[originatingStepId] ?? const [];
    if (reviewSourceStepIds.isEmpty) {
      return null;
    }

    final reviewSourceStepId = reviewSourceStepIds.first;
    if (!state.canonicalStepIds.contains(reviewSourceStepId)) {
      return null;
    }

    final currentIndex = state.currentStepIndex;
    if (currentIndex < 0 || currentIndex >= state.orderedStepIds.length) {
      return null;
    }

    final insertedReviewStepId = lessonSessionReviewStepId(
      originatingStepId: originatingStepId,
      reviewStepId: reviewSourceStepId,
    );
    final nextOrderedStepIds = [
      ...state.orderedStepIds.take(currentIndex + 1),
      insertedReviewStepId,
      originatingStepId,
      ...state.orderedStepIds.skip(currentIndex + 1),
    ];
    final nextCheckableStepIds = Set<String>.from(state.checkableStepIds);
    if (state.checkableStepIds.contains(reviewSourceStepId)) {
      nextCheckableStepIds.add(insertedReviewStepId);
    }

    final nextRemediationAvailable = Set<String>.from(
      state.remediationAvailableStepIds,
    );
    if (state.remediationAvailableStepIds.contains(reviewSourceStepId)) {
      nextRemediationAvailable.add(insertedReviewStepId);
    }

    final nextReviewStepIdsByStepId = Map<String, List<String>>.from(
      state.reviewStepIdsByStepId,
    );
    final nestedReviewStepIds = state.reviewStepIdsByStepId[reviewSourceStepId];
    if (nestedReviewStepIds != null) {
      nextReviewStepIdsByStepId[insertedReviewStepId] = nestedReviewStepIds;
    }

    final nextInsertedByOriginating = Map<String, String>.from(
      state.insertedReviewStepIdsByOriginatingStepId,
    )..[originatingStepId] = insertedReviewStepId;
    final nextOriginByReview = Map<String, String>.from(
      state.originatingStepIdByReviewStepId,
    )..[insertedReviewStepId] = originatingStepId;
    final nextAuthoredByInserted = Map<String, String>.from(
      state.authoredReviewStepIdByInsertedStepId,
    )..[insertedReviewStepId] = reviewSourceStepId;
    final nextMasteryAssessments = Map<String, StepMasteryAssessment>.from(
      state.masteryAssessmentByStepId,
    )..[insertedReviewStepId] = _notAssessed(insertedReviewStepId);

    final expandedState = state.copyWith(
      orderedStepIds: List.unmodifiable(nextOrderedStepIds),
      checkableStepIds: Set.unmodifiable(nextCheckableStepIds),
      remediationAvailableStepIds: Set.unmodifiable(nextRemediationAvailable),
      reviewStepIdsByStepId: Map.unmodifiable(nextReviewStepIdsByStepId),
      insertedReviewStepIdsByOriginatingStepId: Map.unmodifiable(
        nextInsertedByOriginating,
      ),
      originatingStepIdByReviewStepId: Map.unmodifiable(nextOriginByReview),
      authoredReviewStepIdByInsertedStepId: Map.unmodifiable(
        nextAuthoredByInserted,
      ),
      masteryAssessmentByStepId: Map.unmodifiable(nextMasteryAssessments),
      currentStepIndex: currentIndex + 1,
      currentStepId: insertedReviewStepId,
    );
    final updatedState = _updateMasteryAssessment(
      expandedState,
      originatingStepId,
    );

    return LessonSessionDecision(
      type: LessonSessionDecisionType.insertReviewStep,
      reasonCode: LessonSessionReasonCode.reviewInserted,
      updatedState: updatedState,
      stepId: insertedReviewStepId,
      originatingStepId: originatingStepId,
      reviewStepId: reviewSourceStepId,
    );
  }

  LessonSessionDecision _rejectCompleted(LessonSessionState state) {
    return LessonSessionDecision(
      type: LessonSessionDecisionType.rejectAction,
      reasonCode: LessonSessionReasonCode.lessonAlreadyCompleted,
      updatedState: state,
      stepId: state.currentStepId,
    );
  }
}

String lessonSessionReviewStepId({
  required String originatingStepId,
  required String reviewStepId,
}) {
  return 'review::${Uri.encodeComponent(originatingStepId)}::'
      '${Uri.encodeComponent(reviewStepId)}';
}

const _unset = Object();
