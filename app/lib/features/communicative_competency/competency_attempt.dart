import 'communicative_competency_models.dart';

enum CompetencyAttemptStatus {
  inProgress('in_progress'),
  completed('completed'),
  abandoned('abandoned');

  const CompetencyAttemptStatus(this.code);

  final String code;

  static CompetencyAttemptStatus fromCode(String code) {
    for (final value in values) {
      if (value.code == code) {
        return value;
      }
    }
    throw CompetencyAttemptDecodeException(
      'Unknown competency attempt status: $code',
    );
  }
}

enum CompetencyTaskResultPhase {
  initialAssessment('initial_assessment'),
  recovery('recovery'),
  retry('retry');

  const CompetencyTaskResultPhase(this.code);

  final String code;

  static CompetencyTaskResultPhase fromCode(String code) {
    for (final value in values) {
      if (value.code == code) {
        return value;
      }
    }
    throw CompetencyAttemptDecodeException(
      'Unknown competency task result phase: $code',
    );
  }
}

enum CompetencyGapResolutionStatus {
  unresolved('unresolved'),
  resolved('resolved'),
  abandoned('abandoned');

  const CompetencyGapResolutionStatus(this.code);

  final String code;

  static CompetencyGapResolutionStatus fromCode(String code) {
    for (final value in values) {
      if (value.code == code) {
        return value;
      }
    }
    throw CompetencyAttemptDecodeException(
      'Unknown competency gap resolution status: $code',
    );
  }
}

enum CompetencyRecoveryExecutionStatus {
  inserted('inserted'),
  started('started'),
  completed('completed');

  const CompetencyRecoveryExecutionStatus(this.code);

  final String code;

  static CompetencyRecoveryExecutionStatus fromCode(String code) {
    for (final value in values) {
      if (value.code == code) {
        return value;
      }
    }
    throw CompetencyAttemptDecodeException(
      'Unknown competency recovery status: $code',
    );
  }
}

class DurableCompetencyAttempt {
  const DurableCompetencyAttempt({
    required this.attemptId,
    required this.competencyId,
    required this.moduleId,
    required this.startedAt,
    required this.status,
    required this.definitionFingerprint,
    this.completedAt,
    this.finalOutcome,
  });

  final String attemptId;
  final String competencyId;
  final String moduleId;
  final DateTime startedAt;
  final CompetencyAttemptStatus status;
  final String definitionFingerprint;
  final DateTime? completedAt;
  final CompetencyOutcomeStatus? finalOutcome;
}

class DurableCompetencyTaskResult {
  const DurableCompetencyTaskResult({
    required this.resultId,
    required this.attemptId,
    required this.assessmentTaskId,
    required this.microCompetencyIds,
    required this.attemptSequence,
    required this.phase,
    required this.activityResultStatus,
    required this.createdAt,
    this.reasonCode,
  });

  final String resultId;
  final String attemptId;
  final String assessmentTaskId;
  final List<String> microCompetencyIds;
  final int attemptSequence;
  final CompetencyTaskResultPhase phase;
  final String activityResultStatus;
  final DateTime createdAt;
  final String? reasonCode;
}

class DurableCompetencyGap {
  const DurableCompetencyGap({
    required this.gapId,
    required this.attemptId,
    required this.assessmentTaskId,
    required this.microCompetencyId,
    required this.reasonCode,
    required this.sourceModuleId,
    required this.sourceLessonId,
    required this.sourceStepId,
    required this.detectedAt,
    required this.resolutionStatus,
    this.resolvedAt,
  });

  final String gapId;
  final String attemptId;
  final String assessmentTaskId;
  final String microCompetencyId;
  final String reasonCode;
  final String sourceModuleId;
  final String sourceLessonId;
  final String sourceStepId;
  final DateTime detectedAt;
  final DateTime? resolvedAt;
  final CompetencyGapResolutionStatus resolutionStatus;
}

class DurableCompetencyRecoveryExecution {
  const DurableCompetencyRecoveryExecution({
    required this.recoveryExecutionId,
    required this.attemptId,
    required this.gapId,
    required this.recoveryStepId,
    required this.sourceModuleId,
    required this.sourceLessonId,
    required this.sourceStepId,
    required this.status,
    this.startedAt,
    this.completedAt,
    this.succeeded,
    this.retryOccurred = false,
  });

  final String recoveryExecutionId;
  final String attemptId;
  final String gapId;
  final String recoveryStepId;
  final String sourceModuleId;
  final String sourceLessonId;
  final String sourceStepId;
  final CompetencyRecoveryExecutionStatus status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final bool? succeeded;
  final bool retryOccurred;
}

class CompetencyAttemptSnapshot {
  const CompetencyAttemptSnapshot({
    required this.attempt,
    required this.taskResults,
    required this.gaps,
    required this.recoveryExecutions,
  });

  final DurableCompetencyAttempt attempt;
  final List<DurableCompetencyTaskResult> taskResults;
  final List<DurableCompetencyGap> gaps;
  final List<DurableCompetencyRecoveryExecution> recoveryExecutions;
}

class StartCompetencyAttemptCommand {
  const StartCompetencyAttemptCommand({required this.attempt});

  final DurableCompetencyAttempt attempt;
}

class CompleteCompetencyAttemptCommand {
  const CompleteCompetencyAttemptCommand({
    required this.attemptId,
    required this.completedAt,
    required this.finalOutcome,
  });

  final String attemptId;
  final DateTime completedAt;
  final CompetencyOutcomeStatus finalOutcome;
}

enum CompetencyPersistenceStatus {
  created,
  alreadyRecordedIdentically,
  updated,
  conflict,
  failure,
}

class CompetencyPersistenceResult {
  const CompetencyPersistenceResult({
    required this.status,
    required this.attemptId,
    this.message,
  });

  final CompetencyPersistenceStatus status;
  final String attemptId;
  final String? message;

  bool get isSuccess =>
      status == CompetencyPersistenceStatus.created ||
      status == CompetencyPersistenceStatus.alreadyRecordedIdentically ||
      status == CompetencyPersistenceStatus.updated;
}

class CompetencyAttemptDecodeException implements Exception {
  const CompetencyAttemptDecodeException(this.message);

  final String message;

  @override
  String toString() => message;
}

class CompetencyAttemptValidationException implements Exception {
  const CompetencyAttemptValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
