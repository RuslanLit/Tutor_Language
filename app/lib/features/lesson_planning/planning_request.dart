import '../../core/learner/learner_state.dart';
import '../curriculum/curriculum_models.dart';
import 'learner_history_summary.dart';
import 'planning_policy.dart';

class PlanningRequest {
  const PlanningRequest({
    required this.course,
    this.learnerState,
    this.learnerHistory = const LearnerHistorySummary(),
    this.policy = const PlanningPolicy(),
  });

  final Course course;
  final LearnerState? learnerState;
  final LearnerHistorySummary learnerHistory;
  final PlanningPolicy policy;
}
