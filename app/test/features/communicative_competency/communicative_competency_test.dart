import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/features/activity_engine/activity_result.dart';
import 'package:tutor_language/features/communicative_competency/communicative_competency.dart';
import 'package:tutor_language/features/lesson_session/lesson_session_engine.dart';

void main() {
  group('CommunicativeCompetencyValidator', () {
    test('valid competency definition loads', () {
      final result = const CommunicativeCompetencyValidator().validate(
        _fixtureCatalog(),
      );

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('duplicate competency ID fails', () {
      final catalog = _fixtureCatalog(
        extraCompetencies: [
          const CommunicativeCompetencyDefinition(
            competencyId: 'competency.es.a0.m03.personal_profile',
            moduleId: 'M03',
            title: 'Duplicate',
            communicativeGoal: 'Duplicate competency.',
            requiredMicroCompetencyIds: ['micro.introduce_self'],
            assessmentTaskIds: ['task.introduce_self'],
          ),
        ],
      );

      final result = const CommunicativeCompetencyValidator().validate(catalog);

      expect(
        result.errors.map((error) => error.code),
        contains(CompetencyValidationErrorCode.duplicateCompetencyId),
      );
    });

    test('missing micro-competency reference fails', () {
      final catalog = _fixtureCatalog(
        competencyOverride: const CommunicativeCompetencyDefinition(
          competencyId: 'competency.es.a0.m03.personal_profile',
          moduleId: 'M03',
          title: 'Personal profile',
          communicativeGoal: 'Give a short personal profile.',
          requiredMicroCompetencyIds: ['micro.missing'],
          assessmentTaskIds: ['task.introduce_self'],
        ),
      );

      final result = const CommunicativeCompetencyValidator().validate(catalog);

      expect(
        result.errors.map((error) => error.code),
        contains(CompetencyValidationErrorCode.missingMicroCompetencyReference),
      );
    });

    test('missing recovery step reference fails', () {
      final catalog = _fixtureCatalog(availableRecoveryStepIds: const {});

      final result = const CommunicativeCompetencyValidator().validate(catalog);

      expect(
        result.errors.map((error) => error.code),
        contains(CompetencyValidationErrorCode.missingRecoveryStepReference),
      );
    });

    test('future-module prerequisite reference fails', () {
      final catalog = _fixtureCatalog(
        extraMicroCompetencies: const [
          MicroCompetencyDefinition(
            microCompetencyId: 'micro.future',
            description: 'Future capability.',
            introducedInModuleId: 'M04',
          ),
        ],
        competencyOverride: const CommunicativeCompetencyDefinition(
          competencyId: 'competency.es.a0.m03.personal_profile',
          moduleId: 'M03',
          title: 'Personal profile',
          communicativeGoal: 'Give a short personal profile.',
          requiredMicroCompetencyIds: ['micro.introduce_self', 'micro.future'],
          assessmentTaskIds: ['task.introduce_self'],
        ),
      );

      final result = const CommunicativeCompetencyValidator().validate(catalog);

      expect(
        result.errors.map((error) => error.code),
        contains(CompetencyValidationErrorCode.futureModuleReference),
      );
    });

    test('recovery cycle or duplicate insertion hazard fails validation', () {
      final recovery = _recoveryReference(
        stepId: 'step.assess.introduce_self',
        moduleId: 'M02',
      );
      final catalog = _fixtureCatalog(
        introduceSelfTaskOverride: CompetencyAssessmentTask(
          taskId: 'task.introduce_self',
          competencyId: 'competency.es.a0.m03.personal_profile',
          assessedMicroCompetencyIds: const ['micro.introduce_self'],
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
        availableRecoveryStepIds: {recovery.stepId},
      );

      final result = const CommunicativeCompetencyValidator().validate(catalog);

      expect(
        result.errors.map((error) => error.code),
        contains(CompetencyValidationErrorCode.recoveryCycle),
      );
    });
  });

  group('CommunicativeCompetencyCoordinator', () {
    test('all diagnostic tasks succeed produces achieved', () {
      final catalog = _fixtureCatalog();
      const coordinator = CommunicativeCompetencyCoordinator();
      var state = coordinator.startAssessment(
        competencyId: 'competency.es.a0.m03.personal_profile',
      );

      for (final taskId
          in catalog.competency(state.competencyId).assessmentTaskIds) {
        final decision = coordinator.recordTaskResult(
          catalog: catalog,
          state: state,
          taskId: taskId,
          result: _correct(taskId),
        );
        state = decision.updatedState;
      }

      final outcome = coordinator.evaluateOutcome(
        catalog: catalog,
        state: state,
      );

      expect(outcome.status, CompetencyOutcomeStatus.achieved);
      expect(outcome.recoveryWasRequired, isFalse);
      expect(outcome.unresolvedGapIds, isEmpty);
    });

    test('one task fails, recovery succeeds, retry succeeds', () {
      final catalog = _fixtureCatalog();
      const coordinator = CommunicativeCompetencyCoordinator();
      var state = coordinator.startAssessment(
        competencyId: 'competency.es.a0.m03.personal_profile',
      );

      final failure = coordinator.recordTaskResult(
        catalog: catalog,
        state: state,
        taskId: 'task.introduce_self',
        result: _incorrect('task.introduce_self'),
      );

      expect(
        failure.type,
        CompetencyAssessmentDecisionType.insertRecoverySteps,
      );
      expect(failure.recoveryInsertions.single.sourceModuleId, 'M02');
      expect(
        failure.recoveryInsertions.single.runtimeStepId,
        startsWith('competency_recovery::'),
      );

      final recovery = coordinator.recordRecoveryCompleted(
        catalog: catalog,
        state: failure.updatedState,
        gapId: failure.gaps.single.gapId,
      );
      expect(
        recovery.type,
        CompetencyAssessmentDecisionType.retryAssessmentTask,
      );
      expect(recovery.assessmentTaskId, 'task.introduce_self');

      state = coordinator
          .recordTaskResult(
            catalog: catalog,
            state: recovery.updatedState,
            taskId: 'task.introduce_self',
            result: _correct('task.introduce_self'),
          )
          .updatedState;
      state = coordinator
          .recordTaskResult(
            catalog: catalog,
            state: state,
            taskId: 'task.state_origin',
            result: _correct('task.state_origin'),
          )
          .updatedState;
      state = coordinator
          .recordTaskResult(
            catalog: catalog,
            state: state,
            taskId: 'task.build_profile',
            result: _correct('task.build_profile'),
          )
          .updatedState;

      final outcome = coordinator.evaluateOutcome(
        catalog: catalog,
        state: state,
      );

      expect(outcome.status, CompetencyOutcomeStatus.achievedWithReinforcement);
      expect(outcome.recoveryWasRequired, isTrue);
      expect(outcome.unresolvedGapIds, isEmpty);
    });

    test('unresolved non-central gap produces partiallyAchieved', () {
      final catalog = _fixtureCatalog();
      const coordinator = CommunicativeCompetencyCoordinator();
      var state = coordinator.startAssessment(
        competencyId: 'competency.es.a0.m03.personal_profile',
      );

      state = coordinator
          .recordTaskResult(
            catalog: catalog,
            state: state,
            taskId: 'task.introduce_self',
            result: _correct('task.introduce_self'),
          )
          .updatedState;
      state = coordinator
          .recordTaskResult(
            catalog: catalog,
            state: state,
            taskId: 'task.state_origin',
            result: _incorrect('task.state_origin'),
          )
          .updatedState;

      final outcome = coordinator.evaluateOutcome(
        catalog: catalog,
        state: state,
      );

      expect(outcome.status, CompetencyOutcomeStatus.partiallyAchieved);
      expect(outcome.unresolvedGapIds, isNotEmpty);
    });

    test('central task failure after retry produces notYetAchieved', () {
      final catalog = _fixtureCatalog();
      const coordinator = CommunicativeCompetencyCoordinator();
      var state = coordinator.startAssessment(
        competencyId: 'competency.es.a0.m03.personal_profile',
      );

      state = coordinator
          .recordTaskResult(
            catalog: catalog,
            state: state,
            taskId: 'task.introduce_self',
            result: _correct('task.introduce_self'),
          )
          .updatedState;
      state = coordinator
          .recordTaskResult(
            catalog: catalog,
            state: state,
            taskId: 'task.state_origin',
            result: _correct('task.state_origin'),
          )
          .updatedState;
      state = coordinator
          .recordTaskResult(
            catalog: catalog,
            state: state,
            taskId: 'task.build_profile',
            result: _incorrect('task.build_profile'),
          )
          .updatedState;

      final outcome = coordinator.evaluateOutcome(
        catalog: catalog,
        state: state,
      );

      expect(outcome.status, CompetencyOutcomeStatus.notYetAchieved);
    });

    test('acceptedWithFeedback remains successful', () {
      final catalog = _fixtureCatalog();
      const coordinator = CommunicativeCompetencyCoordinator();
      final state = coordinator.startAssessment(
        competencyId: 'competency.es.a0.m03.personal_profile',
      );

      final decision = coordinator.recordTaskResult(
        catalog: catalog,
        state: state,
        taskId: 'task.introduce_self',
        result: const ActivityResult(
          exerciseId: 'task.introduce_self',
          isCorrect: true,
          status: ActivityResultStatus.acceptedWithFeedback,
        ),
      );

      expect(
        decision.type,
        CompetencyAssessmentDecisionType.continueAssessment,
      );
      expect(
        decision.updatedState.succeededTaskIds,
        contains('task.introduce_self'),
      );
      expect(decision.updatedState.detectedGaps, isEmpty);
      expect(decision.recoveryInsertions, isEmpty);
    });

    test('informational session steps do not create false gaps', () {
      const engine = LessonSessionEngine();
      final decision = engine.startSession(
        lessonId: 'lesson.info',
        steps: const [LessonSessionStep(id: 'info.1', isCheckable: false)],
      );

      final next = engine.requestNext(decision.updatedState);

      expect(next.reasonCode, LessonSessionReasonCode.lastStepCompleted);
      expect(next.updatedState.attemptsByStepId, isEmpty);
    });
  });
}

CommunicativeCompetencyCatalog _fixtureCatalog({
  CommunicativeCompetencyDefinition? competencyOverride,
  CompetencyAssessmentTask? introduceSelfTaskOverride,
  List<CommunicativeCompetencyDefinition> extraCompetencies = const [],
  List<MicroCompetencyDefinition> extraMicroCompetencies = const [],
  Set<String>? availableRecoveryStepIds,
}) {
  final introduceRecovery = _recoveryReference(
    stepId: 'step.recovery.m02.me_llamo',
    moduleId: 'M02',
  );
  final originRecovery = _recoveryReference(
    stepId: 'step.recovery.m03.soy_de',
    moduleId: 'M03',
  );
  final competency =
      competencyOverride ??
      const CommunicativeCompetencyDefinition(
        competencyId: 'competency.es.a0.m03.personal_profile',
        moduleId: 'M03',
        title: 'Personal profile',
        communicativeGoal:
            'Give a short personal profile with name and origin.',
        requiredMicroCompetencyIds: [
          'micro.introduce_self',
          'micro.state_origin',
          'micro.build_personal_profile',
        ],
        assessmentTaskIds: [
          'task.introduce_self',
          'task.state_origin',
          'task.build_profile',
        ],
      );

  final introduceTask =
      introduceSelfTaskOverride ??
      CompetencyAssessmentTask(
        taskId: 'task.introduce_self',
        competencyId: 'competency.es.a0.m03.personal_profile',
        assessedMicroCompetencyIds: const ['micro.introduce_self'],
        lessonStepReference: 'step.assess.introduce_self',
        recoveryMappings: [
          CompetencyRecoveryMapping(
            microCompetencyId: 'micro.introduce_self',
            reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
            recoveryStepReferences: [introduceRecovery],
            retryTaskId: 'task.introduce_self',
          ),
        ],
      );

  return CommunicativeCompetencyCatalog(
    moduleSequence: const ['M01', 'M02', 'M03', 'M04'],
    competencies: [competency, ...extraCompetencies],
    microCompetencies: [
      const MicroCompetencyDefinition(
        microCompetencyId: 'micro.introduce_self',
        description: 'Introduce oneself with me llamo.',
        introducedInModuleId: 'M02',
        prerequisiteContentReferences: ['template.es.a0.m02.type_me_llamo'],
      ),
      const MicroCompetencyDefinition(
        microCompetencyId: 'micro.state_origin',
        description: 'State origin with soy de.',
        introducedInModuleId: 'M03',
        prerequisiteContentReferences: ['template.es.a0.m03.type_soy_de'],
      ),
      const MicroCompetencyDefinition(
        microCompetencyId: 'micro.build_personal_profile',
        description: 'Combine name and origin in a short profile.',
        introducedInModuleId: 'M03',
      ),
      ...extraMicroCompetencies,
    ],
    assessmentTasks: [
      introduceTask,
      CompetencyAssessmentTask(
        taskId: 'task.state_origin',
        competencyId: 'competency.es.a0.m03.personal_profile',
        assessedMicroCompetencyIds: const ['micro.state_origin'],
        lessonStepReference: 'step.assess.state_origin',
        recoveryMappings: [
          CompetencyRecoveryMapping(
            microCompetencyId: 'micro.state_origin',
            reasonCode: CompetencyGapReasonCode.missingStructure,
            recoveryStepReferences: [originRecovery],
            retryTaskId: 'task.state_origin',
          ),
        ],
      ),
      const CompetencyAssessmentTask(
        taskId: 'task.build_profile',
        competencyId: 'competency.es.a0.m03.personal_profile',
        assessedMicroCompetencyIds: ['micro.build_personal_profile'],
        lessonStepReference: 'step.assess.build_profile',
        isCentralTask: true,
      ),
    ],
    availableRecoveryStepIds:
        availableRecoveryStepIds ??
        {introduceRecovery.stepId, originRecovery.stepId},
  );
}

CompetencyRecoveryStepReference _recoveryReference({
  required String stepId,
  required String moduleId,
}) {
  return CompetencyRecoveryStepReference(
    stepId: stepId,
    sourceModuleId: moduleId,
    sourceLessonId: 'lesson.$moduleId.recovery',
    sourceStepId: stepId,
  );
}

ActivityResult _correct(String id) {
  return ActivityResult(exerciseId: id, isCorrect: true);
}

ActivityResult _incorrect(String id) {
  return ActivityResult(exerciseId: id, isCorrect: false);
}
