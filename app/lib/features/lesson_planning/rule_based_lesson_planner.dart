import '../../core/learner/lesson_attempt.dart';
import '../curriculum/curriculum_models.dart';
import 'learner_history_summary.dart';
import 'lesson_plan.dart';
import 'planning_request.dart';

class RuleBasedLessonPlanner {
  const RuleBasedLessonPlanner();

  LessonPlanningResult plan(PlanningRequest request) {
    final orderedLessons = _orderedLessons(request.course);

    if (orderedLessons.isEmpty) {
      return LessonPlanningResult.failure(
        const PlanningFailure(
          reasonCode: LessonPlanReasonCode.emptyCourse,
          message: 'Course has no usable lessons.',
        ),
      );
    }

    final history = request.learnerHistory;
    final currentLessonId =
        history.currentLessonId ?? request.learnerState?.currentTopicId;
    final currentLesson = _lessonById(orderedLessons, currentLessonId);
    final lastAttemptedLesson = _lessonById(
      orderedLessons,
      history.lastAttemptedLessonId,
    );
    final completedLessonIds = _effectiveCompletedLessonIds(history);

    if (!history.hasHistory) {
      return _success(
        lesson: orderedLessons.first,
        planType: LessonPlanType.newLesson,
        reasonCodes: [LessonPlanReasonCode.noHistorySelectFirstLesson],
        explanation: 'No learner history exists; selected first course lesson.',
      );
    }

    if (request.policy.preferIncompleteLesson &&
        currentLesson != null &&
        !completedLessonIds.contains(currentLesson.id)) {
      return _success(
        lesson: currentLesson,
        planType: LessonPlanType.continueLesson,
        reasonCodes: [LessonPlanReasonCode.currentLessonIncomplete],
        explanation: 'Current lesson is not complete; continuing it.',
      );
    }

    if (currentLessonId != null && currentLesson == null) {
      return _success(
        lesson: _firstIncompleteLesson(orderedLessons, completedLessonIds),
        planType: LessonPlanType.newLesson,
        reasonCodes: [LessonPlanReasonCode.invalidCurrentLessonFallback],
        explanation:
            'Current lesson is not in this course; selected the first deterministic fallback lesson.',
      );
    }

    final positionLesson = _coursePositionLesson(
      orderedLessons,
      currentLesson,
      completedLessonIds,
    );
    if (positionLesson != null) {
      final outcomePlan = _planFromCompletedPosition(
        orderedLessons,
        positionLesson,
        history,
      );
      if (outcomePlan != null) {
        return outcomePlan;
      }
    }

    final lowAccuracy = _hasLowRecentAccuracy(history, request);
    if (lowAccuracy && request.policy.reviewOnLowAccuracy) {
      final fallbackLesson = currentLesson ?? lastAttemptedLesson;
      if (fallbackLesson != null) {
        return _success(
          lesson: fallbackLesson,
          planType: LessonPlanType.repeatLesson,
          reasonCodes: [
            LessonPlanReasonCode.lowAccuracyRepeatCurrent,
            if (currentLessonId != null && currentLesson == null)
              LessonPlanReasonCode.invalidCurrentLessonFallback,
          ],
          explanation:
              'No durable completed-lesson outcome applies; recent accuracy is low, so repeating a recent lesson.',
        );
      }

      return _success(
        lesson: orderedLessons.first,
        planType: LessonPlanType.reviewLesson,
        reasonCodes: [
          LessonPlanReasonCode.lowAccuracyReview,
          if (currentLessonId != null)
            LessonPlanReasonCode.invalidCurrentLessonFallback,
        ],
        explanation:
            'No durable completed-lesson outcome applies; recent accuracy is low, so reviewing from the first lesson.',
      );
    }

    final firstIncompleteLesson = _firstIncompleteLessonOrNull(
      orderedLessons,
      completedLessonIds,
    );
    if (firstIncompleteLesson != null) {
      return _success(
        lesson: firstIncompleteLesson,
        planType: LessonPlanType.newLesson,
        reasonCodes: [LessonPlanReasonCode.completedLessonSelectNext],
        explanation: 'Selected the first incomplete course lesson.',
      );
    }

    return _success(
      lesson: positionLesson ?? currentLesson ?? orderedLessons.last,
      planType: LessonPlanType.courseComplete,
      reasonCodes: [LessonPlanReasonCode.noNextLessonAvailable],
      explanation: 'No next lesson is available; course is complete.',
    );
  }

  bool _hasLowRecentAccuracy(
    LearnerHistorySummary history,
    PlanningRequest request,
  ) {
    final recentAccuracy = history.recentAccuracy;
    return recentAccuracy != null &&
        history.recentCheckedAnswersCount >=
            request.policy.minRecentAnswersForAccuracyDecision &&
        recentAccuracy < request.policy.lowAccuracyThreshold;
  }

  LessonPlanningResult? _planFromCompletedPosition(
    List<LessonDefinition> orderedLessons,
    LessonDefinition positionLesson,
    LearnerHistorySummary history,
  ) {
    final latestAttempt =
        _latestAttemptForLesson(history, positionLesson.id) ??
        history.latestLessonAttemptsByLessonId[positionLesson.id];
    final isFinalLesson = _nextLesson(orderedLessons, positionLesson) == null;

    if (latestAttempt == null) {
      if (!history.completedLessonIds.contains(positionLesson.id)) {
        return null;
      }
      return _advanceAfterLegacyCompletion(
        orderedLessons,
        positionLesson,
        isFinalLesson,
      );
    }

    switch (latestAttempt.outcomeStatus) {
      case DurableLessonOutcomeStatus.mastered:
        if (latestAttempt.purpose == LessonAttemptPurpose.reinforcementRepeat) {
          return _advanceAfterConsumedReinforcement(
            orderedLessons,
            positionLesson,
            latestAttempt,
            isFinalLesson,
          );
        }
        return _advanceAfterMastery(
          orderedLessons,
          positionLesson,
          latestAttempt,
          isFinalLesson,
        );
      case DurableLessonOutcomeStatus.completedWithReinforcement:
        if (latestAttempt.purpose == LessonAttemptPurpose.reinforcementRepeat) {
          return _advanceAfterConsumedReinforcement(
            orderedLessons,
            positionLesson,
            latestAttempt,
            isFinalLesson,
          );
        }

        return _reinforcementRepeat(
          positionLesson,
          latestAttempt,
          reasonCode: latestAttempt.purpose == LessonAttemptPurpose.manualRepeat
              ? LessonPlanReasonCode.manualRepeatNeedsReinforcement
              : LessonPlanReasonCode.latestOutcomeNeedsReinforcement,
        );
      case DurableLessonOutcomeStatus.incomplete:
        return _success(
          lesson: positionLesson,
          planType: LessonPlanType.continueLesson,
          reasonCodes: [LessonPlanReasonCode.currentLessonIncomplete],
          explanation: 'Latest durable attempt is incomplete; continuing it.',
        );
    }
  }

  LessonPlanningResult _reinforcementRepeat(
    LessonDefinition lesson,
    LessonAttemptSummary sourceAttempt, {
    required LessonPlanReasonCode reasonCode,
  }) {
    return _success(
      lesson: lesson,
      planType: LessonPlanType.reinforcementRepeat,
      attemptPurpose: LessonAttemptPurpose.reinforcementRepeat,
      reasonCodes: [
        reasonCode,
        LessonPlanReasonCode.immediateReinforcementRepeatSelected,
      ],
      explanation:
          'Latest durable outcome is fragile and has not consumed its immediate reinforcement repeat.',
      sourceAttempt: sourceAttempt,
    );
  }

  LessonPlanningResult _advanceAfterMastery(
    List<LessonDefinition> orderedLessons,
    LessonDefinition lesson,
    LessonAttemptSummary sourceAttempt,
    bool isFinalLesson,
  ) {
    if (isFinalLesson) {
      return _success(
        lesson: lesson,
        planType: LessonPlanType.courseComplete,
        reasonCodes: [
          LessonPlanReasonCode.latestOutcomeMastered,
          LessonPlanReasonCode.finalLessonMasteredCourseComplete,
        ],
        explanation:
            'Final lesson durable outcome is mastered; course complete.',
        sourceAttempt: sourceAttempt,
      );
    }

    return _success(
      lesson: _nextLesson(orderedLessons, lesson)!,
      planType: LessonPlanType.newLesson,
      reasonCodes: [
        LessonPlanReasonCode.latestOutcomeMastered,
        LessonPlanReasonCode.nextLessonAfterMastery,
      ],
      explanation:
          'Latest durable outcome is mastered; selected next course lesson.',
      sourceAttempt: sourceAttempt,
    );
  }

  LessonPlanningResult _advanceAfterConsumedReinforcement(
    List<LessonDefinition> orderedLessons,
    LessonDefinition lesson,
    LessonAttemptSummary sourceAttempt,
    bool isFinalLesson,
  ) {
    final reasonCode =
        sourceAttempt.outcomeStatus == DurableLessonOutcomeStatus.mastered
        ? LessonPlanReasonCode.reinforcementRepeatConsumedMastered
        : LessonPlanReasonCode.reinforcementRepeatConsumedStillFragile;

    if (isFinalLesson) {
      return _success(
        lesson: lesson,
        planType: LessonPlanType.courseComplete,
        reasonCodes: [
          reasonCode,
          LessonPlanReasonCode.finalReinforcementConsumedCourseComplete,
        ],
        explanation:
            'Final lesson reinforcement repeat has been consumed; course complete.',
        sourceAttempt: sourceAttempt,
        reinforcementRecommended:
            sourceAttempt.outcomeStatus ==
            DurableLessonOutcomeStatus.completedWithReinforcement,
        reinforcementConsumed: true,
      );
    }

    return _success(
      lesson: _nextLesson(orderedLessons, lesson)!,
      planType: LessonPlanType.newLesson,
      reasonCodes: [
        reasonCode,
        LessonPlanReasonCode.nextLessonAfterBoundedReinforcement,
      ],
      explanation:
          'Immediate reinforcement repeat has been consumed; selected next course lesson.',
      sourceAttempt: sourceAttempt,
      reinforcementRecommended:
          sourceAttempt.outcomeStatus ==
          DurableLessonOutcomeStatus.completedWithReinforcement,
      reinforcementConsumed: true,
    );
  }

  LessonPlanningResult _advanceAfterLegacyCompletion(
    List<LessonDefinition> orderedLessons,
    LessonDefinition lesson,
    bool isFinalLesson,
  ) {
    if (isFinalLesson) {
      return _success(
        lesson: lesson,
        planType: LessonPlanType.courseComplete,
        reasonCodes: [
          LessonPlanReasonCode.legacyCompletionWithoutDurableOutcome,
          LessonPlanReasonCode.legacyFinalCompletionCourseComplete,
        ],
        explanation:
            'Final lesson has legacy completion without durable outcome detail; course complete.',
      );
    }

    return _success(
      lesson: _nextLesson(orderedLessons, lesson)!,
      planType: LessonPlanType.newLesson,
      reasonCodes: [
        LessonPlanReasonCode.legacyCompletionWithoutDurableOutcome,
        LessonPlanReasonCode.completedLessonSelectNext,
      ],
      explanation:
          'Lesson has legacy completion without durable outcome detail; selected next course lesson.',
    );
  }

  LessonPlanningResult _success({
    required LessonDefinition lesson,
    required LessonPlanType planType,
    required List<LessonPlanReasonCode> reasonCodes,
    required String explanation,
    LessonAttemptPurpose attemptPurpose = LessonAttemptPurpose.normal,
    LessonAttemptSummary? sourceAttempt,
    bool reinforcementRecommended = false,
    bool reinforcementConsumed = false,
  }) {
    return LessonPlanningResult.success(
      LessonPlan(
        selectedLessonId: lesson.id,
        planType: planType,
        reasonCodes: List.unmodifiable(reasonCodes),
        diagnosticExplanation: explanation,
        attemptPurpose: attemptPurpose,
        reinforcementRecommended: reinforcementRecommended,
        sourceLessonId: sourceAttempt?.lessonId,
        sourceOutcomeStatus: sourceAttempt?.outcomeStatus,
        sourceAttemptPurpose: sourceAttempt?.purpose,
        reinforcementConsumed: reinforcementConsumed,
        selectedReferences: List.unmodifiable(
          lesson.activities.expand((activity) => activity.references),
        ),
      ),
    );
  }

  List<LessonDefinition> _orderedLessons(Course course) {
    final lessonsById = {
      for (final lesson in course.lessons) lesson.id: lesson,
    };
    final ordered = <LessonDefinition>[];
    final seen = <String>{};

    for (final module in course.modules) {
      for (final lessonId in module.lessonIds) {
        final lesson = lessonsById[lessonId];
        if (lesson != null && seen.add(lesson.id)) {
          ordered.add(lesson);
        }
      }
    }

    for (final lesson in course.lessons) {
      if (seen.add(lesson.id)) {
        ordered.add(lesson);
      }
    }

    return List.unmodifiable(ordered);
  }

  LessonDefinition? _lessonById(
    List<LessonDefinition> lessons,
    String? lessonId,
  ) {
    if (lessonId == null) {
      return null;
    }

    for (final lesson in lessons) {
      if (lesson.id == lessonId) {
        return lesson;
      }
    }

    return null;
  }

  LessonDefinition? _nextLesson(
    List<LessonDefinition> lessons,
    LessonDefinition lesson,
  ) {
    final index = lessons.indexWhere((candidate) => candidate.id == lesson.id);
    if (index < 0 || index + 1 >= lessons.length) {
      return null;
    }

    return lessons[index + 1];
  }

  LessonDefinition _firstIncompleteLesson(
    List<LessonDefinition> lessons,
    Set<String> completedLessonIds,
  ) {
    return _firstIncompleteLessonOrNull(lessons, completedLessonIds) ??
        lessons.first;
  }

  LessonDefinition? _firstIncompleteLessonOrNull(
    List<LessonDefinition> lessons,
    Set<String> completedLessonIds,
  ) {
    for (final lesson in lessons) {
      if (!completedLessonIds.contains(lesson.id)) {
        return lesson;
      }
    }

    return null;
  }

  Set<String> _effectiveCompletedLessonIds(LearnerHistorySummary history) {
    final completed = <String>{...history.completedLessonIds};
    for (final entry in history.latestLessonAttemptsByLessonId.entries) {
      if (entry.value.outcomeStatus != DurableLessonOutcomeStatus.incomplete) {
        completed.add(entry.key);
      }
    }
    for (final entry in history.lessonAttemptHistoryByLessonId.entries) {
      final latest = _latestAttempt(entry.value);
      if (latest != null &&
          latest.outcomeStatus != DurableLessonOutcomeStatus.incomplete) {
        completed.add(entry.key);
      }
    }
    return Set.unmodifiable(completed);
  }

  LessonDefinition? _coursePositionLesson(
    List<LessonDefinition> orderedLessons,
    LessonDefinition? currentLesson,
    Set<String> completedLessonIds,
  ) {
    if (currentLesson != null &&
        completedLessonIds.contains(currentLesson.id)) {
      return currentLesson;
    }

    for (final lesson in orderedLessons.reversed) {
      if (completedLessonIds.contains(lesson.id)) {
        return lesson;
      }
    }

    return null;
  }

  LessonAttemptSummary? _latestAttemptForLesson(
    LearnerHistorySummary history,
    String lessonId,
  ) {
    final attempts = history.lessonAttemptHistoryByLessonId[lessonId];
    if (attempts == null || attempts.isEmpty) {
      return null;
    }
    return _latestAttempt(attempts);
  }

  LessonAttemptSummary? _latestAttempt(List<LessonAttemptSummary> attempts) {
    LessonAttemptSummary? latest;
    for (final attempt in attempts) {
      if (latest == null ||
          attempt.completedAt.isAfter(latest.completedAt) ||
          (attempt.completedAt.isAtSameMomentAs(latest.completedAt) &&
              attempt.attemptId.compareTo(latest.attemptId) > 0)) {
        latest = attempt;
      }
    }
    return latest;
  }
}
