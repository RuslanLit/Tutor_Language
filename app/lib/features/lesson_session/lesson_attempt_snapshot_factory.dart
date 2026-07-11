import '../../core/learner/lesson_attempt.dart';
import '../activity_engine/activity_result.dart';
import 'lesson_session_engine.dart';

const lessonLearningPolicyVersion = 'e20-v1';

class LessonAttemptSnapshotFactory {
  const LessonAttemptSnapshotFactory();

  CompletedLessonAttemptCommand create({
    required String attemptId,
    required String lessonId,
    required String courseId,
    required LessonSessionState finalState,
    required LessonSessionDecision finishDecision,
    required DateTime completedAt,
    DateTime? startedAt,
  }) {
    final outcome = finishDecision.lessonOutcome;
    final summary = finishDecision.masterySummary;
    if (outcome == null || summary == null) {
      throw const LessonAttemptValidationException(
        'A completed lesson attempt requires outcome and mastery summary.',
      );
    }
    if (finishDecision.type != LessonSessionDecisionType.finishLesson ||
        finalState.status != LessonSessionStatus.completed) {
      throw const LessonAttemptValidationException(
        'Only finished lesson sessions can be persisted.',
      );
    }
    if (lessonId != finalState.lessonId || lessonId != outcome.lessonId) {
      throw const LessonAttemptValidationException(
        'Lesson attempt lesson IDs must match.',
      );
    }
    if (!_sameSummary(outcome.summary, summary)) {
      throw const LessonAttemptValidationException(
        'Lesson outcome summary must be the finish summary.',
      );
    }
    if (outcome.status == LessonOutcomeStatus.incomplete) {
      throw const LessonAttemptValidationException(
        'Completed attempts cannot persist an incomplete lesson outcome.',
      );
    }

    final canonicalCheckableStepIds = finalState.canonicalStepIds
        .where(finalState.checkableStepIds.contains)
        .toList(growable: false);
    final uniqueStepIds = canonicalCheckableStepIds.toSet();
    if (uniqueStepIds.length != canonicalCheckableStepIds.length) {
      throw const LessonAttemptValidationException(
        'Canonical checkable step IDs must be unique.',
      );
    }

    final stepResults = canonicalCheckableStepIds
        .map((stepId) {
          final assessment = finalState.masteryAssessmentByStepId[stepId];
          if (assessment == null) {
            throw LessonAttemptValidationException(
              'Missing mastery assessment for canonical step: $stepId',
            );
          }
          return _stepResult(
            attemptId: attemptId,
            lessonId: lessonId,
            state: finalState,
            stepId: stepId,
            assessment: assessment,
          );
        })
        .toList(growable: false);

    _validateSummaryMatches(summary, stepResults);
    if (outcome.status == LessonOutcomeStatus.mastered &&
        stepResults.any(
          (step) => step.masteryStatus != DurableStepMasteryStatus.mastered,
        )) {
      throw const LessonAttemptValidationException(
        'Mastered lesson outcome cannot contain non-mastered step evidence.',
      );
    }

    final totalSubmissionCount = stepResults.fold<int>(
      0,
      (sum, step) => sum + step.attemptCount,
    );
    final attempt = DurableLessonAttempt(
      attemptId: attemptId,
      lessonId: lessonId,
      courseId: courseId,
      startedAt: startedAt,
      completedAt: completedAt.toUtc(),
      outcomeStatus: _outcomeStatus(outcome.status),
      outcomeReasonCode: _outcomeReason(outcome.reasonCode),
      assessedStepCount: summary.assessedStepCount,
      masteredStepCount: summary.masteredStepCount,
      fragileStepCount: summary.fragileStepCount,
      notMasteredStepCount: summary.notMasteredStepCount,
      unassessedStepCount: summary.unassessedStepCount,
      canonicalCheckableStepCount: canonicalCheckableStepIds.length,
      totalSubmissionCount: totalSubmissionCount,
      learningPolicyVersion: lessonLearningPolicyVersion,
    );

    return CompletedLessonAttemptCommand(
      attempt: attempt,
      stepResults: List.unmodifiable(stepResults),
    );
  }

  DurableStepResult _stepResult({
    required String attemptId,
    required String lessonId,
    required LessonSessionState state,
    required String stepId,
    required StepMasteryAssessment assessment,
  }) {
    final latestResult = state.resultByStepId[stepId];
    return DurableStepResult(
      attemptId: attemptId,
      lessonId: lessonId,
      stepId: stepId,
      masteryStatus: _stepStatus(assessment.status),
      masteryReasonCode: _stepReason(assessment.reasonCode),
      attemptCount: assessment.evidence.attemptCount,
      successfulSubmissionCount:
          assessment.evidence.correctSubmissionCount +
          assessment.evidence.acceptedWithCorrectionCount,
      latestEvaluationOutcome: _activityStatus(latestResult?.status),
      remediationWasRequired: assessment.evidence.remediationWasShown,
      reviewWasRequired: assessment.evidence.reviewWasRequired,
      confirmationSucceeded:
          assessment.reasonCode == StepMasteryReasonCode.confirmationSucceeded,
    );
  }

  void _validateSummaryMatches(
    LessonMasterySummary summary,
    List<DurableStepResult> stepResults,
  ) {
    var mastered = 0;
    var fragile = 0;
    var notMastered = 0;
    var unassessed = 0;

    for (final step in stepResults) {
      switch (step.masteryStatus) {
        case DurableStepMasteryStatus.mastered:
          mastered += 1;
        case DurableStepMasteryStatus.fragile:
          fragile += 1;
        case DurableStepMasteryStatus.notMastered:
          notMastered += 1;
        case DurableStepMasteryStatus.notAssessed:
          unassessed += 1;
      }
    }

    if (summary.masteredStepCount != mastered ||
        summary.fragileStepCount != fragile ||
        summary.notMasteredStepCount != notMastered ||
        summary.unassessedStepCount != unassessed ||
        summary.assessedStepCount != mastered + fragile + notMastered) {
      throw const LessonAttemptValidationException(
        'Lesson mastery summary does not match canonical step evidence.',
      );
    }
  }
}

bool _sameSummary(LessonMasterySummary left, LessonMasterySummary right) {
  return left.assessedStepCount == right.assessedStepCount &&
      left.masteredStepCount == right.masteredStepCount &&
      left.fragileStepCount == right.fragileStepCount &&
      left.notMasteredStepCount == right.notMasteredStepCount &&
      left.unassessedStepCount == right.unassessedStepCount &&
      left.masteryRatio == right.masteryRatio;
}

DurableLessonOutcomeStatus _outcomeStatus(LessonOutcomeStatus status) {
  return switch (status) {
    LessonOutcomeStatus.mastered => DurableLessonOutcomeStatus.mastered,
    LessonOutcomeStatus.completedWithReinforcement =>
      DurableLessonOutcomeStatus.completedWithReinforcement,
    LessonOutcomeStatus.incomplete => DurableLessonOutcomeStatus.incomplete,
  };
}

DurableLessonOutcomeReasonCode _outcomeReason(
  LessonOutcomeReasonCode reasonCode,
) {
  return switch (reasonCode) {
    LessonOutcomeReasonCode.allStepsMastered =>
      DurableLessonOutcomeReasonCode.allStepsMastered,
    LessonOutcomeReasonCode.fragileMasteryPresent =>
      DurableLessonOutcomeReasonCode.fragileMasteryPresent,
    LessonOutcomeReasonCode.lessonNotCompleted =>
      DurableLessonOutcomeReasonCode.lessonNotCompleted,
    LessonOutcomeReasonCode.noAssessableSteps =>
      DurableLessonOutcomeReasonCode.noAssessableSteps,
  };
}

DurableStepMasteryStatus _stepStatus(StepMasteryStatus status) {
  return switch (status) {
    StepMasteryStatus.notAssessed => DurableStepMasteryStatus.notAssessed,
    StepMasteryStatus.notMastered => DurableStepMasteryStatus.notMastered,
    StepMasteryStatus.fragile => DurableStepMasteryStatus.fragile,
    StepMasteryStatus.mastered => DurableStepMasteryStatus.mastered,
  };
}

DurableStepMasteryReasonCode _stepReason(StepMasteryReasonCode reasonCode) {
  return switch (reasonCode) {
    StepMasteryReasonCode.noAssessmentEvidence =>
      DurableStepMasteryReasonCode.noAssessmentEvidence,
    StepMasteryReasonCode.incorrectEvidenceOnly =>
      DurableStepMasteryReasonCode.incorrectEvidenceOnly,
    StepMasteryReasonCode.firstAttemptCorrect =>
      DurableStepMasteryReasonCode.firstAttemptCorrect,
    StepMasteryReasonCode.acceptedWithCorrection =>
      DurableStepMasteryReasonCode.acceptedWithCorrection,
    StepMasteryReasonCode.recoveredAfterIncorrect =>
      DurableStepMasteryReasonCode.recoveredAfterIncorrect,
    StepMasteryReasonCode.recoveredAfterRemediation =>
      DurableStepMasteryReasonCode.recoveredAfterRemediation,
    StepMasteryReasonCode.recoveredAfterReview =>
      DurableStepMasteryReasonCode.recoveredAfterReview,
    StepMasteryReasonCode.confirmationRequired =>
      DurableStepMasteryReasonCode.confirmationRequired,
    StepMasteryReasonCode.confirmationSucceeded =>
      DurableStepMasteryReasonCode.confirmationSucceeded,
    StepMasteryReasonCode.latestSubmissionIncorrect =>
      DurableStepMasteryReasonCode.latestSubmissionIncorrect,
  };
}

DurableActivityResultStatus _activityStatus(ActivityResultStatus? status) {
  return switch (status) {
    ActivityResultStatus.correct => DurableActivityResultStatus.correct,
    ActivityResultStatus.acceptedWithFeedback =>
      DurableActivityResultStatus.acceptedWithFeedback,
    ActivityResultStatus.incorrect => DurableActivityResultStatus.incorrect,
    ActivityResultStatus.unsupported => DurableActivityResultStatus.unsupported,
    null => DurableActivityResultStatus.notSubmitted,
  };
}
