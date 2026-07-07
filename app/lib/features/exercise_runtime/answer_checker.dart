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
  const AnswerChecker();

  AnswerCheckResult check(AnswerCheckInput input) {
    final response = input.response;

    if (response == null) {
      return const AnswerCheckResult(status: AnswerCheckStatus.unchecked);
    }

    return switch (input.item.interactionType) {
      'multiple_choice' => _checkMultipleChoice(input, response),
      'text_entry' => _checkTextEntry(input, response),
      _ => const AnswerCheckResult(status: AnswerCheckStatus.unsupported),
    };
  }

  AnswerCheckResult _checkMultipleChoice(
    AnswerCheckInput input,
    ExerciseResponse response,
  ) {
    final expectedAnswerId = input.expectedAnswer.answerId;

    if (expectedAnswerId == null) {
      return const AnswerCheckResult(status: AnswerCheckStatus.unsupported);
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

    if (expectedText == null) {
      return const AnswerCheckResult(status: AnswerCheckStatus.unsupported);
    }

    return AnswerCheckResult(
      status: _normalize(response.answer.label) == _normalize(expectedText)
          ? AnswerCheckStatus.correct
          : AnswerCheckStatus.incorrect,
    );
  }

  String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }
}
