import 'competency_attempt_repository.dart';
import 'communicative_competency_models.dart';

enum ModuleCompetencyState {
  moduleContentIncomplete,
  moduleContentCompleteCompetencyNotStarted,
  competencyInProgress,
  competencyAchieved,
  competencyAchievedWithReinforcement,
  competencyPartiallyAchieved,
  competencyNotYetAchieved,
}

class ModuleCompetencyProjection {
  const ModuleCompetencyProjection({
    required this.competencyId,
    required this.moduleId,
    required this.state,
    this.activeAttemptId,
    this.latestOutcome,
  });

  final String competencyId;
  final String moduleId;
  final ModuleCompetencyState state;
  final String? activeAttemptId;
  final CompetencyOutcomeStatus? latestOutcome;

  bool get canStart =>
      state == ModuleCompetencyState.moduleContentCompleteCompetencyNotStarted;

  bool get canContinue => state == ModuleCompetencyState.competencyInProgress;

  bool get canRetry =>
      state == ModuleCompetencyState.competencyPartiallyAchieved ||
      state == ModuleCompetencyState.competencyNotYetAchieved;
}

class ModuleCompetencyProjectionService {
  const ModuleCompetencyProjectionService({required this.repository});

  final CompetencyAttemptRepository repository;

  Future<ModuleCompetencyProjection> project({
    required CommunicativeCompetencyDefinition competency,
    required bool moduleContentComplete,
    required bool checkpointComplete,
  }) async {
    if (!moduleContentComplete || !checkpointComplete) {
      return ModuleCompetencyProjection(
        competencyId: competency.competencyId,
        moduleId: competency.moduleId,
        state: ModuleCompetencyState.moduleContentIncomplete,
      );
    }

    final active = await repository.loadActiveCompetencyAttempt(
      competency.competencyId,
    );
    if (active != null) {
      return ModuleCompetencyProjection(
        competencyId: competency.competencyId,
        moduleId: competency.moduleId,
        state: ModuleCompetencyState.competencyInProgress,
        activeAttemptId: active.attempt.attemptId,
      );
    }

    final latest = await repository.loadLatestCompetencyOutcome(
      competency.competencyId,
    );
    if (latest == null || latest.finalOutcome == null) {
      return ModuleCompetencyProjection(
        competencyId: competency.competencyId,
        moduleId: competency.moduleId,
        state: ModuleCompetencyState.moduleContentCompleteCompetencyNotStarted,
      );
    }

    return ModuleCompetencyProjection(
      competencyId: competency.competencyId,
      moduleId: competency.moduleId,
      state: _stateFor(latest.finalOutcome!),
      latestOutcome: latest.finalOutcome,
    );
  }

  ModuleCompetencyState _stateFor(CompetencyOutcomeStatus status) {
    return switch (status) {
      CompetencyOutcomeStatus.achieved =>
        ModuleCompetencyState.competencyAchieved,
      CompetencyOutcomeStatus.achievedWithReinforcement =>
        ModuleCompetencyState.competencyAchievedWithReinforcement,
      CompetencyOutcomeStatus.partiallyAchieved =>
        ModuleCompetencyState.competencyPartiallyAchieved,
      CompetencyOutcomeStatus.notYetAchieved =>
        ModuleCompetencyState.competencyNotYetAchieved,
    };
  }
}
