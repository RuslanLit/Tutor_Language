enum AnswerCheckStatus { unchecked, correct, incorrect, unsupported }

class ExpectedAnswer {
  const ExpectedAnswer({this.answerId, this.text});

  final String? answerId;
  final String? text;
}

class AnswerCheckResult {
  const AnswerCheckResult({required this.status});

  final AnswerCheckStatus status;
}
