import '../activity_engine/activity_result.dart';

enum LessonSessionStatus { notStarted, inProgress, completed }

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
  });

  final LessonSessionDecisionType type;
  final LessonSessionReasonCode reasonCode;
  final LessonSessionState updatedState;
  final String? stepId;
  final String? originatingStepId;
  final String? reviewStepId;
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
    final state = LessonSessionState(
      lessonId: lessonId,
      canonicalStepIds: List.unmodifiable(stepIds),
      orderedStepIds: List.unmodifiable(stepIds),
      checkableStepIds: Set.unmodifiable(checkableStepIds),
      remediationAvailableStepIds: Set.unmodifiable(
        remediationAvailableStepIds,
      ),
      reviewStepIdsByStepId: Map.unmodifiable(reviewStepIdsByStepId),
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

    final nextResults = Map<String, ActivityResult>.from(state.resultByStepId);
    nextResults[stepId] = result;

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
      completedStepIds: Set.unmodifiable(nextCompleted),
    );

    if (!isAccepted) {
      final newAttemptCount = nextAttempts[stepId] ?? 0;
      if (newAttemptCount == 1) {
        return LessonSessionDecision(
          type: LessonSessionDecisionType.retryCurrentStep,
          reasonCode: LessonSessionReasonCode.firstIncorrectAttempt,
          updatedState: updatedState,
          stepId: stepId,
        );
      }

      if (newAttemptCount == 3) {
        final reviewDecision = _insertReviewStepIfAvailable(
          state: updatedState,
          originatingStepId: stepId,
        );
        if (reviewDecision != null) {
          return reviewDecision;
        }
      }

      if (state.remediationAvailableStepIds.contains(stepId)) {
        final nextRemediationShown = Set<String>.from(
          updatedState.remediationShownByStepId,
        )..add(stepId);
        final remediationState = updatedState.copyWith(
          remediationShownByStepId: Set.unmodifiable(nextRemediationShown),
        );

        return LessonSessionDecision(
          type: LessonSessionDecisionType.showRemediation,
          reasonCode: LessonSessionReasonCode.remediationRequested,
          updatedState: remediationState,
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
        updatedState: updatedState,
        stepId: stepId,
      );
    }

    return LessonSessionDecision(
      type: LessonSessionDecisionType.showFeedback,
      reasonCode: result.status == ActivityResultStatus.acceptedWithFeedback
          ? LessonSessionReasonCode.acceptedWithCorrection
          : LessonSessionReasonCode.correctAnswerAccepted,
      updatedState: updatedState,
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

    return LessonSessionDecision(
      type: LessonSessionDecisionType.finishLesson,
      reasonCode: LessonSessionReasonCode.lessonFinished,
      updatedState: updatedState,
      stepId: currentStepId,
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
    final updatedState = state.copyWith(
      completedStepIds: Set.unmodifiable(nextCompleted),
      resultByStepId: Map.unmodifiable(nextResults),
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

    final updatedState = state.copyWith(
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
      currentStepIndex: currentIndex + 1,
      currentStepId: insertedReviewStepId,
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
