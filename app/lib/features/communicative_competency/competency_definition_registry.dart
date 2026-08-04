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
      moduleSequence: const ['es.a0.m01'],
      competencies: [definition.competency],
      microCompetencies: const [],
      assessmentTasks: const [],
      availableRecoveryStepIds: definition.recoveryTemplateIds.values.toSet(),
    );
  }
}

const _defaultDefinitions = <RuntimeCompetencyDefinition>[];

LessonContentReference templateReference(String templateId) {
  return LessonContentReference(
    type: 'exercise_template',
    assetPath: 'assets/languages/spanish/templates/empty.json',
    referenceId: templateId,
  );
}
