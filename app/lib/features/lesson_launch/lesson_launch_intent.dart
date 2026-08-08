import '../../core/learner/lesson_attempt.dart';
import '../lesson_planning/lesson_plan.dart';

class LessonLaunchIntent {
  const LessonLaunchIntent({
    required this.lessonId,
    this.attemptPurpose = LessonAttemptPurpose.normal,
    this.initialStepId,
  });

  factory LessonLaunchIntent.fromPlan(LessonPlan plan) {
    return LessonLaunchIntent(
      lessonId: plan.selectedLessonId,
      attemptPurpose: plan.attemptPurpose,
    );
  }

  final String lessonId;
  final LessonAttemptPurpose attemptPurpose;
  final String? initialStepId;
}
