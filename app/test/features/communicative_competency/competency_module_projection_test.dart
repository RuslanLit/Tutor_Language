import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/features/communicative_competency/communicative_competency.dart';

void main() {
  late AppDatabase database;
  late CompetencyAttemptRepository repository;
  late ModuleCompetencyProjectionService service;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = CompetencyAttemptRepository(database);
    service = ModuleCompetencyProjectionService(repository: repository);
  });

  tearDown(() async {
    await database.close();
  });

  test('unavailable before checkpoint completion', () async {
    final projection = await service.project(
      competency: _competency,
      moduleContentComplete: true,
      checkpointComplete: false,
    );

    expect(projection.state, ModuleCompetencyState.moduleContentIncomplete);
  });

  test('available after module content and checkpoint completion', () async {
    final projection = await service.project(
      competency: _competency,
      moduleContentComplete: true,
      checkpointComplete: true,
    );

    expect(
      projection.state,
      ModuleCompetencyState.moduleContentCompleteCompetencyNotStarted,
    );
    expect(projection.canStart, isTrue);
  });

  test('in-progress and completed outcomes are projected distinctly', () async {
    await repository.startCompetencyAttempt(
      StartCompetencyAttemptCommand(attempt: _attempt('attempt.active')),
    );

    final active = await service.project(
      competency: _competency,
      moduleContentComplete: true,
      checkpointComplete: true,
    );
    expect(active.state, ModuleCompetencyState.competencyInProgress);
    expect(active.canContinue, isTrue);

    await repository.completeCompetencyAttempt(
      CompleteCompetencyAttemptCommand(
        attemptId: 'attempt.active',
        completedAt: DateTime.utc(2026, 1, 1, 13),
        finalOutcome: CompetencyOutcomeStatus.notYetAchieved,
      ),
    );

    final completed = await service.project(
      competency: _competency,
      moduleContentComplete: true,
      checkpointComplete: true,
    );
    expect(completed.state, ModuleCompetencyState.competencyNotYetAchieved);
    expect(completed.canRetry, isTrue);
  });
}

const _competency = CommunicativeCompetencyDefinition(
  competencyId: 'competency.es.a0.m03.personal_profile',
  moduleId: 'M03',
  title: 'Personal profile',
  communicativeGoal: 'Give a short profile.',
  requiredMicroCompetencyIds: ['micro.introduce_self'],
  assessmentTaskIds: ['task.introduce_self'],
);

DurableCompetencyAttempt _attempt(String attemptId) {
  return DurableCompetencyAttempt(
    attemptId: attemptId,
    competencyId: _competency.competencyId,
    moduleId: _competency.moduleId,
    startedAt: DateTime.utc(2026, 1, 1, 12),
    status: CompetencyAttemptStatus.inProgress,
    definitionFingerprint: 'fixture-v1',
  );
}
