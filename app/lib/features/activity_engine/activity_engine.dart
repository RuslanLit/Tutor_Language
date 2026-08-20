import '../../core/content/topic_content.dart';
import '../answer_evaluation/answer_evaluation.dart';
import 'activity_result.dart';

class ActivityEngine {
  const ActivityEngine({
    this.answerEvaluator = const AnswerEvaluator(),
    this.structuredProductionEvaluator = const StructuredProductionEvaluator(),
  });

  final AnswerEvaluator answerEvaluator;
  final StructuredProductionEvaluator structuredProductionEvaluator;

  ActivityResult evaluate({
    required ExerciseTemplate template,
    required ActivitySubmission submission,
  }) {
    return switch (template.exerciseType) {
      'multiple_choice' => _evaluateMultipleChoice(template, submission),
      'fill_gap' => _evaluateFillGap(template, submission),
      'text_entry' => _evaluateFillGap(template, submission),
      'matching' => _evaluateMatching(template, submission),
      'sentence_builder' => _evaluateSentenceBuilder(template, submission),
      'guided_dialogue' => _evaluateGuidedDialogue(
        template,
        submission,
        dialogueTurnIndex: submission.dialogueTurnIndex ?? 0,
      ),
      _ => ActivityResult(
        exerciseId: template.id,
        isCorrect: false,
        status: ActivityResultStatus.unsupported,
        feedbackKey: 'answer.unsupported',
        feedbackText: 'This activity type is not supported yet.',
      ),
    };
  }

  ActivityResult _evaluateSentenceBuilder(
    ExerciseTemplate template,
    ActivitySubmission submission,
  ) {
    final builder = template.sentenceBuilder;
    final selected = submission.selectedTokenIds ?? const <String>[];
    if (builder == null || builder.acceptedSequences.isEmpty) {
      return ActivityResult(
        exerciseId: template.id,
        isCorrect: false,
        status: ActivityResultStatus.unsupported,
        feedbackKey: 'answer.unsupported',
      );
    }
    final labels = {for (final token in builder.tokens) token.id: token.label};
    final selectedLabels = selected
        .map((id) => labels[id])
        .toList(growable: false);
    final correct = selectedLabels.every((label) => label != null) &&
        builder.acceptedSequences.any((sequence) {
          final expectedLabels = sequence
              .map((id) => labels[id])
              .toList(growable: false);
          return expectedLabels.length == selectedLabels.length &&
              expectedLabels.asMap().entries.every(
                (entry) => entry.value == selectedLabels[entry.key],
              );
        });
    final answer = selectedLabels.map((label) => label ?? '').join(' ');
    final expected = builder.acceptedSequences.first
        .map((id) => labels[id] ?? id)
        .join(' ');
    return ActivityResult(
      exerciseId: template.id,
      isCorrect: correct,
      submittedAnswer: answer,
      expectedAnswer: expected,
      feedbackKey: _feedbackKey(correct),
    );
  }

  ActivityResult _evaluateGuidedDialogue(
    ExerciseTemplate template,
    ActivitySubmission submission, {
    required int dialogueTurnIndex,
  }) {
    final dialogue = template.guidedDialogue;
    final submitted = submission.submittedAnswer ?? '';
    if (dialogue == null || dialogueTurnIndex >= dialogue.turns.length) {
      return ActivityResult(
        exerciseId: template.id,
        isCorrect: false,
        status: ActivityResultStatus.unsupported,
        feedbackKey: 'answer.unsupported',
      );
    }
    final turn = dialogue.turns[dialogueTurnIndex];
    if (!turn.learner || turn.responsePatterns.isEmpty) {
      return ActivityResult(
        exerciseId: template.id,
        isCorrect: false,
        status: ActivityResultStatus.unsupported,
        feedbackKey: 'answer.unsupported',
      );
    }

    if (turn.responseMode == 'prefix' ||
        turn.responseMode == 'prefix_with_value') {
      return _evaluateGuidedConstruction(
        template,
        submitted,
        turn,
        requiresValue: turn.responseMode == 'prefix_with_value',
      );
    }

    final candidates = <String>[];
    for (final pattern in turn.responsePatterns) {
      candidates.addAll(_expandGuidedPattern(pattern, turn.allowedSlots));
    }
    final evaluation = answerEvaluator.evaluateTypedAnswer(
      learnerAnswer: submitted,
      canonicalAnswer: candidates.firstOrNull,
      acceptedAnswers: candidates.skip(1).toList(growable: false),
      allowMeaningSupport: false,
    );
    return ActivityResult(
      exerciseId: template.id,
      isCorrect: evaluation.isAccepted,
      status: _activityStatusFor(evaluation.status),
      submittedAnswer: submitted,
      expectedAnswer: candidates.firstOrNull,
      feedbackKey: evaluation.feedback.key,
      evaluation: evaluation,
    );
  }

  ActivityResult _evaluateGuidedConstruction(
    ExerciseTemplate template,
    String submitted,
    GuidedDialogueTurn turn, {
    required bool requiresValue,
  }) {
    final pattern = turn.responsePatterns.first;
    final placeholder = RegExp(r'\{[^{}]+\}').firstMatch(pattern);
    final authoredPrefix =
        (placeholder == null
                ? pattern
                : pattern.substring(0, placeholder.start))
            .replaceFirst(RegExp(r'[.!?…]+\s*$'), '')
            .trim();
    final normalizedSubmitted = answerEvaluator.normalizer
        .normalize(submitted)
        .value
        .replaceFirst(RegExp(r'[.!?…]+$'), '')
        .trim();
    final normalizedPrefix = answerEvaluator.normalizer
        .normalize(authoredPrefix)
        .value;
    final hasPrefix =
        normalizedSubmitted == normalizedPrefix ||
        normalizedSubmitted.startsWith('$normalizedPrefix ');
    final tail = normalizedSubmitted.length > normalizedPrefix.length
        ? normalizedSubmitted.substring(normalizedPrefix.length).trim()
        : '';
    final meaningfulTail = tail.replaceFirst(RegExp(r'[.!?…]+$'), '').trim();
    final valid = hasPrefix && (!requiresValue || meaningfulTail.isNotEmpty);

    AnswerEvaluationResult evaluation;
    if (valid) {
      final submittedPrefix = submitted
          .trim()
          .split(RegExp(r'\s+'))
          .take(authoredPrefix.split(RegExp(r'\s+')).length)
          .join(' ');
      evaluation = answerEvaluator.evaluateTypedAnswer(
        learnerAnswer: submittedPrefix,
        canonicalAnswer: authoredPrefix,
        allowMeaningSupport: false,
      );
      if (!evaluation.isAccepted) {
        evaluation = answerEvaluator.evaluateTypedAnswer(
          learnerAnswer: authoredPrefix,
          canonicalAnswer: authoredPrefix,
          allowMeaningSupport: false,
        );
      }
    } else {
      evaluation = answerEvaluator.evaluateTypedAnswer(
        learnerAnswer: submitted,
        canonicalAnswer: authoredPrefix,
        allowMeaningSupport: false,
      );
    }
    return ActivityResult(
      exerciseId: template.id,
      isCorrect: evaluation.isAccepted && valid,
      status: _activityStatusFor(
        valid ? evaluation.status : AnswerEvaluationStatus.incorrect,
      ),
      submittedAnswer: submitted,
      expectedAnswer: authoredPrefix,
      feedbackKey: evaluation.feedback.key,
      evaluation: evaluation,
    );
  }

  List<String> _expandGuidedPattern(
    String pattern,
    Map<String, List<String>> slots,
  ) {
    final names = RegExp(r'\{([^{}]+)\}')
        .allMatches(pattern)
        .map((match) => match.group(1)!)
        .toSet()
        .toList(growable: false);
    if (names.any((name) => !slots.containsKey(name))) {
      return const [];
    }
    var values = <String>[pattern];
    for (final name in names) {
      final next = <String>[];
      for (final value in values) {
        for (final option in slots[name]!) {
          next.add(value.replaceFirst('{$name}', option));
        }
      }
      values = next;
    }
    return values;
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
    final evaluation =
        template.productionContract != null &&
            !template.requiresExactAnswer &&
            expected != null
        ? structuredProductionEvaluator.evaluate(
            learnerAnswer: submitted,
            canonicalAnswer: expected,
            contract: template.productionContract!,
          )
        : answerEvaluator.evaluateTypedAnswer(
            learnerAnswer: submitted,
            canonicalAnswer: expected,
            acceptedAnswers: template.acceptedAnswers,
            acceptedWithFeedbackAnswers: template.acceptedWithFeedbackAnswers,
            authoredMisconceptions: template.authoredMisconceptions,
            allowMeaningSupport: !template.requiresExactAnswer,
            multilineLineRange: _multilineLineRange(template.promptTemplate),
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

  ({int minimum, int maximum})? _multilineLineRange(String prompt) {
    final match = RegExp(
      r'(?:Введи|Enter)\s+(\d+)[–-](\d+)\s+(?:коротких\s+реплік|lines)',
      caseSensitive: false,
    ).firstMatch(prompt);
    if (match == null) return null;
    return (
      minimum: int.parse(match.group(1)!),
      maximum: int.parse(match.group(2)!),
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
    return const AnswerNormalizer().normalizeMeaningSupport(value).value;
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
