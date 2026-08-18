import '../answer_evaluation/answer_evaluation.dart';

enum ActivityResultStatus {
  correct,
  acceptedWithFeedback,
  incorrect,
  unsupported,
}

class ActivityResult {
  const ActivityResult({
    required this.exerciseId,
    required this.isCorrect,
    ActivityResultStatus? status,
    this.selectedAnswer,
    this.submittedAnswer,
    this.matchedPairs = const {},
    this.expectedAnswer,
    this.feedbackText,
    this.feedbackKey,
    this.evaluation,
  }) : status =
           status ??
           (isCorrect
               ? ActivityResultStatus.correct
               : ActivityResultStatus.incorrect);

  final String exerciseId;
  final bool isCorrect;
  final ActivityResultStatus status;
  final String? selectedAnswer;
  final String? submittedAnswer;
  final Map<String, String> matchedPairs;
  final String? expectedAnswer;
  final String? feedbackText;
  final String? feedbackKey;
  final AnswerEvaluationResult? evaluation;
}

class ActivitySubmission {
  const ActivitySubmission({
    this.selectedAnswerId,
    this.submittedAnswer,
    this.matchedPairs = const {},
    this.dialogueTurnIndex,
  });

  final String? selectedAnswerId;
  final String? submittedAnswer;
  final Map<String, String> matchedPairs;
  final int? dialogueTurnIndex;
}
