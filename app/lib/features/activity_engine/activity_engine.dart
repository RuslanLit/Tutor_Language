import '../../core/content/topic_content.dart';
import '../answer_evaluation/answer_evaluation.dart';
import 'activity_result.dart';

class ActivityEngine {
  const ActivityEngine({this.answerEvaluator = const AnswerEvaluator()});

  final AnswerEvaluator answerEvaluator;

  ActivityResult evaluate({
    required ExerciseTemplate template,
    required ActivitySubmission submission,
  }) {
    return switch (template.exerciseType) {
      'multiple_choice' => _evaluateMultipleChoice(template, submission),
      'fill_gap' => _evaluateFillGap(template, submission),
      'text_entry' => _evaluateFillGap(template, submission),
      'matching' => _evaluateMatching(template, submission),
      _ => ActivityResult(
        exerciseId: template.id,
        isCorrect: false,
        status: ActivityResultStatus.unsupported,
        feedbackKey: 'answer.unsupported',
        feedbackText: 'This activity type is not supported yet.',
      ),
    };
  }

  Map<String, String> expectedMatchingPairs(ExerciseTemplate template) {
    return _parsePairs(template.expectedAnswer);
  }

  ActivityResult _evaluateMultipleChoice(
    ExerciseTemplate template,
    ActivitySubmission submission,
  ) {
    final expected = template.correctOptionId;
    final selected = submission.selectedAnswerId;
    final isCorrect = expected != null && selected == expected;

    return ActivityResult(
      exerciseId: template.id,
      isCorrect: isCorrect,
      selectedAnswer: selected,
      expectedAnswer: expected,
      feedbackKey: _feedbackKey(isCorrect),
    );
  }

  ActivityResult _evaluateFillGap(
    ExerciseTemplate template,
    ActivitySubmission submission,
  ) {
    final expected = template.expectedAnswer;
    final submitted = submission.submittedAnswer ?? '';
    final evaluation = answerEvaluator.evaluateTypedAnswer(
      learnerAnswer: submitted,
      canonicalAnswer: expected,
    );

    return ActivityResult(
      exerciseId: template.id,
      isCorrect: evaluation.isAccepted,
      status: _activityStatusFor(evaluation.status),
      submittedAnswer: submitted,
      expectedAnswer: expected,
      feedbackKey: evaluation.feedback.key,
      evaluation: evaluation,
    );
  }

  ActivityResult _evaluateMatching(
    ExerciseTemplate template,
    ActivitySubmission submission,
  ) {
    final expectedPairs = _parsePairs(template.expectedAnswer);

    if (expectedPairs.isEmpty) {
      final expected = template.correctOptionId;
      final selected = submission.selectedAnswerId;
      final isCorrect = expected != null && selected == expected;

      return ActivityResult(
        exerciseId: template.id,
        isCorrect: isCorrect,
        selectedAnswer: selected,
        expectedAnswer: expected,
        status: expected == null ? ActivityResultStatus.unsupported : null,
        feedbackKey: expected == null
            ? 'answer.unsupported'
            : _feedbackKey(isCorrect),
        feedbackText: expected == null
            ? 'This matching activity is not checkable yet.'
            : null,
      );
    }

    final isCorrect =
        submission.matchedPairs.length == expectedPairs.length &&
        expectedPairs.entries.every((entry) {
          return _normalize(submission.matchedPairs[entry.key] ?? '') ==
              _normalize(entry.value);
        });

    return ActivityResult(
      exerciseId: template.id,
      isCorrect: isCorrect,
      matchedPairs: submission.matchedPairs,
      expectedAnswer: _formatPairs(expectedPairs),
      feedbackKey: _feedbackKey(isCorrect),
    );
  }

  Map<String, String> _parsePairs(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const {};
    }

    final pairs = <String, String>{};
    for (final rawPair in value.split(RegExp(r'[;\n]'))) {
      final separator = rawPair.contains('=>')
          ? '=>'
          : rawPair.contains('=')
          ? '='
          : rawPair.contains(':')
          ? ':'
          : null;

      if (separator == null) {
        continue;
      }

      final parts = rawPair.split(separator);
      if (parts.length < 2) {
        continue;
      }

      final left = parts.first.trim();
      final right = parts.sublist(1).join(separator).trim();
      if (left.isNotEmpty && right.isNotEmpty) {
        pairs[left] = right;
      }
    }

    return Map.unmodifiable(pairs);
  }

  String _formatPairs(Map<String, String> pairs) {
    return pairs.entries
        .map((entry) => '${entry.key} = ${entry.value}')
        .join('; ');
  }

  String _normalize(String value) {
    return const AnswerNormalizer().normalize(value).value;
  }

  String _feedbackKey(bool isCorrect) {
    return isCorrect ? 'answer.correct' : 'answer.incorrect';
  }

  ActivityResultStatus _activityStatusFor(AnswerEvaluationStatus status) {
    return switch (status) {
      AnswerEvaluationStatus.correct => ActivityResultStatus.correct,
      AnswerEvaluationStatus.acceptedWithFeedback =>
        ActivityResultStatus.acceptedWithFeedback,
      AnswerEvaluationStatus.incorrect => ActivityResultStatus.incorrect,
      AnswerEvaluationStatus.unsupported => ActivityResultStatus.unsupported,
    };
  }
}
