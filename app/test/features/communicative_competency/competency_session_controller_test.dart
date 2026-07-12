import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/features/activity_engine/activity_result.dart';
import 'package:tutor_language/features/communicative_competency/communicative_competency.dart';
import 'package:tutor_language/features/lesson_session/lesson_session_engine.dart';

void main() {
  late AppDatabase database;
  late CompetencyAttemptRepository repository;
  late CompetencySessionController controller;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = CompetencyAttemptRepository(database);
    controller = CompetencySessionController(
      catalog: _catalog(),
      repository: repository,
      now: () => DateTime.utc(2026, 1, 1, 12),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('diagnostic success executes through Lesson Session Engine', () async {
    var state = await controller.startOrResume(
      competencyId: 'competency.es.a0.m03.personal_profile',
      attemptId: 'attempt.runtime',
    );

    final decision = await controller.submitDiagnosticResult(
      state: state,
      taskId: 'task.introduce_self',
      result: const ActivityResult(
        exerciseId: 'task.introduce_self',
        isCorrect: true,
      ),
    );

    expect(
      decision.sessionDecision?.reasonCode,
      LessonSessionReasonCode.correctAnswerAccepted,
    );
    expect(
      decision.updatedState.competencyState.succeededTaskIds,
      contains('task.introduce_self'),
    );
    final snapshot = await repository.loadCompetencyAttempt('attempt.runtime');
    expect(
      snapshot?.taskResults.single.phase,
      CompetencyTaskResultPhase.initialAssessment,
    );
  });

  test('failure persists gap, recovery, retry and final outcome', () async {
    var state = await controller.startOrResume(
      competencyId: 'competency.es.a0.m03.personal_profile',
      attemptId: 'attempt.runtime',
    );

    final failed = await controller.submitDiagnosticResult(
      state: state,
      taskId: 'task.introduce_self',
      result: const ActivityResult(
        exerciseId: 'task.introduce_self',
        isCorrect: false,
      ),
    );
    expect(
      failed.competencyDecision.type,
      CompetencyAssessmentDecisionType.insertRecoverySteps,
    );
    expect(
      failed.competencyDecision.recoveryInsertions.single.sourceModuleId,
      'M02',
    );

    final recovery = await controller.completeRecovery(
      state: failed.updatedState,
      gapId: failed.competencyDecision.gaps.single.gapId,
    );
    expect(
      recovery.competencyDecision.type,
      CompetencyAssessmentDecisionType.retryAssessmentTask,
    );

    state = recovery.updatedState;
    final retry = await controller.submitDiagnosticResult(
      state: state,
      taskId: 'task.introduce_self',
      result: const ActivityResult(
        exerciseId: 'task.introduce_self',
        isCorrect: true,
      ),
    );
    state = retry.updatedState;
    state = (await controller.submitDiagnosticResult(
      state: state,
      taskId: 'task.build_profile',
      result: const ActivityResult(
        exerciseId: 'task.build_profile',
        isCorrect: true,
      ),
    )).updatedState;

    final outcome = await controller.finishIfReady(state);
    final snapshot = await repository.loadCompetencyAttempt('attempt.runtime');

    expect(outcome.status, CompetencyOutcomeStatus.achievedWithReinforcement);
    expect(
      snapshot?.attempt.finalOutcome,
      CompetencyOutcomeStatus.achievedWithReinforcement,
    );
    expect(
      snapshot?.gaps.single.resolutionStatus,
      CompetencyGapResolutionStatus.resolved,
    );
    expect(snapshot?.recoveryExecutions.single.sourceModuleId, 'M02');
    expect(
      snapshot?.taskResults.map((result) => result.phase),
      contains(CompetencyTaskResultPhase.retry),
    );
  });

  test('active attempt resumes without duplicating recovery', () async {
    var state = await controller.startOrResume(
      competencyId: 'competency.es.a0.m03.personal_profile',
      attemptId: 'attempt.runtime',
    );
    final failed = await controller.submitDiagnosticResult(
      state: state,
      taskId: 'task.introduce_self',
      result: const ActivityResult(
        exerciseId: 'task.introduce_self',
        isCorrect: false,
      ),
    );

    final resumed = await controller.startOrResume(
      competencyId: 'competency.es.a0.m03.personal_profile',
      attemptId: 'attempt.ignored',
    );

    expect(resumed.attemptId, 'attempt.runtime');
    expect(resumed.competencyState.detectedGaps, hasLength(1));
    expect(resumed.competencyState.insertedRecoveryGapIds, hasLength(1));
    expect(failed.competencyDecision.recoveryInsertions, hasLength(1));
  });
}

CommunicativeCompetencyCatalog _catalog() {
  const recovery = CompetencyRecoveryStepReference(
    stepId: 'step.recovery.m02.me_llamo',
    sourceModuleId: 'M02',
    sourceLessonId: 'lesson.m02.me_llamo',
    sourceStepId: 'step.recovery.m02.me_llamo',
  );

  return CommunicativeCompetencyCatalog(
    moduleSequence: const ['M01', 'M02', 'M03'],
    competencies: const [
      CommunicativeCompetencyDefinition(
        competencyId: 'competency.es.a0.m03.personal_profile',
        moduleId: 'M03',
        title: 'Personal profile',
        communicativeGoal: 'Give a short personal identity profile.',
        requiredMicroCompetencyIds: [
          'micro.introduce_self',
          'micro.build_personal_profile',
        ],
        assessmentTaskIds: ['task.introduce_self', 'task.build_profile'],
      ),
    ],
    microCompetencies: const [
      MicroCompetencyDefinition(
        microCompetencyId: 'micro.introduce_self',
        description: 'Introduce oneself with me llamo.',
        introducedInModuleId: 'M02',
      ),
      MicroCompetencyDefinition(
        microCompetencyId: 'micro.build_personal_profile',
        description: 'Combine known personal facts.',
        introducedInModuleId: 'M03',
      ),
    ],
    assessmentTasks: const [
      CompetencyAssessmentTask(
        taskId: 'task.introduce_self',
        competencyId: 'competency.es.a0.m03.personal_profile',
        assessedMicroCompetencyIds: ['micro.introduce_self'],
        lessonStepReference: 'step.assess.introduce_self',
        recoveryMappings: [
          CompetencyRecoveryMapping(
            microCompetencyId: 'micro.introduce_self',
            reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
            recoveryStepReferences: [recovery],
            retryTaskId: 'task.introduce_self',
          ),
        ],
      ),
      CompetencyAssessmentTask(
        taskId: 'task.build_profile',
        competencyId: 'competency.es.a0.m03.personal_profile',
        assessedMicroCompetencyIds: ['micro.build_personal_profile'],
        lessonStepReference: 'step.assess.build_profile',
        isCentralTask: true,
      ),
    ],
    availableRecoveryStepIds: {'step.recovery.m02.me_llamo'},
  );
}
