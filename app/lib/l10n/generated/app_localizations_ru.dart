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
  String get checkAnswer => 'Проверить';

  @override
  String selectedAnswer(String answer) {
    return 'Выбранный ответ: $answer';
  }

  @override
  String get correct => 'Правильно';

  @override
  String get acceptedWithCorrection => 'Принято с исправлением';

  @override
  String get tryAgain => 'Попробуйте ещё раз';

  @override
  String get notCorrectYet => 'Пока не правильно';

  @override
  String get incorrect => 'Неправильно';

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
}
