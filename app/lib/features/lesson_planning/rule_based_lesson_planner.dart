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
        !history.completedLessonIds.contains(currentLesson.id)) {
      return _success(
        lesson: currentLesson,
        planType: LessonPlanType.continueLesson,
        reasonCodes: [LessonPlanReasonCode.currentLessonIncomplete],
        explanation: 'Current lesson is not complete; continuing it.',
      );
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
          explanation: 'Recent accuracy is low; repeating a recent lesson.',
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
            'Recent accuracy is low; no valid recent lesson exists, so reviewing from the first lesson.',
      );
    }

    if (currentLessonId != null && currentLesson == null) {
      return _success(
        lesson: _firstIncompleteLesson(orderedLessons, history),
        planType: LessonPlanType.newLesson,
        reasonCodes: [LessonPlanReasonCode.invalidCurrentLessonFallback],
        explanation:
            'Current lesson is not in this course; selected the first deterministic fallback lesson.',
      );
    }

    if (currentLesson != null &&
        history.completedLessonIds.contains(currentLesson.id)) {
      final nextLesson = _nextLesson(orderedLessons, currentLesson);
      if (nextLesson != null) {
        return _success(
          lesson: nextLesson,
          planType: LessonPlanType.newLesson,
          reasonCodes: [LessonPlanReasonCode.completedLessonSelectNext],
          explanation:
              'Current lesson is complete; selected next course lesson.',
        );
      }
    }

    final firstIncompleteLesson = _firstIncompleteLessonOrNull(
      orderedLessons,
      history,
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
      lesson: currentLesson ?? orderedLessons.last,
      planType: LessonPlanType.reviewLesson,
      reasonCodes: [LessonPlanReasonCode.noNextLessonAvailable],
      explanation: 'No next lesson is available; selected a review lesson.',
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

  LessonPlanningResult _success({
    required LessonDefinition lesson,
    required LessonPlanType planType,
    required List<LessonPlanReasonCode> reasonCodes,
    required String explanation,
  }) {
    return LessonPlanningResult.success(
      LessonPlan(
        selectedLessonId: lesson.id,
        planType: planType,
        reasonCodes: List.unmodifiable(reasonCodes),
        diagnosticExplanation: explanation,
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
    LearnerHistorySummary history,
  ) {
    return _firstIncompleteLessonOrNull(lessons, history) ?? lessons.first;
  }

  LessonDefinition? _firstIncompleteLessonOrNull(
    List<LessonDefinition> lessons,
    LearnerHistorySummary history,
  ) {
    for (final lesson in lessons) {
      if (!history.completedLessonIds.contains(lesson.id)) {
        return lesson;
      }
    }

    return null;
  }
}
