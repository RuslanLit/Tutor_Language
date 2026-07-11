import 'answer_evaluation_models.dart';

class PresentedAnswerFeedback {
  const PresentedAnswerFeedback({
    required this.statusLabel,
    this.canonicalAnswer,
    this.corrections = const [],
  });

  final String statusLabel;
  final String? canonicalAnswer;
  final List<String> corrections;
}

class AnswerFeedbackPresenter {
  const AnswerFeedbackPresenter();

  PresentedAnswerFeedback present(AnswerEvaluationResult result) {
    return switch (result.status) {
      AnswerEvaluationStatus.correct => const PresentedAnswerFeedback(
        statusLabel: 'Correct',
      ),
      AnswerEvaluationStatus.acceptedWithFeedback => PresentedAnswerFeedback(
        statusLabel: 'Accepted with correction',
        canonicalAnswer: result.feedback.canonicalAnswer,
        corrections: result.feedback.differences
            .map(_correctionFor)
            .toList(growable: false),
      ),
      AnswerEvaluationStatus.incorrect => PresentedAnswerFeedback(
        statusLabel: 'Not correct yet',
        canonicalAnswer: result.feedback.canonicalAnswer,
        corrections: _incorrectCorrectionsFor(result.feedback),
      ),
      AnswerEvaluationStatus.unsupported => const PresentedAnswerFeedback(
        statusLabel: 'Unsupported activity type',
      ),
    };
  }

  String _correctionFor(AnswerDifference difference) {
    final canonical = difference.canonicalFragment;
    return switch (difference.feedbackKey) {
      'spanish.interrogative.que_requires_accent' =>
        '"$canonical" requires an accent in this question.',
      'spanish.interrogative.como_requires_accent' =>
        '"$canonical" requires an accent in this question.',
      'spanish.missing_diacritic' =>
        'Canonical Spanish spelling: "$canonical".',
      'spanish.question.missing_opening_mark' =>
        'Spanish questions begin with "¿".',
      'spanish.question.missing_closing_mark' =>
        'Spanish questions end with "?".',
      'spanish.exclamation.missing_opening_mark' =>
        'Spanish exclamations begin with "¡".',
      'spanish.exclamation.missing_closing_mark' =>
        'Spanish exclamations end with "!".',
      _ => 'Use the canonical form: "$canonical".',
    };
  }

  List<String> _incorrectCorrectionsFor(AnswerFeedback feedback) {
    final correction = switch (feedback.key) {
      'spanish.name_pattern.use_me_llamo' =>
        'For this introduction pattern, use "me llamo".',
      'spanish.origin.use_ser' => 'To state origin, Spanish uses "soy de".',
      _ => null,
    };

    if (correction == null) {
      return const [];
    }

    return [correction];
  }
}
