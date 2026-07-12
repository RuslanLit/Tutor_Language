import '../curriculum/curriculum_models.dart';
import 'communicative_competency_models.dart';

class RuntimeCompetencyDefinition {
  const RuntimeCompetencyDefinition({
    required this.competency,
    required this.diagnosticTaskTemplateIds,
    required this.recoveryTemplateIds,
  });

  final CommunicativeCompetencyDefinition competency;
  final Map<String, String> diagnosticTaskTemplateIds;
  final Map<String, String> recoveryTemplateIds;
}

class CompetencyDefinitionRegistry {
  const CompetencyDefinitionRegistry({this.definitions = _defaultDefinitions});

  final List<RuntimeCompetencyDefinition> definitions;

  List<RuntimeCompetencyDefinition> definitionsForModule(String moduleId) {
    return definitions
        .where((definition) => definition.competency.moduleId == moduleId)
        .toList(growable: false);
  }

  RuntimeCompetencyDefinition? lookup({
    required String moduleId,
    required String competencyId,
  }) {
    for (final definition in definitions) {
      if (definition.competency.moduleId == moduleId &&
          definition.competency.competencyId == competencyId) {
        return definition;
      }
    }
    return null;
  }

  CommunicativeCompetencyCatalog catalogFor(
    RuntimeCompetencyDefinition definition,
  ) {
    return CommunicativeCompetencyCatalog(
      moduleSequence: const ['es.a0.m01', 'es.a0.m02', 'es.a0.m03'],
      competencies: [definition.competency],
      microCompetencies: _microCompetencies,
      assessmentTasks: _assessmentTasks,
      availableRecoveryStepIds: definition.recoveryTemplateIds.values.toSet(),
    );
  }
}

const _defaultDefinitions = [
  RuntimeCompetencyDefinition(
    competency: CommunicativeCompetencyDefinition(
      competencyId: 'competency.es.a0.m03.personal_profile',
      moduleId: 'es.a0.m03',
      title: 'Personal identity check',
      communicativeGoal:
          'Give basic personal identity information using known patterns.',
      requiredMicroCompetencyIds: [
        'micro.es.a0.introduce_self',
        'micro.es.a0.state_origin',
      ],
      assessmentTaskIds: [
        'task.es.a0.introduce_self',
        'task.es.a0.state_origin',
      ],
    ),
    diagnosticTaskTemplateIds: {
      'task.es.a0.introduce_self':
          'template.es.a0.m02.review.type_me_llamo_marta.v1',
      'task.es.a0.state_origin':
          'template.es.a0.m02.review.type_soy_de_valencia.v1',
    },
    recoveryTemplateIds: {
      'micro.es.a0.introduce_self':
          'template.es.a0.m02.l004.name_pattern_choice.v1',
      'micro.es.a0.state_origin': 'template.es.a0.m02.l009.origin_choice.v1',
    },
  ),
];

const _microCompetencies = [
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.introduce_self',
    description: 'Introduce oneself with the me llamo pattern.',
    introducedInModuleId: 'es.a0.m02',
    prerequisiteContentReferences: [
      'template.es.a0.m02.l004.type_me_llamo_carlos.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_origin',
    description: 'State origin with soy de.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m02.l009.type_soy_de_mexico.v1',
    ],
  ),
];

const _assessmentTasks = [
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.introduce_self',
    competencyId: 'competency.es.a0.m03.personal_profile',
    assessedMicroCompetencyIds: ['micro.es.a0.introduce_self'],
    lessonStepReference: 'template.es.a0.m02.review.type_me_llamo_marta.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.introduce_self',
        reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m02.l004.name_pattern_choice.v1',
            sourceModuleId: 'es.a0.m02',
            sourceLessonId: 'es.a0.m02.l004',
            sourceStepId: 'template.es.a0.m02.l004.name_pattern_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.introduce_self',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.state_origin',
    competencyId: 'competency.es.a0.m03.personal_profile',
    assessedMicroCompetencyIds: ['micro.es.a0.state_origin'],
    lessonStepReference: 'template.es.a0.m02.review.type_soy_de_valencia.v1',
    isCentralTask: true,
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_origin',
        reasonCode: CompetencyGapReasonCode.missingStructure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m02.l009.origin_choice.v1',
            sourceModuleId: 'es.a0.m02',
            sourceLessonId: 'es.a0.m02.l009',
            sourceStepId: 'template.es.a0.m02.l009.origin_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.state_origin',
      ),
    ],
  ),
];

LessonContentReference templateReference(String templateId) {
  return LessonContentReference(
    type: 'exercise_template',
    assetPath: 'assets/languages/spanish/templates/module_2_names.json',
    referenceId: templateId,
  );
}
