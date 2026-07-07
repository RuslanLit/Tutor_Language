import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/features/exercise_runtime/answer_check_models.dart';
import 'package:tutor_language/features/learning_session/completion_evaluator.dart';

void main() {
  const evaluator = CompletionEvaluator();

  test('no checked answers returns incomplete', () {
    final decision = evaluator.evaluate(
      const CompletionEvaluation(checkedAnswerStatuses: []),
    );

    expect(decision.status, CompletionStatus.incomplete);
  });

  test('one correct checked answer returns completed', () {
    final decision = evaluator.evaluate(
      const CompletionEvaluation(
        checkedAnswerStatuses: [AnswerCheckStatus.correct],
      ),
    );

    expect(decision.status, CompletionStatus.completed);
  });

  test('one incorrect checked answer returns incomplete', () {
    final decision = evaluator.evaluate(
      const CompletionEvaluation(
        checkedAnswerStatuses: [AnswerCheckStatus.incorrect],
      ),
    );

    expect(decision.status, CompletionStatus.incomplete);
  });

  test('mixed checked answers return incomplete', () {
    final decision = evaluator.evaluate(
      const CompletionEvaluation(
        checkedAnswerStatuses: [
          AnswerCheckStatus.correct,
          AnswerCheckStatus.incorrect,
        ],
      ),
    );

    expect(decision.status, CompletionStatus.incomplete);
  });
}
