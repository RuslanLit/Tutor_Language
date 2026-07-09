import '../curriculum/curriculum_models.dart';

enum LessonPlanType { newLesson, continueLesson, reviewLesson, repeatLesson }

enum LessonPlanReasonCode {
  noHistorySelectFirstLesson,
  currentLessonIncomplete,
  completedLessonSelectNext,
  lowAccuracyReview,
  lowAccuracyRepeatCurrent,
  noNextLessonAvailable,
  emptyCourse,
  invalidCurrentLessonFallback,
}

class LessonPlan {
  const LessonPlan({
    required this.selectedLessonId,
    required this.planType,
    required this.reasonCodes,
    required this.diagnosticExplanation,
    this.selectedReferences = const [],
  });

  final String selectedLessonId;
  final LessonPlanType planType;
  final List<LessonPlanReasonCode> reasonCodes;
  final String diagnosticExplanation;
  final List<LessonActivityReference> selectedReferences;
}

class PlanningFailure {
  const PlanningFailure({required this.reasonCode, required this.message});

  final LessonPlanReasonCode reasonCode;
  final String message;
}

class LessonPlanningResult {
  const LessonPlanningResult._({this.plan, this.failure});

  factory LessonPlanningResult.success(LessonPlan plan) {
    return LessonPlanningResult._(plan: plan);
  }

  factory LessonPlanningResult.failure(PlanningFailure failure) {
    return LessonPlanningResult._(failure: failure);
  }

  final LessonPlan? plan;
  final PlanningFailure? failure;

  bool get isSuccess => plan != null;
}
