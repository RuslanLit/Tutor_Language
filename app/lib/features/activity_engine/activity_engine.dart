import '../../core/content/topic_content.dart';
import 'activity_result.dart';

class ActivityEngine {
  const ActivityEngine();

  ActivityResult evaluate({
    required ExerciseTemplate template,
    required ActivitySubmission submission,
  }) {
    return switch (template.exerciseType) {
      'multiple_choice' => _evaluateMultipleChoice(template, submission),
      'fill_gap' => _evaluateFillGap(template, submission),
      'matching' => _evaluateMatching(template, submission),
      _ => ActivityResult(
        exerciseId: template.id,
        isCorrect: false,
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
      feedbackText: _feedback(isCorrect),
    );
  }

  ActivityResult _evaluateFillGap(
    ExerciseTemplate template,
    ActivitySubmission submission,
  ) {
    final expected = template.expectedAnswer;
    final submitted = submission.submittedAnswer ?? '';
    final isCorrect =
        expected != null && _normalize(submitted) == _normalize(expected);

    return ActivityResult(
      exerciseId: template.id,
      isCorrect: isCorrect,
      submittedAnswer: submitted,
      expectedAnswer: expected,
      feedbackText: _feedback(isCorrect),
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
        feedbackText: expected == null
            ? 'This matching activity is not checkable yet.'
            : _feedback(isCorrect),
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
      feedbackText: _feedback(isCorrect),
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
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  String _feedback(bool isCorrect) {
    return isCorrect ? 'Correct' : 'Try again';
  }
}
