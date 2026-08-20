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

  /// No description provided for @repeatFromStep.
  ///
  /// In en, this message translates to:
  /// **'Repeat from a step'**
  String get repeatFromStep;

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

  /// No description provided for @sentenceBuilderAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get sentenceBuilderAnswer;

  /// No description provided for @sentenceBuilderAvailableWords.
  ///
  /// In en, this message translates to:
  /// **'Available words'**
  String get sentenceBuilderAvailableWords;

  /// No description provided for @sentenceBuilderClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get sentenceBuilderClear;

  /// No description provided for @learnerSpeakerLabel.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get learnerSpeakerLabel;

  /// No description provided for @checkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get checkAnswer;

  /// No description provided for @dialogueProgress.
  ///
  /// In en, this message translates to:
  /// **'Dialogue {current} / {total}'**
  String dialogueProgress(int current, int total);

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

  /// No description provided for @feedbackMultilineMissing.
  ///
  /// In en, this message translates to:
  /// **'You entered {submitted} of {expected} lines. Complete the dialogue.'**
  String feedbackMultilineMissing(int submitted, int expected);

  /// No description provided for @feedbackMultilineExtra.
  ///
  /// In en, this message translates to:
  /// **'You entered {submitted} lines instead of {expected}. Check the dialogue.'**
  String feedbackMultilineExtra(int submitted, int expected);

  /// No description provided for @feedbackMultilineIncorrectLines.
  ///
  /// In en, this message translates to:
  /// **'{correct} of {expected} lines are correct. Check lines: {lines}.'**
  String feedbackMultilineIncorrectLines(
    int correct,
    int expected,
    String lines,
  );

  /// No description provided for @feedbackMultilineIncomplete.
  ///
  /// In en, this message translates to:
  /// **'You entered {submitted} lines. Complete the dialogue.'**
  String feedbackMultilineIncomplete(int submitted);

  /// No description provided for @feedbackMultilineTooMany.
  ///
  /// In en, this message translates to:
  /// **'You entered {submitted} lines. Check the dialogue.'**
  String feedbackMultilineTooMany(int submitted);

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

  /// No description provided for @primerTitle.
  ///
  /// In en, this message translates to:
  /// **'Spanish Alphabet'**
  String get primerTitle;

  /// No description provided for @primerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional 5–10 minute reading map before Lesson 1.'**
  String get primerSubtitle;

  /// No description provided for @primerInProgress.
  ///
  /// In en, this message translates to:
  /// **'Continue the optional reading primer.'**
  String get primerInProgress;

  /// No description provided for @primerCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed. Review it any time.'**
  String get primerCompleted;

  /// No description provided for @primerSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped. You can reopen it any time.'**
  String get primerSkipped;

  /// No description provided for @primerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Optional reading support'**
  String get primerUnavailable;

  /// No description provided for @primerStart.
  ///
  /// In en, this message translates to:
  /// **'Start primer'**
  String get primerStart;

  /// No description provided for @primerReview.
  ///
  /// In en, this message translates to:
  /// **'Review primer'**
  String get primerReview;

  /// No description provided for @primerOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional preparation — Lesson 1 stays available.'**
  String get primerOptional;

  /// No description provided for @primerIntro.
  ///
  /// In en, this message translates to:
  /// **'Below is an approximate guide to Spanish letters. You will learn to read words gradually in the lessons.'**
  String get primerIntro;

  /// No description provided for @primerContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue to Lesson 1'**
  String get primerContinue;

  /// No description provided for @primerAlphabetTitle.
  ///
  /// In en, this message translates to:
  /// **'Spanish alphabet'**
  String get primerAlphabetTitle;

  /// No description provided for @primerAlphabetRows.
  ///
  /// In en, this message translates to:
  /// **'A (ay) — a\nB (bee) — b\nC (see) — k or s\nD (dee) — d\nE (ee) — e\nF (ef) — f\nG (heh) — g or h\nH (ah-cheh) — not pronounced\nI (ee) — ee\nJ (ho-ta) — approximately a strong h\nK (kah) — k\nL (eh-leh) — l\nM (eh-meh) — m\nN (eh-neh) — n\nÑ (en-yeh) — approximately ny\nO (oh) — o\nP (peh) — p\nQ (koo) — k\nR (eh-rreh) — r\nS (eh-seh) — s\nT (teh) — t\nU (oo) — oo\nV (oo-beh) — approximately b\nW (oo-beh doh-bleh) — depends on the word\nX (eh-kees) — usually ks\nY (ee-gree-eh-gah) — approximately y or ee\nZ (seh-tah) — approximately s'**
  String get primerAlphabetRows;

  /// No description provided for @primerDigraphTitle.
  ///
  /// In en, this message translates to:
  /// **'Common letter combinations'**
  String get primerDigraphTitle;

  /// No description provided for @primerDigraphRows.
  ///
  /// In en, this message translates to:
  /// **'CH (cheh) — approximately ch\nLL (eh-yeh) — approximately y'**
  String get primerDigraphRows;

  /// No description provided for @primerSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get primerSkip;

  /// No description provided for @primerSectionCounter.
  ///
  /// In en, this message translates to:
  /// **'Reading map {current} of {total}'**
  String primerSectionCounter(int current, int total);

  /// No description provided for @primerExamples.
  ///
  /// In en, this message translates to:
  /// **'Real Spanish examples'**
  String get primerExamples;

  /// No description provided for @primerLettersTitle.
  ///
  /// In en, this message translates to:
  /// **'Letters and common combinations'**
  String get primerLettersTitle;

  /// No description provided for @primerExamplesTitle.
  ///
  /// In en, this message translates to:
  /// **'Real course examples'**
  String get primerExamplesTitle;

  /// No description provided for @primerReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick recognition check'**
  String get primerReviewTitle;

  /// No description provided for @primerLetterColumn.
  ///
  /// In en, this message translates to:
  /// **'Spanish form'**
  String get primerLetterColumn;

  /// No description provided for @primerReadingColumn.
  ///
  /// In en, this message translates to:
  /// **'Approximate reading'**
  String get primerReadingColumn;

  /// No description provided for @primerSpanishColumn.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get primerSpanishColumn;

  /// No description provided for @primerMeaningColumn.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get primerMeaningColumn;

  /// No description provided for @primerStressHint.
  ///
  /// In en, this message translates to:
  /// **'The capitalized syllable carries the main stress.'**
  String get primerStressHint;

  /// No description provided for @primerLetterH.
  ///
  /// In en, this message translates to:
  /// **'h (hache)'**
  String get primerLetterH;

  /// No description provided for @primerReadingA.
  ///
  /// In en, this message translates to:
  /// **'ah'**
  String get primerReadingA;

  /// No description provided for @primerReadingE.
  ///
  /// In en, this message translates to:
  /// **'eh'**
  String get primerReadingE;

  /// No description provided for @primerReadingI.
  ///
  /// In en, this message translates to:
  /// **'ee'**
  String get primerReadingI;

  /// No description provided for @primerReadingO.
  ///
  /// In en, this message translates to:
  /// **'oh'**
  String get primerReadingO;

  /// No description provided for @primerReadingU.
  ///
  /// In en, this message translates to:
  /// **'oo'**
  String get primerReadingU;

  /// No description provided for @primerReadingH.
  ///
  /// In en, this message translates to:
  /// **'not pronounced'**
  String get primerReadingH;

  /// No description provided for @primerReadingJ.
  ///
  /// In en, this message translates to:
  /// **'like a strong h'**
  String get primerReadingJ;

  /// No description provided for @primerReadingEnye.
  ///
  /// In en, this message translates to:
  /// **'like ny'**
  String get primerReadingEnye;

  /// No description provided for @primerReadingLl.
  ///
  /// In en, this message translates to:
  /// **'like y; in llamo, approximately yah'**
  String get primerReadingLl;

  /// No description provided for @primerReadingR.
  ///
  /// In en, this message translates to:
  /// **'a short r'**
  String get primerReadingR;

  /// No description provided for @primerReadingRr.
  ///
  /// In en, this message translates to:
  /// **'a stronger rolled r'**
  String get primerReadingRr;

  /// No description provided for @primerApproxReadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Approximate reading'**
  String get primerApproxReadingLabel;

  /// No description provided for @primerReadingHola.
  ///
  /// In en, this message translates to:
  /// **'OH-lah'**
  String get primerReadingHola;

  /// No description provided for @primerReadingMe.
  ///
  /// In en, this message translates to:
  /// **'meh'**
  String get primerReadingMe;

  /// No description provided for @primerReadingTu.
  ///
  /// In en, this message translates to:
  /// **'too'**
  String get primerReadingTu;

  /// No description provided for @primerReadingBuenosDias.
  ///
  /// In en, this message translates to:
  /// **'BWEH-nos DEE-ahs'**
  String get primerReadingBuenosDias;

  /// No description provided for @primerReadingHastaLuego.
  ///
  /// In en, this message translates to:
  /// **'AHS-tah LWEH-goh'**
  String get primerReadingHastaLuego;

  /// No description provided for @primerReadingMeLlamo.
  ///
  /// In en, this message translates to:
  /// **'meh YAH-moh'**
  String get primerReadingMeLlamo;

  /// No description provided for @primerReadingYTu.
  ///
  /// In en, this message translates to:
  /// **'ee too'**
  String get primerReadingYTu;

  /// No description provided for @primerReadingEspana.
  ///
  /// In en, this message translates to:
  /// **'es-PAH-nyah'**
  String get primerReadingEspana;

  /// No description provided for @primerReadingMadrid.
  ///
  /// In en, this message translates to:
  /// **'mah-DRID'**
  String get primerReadingMadrid;

  /// No description provided for @primerReadingComo.
  ///
  /// In en, this message translates to:
  /// **'KOH-moh'**
  String get primerReadingComo;

  /// No description provided for @primerReadingComoTeLlamas.
  ///
  /// In en, this message translates to:
  /// **'KOH-moh teh YAH-mahs'**
  String get primerReadingComoTeLlamas;

  /// No description provided for @primerReadingGracias.
  ///
  /// In en, this message translates to:
  /// **'GRAH-syahs'**
  String get primerReadingGracias;

  /// No description provided for @primerReadingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Reading habit'**
  String get primerReadingPrompt;

  /// No description provided for @primerRecognitionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Read the Spanish form as a whole, notice the highlighted pattern, and keep the example ready for later lessons.'**
  String get primerRecognitionPrompt;

  /// No description provided for @primerFinish.
  ///
  /// In en, this message translates to:
  /// **'Complete primer'**
  String get primerFinish;

  /// No description provided for @primerReopenHint.
  ///
  /// In en, this message translates to:
  /// **'This primer is optional and can be reviewed again from the course screen.'**
  String get primerReopenHint;

  /// No description provided for @primerVowelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stable vowels: a, e, i, o, u'**
  String get primerVowelsTitle;

  /// No description provided for @primerVowelsBody.
  ///
  /// In en, this message translates to:
  /// **'Read a, e, i, o and u clearly and steadily. The examples below show a practical approximation; the capitalized syllable carries the main stress.'**
  String get primerVowelsBody;

  /// No description provided for @primerVowelGuide.
  ///
  /// In en, this message translates to:
  /// **'Reading cue: a is like ah; e like eh; i like ee; o like oh; u like oo.'**
  String get primerVowelGuide;

  /// No description provided for @primerSilentHTitle.
  ///
  /// In en, this message translates to:
  /// **'h is written but not pronounced'**
  String get primerSilentHTitle;

  /// No description provided for @primerSilentHBody.
  ///
  /// In en, this message translates to:
  /// **'In Spanish, h normally has no separate sound. Notice this in hola and hasta luego.'**
  String get primerSilentHBody;

  /// No description provided for @primerLlYTitle.
  ///
  /// In en, this message translates to:
  /// **'ll and y in early course words'**
  String get primerLlYTitle;

  /// No description provided for @primerLlYBody.
  ///
  /// In en, this message translates to:
  /// **'ll is a single written unit in llamo and llamas. y is a separate letter, as in y tú. Regional pronunciation varies, but the written patterns remain visible.'**
  String get primerLlYBody;

  /// No description provided for @primerEnyeTitle.
  ///
  /// In en, this message translates to:
  /// **'ñ is a distinct Spanish letter'**
  String get primerEnyeTitle;

  /// No description provided for @primerEnyeBody.
  ///
  /// In en, this message translates to:
  /// **'ñ is not the same as n. Recognize it in España and keep the tilde as part of the Spanish spelling.'**
  String get primerEnyeBody;

  /// No description provided for @primerRRTitle.
  ///
  /// In en, this message translates to:
  /// **'r and rr'**
  String get primerRRTitle;

  /// No description provided for @primerRRBody.
  ///
  /// In en, this message translates to:
  /// **'r and rr mark different written patterns. A single r appears in Madrid; rr is the strong pattern in perro. The Primer only builds recognition, not accent training.'**
  String get primerRRBody;

  /// No description provided for @primerContextTitle.
  ///
  /// In en, this message translates to:
  /// **'Context patterns: c, g, qu, gu and gü'**
  String get primerContextTitle;

  /// No description provided for @primerContextBody.
  ///
  /// In en, this message translates to:
  /// **'c and g change their reading with the following vowel. qu commonly keeps the k-like reading before e/i; gu and gü show different written cues. Meet these patterns as complete words, not as a long rule table.'**
  String get primerContextBody;

  /// No description provided for @primerAccentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accents and Spanish punctuation'**
  String get primerAccentsTitle;

  /// No description provided for @primerAccentsBody.
  ///
  /// In en, this message translates to:
  /// **'á, é, í, ó and ú are familiar vowels with a meaningful written accent. Notice the mark in Cómo and días; full Spanish stress rules are outside this Primer.'**
  String get primerAccentsBody;

  /// No description provided for @primerTryReview.
  ///
  /// In en, this message translates to:
  /// **'Try a quick review'**
  String get primerTryReview;

  /// No description provided for @primerNoticeLabel.
  ///
  /// In en, this message translates to:
  /// **'NOTICE'**
  String get primerNoticeLabel;

  /// No description provided for @primerTryLabel.
  ///
  /// In en, this message translates to:
  /// **'TRY IT'**
  String get primerTryLabel;

  /// No description provided for @primerReviewCounter.
  ///
  /// In en, this message translates to:
  /// **'Recognition {current} of {total}'**
  String primerReviewCounter(Object current, Object total);

  /// No description provided for @primerCorrectReading.
  ///
  /// In en, this message translates to:
  /// **'Correct. {word} is read approximately as {hint}.'**
  String primerCorrectReading(String word, String hint);

  /// No description provided for @primerTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Not quite. Read the options again and try once more.'**
  String get primerTryAgain;

  /// No description provided for @primerCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get primerCheck;

  /// No description provided for @primerLlTitle.
  ///
  /// In en, this message translates to:
  /// **'ll is a Spanish spelling pattern'**
  String get primerLlTitle;

  /// No description provided for @primerLlBody.
  ///
  /// In en, this message translates to:
  /// **'In this course, ll in me llamo uses a y-like starting sound: approximately meh YAH-moh. Other regions may vary, but this is the course reference for now.'**
  String get primerLlBody;

  /// No description provided for @primerEnyeRTitle.
  ///
  /// In en, this message translates to:
  /// **'ñ and a single r'**
  String get primerEnyeRTitle;

  /// No description provided for @primerEnyeRBody.
  ///
  /// In en, this message translates to:
  /// **'In España, ñ is read with a y-like n sound: es-PAH-nyah. Madrid has a single r: mah-DRID. This is an approximate reading, not a perfect-r test.'**
  String get primerEnyeRBody;

  /// No description provided for @primerAccentsQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accent marks and written questions'**
  String get primerAccentsQuestionsTitle;

  /// No description provided for @primerAccentsQuestionsBody.
  ///
  /// In en, this message translates to:
  /// **'An accent mark helps show stress: Cómo is KOH-moh and días is BWEH-nos DEE-ahs in the example phrase. ¿ begins a written question and ? ends it; punctuation is not a sound.'**
  String get primerAccentsQuestionsBody;

  /// No description provided for @primerNarrowCTitle.
  ///
  /// In en, this message translates to:
  /// **'A small c reading clue'**
  String get primerNarrowCTitle;

  /// No description provided for @primerNarrowCBody.
  ///
  /// In en, this message translates to:
  /// **'c is not read the same way in every context: c in Cómo is k-like (KOH-moh), while c in Gracias is s-like in this course reference (GRAH-syahs). This is a small clue, not a full c chapter.'**
  String get primerNarrowCBody;

  /// No description provided for @primerExampleHola.
  ///
  /// In en, this message translates to:
  /// **'a greeting'**
  String get primerExampleHola;

  /// No description provided for @primerExampleMe.
  ///
  /// In en, this message translates to:
  /// **'me / myself'**
  String get primerExampleMe;

  /// No description provided for @primerExampleTu.
  ///
  /// In en, this message translates to:
  /// **'you'**
  String get primerExampleTu;

  /// No description provided for @primerExampleBuenosDias.
  ///
  /// In en, this message translates to:
  /// **'a daytime greeting'**
  String get primerExampleBuenosDias;

  /// No description provided for @primerExampleMeLlamo.
  ///
  /// In en, this message translates to:
  /// **'saying your name'**
  String get primerExampleMeLlamo;

  /// No description provided for @primerExampleHastaLuego.
  ///
  /// In en, this message translates to:
  /// **'a farewell'**
  String get primerExampleHastaLuego;

  /// No description provided for @primerExampleYTu.
  ///
  /// In en, this message translates to:
  /// **'asking about the other person'**
  String get primerExampleYTu;

  /// No description provided for @primerExampleEspana.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get primerExampleEspana;

  /// No description provided for @primerExampleMadrid.
  ///
  /// In en, this message translates to:
  /// **'Madrid'**
  String get primerExampleMadrid;

  /// No description provided for @primerExampleComo.
  ///
  /// In en, this message translates to:
  /// **'how / what way'**
  String get primerExampleComo;

  /// No description provided for @primerExampleComoTeLlamas.
  ///
  /// In en, this message translates to:
  /// **'What is your name?'**
  String get primerExampleComoTeLlamas;

  /// No description provided for @primerExampleGracias.
  ///
  /// In en, this message translates to:
  /// **'thank you'**
  String get primerExampleGracias;

  /// No description provided for @primerReviewHolaReadingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Which Spanish word is read approximately as {hint}?'**
  String primerReviewHolaReadingPrompt(String hint);

  /// No description provided for @primerReviewEspanaReadingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Which Spanish word is read approximately as {hint}?'**
  String primerReviewEspanaReadingPrompt(String hint);

  /// No description provided for @primerReviewQuestionReadingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Which Spanish question is read approximately as {hint}?'**
  String primerReviewQuestionReadingPrompt(String hint);

  /// No description provided for @audioListen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get audioListen;

  /// No description provided for @audioUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Audio unavailable. Try again.'**
  String get audioUnavailable;

  /// No description provided for @recordingPurpose.
  ///
  /// In en, this message translates to:
  /// **'Microphone access lets you record your voice and listen to it locally.'**
  String get recordingPurpose;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get stopRecording;

  /// No description provided for @playMyRecording.
  ///
  /// In en, this message translates to:
  /// **'Play my recording'**
  String get playMyRecording;

  /// No description provided for @recordAgain.
  ///
  /// In en, this message translates to:
  /// **'Record again'**
  String get recordAgain;

  /// No description provided for @deleteRecording.
  ///
  /// In en, this message translates to:
  /// **'Delete recording'**
  String get deleteRecording;

  /// No description provided for @microphoneDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone access was denied. You can continue without recording.'**
  String get microphoneDenied;

  /// No description provided for @tryRecordingAgain.
  ///
  /// In en, this message translates to:
  /// **'Try recording again'**
  String get tryRecordingAgain;

  /// No description provided for @recordingFailed.
  ///
  /// In en, this message translates to:
  /// **'Recording failed. You can continue without recording.'**
  String get recordingFailed;

  /// No description provided for @continueWithoutRecording.
  ///
  /// In en, this message translates to:
  /// **'Continue without recording'**
  String get continueWithoutRecording;

  /// No description provided for @spokenPractice.
  ///
  /// In en, this message translates to:
  /// **'Spoken practice'**
  String get spokenPractice;

  /// No description provided for @listen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listen;

  /// No description provided for @sayItAloud.
  ///
  /// In en, this message translates to:
  /// **'Say it aloud'**
  String get sayItAloud;

  /// No description provided for @tryFromMemory.
  ///
  /// In en, this message translates to:
  /// **'Try from memory'**
  String get tryFromMemory;

  /// No description provided for @listenToReference.
  ///
  /// In en, this message translates to:
  /// **'Listen to reference'**
  String get listenToReference;

  /// No description provided for @showReference.
  ///
  /// In en, this message translates to:
  /// **'Show reference'**
  String get showReference;

  /// No description provided for @finishAttempt.
  ///
  /// In en, this message translates to:
  /// **'Finish attempt'**
  String get finishAttempt;

  /// No description provided for @continuePractice.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuePractice;

  /// No description provided for @practiceComplete.
  ///
  /// In en, this message translates to:
  /// **'Practice complete'**
  String get practiceComplete;
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
