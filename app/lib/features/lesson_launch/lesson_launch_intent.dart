import '../../core/learner/lesson_attempt.dart';
import '../lesson_planning/lesson_plan.dart';

class LessonLaunchIntent {
  const LessonLaunchIntent({
    required this.lessonId,
    this.attemptPurpose = LessonAttemptPurpose.normal,
  });

  factory LessonLaunchIntent.fromPlan(LessonPlan plan) {
    return LessonLaunchIntent(
      lessonId: plan.selectedLessonId,
      attemptPurpose: switch (plan.planType) {
        LessonPlanType.reinforcementRepeat =>
          LessonAttemptPurpose.reinforcementRepeat,
        LessonPlanType.newLesson ||
        LessonPlanType.continueLesson ||
        LessonPlanType.reviewLesson ||
        LessonPlanType.repeatLesson => LessonAttemptPurpose.normal,
      },
    );
  }

  final String lessonId;
  final LessonAttemptPurpose attemptPurpose;
}
