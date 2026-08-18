import '../../l10n/generated/app_localizations.dart';
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
    AppLocalizations l10n,
    AnswerEvaluationResult result, {
    int attemptCount = 1,
  }) {
    return switch (result.status) {
      AnswerEvaluationStatus.correct => PresentedAnswerFeedback(
        statusLabel: l10n.correct,
      ),
      AnswerEvaluationStatus.acceptedWithFeedback => PresentedAnswerFeedback(
        statusLabel: l10n.acceptedWithCorrection,
        canonicalAnswer: result.feedback.canonicalAnswer,
        corrections: _acceptedCorrectionsFor(l10n, result.feedback),
      ),
      AnswerEvaluationStatus.incorrect => PresentedAnswerFeedback(
        statusLabel: l10n.notCorrectYet,
        canonicalAnswer: result.feedback.canonicalAnswer,
        corrections: _incorrectCorrectionsFor(
          l10n,
          result.feedback,
          attemptCount: attemptCount,
        ),
      ),
      AnswerEvaluationStatus.unsupported => PresentedAnswerFeedback(
        statusLabel: l10n.unsupportedActivityType,
      ),
    };
  }

  String _correctionFor(AppLocalizations l10n, AnswerDifference difference) {
    final canonical = difference.canonicalFragment ?? '';
    return switch (difference.feedbackKey) {
      'spanish.interrogative.que_requires_accent' =>
        l10n.feedbackSpanishInterrogativeQueRequiresAccent(canonical),
      'spanish.interrogative.como_requires_accent' =>
        l10n.feedbackSpanishInterrogativeComoRequiresAccent(canonical),
      'spanish.missing_diacritic' => l10n.feedbackSpanishMissingDiacritic(
        canonical,
      ),
      'spanish.question.missing_opening_mark' =>
        l10n.feedbackSpanishQuestionMissingOpeningMark,
      'spanish.question.missing_closing_mark' =>
        l10n.feedbackSpanishQuestionMissingClosingMark,
      'spanish.exclamation.missing_opening_mark' =>
        l10n.feedbackSpanishExclamationMissingOpeningMark,
      'spanish.exclamation.missing_closing_mark' =>
        l10n.feedbackSpanishExclamationMissingClosingMark,
      _ => l10n.feedbackUseCanonicalForm(canonical),
    };
  }

  List<String> _acceptedCorrectionsFor(
    AppLocalizations l10n,
    AnswerFeedback feedback,
  ) {
    if (feedback.key == 'answer.preferred_order') {
      final canonical = feedback.canonicalAnswer;
      if (canonical == null || canonical.isEmpty) {
        return [l10n.feedbackPreferredOrderNoCanonical];
      }
      return [l10n.feedbackPreferredOrder(canonical)];
    }

    return feedback.differences
        .map((difference) => _correctionFor(l10n, difference))
        .toList(growable: false);
  }

  List<String> _incorrectCorrectionsFor(
    AppLocalizations l10n,
    AnswerFeedback feedback, {
    required int attemptCount,
  }) {
    final correction = switch (feedback.key) {
      'response.question_expected_statement_provided' =>
        l10n.feedbackQuestionExpectedStatementProvided,
      'response.statement_expected_question_provided' =>
        l10n.feedbackStatementExpectedQuestionProvided,
      'response.answer_expected_question' =>
        l10n.feedbackAnswerExpectedQuestion,
      'response.question_expected_answer' =>
        l10n.feedbackQuestionExpectedAnswer,
      'response.translation_expected_source_language' =>
        l10n.feedbackTranslationExpectedSourceLanguage,
      'response.greeting_expected_farewell' =>
        l10n.feedbackGreetingExpectedFarewell,
      'response.farewell_expected_greeting' =>
        l10n.feedbackFarewellExpectedGreeting,
      'spanish.name_pattern.use_me_llamo' => l10n.feedbackNamePatternUseMeLlamo,
      'spanish.origin.use_ser' => l10n.feedbackOriginUseSer,
      'spanish.origin.keep_de' => l10n.feedbackOriginKeepDe,
      'spanish.origin.use_soy_de' => l10n.feedbackOriginUseSoyDe,
      'spanish.origin_question.include_de' =>
        l10n.feedbackOriginQuestionIncludeDe,
      'spanish.residence.use_vivo_en' => l10n.feedbackResidenceUseVivoEn,
      'spanish.residence_question.no_de' => l10n.feedbackResidenceQuestionNoDe,
      'spanish.languages.use_hablo' => l10n.feedbackLanguagesUseHablo,
      'spanish.languages.use_language_names' =>
        l10n.feedbackLanguagesUseLanguageNames,
      'spanish.languages.keep_de_after_un_poco' =>
        l10n.feedbackLanguagesKeepDeAfterUnPoco,
      'spanish.languages.ask_idiomas' => l10n.feedbackLanguagesAskIdiomas,
      'spanish.identity.ask_specific_questions' =>
        l10n.feedbackIdentityAskSpecificQuestions,
      'spanish.origin_residence.do_not_swap' =>
        l10n.feedbackOriginResidenceDoNotSwap,
      'spanish.people.use_es_for_other' => l10n.feedbackPeopleUseEsForOther,
      'spanish.people.use_se_llama' => l10n.feedbackPeopleUseSeLlama,
      'spanish.people.use_feminine_role' => l10n.feedbackPeopleUseFeminineRole,
      'spanish.people.use_masculine_role' =>
        l10n.feedbackPeopleUseMasculineRole,
      'spanish.people.question_quien_not_como' =>
        l10n.feedbackPeopleQuestionQuienNotComo,
      'spanish.people.question_como_not_quien' =>
        l10n.feedbackPeopleQuestionComoNotQuien,
      'spanish.people.use_feminine_description' =>
        l10n.feedbackPeopleUseFeminineDescription,
      'spanish.people.use_masculine_description' =>
        l10n.feedbackPeopleUseMasculineDescription,
      'spanish.people.use_vive_for_other' => l10n.feedbackPeopleUseViveForOther,
      'spanish.people.use_habla_for_other' =>
        l10n.feedbackPeopleUseHablaForOther,
      'spanish.people.origin_residence_contrast' =>
        l10n.feedbackPeopleOriginResidenceContrast,
      'spanish.people.language_not_nationality' =>
        l10n.feedbackPeopleLanguageNotNationality,
      'spanish.people.third_person_sequence' =>
        l10n.feedbackPeopleThirdPersonSequence,
      'spanish.people.question_order_matters' =>
        l10n.feedbackPeopleQuestionOrderMatters,
      'spanish.people.question_and_person_form' =>
        l10n.feedbackPeopleQuestionAndPersonForm,
      'spanish.shopping.use_que_for_object' =>
        l10n.feedbackShoppingUseQueForObject,
      'spanish.shopping.use_cuanto_for_price' =>
        l10n.feedbackShoppingUseCuantoForPrice,
      'spanish.shopping.use_cuesta_for_price' =>
        l10n.feedbackShoppingUseCuestaForPrice,
      'spanish.shopping.use_polite_tiene' =>
        l10n.feedbackShoppingUsePoliteTiene,
      'spanish.shopping.use_tenemos_for_shop' =>
        l10n.feedbackShoppingUseTenemosForShop,
      'spanish.shopping.use_quiero_for_purchase' =>
        l10n.feedbackShoppingUseQuieroForPurchase,
      'spanish.shopping.use_una_feminine' =>
        l10n.feedbackShoppingUseUnaFeminine,
      'spanish.shopping.use_este_masculine' =>
        l10n.feedbackShoppingUseEsteMasculine,
      'spanish.shopping.use_esta_feminine' =>
        l10n.feedbackShoppingUseEstaFeminine,
      'spanish.shopping.use_masculine_price_adjective' =>
        l10n.feedbackShoppingUseMasculinePriceAdjective,
      'spanish.shopping.use_feminine_price_adjective' =>
        l10n.feedbackShoppingUseFemininePriceAdjective,
      'spanish.transport.use_a_pie' => l10n.feedbackTransportUseAPie,
      'spanish.directions.use_donde_for_location' =>
        l10n.feedbackDirectionsUseDondeForLocation,
      'spanish.directions.use_esta_for_location' =>
        l10n.feedbackDirectionsUseEstaForLocation,
      'spanish.directions.left_not_right' =>
        l10n.feedbackDirectionsLeftNotRight,
      'spanish.directions.right_not_left' =>
        l10n.feedbackDirectionsRightNotLeft,
      'spanish.directions.far_not_near' => l10n.feedbackDirectionsFarNotNear,
      'spanish.directions.use_como_for_route' =>
        l10n.feedbackDirectionsUseComoForRoute,
      'spanish.directions.route_order_matters' =>
        l10n.feedbackDirectionsRouteOrderMatters,
      'spanish.transport.use_toma_for_advice' =>
        l10n.feedbackTransportUseTomaForAdvice,
      'spanish.directions.direction_not_location' =>
        l10n.feedbackDirectionsDirectionNotLocation,
      'spanish.help.polite_opening_first' =>
        l10n.feedbackHelpPoliteOpeningFirst,
      'spanish.help.include_polite_attention' =>
        l10n.feedbackHelpIncludePoliteAttention,
      _ => null,
    };

    if (correction == null) {
      return _structuralCorrections(l10n, feedback);
    }

    return [
      correction,
      ..._progressiveResponseTypeHints(l10n, feedback, attemptCount),
      ..._structuralCorrections(l10n, feedback),
    ];
  }

  List<String> _structuralCorrections(
    AppLocalizations l10n,
    AnswerFeedback feedback,
  ) {
    final structure = feedback.structure;
    if (structure == null) return const [];

    final messages = <String>[];
    final minimum = structure.minimumExpectedLineCount;
    final maximum = structure.maximumExpectedLineCount;
    if (minimum != null && structure.submittedLineCount < minimum) {
      messages.add(
        l10n.feedbackMultilineIncomplete(structure.submittedLineCount),
      );
    } else if (maximum != null && structure.submittedLineCount > maximum) {
      messages.add(l10n.feedbackMultilineTooMany(structure.submittedLineCount));
    } else if (structure.missingLineCount > 0) {
      messages.add(
        l10n.feedbackMultilineMissing(
          structure.submittedLineCount,
          structure.expectedLineCount,
        ),
      );
    } else if (structure.extraLineCount > 0) {
      messages.add(
        l10n.feedbackMultilineExtra(
          structure.submittedLineCount,
          structure.expectedLineCount,
        ),
      );
    }

    if (structure.incorrectLineNumbers.isNotEmpty) {
      messages.add(
        l10n.feedbackMultilineIncorrectLines(
          structure.correctLineNumbers.length,
          structure.expectedLineCount,
          structure.incorrectLineNumbers.join(', '),
        ),
      );
    }
    return messages;
  }

  List<String> _progressiveResponseTypeHints(
    AppLocalizations l10n,
    AnswerFeedback feedback,
    int attemptCount,
  ) {
    if (feedback.key != 'response.question_expected_statement_provided' &&
        feedback.key != 'response.question_expected_answer') {
      if (attemptCount >= 2 &&
          (feedback.key == 'response.answer_expected_question' ||
              feedback.key ==
                  'response.statement_expected_question_provided')) {
        return [l10n.feedbackAnswersUsuallyDoNotBeginQuestionMark];
      }
      return const [];
    }

    final hints = <String>[];
    if (attemptCount >= 2) {
      hints.add(l10n.feedbackQuestionsBeginWith);
    }
    if (attemptCount >= 3) {
      final canonical = feedback.canonicalAnswer;
      if (canonical != null && canonical.trim().isNotEmpty) {
        hints.add(l10n.feedbackStartsWith(_prefixHint(canonical)));
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
