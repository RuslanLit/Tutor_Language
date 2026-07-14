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
  String get checkAnswer => 'Check';

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
    return 'Required object types: $count';
  }

  @override
  String supportedGoalsCount(int count) {
    return 'Supported goals: $count';
  }
}
