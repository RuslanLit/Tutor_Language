class PlanningPolicy {
  const PlanningPolicy({
    this.lowAccuracyThreshold = 0.7,
    this.minRecentAnswersForAccuracyDecision = 3,
    this.preferIncompleteLesson = true,
    this.reviewOnLowAccuracy = true,
  });

  final double lowAccuracyThreshold;
  final int minRecentAnswersForAccuracyDecision;
  final bool preferIncompleteLesson;
  final bool reviewOnLowAccuracy;
}
