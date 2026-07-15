// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Tutor Language';

  @override
  String get settingsTooltip => 'Ustawienia';

  @override
  String get backTooltip => 'Wstecz';

  @override
  String get backToCourse => 'Wróć do kursu';

  @override
  String get openCourse => 'Otwórz kurs';

  @override
  String get courseTitle => 'Kurs';

  @override
  String courseProgress(int completed, int total) {
    return 'Ukończono $completed z $total lekcji';
  }

  @override
  String get courseComplete => 'Kurs ukończony';

  @override
  String get noUnitsAvailable => 'Brak dostępnych części.';

  @override
  String get noLessonsAvailable => 'Brak dostępnych lekcji.';

  @override
  String get lessonStatusCompleted => 'Ukończono';

  @override
  String get lessonStatusAvailableNext => 'Dostępna jako następna';

  @override
  String get lessonStatusLocked => 'Zablokowana';

  @override
  String moduleNumber(String number) {
    return 'Moduł $number';
  }

  @override
  String lessonNumber(String number) {
    return 'Lekcja $number';
  }

  @override
  String get competencyCheck => 'Sprawdzenie umiejętności komunikacyjnej';

  @override
  String get competencyAchieved => 'Umiejętność komunikacyjna potwierdzona';

  @override
  String get competencyAchievedAfterReview =>
      'Umiejętność komunikacyjna potwierdzona po powtórce';

  @override
  String get competencyNeedsPractice =>
      'Umiejętność komunikacyjna wymaga ćwiczeń';

  @override
  String get competencyNotYetAchieved =>
      'Umiejętność komunikacyjna nie jest jeszcze potwierdzona';

  @override
  String get competencyCompleteModuleFirst => 'Najpierw ukończ ten moduł';

  @override
  String get competencyReadyToStart => 'Gotowe do rozpoczęcia';

  @override
  String get competencyContinueCheck => 'Kontynuuj sprawdzenie';

  @override
  String get competencyGoalDemonstrated => 'Cel tego modułu został pokazany';

  @override
  String get competencySucceededAfterReview =>
      'Udało się po ukierunkowanej powtórce';

  @override
  String get competencyRetryWhenReady =>
      'Powtórz sprawdzenie, gdy będziesz gotowy';

  @override
  String get start => 'Start';

  @override
  String get continueAction => 'Kontynuuj';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get lessonTitle => 'Lekcja';

  @override
  String get previousLesson => 'Poprzednia lekcja';

  @override
  String get nextLesson => 'Następna lekcja';

  @override
  String lessonLaunchError(String error) {
    return 'Nie można uruchomić lekcji.\n$error';
  }

  @override
  String get lessonPlayerTitle => 'Lekcja';

  @override
  String get leaveLessonTitle => 'Opuścić lekcję?';

  @override
  String get leaveLessonBody =>
      'Niedokończona lekcja zacznie się od początku, gdy otworzysz ją ponownie.';

  @override
  String get stay => 'Zostań';

  @override
  String get leaveLesson => 'Opuść lekcję';

  @override
  String get noActivitiesAvailable => 'Brak dostępnych zadań.';

  @override
  String get previous => '← Wstecz';

  @override
  String get next => 'Dalej →';

  @override
  String stepCounter(int current, int total) {
    return 'Krok $current / $total';
  }

  @override
  String get finishLesson => 'Zakończ lekcję';

  @override
  String get finishing => 'Kończenie...';

  @override
  String get completionSaveError =>
      'Nie udało się zapisać ukończenia lekcji. Spróbuj ponownie.';

  @override
  String get lessonCompleted => 'Lekcja ukończona';

  @override
  String get continueToNextLesson => 'Przejdź do następnej lekcji';

  @override
  String get repeatLesson => 'Powtórz lekcję';

  @override
  String get repeatCheckpoint => 'Powtórz sprawdzian';

  @override
  String get reviewCompletedLessons => 'Przejrzyj ukończone lekcje';

  @override
  String get someTopicsNeedReinforcement =>
      'Niektóre tematy wymagają utrwalenia.';

  @override
  String get lessonMasteredOutcome => 'Wykazano mocne opanowanie.';

  @override
  String get lessonReinforcementOutcome => 'Ukończono z utrwaleniem.';

  @override
  String get lessonIncompleteOutcome => 'Wynik lekcji jest niepełny.';

  @override
  String get lessonMastered => 'Lekcja opanowana';

  @override
  String get courseCompletionRecommended =>
      'Kurs ukończony. Nadal powtarzaj ukończone lekcje.';

  @override
  String get quickReview => 'Krótka powtórka';

  @override
  String get mastered => 'Opanowano';

  @override
  String get fragileMastery => 'Dobra praca. To wymaga jeszcze trochę ćwiczeń.';

  @override
  String unsupportedContent(String type) {
    return 'Nieobsługiwana treść: $type';
  }

  @override
  String get buildsOnEarlierMaterial =>
      'Opiera się na wcześniejszym materiale.';

  @override
  String get stepTypeVocabulary => 'słownictwo';

  @override
  String get stepTypeGrammar => 'gramatyka';

  @override
  String get stepTypeDialogue => 'dialog';

  @override
  String get stepTypeReading => 'czytanie';

  @override
  String get stepTypeExercise => 'ćwiczenie';

  @override
  String get stepTypeMixed => 'mieszane';

  @override
  String get answerLabel => 'Odpowiedź';

  @override
  String get checkAnswer => 'Sprawdź';

  @override
  String selectedAnswer(String answer) {
    return 'Wybrana odpowiedź: $answer';
  }

  @override
  String get correct => 'Poprawnie';

  @override
  String get acceptedWithCorrection => 'Przyjęto z poprawką';

  @override
  String get tryAgain => 'Spróbuj ponownie';

  @override
  String get notCorrectYet => 'Jeszcze niepoprawnie';

  @override
  String get incorrect => 'Niepoprawnie';

  @override
  String get unsupportedActivityType => 'Nieobsługiwany typ zadania';

  @override
  String unsupportedActivityTypeValue(String type) {
    return 'Nieobsługiwany typ zadania: $type';
  }

  @override
  String get matchingNotCheckableYet =>
      'Tego zadania dopasowywania nie można jeszcze sprawdzić.';

  @override
  String recommendedAnswer(String answer) {
    return 'Zalecana odpowiedź: $answer';
  }

  @override
  String feedbackBullet(String message) {
    return '- $message';
  }

  @override
  String exercisePromptSemantics(String prompt) {
    return 'Polecenie ćwiczenia: $prompt';
  }

  @override
  String get settingsTitle => 'O aplikacji i ustawienia';

  @override
  String get releaseStatusLabel => 'Wczesne wydanie publiczne';

  @override
  String get releaseScopeLabel => 'Kurs hiszpańskiego A0 offline';

  @override
  String versionLabel(String version) {
    return 'Wersja $version';
  }

  @override
  String get privacyTitle => 'Prywatność';

  @override
  String get privacyOffline => 'Działa offline.';

  @override
  String get privacyNoAccount => 'Konto nie jest wymagane.';

  @override
  String get privacyNoTracking =>
      'Nie używamy reklam, śledzenia ani analityki.';

  @override
  String get privacyNoAi =>
      'Podczas lekcji aplikacja nie łączy się z usługami AI.';

  @override
  String get privacyLocalProgress =>
      'Postępy nauki pozostają na tym urządzeniu.';

  @override
  String get feedbackTitle => 'Opinie';

  @override
  String get feedbackBody =>
      'W tym wczesnym wydaniu zgłaszaj problemy przez repozytorium projektu albo bezpośrednio do opiekuna projektu.';

  @override
  String get licensesTitle => 'Licencje i podziękowania';

  @override
  String get licensesBody =>
      'Tutor Language jest zbudowany we Flutterze i zawiera autorskie materiały edukacyjne hiszpańskiego A0. Pełne informacje o licencjach i komponentach zewnętrznych zostaną dołączone do publicznego pakietu wydania.';

  @override
  String get competencyScreenTitle => 'Sprawdzenie umiejętności';

  @override
  String get competencyUnavailable =>
      'Sprawdzenie umiejętności jest niedostępne.';

  @override
  String competencyUnavailableWithError(String error) {
    return 'Sprawdzenie umiejętności jest niedostępne. $error';
  }

  @override
  String get competencyTaskUnavailable =>
      'To zadanie sprawdzające jest niedostępne.';

  @override
  String get competencyDiagnosticIntro =>
      'Pokaż, co potrafisz zrobić bez pomocy.';

  @override
  String get competencyRetryIntro =>
      'Spróbuj ponownie wykonać pierwotne zadanie.';

  @override
  String get competencyRecoveryIntro =>
      'Krótko powtórzmy jedną część i spróbujmy ponownie.';

  @override
  String get startReview => 'Rozpocznij powtórkę';

  @override
  String get recoveryActivityUnavailable =>
      'Zadanie powtórkowe jest niedostępne.';

  @override
  String get competencyCheckComplete => 'Sprawdzenie umiejętności zakończone.';

  @override
  String get retryCompetencyCheck => 'Powtórz sprawdzenie umiejętności';

  @override
  String get competencyAchievedTitle => 'Umiejętność potwierdzona';

  @override
  String get competencyAchievedAfterReviewTitle =>
      'Umiejętność potwierdzona po powtórce';

  @override
  String get competencyNeedsPracticeTitle => 'Umiejętność wymaga ćwiczeń';

  @override
  String get competencyNotYetAchievedTitle =>
      'Umiejętność jeszcze niepotwierdzona';

  @override
  String get competencyAchievedDescription =>
      'Samodzielnie wykonano zadanie komunikacyjne.';

  @override
  String get competencyAchievedAfterReviewDescription =>
      'Użyto powtórki, a potem wykonano zadanie komunikacyjne.';

  @override
  String get competencyNeedsPracticeDescription =>
      'Pokazano część celu. Powtórz, gdy będziesz gotowy.';

  @override
  String get competencyNotYetAchievedDescription =>
      'Główny cel nie jest jeszcze pewny. Powtórz po przejrzeniu materiału.';

  @override
  String get notViewed => 'Nie wyświetlono';

  @override
  String get viewed => 'Wyświetlono';

  @override
  String activitiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zadania',
      many: '$count zadań',
      few: '$count zadania',
      one: '1 zadanie',
      zero: 'Brak zadań',
    );
    return '$_temp0';
  }

  @override
  String get noAnswerChoices => 'Ten szablon nie zawiera wariantów odpowiedzi.';

  @override
  String get unchecked => 'Niesprawdzone';

  @override
  String templateType(String type) {
    return 'Typ: $type';
  }

  @override
  String templatePrompt(String prompt) {
    return 'Polecenie: $prompt';
  }

  @override
  String requiredObjectTypesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wymaganego typu obiektu',
      many: '$count wymaganych typów obiektów',
      few: '$count wymagane typy obiektów',
      one: '1 wymagany typ obiektu',
      zero: 'Brak wymaganych typów obiektów',
    );
    return '$_temp0';
  }

  @override
  String supportedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count obsługiwanego celu',
      many: '$count obsługiwanych celów',
      few: '$count obsługiwane cele',
      one: '1 obsługiwany cel',
      zero: 'Brak obsługiwanych celów',
    );
    return '$_temp0';
  }

  @override
  String get feedbackPreferredOrderNoCanonical =>
      'Tutaj akceptowana jest inna kolejność.';

  @override
  String feedbackPreferredOrder(String answer) {
    return 'Bardziej naturalna kolejność: $answer';
  }

  @override
  String feedbackSpanishInterrogativeQueRequiresAccent(String canonical) {
    return 'W tym pytaniu „$canonical” wymaga akcentu.';
  }

  @override
  String feedbackSpanishInterrogativeComoRequiresAccent(String canonical) {
    return 'W tym pytaniu „$canonical” wymaga akcentu.';
  }

  @override
  String feedbackSpanishMissingDiacritic(String canonical) {
    return 'Normatywna pisownia hiszpańska: „$canonical”.';
  }

  @override
  String get feedbackSpanishQuestionMissingOpeningMark =>
      'Hiszpańskie pytania zaczynają się od „¿”.';

  @override
  String get feedbackSpanishQuestionMissingClosingMark =>
      'Hiszpańskie pytania kończą się znakiem „?”.';

  @override
  String get feedbackSpanishExclamationMissingOpeningMark =>
      'Hiszpańskie wykrzyknienia zaczynają się od „¡”.';

  @override
  String get feedbackSpanishExclamationMissingClosingMark =>
      'Hiszpańskie wykrzyknienia kończą się znakiem „!”.';

  @override
  String feedbackUseCanonicalForm(String canonical) {
    return 'Użyj formy normatywnej: „$canonical”.';
  }

  @override
  String get feedbackQuestionExpectedStatementProvided =>
      'To ćwiczenie prosi o pytanie.\nWpisano odpowiedź.\nSpróbuj napisać hiszpańskie pytanie.';

  @override
  String get feedbackStatementExpectedQuestionProvided =>
      'To ćwiczenie prosi o zdanie oznajmujące.\nWpisano pytanie.\nSpróbuj napisać hiszpańskie zdanie oznajmujące.';

  @override
  String get feedbackAnswerExpectedQuestion =>
      'To ćwiczenie prosi o odpowiedź.\nWpisano inne pytanie.';

  @override
  String get feedbackQuestionExpectedAnswer => 'Napisz pytanie, nie odpowiedź.';

  @override
  String get feedbackTranslationExpectedSourceLanguage =>
      'Przetłumacz polecenie zamiast je kopiować.';

  @override
  String get feedbackGreetingExpectedFarewell =>
      'To ćwiczenie prosi o powitanie.\nWpisano pożegnanie.';

  @override
  String get feedbackFarewellExpectedGreeting =>
      'To ćwiczenie prosi o pożegnanie.\nWpisano powitanie.';

  @override
  String get feedbackNamePatternUseMeLlamo =>
      'W tym wzorcu przedstawiania się użyj „me llamo”.';

  @override
  String get feedbackOriginUseSer =>
      'Aby podać pochodzenie, hiszpański używa „soy de”.';

  @override
  String get feedbackOriginKeepDe =>
      'Zachowaj „de” we wzorcu pochodzenia: „soy de”.';

  @override
  String get feedbackOriginUseSoyDe => '„Soy de” mówi, skąd ktoś pochodzi.';

  @override
  String get feedbackOriginQuestionIncludeDe =>
      'Użyj „¿De dónde eres?”, aby zapytać, skąd ktoś pochodzi.';

  @override
  String get feedbackResidenceUseVivoEn =>
      '„Vivo en” mówi, gdzie ktoś mieszka.';

  @override
  String get feedbackResidenceQuestionNoDe =>
      'Użyj „¿Dónde vives?”, aby zapytać, gdzie ktoś mieszka.';

  @override
  String get feedbackLanguagesUseHablo =>
      'Użyj „hablo”, aby powiedzieć, jakim językiem mówisz.';

  @override
  String get feedbackLanguagesUseLanguageNames =>
      'Używaj nazw języków, takich jak „ucraniano” lub „ruso”.';

  @override
  String get feedbackLanguagesKeepDeAfterUnPoco =>
      'Zachowaj „de” w „un poco de” przed nazwą języka.';

  @override
  String get feedbackLanguagesAskIdiomas =>
      'Użyj „idiomas”, gdy pytasz, jakimi językami ktoś mówi.';

  @override
  String get feedbackIdentityAskSpecificQuestions =>
      'Użyj pytania pasującego do potrzebnej informacji.';

  @override
  String get feedbackOriginResidenceDoNotSwap =>
      'Nie zamieniaj pochodzenia i miejsca zamieszkania: „soy de” to pochodzenie, „vivo en” to miejsce zamieszkania.';

  @override
  String get feedbackPeopleUseEsForOther =>
      'Użyj „es”, gdy mówisz o innej osobie.';

  @override
  String get feedbackPeopleUseSeLlama =>
      'Użyj „se llama”, aby podać imię innej osoby.';

  @override
  String get feedbackPeopleUseFeminineRole =>
      'Dla tej osoby użyj żeńskiej formy roli.';

  @override
  String get feedbackPeopleUseMasculineRole =>
      'Dla tej osoby użyj męskiej formy roli.';

  @override
  String get feedbackPeopleQuestionQuienNotComo =>
      '„¿Quién es?” pyta, kim jest ta osoba.';

  @override
  String get feedbackPeopleQuestionComoNotQuien =>
      '„¿Cómo es?” pyta, jaka jest ta osoba.';

  @override
  String get feedbackPeopleUseFeminineDescription =>
      'Dla tej osoby użyj żeńskiej formy opisu.';

  @override
  String get feedbackPeopleUseMasculineDescription =>
      'Dla tej osoby użyj męskiej formy opisu.';

  @override
  String get feedbackPeopleUseViveForOther =>
      'Użyj „vive”, gdy mówisz, gdzie mieszka inna osoba.';

  @override
  String get feedbackPeopleUseHablaForOther =>
      'Użyj „habla”, gdy mówisz, jakim językiem mówi inna osoba.';

  @override
  String get feedbackPeopleOriginResidenceContrast =>
      '„Es de” oznacza pochodzenie; „vive en” oznacza miejsce zamieszkania.';

  @override
  String get feedbackPeopleLanguageNotNationality =>
      'Użyj „habla”, aby powiedzieć, jakim językiem mówi inna osoba.';

  @override
  String get feedbackPeopleThirdPersonSequence =>
      'Cała odpowiedź o innej osobie powinna być w trzeciej osobie.';

  @override
  String get feedbackPeopleQuestionOrderMatters =>
      'Użyj pytań w kolejności podanej w poleceniu.';

  @override
  String get feedbackPeopleQuestionAndPersonForm =>
      'Użyj wymaganego pytania i formy czasownika dla trzeciej osoby.';

  @override
  String get feedbackShoppingUseQueForObject =>
      'Użyj „¿Qué es esto?”, aby zapytać, co to za przedmiot.';

  @override
  String get feedbackShoppingUseCuantoForPrice =>
      'Użyj „¿Cuánto cuesta?”, aby zapytać o cenę.';

  @override
  String get feedbackShoppingUseCuestaForPrice =>
      'Użyj „cuesta”, gdy podajesz cenę jednego przedmiotu.';

  @override
  String get feedbackShoppingUsePoliteTiene =>
      'W tym module użyj uprzejmego pytania sklepowego „¿Tiene...?”.';

  @override
  String get feedbackShoppingUseTenemosForShop =>
      'Użyj „tenemos”, gdy sklep mówi, co ma.';

  @override
  String get feedbackShoppingUseQuieroForPurchase =>
      'Użyj „quiero”, aby powiedzieć, co chcesz kupić.';

  @override
  String get feedbackShoppingUseUnaFeminine =>
      'Użyj „una” z ćwiczonym rzeczownikiem żeńskim, takim jak „botella” lub „bolsa”.';

  @override
  String get feedbackShoppingUseEsteMasculine =>
      'Użyj „este” przed ćwiczonym rzeczownikiem męskim, takim jak „libro”.';

  @override
  String get feedbackShoppingUseEstaFeminine =>
      'Użyj „esta” przed ćwiczonym rzeczownikiem żeńskim, takim jak „bolsa”.';

  @override
  String get feedbackShoppingUseMasculinePriceAdjective =>
      'Z tym rzeczownikiem męskim użyj męskiej formy przymiotnika.';

  @override
  String get feedbackShoppingUseFemininePriceAdjective =>
      'Z tym rzeczownikiem żeńskim użyj żeńskiej formy przymiotnika.';

  @override
  String get feedbackTransportUseAPie => 'Użyj „a pie”, gdy idziesz pieszo.';

  @override
  String get feedbackDirectionsUseDondeForLocation =>
      'Użyj „¿Dónde está...?“, aby zapytać, gdzie znajduje się miejsce.';

  @override
  String get feedbackDirectionsUseEstaForLocation =>
      'Użyj „está”, aby powiedzieć, gdzie znajduje się miejsce.';

  @override
  String get feedbackDirectionsLeftNotRight => '„Izquierda” znaczy w lewo.';

  @override
  String get feedbackDirectionsRightNotLeft => '„Derecha” znaczy w prawo.';

  @override
  String get feedbackDirectionsFarNotNear => '„Lejos” znaczy daleko.';

  @override
  String get feedbackDirectionsUseComoForRoute =>
      'Użyj „¿Cómo llego...?“, aby zapytać, jak dotrzeć.';

  @override
  String get feedbackDirectionsRouteOrderMatters =>
      'W tym ćwiczeniu kolejność trasy ma znaczenie. Postępuj według podanej sekwencji.';

  @override
  String get feedbackTransportUseTomaForAdvice =>
      'Użyj „toma”, gdy doradzasz, jaki transport wybrać.';

  @override
  String get feedbackDirectionsDirectionNotLocation =>
      'To ćwiczenie prosi o wskazówki dojścia, nie tylko o położenie miejsca.';

  @override
  String get feedbackHelpPoliteOpeningFirst =>
      'Zacznij od uprzejmego zwrotu, potem poproś o usługę.';

  @override
  String get feedbackHelpIncludePoliteAttention =>
      'Dodaj uprzejmy zwrot przed pilną prośbą.';

  @override
  String get feedbackAnswersUsuallyDoNotBeginQuestionMark =>
      'Odpowiedzi i zdania oznajmujące zwykle nie zaczynają się od „¿”.';

  @override
  String get feedbackQuestionsBeginWith => 'Pytania zaczynają się od: ¿...';

  @override
  String feedbackStartsWith(String prefix) {
    return 'Zaczyna się od: $prefix';
  }
}
