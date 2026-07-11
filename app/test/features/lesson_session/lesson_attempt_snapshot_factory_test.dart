import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/learner/lesson_attempt.dart';
import 'package:tutor_language/features/activity_engine/activity_result.dart';
import 'package:tutor_language/features/lesson_session/lesson_attempt_snapshot_factory.dart';
import 'package:tutor_language/features/lesson_session/lesson_session_engine.dart';

void main() {
  const engine = LessonSessionEngine();
  const factory = LessonAttemptSnapshotFactory();
  const lessonId = 'lesson.snapshot';
  const infoStep = LessonSessionStep(id: 'step.info', isCheckable: false);
  const practiceStep = LessonSessionStep(
    id: 'step.practice',
    isCheckable: true,
  );
  const finalStep = LessonSessionStep(id: 'step.final', isCheckable: true);

  test('final session maps to one durable attempt aggregate', () {
    final finishDecision = _finishTwoStepLesson(engine);

    final command = factory.create(
      attemptId: 'attempt.snapshot',
      lessonId: lessonId,
      courseId: 'course.spanish.a0',
      finalState: finishDecision.updatedState,
      finishDecision: finishDecision,
      completedAt: DateTime.utc(2026, 7, 11),
    );

    expect(command.attempt.attemptId, 'attempt.snapshot');
    expect(command.attempt.lessonId, lessonId);
    expect(command.attempt.courseId, 'course.spanish.a0');
    expect(command.attempt.outcomeStatus, DurableLessonOutcomeStatus.mastered);
    expect(command.attempt.masteredStepCount, 2);
    expect(command.attempt.canonicalCheckableStepCount, 2);
    expect(command.attempt.totalSubmissionCount, 2);
    expect(command.attempt.learningPolicyVersion, lessonLearningPolicyVersion);
    expect(command.stepResults.map((step) => step.stepId), [
      practiceStep.id,
      finalStep.id,
    ]);
  });

  test('informational and inserted review runtime steps are excluded', () {
    const originStep = LessonSessionStep(
      id: 'step.origin',
      isCheckable: true,
      hasRemediation: true,
      reviewStepIds: ['step.review'],
    );
    const reviewStep = LessonSessionStep(id: 'step.review', isCheckable: true);
    var state = engine
        .startSession(
          lessonId: lessonId,
          steps: const [infoStep, originStep, reviewStep],
        )
        .updatedState;
    state = engine.requestNext(state).updatedState;
    state = engine
        .submitStepResult(state: state, result: _incorrectResult)
        .updatedState;
    state = engine
        .submitStepResult(state: state, result: _incorrectResult)
        .updatedState;
    final inserted = engine.submitStepResult(
      state: state,
      result: _incorrectResult,
    );
    final completedReview = engine
        .submitStepResult(state: inserted.updatedState, result: _correctResult)
        .updatedState;
    final returnedToOrigin = engine.requestNext(completedReview).updatedState;
    final completedOrigin = engine
        .submitStepResult(state: returnedToOrigin, result: _correctResult)
        .updatedState;
    final onAuthoredReview = engine.requestNext(completedOrigin).updatedState;
    final completedAuthoredReview = engine
        .submitStepResult(state: onAuthoredReview, result: _correctResult)
        .updatedState;
    final finishDecision = engine.finishSession(completedAuthoredReview);

    final command = factory.create(
      attemptId: 'attempt.review',
      lessonId: lessonId,
      courseId: 'course.spanish.a0',
      finalState: finishDecision.updatedState,
      finishDecision: finishDecision,
      completedAt: DateTime.utc(2026, 7, 11),
    );

    expect(command.stepResults.map((step) => step.stepId), [
      originStep.id,
      reviewStep.id,
    ]);
    final origin = command.stepResults.first;
    expect(origin.reviewWasRequired, isTrue);
    expect(origin.remediationWasRequired, isTrue);
    expect(
      command.stepResults.any((step) => step.stepId.startsWith('review::')),
      isFalse,
    );
  });

  test('summary mismatch is rejected', () {
    final finishDecision = _finishTwoStepLesson(engine);
    final badDecision = LessonSessionDecision(
      type: LessonSessionDecisionType.finishLesson,
      reasonCode: LessonSessionReasonCode.lessonFinished,
      updatedState: finishDecision.updatedState,
      masterySummary: const LessonMasterySummary(
        assessedStepCount: 2,
        masteredStepCount: 1,
        fragileStepCount: 1,
        notMasteredStepCount: 0,
        unassessedStepCount: 0,
        masteryRatio: 0.5,
      ),
      lessonOutcome: finishDecision.lessonOutcome,
    );

    expect(
      () => factory.create(
        attemptId: 'attempt.bad',
        lessonId: lessonId,
        courseId: 'course.spanish.a0',
        finalState: finishDecision.updatedState,
        finishDecision: badDecision,
        completedAt: DateTime.utc(2026, 7, 11),
      ),
      throwsA(isA<LessonAttemptValidationException>()),
    );
  });

  test('completed attempt with incomplete outcome is rejected', () {
    final finishDecision = _finishTwoStepLesson(engine);
    final badDecision = LessonSessionDecision(
      type: LessonSessionDecisionType.finishLesson,
      reasonCode: LessonSessionReasonCode.lessonFinished,
      updatedState: finishDecision.updatedState,
      masterySummary: finishDecision.masterySummary,
      lessonOutcome: LessonOutcome(
        lessonId: lessonId,
        status: LessonOutcomeStatus.incomplete,
        summary: finishDecision.masterySummary!,
        reasonCode: LessonOutcomeReasonCode.lessonNotCompleted,
      ),
    );

    expect(
      () => factory.create(
        attemptId: 'attempt.incomplete',
        lessonId: lessonId,
        courseId: 'course.spanish.a0',
        finalState: finishDecision.updatedState,
        finishDecision: badDecision,
        completedAt: DateTime.utc(2026, 7, 11),
      ),
      throwsA(isA<LessonAttemptValidationException>()),
    );
  });
}

LessonSessionDecision _finishTwoStepLesson(LessonSessionEngine engine) {
  final started = engine
      .startSession(
        lessonId: 'lesson.snapshot',
        steps: const [practiceStep, finalStep],
      )
      .updatedState;
  final completedFirst = engine
      .submitStepResult(state: started, result: _correctResult)
      .updatedState;
  final onFinal = engine.requestNext(completedFirst).updatedState;
  final completedFinal = engine
      .submitStepResult(state: onFinal, result: _correctResult)
      .updatedState;
  return engine.finishSession(completedFinal);
}

const practiceStep = LessonSessionStep(id: 'step.practice', isCheckable: true);
const finalStep = LessonSessionStep(id: 'step.final', isCheckable: true);

const _correctResult = ActivityResult(
  exerciseId: 'exercise',
  isCorrect: true,
  status: ActivityResultStatus.correct,
);

const _incorrectResult = ActivityResult(
  exerciseId: 'exercise',
  isCorrect: false,
  status: ActivityResultStatus.incorrect,
);
