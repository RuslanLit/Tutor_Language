import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../curriculum/curriculum_repository.dart';
import '../learner_history/learner_history_providers.dart';
import '../lesson_planning/lesson_plan.dart';
import '../lesson_planning/rule_based_lesson_planner.dart';
import 'lesson_launch_service.dart';

final ruleBasedLessonPlannerProvider = Provider<RuleBasedLessonPlanner>((ref) {
  return const RuleBasedLessonPlanner();
});

final lessonLaunchServiceProvider = Provider<LessonLaunchService>((ref) {
  return LessonLaunchService(
    curriculumRepository: CurriculumRepository(),
    planner: ref.watch(ruleBasedLessonPlannerProvider),
    learnerHistorySummary: () {
      return ref.watch(learnerHistoryProjectionProvider).project();
    },
  );
});

final nextLessonPlanProvider = FutureProvider<LessonPlan>((ref) {
  return ref.watch(lessonLaunchServiceProvider).planNextLesson();
});
