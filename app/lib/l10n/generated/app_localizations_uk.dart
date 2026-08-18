// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Tutor Language';

  @override
  String get settingsTooltip => 'Налаштування';

  @override
  String get backTooltip => 'Назад';

  @override
  String get backToCourse => 'Назад до курсу';

  @override
  String get openCourse => 'Відкрити курс';

  @override
  String get courseTitle => 'Курс';

  @override
  String courseProgress(int completed, int total) {
    return 'Виконано $completed з $total уроків';
  }

  @override
  String get courseComplete => 'Курс завершено';

  @override
  String get noUnitsAvailable => 'Немає доступних розділів.';

  @override
  String get noLessonsAvailable => 'Немає доступних уроків.';

  @override
  String get lessonStatusCompleted => 'Завершено';

  @override
  String get lessonStatusAvailableNext => 'Доступно далі';

  @override
  String get lessonStatusLocked => 'Заблоковано';

  @override
  String moduleNumber(String number) {
    return 'Модуль $number';
  }

  @override
  String lessonNumber(String number) {
    return 'Урок $number';
  }

  @override
  String get competencyCheck => 'Перевірка комунікативної навички';

  @override
  String get competencyAchieved => 'Комунікативну навичку підтверджено';

  @override
  String get competencyAchievedAfterReview =>
      'Комунікативну навичку підтверджено після повторення';

  @override
  String get competencyNeedsPractice =>
      'Комунікативна навичка потребує практики';

  @override
  String get competencyNotYetAchieved =>
      'Комунікативну навичку ще не підтверджено';

  @override
  String get competencyCompleteModuleFirst => 'Спершу завершіть цей модуль';

  @override
  String get competencyReadyToStart => 'Можна починати';

  @override
  String get competencyContinueCheck => 'Продовжити перевірку';

  @override
  String get competencyGoalDemonstrated => 'Ви показали ціль цього модуля';

  @override
  String get competencySucceededAfterReview =>
      'Ви впоралися після цільового повторення';

  @override
  String get competencyRetryWhenReady =>
      'Повторіть перевірку, коли будете готові';

  @override
  String get start => 'Почати';

  @override
  String get continueAction => 'Продовжити';

  @override
  String get retry => 'Повторити';

  @override
  String get lessonTitle => 'Урок';

  @override
  String get previousLesson => 'Попередній урок';

  @override
  String get nextLesson => 'Наступний урок';

  @override
  String lessonLaunchError(String error) {
    return 'Не вдалося відкрити урок.\n$error';
  }

  @override
  String get lessonPlayerTitle => 'Урок';

  @override
  String get leaveLessonTitle => 'Вийти з уроку?';

  @override
  String get leaveLessonBody =>
      'Незавершений урок почнеться спочатку, коли ви відкриєте його знову.';

  @override
  String get stay => 'Залишитися';

  @override
  String get leaveLesson => 'Вийти з уроку';

  @override
  String get noActivitiesAvailable => 'Немає доступних завдань.';

  @override
  String get previous => '← Назад';

  @override
  String get next => 'Далі →';

  @override
  String stepCounter(int current, int total) {
    return 'Крок $current / $total';
  }

  @override
  String get finishLesson => 'Завершити урок';

  @override
  String get finishing => 'Завершення...';

  @override
  String get completionSaveError =>
      'Не вдалося зберегти завершення уроку. Спробуйте ще раз.';

  @override
  String get lessonCompleted => 'Урок завершено';

  @override
  String get continueToNextLesson => 'Перейти до наступного уроку';

  @override
  String get repeatLesson => 'Повторити урок';

  @override
  String get repeatFromStep => 'Повторити з вибраного кроку';

  @override
  String get repeatCheckpoint => 'Повторити контрольну перевірку';

  @override
  String get reviewCompletedLessons => 'Переглянути завершені уроки';

  @override
  String get someTopicsNeedReinforcement =>
      'Деякі теми потребуватимуть закріплення.';

  @override
  String get lessonMasteredOutcome => 'Показано впевнене засвоєння.';

  @override
  String get lessonReinforcementOutcome => 'Завершено із закріпленням.';

  @override
  String get lessonIncompleteOutcome => 'Результат уроку неповний.';

  @override
  String get lessonMastered => 'Урок засвоєно';

  @override
  String get courseCompletionRecommended =>
      'Курс завершено. Продовжуйте повторювати завершені уроки.';

  @override
  String get quickReview => 'Коротке повторення';

  @override
  String get mastered => 'Засвоєно';

  @override
  String get fragileMastery => 'Добра робота. Це ще потребує трохи практики.';

  @override
  String unsupportedContent(String type) {
    return 'Непідтримуваний вміст: $type';
  }

  @override
  String get buildsOnEarlierMaterial => 'Спирається на попередній матеріал.';

  @override
  String get stepTypeVocabulary => 'лексика';

  @override
  String get stepTypeGrammar => 'граматика';

  @override
  String get stepTypeDialogue => 'діалог';

  @override
  String get stepTypeReading => 'читання';

  @override
  String get stepTypeExercise => 'вправа';

  @override
  String get stepTypeMixed => 'змішане';

  @override
  String get answerLabel => 'Відповідь';

  @override
  String get learnerSpeakerLabel => 'Ти';

  @override
  String get checkAnswer => 'Перевірити';

  @override
  String dialogueProgress(int current, int total) {
    return 'Діалог $current / $total';
  }

  @override
  String selectedAnswer(String answer) {
    return 'Вибрана відповідь: $answer';
  }

  @override
  String get correct => 'Правильно';

  @override
  String get acceptedWithCorrection => 'Прийнято з виправленням';

  @override
  String get tryAgain => 'Спробувати ще раз';

  @override
  String get notCorrectYet => 'Поки що не правильно';

  @override
  String get incorrect => 'Неправильно';

  @override
  String feedbackMultilineMissing(int submitted, int expected) {
    return 'Введено $submitted з $expected реплік. Доповни діалог.';
  }

  @override
  String feedbackMultilineExtra(int submitted, int expected) {
    return 'Введено $submitted реплік замість $expected. Перевір діалог.';
  }

  @override
  String feedbackMultilineIncorrectLines(
    int correct,
    int expected,
    String lines,
  ) {
    return '$correct з $expected реплік правильні. Перевір репліки: $lines.';
  }

  @override
  String feedbackMultilineIncomplete(int submitted) {
    return 'Введено $submitted реплік. Доповни діалог.';
  }

  @override
  String feedbackMultilineTooMany(int submitted) {
    return 'Введено $submitted реплік. Перевір діалог.';
  }

  @override
  String get unsupportedActivityType => 'Непідтримуваний тип завдання';

  @override
  String unsupportedActivityTypeValue(String type) {
    return 'Непідтримуваний тип завдання: $type';
  }

  @override
  String get matchingNotCheckableYet =>
      'Це завдання на встановлення відповідностей поки неможливо перевірити.';

  @override
  String recommendedAnswer(String answer) {
    return 'Рекомендована відповідь: $answer';
  }

  @override
  String feedbackBullet(String message) {
    return '- $message';
  }

  @override
  String exercisePromptSemantics(String prompt) {
    return 'Умова вправи: $prompt';
  }

  @override
  String get settingsTitle => 'Про застосунок і налаштування';

  @override
  String get releaseStatusLabel => 'Ранній публічний випуск';

  @override
  String get releaseScopeLabel => 'Офлайн-курс іспанської A0';

  @override
  String versionLabel(String version) {
    return 'Версія $version';
  }

  @override
  String get privacyTitle => 'Приватність';

  @override
  String get privacyOffline => 'Працює офлайн.';

  @override
  String get privacyNoAccount => 'Обліковий запис не потрібен.';

  @override
  String get privacyNoTracking =>
      'Реклама, відстеження й аналітика не використовуються.';

  @override
  String get privacyNoAi =>
      'Під час уроків застосунок не звертається до AI-сервісів.';

  @override
  String get privacyLocalProgress =>
      'Прогрес навчання зберігається на цьому пристрої.';

  @override
  String get feedbackTitle => 'Зворотний зв’язок';

  @override
  String get feedbackBody =>
      'Для цього раннього випуску повідомляйте про проблеми через репозиторій проєкту або безпосередньо супровіднику проєкту.';

  @override
  String get licensesTitle => 'Ліцензії та подяки';

  @override
  String get licensesBody =>
      'Tutor Language створено на Flutter і містить авторський навчальний контент іспанської A0. Повну інформацію про ліцензії та сторонні компоненти буде додано до публічного релізного пакета.';

  @override
  String get competencyScreenTitle => 'Перевірка навички';

  @override
  String get competencyUnavailable => 'Перевірка навички недоступна.';

  @override
  String competencyUnavailableWithError(String error) {
    return 'Перевірка навички недоступна. $error';
  }

  @override
  String get competencyTaskUnavailable => 'Це завдання перевірки недоступне.';

  @override
  String get competencyDiagnosticIntro =>
      'Покажіть, що можете зробити без підказок.';

  @override
  String get competencyRetryIntro => 'Спробуйте початкове завдання ще раз.';

  @override
  String get competencyRecoveryIntro =>
      'Коротко повторімо одну частину й спробуймо знову.';

  @override
  String get startReview => 'Почати повторення';

  @override
  String get recoveryActivityUnavailable =>
      'Завдання для повторення недоступне.';

  @override
  String get competencyCheckComplete => 'Перевірку навички завершено.';

  @override
  String get retryCompetencyCheck => 'Повторити перевірку навички';

  @override
  String get competencyAchievedTitle => 'Навичку підтверджено';

  @override
  String get competencyAchievedAfterReviewTitle =>
      'Навичку підтверджено після повторення';

  @override
  String get competencyNeedsPracticeTitle => 'Навичка потребує практики';

  @override
  String get competencyNotYetAchievedTitle => 'Навичку ще не підтверджено';

  @override
  String get competencyAchievedDescription =>
      'Ви самостійно виконали комунікативне завдання.';

  @override
  String get competencyAchievedAfterReviewDescription =>
      'Ви скористалися повторенням, а потім виконали комунікативне завдання.';

  @override
  String get competencyNeedsPracticeDescription =>
      'Ви показали частину цілі. Повторіть, коли будете готові.';

  @override
  String get competencyNotYetAchievedDescription =>
      'Ключова ціль ще не закріплена. Повторіть після перегляду матеріалу.';

  @override
  String get notViewed => 'Не переглянуто';

  @override
  String get viewed => 'Переглянуто';

  @override
  String activitiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count завдання',
      many: '$count завдань',
      few: '$count завдання',
      one: '1 завдання',
      zero: 'Немає завдань',
    );
    return '$_temp0';
  }

  @override
  String get noAnswerChoices => 'У цьому шаблоні немає варіантів відповіді.';

  @override
  String get unchecked => 'Не перевірено';

  @override
  String templateType(String type) {
    return 'Тип: $type';
  }

  @override
  String templatePrompt(String prompt) {
    return 'Умова: $prompt';
  }

  @override
  String requiredObjectTypesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count обов’язкового типу об’єкта',
      many: '$count обов’язкових типів об’єктів',
      few: '$count обов’язкові типи об’єктів',
      one: '1 обов’язковий тип об’єкта',
      zero: 'Немає обов’язкових типів об’єктів',
    );
    return '$_temp0';
  }

  @override
  String supportedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count підтримуваної цілі',
      many: '$count підтримуваних цілей',
      few: '$count підтримувані цілі',
      one: '1 підтримувана ціль',
      zero: 'Немає підтримуваних цілей',
    );
    return '$_temp0';
  }

  @override
  String get feedbackPreferredOrderNoCanonical =>
      'Тут приймається інший порядок.';

  @override
  String feedbackPreferredOrder(String answer) {
    return 'Природніший порядок: $answer';
  }

  @override
  String feedbackSpanishInterrogativeQueRequiresAccent(String canonical) {
    return 'У цьому питанні «$canonical» пишеться з наголосом.';
  }

  @override
  String feedbackSpanishInterrogativeComoRequiresAccent(String canonical) {
    return 'У цьому питанні «$canonical» пишеться з наголосом.';
  }

  @override
  String feedbackSpanishMissingDiacritic(String canonical) {
    return 'Нормативне іспанське написання: «$canonical».';
  }

  @override
  String get feedbackSpanishQuestionMissingOpeningMark =>
      'Іспанські питання починаються з «¿».';

  @override
  String get feedbackSpanishQuestionMissingClosingMark =>
      'Іспанські питання закінчуються знаком «?».';

  @override
  String get feedbackSpanishExclamationMissingOpeningMark =>
      'Іспанські окличні речення починаються з «¡».';

  @override
  String get feedbackSpanishExclamationMissingClosingMark =>
      'Іспанські окличні речення закінчуються знаком «!».';

  @override
  String feedbackUseCanonicalForm(String canonical) {
    return 'Використайте нормативну форму: «$canonical».';
  }

  @override
  String get feedbackQuestionExpectedStatementProvided =>
      'У цій вправі потрібно написати питання.\nВи написали відповідь.\nСпробуйте написати іспанське питання.';

  @override
  String get feedbackStatementExpectedQuestionProvided =>
      'У цій вправі потрібно написати твердження.\nВи написали питання.\nСпробуйте написати іспанське твердження.';

  @override
  String get feedbackAnswerExpectedQuestion =>
      'У цій вправі потрібно написати відповідь.\nВи написали інше питання.';

  @override
  String get feedbackQuestionExpectedAnswer =>
      'Напишіть питання, а не відповідь.';

  @override
  String get feedbackTranslationExpectedSourceLanguage =>
      'Перекладіть підказку, а не копіюйте її.';

  @override
  String get feedbackGreetingExpectedFarewell =>
      'У цій вправі потрібне привітання.\nВи написали прощання.';

  @override
  String get feedbackFarewellExpectedGreeting =>
      'У цій вправі потрібне прощання.\nВи написали привітання.';

  @override
  String get feedbackNamePatternUseMeLlamo =>
      'У цьому шаблоні представлення використовуйте «me llamo».';

  @override
  String get feedbackOriginUseSer =>
      'Щоб сказати про походження, в іспанській використовується «soy de».';

  @override
  String get feedbackOriginKeepDe =>
      'Залишайте «de» у шаблоні походження: «soy de».';

  @override
  String get feedbackOriginUseSoyDe => '«Soy de» означає, звідки людина.';

  @override
  String get feedbackOriginQuestionIncludeDe =>
      'Щоб запитати, звідки людина, використовуйте «¿De dónde eres?».';

  @override
  String get feedbackResidenceUseVivoEn => '«Vivo en» означає, де людина живе.';

  @override
  String get feedbackResidenceQuestionNoDe =>
      'Щоб запитати, де людина живе, використовуйте «¿Dónde vives?».';

  @override
  String get feedbackLanguagesUseHablo =>
      'Використовуйте «hablo», щоб сказати, якою мовою ви говорите.';

  @override
  String get feedbackLanguagesUseLanguageNames =>
      'Використовуйте назви мов, наприклад «ucraniano» або «ruso».';

  @override
  String get feedbackLanguagesKeepDeAfterUnPoco =>
      'Залишайте «de» у «un poco de» перед назвою мови.';

  @override
  String get feedbackLanguagesAskIdiomas =>
      'Використовуйте «idiomas», коли питаєте, якими мовами хтось говорить.';

  @override
  String get feedbackIdentityAskSpecificQuestions =>
      'Використовуйте питання, яке відповідає потрібній інформації.';

  @override
  String get feedbackOriginResidenceDoNotSwap =>
      'Не плутайте походження й місце проживання: «soy de» — походження, «vivo en» — проживання.';

  @override
  String get feedbackPeopleUseEsForOther =>
      'Використовуйте «es», коли говорите про іншу людину.';

  @override
  String get feedbackPeopleUseSeLlama =>
      'Використовуйте «se llama», щоб сказати ім’я іншої людини.';

  @override
  String get feedbackPeopleUseFeminineRole =>
      'Для цієї людини використайте форму ролі жіночого роду.';

  @override
  String get feedbackPeopleUseMasculineRole =>
      'Для цієї людини використайте форму ролі чоловічого роду.';

  @override
  String get feedbackPeopleQuestionQuienNotComo =>
      '«¿Quién es?» питає, хто ця людина.';

  @override
  String get feedbackPeopleQuestionComoNotQuien =>
      '«¿Cómo es?» питає, яка ця людина.';

  @override
  String get feedbackPeopleUseFeminineDescription =>
      'Для цієї людини використайте опис у жіночому роді.';

  @override
  String get feedbackPeopleUseMasculineDescription =>
      'Для цієї людини використайте опис у чоловічому роді.';

  @override
  String get feedbackPeopleUseViveForOther =>
      'Використовуйте «vive», коли говорите, де живе інша людина.';

  @override
  String get feedbackPeopleUseHablaForOther =>
      'Використовуйте «habla», коли говорите, якою мовою говорить інша людина.';

  @override
  String get feedbackPeopleOriginResidenceContrast =>
      '«Es de» означає походження; «vive en» — місце проживання.';

  @override
  String get feedbackPeopleLanguageNotNationality =>
      'Використовуйте «habla», щоб сказати, якою мовою говорить інша людина.';

  @override
  String get feedbackPeopleThirdPersonSequence =>
      'Уся відповідь про іншу людину має бути в третій особі.';

  @override
  String get feedbackPeopleQuestionOrderMatters =>
      'Використовуйте питання в порядку, заданому в умові.';

  @override
  String get feedbackPeopleQuestionAndPersonForm =>
      'Використайте потрібне питання й форму дієслова для третьої особи.';

  @override
  String get feedbackShoppingUseQueForObject =>
      'Використовуйте «¿Qué es esto?», щоб запитати, що це за предмет.';

  @override
  String get feedbackShoppingUseCuantoForPrice =>
      'Використовуйте «¿Cuánto cuesta?», щоб запитати ціну.';

  @override
  String get feedbackShoppingUseCuestaForPrice =>
      'Використовуйте «cuesta», коли називаєте ціну одного предмета.';

  @override
  String get feedbackShoppingUsePoliteTiene =>
      'У цьому модулі використовуйте ввічливе питання в магазині «¿Tiene...?».';

  @override
  String get feedbackShoppingUseTenemosForShop =>
      'Використовуйте «tenemos», коли магазин говорить, що має.';

  @override
  String get feedbackShoppingUseQuieroForPurchase =>
      'Використовуйте «quiero», щоб сказати, що хочете купити.';

  @override
  String get feedbackShoppingUseUnaFeminine =>
      'Використовуйте «una» з відпрацьованим іменником жіночого роду, наприклад «botella» або «bolsa».';

  @override
  String get feedbackShoppingUseEsteMasculine =>
      'Використовуйте «este» перед відпрацьованим іменником чоловічого роду, наприклад «libro».';

  @override
  String get feedbackShoppingUseEstaFeminine =>
      'Використовуйте «esta» перед відпрацьованим іменником жіночого роду, наприклад «bolsa».';

  @override
  String get feedbackShoppingUseMasculinePriceAdjective =>
      'З цим іменником чоловічого роду використайте прикметник у чоловічому роді.';

  @override
  String get feedbackShoppingUseFemininePriceAdjective =>
      'З цим іменником жіночого роду використайте прикметник у жіночому роді.';

  @override
  String get feedbackTransportUseAPie =>
      'Використовуйте «a pie», коли йдете пішки.';

  @override
  String get feedbackDirectionsUseDondeForLocation =>
      'Використовуйте «¿Dónde está...?», щоб запитати, де розташоване місце.';

  @override
  String get feedbackDirectionsUseEstaForLocation =>
      'Використовуйте «está», щоб сказати, де розташоване місце.';

  @override
  String get feedbackDirectionsLeftNotRight => '«Izquierda» означає ліворуч.';

  @override
  String get feedbackDirectionsRightNotLeft => '«Derecha» означає праворуч.';

  @override
  String get feedbackDirectionsFarNotNear => '«Lejos» означає далеко.';

  @override
  String get feedbackDirectionsUseComoForRoute =>
      'Використовуйте «¿Cómo llego...?», щоб запитати, як дістатися.';

  @override
  String get feedbackDirectionsRouteOrderMatters =>
      'У цій вправі порядок маршруту важливий. Дотримуйтеся заданої послідовності.';

  @override
  String get feedbackTransportUseTomaForAdvice =>
      'Використовуйте «toma», коли радите, яким транспортом скористатися.';

  @override
  String get feedbackDirectionsDirectionNotLocation =>
      'У цій вправі потрібні вказівки маршруту, а не лише розташування місця.';

  @override
  String get feedbackHelpPoliteOpeningFirst =>
      'Почніть з ввічливого звертання, потім попросіть послугу.';

  @override
  String get feedbackHelpIncludePoliteAttention =>
      'Додайте ввічливе звертання перед терміновим проханням.';

  @override
  String get feedbackAnswersUsuallyDoNotBeginQuestionMark =>
      'Відповіді й твердження зазвичай не починаються з «¿».';

  @override
  String get feedbackQuestionsBeginWith => 'Питання починаються з: ¿...';

  @override
  String feedbackStartsWith(String prefix) {
    return 'Починається з: $prefix';
  }

  @override
  String get primerTitle => 'Іспанський алфавіт';

  @override
  String get primerSubtitle =>
      'Необов\'язкова карта читання на 5–10 хвилин перед уроком 1.';

  @override
  String get primerInProgress =>
      'Продовжіть необов\'язкову підготовку до читання.';

  @override
  String get primerCompleted => 'Завершено. Ви можете повторити будь-коли.';

  @override
  String get primerSkipped =>
      'Пропущено. Ви можете відкрити підготовку будь-коли.';

  @override
  String get primerUnavailable => 'Необов\'язкова підтримка читання';

  @override
  String get primerStart => 'Почати підготовку';

  @override
  String get primerReview => 'Повторити підготовку';

  @override
  String get primerOptional =>
      'Необов\'язкова підготовка — урок 1 залишається доступним.';

  @override
  String get primerIntro =>
      'Нижче показано, як приблизно звучать іспанські літери. Читання слів ви поступово вивчатимете в уроках.';

  @override
  String get primerContinue => 'Перейти до уроку 1';

  @override
  String get primerAlphabetTitle => 'Іспанський алфавіт';

  @override
  String get primerAlphabetRows =>
      'A (а) — а\nB (бе) — б\nC (се) — к або с\nD (де) — д\nE (е) — е\nF (ефе) — ф\nG (хе) — г або х\nH (аче) — не читається\nI (і) — і\nJ (хота) — приблизно х\nK (ка) — к\nL (еле) — л\nM (еме) — м\nN (ене) — н\nÑ (еньє) — приблизно нь\nO (о) — о\nP (пе) — п\nQ (ку) — к\nR (ерре) — р\nS (есе) — с\nT (те) — т\nU (у) — у\nV (уве) — приблизно б\nW (уве добле) — звучання залежить від слова\nX (екіс) — переважно кс\nY (і грієга) — приблизно й або і\nZ (сета) — приблизно с';

  @override
  String get primerDigraphTitle => 'Поширені сполучення букв';

  @override
  String get primerDigraphRows =>
      'CH (че) — приблизно ч\nLL (ельє) — приблизно й';

  @override
  String get primerSkip => 'Пропустити зараз';

  @override
  String primerSectionCounter(int current, int total) {
    return 'Карта читання: $current з $total';
  }

  @override
  String get primerExamples => 'Реальні іспанські приклади';

  @override
  String get primerLettersTitle => 'Літери й поширені сполучення';

  @override
  String get primerExamplesTitle => 'Реальні приклади з курсу';

  @override
  String get primerReviewTitle => 'Коротка перевірка читання';

  @override
  String get primerLetterColumn => 'Іспанська форма';

  @override
  String get primerReadingColumn => 'Як приблизно читається';

  @override
  String get primerSpanishColumn => 'Іспанською';

  @override
  String get primerMeaningColumn => 'Значення';

  @override
  String get primerStressHint =>
      'Склад великими літерами вимовляється з наголосом.';

  @override
  String get primerLetterH => 'h (аче)';

  @override
  String get primerReadingA => 'а';

  @override
  String get primerReadingE => 'е';

  @override
  String get primerReadingI => 'і';

  @override
  String get primerReadingO => 'о';

  @override
  String get primerReadingU => 'у';

  @override
  String get primerReadingH => 'не читається';

  @override
  String get primerReadingJ => 'приблизно як українське «х»';

  @override
  String get primerReadingEnye => 'приблизно як «нь»';

  @override
  String get primerReadingLl => 'приблизно як «й»; у llamo — «я»';

  @override
  String get primerReadingR => 'коротке «р»';

  @override
  String get primerReadingRr => 'сильніше, розкотисте «р»';

  @override
  String get primerApproxReadingLabel => 'Приблизно читається';

  @override
  String get primerReadingHola => 'О-ла';

  @override
  String get primerReadingMe => 'ме';

  @override
  String get primerReadingTu => 'ту';

  @override
  String get primerReadingBuenosDias => 'БУ-Е-нос ДІ-ас';

  @override
  String get primerReadingHastaLuego => 'АС-та ЛУ-Е-го';

  @override
  String get primerReadingMeLlamo => 'ме Я-мо';

  @override
  String get primerReadingYTu => 'і ту';

  @override
  String get primerReadingEspana => 'ес-ПА-нья';

  @override
  String get primerReadingMadrid => 'ма-ДРІД';

  @override
  String get primerReadingComo => 'КО-мо';

  @override
  String get primerReadingComoTeLlamas => 'КО-мо те Я-мас';

  @override
  String get primerReadingGracias => 'ГРА-сіас';

  @override
  String get primerReadingPrompt => 'Звичка читання';

  @override
  String get primerRecognitionPrompt =>
      'Прочитайте іспанську форму цілком, зверніть увагу на потрібну закономірність і збережіть приклад для наступних уроків.';

  @override
  String get primerFinish => 'Завершити підготовку';

  @override
  String get primerReopenHint =>
      'Ця підготовка необов\'язкова, і її можна повторити з екрана курсу.';

  @override
  String get primerVowelsTitle => 'Стабільні голосні: a, e, i, o, u';

  @override
  String get primerVowelsBody =>
      'Читайте a, e, i, o та u чітко й рівно. Приклади нижче дають практичну приблизну підказку; склад великими літерами має основний наголос.';

  @override
  String get primerVowelGuide =>
      'Підказка: a — приблизно «а», e — «е», i — «і», o — «о», u — «у».';

  @override
  String get primerSilentHTitle => 'h пишеться, але не вимовляється';

  @override
  String get primerSilentHBody =>
      'Літера h в іспанській зазвичай не має окремого звука. Це видно в hola та hasta luego.';

  @override
  String get primerLlYTitle => 'll та y у ранніх словах курсу';

  @override
  String get primerLlYBody =>
      'll — одна письмова одиниця в llamo та llamas. y — окрема літера, як у y tú. Вимова залежить від регіону, але написані моделі залишаються видимими.';

  @override
  String get primerEnyeTitle => 'ñ — окрема іспанська літера';

  @override
  String get primerEnyeBody =>
      'ñ — не те саме, що n. Розпізнавайте її в España й зберігайте тильду як частину іспанського написання.';

  @override
  String get primerRRTitle => 'r та rr';

  @override
  String get primerRRBody =>
      'r та rr позначають різні письмові моделі. Одна r є в Madrid; rr — сильна модель у perro. Підготовка формує лише розпізнавання, а не тренує акцент.';

  @override
  String get primerContextTitle => 'Контекстні моделі: c, g, qu, gu та gü';

  @override
  String get primerContextBody =>
      'c і g змінюють читання залежно від наступної голосної. qu зазвичай зберігає звук k перед e/i; gu та gü дають різні письмові підказки. Зустрічайте ці моделі в цілих словах, а не в довгій таблиці правил.';

  @override
  String get primerAccentsTitle => 'Наголоси й іспанська пунктуація';

  @override
  String get primerAccentsBody =>
      'á, é, í, ó та ú — знайомі голосні зі значущим письмовим наголосом. Зверніть увагу на знак у Cómo та días; повні правила іспанського наголосу не входять до цієї підготовки.';

  @override
  String get primerTryReview => 'Перевірити себе';

  @override
  String get primerNoticeLabel => 'ЗВЕРНІТЬ УВАГУ';

  @override
  String get primerTryLabel => 'СПРОБУЙТЕ';

  @override
  String primerReviewCounter(Object current, Object total) {
    return 'Розпізнавання: $current з $total';
  }

  @override
  String primerCorrectReading(String word, String hint) {
    return 'Правильно. $word приблизно читається як $hint.';
  }

  @override
  String get primerTryAgain =>
      'Поки що ні. Ще раз прочитайте варіанти й спробуйте.';

  @override
  String get primerCheck => 'Перевірити';

  @override
  String get primerLlTitle => 'll — іспанська письмова модель';

  @override
  String get primerLlBody =>
      'У цьому курсі ll у me llamo починається приблизно як українське «й»: ме Я-мо. В інших регіонах можливі варіанти, але це наша початкова модель.';

  @override
  String get primerEnyeRTitle => 'ñ та одинарне r';

  @override
  String get primerEnyeRBody =>
      'У España ñ читається з м\'яким «нь»: ес-ПА-нья. У Madrid є одна r: ма-ДРІД. Це приблизне читання, а не перевірка ідеального r.';

  @override
  String get primerAccentsQuestionsTitle => 'Наголос і питання на письмі';

  @override
  String get primerAccentsQuestionsBody =>
      'Знак наголосу допомагає побачити наголошений склад: Cómo — КО-мо, а Buenos días — БУ-Е-нос ДІ-ас. ¿ відкриває письмове питання, а ? його закриває; це не окремі звуки.';

  @override
  String get primerNarrowCTitle => 'Невелика підказка для c';

  @override
  String get primerNarrowCBody =>
      'c не читається однаково в усіх позиціях: у Cómo вона дає звук, близький до «к» — КО-мо, а в Gracias у нашій моделі близька до «с» — ГРА-сіас. Це лише мала підказка, не повний розділ про c.';

  @override
  String get primerExampleHola => 'привітання';

  @override
  String get primerExampleMe => 'я / мене';

  @override
  String get primerExampleTu => 'ти';

  @override
  String get primerExampleBuenosDias => 'денне привітання';

  @override
  String get primerExampleMeLlamo => 'як назвати своє ім\'я';

  @override
  String get primerExampleHastaLuego => 'прощання';

  @override
  String get primerExampleYTu => 'питання про співрозмовника';

  @override
  String get primerExampleEspana => 'Іспанія';

  @override
  String get primerExampleMadrid => 'Мадрид';

  @override
  String get primerExampleComo => 'як / яким способом';

  @override
  String get primerExampleComoTeLlamas => 'Як тебе звати?';

  @override
  String get primerExampleGracias => 'дякую';

  @override
  String primerReviewHolaReadingPrompt(String hint) {
    return 'Яке іспанське слово приблизно читається як $hint?';
  }

  @override
  String primerReviewEspanaReadingPrompt(String hint) {
    return 'Яке іспанське слово приблизно читається як $hint?';
  }

  @override
  String primerReviewQuestionReadingPrompt(String hint) {
    return 'Яке іспанське питання приблизно читається як $hint?';
  }

  @override
  String get audioListen => 'Прослухати';

  @override
  String get audioUnavailable => 'Аудіо недоступне. Ви можете продовжити.';

  @override
  String get recordingPurpose =>
      'Доступ до мікрофона дає змогу записати свій голос і прослухати його локально.';

  @override
  String get record => 'Записати';

  @override
  String get stopRecording => 'Зупинити запис';

  @override
  String get playMyRecording => 'Прослухати мій запис';

  @override
  String get recordAgain => 'Записати ще раз';

  @override
  String get deleteRecording => 'Видалити запис';

  @override
  String get microphoneDenied =>
      'Доступ до мікрофона відхилено. Ви можете продовжити без запису.';

  @override
  String get tryRecordingAgain => 'Спробувати записати ще раз';

  @override
  String get recordingFailed =>
      'Не вдалося записати. Ви можете продовжити без запису.';

  @override
  String get continueWithoutRecording => 'Продовжити без запису';

  @override
  String get spokenPractice => 'Усна практика';

  @override
  String get listen => 'Послухати';

  @override
  String get sayItAloud => 'Скажіть уголос';

  @override
  String get tryFromMemory => 'Спробувати з пам’яті';

  @override
  String get listenToReference => 'Послухати зразок';

  @override
  String get showReference => 'Показати зразок';

  @override
  String get finishAttempt => 'Завершити спробу';

  @override
  String get continuePractice => 'Продовжити';

  @override
  String get practiceComplete => 'Практику завершено';
}
