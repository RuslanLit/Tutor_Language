enum AnswerEvaluationStatus {
  correct,
  acceptedWithFeedback,
  incorrect,
  unsupported,
}

enum AnswerMatchType {
  exactCanonical,
  normalizedCanonical,
  acceptedAlternative,
  acceptedAlternativeWithFeedback,
  orthographicEquivalent,
  authoredMisconception,
  none,
}

enum AnswerDifferenceType {
  missingDiacritic,
  incorrectDiacritic,
  missingOpeningQuestionMark,
  missingClosingQuestionMark,
  missingOpeningExclamationMark,
  missingClosingExclamationMark,
}

class NormalizedAnswer {
  const NormalizedAnswer({required this.raw, required this.value});

  final String raw;
  final String value;
}

class ExpectedAnswerSet {
  const ExpectedAnswerSet({
    required this.canonicalAnswer,
    this.acceptedAnswers = const [],
  });

  final String canonicalAnswer;
  final List<String> acceptedAnswers;
}

class AnswerComparison {
  const AnswerComparison({required this.matchType});

  final AnswerMatchType matchType;

  bool get isMatch => matchType != AnswerMatchType.none;
}

class AnswerDifference {
  const AnswerDifference({
    required this.type,
    required this.feedbackKey,
    this.learnerFragment,
    this.canonicalFragment,
  });

  final AnswerDifferenceType type;
  final String feedbackKey;
  final String? learnerFragment;
  final String? canonicalFragment;
}

class AnswerFeedback {
  const AnswerFeedback({
    required this.key,
    this.canonicalAnswer,
    this.differences = const [],
    this.misconceptionId,
    this.explanationReference,
  });

  final String key;
  final String? canonicalAnswer;
  final List<AnswerDifference> differences;
  final String? misconceptionId;
  final String? explanationReference;
}

class AnswerEvaluationResult {
  const AnswerEvaluationResult({
    required this.status,
    required this.feedback,
    required this.matchType,
    this.normalizedLearnerAnswer,
    this.normalizedCanonicalAnswer,
  });

  final AnswerEvaluationStatus status;
  final AnswerFeedback feedback;
  final AnswerMatchType matchType;
  final String? normalizedLearnerAnswer;
  final String? normalizedCanonicalAnswer;

  bool get isCorrect => status == AnswerEvaluationStatus.correct;

  bool get isAccepted =>
      status == AnswerEvaluationStatus.correct ||
      status == AnswerEvaluationStatus.acceptedWithFeedback;
}
