import '../../core/learner/learner_progress_repository.dart';
import '../../core/learner/learner_state_repository.dart';
import '../lesson_planning/learner_history_summary.dart';

class LearnerHistoryProjection {
  const LearnerHistoryProjection({
    required this.learnerProgressRepository,
    required this.learnerStateRepository,
  });

  final LearnerProgressRepository learnerProgressRepository;
  final LearnerStateRepository learnerStateRepository;

  Future<LearnerHistorySummary> project() async {
    try {
      final state = await learnerStateRepository.readState();
      final events = await learnerProgressRepository.readEvents();
      final eventSummary = LearnerHistorySummary.fromProgressEvents(events);
      final attemptSummaries = state == null
          ? const {}
          : {
              for (final summary
                  in await learnerProgressRepository
                      .getCourseLessonAttemptSummaries(state.currentCourseId))
                summary.lessonId: summary,
            };

      return LearnerHistorySummary(
        completedLessonIds: eventSummary.completedLessonIds,
        currentLessonId: state?.currentTopicId,
        incompleteLessonIds: eventSummary.incompleteLessonIds,
        latestLessonAttemptsByLessonId: Map.unmodifiable(attemptSummaries),
        recentCheckedAnswersCount: eventSummary.recentCheckedAnswersCount,
        recentCorrectAnswersCount: eventSummary.recentCorrectAnswersCount,
        lastAttemptedLessonId: eventSummary.lastAttemptedLessonId,
      );
    } catch (_) {
      return const LearnerHistorySummary();
    }
  }
}
