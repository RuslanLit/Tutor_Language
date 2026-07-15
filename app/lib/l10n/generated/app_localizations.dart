import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('pl'),
    Locale('ru'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tutor Language'**
  String get appTitle;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @backTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backTooltip;

  /// No description provided for @backToCourse.
  ///
  /// In en, this message translates to:
  /// **'Back to course'**
  String get backToCourse;

  /// No description provided for @openCourse.
  ///
  /// In en, this message translates to:
  /// **'Open course'**
  String get openCourse;

  /// No description provided for @courseTitle.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get courseTitle;

  /// No description provided for @courseProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} lessons completed'**
  String courseProgress(int completed, int total);

  /// No description provided for @courseComplete.
  ///
  /// In en, this message translates to:
  /// **'Course complete'**
  String get courseComplete;

  /// No description provided for @noUnitsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No units available.'**
  String get noUnitsAvailable;

  /// No description provided for @noLessonsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No lessons available.'**
  String get noLessonsAvailable;

  /// No description provided for @lessonStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get lessonStatusCompleted;

  /// No description provided for @lessonStatusAvailableNext.
  ///
  /// In en, this message translates to:
  /// **'Available next'**
  String get lessonStatusAvailableNext;

  /// No description provided for @lessonStatusLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get lessonStatusLocked;

  /// No description provided for @moduleNumber.
  ///
  /// In en, this message translates to:
  /// **'Module {number}'**
  String moduleNumber(String number);

  /// No description provided for @lessonNumber.
  ///
  /// In en, this message translates to:
  /// **'Lesson {number}'**
  String lessonNumber(String number);

  /// No description provided for @competencyCheck.
  ///
  /// In en, this message translates to:
  /// **'Communicative competency check'**
  String get competencyCheck;

  /// No description provided for @competencyAchieved.
  ///
  /// In en, this message translates to:
  /// **'Communicative competency achieved'**
  String get competencyAchieved;

  /// No description provided for @competencyAchievedAfterReview.
  ///
  /// In en, this message translates to:
  /// **'Communicative competency achieved after review'**
  String get competencyAchievedAfterReview;

  /// No description provided for @competencyNeedsPractice.
  ///
  /// In en, this message translates to:
  /// **'Communicative competency needs more practice'**
  String get competencyNeedsPractice;

  /// No description provided for @competencyNotYetAchieved.
  ///
  /// In en, this message translates to:
  /// **'Communicative competency not yet achieved'**
  String get competencyNotYetAchieved;

  /// No description provided for @competencyCompleteModuleFirst.
  ///
  /// In en, this message translates to:
  /// **'Complete this module first'**
  String get competencyCompleteModuleFirst;

  /// No description provided for @competencyReadyToStart.
  ///
  /// In en, this message translates to:
  /// **'Ready to start'**
  String get competencyReadyToStart;

  /// No description provided for @competencyContinueCheck.
  ///
  /// In en, this message translates to:
  /// **'Continue your check'**
  String get competencyContinueCheck;

  /// No description provided for @competencyGoalDemonstrated.
  ///
  /// In en, this message translates to:
  /// **'You demonstrated this module goal'**
  String get competencyGoalDemonstrated;

  /// No description provided for @competencySucceededAfterReview.
  ///
  /// In en, this message translates to:
  /// **'You succeeded after targeted review'**
  String get competencySucceededAfterReview;

  /// No description provided for @competencyRetryWhenReady.
  ///
  /// In en, this message translates to:
  /// **'Retry the check when ready'**
  String get competencyRetryWhenReady;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @lessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get lessonTitle;

  /// No description provided for @previousLesson.
  ///
  /// In en, this message translates to:
  /// **'Previous lesson'**
  String get previousLesson;

  /// No description provided for @nextLesson.
  ///
  /// In en, this message translates to:
  /// **'Next lesson'**
  String get nextLesson;

  /// No description provided for @lessonLaunchError.
  ///
  /// In en, this message translates to:
  /// **'Unable to launch lesson.\n{error}'**
  String lessonLaunchError(String error);

  /// No description provided for @lessonPlayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Lesson Player'**
  String get lessonPlayerTitle;

  /// No description provided for @leaveLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave lesson?'**
  String get leaveLessonTitle;

  /// No description provided for @leaveLessonBody.
  ///
  /// In en, this message translates to:
  /// **'This unfinished lesson will restart when you open it again.'**
  String get leaveLessonBody;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @leaveLesson.
  ///
  /// In en, this message translates to:
  /// **'Leave lesson'**
  String get leaveLesson;

  /// No description provided for @noActivitiesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No activities available.'**
  String get noActivitiesAvailable;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'← Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next →'**
  String get next;

  /// No description provided for @stepCounter.
  ///
  /// In en, this message translates to:
  /// **'Step {current} / {total}'**
  String stepCounter(int current, int total);

  /// No description provided for @finishLesson.
  ///
  /// In en, this message translates to:
  /// **'Finish Lesson'**
  String get finishLesson;

  /// No description provided for @finishing.
  ///
  /// In en, this message translates to:
  /// **'Finishing...'**
  String get finishing;

  /// No description provided for @completionSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save lesson completion. Please try again.'**
  String get completionSaveError;

  /// No description provided for @lessonCompleted.
  ///
  /// In en, this message translates to:
  /// **'Lesson completed'**
  String get lessonCompleted;

  /// No description provided for @continueToNextLesson.
  ///
  /// In en, this message translates to:
  /// **'Continue to next lesson'**
  String get continueToNextLesson;

  /// No description provided for @repeatLesson.
  ///
  /// In en, this message translates to:
  /// **'Repeat lesson'**
  String get repeatLesson;

  /// No description provided for @repeatCheckpoint.
  ///
  /// In en, this message translates to:
  /// **'Repeat checkpoint'**
  String get repeatCheckpoint;

  /// No description provided for @reviewCompletedLessons.
  ///
  /// In en, this message translates to:
  /// **'Review completed lessons'**
  String get reviewCompletedLessons;

  /// No description provided for @someTopicsNeedReinforcement.
  ///
  /// In en, this message translates to:
  /// **'Some topics will need reinforcement.'**
  String get someTopicsNeedReinforcement;

  /// No description provided for @lessonMasteredOutcome.
  ///
  /// In en, this message translates to:
  /// **'Strong mastery demonstrated.'**
  String get lessonMasteredOutcome;

  /// No description provided for @lessonReinforcementOutcome.
  ///
  /// In en, this message translates to:
  /// **'Completed with reinforcement.'**
  String get lessonReinforcementOutcome;

  /// No description provided for @lessonIncompleteOutcome.
  ///
  /// In en, this message translates to:
  /// **'Lesson outcome incomplete.'**
  String get lessonIncompleteOutcome;

  /// No description provided for @lessonMastered.
  ///
  /// In en, this message translates to:
  /// **'Lesson mastered'**
  String get lessonMastered;

  /// No description provided for @courseCompletionRecommended.
  ///
  /// In en, this message translates to:
  /// **'Course complete. Keep reviewing completed lessons.'**
  String get courseCompletionRecommended;

  /// No description provided for @quickReview.
  ///
  /// In en, this message translates to:
  /// **'Quick Review'**
  String get quickReview;

  /// No description provided for @mastered.
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get mastered;

  /// No description provided for @fragileMastery.
  ///
  /// In en, this message translates to:
  /// **'Good work. This needs a little more practice.'**
  String get fragileMastery;

  /// No description provided for @unsupportedContent.
  ///
  /// In en, this message translates to:
  /// **'Unsupported content: {type}'**
  String unsupportedContent(String type);

  /// No description provided for @buildsOnEarlierMaterial.
  ///
  /// In en, this message translates to:
  /// **'Builds on earlier material.'**
  String get buildsOnEarlierMaterial;

  /// No description provided for @stepTypeVocabulary.
  ///
  /// In en, this message translates to:
  /// **'vocabulary'**
  String get stepTypeVocabulary;

  /// No description provided for @stepTypeGrammar.
  ///
  /// In en, this message translates to:
  /// **'grammar'**
  String get stepTypeGrammar;

  /// No description provided for @stepTypeDialogue.
  ///
  /// In en, this message translates to:
  /// **'dialogue'**
  String get stepTypeDialogue;

  /// No description provided for @stepTypeReading.
  ///
  /// In en, this message translates to:
  /// **'reading'**
  String get stepTypeReading;

  /// No description provided for @stepTypeExercise.
  ///
  /// In en, this message translates to:
  /// **'exercise'**
  String get stepTypeExercise;

  /// No description provided for @stepTypeMixed.
  ///
  /// In en, this message translates to:
  /// **'mixed'**
  String get stepTypeMixed;

  /// No description provided for @answerLabel.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answerLabel;

  /// No description provided for @checkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get checkAnswer;

  /// No description provided for @selectedAnswer.
  ///
  /// In en, this message translates to:
  /// **'Selected answer: {answer}'**
  String selectedAnswer(String answer);

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @acceptedWithCorrection.
  ///
  /// In en, this message translates to:
  /// **'Accepted with correction'**
  String get acceptedWithCorrection;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @notCorrectYet.
  ///
  /// In en, this message translates to:
  /// **'Not correct yet'**
  String get notCorrectYet;

  /// No description provided for @incorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get incorrect;

  /// No description provided for @unsupportedActivityType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported activity type'**
  String get unsupportedActivityType;

  /// No description provided for @unsupportedActivityTypeValue.
  ///
  /// In en, this message translates to:
  /// **'Unsupported activity type: {type}'**
  String unsupportedActivityTypeValue(String type);

  /// No description provided for @matchingNotCheckableYet.
  ///
  /// In en, this message translates to:
  /// **'This matching activity is not checkable yet.'**
  String get matchingNotCheckableYet;

  /// No description provided for @recommendedAnswer.
  ///
  /// In en, this message translates to:
  /// **'Recommended answer: {answer}'**
  String recommendedAnswer(String answer);

  /// No description provided for @feedbackBullet.
  ///
  /// In en, this message translates to:
  /// **'- {message}'**
  String feedbackBullet(String message);

  /// No description provided for @exercisePromptSemantics.
  ///
  /// In en, this message translates to:
  /// **'Exercise prompt: {prompt}'**
  String exercisePromptSemantics(String prompt);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'About and Settings'**
  String get settingsTitle;

  /// No description provided for @releaseStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Early public release'**
  String get releaseStatusLabel;

  /// No description provided for @releaseScopeLabel.
  ///
  /// In en, this message translates to:
  /// **'Offline Spanish A0 course'**
  String get releaseScopeLabel;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @privacyOffline.
  ///
  /// In en, this message translates to:
  /// **'Works offline.'**
  String get privacyOffline;

  /// No description provided for @privacyNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account is required.'**
  String get privacyNoAccount;

  /// No description provided for @privacyNoTracking.
  ///
  /// In en, this message translates to:
  /// **'No ads, tracking, or analytics are used.'**
  String get privacyNoTracking;

  /// No description provided for @privacyNoAi.
  ///
  /// In en, this message translates to:
  /// **'No AI service is contacted during lessons.'**
  String get privacyNoAi;

  /// No description provided for @privacyLocalProgress.
  ///
  /// In en, this message translates to:
  /// **'Learner progress stays on this device.'**
  String get privacyLocalProgress;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackBody.
  ///
  /// In en, this message translates to:
  /// **'For this early release, report issues through the project repository or directly to the project maintainer.'**
  String get feedbackBody;

  /// No description provided for @licensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Licenses and Credits'**
  String get licensesTitle;

  /// No description provided for @licensesBody.
  ///
  /// In en, this message translates to:
  /// **'Tutor Language is built with Flutter and includes authored Spanish A0 educational content. Full license and third-party credit information will be included with the public release package.'**
  String get licensesBody;

  /// No description provided for @competencyScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Competency Check'**
  String get competencyScreenTitle;

  /// No description provided for @competencyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Competency check unavailable.'**
  String get competencyUnavailable;

  /// No description provided for @competencyUnavailableWithError.
  ///
  /// In en, this message translates to:
  /// **'Competency check unavailable. {error}'**
  String competencyUnavailableWithError(String error);

  /// No description provided for @competencyTaskUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This competency task is unavailable.'**
  String get competencyTaskUnavailable;

  /// No description provided for @competencyDiagnosticIntro.
  ///
  /// In en, this message translates to:
  /// **'Show what you can do without help.'**
  String get competencyDiagnosticIntro;

  /// No description provided for @competencyRetryIntro.
  ///
  /// In en, this message translates to:
  /// **'Try the original task again.'**
  String get competencyRetryIntro;

  /// No description provided for @competencyRecoveryIntro.
  ///
  /// In en, this message translates to:
  /// **'Let\'s briefly review one part and try again.'**
  String get competencyRecoveryIntro;

  /// No description provided for @startReview.
  ///
  /// In en, this message translates to:
  /// **'Start review'**
  String get startReview;

  /// No description provided for @recoveryActivityUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Recovery activity unavailable.'**
  String get recoveryActivityUnavailable;

  /// No description provided for @competencyCheckComplete.
  ///
  /// In en, this message translates to:
  /// **'Competency check complete.'**
  String get competencyCheckComplete;

  /// No description provided for @retryCompetencyCheck.
  ///
  /// In en, this message translates to:
  /// **'Retry competency check'**
  String get retryCompetencyCheck;

  /// No description provided for @competencyAchievedTitle.
  ///
  /// In en, this message translates to:
  /// **'Competency achieved'**
  String get competencyAchievedTitle;

  /// No description provided for @competencyAchievedAfterReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Competency achieved after review'**
  String get competencyAchievedAfterReviewTitle;

  /// No description provided for @competencyNeedsPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Competency needs more practice'**
  String get competencyNeedsPracticeTitle;

  /// No description provided for @competencyNotYetAchievedTitle.
  ///
  /// In en, this message translates to:
  /// **'Competency not yet achieved'**
  String get competencyNotYetAchievedTitle;

  /// No description provided for @competencyAchievedDescription.
  ///
  /// In en, this message translates to:
  /// **'You completed the communicative task independently.'**
  String get competencyAchievedDescription;

  /// No description provided for @competencyAchievedAfterReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'You used review and then completed the communicative task.'**
  String get competencyAchievedAfterReviewDescription;

  /// No description provided for @competencyNeedsPracticeDescription.
  ///
  /// In en, this message translates to:
  /// **'You demonstrated part of the goal. Retry when ready.'**
  String get competencyNeedsPracticeDescription;

  /// No description provided for @competencyNotYetAchievedDescription.
  ///
  /// In en, this message translates to:
  /// **'The core goal is not secure yet. Retry after review.'**
  String get competencyNotYetAchievedDescription;

  /// No description provided for @notViewed.
  ///
  /// In en, this message translates to:
  /// **'Not viewed'**
  String get notViewed;

  /// No description provided for @viewed.
  ///
  /// In en, this message translates to:
  /// **'Viewed'**
  String get viewed;

  /// No description provided for @activitiesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No activities} =1{1 activity} other{{count} activities}}'**
  String activitiesCount(int count);

  /// No description provided for @noAnswerChoices.
  ///
  /// In en, this message translates to:
  /// **'No answer choices are bundled with this template.'**
  String get noAnswerChoices;

  /// No description provided for @unchecked.
  ///
  /// In en, this message translates to:
  /// **'Unchecked'**
  String get unchecked;

  /// No description provided for @templateType.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String templateType(String type);

  /// No description provided for @templatePrompt.
  ///
  /// In en, this message translates to:
  /// **'Prompt: {prompt}'**
  String templatePrompt(String prompt);

  /// No description provided for @requiredObjectTypesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No required object types} =1{1 required object type} other{{count} required object types}}'**
  String requiredObjectTypesCount(int count);

  /// No description provided for @supportedGoalsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No supported goals} =1{1 supported goal} other{{count} supported goals}}'**
  String supportedGoalsCount(int count);

  /// No description provided for @feedbackPreferredOrderNoCanonical.
  ///
  /// In en, this message translates to:
  /// **'A different order is accepted here.'**
  String get feedbackPreferredOrderNoCanonical;

  /// No description provided for @feedbackPreferredOrder.
  ///
  /// In en, this message translates to:
  /// **'A more natural order is: {answer}'**
  String feedbackPreferredOrder(String answer);

  /// No description provided for @feedbackSpanishInterrogativeQueRequiresAccent.
  ///
  /// In en, this message translates to:
  /// **'\"{canonical}\" requires an accent in this question.'**
  String feedbackSpanishInterrogativeQueRequiresAccent(String canonical);

  /// No description provided for @feedbackSpanishInterrogativeComoRequiresAccent.
  ///
  /// In en, this message translates to:
  /// **'\"{canonical}\" requires an accent in this question.'**
  String feedbackSpanishInterrogativeComoRequiresAccent(String canonical);

  /// No description provided for @feedbackSpanishMissingDiacritic.
  ///
  /// In en, this message translates to:
  /// **'Canonical Spanish spelling: \"{canonical}\".'**
  String feedbackSpanishMissingDiacritic(String canonical);

  /// No description provided for @feedbackSpanishQuestionMissingOpeningMark.
  ///
  /// In en, this message translates to:
  /// **'Spanish questions begin with \"¿\".'**
  String get feedbackSpanishQuestionMissingOpeningMark;

  /// No description provided for @feedbackSpanishQuestionMissingClosingMark.
  ///
  /// In en, this message translates to:
  /// **'Spanish questions end with \"?\".'**
  String get feedbackSpanishQuestionMissingClosingMark;

  /// No description provided for @feedbackSpanishExclamationMissingOpeningMark.
  ///
  /// In en, this message translates to:
  /// **'Spanish exclamations begin with \"¡\".'**
  String get feedbackSpanishExclamationMissingOpeningMark;

  /// No description provided for @feedbackSpanishExclamationMissingClosingMark.
  ///
  /// In en, this message translates to:
  /// **'Spanish exclamations end with \"!\".'**
  String get feedbackSpanishExclamationMissingClosingMark;

  /// No description provided for @feedbackUseCanonicalForm.
  ///
  /// In en, this message translates to:
  /// **'Use the canonical form: \"{canonical}\".'**
  String feedbackUseCanonicalForm(String canonical);

  /// No description provided for @feedbackQuestionExpectedStatementProvided.
  ///
  /// In en, this message translates to:
  /// **'This exercise asks for a question.\nYou wrote an answer.\nTry writing the Spanish question instead.'**
  String get feedbackQuestionExpectedStatementProvided;

  /// No description provided for @feedbackStatementExpectedQuestionProvided.
  ///
  /// In en, this message translates to:
  /// **'This exercise asks for a statement.\nYou wrote a question.\nTry writing the Spanish statement instead.'**
  String get feedbackStatementExpectedQuestionProvided;

  /// No description provided for @feedbackAnswerExpectedQuestion.
  ///
  /// In en, this message translates to:
  /// **'This exercise asks for an answer.\nYou wrote another question.'**
  String get feedbackAnswerExpectedQuestion;

  /// No description provided for @feedbackQuestionExpectedAnswer.
  ///
  /// In en, this message translates to:
  /// **'Write the question, not the answer.'**
  String get feedbackQuestionExpectedAnswer;

  /// No description provided for @feedbackTranslationExpectedSourceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Translate the prompt instead of copying it.'**
  String get feedbackTranslationExpectedSourceLanguage;

  /// No description provided for @feedbackGreetingExpectedFarewell.
  ///
  /// In en, this message translates to:
  /// **'This exercise asks for a greeting.\nYou wrote a farewell.'**
  String get feedbackGreetingExpectedFarewell;

  /// No description provided for @feedbackFarewellExpectedGreeting.
  ///
  /// In en, this message translates to:
  /// **'This exercise asks for a farewell.\nYou wrote a greeting.'**
  String get feedbackFarewellExpectedGreeting;

  /// No description provided for @feedbackNamePatternUseMeLlamo.
  ///
  /// In en, this message translates to:
  /// **'For this introduction pattern, use \"me llamo\".'**
  String get feedbackNamePatternUseMeLlamo;

  /// No description provided for @feedbackOriginUseSer.
  ///
  /// In en, this message translates to:
  /// **'To state origin, Spanish uses \"soy de\".'**
  String get feedbackOriginUseSer;

  /// No description provided for @feedbackOriginKeepDe.
  ///
  /// In en, this message translates to:
  /// **'Keep \"de\" in the origin pattern: \"soy de\".'**
  String get feedbackOriginKeepDe;

  /// No description provided for @feedbackOriginUseSoyDe.
  ///
  /// In en, this message translates to:
  /// **'\"Soy de\" tells where someone is from.'**
  String get feedbackOriginUseSoyDe;

  /// No description provided for @feedbackOriginQuestionIncludeDe.
  ///
  /// In en, this message translates to:
  /// **'Use \"¿De dónde eres?\" to ask where someone is from.'**
  String get feedbackOriginQuestionIncludeDe;

  /// No description provided for @feedbackResidenceUseVivoEn.
  ///
  /// In en, this message translates to:
  /// **'\"Vivo en\" tells where someone lives.'**
  String get feedbackResidenceUseVivoEn;

  /// No description provided for @feedbackResidenceQuestionNoDe.
  ///
  /// In en, this message translates to:
  /// **'Use \"¿Dónde vives?\" to ask where someone lives.'**
  String get feedbackResidenceQuestionNoDe;

  /// No description provided for @feedbackLanguagesUseHablo.
  ///
  /// In en, this message translates to:
  /// **'Use \"hablo\" to say which language you speak.'**
  String get feedbackLanguagesUseHablo;

  /// No description provided for @feedbackLanguagesUseLanguageNames.
  ///
  /// In en, this message translates to:
  /// **'Use language names such as \"ucraniano\" or \"ruso\".'**
  String get feedbackLanguagesUseLanguageNames;

  /// No description provided for @feedbackLanguagesKeepDeAfterUnPoco.
  ///
  /// In en, this message translates to:
  /// **'Keep \"de\" in \"un poco de\" before the language.'**
  String get feedbackLanguagesKeepDeAfterUnPoco;

  /// No description provided for @feedbackLanguagesAskIdiomas.
  ///
  /// In en, this message translates to:
  /// **'Use \"idiomas\" when asking which languages someone speaks.'**
  String get feedbackLanguagesAskIdiomas;

  /// No description provided for @feedbackIdentityAskSpecificQuestions.
  ///
  /// In en, this message translates to:
  /// **'Use the question that matches the information you need.'**
  String get feedbackIdentityAskSpecificQuestions;

  /// No description provided for @feedbackOriginResidenceDoNotSwap.
  ///
  /// In en, this message translates to:
  /// **'Do not swap origin and residence: \"soy de\" is origin, \"vivo en\" is residence.'**
  String get feedbackOriginResidenceDoNotSwap;

  /// No description provided for @feedbackPeopleUseEsForOther.
  ///
  /// In en, this message translates to:
  /// **'Use \"es\" when speaking about another person.'**
  String get feedbackPeopleUseEsForOther;

  /// No description provided for @feedbackPeopleUseSeLlama.
  ///
  /// In en, this message translates to:
  /// **'Use \"se llama\" to say another person’s name.'**
  String get feedbackPeopleUseSeLlama;

  /// No description provided for @feedbackPeopleUseFeminineRole.
  ///
  /// In en, this message translates to:
  /// **'Use the feminine role form for this person.'**
  String get feedbackPeopleUseFeminineRole;

  /// No description provided for @feedbackPeopleUseMasculineRole.
  ///
  /// In en, this message translates to:
  /// **'Use the masculine role form for this person.'**
  String get feedbackPeopleUseMasculineRole;

  /// No description provided for @feedbackPeopleQuestionQuienNotComo.
  ///
  /// In en, this message translates to:
  /// **'\"¿Quién es?\" asks who the person is.'**
  String get feedbackPeopleQuestionQuienNotComo;

  /// No description provided for @feedbackPeopleQuestionComoNotQuien.
  ///
  /// In en, this message translates to:
  /// **'\"¿Cómo es?\" asks what the person is like.'**
  String get feedbackPeopleQuestionComoNotQuien;

  /// No description provided for @feedbackPeopleUseFeminineDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the feminine description form for this person.'**
  String get feedbackPeopleUseFeminineDescription;

  /// No description provided for @feedbackPeopleUseMasculineDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the masculine description form for this person.'**
  String get feedbackPeopleUseMasculineDescription;

  /// No description provided for @feedbackPeopleUseViveForOther.
  ///
  /// In en, this message translates to:
  /// **'Use \"vive\" for where another person lives.'**
  String get feedbackPeopleUseViveForOther;

  /// No description provided for @feedbackPeopleUseHablaForOther.
  ///
  /// In en, this message translates to:
  /// **'Use \"habla\" for what another person speaks.'**
  String get feedbackPeopleUseHablaForOther;

  /// No description provided for @feedbackPeopleOriginResidenceContrast.
  ///
  /// In en, this message translates to:
  /// **'\"Es de\" tells origin; \"vive en\" tells residence.'**
  String get feedbackPeopleOriginResidenceContrast;

  /// No description provided for @feedbackPeopleLanguageNotNationality.
  ///
  /// In en, this message translates to:
  /// **'Use \"habla\" to say which language another person speaks.'**
  String get feedbackPeopleLanguageNotNationality;

  /// No description provided for @feedbackPeopleThirdPersonSequence.
  ///
  /// In en, this message translates to:
  /// **'Keep the whole answer in third person for another person.'**
  String get feedbackPeopleThirdPersonSequence;

  /// No description provided for @feedbackPeopleQuestionOrderMatters.
  ///
  /// In en, this message translates to:
  /// **'Use the questions in the order requested by the prompt.'**
  String get feedbackPeopleQuestionOrderMatters;

  /// No description provided for @feedbackPeopleQuestionAndPersonForm.
  ///
  /// In en, this message translates to:
  /// **'Use the requested question and third-person verb form.'**
  String get feedbackPeopleQuestionAndPersonForm;

  /// No description provided for @feedbackShoppingUseQueForObject.
  ///
  /// In en, this message translates to:
  /// **'Use \"¿Qué es esto?\" to ask what the object is.'**
  String get feedbackShoppingUseQueForObject;

  /// No description provided for @feedbackShoppingUseCuantoForPrice.
  ///
  /// In en, this message translates to:
  /// **'Use \"¿Cuánto cuesta?\" to ask the price.'**
  String get feedbackShoppingUseCuantoForPrice;

  /// No description provided for @feedbackShoppingUseCuestaForPrice.
  ///
  /// In en, this message translates to:
  /// **'Use \"cuesta\" when stating the price of one item.'**
  String get feedbackShoppingUseCuestaForPrice;

  /// No description provided for @feedbackShoppingUsePoliteTiene.
  ///
  /// In en, this message translates to:
  /// **'Use the polite shop question \"¿Tiene...?\" in this module.'**
  String get feedbackShoppingUsePoliteTiene;

  /// No description provided for @feedbackShoppingUseTenemosForShop.
  ///
  /// In en, this message translates to:
  /// **'Use \"tenemos\" when the shop says what it has.'**
  String get feedbackShoppingUseTenemosForShop;

  /// No description provided for @feedbackShoppingUseQuieroForPurchase.
  ///
  /// In en, this message translates to:
  /// **'Use \"quiero\" to say what you want to buy.'**
  String get feedbackShoppingUseQuieroForPurchase;

  /// No description provided for @feedbackShoppingUseUnaFeminine.
  ///
  /// In en, this message translates to:
  /// **'Use \"una\" with a practiced feminine noun such as \"botella\" or \"bolsa\".'**
  String get feedbackShoppingUseUnaFeminine;

  /// No description provided for @feedbackShoppingUseEsteMasculine.
  ///
  /// In en, this message translates to:
  /// **'Use \"este\" before a practiced masculine noun such as \"libro\".'**
  String get feedbackShoppingUseEsteMasculine;

  /// No description provided for @feedbackShoppingUseEstaFeminine.
  ///
  /// In en, this message translates to:
  /// **'Use \"esta\" before a practiced feminine noun such as \"bolsa\".'**
  String get feedbackShoppingUseEstaFeminine;

  /// No description provided for @feedbackShoppingUseMasculinePriceAdjective.
  ///
  /// In en, this message translates to:
  /// **'Use the masculine adjective form with this masculine object.'**
  String get feedbackShoppingUseMasculinePriceAdjective;

  /// No description provided for @feedbackShoppingUseFemininePriceAdjective.
  ///
  /// In en, this message translates to:
  /// **'Use the feminine adjective form with this feminine object.'**
  String get feedbackShoppingUseFemininePriceAdjective;

  /// No description provided for @feedbackTransportUseAPie.
  ///
  /// In en, this message translates to:
  /// **'Use \"a pie\" for going on foot.'**
  String get feedbackTransportUseAPie;

  /// No description provided for @feedbackDirectionsUseDondeForLocation.
  ///
  /// In en, this message translates to:
  /// **'Use \"¿Dónde está...?\" to ask where a place is.'**
  String get feedbackDirectionsUseDondeForLocation;

  /// No description provided for @feedbackDirectionsUseEstaForLocation.
  ///
  /// In en, this message translates to:
  /// **'Use \"está\" to say where a place is.'**
  String get feedbackDirectionsUseEstaForLocation;

  /// No description provided for @feedbackDirectionsLeftNotRight.
  ///
  /// In en, this message translates to:
  /// **'\"Izquierda\" means left.'**
  String get feedbackDirectionsLeftNotRight;

  /// No description provided for @feedbackDirectionsRightNotLeft.
  ///
  /// In en, this message translates to:
  /// **'\"Derecha\" means right.'**
  String get feedbackDirectionsRightNotLeft;

  /// No description provided for @feedbackDirectionsFarNotNear.
  ///
  /// In en, this message translates to:
  /// **'\"Lejos\" means far.'**
  String get feedbackDirectionsFarNotNear;

  /// No description provided for @feedbackDirectionsUseComoForRoute.
  ///
  /// In en, this message translates to:
  /// **'Use \"¿Cómo llego...?\" to ask how to get somewhere.'**
  String get feedbackDirectionsUseComoForRoute;

  /// No description provided for @feedbackDirectionsRouteOrderMatters.
  ///
  /// In en, this message translates to:
  /// **'Route order matters in this exercise. Follow the requested sequence.'**
  String get feedbackDirectionsRouteOrderMatters;

  /// No description provided for @feedbackTransportUseTomaForAdvice.
  ///
  /// In en, this message translates to:
  /// **'Use \"toma\" when advising which transport to take.'**
  String get feedbackTransportUseTomaForAdvice;

  /// No description provided for @feedbackDirectionsDirectionNotLocation.
  ///
  /// In en, this message translates to:
  /// **'This exercise asks for directions, not only the place location.'**
  String get feedbackDirectionsDirectionNotLocation;

  /// No description provided for @feedbackHelpPoliteOpeningFirst.
  ///
  /// In en, this message translates to:
  /// **'Start with the polite attention word, then ask for the service.'**
  String get feedbackHelpPoliteOpeningFirst;

  /// No description provided for @feedbackHelpIncludePoliteAttention.
  ///
  /// In en, this message translates to:
  /// **'Include a polite attention word before the urgent request.'**
  String get feedbackHelpIncludePoliteAttention;

  /// No description provided for @feedbackAnswersUsuallyDoNotBeginQuestionMark.
  ///
  /// In en, this message translates to:
  /// **'Answers and statements usually do not begin with \"¿\".'**
  String get feedbackAnswersUsuallyDoNotBeginQuestionMark;

  /// No description provided for @feedbackQuestionsBeginWith.
  ///
  /// In en, this message translates to:
  /// **'Questions begin with: ¿...'**
  String get feedbackQuestionsBeginWith;

  /// No description provided for @feedbackStartsWith.
  ///
  /// In en, this message translates to:
  /// **'Starts with: {prefix}'**
  String feedbackStartsWith(String prefix);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'pl', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
