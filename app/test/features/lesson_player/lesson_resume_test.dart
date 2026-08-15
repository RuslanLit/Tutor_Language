import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/learner/learner_progress.dart';
import 'package:tutor_language/core/learner/lesson_attempt.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_content.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_providers.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_step.dart';

void main() {
  final steps = [_step('step.1'), _step('step.2'), _step('step.3')];

  test('session reconstruction restores a valid stable step and attempt', () {
    final cursor = LessonResumeCursor(
      lessonId: 'lesson.resume',
      courseId: 'course.a0',
      attemptId: 'attempt.resume',
      attemptPurpose: LessonAttemptPurpose.normal,
      stepId: 'step.2',
      stepIndex: 1,
      furthestReachedStepIndex: 2,
      startedAt: DateTime.utc(2026, 8, 8),
      savedAt: DateTime.utc(2026, 8, 8, 1),
    );

    final state = const LessonPlayerSessionState().ensureStarted(
      lessonId: 'lesson.resume',
      steps: steps,
      resumeCursor: cursor,
    );

    expect(state.sessionState.currentStepId, 'step.2');
    expect(state.sessionState.currentStepIndex, 1);
    expect(state.sessionState.furthestReachedStepIndex, 2);
    expect(state.attemptId, 'attempt.resume');
    expect(state.attemptStartedAt, cursor.startedAt);
  });

  test('stale step identity falls back to the first valid step', () {
    final cursor = LessonResumeCursor(
      lessonId: 'lesson.resume',
      courseId: 'course.a0',
      attemptId: 'attempt.stale',
      attemptPurpose: LessonAttemptPurpose.normal,
      stepId: 'step.removed',
      stepIndex: 9999,
      startedAt: DateTime.utc(2026, 8, 8),
      savedAt: DateTime.utc(2026, 8, 8, 1),
    );

    final state = const LessonPlayerSessionState().ensureStarted(
      lessonId: 'lesson.resume',
      steps: steps,
      resumeCursor: cursor,
    );

    expect(state.sessionState.currentStepId, 'step.1');
    expect(state.sessionState.currentStepIndex, 0);
    expect(state.attemptId, isNot('attempt.stale'));
  });

  test('manual repeat does not inherit a normal attempt cursor', () {
    final cursor = LessonResumeCursor(
      lessonId: 'lesson.resume',
      courseId: 'course.a0',
      attemptId: 'attempt.normal',
      attemptPurpose: LessonAttemptPurpose.normal,
      stepId: 'step.3',
      stepIndex: 2,
      startedAt: DateTime.utc(2026, 8, 8),
      savedAt: DateTime.utc(2026, 8, 8, 1),
    );

    final state = const LessonPlayerSessionState().ensureStarted(
      lessonId: 'lesson.resume',
      steps: steps,
      attemptPurpose: LessonAttemptPurpose.manualRepeat,
      resumeCursor: cursor,
    );

    expect(state.sessionState.currentStepId, 'step.1');
    expect(state.attemptId, isNot('attempt.normal'));
  });

  test('resume cursor does not carry unfinished typed input state', () {
    final cursor = LessonResumeCursor(
      lessonId: 'lesson.resume',
      courseId: 'course.a0',
      attemptId: 'attempt.typed',
      attemptPurpose: LessonAttemptPurpose.normal,
      stepId: 'step.2',
      stepIndex: 1,
      startedAt: DateTime.utc(2026, 8, 8),
      savedAt: DateTime.utc(2026, 8, 8, 1),
    );

    final state = const LessonPlayerSessionState().ensureStarted(
      lessonId: 'lesson.resume',
      steps: steps,
      resumeCursor: cursor,
    );

    expect(state.sessionState.currentStepId, 'step.2');
    expect(state.stepStates, isEmpty);
  });
}

LessonPlayerStep _step(String id) {
  final activity = LessonActivity(
    id: '$id.activity',
    title: id,
    type: 'information',
  );
  return LessonPlayerStep(
    id: id,
    sourceActivity: LessonContentActivity(
      activity: activity,
      resolvedContent: const [],
    ),
    content: const [],
    stepType: LessonPlayerStepType.mixed,
  );
}
