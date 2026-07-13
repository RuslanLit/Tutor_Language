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
      'spanish.origin.keep_de' => 'Keep "de" in the origin pattern: "soy de".',
      'spanish.origin.use_soy_de' => '"Soy de" tells where someone is from.',
      'spanish.origin_question.include_de' =>
        'Use "¿De dónde eres?" to ask where someone is from.',
      'spanish.residence.use_vivo_en' => '"Vivo en" tells where someone lives.',
      'spanish.residence_question.no_de' =>
        'Use "¿Dónde vives?" to ask where someone lives.',
      'spanish.languages.use_hablo' =>
        'Use "hablo" to say which language you speak.',
      'spanish.languages.use_language_names' =>
        'Use language names such as "ucraniano" or "ruso".',
      'spanish.languages.keep_de_after_un_poco' =>
        'Keep "de" in "un poco de" before the language.',
      'spanish.languages.ask_idiomas' =>
        'Use "idiomas" when asking which languages someone speaks.',
      'spanish.identity.ask_specific_questions' =>
        'Use the question that matches the information you need.',
      'spanish.origin_residence.do_not_swap' =>
        'Do not swap origin and residence: "soy de" is origin, "vivo en" is residence.',
      _ => null,
    };

    if (correction == null) {
      return const [];
    }

    return [correction];
  }
}
