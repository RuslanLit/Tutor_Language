import '../activity_engine/activity_result.dart';

enum CompetencyOutcomeStatus {
  achieved,
  achievedWithReinforcement,
  partiallyAchieved,
  notYetAchieved,
}

enum CompetencyGapReasonCode {
  missingVocabulary,
  missingStructure,
  incorrectVerbForm,
  incorrectQuestionForm,
  wordOrderFailure,
  integrationFailure,
  prerequisiteNotRetained,
}

enum CompetencyRecoveryRetryPolicy { retryOriginatingTask }

enum CompetencyAssessmentDecisionType {
  continueAssessment,
  insertRecoverySteps,
  retryAssessmentTask,
  assessmentComplete,
}

enum CompetencyAssessmentReasonCode {
  taskSucceeded,
  acceptedWithFeedbackSucceeded,
  gapDetected,
  recoveryInserted,
  recoveryUnavailable,
  recoveryCompleted,
  outcomeCalculated,
}

class CommunicativeCompetencyDefinition {
  const CommunicativeCompetencyDefinition({
    required this.competencyId,
    required this.moduleId,
    required this.title,
    required this.communicativeGoal,
    required this.requiredMicroCompetencyIds,
    required this.assessmentTaskIds,
  });

  final String competencyId;
  final String moduleId;
  final String title;
  final String communicativeGoal;
  final List<String> requiredMicroCompetencyIds;
  final List<String> assessmentTaskIds;
}

class MicroCompetencyDefinition {
  const MicroCompetencyDefinition({
    required this.microCompetencyId,
    required this.description,
    required this.introducedInModuleId,
    this.prerequisiteContentReferences = const [],
    this.recoveryStepReferences = const [],
  });

  final String microCompetencyId;
  final String description;
  final String introducedInModuleId;
  final List<String> prerequisiteContentReferences;
  final List<CompetencyRecoveryStepReference> recoveryStepReferences;
}

class CompetencyAssessmentTask {
  const CompetencyAssessmentTask({
    required this.taskId,
    required this.competencyId,
    required this.assessedMicroCompetencyIds,
    required this.lessonStepReference,
    this.recoveryMappings = const [],
    this.retryPolicy = CompetencyRecoveryRetryPolicy.retryOriginatingTask,
    this.isCentralTask = false,
  });

  final String taskId;
  final String competencyId;
  final List<String> assessedMicroCompetencyIds;
  final String lessonStepReference;
  final List<CompetencyRecoveryMapping> recoveryMappings;
  final CompetencyRecoveryRetryPolicy retryPolicy;
  final bool isCentralTask;
}

class CompetencyRecoveryMapping {
  const CompetencyRecoveryMapping({
    required this.microCompetencyId,
    required this.reasonCode,
    required this.recoveryStepReferences,
    required this.retryTaskId,
  });

  final String microCompetencyId;
  final CompetencyGapReasonCode reasonCode;
  final List<CompetencyRecoveryStepReference> recoveryStepReferences;
  final String retryTaskId;
}

class CompetencyRecoveryStepReference {
  const CompetencyRecoveryStepReference({
    required this.stepId,
    required this.sourceModuleId,
    required this.sourceLessonId,
    required this.sourceStepId,
  });

  final String stepId;
  final String sourceModuleId;
  final String sourceLessonId;
  final String sourceStepId;
}

class CommunicativeCompetencyCatalog {
  const CommunicativeCompetencyCatalog({
    required this.moduleSequence,
    required this.competencies,
    required this.microCompetencies,
    required this.assessmentTasks,
    required this.availableRecoveryStepIds,
  });

  final List<String> moduleSequence;
  final List<CommunicativeCompetencyDefinition> competencies;
  final List<MicroCompetencyDefinition> microCompetencies;
  final List<CompetencyAssessmentTask> assessmentTasks;
  final Set<String> availableRecoveryStepIds;

  CommunicativeCompetencyDefinition competency(String id) {
    return competencies.singleWhere(
      (competency) => competency.competencyId == id,
    );
  }

  CompetencyAssessmentTask task(String id) {
    return assessmentTasks.singleWhere((task) => task.taskId == id);
  }
}

class CompetencyGap {
  const CompetencyGap({
    required this.gapId,
    required this.competencyId,
    required this.assessmentTaskId,
    required this.microCompetencyId,
    required this.reasonCode,
    required this.sourceModuleId,
    required this.recoveryStepReferences,
  });

  final String gapId;
  final String competencyId;
  final String assessmentTaskId;
  final String microCompetencyId;
  final CompetencyGapReasonCode reasonCode;
  final String sourceModuleId;
  final List<CompetencyRecoveryStepReference> recoveryStepReferences;
}

class CompetencyRecoveryInsertion {
  const CompetencyRecoveryInsertion({
    required this.runtimeStepId,
    required this.gapId,
    required this.originCompetencyId,
    required this.originAssessmentTaskId,
    required this.originMicroCompetencyId,
    required this.sourceModuleId,
    required this.sourceLessonId,
    required this.sourceStepId,
  });

  final String runtimeStepId;
  final String gapId;
  final String originCompetencyId;
  final String originAssessmentTaskId;
  final String originMicroCompetencyId;
  final String sourceModuleId;
  final String sourceLessonId;
  final String sourceStepId;
}

class CompetencyAssessmentState {
  const CompetencyAssessmentState({
    required this.competencyId,
    this.succeededTaskIds = const {},
    this.failedTaskIds = const {},
    this.detectedGaps = const {},
    this.insertedRecoveryGapIds = const {},
    this.completedRecoveryGapIds = const {},
    this.retrySucceededTaskIds = const {},
  });

  final String competencyId;
  final Set<String> succeededTaskIds;
  final Set<String> failedTaskIds;
  final Map<String, CompetencyGap> detectedGaps;
  final Set<String> insertedRecoveryGapIds;
  final Set<String> completedRecoveryGapIds;
  final Set<String> retrySucceededTaskIds;

  CompetencyAssessmentState copyWith({
    Set<String>? succeededTaskIds,
    Set<String>? failedTaskIds,
    Map<String, CompetencyGap>? detectedGaps,
    Set<String>? insertedRecoveryGapIds,
    Set<String>? completedRecoveryGapIds,
    Set<String>? retrySucceededTaskIds,
  }) {
    return CompetencyAssessmentState(
      competencyId: competencyId,
      succeededTaskIds: succeededTaskIds ?? this.succeededTaskIds,
      failedTaskIds: failedTaskIds ?? this.failedTaskIds,
      detectedGaps: detectedGaps ?? this.detectedGaps,
      insertedRecoveryGapIds:
          insertedRecoveryGapIds ?? this.insertedRecoveryGapIds,
      completedRecoveryGapIds:
          completedRecoveryGapIds ?? this.completedRecoveryGapIds,
      retrySucceededTaskIds:
          retrySucceededTaskIds ?? this.retrySucceededTaskIds,
    );
  }
}

class CompetencyAssessmentDecision {
  const CompetencyAssessmentDecision({
    required this.type,
    required this.reasonCode,
    required this.updatedState,
    this.assessmentTaskId,
    this.gaps = const [],
    this.recoveryInsertions = const [],
    this.outcome,
  });

  final CompetencyAssessmentDecisionType type;
  final CompetencyAssessmentReasonCode reasonCode;
  final CompetencyAssessmentState updatedState;
  final String? assessmentTaskId;
  final List<CompetencyGap> gaps;
  final List<CompetencyRecoveryInsertion> recoveryInsertions;
  final CompetencyOutcome? outcome;
}

class CompetencyOutcome {
  const CompetencyOutcome({
    required this.competencyId,
    required this.status,
    required this.succeededTaskIds,
    required this.unresolvedGapIds,
    required this.recoveryWasRequired,
  });

  final String competencyId;
  final CompetencyOutcomeStatus status;
  final Set<String> succeededTaskIds;
  final Set<String> unresolvedGapIds;
  final bool recoveryWasRequired;
}

bool competencyTaskSucceeded(ActivityResult result) {
  return result.status == ActivityResultStatus.correct ||
      result.status == ActivityResultStatus.acceptedWithFeedback;
}

String competencyDefinitionFingerprint({
  required CommunicativeCompetencyDefinition competency,
  required List<CompetencyAssessmentTask> tasks,
}) {
  final taskPart = tasks
      .where((task) => competency.assessmentTaskIds.contains(task.taskId))
      .map(
        (task) =>
            '${task.taskId}:${task.lessonStepReference}:'
            '${task.assessedMicroCompetencyIds.join(",")}:'
            '${task.isCentralTask}',
      )
      .join('|');
  return [
    competency.competencyId,
    competency.moduleId,
    competency.requiredMicroCompetencyIds.join(','),
    competency.assessmentTaskIds.join(','),
    taskPart,
  ].join('::');
}
