class ActivityResult {
  const ActivityResult({
    required this.exerciseId,
    required this.isCorrect,
    this.selectedAnswer,
    this.submittedAnswer,
    this.matchedPairs = const {},
    this.expectedAnswer,
    this.feedbackText,
  });

  final String exerciseId;
  final bool isCorrect;
  final String? selectedAnswer;
  final String? submittedAnswer;
  final Map<String, String> matchedPairs;
  final String? expectedAnswer;
  final String? feedbackText;
}

class ActivitySubmission {
  const ActivitySubmission({
    this.selectedAnswerId,
    this.submittedAnswer,
    this.matchedPairs = const {},
  });

  final String? selectedAnswerId;
  final String? submittedAnswer;
  final Map<String, String> matchedPairs;
}
