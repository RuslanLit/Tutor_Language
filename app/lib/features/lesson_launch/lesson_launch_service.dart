import '../curriculum/curriculum_repository.dart';
import '../lesson_planning/learner_history_summary.dart';
import '../lesson_planning/lesson_plan.dart';
import '../lesson_planning/planning_request.dart';
import '../lesson_planning/rule_based_lesson_planner.dart';

class LessonLaunchService {
  const LessonLaunchService({
    required this.curriculumRepository,
    required this.planner,
    this.learnerHistorySummary,
  });

  final CurriculumRepository curriculumRepository;
  final RuleBasedLessonPlanner planner;
  final LearnerHistorySummary Function()? learnerHistorySummary;

  Future<LessonPlan> planNextLesson() async {
    final course = await curriculumRepository.loadCourse();
    final result = planner.plan(
      PlanningRequest(
        course: course,
        learnerHistory:
            learnerHistorySummary?.call() ?? const LearnerHistorySummary(),
      ),
    );

    final plan = result.plan;
    if (plan != null) {
      return plan;
    }

    final failure = result.failure;
    throw LessonLaunchException(
      failure?.message ?? 'No lesson could be selected.',
    );
  }
}

class LessonLaunchException implements Exception {
  const LessonLaunchException(this.message);

  final String message;

  @override
  String toString() => message;
}
