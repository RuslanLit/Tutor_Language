import '../../core/learner/lesson_attempt.dart';
import '../curriculum/curriculum_models.dart';

enum LessonPlanType {
  newLesson,
  continueLesson,
  reviewLesson,
  repeatLesson,
  reinforcementRepeat,
  courseComplete,
}

enum LessonPlanReasonCode {
  noHistorySelectFirstLesson,
  currentLessonIncomplete,
  completedLessonSelectNext,
  lowAccuracyReview,
  lowAccuracyRepeatCurrent,
  noNextLessonAvailable,
  emptyCourse,
  invalidCurrentLessonFallback,
  latestOutcomeMastered,
  latestOutcomeNeedsReinforcement,
  immediateReinforcementRepeatSelected,
  reinforcementRepeatConsumedMastered,
  reinforcementRepeatConsumedStillFragile,
  manualRepeatNeedsReinforcement,
  legacyCompletionWithoutDurableOutcome,
  nextLessonAfterMastery,
  nextLessonAfterBoundedReinforcement,
  finalLessonMasteredCourseComplete,
  finalReinforcementConsumedCourseComplete,
  legacyFinalCompletionCourseComplete,
}

class LessonPlan {
  const LessonPlan({
    required this.selectedLessonId,
    required this.planType,
    required this.reasonCodes,
    required this.diagnosticExplanation,
    this.attemptPurpose = LessonAttemptPurpose.normal,
    this.reinforcementRecommended = false,
    this.sourceLessonId,
    this.sourceOutcomeStatus,
    this.sourceAttemptPurpose,
    this.reinforcementConsumed = false,
    this.selectedReferences = const [],
  });

  final String selectedLessonId;
  final LessonPlanType planType;
  final List<LessonPlanReasonCode> reasonCodes;
  final String diagnosticExplanation;
  final LessonAttemptPurpose attemptPurpose;
  final bool reinforcementRecommended;
  final String? sourceLessonId;
  final DurableLessonOutcomeStatus? sourceOutcomeStatus;
  final LessonAttemptPurpose? sourceAttemptPurpose;
  final bool reinforcementConsumed;
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
