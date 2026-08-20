// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Tutor Language';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get backTooltip => 'Zurück';

  @override
  String get backToCourse => 'Zurück zum Kurs';

  @override
  String get openCourse => 'Kurs öffnen';

  @override
  String get courseTitle => 'Kurs';

  @override
  String courseProgress(int completed, int total) {
    return '$completed von $total Lektionen abgeschlossen';
  }

  @override
  String get courseComplete => 'Kurs abgeschlossen';

  @override
  String get noUnitsAvailable => 'Keine Einheiten verfügbar.';

  @override
  String get noLessonsAvailable => 'Keine Lektionen verfügbar.';

  @override
  String get lessonStatusCompleted => 'Abgeschlossen';

  @override
  String get lessonStatusAvailableNext => 'Als Nächstes verfügbar';

  @override
  String get lessonStatusLocked => 'Gesperrt';

  @override
  String moduleNumber(String number) {
    return 'Modul $number';
  }

  @override
  String lessonNumber(String number) {
    return 'Lektion $number';
  }

  @override
  String get competencyCheck => 'Kommunikative Kompetenzprüfung';

  @override
  String get competencyAchieved => 'Kommunikative Kompetenz erreicht';

  @override
  String get competencyAchievedAfterReview =>
      'Kommunikative Kompetenz nach Wiederholung erreicht';

  @override
  String get competencyNeedsPractice =>
      'Kommunikative Kompetenz braucht mehr Übung';

  @override
  String get competencyNotYetAchieved =>
      'Kommunikative Kompetenz noch nicht erreicht';

  @override
  String get competencyCompleteModuleFirst => 'Dieses Modul zuerst abschließen';

  @override
  String get competencyReadyToStart => 'Bereit zum Start';

  @override
  String get competencyContinueCheck => 'Prüfung fortsetzen';

  @override
  String get competencyGoalDemonstrated => 'Modulziel gezeigt';

  @override
  String get competencySucceededAfterReview =>
      'Nach gezielter Wiederholung geschafft';

  @override
  String get competencyRetryWhenReady =>
      'Prüfung wiederholen, wenn Sie bereit sind';

  @override
  String get start => 'Start';

  @override
  String get continueAction => 'Weiter';

  @override
  String get retry => 'Wiederholen';

  @override
  String get lessonTitle => 'Lektion';

  @override
  String get previousLesson => 'Vorherige Lektion';

  @override
  String get nextLesson => 'Nächste Lektion';

  @override
  String lessonLaunchError(String error) {
    return 'Lektion konnte nicht gestartet werden.\n$error';
  }

  @override
  String get lessonPlayerTitle => 'Lektion';

  @override
  String get leaveLessonTitle => 'Lektion verlassen?';

  @override
  String get leaveLessonBody =>
      'Diese unvollständige Lektion beginnt neu, wenn Sie sie wieder öffnen.';

  @override
  String get stay => 'Bleiben';

  @override
  String get leaveLesson => 'Lektion verlassen';

  @override
  String get noActivitiesAvailable => 'Keine Aufgaben verfügbar.';

  @override
  String get previous => '← Zurück';

  @override
  String get next => 'Weiter →';

  @override
  String stepCounter(int current, int total) {
    return 'Schritt $current / $total';
  }

  @override
  String get finishLesson => 'Lektion abschließen';

  @override
  String get finishing => 'Wird abgeschlossen...';

  @override
  String get completionSaveError =>
      'Der Abschluss der Lektion konnte nicht gespeichert werden. Bitte versuchen Sie es erneut.';

  @override
  String get lessonCompleted => 'Lektion abgeschlossen';

  @override
  String get continueToNextLesson => 'Zur nächsten Lektion';

  @override
  String get repeatLesson => 'Lektion wiederholen';

  @override
  String get repeatFromStep => 'Ab einem Schritt wiederholen';

  @override
  String get repeatCheckpoint => 'Checkpoint wiederholen';

  @override
  String get reviewCompletedLessons => 'Abgeschlossene Lektionen wiederholen';

  @override
  String get someTopicsNeedReinforcement =>
      'Einige Themen brauchen noch Festigung.';

  @override
  String get lessonMasteredOutcome => 'Sichere Beherrschung gezeigt.';

  @override
  String get lessonReinforcementOutcome => 'Mit Festigung abgeschlossen.';

  @override
  String get lessonIncompleteOutcome => 'Lektionsergebnis unvollständig.';

  @override
  String get lessonMastered => 'Lektion beherrscht';

  @override
  String get courseCompletionRecommended =>
      'Kurs abgeschlossen. Wiederholen Sie weiterhin abgeschlossene Lektionen.';

  @override
  String get quickReview => 'Kurze Wiederholung';

  @override
  String get mastered => 'Beherrscht';

  @override
  String get fragileMastery => 'Gute Arbeit. Das braucht noch etwas Übung.';

  @override
  String unsupportedContent(String type) {
    return 'Nicht unterstützter Inhalt: $type';
  }

  @override
  String get buildsOnEarlierMaterial => 'Baut auf früherem Material auf.';

  @override
  String get stepTypeVocabulary => 'Wortschatz';

  @override
  String get stepTypeGrammar => 'Grammatik';

  @override
  String get stepTypeDialogue => 'Dialog';

  @override
  String get stepTypeReading => 'Lesen';

  @override
  String get stepTypeExercise => 'Übung';

  @override
  String get stepTypeMixed => 'gemischt';

  @override
  String get answerLabel => 'Antwort';

  @override
  String get sentenceBuilderAnswer => 'Deine Antwort';

  @override
  String get sentenceBuilderAvailableWords => 'Verfügbare Wörter';

  @override
  String get sentenceBuilderClear => 'Löschen';

  @override
  String get learnerSpeakerLabel => 'Du';

  @override
  String get checkAnswer => 'Prüfen';

  @override
  String dialogueProgress(int current, int total) {
    return 'Dialog $current / $total';
  }

  @override
  String selectedAnswer(String answer) {
    return 'Ausgewählte Antwort: $answer';
  }

  @override
  String get correct => 'Richtig';

  @override
  String get acceptedWithCorrection => 'Mit Korrektur akzeptiert';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get notCorrectYet => 'Noch nicht richtig';

  @override
  String get incorrect => 'Falsch';

  @override
  String feedbackMultilineMissing(int submitted, int expected) {
    return 'Du hast $submitted von $expected Zeilen eingegeben. Ergänze den Dialog.';
  }

  @override
  String feedbackMultilineExtra(int submitted, int expected) {
    return 'Du hast $submitted statt $expected Zeilen eingegeben. Prüfe den Dialog.';
  }

  @override
  String feedbackMultilineIncorrectLines(
    int correct,
    int expected,
    String lines,
  ) {
    return '$correct von $expected Zeilen sind richtig. Prüfe die Zeilen: $lines.';
  }

  @override
  String feedbackMultilineIncomplete(int submitted) {
    return 'Du hast $submitted Zeilen eingegeben. Ergänze den Dialog.';
  }

  @override
  String feedbackMultilineTooMany(int submitted) {
    return 'Du hast $submitted Zeilen eingegeben. Prüfe den Dialog.';
  }

  @override
  String get unsupportedActivityType => 'Nicht unterstützter Aufgabentyp';

  @override
  String unsupportedActivityTypeValue(String type) {
    return 'Nicht unterstützter Aufgabentyp: $type';
  }

  @override
  String get matchingNotCheckableYet =>
      'Diese Zuordnungsaufgabe kann noch nicht geprüft werden.';

  @override
  String recommendedAnswer(String answer) {
    return 'Empfohlene Antwort: $answer';
  }

  @override
  String feedbackBullet(String message) {
    return '- $message';
  }

  @override
  String exercisePromptSemantics(String prompt) {
    return 'Aufgabenstellung: $prompt';
  }

  @override
  String get settingsTitle => 'Info und Einstellungen';

  @override
  String get releaseStatusLabel => 'Frühe öffentliche Version';

  @override
  String get releaseScopeLabel => 'Offline-Spanischkurs A0';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get privacyTitle => 'Datenschutz';

  @override
  String get privacyOffline => 'Funktioniert offline.';

  @override
  String get privacyNoAccount => 'Es ist kein Konto erforderlich.';

  @override
  String get privacyNoTracking =>
      'Es werden keine Werbung, kein Tracking und keine Analytik verwendet.';

  @override
  String get privacyNoAi =>
      'Während der Lektionen wird kein KI-Dienst kontaktiert.';

  @override
  String get privacyLocalProgress =>
      'Der Lernfortschritt bleibt auf diesem Gerät.';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackBody =>
      'Für diese frühe Version melden Sie Probleme bitte über das Projekt-Repository oder direkt an die Projektbetreuung.';

  @override
  String get licensesTitle => 'Lizenzen und Danksagungen';

  @override
  String get licensesBody =>
      'Tutor Language wurde mit Flutter entwickelt und enthält eigens erstellte Spanisch-A0-Lerninhalte. Vollständige Lizenz- und Drittanbieterinformationen werden dem öffentlichen Release-Paket beigefügt.';

  @override
  String get competencyScreenTitle => 'Kompetenzprüfung';

  @override
  String get competencyUnavailable => 'Kompetenzprüfung nicht verfügbar.';

  @override
  String competencyUnavailableWithError(String error) {
    return 'Kompetenzprüfung nicht verfügbar. $error';
  }

  @override
  String get competencyTaskUnavailable =>
      'Diese Kompetenzaufgabe ist nicht verfügbar.';

  @override
  String get competencyDiagnosticIntro =>
      'Zeigen Sie, was ohne Hilfe möglich ist.';

  @override
  String get competencyRetryIntro =>
      'Versuchen Sie die ursprüngliche Aufgabe noch einmal.';

  @override
  String get competencyRecoveryIntro =>
      'Wiederholen wir kurz einen Teil und versuchen es erneut.';

  @override
  String get startReview => 'Wiederholung starten';

  @override
  String get recoveryActivityUnavailable =>
      'Wiederholungsaufgabe nicht verfügbar.';

  @override
  String get competencyCheckComplete => 'Kompetenzprüfung abgeschlossen.';

  @override
  String get retryCompetencyCheck => 'Kompetenzprüfung wiederholen';

  @override
  String get competencyAchievedTitle => 'Kompetenz erreicht';

  @override
  String get competencyAchievedAfterReviewTitle =>
      'Kompetenz nach Wiederholung erreicht';

  @override
  String get competencyNeedsPracticeTitle => 'Kompetenz braucht Übung';

  @override
  String get competencyNotYetAchievedTitle => 'Kompetenz noch nicht erreicht';

  @override
  String get competencyAchievedDescription =>
      'Die kommunikative Aufgabe wurde selbstständig abgeschlossen.';

  @override
  String get competencyAchievedAfterReviewDescription =>
      'Nach einer Wiederholung wurde die kommunikative Aufgabe abgeschlossen.';

  @override
  String get competencyNeedsPracticeDescription =>
      'Ein Teil des Ziels wurde gezeigt. Wiederholen Sie die Prüfung, wenn Sie bereit sind.';

  @override
  String get competencyNotYetAchievedDescription =>
      'Das Kernziel ist noch nicht sicher. Wiederholen Sie es nach der Wiederholung.';

  @override
  String get notViewed => 'Nicht angesehen';

  @override
  String get viewed => 'Angesehen';

  @override
  String activitiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben',
      one: '1 Aufgabe',
      zero: 'Keine Aufgaben',
    );
    return '$_temp0';
  }

  @override
  String get noAnswerChoices => 'Diese Vorlage enthält keine Antwortoptionen.';

  @override
  String get unchecked => 'Nicht geprüft';

  @override
  String templateType(String type) {
    return 'Typ: $type';
  }

  @override
  String templatePrompt(String prompt) {
    return 'Aufgabe: $prompt';
  }

  @override
  String requiredObjectTypesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count erforderliche Objekttypen',
      one: '1 erforderlicher Objekttyp',
      zero: 'Keine erforderlichen Objekttypen',
    );
    return '$_temp0';
  }

  @override
  String supportedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unterstützte Ziele',
      one: '1 unterstütztes Ziel',
      zero: 'Keine unterstützten Ziele',
    );
    return '$_temp0';
  }

  @override
  String get feedbackPreferredOrderNoCanonical =>
      'Hier wird eine andere Reihenfolge akzeptiert.';

  @override
  String feedbackPreferredOrder(String answer) {
    return 'Natürlicher ist die Reihenfolge: $answer';
  }

  @override
  String feedbackSpanishInterrogativeQueRequiresAccent(String canonical) {
    return 'In dieser Frage braucht „$canonical“ einen Akzent.';
  }

  @override
  String feedbackSpanishInterrogativeComoRequiresAccent(String canonical) {
    return 'In dieser Frage braucht „$canonical“ einen Akzent.';
  }

  @override
  String feedbackSpanishMissingDiacritic(String canonical) {
    return 'Korrekte spanische Schreibweise: „$canonical“.';
  }

  @override
  String get feedbackSpanishQuestionMissingOpeningMark =>
      'Spanische Fragen beginnen mit „¿“.';

  @override
  String get feedbackSpanishQuestionMissingClosingMark =>
      'Spanische Fragen enden mit „?“.';

  @override
  String get feedbackSpanishExclamationMissingOpeningMark =>
      'Spanische Ausrufe beginnen mit „¡“.';

  @override
  String get feedbackSpanishExclamationMissingClosingMark =>
      'Spanische Ausrufe enden mit „!“.';

  @override
  String feedbackUseCanonicalForm(String canonical) {
    return 'Verwenden Sie die Standardform: „$canonical“.';
  }

  @override
  String get feedbackQuestionExpectedStatementProvided =>
      'Diese Übung fragt nach einer Frage.\nSie haben eine Antwort geschrieben.\nVersuchen Sie, die spanische Frage zu schreiben.';

  @override
  String get feedbackStatementExpectedQuestionProvided =>
      'Diese Übung fragt nach einer Aussage.\nSie haben eine Frage geschrieben.\nVersuchen Sie, die spanische Aussage zu schreiben.';

  @override
  String get feedbackAnswerExpectedQuestion =>
      'Diese Übung fragt nach einer Antwort.\nSie haben eine andere Frage geschrieben.';

  @override
  String get feedbackQuestionExpectedAnswer =>
      'Schreiben Sie die Frage, nicht die Antwort.';

  @override
  String get feedbackTranslationExpectedSourceLanguage =>
      'Übersetzen Sie die Vorgabe, statt sie zu kopieren.';

  @override
  String get feedbackGreetingExpectedFarewell =>
      'Diese Übung fragt nach einer Begrüßung.\nSie haben einen Abschied geschrieben.';

  @override
  String get feedbackFarewellExpectedGreeting =>
      'Diese Übung fragt nach einem Abschied.\nSie haben eine Begrüßung geschrieben.';

  @override
  String get feedbackNamePatternUseMeLlamo =>
      'Für dieses Vorstellungsmuster verwenden Sie „me llamo“.';

  @override
  String get feedbackOriginUseSer =>
      'Für Herkunft verwendet Spanisch „soy de“.';

  @override
  String get feedbackOriginKeepDe =>
      'Behalten Sie „de“ im Herkunftsmuster: „soy de“.';

  @override
  String get feedbackOriginUseSoyDe => '„Soy de“ sagt, woher jemand kommt.';

  @override
  String get feedbackOriginQuestionIncludeDe =>
      'Verwenden Sie „¿De dónde eres?“, um zu fragen, woher jemand kommt.';

  @override
  String get feedbackResidenceUseVivoEn => '„Vivo en“ sagt, wo jemand wohnt.';

  @override
  String get feedbackResidenceQuestionNoDe =>
      'Verwenden Sie „¿Dónde vives?“, um zu fragen, wo jemand wohnt.';

  @override
  String get feedbackLanguagesUseHablo =>
      'Verwenden Sie „hablo“, um zu sagen, welche Sprache Sie sprechen.';

  @override
  String get feedbackLanguagesUseLanguageNames =>
      'Verwenden Sie Sprachennamen wie „ucraniano“ oder „ruso“.';

  @override
  String get feedbackLanguagesKeepDeAfterUnPoco =>
      'Behalten Sie „de“ in „un poco de“ vor der Sprache.';

  @override
  String get feedbackLanguagesAskIdiomas =>
      'Verwenden Sie „idiomas“, wenn Sie fragen, welche Sprachen jemand spricht.';

  @override
  String get feedbackIdentityAskSpecificQuestions =>
      'Verwenden Sie die Frage, die zur benötigten Information passt.';

  @override
  String get feedbackOriginResidenceDoNotSwap =>
      'Vertauschen Sie Herkunft und Wohnort nicht: „soy de“ ist Herkunft, „vivo en“ ist Wohnort.';

  @override
  String get feedbackPeopleUseEsForOther =>
      'Verwenden Sie „es“, wenn Sie über eine andere Person sprechen.';

  @override
  String get feedbackPeopleUseSeLlama =>
      'Verwenden Sie „se llama“, um den Namen einer anderen Person zu nennen.';

  @override
  String get feedbackPeopleUseFeminineRole =>
      'Verwenden Sie für diese Person die feminine Rollenform.';

  @override
  String get feedbackPeopleUseMasculineRole =>
      'Verwenden Sie für diese Person die maskuline Rollenform.';

  @override
  String get feedbackPeopleQuestionQuienNotComo =>
      '„¿Quién es?“ fragt, wer die Person ist.';

  @override
  String get feedbackPeopleQuestionComoNotQuien =>
      '„¿Cómo es?“ fragt, wie die Person ist.';

  @override
  String get feedbackPeopleUseFeminineDescription =>
      'Verwenden Sie für diese Person die feminine Beschreibungsform.';

  @override
  String get feedbackPeopleUseMasculineDescription =>
      'Verwenden Sie für diese Person die maskuline Beschreibungsform.';

  @override
  String get feedbackPeopleUseViveForOther =>
      'Verwenden Sie „vive“, wenn Sie sagen, wo eine andere Person wohnt.';

  @override
  String get feedbackPeopleUseHablaForOther =>
      'Verwenden Sie „habla“, wenn Sie sagen, was eine andere Person spricht.';

  @override
  String get feedbackPeopleOriginResidenceContrast =>
      '„Es de“ nennt die Herkunft; „vive en“ nennt den Wohnort.';

  @override
  String get feedbackPeopleLanguageNotNationality =>
      'Verwenden Sie „habla“, um zu sagen, welche Sprache eine andere Person spricht.';

  @override
  String get feedbackPeopleThirdPersonSequence =>
      'Die ganze Antwort über eine andere Person soll in der dritten Person bleiben.';

  @override
  String get feedbackPeopleQuestionOrderMatters =>
      'Verwenden Sie die Fragen in der Reihenfolge der Aufgabenstellung.';

  @override
  String get feedbackPeopleQuestionAndPersonForm =>
      'Verwenden Sie die geforderte Frage und die Verbform der dritten Person.';

  @override
  String get feedbackShoppingUseQueForObject =>
      'Verwenden Sie „¿Qué es esto?“, um zu fragen, was der Gegenstand ist.';

  @override
  String get feedbackShoppingUseCuantoForPrice =>
      'Verwenden Sie „¿Cuánto cuesta?“, um nach dem Preis zu fragen.';

  @override
  String get feedbackShoppingUseCuestaForPrice =>
      'Verwenden Sie „cuesta“, wenn Sie den Preis eines einzelnen Gegenstands nennen.';

  @override
  String get feedbackShoppingUsePoliteTiene =>
      'Verwenden Sie in diesem Modul die höfliche Ladenfrage „¿Tiene...?“.';

  @override
  String get feedbackShoppingUseTenemosForShop =>
      'Verwenden Sie „tenemos“, wenn der Laden sagt, was er hat.';

  @override
  String get feedbackShoppingUseQuieroForPurchase =>
      'Verwenden Sie „quiero“, um zu sagen, was Sie kaufen möchten.';

  @override
  String get feedbackShoppingUseUnaFeminine =>
      'Verwenden Sie „una“ mit einem geübten femininen Nomen wie „botella“ oder „bolsa“.';

  @override
  String get feedbackShoppingUseEsteMasculine =>
      'Verwenden Sie „este“ vor einem geübten maskulinen Nomen wie „libro“.';

  @override
  String get feedbackShoppingUseEstaFeminine =>
      'Verwenden Sie „esta“ vor einem geübten femininen Nomen wie „bolsa“.';

  @override
  String get feedbackShoppingUseMasculinePriceAdjective =>
      'Verwenden Sie bei diesem maskulinen Gegenstand die maskuline Adjektivform.';

  @override
  String get feedbackShoppingUseFemininePriceAdjective =>
      'Verwenden Sie bei diesem femininen Gegenstand die feminine Adjektivform.';

  @override
  String get feedbackTransportUseAPie =>
      'Verwenden Sie „a pie“, wenn Sie zu Fuß gehen.';

  @override
  String get feedbackDirectionsUseDondeForLocation =>
      'Verwenden Sie „¿Dónde está...?“, um nach dem Ort zu fragen.';

  @override
  String get feedbackDirectionsUseEstaForLocation =>
      'Verwenden Sie „está“, um zu sagen, wo ein Ort liegt.';

  @override
  String get feedbackDirectionsLeftNotRight => '„Izquierda“ bedeutet links.';

  @override
  String get feedbackDirectionsRightNotLeft => '„Derecha“ bedeutet rechts.';

  @override
  String get feedbackDirectionsFarNotNear => '„Lejos“ bedeutet weit weg.';

  @override
  String get feedbackDirectionsUseComoForRoute =>
      'Verwenden Sie „¿Cómo llego...?“, um nach dem Weg zu fragen.';

  @override
  String get feedbackDirectionsRouteOrderMatters =>
      'In dieser Übung ist die Reihenfolge des Weges wichtig. Folgen Sie der vorgegebenen Abfolge.';

  @override
  String get feedbackTransportUseTomaForAdvice =>
      'Verwenden Sie „toma“, wenn Sie ein Verkehrsmittel empfehlen.';

  @override
  String get feedbackDirectionsDirectionNotLocation =>
      'Diese Übung fragt nach Wegbeschreibung, nicht nur nach dem Standort.';

  @override
  String get feedbackHelpPoliteOpeningFirst =>
      'Beginnen Sie mit dem höflichen Aufmerksamkeitswort und bitten Sie dann um die Dienstleistung.';

  @override
  String get feedbackHelpIncludePoliteAttention =>
      'Fügen Sie vor der dringenden Bitte ein höfliches Aufmerksamkeitswort ein.';

  @override
  String get feedbackAnswersUsuallyDoNotBeginQuestionMark =>
      'Antworten und Aussagen beginnen normalerweise nicht mit „¿“.';

  @override
  String get feedbackQuestionsBeginWith => 'Fragen beginnen mit: ¿...';

  @override
  String feedbackStartsWith(String prefix) {
    return 'Beginnt mit: $prefix';
  }

  @override
  String get primerTitle => 'Spanisches Alphabet';

  @override
  String get primerSubtitle =>
      'Optionale Lesekarte für 5–10 Minuten vor Lektion 1.';

  @override
  String get primerInProgress => 'Optionale Lesevorbereitung fortsetzen.';

  @override
  String get primerCompleted => 'Abgeschlossen. Jederzeit wiederholbar.';

  @override
  String get primerSkipped => 'Übersprungen. Jederzeit wieder öffnbar.';

  @override
  String get primerUnavailable => 'Optionale Lesehilfe';

  @override
  String get primerStart => 'Vorbereitung starten';

  @override
  String get primerReview => 'Vorbereitung wiederholen';

  @override
  String get primerOptional =>
      'Optionale Vorbereitung — Lektion 1 bleibt verfügbar.';

  @override
  String get primerIntro =>
      'Unten siehst du, wie spanische Buchstaben ungefähr klingen. Das Lesen von Wörtern lernst du nach und nach in den Lektionen.';

  @override
  String get primerContinue => 'Weiter zu Lektion 1';

  @override
  String get primerAlphabetTitle => 'Spanisches Alphabet';

  @override
  String get primerAlphabetRows =>
      'A (a) — a\nB (be) — b\nC (se) — k oder s\nD (de) — d\nE (e) — e\nF (efe) — f\nG (che) — g oder ch\nH (ache) — wird nicht gesprochen\nI (i) — i\nJ (chota) — ungefähr wie starkes ch\nK (ka) — k\nL (ele) — l\nM (eme) — m\nN (ene) — n\nÑ (enje) — ungefähr nj\nO (o) — o\nP (pe) — p\nQ (ku) — k\nR (erre) — r\nS (ese) — s\nT (te) — t\nU (u) — u\nV (ube) — ungefähr b\nW (ube doble) — hängt vom Wort ab\nX (ekis) — meistens ks\nY (i griega) — ungefähr j oder i\nZ (seta) — ungefähr s';

  @override
  String get primerDigraphTitle => 'Häufige Buchstabenkombinationen';

  @override
  String get primerDigraphRows =>
      'CH (tsche) — ungefähr tsch\nLL (elje) — ungefähr j';

  @override
  String get primerSkip => 'Jetzt überspringen';

  @override
  String primerSectionCounter(int current, int total) {
    return 'Lesekarte: $current von $total';
  }

  @override
  String get primerExamples => 'Echte spanische Beispiele';

  @override
  String get primerLettersTitle => 'Buchstaben und häufige Kombinationen';

  @override
  String get primerExamplesTitle => 'Echte Beispiele aus dem Kurs';

  @override
  String get primerReviewTitle => 'Kurze Leseprüfung';

  @override
  String get primerLetterColumn => 'Spanische Form';

  @override
  String get primerReadingColumn => 'Ungefähre Lesung';

  @override
  String get primerSpanishColumn => 'Spanisch';

  @override
  String get primerMeaningColumn => 'Bedeutung';

  @override
  String get primerStressHint =>
      'Die Silbe in Großbuchstaben trägt die Hauptbetonung.';

  @override
  String get primerLetterH => 'h (hache)';

  @override
  String get primerReadingA => 'a';

  @override
  String get primerReadingE => 'e';

  @override
  String get primerReadingI => 'i';

  @override
  String get primerReadingO => 'o';

  @override
  String get primerReadingU => 'u';

  @override
  String get primerReadingH => 'wird nicht gesprochen';

  @override
  String get primerReadingJ => 'ungefähr wie ein starkes «ch»';

  @override
  String get primerReadingEnye => 'ungefähr wie «nj»';

  @override
  String get primerReadingLl => 'ungefähr wie «j»; in llamo — «ja»';

  @override
  String get primerReadingR => 'ein kurzes r';

  @override
  String get primerReadingRr => 'ein stärker gerolltes r';

  @override
  String get primerApproxReadingLabel => 'Ungefähre Lesung';

  @override
  String get primerReadingHola => 'O-la';

  @override
  String get primerReadingMe => 'me';

  @override
  String get primerReadingTu => 'tu';

  @override
  String get primerReadingBuenosDias => 'BUE-nos DI-as';

  @override
  String get primerReadingHastaLuego => 'AS-ta LUE-go';

  @override
  String get primerReadingMeLlamo => 'me JA-mo';

  @override
  String get primerReadingYTu => 'i tu';

  @override
  String get primerReadingEspana => 'es-PA-nja';

  @override
  String get primerReadingMadrid => 'ma-DRID';

  @override
  String get primerReadingComo => 'KO-mo';

  @override
  String get primerReadingComoTeLlamas => 'KO-mo te JA-mas';

  @override
  String get primerReadingGracias => 'GRA-sjas';

  @override
  String get primerReadingPrompt => 'Lesegewohnheit';

  @override
  String get primerRecognitionPrompt =>
      'Lies die spanische Form als Ganzes und verbinde sie mit dem Hinweis darunter; diese Wörter kommen in späteren Lektionen vor.';

  @override
  String get primerFinish => 'Vorbereitung abschließen';

  @override
  String get primerReopenHint =>
      'Diese Vorbereitung ist optional und kann auf dem Kursbildschirm erneut geöffnet werden.';

  @override
  String get primerVowelsTitle => 'Gleichbleibende Vokale: a, e, i, o, u';

  @override
  String get primerVowelsBody =>
      'Lies a, e, i, o und u klar und gleichmäßig. Die Hinweise zeigen eine praktische Annäherung; die Großbuchstaben markieren die Hauptbetonung.';

  @override
  String get primerVowelGuide =>
      'Hinweis: a klingt ungefähr wie «a», e wie «e», i wie «i», o wie «o», u wie «u».';

  @override
  String get primerSilentHTitle => 'h wird geschrieben, aber nicht gesprochen';

  @override
  String get primerSilentHBody =>
      'Im Spanischen hat h normalerweise keinen eigenen Laut. Das siehst du in hola und hasta luego.';

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
  String get primerTryReview => 'Kurze Wiederholung';

  @override
  String get primerNoticeLabel => 'ACHTE DARAUF';

  @override
  String get primerTryLabel => 'PROBIERE ES';

  @override
  String primerReviewCounter(Object current, Object total) {
    return 'Erkennen: $current von $total';
  }

  @override
  String primerCorrectReading(String word, String hint) {
    return 'Richtig. $word wird ungefähr wie $hint gelesen.';
  }

  @override
  String get primerTryAgain =>
      'Noch nicht. Lies die Optionen noch einmal und versuche es erneut.';

  @override
  String get primerCheck => 'Prüfen';

  @override
  String get primerLlTitle => 'll — spanisches Schreibmuster';

  @override
  String get primerLlBody =>
      'In diesem Kurs beginnt ll in me llamo ungefähr mit einem j-Laut: me JA-mo. Andere Regionen können anders klingen; dies ist unser Startmodell.';

  @override
  String get primerEnyeRTitle => 'ñ und ein einfaches r';

  @override
  String get primerEnyeRBody =>
      'In España wird ñ mit einem weichen nj-Laut gelesen: es-PA-nja. Madrid hat ein einfaches r: ma-DRID. Das ist eine Annäherung, kein Test für perfektes r.';

  @override
  String get primerAccentsQuestionsTitle => 'Akzente und geschriebene Fragen';

  @override
  String get primerAccentsQuestionsBody =>
      'Der Akzent zeigt die betonte Silbe: Cómo — KO-mo, Buenos días — BUE-nos DI-as. ¿ öffnet eine geschriebene Frage und ? schließt sie; das sind keine eigenen Laute.';

  @override
  String get primerNarrowCTitle => 'Ein kleiner Lesehinweis für c';

  @override
  String get primerNarrowCBody =>
      'c wird nicht überall gleich gelesen: In Cómo klingt es ungefähr wie k — KO-mo, in Gracias in unserem Modell ungefähr wie s — GRA-sjas. Das ist nur ein kleiner Hinweis, kein vollständiges c-Kapitel.';

  @override
  String get primerExampleHola => 'eine Begrüßung';

  @override
  String get primerExampleMe => 'ich / mich';

  @override
  String get primerExampleTu => 'du';

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
    return 'Welches spanische Wort wird ungefähr wie $hint gelesen?';
  }

  @override
  String primerReviewEspanaReadingPrompt(String hint) {
    return 'Welches spanische Wort wird ungefähr wie $hint gelesen?';
  }

  @override
  String primerReviewQuestionReadingPrompt(String hint) {
    return 'Welche spanische Frage wird ungefähr wie $hint gelesen?';
  }

  @override
  String get audioListen => 'Anhören';

  @override
  String get audioUnavailable =>
      'Audio nicht verfügbar. Versuchen Sie es erneut.';

  @override
  String get recordingPurpose =>
      'Der Mikrofonzugriff ermöglicht es Ihnen, Ihre Stimme aufzunehmen und lokal anzuhören.';

  @override
  String get record => 'Aufnehmen';

  @override
  String get stopRecording => 'Aufnahme stoppen';

  @override
  String get playMyRecording => 'Meine Aufnahme abspielen';

  @override
  String get recordAgain => 'Erneut aufnehmen';

  @override
  String get deleteRecording => 'Aufnahme löschen';

  @override
  String get microphoneDenied =>
      'Der Mikrofonzugriff wurde abgelehnt. Sie können ohne Aufnahme fortfahren.';

  @override
  String get tryRecordingAgain => 'Erneut versuchen';

  @override
  String get recordingFailed =>
      'Aufnahme fehlgeschlagen. Sie können ohne Aufnahme fortfahren.';

  @override
  String get continueWithoutRecording => 'Ohne Aufnahme fortfahren';

  @override
  String get spokenPractice => 'Sprechübung';

  @override
  String get listen => 'Anhören';

  @override
  String get sayItAloud => 'Laut sagen';

  @override
  String get tryFromMemory => 'Aus dem Gedächtnis versuchen';

  @override
  String get listenToReference => 'Referenz anhören';

  @override
  String get showReference => 'Referenz anzeigen';

  @override
  String get finishAttempt => 'Versuch beenden';

  @override
  String get continuePractice => 'Weiter';

  @override
  String get practiceComplete => 'Übung abgeschlossen';
}
