import '../../core/learner/lesson_attempt.dart';
import '../lesson_planning/lesson_plan.dart';

enum LessonLaunchMode { learning, review }

class LessonLaunchIntent {
  const LessonLaunchIntent({
    required this.lessonId,
    this.attemptPurpose = LessonAttemptPurpose.normal,
    this.mode = LessonLaunchMode.learning,
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
  final LessonLaunchMode mode;
  final String? initialStepId;
}
