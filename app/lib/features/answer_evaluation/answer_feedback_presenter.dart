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

  PresentedAnswerFeedback present(
    AnswerEvaluationResult result, {
    int attemptCount = 1,
  }) {
    return switch (result.status) {
      AnswerEvaluationStatus.correct => const PresentedAnswerFeedback(
        statusLabel: 'Correct',
      ),
      AnswerEvaluationStatus.acceptedWithFeedback => PresentedAnswerFeedback(
        statusLabel: 'Accepted with correction',
        canonicalAnswer: result.feedback.canonicalAnswer,
        corrections: _acceptedCorrectionsFor(result.feedback),
      ),
      AnswerEvaluationStatus.incorrect => PresentedAnswerFeedback(
        statusLabel: 'Not correct yet',
        canonicalAnswer: result.feedback.canonicalAnswer,
        corrections: _incorrectCorrectionsFor(
          result.feedback,
          attemptCount: attemptCount,
        ),
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

  List<String> _acceptedCorrectionsFor(AnswerFeedback feedback) {
    if (feedback.key == 'answer.preferred_order') {
      final canonical = feedback.canonicalAnswer;
      if (canonical == null || canonical.isEmpty) {
        return const ['A different order is accepted here.'];
      }
      return ['A more natural order is: $canonical'];
    }

    return feedback.differences.map(_correctionFor).toList(growable: false);
  }

  List<String> _incorrectCorrectionsFor(
    AnswerFeedback feedback, {
    required int attemptCount,
  }) {
    final correction = switch (feedback.key) {
      'response.question_expected_statement_provided' =>
        'This exercise asks for a question.\nYou wrote an answer.\nTry writing the Spanish question instead.',
      'response.statement_expected_question_provided' =>
        'This exercise asks for a statement.\nYou wrote a question.\nTry writing the Spanish statement instead.',
      'response.answer_expected_question' =>
        'This exercise asks for an answer.\nYou wrote another question.',
      'response.question_expected_answer' =>
        'Write the question, not the answer.',
      'response.translation_expected_source_language' =>
        'Translate the prompt instead of copying it.',
      'response.greeting_expected_farewell' =>
        'This exercise asks for a greeting.\nYou wrote a farewell.',
      'response.farewell_expected_greeting' =>
        'This exercise asks for a farewell.\nYou wrote a greeting.',
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
      'spanish.people.use_es_for_other' =>
        'Use "es" when speaking about another person.',
      'spanish.people.use_se_llama' =>
        'Use "se llama" to say another person’s name.',
      'spanish.people.use_feminine_role' =>
        'Use the feminine role form for this person.',
      'spanish.people.use_masculine_role' =>
        'Use the masculine role form for this person.',
      'spanish.people.question_quien_not_como' =>
        '"¿Quién es?" asks who the person is.',
      'spanish.people.question_como_not_quien' =>
        '"¿Cómo es?" asks what the person is like.',
      'spanish.people.use_feminine_description' =>
        'Use the feminine description form for this person.',
      'spanish.people.use_masculine_description' =>
        'Use the masculine description form for this person.',
      'spanish.people.use_vive_for_other' =>
        'Use "vive" for where another person lives.',
      'spanish.people.use_habla_for_other' =>
        'Use "habla" for what another person speaks.',
      'spanish.people.origin_residence_contrast' =>
        '"Es de" tells origin; "vive en" tells residence.',
      'spanish.people.language_not_nationality' =>
        'Use "habla" to say which language another person speaks.',
      'spanish.people.third_person_sequence' =>
        'Keep the whole answer in third person for another person.',
      'spanish.people.question_order_matters' =>
        'Use the questions in the order requested by the prompt.',
      'spanish.people.question_and_person_form' =>
        'Use the requested question and third-person verb form.',
      'spanish.shopping.use_que_for_object' =>
        'Use "¿Qué es esto?" to ask what the object is.',
      'spanish.shopping.use_cuanto_for_price' =>
        'Use "¿Cuánto cuesta?" to ask the price.',
      'spanish.shopping.use_cuesta_for_price' =>
        'Use "cuesta" when stating the price of one item.',
      'spanish.shopping.use_polite_tiene' =>
        'Use the polite shop question "¿Tiene...?" in this module.',
      'spanish.shopping.use_tenemos_for_shop' =>
        'Use "tenemos" when the shop says what it has.',
      'spanish.shopping.use_quiero_for_purchase' =>
        'Use "quiero" to say what you want to buy.',
      'spanish.shopping.use_una_feminine' =>
        'Use "una" with a practiced feminine noun such as "botella" or "bolsa".',
      'spanish.shopping.use_este_masculine' =>
        'Use "este" before a practiced masculine noun such as "libro".',
      'spanish.shopping.use_esta_feminine' =>
        'Use "esta" before a practiced feminine noun such as "bolsa".',
      'spanish.shopping.use_masculine_price_adjective' =>
        'Use the masculine adjective form with this masculine object.',
      'spanish.shopping.use_feminine_price_adjective' =>
        'Use the feminine adjective form with this feminine object.',
      _ => null,
    };

    if (correction == null) {
      return const [];
    }

    return [
      correction,
      ..._progressiveResponseTypeHints(feedback, attemptCount),
    ];
  }

  List<String> _progressiveResponseTypeHints(
    AnswerFeedback feedback,
    int attemptCount,
  ) {
    if (feedback.key != 'response.question_expected_statement_provided' &&
        feedback.key != 'response.question_expected_answer') {
      if (attemptCount >= 2 &&
          (feedback.key == 'response.answer_expected_question' ||
              feedback.key ==
                  'response.statement_expected_question_provided')) {
        return ['Answers and statements usually do not begin with "¿".'];
      }
      return const [];
    }

    final hints = <String>[];
    if (attemptCount >= 2) {
      hints.add('Questions begin with: ¿...');
    }
    if (attemptCount >= 3) {
      final canonical = feedback.canonicalAnswer;
      if (canonical != null && canonical.trim().isNotEmpty) {
        hints.add('Starts with: ${_prefixHint(canonical)}');
      }
    }
    return hints;
  }

  String _prefixHint(String canonicalAnswer) {
    final trimmed = canonicalAnswer.trim();
    if (trimmed.length <= 3) {
      return trimmed;
    }
    return trimmed.substring(0, 3);
  }
}
