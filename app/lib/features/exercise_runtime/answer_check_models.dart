import '../../core/content/topic_content.dart';

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
    this.acceptedWithFeedbackAnswers = const [],
    this.authoredMisconceptions = const [],
  });

  final String? answerId;
  final String? text;
  final List<String> acceptedTextAnswers;
  final List<AcceptedWithFeedbackAnswer> acceptedWithFeedbackAnswers;
  final List<AuthoredMisconception> authoredMisconceptions;
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
