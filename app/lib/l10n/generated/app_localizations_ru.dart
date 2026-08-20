// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Tutor Language';

  @override
  String get settingsTooltip => 'Настройки';

  @override
  String get backTooltip => 'Назад';

  @override
  String get backToCourse => 'Назад к курсу';

  @override
  String get openCourse => 'Открыть курс';

  @override
  String get courseTitle => 'Курс';

  @override
  String courseProgress(int completed, int total) {
    return 'Выполнено $completed из $total уроков';
  }

  @override
  String get courseComplete => 'Курс завершён';

  @override
  String get noUnitsAvailable => 'Нет доступных разделов.';

  @override
  String get noLessonsAvailable => 'Нет доступных уроков.';

  @override
  String get lessonStatusCompleted => 'Завершено';

  @override
  String get lessonStatusAvailableNext => 'Доступно следующим';

  @override
  String get lessonStatusLocked => 'Заблокировано';

  @override
  String moduleNumber(String number) {
    return 'Модуль $number';
  }

  @override
  String lessonNumber(String number) {
    return 'Урок $number';
  }

  @override
  String get competencyCheck => 'Проверка коммуникативного навыка';

  @override
  String get competencyAchieved => 'Коммуникативный навык подтверждён';

  @override
  String get competencyAchievedAfterReview =>
      'Коммуникативный навык подтверждён после повторения';

  @override
  String get competencyNeedsPractice =>
      'Коммуникативному навыку нужна практика';

  @override
  String get competencyNotYetAchieved =>
      'Коммуникативный навык ещё не подтверждён';

  @override
  String get competencyCompleteModuleFirst => 'Сначала завершите этот модуль';

  @override
  String get competencyReadyToStart => 'Можно начинать';

  @override
  String get competencyContinueCheck => 'Продолжить проверку';

  @override
  String get competencyGoalDemonstrated => 'Вы показали цель этого модуля';

  @override
  String get competencySucceededAfterReview =>
      'Вы справились после целевого повторения';

  @override
  String get competencyRetryWhenReady =>
      'Повторите проверку, когда будете готовы';

  @override
  String get start => 'Начать';

  @override
  String get continueAction => 'Продолжить';

  @override
  String get retry => 'Повторить';

  @override
  String get lessonTitle => 'Урок';

  @override
  String get previousLesson => 'Предыдущий урок';

  @override
  String get nextLesson => 'Следующий урок';

  @override
  String lessonLaunchError(String error) {
    return 'Не удалось открыть урок.\n$error';
  }

  @override
  String get lessonPlayerTitle => 'Урок';

  @override
  String get leaveLessonTitle => 'Выйти из урока?';

  @override
  String get leaveLessonBody =>
      'Незавершённый урок начнётся заново, когда вы откроете его снова.';

  @override
  String get stay => 'Остаться';

  @override
  String get leaveLesson => 'Выйти из урока';

  @override
  String get noActivitiesAvailable => 'Нет доступных заданий.';

  @override
  String get previous => '← Назад';

  @override
  String get next => 'Далее →';

  @override
  String stepCounter(int current, int total) {
    return 'Шаг $current / $total';
  }

  @override
  String get finishLesson => 'Завершить урок';

  @override
  String get finishing => 'Завершение...';

  @override
  String get completionSaveError =>
      'Не удалось сохранить завершение урока. Попробуйте ещё раз.';

  @override
  String get lessonCompleted => 'Урок завершён';

  @override
  String get continueToNextLesson => 'Перейти к следующему уроку';

  @override
  String get repeatLesson => 'Повторить урок';

  @override
  String get repeatFromStep => 'Повторить с шага';

  @override
  String get repeatCheckpoint => 'Повторить контрольную проверку';

  @override
  String get reviewCompletedLessons => 'Просмотреть завершённые уроки';

  @override
  String get someTopicsNeedReinforcement =>
      'Некоторые темы потребуют закрепления.';

  @override
  String get lessonMasteredOutcome => 'Показано уверенное усвоение.';

  @override
  String get lessonReinforcementOutcome => 'Завершено с закреплением.';

  @override
  String get lessonIncompleteOutcome => 'Результат урока неполный.';

  @override
  String get lessonMastered => 'Урок усвоен';

  @override
  String get courseCompletionRecommended =>
      'Курс завершён. Продолжайте повторять завершённые уроки.';

  @override
  String get quickReview => 'Краткое повторение';

  @override
  String get mastered => 'Усвоено';

  @override
  String get fragileMastery =>
      'Хорошая работа. Здесь нужно ещё немного практики.';

  @override
  String unsupportedContent(String type) {
    return 'Неподдерживаемое содержимое: $type';
  }

  @override
  String get buildsOnEarlierMaterial => 'Опирается на предыдущий материал.';

  @override
  String get stepTypeVocabulary => 'лексика';

  @override
  String get stepTypeGrammar => 'грамматика';

  @override
  String get stepTypeDialogue => 'диалог';

  @override
  String get stepTypeReading => 'чтение';

  @override
  String get stepTypeExercise => 'упражнение';

  @override
  String get stepTypeMixed => 'смешанное';

  @override
  String get answerLabel => 'Ответ';

  @override
  String get sentenceBuilderAnswer => 'Твой ответ';

  @override
  String get sentenceBuilderAvailableWords => 'Доступные слова';

  @override
  String get sentenceBuilderClear => 'Очистить';

  @override
  String get learnerSpeakerLabel => 'Ты';

  @override
  String get checkAnswer => 'Проверить';

  @override
  String dialogueProgress(int current, int total) {
    return 'Диалог $current / $total';
  }

  @override
  String selectedAnswer(String answer) {
    return 'Выбранный ответ: $answer';
  }

  @override
  String get correct => 'Правильно';

  @override
  String get acceptedWithCorrection => 'Принято с исправлением';

  @override
  String get tryAgain => 'Попробовать ещё раз';

  @override
  String get notCorrectYet => 'Пока не правильно';

  @override
  String get incorrect => 'Неправильно';

  @override
  String feedbackMultilineMissing(int submitted, int expected) {
    return 'Введено $submitted из $expected реплик. Дополните диалог.';
  }

  @override
  String feedbackMultilineExtra(int submitted, int expected) {
    return 'Введено $submitted реплик вместо $expected. Проверьте диалог.';
  }

  @override
  String feedbackMultilineIncorrectLines(
    int correct,
    int expected,
    String lines,
  ) {
    return '$correct из $expected реплик правильные. Проверьте реплики: $lines.';
  }

  @override
  String feedbackMultilineIncomplete(int submitted) {
    return 'Введено $submitted реплик. Дополните диалог.';
  }

  @override
  String feedbackMultilineTooMany(int submitted) {
    return 'Введено $submitted реплик. Проверьте диалог.';
  }

  @override
  String get unsupportedActivityType => 'Неподдерживаемый тип задания';

  @override
  String unsupportedActivityTypeValue(String type) {
    return 'Неподдерживаемый тип задания: $type';
  }

  @override
  String get matchingNotCheckableYet =>
      'Это задание на сопоставление пока нельзя проверить.';

  @override
  String recommendedAnswer(String answer) {
    return 'Рекомендуемый ответ: $answer';
  }

  @override
  String feedbackBullet(String message) {
    return '- $message';
  }

  @override
  String exercisePromptSemantics(String prompt) {
    return 'Условие упражнения: $prompt';
  }

  @override
  String get settingsTitle => 'О приложении и настройки';

  @override
  String get releaseStatusLabel => 'Ранний публичный выпуск';

  @override
  String get releaseScopeLabel => 'Офлайн-курс испанского A0';

  @override
  String versionLabel(String version) {
    return 'Версия $version';
  }

  @override
  String get privacyTitle => 'Приватность';

  @override
  String get privacyOffline => 'Работает офлайн.';

  @override
  String get privacyNoAccount => 'Учётная запись не требуется.';

  @override
  String get privacyNoTracking =>
      'Реклама, отслеживание и аналитика не используются.';

  @override
  String get privacyNoAi =>
      'Во время уроков приложение не обращается к AI-сервисам.';

  @override
  String get privacyLocalProgress =>
      'Прогресс обучения хранится на этом устройстве.';

  @override
  String get feedbackTitle => 'Обратная связь';

  @override
  String get feedbackBody =>
      'Для этого раннего выпуска сообщайте о проблемах через репозиторий проекта или напрямую сопровождающему проекта.';

  @override
  String get licensesTitle => 'Лицензии и благодарности';

  @override
  String get licensesBody =>
      'Tutor Language создан на Flutter и содержит авторский учебный контент испанского A0. Полная информация о лицензиях и сторонних компонентах будет включена в публичный релизный пакет.';

  @override
  String get competencyScreenTitle => 'Проверка навыка';

  @override
  String get competencyUnavailable => 'Проверка навыка недоступна.';

  @override
  String competencyUnavailableWithError(String error) {
    return 'Проверка навыка недоступна. $error';
  }

  @override
  String get competencyTaskUnavailable => 'Это задание проверки недоступно.';

  @override
  String get competencyDiagnosticIntro =>
      'Покажите, что можете сделать без подсказок.';

  @override
  String get competencyRetryIntro => 'Попробуйте исходное задание ещё раз.';

  @override
  String get competencyRecoveryIntro =>
      'Коротко повторим одну часть и попробуем снова.';

  @override
  String get startReview => 'Начать повторение';

  @override
  String get recoveryActivityUnavailable =>
      'Задание для повторения недоступно.';

  @override
  String get competencyCheckComplete => 'Проверка навыка завершена.';

  @override
  String get retryCompetencyCheck => 'Повторить проверку навыка';

  @override
  String get competencyAchievedTitle => 'Навык подтверждён';

  @override
  String get competencyAchievedAfterReviewTitle =>
      'Навык подтверждён после повторения';

  @override
  String get competencyNeedsPracticeTitle => 'Навыку нужна практика';

  @override
  String get competencyNotYetAchievedTitle => 'Навык ещё не подтверждён';

  @override
  String get competencyAchievedDescription =>
      'Вы самостоятельно выполнили коммуникативное задание.';

  @override
  String get competencyAchievedAfterReviewDescription =>
      'Вы использовали повторение, а затем выполнили коммуникативное задание.';

  @override
  String get competencyNeedsPracticeDescription =>
      'Вы показали часть цели. Повторите, когда будете готовы.';

  @override
  String get competencyNotYetAchievedDescription =>
      'Ключевая цель ещё не закреплена. Повторите после просмотра материала.';

  @override
  String get notViewed => 'Не просмотрено';

  @override
  String get viewed => 'Просмотрено';

  @override
  String activitiesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count задания',
      many: '$count заданий',
      few: '$count задания',
      one: '1 задание',
      zero: 'Нет заданий',
    );
    return '$_temp0';
  }

  @override
  String get noAnswerChoices => 'В этом шаблоне нет вариантов ответа.';

  @override
  String get unchecked => 'Не проверено';

  @override
  String templateType(String type) {
    return 'Тип: $type';
  }

  @override
  String templatePrompt(String prompt) {
    return 'Условие: $prompt';
  }

  @override
  String requiredObjectTypesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count обязательного типа объекта',
      many: '$count обязательных типов объектов',
      few: '$count обязательных типа объекта',
      one: '1 обязательный тип объекта',
      zero: 'Нет обязательных типов объектов',
    );
    return '$_temp0';
  }

  @override
  String supportedGoalsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count поддерживаемой цели',
      many: '$count поддерживаемых целей',
      few: '$count поддерживаемые цели',
      one: '1 поддерживаемая цель',
      zero: 'Нет поддерживаемых целей',
    );
    return '$_temp0';
  }

  @override
  String get feedbackPreferredOrderNoCanonical =>
      'Здесь принимается другой порядок.';

  @override
  String feedbackPreferredOrder(String answer) {
    return 'Более естественный порядок: $answer';
  }

  @override
  String feedbackSpanishInterrogativeQueRequiresAccent(String canonical) {
    return 'В этом вопросе «$canonical» пишется с ударением.';
  }

  @override
  String feedbackSpanishInterrogativeComoRequiresAccent(String canonical) {
    return 'В этом вопросе «$canonical» пишется с ударением.';
  }

  @override
  String feedbackSpanishMissingDiacritic(String canonical) {
    return 'Нормативное испанское написание: «$canonical».';
  }

  @override
  String get feedbackSpanishQuestionMissingOpeningMark =>
      'Испанские вопросы начинаются с «¿».';

  @override
  String get feedbackSpanishQuestionMissingClosingMark =>
      'Испанские вопросы заканчиваются знаком «?».';

  @override
  String get feedbackSpanishExclamationMissingOpeningMark =>
      'Испанские восклицания начинаются с «¡».';

  @override
  String get feedbackSpanishExclamationMissingClosingMark =>
      'Испанские восклицания заканчиваются знаком «!».';

  @override
  String feedbackUseCanonicalForm(String canonical) {
    return 'Используйте нормативную форму: «$canonical».';
  }

  @override
  String get feedbackQuestionExpectedStatementProvided =>
      'В этом упражнении нужен вопрос.\nВы написали ответ.\nПопробуйте написать испанский вопрос.';

  @override
  String get feedbackStatementExpectedQuestionProvided =>
      'В этом упражнении нужно утверждение.\nВы написали вопрос.\nПопробуйте написать испанское утверждение.';

  @override
  String get feedbackAnswerExpectedQuestion =>
      'В этом упражнении нужен ответ.\nВы написали другой вопрос.';

  @override
  String get feedbackQuestionExpectedAnswer => 'Напишите вопрос, а не ответ.';

  @override
  String get feedbackTranslationExpectedSourceLanguage =>
      'Переведите подсказку, а не копируйте её.';

  @override
  String get feedbackGreetingExpectedFarewell =>
      'В этом упражнении нужно приветствие.\nВы написали прощание.';

  @override
  String get feedbackFarewellExpectedGreeting =>
      'В этом упражнении нужно прощание.\nВы написали приветствие.';

  @override
  String get feedbackNamePatternUseMeLlamo =>
      'В этом шаблоне представления используйте «me llamo».';

  @override
  String get feedbackOriginUseSer =>
      'Чтобы сказать о происхождении, в испанском используется «soy de».';

  @override
  String get feedbackOriginKeepDe =>
      'Сохраняйте «de» в шаблоне происхождения: «soy de».';

  @override
  String get feedbackOriginUseSoyDe => '«Soy de» говорит, откуда человек.';

  @override
  String get feedbackOriginQuestionIncludeDe =>
      'Чтобы спросить, откуда человек, используйте «¿De dónde eres?».';

  @override
  String get feedbackResidenceUseVivoEn =>
      '«Vivo en» говорит, где человек живёт.';

  @override
  String get feedbackResidenceQuestionNoDe =>
      'Чтобы спросить, где человек живёт, используйте «¿Dónde vives?».';

  @override
  String get feedbackLanguagesUseHablo =>
      'Используйте «hablo», чтобы сказать, на каком языке вы говорите.';

  @override
  String get feedbackLanguagesUseLanguageNames =>
      'Используйте названия языков, например «ucraniano» или «ruso».';

  @override
  String get feedbackLanguagesKeepDeAfterUnPoco =>
      'Сохраняйте «de» в «un poco de» перед названием языка.';

  @override
  String get feedbackLanguagesAskIdiomas =>
      'Используйте «idiomas», когда спрашиваете, на каких языках кто-то говорит.';

  @override
  String get feedbackIdentityAskSpecificQuestions =>
      'Используйте вопрос, который соответствует нужной информации.';

  @override
  String get feedbackOriginResidenceDoNotSwap =>
      'Не путайте происхождение и место проживания: «soy de» — происхождение, «vivo en» — проживание.';

  @override
  String get feedbackPeopleUseEsForOther =>
      'Используйте «es», когда говорите о другом человеке.';

  @override
  String get feedbackPeopleUseSeLlama =>
      'Используйте «se llama», чтобы назвать имя другого человека.';

  @override
  String get feedbackPeopleUseFeminineRole =>
      'Для этого человека используйте форму роли женского рода.';

  @override
  String get feedbackPeopleUseMasculineRole =>
      'Для этого человека используйте форму роли мужского рода.';

  @override
  String get feedbackPeopleQuestionQuienNotComo =>
      '«¿Quién es?» спрашивает, кто этот человек.';

  @override
  String get feedbackPeopleQuestionComoNotQuien =>
      '«¿Cómo es?» спрашивает, какой этот человек.';

  @override
  String get feedbackPeopleUseFeminineDescription =>
      'Для этого человека используйте описание в женском роде.';

  @override
  String get feedbackPeopleUseMasculineDescription =>
      'Для этого человека используйте описание в мужском роде.';

  @override
  String get feedbackPeopleUseViveForOther =>
      'Используйте «vive», когда говорите, где живёт другой человек.';

  @override
  String get feedbackPeopleUseHablaForOther =>
      'Используйте «habla», когда говорите, на каком языке говорит другой человек.';

  @override
  String get feedbackPeopleOriginResidenceContrast =>
      '«Es de» говорит о происхождении; «vive en» — о месте проживания.';

  @override
  String get feedbackPeopleLanguageNotNationality =>
      'Используйте «habla», чтобы сказать, на каком языке говорит другой человек.';

  @override
  String get feedbackPeopleThirdPersonSequence =>
      'Весь ответ о другом человеке должен быть в третьем лице.';

  @override
  String get feedbackPeopleQuestionOrderMatters =>
      'Используйте вопросы в порядке, указанном в условии.';

  @override
  String get feedbackPeopleQuestionAndPersonForm =>
      'Используйте нужный вопрос и форму глагола для третьего лица.';

  @override
  String get feedbackShoppingUseQueForObject =>
      'Используйте «¿Qué es esto?», чтобы спросить, что это за предмет.';

  @override
  String get feedbackShoppingUseCuantoForPrice =>
      'Используйте «¿Cuánto cuesta?», чтобы спросить цену.';

  @override
  String get feedbackShoppingUseCuestaForPrice =>
      'Используйте «cuesta», когда называете цену одного предмета.';

  @override
  String get feedbackShoppingUsePoliteTiene =>
      'В этом модуле используйте вежливый вопрос в магазине «¿Tiene...?».';

  @override
  String get feedbackShoppingUseTenemosForShop =>
      'Используйте «tenemos», когда магазин говорит, что у него есть.';

  @override
  String get feedbackShoppingUseQuieroForPurchase =>
      'Используйте «quiero», чтобы сказать, что хотите купить.';

  @override
  String get feedbackShoppingUseUnaFeminine =>
      'Используйте «una» с отработанным существительным женского рода, например «botella» или «bolsa».';

  @override
  String get feedbackShoppingUseEsteMasculine =>
      'Используйте «este» перед отработанным существительным мужского рода, например «libro».';

  @override
  String get feedbackShoppingUseEstaFeminine =>
      'Используйте «esta» перед отработанным существительным женского рода, например «bolsa».';

  @override
  String get feedbackShoppingUseMasculinePriceAdjective =>
      'С этим существительным мужского рода используйте прилагательное в мужском роде.';

  @override
  String get feedbackShoppingUseFemininePriceAdjective =>
      'С этим существительным женского рода используйте прилагательное в женском роде.';

  @override
  String get feedbackTransportUseAPie =>
      'Используйте «a pie», когда идёте пешком.';

  @override
  String get feedbackDirectionsUseDondeForLocation =>
      'Используйте «¿Dónde está...?», чтобы спросить, где находится место.';

  @override
  String get feedbackDirectionsUseEstaForLocation =>
      'Используйте «está», чтобы сказать, где находится место.';

  @override
  String get feedbackDirectionsLeftNotRight => '«Izquierda» означает налево.';

  @override
  String get feedbackDirectionsRightNotLeft => '«Derecha» означает направо.';

  @override
  String get feedbackDirectionsFarNotNear => '«Lejos» означает далеко.';

  @override
  String get feedbackDirectionsUseComoForRoute =>
      'Используйте «¿Cómo llego...?», чтобы спросить, как добраться.';

  @override
  String get feedbackDirectionsRouteOrderMatters =>
      'В этом упражнении важен порядок маршрута. Следуйте заданной последовательности.';

  @override
  String get feedbackTransportUseTomaForAdvice =>
      'Используйте «toma», когда советуете, каким транспортом воспользоваться.';

  @override
  String get feedbackDirectionsDirectionNotLocation =>
      'В этом упражнении нужны указания маршрута, а не только расположение места.';

  @override
  String get feedbackHelpPoliteOpeningFirst =>
      'Начните с вежливого обращения, затем попросите услугу.';

  @override
  String get feedbackHelpIncludePoliteAttention =>
      'Добавьте вежливое обращение перед срочной просьбой.';

  @override
  String get feedbackAnswersUsuallyDoNotBeginQuestionMark =>
      'Ответы и утверждения обычно не начинаются с «¿».';

  @override
  String get feedbackQuestionsBeginWith => 'Вопросы начинаются с: ¿...';

  @override
  String feedbackStartsWith(String prefix) {
    return 'Начинается с: $prefix';
  }

  @override
  String get primerTitle => 'Испанский алфавит';

  @override
  String get primerSubtitle =>
      'Необязательная карта чтения на 5–10 минут перед уроком 1.';

  @override
  String get primerInProgress =>
      'Продолжить необязательную подготовку к чтению.';

  @override
  String get primerCompleted => 'Завершено. Можно повторить в любое время.';

  @override
  String get primerSkipped => 'Пропущено. Можно открыть снова в любое время.';

  @override
  String get primerUnavailable => 'Необязательная помощь с чтением';

  @override
  String get primerStart => 'Начать подготовку';

  @override
  String get primerReview => 'Повторить подготовку';

  @override
  String get primerOptional =>
      'Необязательная подготовка — урок 1 остаётся доступным.';

  @override
  String get primerIntro =>
      'Ниже показано, как примерно звучат испанские буквы. Читать слова вы постепенно научитесь на уроках.';

  @override
  String get primerContinue => 'Перейти к уроку 1';

  @override
  String get primerAlphabetTitle => 'Испанский алфавит';

  @override
  String get primerAlphabetRows =>
      'A (а) — а\nB (бе) — б\nC (се) — к или с\nD (де) — д\nE (э) — э\nF (эфэ) — ф\nG (хэ) — г или х\nH (аче) — не произносится\nI (и) — и\nJ (хота) — примерно х\nK (ка) — к\nL (эле) — л\nM (эмэ) — м\nN (энэ) — н\nÑ (энье) — примерно нь\nO (о) — о\nP (пэ) — п\nQ (ку) — к\nR (эррэ) — р\nS (эсэ) — с\nT (тэ) — т\nU (у) — у\nV (увэ) — примерно б\nW (увэ доблэ) — звучание зависит от слова\nX (экис) — обычно кс\nY (и гриега) — примерно й или и\nZ (сэта) — примерно с';

  @override
  String get primerDigraphTitle => 'Распространённые сочетания букв';

  @override
  String get primerDigraphRows =>
      'CH (че) — примерно ч\nLL (элье) — примерно й';

  @override
  String get primerSkip => 'Пропустить сейчас';

  @override
  String primerSectionCounter(int current, int total) {
    return 'Карта чтения: $current из $total';
  }

  @override
  String get primerExamples => 'Настоящие испанские примеры';

  @override
  String get primerLettersTitle => 'Буквы и распространённые сочетания';

  @override
  String get primerExamplesTitle => 'Настоящие примеры из курса';

  @override
  String get primerReviewTitle => 'Короткая проверка чтения';

  @override
  String get primerLetterColumn => 'Испанская форма';

  @override
  String get primerReadingColumn => 'Как примерно читается';

  @override
  String get primerSpanishColumn => 'По-испански';

  @override
  String get primerMeaningColumn => 'Значение';

  @override
  String get primerStressHint =>
      'Слог большими буквами произносится с ударением.';

  @override
  String get primerLetterH => 'h (аче)';

  @override
  String get primerReadingA => 'а';

  @override
  String get primerReadingE => 'э';

  @override
  String get primerReadingI => 'и';

  @override
  String get primerReadingO => 'о';

  @override
  String get primerReadingU => 'у';

  @override
  String get primerReadingH => 'не произносится';

  @override
  String get primerReadingJ => 'примерно как сильное «х»';

  @override
  String get primerReadingEnye => 'примерно как «нь»';

  @override
  String get primerReadingLl => 'примерно как «й»; в llamo — «я»';

  @override
  String get primerReadingR => 'короткое «р»';

  @override
  String get primerReadingRr => 'более сильное, раскатистое «р»';

  @override
  String get primerApproxReadingLabel => 'Примерно читается';

  @override
  String get primerReadingHola => 'О-ла';

  @override
  String get primerReadingMe => 'ме';

  @override
  String get primerReadingTu => 'ту';

  @override
  String get primerReadingBuenosDias => 'БУ-э-нос ДИ-ас';

  @override
  String get primerReadingHastaLuego => 'АС-та ЛУ-э-го';

  @override
  String get primerReadingMeLlamo => 'ме Я-мо';

  @override
  String get primerReadingYTu => 'и ту';

  @override
  String get primerReadingEspana => 'эс-ПА-нья';

  @override
  String get primerReadingMadrid => 'ма-ДРИД';

  @override
  String get primerReadingComo => 'КО-мо';

  @override
  String get primerReadingComoTeLlamas => 'КО-мо тэ Я-мас';

  @override
  String get primerReadingGracias => 'ГРА-сиас';

  @override
  String get primerReadingPrompt => 'Привычка чтения';

  @override
  String get primerRecognitionPrompt =>
      'Прочитайте испанскую форму целиком и свяжите её с подсказкой ниже; эти слова встретятся в следующих уроках.';

  @override
  String get primerFinish => 'Завершить подготовку';

  @override
  String get primerReopenHint =>
      'Подготовка необязательна; её можно снова открыть с экрана курса.';

  @override
  String get primerVowelsTitle => 'Стабильные гласные: a, e, i, o, u';

  @override
  String get primerVowelsBody =>
      'Читайте a, e, i, o и u чётко и ровно. Подсказки ниже показывают практичное приближение; слог большими буквами несёт основное ударение.';

  @override
  String get primerVowelGuide =>
      'Подсказка: a — примерно «а», e — «э», i — «и», o — «о», u — «у».';

  @override
  String get primerSilentHTitle => 'h пишется, но не произносится';

  @override
  String get primerSilentHBody =>
      'В испанском h обычно не имеет отдельного звука. Это видно в hola и hasta luego.';

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
  String get primerTryReview => 'Быстрая проверка';

  @override
  String get primerNoticeLabel => 'ОБРАТИТЕ ВНИМАНИЕ';

  @override
  String get primerTryLabel => 'ПОПРОБУЙТЕ';

  @override
  String primerReviewCounter(Object current, Object total) {
    return 'Распознавание: $current из $total';
  }

  @override
  String primerCorrectReading(String word, String hint) {
    return 'Правильно. $word примерно читается как $hint.';
  }

  @override
  String get primerTryAgain =>
      'Пока нет. Снова прочитайте варианты и попробуйте ещё раз.';

  @override
  String get primerCheck => 'Проверить';

  @override
  String get primerLlTitle => 'll — испанская модель написания';

  @override
  String get primerLlBody =>
      'В этом курсе ll в me llamo начинается примерно как «й»: ме Я-мо. В разных регионах возможны варианты, но это наша начальная модель.';

  @override
  String get primerEnyeRTitle => 'ñ и одна буква r';

  @override
  String get primerEnyeRBody =>
      'В España буква ñ читается с мягким «нь»: эс-ПА-нья. В Madrid одна r: ма-ДРИД. Это приблизительное чтение, а не проверка идеального r.';

  @override
  String get primerAccentsQuestionsTitle => 'Ударение и письменный вопрос';

  @override
  String get primerAccentsQuestionsBody =>
      'Знак ударения помогает увидеть ударный слог: Cómo — КО-мо, а Buenos días — БУ-э-нос ДИ-ас. ¿ открывает письменный вопрос, а ? закрывает его; это не отдельные звуки.';

  @override
  String get primerNarrowCTitle => 'Небольшая подсказка для c';

  @override
  String get primerNarrowCBody =>
      'c читается не одинаково везде: в Cómo она близка к «к» — КО-мо, а в Gracias в нашей модели близка к «с» — ГРА-сиас. Это небольшая подсказка, не полный раздел о c.';

  @override
  String get primerExampleHola => 'приветствие';

  @override
  String get primerExampleMe => 'я / меня';

  @override
  String get primerExampleTu => 'ты';

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
    return 'Какое испанское слово примерно читается как $hint?';
  }

  @override
  String primerReviewEspanaReadingPrompt(String hint) {
    return 'Какое испанское слово примерно читается как $hint?';
  }

  @override
  String primerReviewQuestionReadingPrompt(String hint) {
    return 'Какой испанский вопрос примерно читается как $hint?';
  }

  @override
  String get audioListen => 'Прослушать';

  @override
  String get audioUnavailable => 'Аудио недоступно. Попробуйте еще раз.';

  @override
  String get recordingPurpose =>
      'Доступ к микрофону позволяет записать свой голос и прослушать его локально.';

  @override
  String get record => 'Записать';

  @override
  String get stopRecording => 'Остановить запись';

  @override
  String get playMyRecording => 'Прослушать мою запись';

  @override
  String get recordAgain => 'Записать ещё раз';

  @override
  String get deleteRecording => 'Удалить запись';

  @override
  String get microphoneDenied =>
      'Доступ к микрофону отклонён. Вы можете продолжить без записи.';

  @override
  String get tryRecordingAgain => 'Попробовать записать ещё раз';

  @override
  String get recordingFailed =>
      'Не удалось записать. Вы можете продолжить без записи.';

  @override
  String get continueWithoutRecording => 'Продолжить без записи';

  @override
  String get spokenPractice => 'Устная практика';

  @override
  String get listen => 'Послушать';

  @override
  String get sayItAloud => 'Скажите вслух';

  @override
  String get tryFromMemory => 'Попробовать по памяти';

  @override
  String get listenToReference => 'Послушать образец';

  @override
  String get showReference => 'Показать образец';

  @override
  String get finishAttempt => 'Завершить попытку';

  @override
  String get continuePractice => 'Продолжить';

  @override
  String get practiceComplete => 'Практика завершена';
}
