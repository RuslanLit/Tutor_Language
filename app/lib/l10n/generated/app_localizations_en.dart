// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tutor Language';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get backTooltip => 'Back';

  @override
  String get backToCourse => 'Back to course';

  @override
  String get openCourse => 'Open course';

  @override
  String get courseTitle => 'Course';

  @override
  String courseProgress(int completed, int total) {
    return '$completed of $total lessons completed';
  }

  @override
  String get courseComplete => 'Course complete';

  @override
  String get noUnitsAvailable => 'No units available.';

  @override
  String get noLessonsAvailable => 'No lessons available.';

  @override
  String get lessonStatusCompleted => 'Completed';

  @override
  String get lessonStatusAvailableNext => 'Available next';

  @override
  String get lessonStatusLocked => 'Locked';

  @override
  String moduleNumber(String number) {
    return 'Module $number';
  }

  @override
  String lessonNumber(String number) {
    return 'Lesson $number';
  }

  @override
  String get competencyCheck => 'Communicative competency check';

  @override
  String get competencyAchieved => 'Communicative competency achieved';

  @override
  String get competencyAchievedAfterReview =>
      'Communicative competency achieved after review';

  @override
  String get competencyNeedsPractice =>
      'Communicative competency needs more practice';

  @override
  String get competencyNotYetAchieved =>
      'Communicative competency not yet achieved';

  @override
  String get competencyCompleteModuleFirst => 'Complete this module first';

  @override
  String get competencyReadyToStart => 'Ready to start';

  @override
  String get competencyContinueCheck => 'Continue your check';

  @override
  String get competencyGoalDemonstrated => 'You demonstrated this module goal';

  @override
  String get competencySucceededAfterReview =>
      'You succeeded after targeted review';

  @override
  String get competencyRetryWhenReady => 'Retry the check when ready';

  @override
  String get start => 'Start';

  @override
  String get continueAction => 'Continue';

  @override
  String get retry => 'Retry';

  @override
  String get lessonTitle => 'Lesson';

  @override
  String get previousLesson => 'Previous lesson';

  @override
  String get nextLesson => 'Next lesson';

  @override
  String lessonLaunchError(String error) {
    return 'Unable to launch lesson.\n$error';
  }

  @override
  String get lessonPlayerTitle => 'Lesson Player';

  @override
  String get leaveLessonTitle => 'Leave lesson?';

  @override
  String get leaveLessonBody =>
      'This unfinished lesson will restart when you open it again.';

  @override
  String get stay => 'Stay';

  @override
  String get leaveLesson => 'Leave lesson';

  @override
  String get noActivitiesAvailable => 'No activities available.';

  @override
  String get previous => '← Previous';

  @override
  String get next => 'Next →';

  @override
  String stepCounter(int current, int total) {
    return 'Step $current / $total';
  }

  @override
  String get finishLesson => 'Finish Lesson';

  @override
  String get finishing => 'Finishing...';

  @override
  String get completionSaveError =>
      'Could not save lesson completion. Please try again.';

  @override
  String get lessonCompleted => 'Lesson completed';

  @override
  String get continueToNextLesson => 'Continue to next lesson';

  @override
  String get repeatLesson => 'Repeat lesson';

  @override
  String get repeatFromStep => 'Repeat from a step';

  @override
  String get repeatCheckpoint => 'Repeat checkpoint';

  @override
  String get reviewCompletedLessons => 'Review completed lessons';

  @override
  String get someTopicsNeedReinforcement =>
      'Some topics will need reinforcement.';

  @override
  String get lessonMasteredOutcome => 'Strong mastery demonstrated.';

  @override
  String get lessonReinforcementOutcome => 'Completed with reinforcement.';

  @override
  String get lessonIncompleteOutcome => 'Lesson outcome incomplete.';

  @override
  String get lessonMastered => 'Lesson mastered';

  @override
  String get courseCompletionRecommended =>
      'Course complete. Keep reviewing completed lessons.';

  @override
  String get quickReview => 'Quick Review';

  @override
  String get mastered => 'Mastered';

  @override
  String get fragileMastery => 'Good work. This needs a little more practice.';

  @override
  String unsupportedContent(String type) {
    return 'Unsupported content: $type';
  }

  @override
  String get buildsOnEarlierMaterial => 'Builds on earlier material.';

  @override
  String get stepTypeVocabulary => 'vocabulary';

  @override
  String get stepTypeGrammar => 'grammar';

  @override
  String get stepTypeDialogue => 'dialogue';

  @override
  String get stepTypeReading => 'reading';

  @override
  String get stepTypeExercise => 'exercise';

  @override
  String get stepTypeMixed => 'mixed';

  @override
  String get answerLabel => 'Answer';

  @override
  String get sentenceBuilderAnswer => 'Your answer';

  @override
  String get sentenceBuilderAvailableWords => 'Available words';

  @override
  String get sentenceBuilderClear => 'Clear';

  @override
  String get learnerSpeakerLabel => 'You';

  @override
  String get checkAnswer => 'Check';

  @override
  String dialogueProgress(int current, int total) {
    return 'Dialogue $current / $total';
  }

  @override
  String selectedAnswer(String answer) {
    return 'Selected answer: $answer';
  }

  @override
  String get correct => 'Correct';

  @override
  String get acceptedWithCorrection => 'Accepted with correction';

  @override
  String get tryAgain => 'Try again';

  @override
  String get notCorrectYet => 'Not correct yet';

  @override
  String get incorrect => 'Incorrect';

  @override
  String feedbackMultilineMissing(int submitted, int expected) {
    return 'You entered $submitted of $expected lines. Complete the dialogue.';
  }

  @override
  String feedbackMultilineExtra(int submitted, int expected) {
    return 'You entered $submitted lines instead of $expected. Check the dialogue.';
  }

  @override
  String feedbackMultilineIncorrectLines(
    int correct,
    int expected,
    String lines,
  ) {
    return '$correct of $expected lines are correct. Check lines: $lines.';
  }

  @override
  String feedbackMultilineIncomplete(int submitted) {
    return 'You entered $submitted lines. Complete the dialogue.';
  }

  @override
  String feedbackMultilineTooMany(int submitted) {
    return 'You entered $submitted lines. Check the dialogue.';
  }

  @override
  String get unsupportedActivityType => 'Unsupported activity type';

  @override
  String unsupportedActivityTypeValue(String type) {
    return 'Unsupported activity type: $type';
  }

  @override
  String get matchingNotCheckableYet =>
      'This matching activity is not checkable yet.';

  @override
  String recommendedAnswer(String answer) {
    return 'Recommended answer: $answer';
  }

  @override
  String feedbackBullet(String message) {
    return '- $message';
  }

  @override
  String exercisePromptSemantics(String prompt) {
    return 'Exercise prompt: $prompt';
  }

  @override
  String get settingsTitle => 'About and Settings';

  @override
  String get releaseStatusLabel => 'Early public release';

  @override
  String get releaseScopeLabel => 'Offline Spanish A0 course';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacyOffline => 'Works offline.';

  @override
  String get privacyNoAccount => 'No account is required.';

  @override
  String get privacyNoTracking => 'No ads, tracking, or analytics are used.';

  @override
  String get privacyNoAi => 'No AI service is contacted during lessons.';

  @override
  String get privacyLocalProgress => 'Learner progress stays on this device.';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackBody =>
      'For this early release, report issues through the project repository or directly to the project maintainer.';

  @override
  String get licensesTitle => 'Licenses and Credits';

  @override
  String get licensesBody =>
      'Tutor Language is built with Flutter and includes authored Spanish A0 educational content. Full license and third-party credit information will be included with the public release package.';

  @override
  String get competencyScreenTitle => 'Competency Check';

  @override
  String get competencyUnavailable => 'Competency check unavailable.';

  @override
  String competencyUnavailableWithError(String error) {
    return 'Competency check unavailable. $error';
  }

  @override
  String get competencyTaskUnavailable =>
      'This competency task is unavailable.';

  @override
  String get competencyDiagnosticIntro => 'Show what you can do without help.';

  @override
  String get competencyRetryIntro => 'Try the original task again.';

  @override
  String get competencyRecoveryIntro =>
      'Let\'s briefly review one part and try again.';

  @override
  String get startReview => 'Start review';

  @override
  String get recoveryActivityUnavailable => 'Recovery activity unavailable.';

  @override
  String get competencyCheckComplete => 'Competency check complete.';

  @override
  String get retryCompetencyCheck => 'Retry competency check';

  @override
  String get competencyAchievedTitle => 'Competency achieved';

  @override
  String get competencyAchievedAfterReviewTitle =>
      'Competency achieved after review';

  @override
  String get competencyNeedsPracticeTitle => 'Competency needs more practice';

  @override
  String get competencyNotYetAchievedTitle => 'Competency not yet achieved';

  @override
  String get competencyAchievedDescription =>
      'You completed the communicative task independently.';

  @override
  String get competencyAchievedAfterReviewDescription =>
      'You used review and then completed the communicative task.';

  @override
  String get competencyNeedsPracticeDescription =>
      'You demonstrated part of the goal. Retry when ready.';

  @override
  String get competencyNotYetAchievedDescription =>
      'The core goal is not secure yet. Retry after review.';

  @override
  String get notViewed => 'Not viewed';

  @override
  String get viewed => 'Viewed';

  @override
  String activitiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count activities',
      one: '1 activity',
      zero: 'No activities',
    );
    return '$_temp0';
  }

  @override
  String get noAnswerChoices =>
      'No answer choices are bundled with this template.';

  @override
  String get unchecked => 'Unchecked';

  @override
  String templateType(String type) {
    return 'Type: $type';
  }

  @override
  String templatePrompt(String prompt) {
    return 'Prompt: $prompt';
  }

  @override
  String requiredObjectTypesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count required object types',
      one: '1 required object type',
      zero: 'No required object types',
    );
    return '$_temp0';
  }

  @override
  String supportedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count supported goals',
      one: '1 supported goal',
      zero: 'No supported goals',
    );
    return '$_temp0';
  }

  @override
  String get feedbackPreferredOrderNoCanonical =>
      'A different order is accepted here.';

  @override
  String feedbackPreferredOrder(String answer) {
    return 'A more natural order is: $answer';
  }

  @override
  String feedbackSpanishInterrogativeQueRequiresAccent(String canonical) {
    return '\"$canonical\" requires an accent in this question.';
  }

  @override
  String feedbackSpanishInterrogativeComoRequiresAccent(String canonical) {
    return '\"$canonical\" requires an accent in this question.';
  }

  @override
  String feedbackSpanishMissingDiacritic(String canonical) {
    return 'Canonical Spanish spelling: \"$canonical\".';
  }

  @override
  String get feedbackSpanishQuestionMissingOpeningMark =>
      'Spanish questions begin with \"¿\".';

  @override
  String get feedbackSpanishQuestionMissingClosingMark =>
      'Spanish questions end with \"?\".';

  @override
  String get feedbackSpanishExclamationMissingOpeningMark =>
      'Spanish exclamations begin with \"¡\".';

  @override
  String get feedbackSpanishExclamationMissingClosingMark =>
      'Spanish exclamations end with \"!\".';

  @override
  String feedbackUseCanonicalForm(String canonical) {
    return 'Use the canonical form: \"$canonical\".';
  }

  @override
  String get feedbackQuestionExpectedStatementProvided =>
      'This exercise asks for a question.\nYou wrote an answer.\nTry writing the Spanish question instead.';

  @override
  String get feedbackStatementExpectedQuestionProvided =>
      'This exercise asks for a statement.\nYou wrote a question.\nTry writing the Spanish statement instead.';

  @override
  String get feedbackAnswerExpectedQuestion =>
      'This exercise asks for an answer.\nYou wrote another question.';

  @override
  String get feedbackQuestionExpectedAnswer =>
      'Write the question, not the answer.';

  @override
  String get feedbackTranslationExpectedSourceLanguage =>
      'Translate the prompt instead of copying it.';

  @override
  String get feedbackGreetingExpectedFarewell =>
      'This exercise asks for a greeting.\nYou wrote a farewell.';

  @override
  String get feedbackFarewellExpectedGreeting =>
      'This exercise asks for a farewell.\nYou wrote a greeting.';

  @override
  String get feedbackNamePatternUseMeLlamo =>
      'For this introduction pattern, use \"me llamo\".';

  @override
  String get feedbackOriginUseSer =>
      'To state origin, Spanish uses \"soy de\".';

  @override
  String get feedbackOriginKeepDe =>
      'Keep \"de\" in the origin pattern: \"soy de\".';

  @override
  String get feedbackOriginUseSoyDe =>
      '\"Soy de\" tells where someone is from.';

  @override
  String get feedbackOriginQuestionIncludeDe =>
      'Use \"¿De dónde eres?\" to ask where someone is from.';

  @override
  String get feedbackResidenceUseVivoEn =>
      '\"Vivo en\" tells where someone lives.';

  @override
  String get feedbackResidenceQuestionNoDe =>
      'Use \"¿Dónde vives?\" to ask where someone lives.';

  @override
  String get feedbackLanguagesUseHablo =>
      'Use \"hablo\" to say which language you speak.';

  @override
  String get feedbackLanguagesUseLanguageNames =>
      'Use language names such as \"ucraniano\" or \"ruso\".';

  @override
  String get feedbackLanguagesKeepDeAfterUnPoco =>
      'Keep \"de\" in \"un poco de\" before the language.';

  @override
  String get feedbackLanguagesAskIdiomas =>
      'Use \"idiomas\" when asking which languages someone speaks.';

  @override
  String get feedbackIdentityAskSpecificQuestions =>
      'Use the question that matches the information you need.';

  @override
  String get feedbackOriginResidenceDoNotSwap =>
      'Do not swap origin and residence: \"soy de\" is origin, \"vivo en\" is residence.';

  @override
  String get feedbackPeopleUseEsForOther =>
      'Use \"es\" when speaking about another person.';

  @override
  String get feedbackPeopleUseSeLlama =>
      'Use \"se llama\" to say another person’s name.';

  @override
  String get feedbackPeopleUseFeminineRole =>
      'Use the feminine role form for this person.';

  @override
  String get feedbackPeopleUseMasculineRole =>
      'Use the masculine role form for this person.';

  @override
  String get feedbackPeopleQuestionQuienNotComo =>
      '\"¿Quién es?\" asks who the person is.';

  @override
  String get feedbackPeopleQuestionComoNotQuien =>
      '\"¿Cómo es?\" asks what the person is like.';

  @override
  String get feedbackPeopleUseFeminineDescription =>
      'Use the feminine description form for this person.';

  @override
  String get feedbackPeopleUseMasculineDescription =>
      'Use the masculine description form for this person.';

  @override
  String get feedbackPeopleUseViveForOther =>
      'Use \"vive\" for where another person lives.';

  @override
  String get feedbackPeopleUseHablaForOther =>
      'Use \"habla\" for what another person speaks.';

  @override
  String get feedbackPeopleOriginResidenceContrast =>
      '\"Es de\" tells origin; \"vive en\" tells residence.';

  @override
  String get feedbackPeopleLanguageNotNationality =>
      'Use \"habla\" to say which language another person speaks.';

  @override
  String get feedbackPeopleThirdPersonSequence =>
      'Keep the whole answer in third person for another person.';

  @override
  String get feedbackPeopleQuestionOrderMatters =>
      'Use the questions in the order requested by the prompt.';

  @override
  String get feedbackPeopleQuestionAndPersonForm =>
      'Use the requested question and third-person verb form.';

  @override
  String get feedbackShoppingUseQueForObject =>
      'Use \"¿Qué es esto?\" to ask what the object is.';

  @override
  String get feedbackShoppingUseCuantoForPrice =>
      'Use \"¿Cuánto cuesta?\" to ask the price.';

  @override
  String get feedbackShoppingUseCuestaForPrice =>
      'Use \"cuesta\" when stating the price of one item.';

  @override
  String get feedbackShoppingUsePoliteTiene =>
      'Use the polite shop question \"¿Tiene...?\" in this module.';

  @override
  String get feedbackShoppingUseTenemosForShop =>
      'Use \"tenemos\" when the shop says what it has.';

  @override
  String get feedbackShoppingUseQuieroForPurchase =>
      'Use \"quiero\" to say what you want to buy.';

  @override
  String get feedbackShoppingUseUnaFeminine =>
      'Use \"una\" with a practiced feminine noun such as \"botella\" or \"bolsa\".';

  @override
  String get feedbackShoppingUseEsteMasculine =>
      'Use \"este\" before a practiced masculine noun such as \"libro\".';

  @override
  String get feedbackShoppingUseEstaFeminine =>
      'Use \"esta\" before a practiced feminine noun such as \"bolsa\".';

  @override
  String get feedbackShoppingUseMasculinePriceAdjective =>
      'Use the masculine adjective form with this masculine object.';

  @override
  String get feedbackShoppingUseFemininePriceAdjective =>
      'Use the feminine adjective form with this feminine object.';

  @override
  String get feedbackTransportUseAPie => 'Use \"a pie\" for going on foot.';

  @override
  String get feedbackDirectionsUseDondeForLocation =>
      'Use \"¿Dónde está...?\" to ask where a place is.';

  @override
  String get feedbackDirectionsUseEstaForLocation =>
      'Use \"está\" to say where a place is.';

  @override
  String get feedbackDirectionsLeftNotRight => '\"Izquierda\" means left.';

  @override
  String get feedbackDirectionsRightNotLeft => '\"Derecha\" means right.';

  @override
  String get feedbackDirectionsFarNotNear => '\"Lejos\" means far.';

  @override
  String get feedbackDirectionsUseComoForRoute =>
      'Use \"¿Cómo llego...?\" to ask how to get somewhere.';

  @override
  String get feedbackDirectionsRouteOrderMatters =>
      'Route order matters in this exercise. Follow the requested sequence.';

  @override
  String get feedbackTransportUseTomaForAdvice =>
      'Use \"toma\" when advising which transport to take.';

  @override
  String get feedbackDirectionsDirectionNotLocation =>
      'This exercise asks for directions, not only the place location.';

  @override
  String get feedbackHelpPoliteOpeningFirst =>
      'Start with the polite attention word, then ask for the service.';

  @override
  String get feedbackHelpIncludePoliteAttention =>
      'Include a polite attention word before the urgent request.';

  @override
  String get feedbackAnswersUsuallyDoNotBeginQuestionMark =>
      'Answers and statements usually do not begin with \"¿\".';

  @override
  String get feedbackQuestionsBeginWith => 'Questions begin with: ¿...';

  @override
  String feedbackStartsWith(String prefix) {
    return 'Starts with: $prefix';
  }

  @override
  String get primerTitle => 'Spanish Alphabet';

  @override
  String get primerSubtitle =>
      'Optional 5–10 minute reading map before Lesson 1.';

  @override
  String get primerInProgress => 'Continue the optional reading primer.';

  @override
  String get primerCompleted => 'Completed. Review it any time.';

  @override
  String get primerSkipped => 'Skipped. You can reopen it any time.';

  @override
  String get primerUnavailable => 'Optional reading support';

  @override
  String get primerStart => 'Start primer';

  @override
  String get primerReview => 'Review primer';

  @override
  String get primerOptional =>
      'Optional preparation — Lesson 1 stays available.';

  @override
  String get primerIntro =>
      'Below is an approximate guide to Spanish letters. You will learn to read words gradually in the lessons.';

  @override
  String get primerContinue => 'Continue to Lesson 1';

  @override
  String get primerAlphabetTitle => 'Spanish alphabet';

  @override
  String get primerAlphabetRows =>
      'A (ay) — a\nB (bee) — b\nC (see) — k or s\nD (dee) — d\nE (ee) — e\nF (ef) — f\nG (heh) — g or h\nH (ah-cheh) — not pronounced\nI (ee) — ee\nJ (ho-ta) — approximately a strong h\nK (kah) — k\nL (eh-leh) — l\nM (eh-meh) — m\nN (eh-neh) — n\nÑ (en-yeh) — approximately ny\nO (oh) — o\nP (peh) — p\nQ (koo) — k\nR (eh-rreh) — r\nS (eh-seh) — s\nT (teh) — t\nU (oo) — oo\nV (oo-beh) — approximately b\nW (oo-beh doh-bleh) — depends on the word\nX (eh-kees) — usually ks\nY (ee-gree-eh-gah) — approximately y or ee\nZ (seh-tah) — approximately s';

  @override
  String get primerDigraphTitle => 'Common letter combinations';

  @override
  String get primerDigraphRows =>
      'CH (cheh) — approximately ch\nLL (eh-yeh) — approximately y';

  @override
  String get primerSkip => 'Skip for now';

  @override
  String primerSectionCounter(int current, int total) {
    return 'Reading map $current of $total';
  }

  @override
  String get primerExamples => 'Real Spanish examples';

  @override
  String get primerLettersTitle => 'Letters and common combinations';

  @override
  String get primerExamplesTitle => 'Real course examples';

  @override
  String get primerReviewTitle => 'Quick recognition check';

  @override
  String get primerLetterColumn => 'Spanish form';

  @override
  String get primerReadingColumn => 'Approximate reading';

  @override
  String get primerSpanishColumn => 'Spanish';

  @override
  String get primerMeaningColumn => 'Meaning';

  @override
  String get primerStressHint =>
      'The capitalized syllable carries the main stress.';

  @override
  String get primerLetterH => 'h (hache)';

  @override
  String get primerReadingA => 'ah';

  @override
  String get primerReadingE => 'eh';

  @override
  String get primerReadingI => 'ee';

  @override
  String get primerReadingO => 'oh';

  @override
  String get primerReadingU => 'oo';

  @override
  String get primerReadingH => 'not pronounced';

  @override
  String get primerReadingJ => 'like a strong h';

  @override
  String get primerReadingEnye => 'like ny';

  @override
  String get primerReadingLl => 'like y; in llamo, approximately yah';

  @override
  String get primerReadingR => 'a short r';

  @override
  String get primerReadingRr => 'a stronger rolled r';

  @override
  String get primerApproxReadingLabel => 'Approximate reading';

  @override
  String get primerReadingHola => 'OH-lah';

  @override
  String get primerReadingMe => 'meh';

  @override
  String get primerReadingTu => 'too';

  @override
  String get primerReadingBuenosDias => 'BWEH-nos DEE-ahs';

  @override
  String get primerReadingHastaLuego => 'AHS-tah LWEH-goh';

  @override
  String get primerReadingMeLlamo => 'meh YAH-moh';

  @override
  String get primerReadingYTu => 'ee too';

  @override
  String get primerReadingEspana => 'es-PAH-nyah';

  @override
  String get primerReadingMadrid => 'mah-DRID';

  @override
  String get primerReadingComo => 'KOH-moh';

  @override
  String get primerReadingComoTeLlamas => 'KOH-moh teh YAH-mahs';

  @override
  String get primerReadingGracias => 'GRAH-syahs';

  @override
  String get primerReadingPrompt => 'Reading habit';

  @override
  String get primerRecognitionPrompt =>
      'Read the Spanish form as a whole, notice the highlighted pattern, and keep the example ready for later lessons.';

  @override
  String get primerFinish => 'Complete primer';

  @override
  String get primerReopenHint =>
      'This primer is optional and can be reviewed again from the course screen.';

  @override
  String get primerVowelsTitle => 'Stable vowels: a, e, i, o, u';

  @override
  String get primerVowelsBody =>
      'Read a, e, i, o and u clearly and steadily. The examples below show a practical approximation; the capitalized syllable carries the main stress.';

  @override
  String get primerVowelGuide =>
      'Reading cue: a is like ah; e like eh; i like ee; o like oh; u like oo.';

  @override
  String get primerSilentHTitle => 'h is written but not pronounced';

  @override
  String get primerSilentHBody =>
      'In Spanish, h normally has no separate sound. Notice this in hola and hasta luego.';

  @override
  String get primerLlYTitle => 'll and y in early course words';

  @override
  String get primerLlYBody =>
      'll is a single written unit in llamo and llamas. y is a separate letter, as in y tú. Regional pronunciation varies, but the written patterns remain visible.';

  @override
  String get primerEnyeTitle => 'ñ is a distinct Spanish letter';

  @override
  String get primerEnyeBody =>
      'ñ is not the same as n. Recognize it in España and keep the tilde as part of the Spanish spelling.';

  @override
  String get primerRRTitle => 'r and rr';

  @override
  String get primerRRBody =>
      'r and rr mark different written patterns. A single r appears in Madrid; rr is the strong pattern in perro. The Primer only builds recognition, not accent training.';

  @override
  String get primerContextTitle => 'Context patterns: c, g, qu, gu and gü';

  @override
  String get primerContextBody =>
      'c and g change their reading with the following vowel. qu commonly keeps the k-like reading before e/i; gu and gü show different written cues. Meet these patterns as complete words, not as a long rule table.';

  @override
  String get primerAccentsTitle => 'Accents and Spanish punctuation';

  @override
  String get primerAccentsBody =>
      'á, é, í, ó and ú are familiar vowels with a meaningful written accent. Notice the mark in Cómo and días; full Spanish stress rules are outside this Primer.';

  @override
  String get primerTryReview => 'Try a quick review';

  @override
  String get primerNoticeLabel => 'NOTICE';

  @override
  String get primerTryLabel => 'TRY IT';

  @override
  String primerReviewCounter(Object current, Object total) {
    return 'Recognition $current of $total';
  }

  @override
  String primerCorrectReading(String word, String hint) {
    return 'Correct. $word is read approximately as $hint.';
  }

  @override
  String get primerTryAgain =>
      'Not quite. Read the options again and try once more.';

  @override
  String get primerCheck => 'Check';

  @override
  String get primerLlTitle => 'll is a Spanish spelling pattern';

  @override
  String get primerLlBody =>
      'In this course, ll in me llamo uses a y-like starting sound: approximately meh YAH-moh. Other regions may vary, but this is the course reference for now.';

  @override
  String get primerEnyeRTitle => 'ñ and a single r';

  @override
  String get primerEnyeRBody =>
      'In España, ñ is read with a y-like n sound: es-PAH-nyah. Madrid has a single r: mah-DRID. This is an approximate reading, not a perfect-r test.';

  @override
  String get primerAccentsQuestionsTitle =>
      'Accent marks and written questions';

  @override
  String get primerAccentsQuestionsBody =>
      'An accent mark helps show stress: Cómo is KOH-moh and días is BWEH-nos DEE-ahs in the example phrase. ¿ begins a written question and ? ends it; punctuation is not a sound.';

  @override
  String get primerNarrowCTitle => 'A small c reading clue';

  @override
  String get primerNarrowCBody =>
      'c is not read the same way in every context: c in Cómo is k-like (KOH-moh), while c in Gracias is s-like in this course reference (GRAH-syahs). This is a small clue, not a full c chapter.';

  @override
  String get primerExampleHola => 'a greeting';

  @override
  String get primerExampleMe => 'me / myself';

  @override
  String get primerExampleTu => 'you';

  @override
  String get primerExampleBuenosDias => 'a daytime greeting';

  @override
  String get primerExampleMeLlamo => 'saying your name';

  @override
  String get primerExampleHastaLuego => 'a farewell';

  @override
  String get primerExampleYTu => 'asking about the other person';

  @override
  String get primerExampleEspana => 'Spain';

  @override
  String get primerExampleMadrid => 'Madrid';

  @override
  String get primerExampleComo => 'how / what way';

  @override
  String get primerExampleComoTeLlamas => 'What is your name?';

  @override
  String get primerExampleGracias => 'thank you';

  @override
  String primerReviewHolaReadingPrompt(String hint) {
    return 'Which Spanish word is read approximately as $hint?';
  }

  @override
  String primerReviewEspanaReadingPrompt(String hint) {
    return 'Which Spanish word is read approximately as $hint?';
  }

  @override
  String primerReviewQuestionReadingPrompt(String hint) {
    return 'Which Spanish question is read approximately as $hint?';
  }

  @override
  String get audioListen => 'Listen';

  @override
  String get audioUnavailable => 'Audio unavailable. You can continue.';

  @override
  String get recordingPurpose =>
      'Microphone access lets you record your voice and listen to it locally.';

  @override
  String get record => 'Record';

  @override
  String get stopRecording => 'Stop recording';

  @override
  String get playMyRecording => 'Play my recording';

  @override
  String get recordAgain => 'Record again';

  @override
  String get deleteRecording => 'Delete recording';

  @override
  String get microphoneDenied =>
      'Microphone access was denied. You can continue without recording.';

  @override
  String get tryRecordingAgain => 'Try recording again';

  @override
  String get recordingFailed =>
      'Recording failed. You can continue without recording.';

  @override
  String get continueWithoutRecording => 'Continue without recording';

  @override
  String get spokenPractice => 'Spoken practice';

  @override
  String get listen => 'Listen';

  @override
  String get sayItAloud => 'Say it aloud';

  @override
  String get tryFromMemory => 'Try from memory';

  @override
  String get listenToReference => 'Listen to reference';

  @override
  String get showReference => 'Show reference';

  @override
  String get finishAttempt => 'Finish attempt';

  @override
  String get continuePractice => 'Continue';

  @override
  String get practiceComplete => 'Practice complete';
}
