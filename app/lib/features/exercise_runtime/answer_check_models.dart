enum AnswerCheckStatus {
  unchecked,
  correct,
  acceptedWithFeedback,
  incorrect,
  unsupported,
}

class ExpectedAnswer {
  const ExpectedAnswer({
    this.answerId,
    this.text,
    this.acceptedTextAnswers = const [],
  });

  final String? answerId;
  final String? text;
  final List<String> acceptedTextAnswers;
}

class AnswerCheckResult {
  const AnswerCheckResult({
    required this.status,
    this.feedbackKey,
    this.explanationReference,
  });

  final AnswerCheckStatus status;
  final String? feedbackKey;
  final String? explanationReference;
}
