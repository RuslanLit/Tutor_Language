import '../../core/learner/learner_progress_repository.dart';
import '../../core/learner/learner_state_repository.dart';
import '../../core/learner/lesson_attempt.dart';
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
      Map<String, LessonAttemptSummary> attemptSummaries = const {};
      Map<String, List<LessonAttemptSummary>> attemptHistory = const {};
      if (state != null) {
        try {
          final summaries = await learnerProgressRepository
              .getCourseLessonAttemptSummaries(state.currentCourseId);
          final latestByLessonId = <String, LessonAttemptSummary>{};
          final historyByLessonId = <String, List<LessonAttemptSummary>>{};
          for (final summary in summaries) {
            latestByLessonId[summary.lessonId] = summary;
            historyByLessonId
                .putIfAbsent(summary.lessonId, () => <LessonAttemptSummary>[])
                .add(summary);
          }
          attemptSummaries = Map.unmodifiable(latestByLessonId);
          attemptHistory = Map<String, List<LessonAttemptSummary>>.unmodifiable(
            {
              for (final entry in historyByLessonId.entries)
                entry.key: List<LessonAttemptSummary>.unmodifiable(entry.value),
            },
          );
        } catch (_) {
          attemptSummaries = const {};
          attemptHistory = const {};
        }
      }

      return LearnerHistorySummary(
        completedLessonIds: eventSummary.completedLessonIds,
        currentLessonId: state?.currentTopicId,
        incompleteLessonIds: eventSummary.incompleteLessonIds,
        lessonAttemptHistoryByLessonId: attemptHistory,
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
