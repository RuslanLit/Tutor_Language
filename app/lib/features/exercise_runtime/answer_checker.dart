import '../answer_evaluation/answer_evaluation.dart';
import 'answer_check_models.dart';
import 'exercise_runtime_models.dart';

class AnswerCheckInput {
  const AnswerCheckInput({
    required this.item,
    required this.response,
    required this.expectedAnswer,
  });

  final ExerciseItem item;
  final ExerciseResponse? response;
  final ExpectedAnswer expectedAnswer;
}

class AnswerChecker {
  const AnswerChecker({this.answerEvaluator = const AnswerEvaluator()});

  final AnswerEvaluator answerEvaluator;

  AnswerCheckResult check(AnswerCheckInput input) {
    final response = input.response;

    if (response == null) {
      return const AnswerCheckResult(status: AnswerCheckStatus.unchecked);
    }

    return switch (input.item.interactionType) {
      'multiple_choice' => _checkMultipleChoice(input, response),
      'text_entry' => _checkTextEntry(input, response),
      _ => const AnswerCheckResult(
        status: AnswerCheckStatus.unsupported,
        feedbackKey: 'answer.unsupported',
      ),
    };
  }

  AnswerCheckResult _checkMultipleChoice(
    AnswerCheckInput input,
    ExerciseResponse response,
  ) {
    final expectedAnswerId = input.expectedAnswer.answerId;

    if (expectedAnswerId == null) {
      return const AnswerCheckResult(
        status: AnswerCheckStatus.unsupported,
        feedbackKey: 'answer.unsupported',
      );
    }

    return AnswerCheckResult(
      status: response.answer.id == expectedAnswerId
          ? AnswerCheckStatus.correct
          : AnswerCheckStatus.incorrect,
    );
  }

  AnswerCheckResult _checkTextEntry(
    AnswerCheckInput input,
    ExerciseResponse response,
  ) {
    final expectedText = input.expectedAnswer.text;

    final result = answerEvaluator.evaluateTypedAnswer(
      learnerAnswer: response.answer.label,
      canonicalAnswer: expectedText,
      acceptedAnswers: input.expectedAnswer.acceptedTextAnswers,
      authoredMisconceptions: input.expectedAnswer.authoredMisconceptions,
    );

    return AnswerCheckResult(
      status: _statusFor(result.status),
      feedbackKey: result.feedback.key,
      explanationReference: result.feedback.explanationReference,
    );
  }

  AnswerCheckStatus _statusFor(AnswerEvaluationStatus status) {
    return switch (status) {
      AnswerEvaluationStatus.correct => AnswerCheckStatus.correct,
      AnswerEvaluationStatus.acceptedWithFeedback =>
        AnswerCheckStatus.acceptedWithFeedback,
      AnswerEvaluationStatus.incorrect => AnswerCheckStatus.incorrect,
      AnswerEvaluationStatus.unsupported => AnswerCheckStatus.unsupported,
    };
  }
}
