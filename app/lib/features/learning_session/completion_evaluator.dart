import '../exercise_runtime/answer_check_models.dart';

enum CompletionStatus { incomplete, completed, insufficientData }

class CompletionEvaluation {
  const CompletionEvaluation({required this.checkedAnswerStatuses});

  final List<AnswerCheckStatus> checkedAnswerStatuses;
}

class CompletionDecision {
  const CompletionDecision({required this.status});

  final CompletionStatus status;

  bool get isCompleted => status == CompletionStatus.completed;
}

class CompletionEvaluator {
  const CompletionEvaluator();

  CompletionDecision evaluate(CompletionEvaluation evaluation) {
    if (evaluation.checkedAnswerStatuses.isEmpty) {
      return const CompletionDecision(status: CompletionStatus.incomplete);
    }

    final allCheckedAnswersCorrect = evaluation.checkedAnswerStatuses.every(
      (status) => status == AnswerCheckStatus.correct,
    );

    return CompletionDecision(
      status: allCheckedAnswersCorrect
          ? CompletionStatus.completed
          : CompletionStatus.incomplete,
    );
  }
}
