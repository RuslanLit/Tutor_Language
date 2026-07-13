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
      competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
      moduleId: 'es.a0.m03',
      title: 'Basic personal identity check',
      communicativeGoal:
          'Exchange basic personal identity information using known patterns.',
      requiredMicroCompetencyIds: [
        'micro.es.a0.introduce_self',
        'micro.es.a0.state_origin',
        'micro.es.a0.state_residence',
        'micro.es.a0.state_languages',
        'micro.es.a0.ask_origin',
        'micro.es.a0.ask_languages',
        'micro.es.a0.build_personal_identity_profile',
      ],
      assessmentTaskIds: [
        'task.es.a0.introduce_self',
        'task.es.a0.state_origin',
        'task.es.a0.state_residence',
        'task.es.a0.state_languages',
        'task.es.a0.ask_origin_and_languages',
        'task.es.a0.build_personal_identity_profile',
      ],
    ),
    diagnosticTaskTemplateIds: {
      'task.es.a0.introduce_self':
          'template.es.a0.m03.competency.type_intro_marta.v1',
      'task.es.a0.state_origin':
          'template.es.a0.m03.competency.type_origin_ucrania.v1',
      'task.es.a0.state_residence':
          'template.es.a0.m03.competency.type_residence_kyiv.v1',
      'task.es.a0.state_languages':
          'template.es.a0.m03.competency.type_languages_ucranian_spanish.v1',
      'task.es.a0.ask_origin_and_languages':
          'template.es.a0.m03.competency.type_ask_origin_languages.v1',
      'task.es.a0.build_personal_identity_profile':
          'template.es.a0.m03.competency.type_identity_profile.v1',
    },
    recoveryTemplateIds: {
      'micro.es.a0.introduce_self':
          'template.es.a0.m02.l004.name_pattern_choice.v1',
      'micro.es.a0.state_origin': 'template.es.a0.m03.l013.origin_choice.v1',
      'micro.es.a0.state_residence':
          'template.es.a0.m03.l015.residence_choice.v1',
      'micro.es.a0.state_languages':
          'template.es.a0.m03.l016.language_choice.v1',
      'micro.es.a0.ask_origin':
          'template.es.a0.m03.l014.origin_question_choice.v1',
      'micro.es.a0.ask_languages':
          'template.es.a0.m03.l017.exchange_question_choice.v1',
      'micro.es.a0.build_personal_identity_profile':
          'template.es.a0.m03.l015.origin_residence_contrast.v1',
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
      'template.es.a0.m03.l013.type_soy_de_ucrania.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_origin',
    description: 'Ask where one person is from.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l014.type_de_donde_eres.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_residence',
    description: 'State residence with vivo en.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l015.type_vivo_en_kyiv.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_residence',
    description: 'Ask where one person lives.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l015.type_donde_vives.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_languages',
    description: 'State spoken languages with hablo.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l016.type_hablo_ucraniano_y_ruso.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_languages',
    description: 'Ask which languages one person speaks.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l016.type_que_idiomas_hablas.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_limited_language_ability',
    description: 'State limited language ability with un poco de.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l016.type_hablo_un_poco_espanol.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.understand_personal_identity_profile',
    description: 'Understand a short personal identity profile.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l018.reading_profile_choice.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.build_personal_identity_profile',
    description:
        'Build a short profile with name, origin, residence and languages.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l018.type_profile_elena.v1',
    ],
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.exchange_personal_identity_information',
    description: 'Exchange basic identity questions and answers.',
    introducedInModuleId: 'es.a0.m03',
    prerequisiteContentReferences: [
      'template.es.a0.m03.l017.type_ask_origin_and_languages.v1',
    ],
  ),
];

const _assessmentTasks = [
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.introduce_self',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: ['micro.es.a0.introduce_self'],
    lessonStepReference: 'template.es.a0.m03.competency.type_intro_marta.v1',
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
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: ['micro.es.a0.state_origin'],
    lessonStepReference: 'template.es.a0.m03.competency.type_origin_ucrania.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_origin',
        reasonCode: CompetencyGapReasonCode.missingStructure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l013.origin_choice.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l013',
            sourceStepId: 'template.es.a0.m03.l013.origin_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.state_origin',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.state_residence',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: ['micro.es.a0.state_residence'],
    lessonStepReference: 'template.es.a0.m03.competency.type_residence_kyiv.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_residence',
        reasonCode: CompetencyGapReasonCode.missingStructure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l015.residence_choice.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l015',
            sourceStepId: 'template.es.a0.m03.l015.residence_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.state_residence',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.state_languages',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: [
      'micro.es.a0.state_languages',
      'micro.es.a0.state_limited_language_ability',
    ],
    lessonStepReference:
        'template.es.a0.m03.competency.type_languages_ucranian_spanish.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.state_languages',
        reasonCode: CompetencyGapReasonCode.missingVocabulary,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l016.language_choice.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l016',
            sourceStepId: 'template.es.a0.m03.l016.language_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.state_languages',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.ask_origin_and_languages',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: [
      'micro.es.a0.ask_origin',
      'micro.es.a0.ask_languages',
    ],
    lessonStepReference:
        'template.es.a0.m03.competency.type_ask_origin_languages.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_origin',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l014.origin_question_choice.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l014',
            sourceStepId: 'template.es.a0.m03.l014.origin_question_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.ask_origin_and_languages',
      ),
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.ask_languages',
        reasonCode: CompetencyGapReasonCode.incorrectQuestionForm,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l017.exchange_question_choice.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l017',
            sourceStepId: 'template.es.a0.m03.l017.exchange_question_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.ask_origin_and_languages',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.build_personal_identity_profile',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: [
      'micro.es.a0.build_personal_identity_profile',
      'micro.es.a0.exchange_personal_identity_information',
    ],
    lessonStepReference:
        'template.es.a0.m03.competency.type_identity_profile.v1',
    isCentralTask: true,
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.build_personal_identity_profile',
        reasonCode: CompetencyGapReasonCode.integrationFailure,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m03.l015.origin_residence_contrast.v1',
            sourceModuleId: 'es.a0.m03',
            sourceLessonId: 'es.a0.m03.l015',
            sourceStepId:
                'template.es.a0.m03.l015.origin_residence_contrast.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.build_personal_identity_profile',
      ),
    ],
  ),
];

LessonContentReference templateReference(String templateId) {
  final assetPath = templateId.startsWith('template.es.a0.m03.')
      ? 'assets/languages/spanish/templates/module_3_identity.json'
      : 'assets/languages/spanish/templates/module_2_names.json';
  return LessonContentReference(
    type: 'exercise_template',
    assetPath: assetPath,
    referenceId: templateId,
  );
}
