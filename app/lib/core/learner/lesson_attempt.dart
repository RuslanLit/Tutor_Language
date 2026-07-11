enum DurableLessonOutcomeStatus {
  mastered('mastered'),
  completedWithReinforcement('completed_with_reinforcement'),
  incomplete('incomplete');

  const DurableLessonOutcomeStatus(this.code);

  final String code;

  static DurableLessonOutcomeStatus fromCode(String code) {
    for (final value in values) {
      if (value.code == code) {
        return value;
      }
    }
    throw LessonAttemptDecodeException('Unknown lesson outcome status: $code');
  }
}

enum DurableLessonOutcomeReasonCode {
  allStepsMastered('all_steps_mastered'),
  fragileMasteryPresent('fragile_mastery_present'),
  lessonNotCompleted('lesson_not_completed'),
  noAssessableSteps('no_assessable_steps');

  const DurableLessonOutcomeReasonCode(this.code);

  final String code;

  static DurableLessonOutcomeReasonCode fromCode(String code) {
    for (final value in values) {
      if (value.code == code) {
        return value;
      }
    }
    throw LessonAttemptDecodeException(
      'Unknown lesson outcome reason code: $code',
    );
  }
}

enum DurableStepMasteryStatus {
  notAssessed('not_assessed'),
  notMastered('not_mastered'),
  fragile('fragile'),
  mastered('mastered');

  const DurableStepMasteryStatus(this.code);

  final String code;

  static DurableStepMasteryStatus fromCode(String code) {
    for (final value in values) {
      if (value.code == code) {
        return value;
      }
    }
    throw LessonAttemptDecodeException('Unknown step mastery status: $code');
  }
}

enum DurableStepMasteryReasonCode {
  noAssessmentEvidence('no_assessment_evidence'),
  incorrectEvidenceOnly('incorrect_evidence_only'),
  firstAttemptCorrect('first_attempt_correct'),
  acceptedWithCorrection('accepted_with_correction'),
  recoveredAfterIncorrect('recovered_after_incorrect'),
  recoveredAfterRemediation('recovered_after_remediation'),
  recoveredAfterReview('recovered_after_review'),
  confirmationRequired('confirmation_required'),
  confirmationSucceeded('confirmation_succeeded'),
  latestSubmissionIncorrect('latest_submission_incorrect');

  const DurableStepMasteryReasonCode(this.code);

  final String code;

  static DurableStepMasteryReasonCode fromCode(String code) {
    for (final value in values) {
      if (value.code == code) {
        return value;
      }
    }
    throw LessonAttemptDecodeException(
      'Unknown step mastery reason code: $code',
    );
  }
}

enum DurableActivityResultStatus {
  correct('correct'),
  incorrect('incorrect'),
  acceptedWithFeedback('accepted_with_feedback'),
  unsupported('unsupported'),
  notSubmitted('not_submitted');

  const DurableActivityResultStatus(this.code);

  final String code;

  static DurableActivityResultStatus fromCode(String code) {
    for (final value in values) {
      if (value.code == code) {
        return value;
      }
    }
    throw LessonAttemptDecodeException('Unknown activity result status: $code');
  }
}

class DurableLessonAttempt {
  const DurableLessonAttempt({
    required this.attemptId,
    required this.lessonId,
    required this.courseId,
    required this.completedAt,
    required this.outcomeStatus,
    required this.outcomeReasonCode,
    required this.assessedStepCount,
    required this.masteredStepCount,
    required this.fragileStepCount,
    required this.notMasteredStepCount,
    required this.unassessedStepCount,
    required this.canonicalCheckableStepCount,
    required this.totalSubmissionCount,
    required this.learningPolicyVersion,
    this.startedAt,
  });

  final String attemptId;
  final String lessonId;
  final String courseId;
  final DateTime? startedAt;
  final DateTime completedAt;
  final DurableLessonOutcomeStatus outcomeStatus;
  final DurableLessonOutcomeReasonCode outcomeReasonCode;
  final int assessedStepCount;
  final int masteredStepCount;
  final int fragileStepCount;
  final int notMasteredStepCount;
  final int unassessedStepCount;
  final int canonicalCheckableStepCount;
  final int totalSubmissionCount;
  final String learningPolicyVersion;
}

class DurableStepResult {
  const DurableStepResult({
    required this.attemptId,
    required this.lessonId,
    required this.stepId,
    required this.masteryStatus,
    required this.masteryReasonCode,
    required this.attemptCount,
    required this.successfulSubmissionCount,
    required this.latestEvaluationOutcome,
    required this.remediationWasRequired,
    required this.reviewWasRequired,
    required this.confirmationSucceeded,
  });

  final String attemptId;
  final String lessonId;
  final String stepId;
  final DurableStepMasteryStatus masteryStatus;
  final DurableStepMasteryReasonCode masteryReasonCode;
  final int attemptCount;
  final int successfulSubmissionCount;
  final DurableActivityResultStatus latestEvaluationOutcome;
  final bool remediationWasRequired;
  final bool reviewWasRequired;
  final bool confirmationSucceeded;
}

class CompletedLessonAttemptCommand {
  const CompletedLessonAttemptCommand({
    required this.attempt,
    required this.stepResults,
  });

  final DurableLessonAttempt attempt;
  final List<DurableStepResult> stepResults;
}

enum CompletedLessonAttemptPersistenceStatus {
  created,
  alreadyRecordedIdentically,
  conflict,
  failure,
}

class CompletedLessonAttemptPersistenceResult {
  const CompletedLessonAttemptPersistenceResult({
    required this.status,
    required this.attemptId,
    required this.lessonId,
    this.message,
  });

  final CompletedLessonAttemptPersistenceStatus status;
  final String attemptId;
  final String lessonId;
  final String? message;

  bool get isSuccess =>
      status == CompletedLessonAttemptPersistenceStatus.created ||
      status ==
          CompletedLessonAttemptPersistenceStatus.alreadyRecordedIdentically;

  static CompletedLessonAttemptPersistenceResult created({
    required String attemptId,
    required String lessonId,
  }) {
    return CompletedLessonAttemptPersistenceResult(
      status: CompletedLessonAttemptPersistenceStatus.created,
      attemptId: attemptId,
      lessonId: lessonId,
    );
  }

  static CompletedLessonAttemptPersistenceResult alreadyRecordedIdentically({
    required String attemptId,
    required String lessonId,
  }) {
    return CompletedLessonAttemptPersistenceResult(
      status:
          CompletedLessonAttemptPersistenceStatus.alreadyRecordedIdentically,
      attemptId: attemptId,
      lessonId: lessonId,
    );
  }

  static CompletedLessonAttemptPersistenceResult conflict({
    required String attemptId,
    required String lessonId,
    required String message,
  }) {
    return CompletedLessonAttemptPersistenceResult(
      status: CompletedLessonAttemptPersistenceStatus.conflict,
      attemptId: attemptId,
      lessonId: lessonId,
      message: message,
    );
  }

  static CompletedLessonAttemptPersistenceResult failure({
    required String attemptId,
    required String lessonId,
    required String message,
  }) {
    return CompletedLessonAttemptPersistenceResult(
      status: CompletedLessonAttemptPersistenceStatus.failure,
      attemptId: attemptId,
      lessonId: lessonId,
      message: message,
    );
  }
}

class LessonAttemptSummary {
  const LessonAttemptSummary({
    required this.attemptId,
    required this.lessonId,
    required this.courseId,
    required this.completedAt,
    required this.outcomeStatus,
    required this.masteredStepCount,
    required this.fragileStepCount,
    required this.canonicalCheckableStepCount,
  });

  final String attemptId;
  final String lessonId;
  final String courseId;
  final DateTime completedAt;
  final DurableLessonOutcomeStatus outcomeStatus;
  final int masteredStepCount;
  final int fragileStepCount;
  final int canonicalCheckableStepCount;
}

class LessonAttemptDecodeException implements Exception {
  const LessonAttemptDecodeException(this.message);

  final String message;

  @override
  String toString() => message;
}

class LessonAttemptValidationException implements Exception {
  const LessonAttemptValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
