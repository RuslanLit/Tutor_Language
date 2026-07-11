import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/features/activity_engine/activity_result.dart';
import 'package:tutor_language/features/lesson_session/lesson_session_engine.dart';

void main() {
  const engine = LessonSessionEngine();
  const lessonId = 'lesson.session';
  const infoStep = LessonSessionStep(id: 'step.info', isCheckable: false);
  const practiceStep = LessonSessionStep(
    id: 'step.practice',
    isCheckable: true,
  );
  const remediationStep = LessonSessionStep(
    id: 'step.remediation',
    isCheckable: true,
    hasRemediation: true,
  );
  const reviewOriginStep = LessonSessionStep(
    id: 'step.review_origin',
    isCheckable: true,
    hasRemediation: true,
    reviewStepIds: ['step.review'],
  );
  const reviewStep = LessonSessionStep(id: 'step.review', isCheckable: true);
  const finalPracticeStep = LessonSessionStep(
    id: 'step.final',
    isCheckable: true,
  );

  test('empty step list returns typed rejection', () {
    final decision = engine.startSession(lessonId: lessonId, steps: const []);

    expect(decision.type, LessonSessionDecisionType.rejectAction);
    expect(decision.reasonCode, LessonSessionReasonCode.emptyStepList);
    expect(decision.updatedState.status, LessonSessionStatus.notStarted);
  });

  test('non-empty lesson starts on first step with zero attempts', () {
    final decision = engine.startSession(
      lessonId: lessonId,
      steps: const [infoStep, practiceStep],
    );

    expect(decision.type, LessonSessionDecisionType.showCurrentStep);
    expect(decision.reasonCode, LessonSessionReasonCode.sessionStarted);
    expect(decision.updatedState.lessonId, lessonId);
    expect(decision.updatedState.currentStepId, infoStep.id);
    expect(decision.updatedState.currentStepIndex, 0);
    expect(decision.updatedState.attemptsByStepId, isEmpty);
    expect(decision.updatedState.status, LessonSessionStatus.inProgress);
    expect(
      decision.updatedState.masteryAssessmentByStepId[practiceStep.id]?.status,
      StepMasteryStatus.notAssessed,
    );
    expect(
      decision.updatedState.masteryAssessmentByStepId[infoStep.id]?.status,
      StepMasteryStatus.notAssessed,
    );
  });

  test('informational step permits next without incrementing attempts', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [infoStep, practiceStep])
        .updatedState;

    final decision = engine.requestNext(state);

    expect(decision.type, LessonSessionDecisionType.moveToNextStep);
    expect(
      decision.reasonCode,
      LessonSessionReasonCode.informationalStepMayContinue,
    );
    expect(decision.updatedState.currentStepId, practiceStep.id);
    expect(decision.updatedState.completedStepIds, contains(infoStep.id));
    expect(decision.updatedState.attemptsByStepId, isEmpty);
  });

  test('final informational step permits finish', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [infoStep])
        .updatedState;

    final decision = engine.finishSession(state);

    expect(decision.type, LessonSessionDecisionType.finishLesson);
    expect(decision.reasonCode, LessonSessionReasonCode.lessonFinished);
    expect(decision.updatedState.status, LessonSessionStatus.completed);
    expect(decision.updatedState.completedStepIds, contains(infoStep.id));
  });

  test('correct submission increments attempts and permits progression', () {
    final state = engine
        .startSession(
          lessonId: lessonId,
          steps: const [practiceStep, finalPracticeStep],
        )
        .updatedState;

    final submitDecision = engine.submitStepResult(
      state: state,
      result: _correctResult,
    );
    final nextDecision = engine.requestNext(submitDecision.updatedState);

    expect(submitDecision.type, LessonSessionDecisionType.showFeedback);
    expect(
      submitDecision.reasonCode,
      LessonSessionReasonCode.correctAnswerAccepted,
    );
    expect(submitDecision.updatedState.attemptsByStepId[practiceStep.id], 1);
    expect(
      submitDecision.updatedState.completedStepIds,
      contains(practiceStep.id),
    );
    expect(nextDecision.type, LessonSessionDecisionType.moveToNextStep);
    expect(
      submitDecision
          .updatedState
          .masteryAssessmentByStepId[practiceStep.id]
          ?.status,
      StepMasteryStatus.mastered,
    );
    expect(
      submitDecision
          .updatedState
          .masteryAssessmentByStepId[practiceStep.id]
          ?.reasonCode,
      StepMasteryReasonCode.firstAttemptCorrect,
    );
  });

  test('accepted with correction is complete but remains distinct', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [practiceStep])
        .updatedState;

    final decision = engine.submitStepResult(
      state: state,
      result: _acceptedWithFeedbackResult,
    );

    expect(decision.type, LessonSessionDecisionType.showFeedback);
    expect(decision.reasonCode, LessonSessionReasonCode.acceptedWithCorrection);
    expect(decision.updatedState.completedStepIds, contains(practiceStep.id));
    expect(
      decision.updatedState.resultByStepId[practiceStep.id]?.status,
      ActivityResultStatus.acceptedWithFeedback,
    );
    expect(
      decision.updatedState.masteryAssessmentByStepId[practiceStep.id]?.status,
      StepMasteryStatus.fragile,
    );
    expect(
      decision
          .updatedState
          .masteryAssessmentByStepId[practiceStep.id]
          ?.reasonCode,
      StepMasteryReasonCode.acceptedWithCorrection,
    );
  });

  test('first incorrect submission increments attempts and retries only', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [practiceStep])
        .updatedState;

    final submitDecision = engine.submitStepResult(
      state: state,
      result: _incorrectResult,
    );
    final nextDecision = engine.requestNext(submitDecision.updatedState);

    expect(submitDecision.type, LessonSessionDecisionType.retryCurrentStep);
    expect(
      submitDecision.reasonCode,
      LessonSessionReasonCode.firstIncorrectAttempt,
    );
    expect(submitDecision.updatedState.attemptsByStepId[practiceStep.id], 1);
    expect(submitDecision.updatedState.remediationShownByStepId, isEmpty);
    expect(
      submitDecision
          .updatedState
          .masteryAssessmentByStepId[practiceStep.id]
          ?.status,
      StepMasteryStatus.notMastered,
    );
    expect(
      submitDecision
          .updatedState
          .masteryAssessmentByStepId[practiceStep.id]
          ?.reasonCode,
      StepMasteryReasonCode.incorrectEvidenceOnly,
    );
    expect(
      submitDecision.updatedState.completedStepIds,
      isNot(contains(practiceStep.id)),
    );
    expect(nextDecision.type, LessonSessionDecisionType.rejectAction);
    expect(nextDecision.reasonCode, LessonSessionReasonCode.nextStepLocked);
  });

  test('incorrect then correct completes but remains fragile', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [practiceStep])
        .updatedState;
    final incorrect = engine
        .submitStepResult(state: state, result: _incorrectResult)
        .updatedState;

    final decision = engine.submitStepResult(
      state: incorrect,
      result: _correctResult,
    );

    expect(decision.type, LessonSessionDecisionType.showFeedback);
    expect(decision.updatedState.completedStepIds, contains(practiceStep.id));
    expect(
      decision.updatedState.masteryAssessmentByStepId[practiceStep.id]?.status,
      StepMasteryStatus.fragile,
    );
    expect(
      decision
          .updatedState
          .masteryAssessmentByStepId[practiceStep.id]
          ?.reasonCode,
      StepMasteryReasonCode.recoveredAfterIncorrect,
    );
  });

  test(
    'fragile step confirmed by another correct submission becomes mastered',
    () {
      final state = engine
          .startSession(lessonId: lessonId, steps: const [practiceStep])
          .updatedState;
      final incorrect = engine
          .submitStepResult(state: state, result: _incorrectResult)
          .updatedState;
      final fragile = engine
          .submitStepResult(state: incorrect, result: _correctResult)
          .updatedState;

      final confirmed = engine.submitStepResult(
        state: fragile,
        result: _correctResult,
      );

      expect(
        confirmed
            .updatedState
            .masteryAssessmentByStepId[practiceStep.id]
            ?.status,
        StepMasteryStatus.mastered,
      );
      expect(
        confirmed
            .updatedState
            .masteryAssessmentByStepId[practiceStep.id]
            ?.reasonCode,
        StepMasteryReasonCode.confirmationSucceeded,
      );
      expect(confirmed.updatedState.attemptsByStepId[practiceStep.id], 3);
    },
  );

  test('accepted-with-correction confirmation does not produce mastery', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [practiceStep])
        .updatedState;
    final accepted = engine
        .submitStepResult(state: state, result: _acceptedWithFeedbackResult)
        .updatedState;

    final acceptedAgain = engine.submitStepResult(
      state: accepted,
      result: _acceptedWithFeedbackResult,
    );

    expect(
      acceptedAgain
          .updatedState
          .masteryAssessmentByStepId[practiceStep.id]
          ?.status,
      StepMasteryStatus.fragile,
    );
    expect(
      acceptedAgain
          .updatedState
          .masteryAssessmentByStepId[practiceStep.id]
          ?.reasonCode,
      StepMasteryReasonCode.acceptedWithCorrection,
    );
  });

  test('second incorrect with remediation available shows remediation', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [remediationStep])
        .updatedState;
    final firstIncorrect = engine
        .submitStepResult(state: state, result: _incorrectResult)
        .updatedState;

    final decision = engine.submitStepResult(
      state: firstIncorrect,
      result: _incorrectResult,
    );

    expect(decision.type, LessonSessionDecisionType.showRemediation);
    expect(decision.reasonCode, LessonSessionReasonCode.remediationRequested);
    expect(decision.stepId, remediationStep.id);
    expect(decision.updatedState.attemptsByStepId[remediationStep.id], 2);
    expect(
      decision.updatedState.remediationShownByStepId,
      contains(remediationStep.id),
    );
    expect(
      decision.updatedState.completedStepIds,
      isNot(contains(remediationStep.id)),
    );
  });

  test('second incorrect without remediation remains retry', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [practiceStep])
        .updatedState;
    final firstIncorrect = engine
        .submitStepResult(state: state, result: _incorrectResult)
        .updatedState;

    final decision = engine.submitStepResult(
      state: firstIncorrect,
      result: _incorrectResult,
    );

    expect(decision.type, LessonSessionDecisionType.retryCurrentStep);
    expect(decision.reasonCode, LessonSessionReasonCode.remediationUnavailable);
    expect(decision.updatedState.attemptsByStepId[practiceStep.id], 2);
    expect(decision.updatedState.remediationShownByStepId, isEmpty);
  });

  test(
    'third incorrect can request remediation again without duplicate state',
    () {
      final state = engine
          .startSession(lessonId: lessonId, steps: const [remediationStep])
          .updatedState;
      final firstIncorrect = engine
          .submitStepResult(state: state, result: _incorrectResult)
          .updatedState;
      final remediationShown = engine
          .submitStepResult(state: firstIncorrect, result: _incorrectResult)
          .updatedState;

      final decision = engine.submitStepResult(
        state: remediationShown,
        result: _incorrectResult,
      );

      expect(decision.type, LessonSessionDecisionType.showRemediation);
      expect(decision.reasonCode, LessonSessionReasonCode.remediationRequested);
      expect(decision.updatedState.attemptsByStepId[remediationStep.id], 3);
      expect(
        decision.updatedState.remediationShownByStepId
            .where((stepId) => stepId == remediationStep.id)
            .length,
        1,
      );
    },
  );

  test(
    'third incorrect without remediation or review reports review unavailable',
    () {
      final state = engine
          .startSession(lessonId: lessonId, steps: const [practiceStep])
          .updatedState;
      final firstIncorrect = engine
          .submitStepResult(state: state, result: _incorrectResult)
          .updatedState;
      final secondIncorrect = engine
          .submitStepResult(state: firstIncorrect, result: _incorrectResult)
          .updatedState;

      final decision = engine.submitStepResult(
        state: secondIncorrect,
        result: _incorrectResult,
      );

      expect(decision.type, LessonSessionDecisionType.retryCurrentStep);
      expect(decision.reasonCode, LessonSessionReasonCode.reviewUnavailable);
      expect(decision.updatedState.attemptsByStepId[practiceStep.id], 3);
    },
  );

  test('accepted with correction bypasses remediation policy', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [remediationStep])
        .updatedState;

    final decision = engine.submitStepResult(
      state: state,
      result: _acceptedWithFeedbackResult,
    );

    expect(decision.type, LessonSessionDecisionType.showFeedback);
    expect(decision.reasonCode, LessonSessionReasonCode.acceptedWithCorrection);
    expect(
      decision.updatedState.completedStepIds,
      contains(remediationStep.id),
    );
    expect(decision.updatedState.remediationShownByStepId, isEmpty);
  });

  test('correct answer after remediation progresses normally', () {
    final state = engine
        .startSession(
          lessonId: lessonId,
          steps: const [remediationStep, finalPracticeStep],
        )
        .updatedState;
    final firstIncorrect = engine
        .submitStepResult(state: state, result: _incorrectResult)
        .updatedState;
    final remediationShown = engine
        .submitStepResult(state: firstIncorrect, result: _incorrectResult)
        .updatedState;

    final correctDecision = engine.submitStepResult(
      state: remediationShown,
      result: _correctResult,
    );
    final nextDecision = engine.requestNext(correctDecision.updatedState);

    expect(correctDecision.type, LessonSessionDecisionType.showFeedback);
    expect(
      correctDecision.reasonCode,
      LessonSessionReasonCode.correctAnswerAccepted,
    );
    expect(
      correctDecision.updatedState.attemptsByStepId[remediationStep.id],
      3,
    );
    expect(
      correctDecision.updatedState.completedStepIds,
      contains(remediationStep.id),
    );
    expect(nextDecision.type, LessonSessionDecisionType.moveToNextStep);
    expect(
      correctDecision
          .updatedState
          .masteryAssessmentByStepId[remediationStep.id]
          ?.status,
      StepMasteryStatus.fragile,
    );
    expect(
      correctDecision
          .updatedState
          .masteryAssessmentByStepId[remediationStep.id]
          ?.reasonCode,
      StepMasteryReasonCode.recoveredAfterRemediation,
    );
  });

  test(
    'restart after remediation does not increment attempts or complete step',
    () {
      final state = engine
          .startSession(lessonId: lessonId, steps: const [remediationStep])
          .updatedState;
      final firstIncorrect = engine
          .submitStepResult(state: state, result: _incorrectResult)
          .updatedState;
      final remediationShown = engine
          .submitStepResult(state: firstIncorrect, result: _incorrectResult)
          .updatedState;

      final decision = engine.restartCurrentStep(remediationShown);

      expect(decision.type, LessonSessionDecisionType.showCurrentStep);
      expect(
        decision.reasonCode,
        LessonSessionReasonCode.retryAfterRemediation,
      );
      expect(decision.updatedState.attemptsByStepId[remediationStep.id], 2);
      expect(
        decision.updatedState.completedStepIds,
        isNot(contains(remediationStep.id)),
      );
      expect(
        decision.updatedState.remediationShownByStepId,
        contains(remediationStep.id),
      );
    },
  );

  test('remediation state belongs to one step and survives navigation', () {
    final started = engine
        .startSession(
          lessonId: lessonId,
          steps: const [infoStep, remediationStep, finalPracticeStep],
        )
        .updatedState;
    final onRemediationStep = engine.requestNext(started).updatedState;
    final firstIncorrect = engine
        .submitStepResult(state: onRemediationStep, result: _incorrectResult)
        .updatedState;
    final remediationShown = engine
        .submitStepResult(state: firstIncorrect, result: _incorrectResult)
        .updatedState;
    final completed = engine
        .submitStepResult(state: remediationShown, result: _correctResult)
        .updatedState;
    final onFinal = engine.requestNext(completed).updatedState;

    final back = engine.requestPrevious(onFinal);
    final forward = engine.requestNext(back.updatedState);

    expect(
      remediationShown.remediationShownByStepId,
      contains(remediationStep.id),
    );
    expect(
      remediationShown.remediationShownByStepId,
      isNot(contains(finalPracticeStep.id)),
    );
    expect(
      back.updatedState.remediationShownByStepId,
      contains(remediationStep.id),
    );
    expect(forward.updatedState.currentStepId, finalPracticeStep.id);
  });

  test('third incorrect inserts authored review step once', () {
    final state = engine
        .startSession(
          lessonId: lessonId,
          steps: const [reviewOriginStep, reviewStep, finalPracticeStep],
        )
        .updatedState;
    final firstIncorrect = engine
        .submitStepResult(state: state, result: _incorrectResult)
        .updatedState;
    final remediationShown = engine
        .submitStepResult(state: firstIncorrect, result: _incorrectResult)
        .updatedState;

    final decision = engine.submitStepResult(
      state: remediationShown,
      result: _incorrectResult,
    );
    final insertedReviewId = lessonSessionReviewStepId(
      originatingStepId: reviewOriginStep.id,
      reviewStepId: reviewStep.id,
    );

    expect(decision.type, LessonSessionDecisionType.insertReviewStep);
    expect(decision.reasonCode, LessonSessionReasonCode.reviewInserted);
    expect(decision.stepId, insertedReviewId);
    expect(decision.originatingStepId, reviewOriginStep.id);
    expect(decision.reviewStepId, reviewStep.id);
    expect(decision.updatedState.canonicalStepIds, [
      reviewOriginStep.id,
      reviewStep.id,
      finalPracticeStep.id,
    ]);
    expect(decision.updatedState.orderedStepIds, [
      reviewOriginStep.id,
      insertedReviewId,
      reviewOriginStep.id,
      reviewStep.id,
      finalPracticeStep.id,
    ]);
    expect(decision.updatedState.currentStepId, insertedReviewId);
    expect(decision.updatedState.currentStepIndex, 1);
    expect(
      decision.updatedState.originatingStepIdByReviewStepId[insertedReviewId],
      reviewOriginStep.id,
    );
    expect(
      decision
          .updatedState
          .authoredReviewStepIdByInsertedStepId[insertedReviewId],
      reviewStep.id,
    );
    expect(decision.updatedState.checkableStepIds, contains(insertedReviewId));
    expect(
      decision
          .updatedState
          .masteryAssessmentByStepId[reviewOriginStep.id]
          ?.status,
      StepMasteryStatus.notMastered,
    );
    expect(
      decision.updatedState.masteryAssessmentByStepId[insertedReviewId]?.status,
      StepMasteryStatus.notAssessed,
    );
  });

  test('review completion returns to original step without completing it', () {
    final state = engine
        .startSession(
          lessonId: lessonId,
          steps: const [reviewOriginStep, reviewStep, finalPracticeStep],
        )
        .updatedState;
    final firstIncorrect = engine
        .submitStepResult(state: state, result: _incorrectResult)
        .updatedState;
    final remediationShown = engine
        .submitStepResult(state: firstIncorrect, result: _incorrectResult)
        .updatedState;
    final reviewInserted = engine
        .submitStepResult(state: remediationShown, result: _incorrectResult)
        .updatedState;

    final reviewCompleted = engine
        .submitStepResult(state: reviewInserted, result: _correctResult)
        .updatedState;
    final returnedToOrigin = engine.requestNext(reviewCompleted);

    expect(returnedToOrigin.type, LessonSessionDecisionType.moveToNextStep);
    expect(returnedToOrigin.updatedState.currentStepId, reviewOriginStep.id);
    expect(returnedToOrigin.updatedState.currentStepIndex, 2);
    expect(
      returnedToOrigin.updatedState.completedStepIds,
      contains(reviewInserted.currentStepId),
    );
    expect(
      returnedToOrigin.updatedState.completedStepIds,
      isNot(contains(reviewOriginStep.id)),
    );
    expect(
      engine.requestNext(returnedToOrigin.updatedState).reasonCode,
      LessonSessionReasonCode.nextStepLocked,
    );
    expect(
      returnedToOrigin
          .updatedState
          .masteryAssessmentByStepId[reviewOriginStep.id]
          ?.status,
      StepMasteryStatus.notMastered,
    );
    expect(
      returnedToOrigin
          .updatedState
          .masteryAssessmentByStepId[reviewInserted.currentStepId]
          ?.status,
      StepMasteryStatus.mastered,
    );
  });

  test('origin correct after inserted review is complete but fragile', () {
    final state = engine
        .startSession(
          lessonId: lessonId,
          steps: const [reviewOriginStep, reviewStep, finalPracticeStep],
        )
        .updatedState;
    final firstIncorrect = engine
        .submitStepResult(state: state, result: _incorrectResult)
        .updatedState;
    final remediationShown = engine
        .submitStepResult(state: firstIncorrect, result: _incorrectResult)
        .updatedState;
    final reviewInserted = engine
        .submitStepResult(state: remediationShown, result: _incorrectResult)
        .updatedState;
    final reviewCompleted = engine
        .submitStepResult(state: reviewInserted, result: _correctResult)
        .updatedState;
    final returnedToOrigin = engine.requestNext(reviewCompleted).updatedState;

    final originCorrect = engine.submitStepResult(
      state: returnedToOrigin,
      result: _correctResult,
    );

    expect(
      originCorrect.updatedState.completedStepIds,
      contains(reviewOriginStep.id),
    );
    expect(
      originCorrect
          .updatedState
          .masteryAssessmentByStepId[reviewOriginStep.id]
          ?.status,
      StepMasteryStatus.fragile,
    );
    expect(
      originCorrect
          .updatedState
          .masteryAssessmentByStepId[reviewOriginStep.id]
          ?.reasonCode,
      StepMasteryReasonCode.recoveredAfterReview,
    );
  });

  test('review insertion is not repeated for the same origin step', () {
    final state = engine
        .startSession(
          lessonId: lessonId,
          steps: const [reviewOriginStep, reviewStep],
        )
        .updatedState;
    final firstIncorrect = engine
        .submitStepResult(state: state, result: _incorrectResult)
        .updatedState;
    final remediationShown = engine
        .submitStepResult(state: firstIncorrect, result: _incorrectResult)
        .updatedState;
    final reviewInserted = engine
        .submitStepResult(state: remediationShown, result: _incorrectResult)
        .updatedState;
    final reviewCompleted = engine
        .submitStepResult(state: reviewInserted, result: _correctResult)
        .updatedState;
    final returnedToOrigin = engine.requestNext(reviewCompleted).updatedState;

    final decision = engine.submitStepResult(
      state: returnedToOrigin,
      result: _incorrectResult,
    );

    expect(decision.type, LessonSessionDecisionType.showRemediation);
    expect(decision.reasonCode, LessonSessionReasonCode.remediationRequested);
    expect(
      decision.updatedState.insertedReviewStepIdsByOriginatingStepId,
      hasLength(1),
    );
    expect(
      decision.updatedState.orderedStepIds
          .where((stepId) => stepId.startsWith('review::'))
          .length,
      1,
    );
  });

  test('third incorrect without review continues remediation behavior', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [remediationStep])
        .updatedState;
    final firstIncorrect = engine
        .submitStepResult(state: state, result: _incorrectResult)
        .updatedState;
    final remediationShown = engine
        .submitStepResult(state: firstIncorrect, result: _incorrectResult)
        .updatedState;

    final decision = engine.submitStepResult(
      state: remediationShown,
      result: _incorrectResult,
    );

    expect(decision.type, LessonSessionDecisionType.showRemediation);
    expect(decision.reasonCode, LessonSessionReasonCode.remediationRequested);
    expect(decision.updatedState.orderedStepIds, [remediationStep.id]);
  });

  test('finish is unavailable while inserted review is pending', () {
    final state = engine
        .startSession(
          lessonId: lessonId,
          steps: const [reviewOriginStep, reviewStep],
        )
        .updatedState;
    final firstIncorrect = engine
        .submitStepResult(state: state, result: _incorrectResult)
        .updatedState;
    final remediationShown = engine
        .submitStepResult(state: firstIncorrect, result: _incorrectResult)
        .updatedState;
    final reviewInserted = engine
        .submitStepResult(state: remediationShown, result: _incorrectResult)
        .updatedState;

    final finishDecision = engine.finishSession(reviewInserted);

    expect(finishDecision.type, LessonSessionDecisionType.rejectAction);
    expect(
      finishDecision.reasonCode,
      LessonSessionReasonCode.finalStepIncomplete,
    );
  });

  test('previous and next preserve attempts and attached results', () {
    final started = engine
        .startSession(
          lessonId: lessonId,
          steps: const [infoStep, practiceStep, finalPracticeStep],
        )
        .updatedState;
    final onPractice = engine.requestNext(started).updatedState;
    final afterSubmit = engine
        .submitStepResult(state: onPractice, result: _correctResult)
        .updatedState;
    final onFinal = engine.requestNext(afterSubmit).updatedState;

    final previousDecision = engine.requestPrevious(onFinal);
    final nextDecision = engine.requestNext(previousDecision.updatedState);

    expect(previousDecision.type, LessonSessionDecisionType.moveToPreviousStep);
    expect(previousDecision.updatedState.currentStepId, practiceStep.id);
    expect(previousDecision.updatedState.attemptsByStepId[practiceStep.id], 1);
    expect(
      previousDecision.updatedState.resultByStepId[practiceStep.id],
      same(_correctResult),
    );
    expect(nextDecision.type, LessonSessionDecisionType.moveToNextStep);
    expect(nextDecision.updatedState.currentStepId, finalPracticeStep.id);
  });

  test('previous is rejected on first step', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [practiceStep])
        .updatedState;

    final decision = engine.requestPrevious(state);

    expect(decision.type, LessonSessionDecisionType.rejectAction);
    expect(decision.reasonCode, LessonSessionReasonCode.alreadyAtFirstStep);
  });

  test('finish is rejected before final eligible step', () {
    final state = engine
        .startSession(
          lessonId: lessonId,
          steps: const [practiceStep, finalPracticeStep],
        )
        .updatedState;

    final decision = engine.finishSession(state);

    expect(decision.type, LessonSessionDecisionType.rejectAction);
    expect(decision.reasonCode, LessonSessionReasonCode.finalStepIncomplete);
  });

  test('finish succeeds only on final completed step', () {
    final started = engine
        .startSession(
          lessonId: lessonId,
          steps: const [practiceStep, finalPracticeStep],
        )
        .updatedState;
    final completedFirst = engine
        .submitStepResult(state: started, result: _correctResult)
        .updatedState;
    final onFinal = engine.requestNext(completedFirst).updatedState;
    final completedFinal = engine
        .submitStepResult(state: onFinal, result: _correctResult)
        .updatedState;

    final finishDecision = engine.finishSession(completedFinal);
    final afterCompleteDecision = engine.requestNext(
      finishDecision.updatedState,
    );

    expect(finishDecision.type, LessonSessionDecisionType.finishLesson);
    expect(finishDecision.updatedState.status, LessonSessionStatus.completed);
    expect(afterCompleteDecision.type, LessonSessionDecisionType.rejectAction);
    expect(
      afterCompleteDecision.reasonCode,
      LessonSessionReasonCode.lessonAlreadyCompleted,
    );
  });

  test('resubmission replaces latest result and completion follows it', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [practiceStep])
        .updatedState;
    final completed = engine
        .submitStepResult(state: state, result: _correctResult)
        .updatedState;

    final resubmitted = engine.submitStepResult(
      state: completed,
      result: _incorrectResult,
    );

    expect(resubmitted.type, LessonSessionDecisionType.retryCurrentStep);
    expect(resubmitted.updatedState.attemptsByStepId[practiceStep.id], 2);
    expect(
      resubmitted.updatedState.resultByStepId[practiceStep.id],
      same(_incorrectResult),
    );
    expect(
      resubmitted.updatedState.completedStepIds,
      isNot(contains(practiceStep.id)),
    );
    expect(
      resubmitted
          .updatedState
          .masteryAssessmentByStepId[practiceStep.id]
          ?.status,
      StepMasteryStatus.notMastered,
    );
    expect(
      resubmitted
          .updatedState
          .masteryAssessmentByStepId[practiceStep.id]
          ?.reasonCode,
      StepMasteryReasonCode.latestSubmissionIncorrect,
    );
  });

  test('lesson mastery summary counts canonical checkable steps only', () {
    final started = engine
        .startSession(
          lessonId: lessonId,
          steps: const [infoStep, practiceStep, finalPracticeStep],
        )
        .updatedState;
    final onPractice = engine.requestNext(started).updatedState;
    final masteredPractice = engine
        .submitStepResult(state: onPractice, result: _correctResult)
        .updatedState;
    final onFinal = engine.requestNext(masteredPractice).updatedState;
    final fragileFinal = engine
        .submitStepResult(state: onFinal, result: _acceptedWithFeedbackResult)
        .updatedState;

    final finishDecision = engine.finishSession(fragileFinal);
    final summary = finishDecision.masterySummary!;

    expect(finishDecision.type, LessonSessionDecisionType.finishLesson);
    expect(summary.assessedStepCount, 2);
    expect(summary.masteredStepCount, 1);
    expect(summary.fragileStepCount, 1);
    expect(summary.notMasteredStepCount, 0);
    expect(summary.unassessedStepCount, 0);
    expect(summary.masteryRatio, 0.5);
  });

  test('restart clears current result without incrementing attempts', () {
    final state = engine
        .startSession(lessonId: lessonId, steps: const [practiceStep])
        .updatedState;
    final completed = engine
        .submitStepResult(state: state, result: _correctResult)
        .updatedState;

    final decision = engine.restartCurrentStep(completed);

    expect(decision.type, LessonSessionDecisionType.showCurrentStep);
    expect(decision.reasonCode, LessonSessionReasonCode.currentStepRestarted);
    expect(decision.updatedState.attemptsByStepId[practiceStep.id], 1);
    expect(
      decision.updatedState.resultByStepId,
      isNot(contains(practiceStep.id)),
    );
    expect(
      decision.updatedState.completedStepIds,
      isNot(contains(practiceStep.id)),
    );
  });
}

const _correctResult = ActivityResult(
  exerciseId: 'exercise',
  isCorrect: true,
  status: ActivityResultStatus.correct,
);

const _acceptedWithFeedbackResult = ActivityResult(
  exerciseId: 'exercise',
  isCorrect: true,
  status: ActivityResultStatus.acceptedWithFeedback,
);

const _incorrectResult = ActivityResult(
  exerciseId: 'exercise',
  isCorrect: false,
  status: ActivityResultStatus.incorrect,
);
