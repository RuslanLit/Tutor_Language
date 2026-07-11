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
  });

  test('incorrect submission increments attempts and requires retry', () {
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
      LessonSessionReasonCode.incorrectAnswerRequiresRetry,
    );
    expect(submitDecision.updatedState.attemptsByStepId[practiceStep.id], 1);
    expect(
      submitDecision.updatedState.completedStepIds,
      isNot(contains(practiceStep.id)),
    );
    expect(nextDecision.type, LessonSessionDecisionType.rejectAction);
    expect(nextDecision.reasonCode, LessonSessionReasonCode.nextStepLocked);
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
