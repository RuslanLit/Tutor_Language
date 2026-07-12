import 'communicative_competency_models.dart';

enum CompetencyValidationErrorCode {
  duplicateCompetencyId,
  duplicateMicroCompetencyId,
  duplicateAssessmentTaskId,
  missingAssessmentTaskReference,
  missingMicroCompetencyReference,
  missingRecoveryStepReference,
  retryTaskMismatch,
  recoveryCycle,
  emptyRequiredMicroCompetencySet,
  emptyAssessedMicroCompetencySet,
  futureModuleReference,
  malformedModuleOwnership,
}

class CompetencyValidationError {
  const CompetencyValidationError({required this.code, required this.message});

  final CompetencyValidationErrorCode code;
  final String message;
}

class CompetencyValidationResult {
  const CompetencyValidationResult(this.errors);

  final List<CompetencyValidationError> errors;

  bool get isValid => errors.isEmpty;
}

class CommunicativeCompetencyValidator {
  const CommunicativeCompetencyValidator();

  CompetencyValidationResult validate(CommunicativeCompetencyCatalog catalog) {
    final errors = <CompetencyValidationError>[];
    final competencyIds = _duplicates(
      catalog.competencies.map((competency) => competency.competencyId),
    );
    for (final id in competencyIds) {
      errors.add(
        CompetencyValidationError(
          code: CompetencyValidationErrorCode.duplicateCompetencyId,
          message: 'Duplicate competency id: $id',
        ),
      );
    }

    final microIds = _duplicates(
      catalog.microCompetencies.map((micro) => micro.microCompetencyId),
    );
    for (final id in microIds) {
      errors.add(
        CompetencyValidationError(
          code: CompetencyValidationErrorCode.duplicateMicroCompetencyId,
          message: 'Duplicate micro-competency id: $id',
        ),
      );
    }

    final taskIds = _duplicates(
      catalog.assessmentTasks.map((task) => task.taskId),
    );
    for (final id in taskIds) {
      errors.add(
        CompetencyValidationError(
          code: CompetencyValidationErrorCode.duplicateAssessmentTaskId,
          message: 'Duplicate assessment task id: $id',
        ),
      );
    }

    final knownMicroIds = catalog.microCompetencies
        .map((micro) => micro.microCompetencyId)
        .toSet();
    final knownTaskIds = catalog.assessmentTasks
        .map((task) => task.taskId)
        .toSet();
    final moduleOrder = {
      for (var i = 0; i < catalog.moduleSequence.length; i++)
        catalog.moduleSequence[i]: i,
    };

    for (final competency in catalog.competencies) {
      final competencyModuleIndex = moduleOrder[competency.moduleId];
      if (competencyModuleIndex == null) {
        errors.add(
          CompetencyValidationError(
            code: CompetencyValidationErrorCode.malformedModuleOwnership,
            message:
                'Competency ${competency.competencyId} has unknown module '
                '${competency.moduleId}',
          ),
        );
      }

      if (competency.requiredMicroCompetencyIds.isEmpty) {
        errors.add(
          CompetencyValidationError(
            code: CompetencyValidationErrorCode.emptyRequiredMicroCompetencySet,
            message:
                'Competency ${competency.competencyId} has no required '
                'micro-competencies',
          ),
        );
      }

      for (final microId in competency.requiredMicroCompetencyIds) {
        if (!knownMicroIds.contains(microId)) {
          errors.add(
            CompetencyValidationError(
              code:
                  CompetencyValidationErrorCode.missingMicroCompetencyReference,
              message:
                  'Competency ${competency.competencyId} references unknown '
                  'micro-competency $microId',
            ),
          );
        }
      }

      for (final taskId in competency.assessmentTaskIds) {
        if (!knownTaskIds.contains(taskId)) {
          errors.add(
            CompetencyValidationError(
              code:
                  CompetencyValidationErrorCode.missingAssessmentTaskReference,
              message:
                  'Competency ${competency.competencyId} references unknown '
                  'assessment task $taskId',
            ),
          );
        }
      }

      for (final micro in catalog.microCompetencies) {
        final microModuleIndex = moduleOrder[micro.introducedInModuleId];
        if (microModuleIndex == null) {
          errors.add(
            CompetencyValidationError(
              code: CompetencyValidationErrorCode.malformedModuleOwnership,
              message:
                  'Micro-competency ${micro.microCompetencyId} has unknown '
                  'module ${micro.introducedInModuleId}',
            ),
          );
          continue;
        }
        if (competency.requiredMicroCompetencyIds.contains(
              micro.microCompetencyId,
            ) &&
            competencyModuleIndex != null &&
            microModuleIndex > competencyModuleIndex) {
          errors.add(
            CompetencyValidationError(
              code: CompetencyValidationErrorCode.futureModuleReference,
              message:
                  'Competency ${competency.competencyId} references future '
                  'micro-competency ${micro.microCompetencyId}',
            ),
          );
        }
      }
    }

    for (final task in catalog.assessmentTasks) {
      if (task.assessedMicroCompetencyIds.isEmpty) {
        errors.add(
          CompetencyValidationError(
            code: CompetencyValidationErrorCode.emptyAssessedMicroCompetencySet,
            message: 'Assessment task ${task.taskId} assesses no capabilities',
          ),
        );
      }

      for (final microId in task.assessedMicroCompetencyIds) {
        if (!knownMicroIds.contains(microId)) {
          errors.add(
            CompetencyValidationError(
              code:
                  CompetencyValidationErrorCode.missingMicroCompetencyReference,
              message:
                  'Assessment task ${task.taskId} references unknown '
                  'micro-competency $microId',
            ),
          );
        }
      }

      for (final mapping in task.recoveryMappings) {
        if (!task.assessedMicroCompetencyIds.contains(
          mapping.microCompetencyId,
        )) {
          errors.add(
            CompetencyValidationError(
              code:
                  CompetencyValidationErrorCode.missingMicroCompetencyReference,
              message:
                  'Recovery mapping for ${task.taskId} targets unassessed '
                  'micro-competency ${mapping.microCompetencyId}',
            ),
          );
        }

        if (mapping.retryTaskId != task.taskId) {
          errors.add(
            CompetencyValidationError(
              code: CompetencyValidationErrorCode.retryTaskMismatch,
              message:
                  'Recovery mapping for ${task.taskId} retries '
                  '${mapping.retryTaskId}',
            ),
          );
        }

        for (final recoveryRef in mapping.recoveryStepReferences) {
          if (!catalog.availableRecoveryStepIds.contains(recoveryRef.stepId)) {
            errors.add(
              CompetencyValidationError(
                code:
                    CompetencyValidationErrorCode.missingRecoveryStepReference,
                message:
                    'Recovery mapping for ${task.taskId} references unavailable '
                    'step ${recoveryRef.stepId}',
              ),
            );
          }
          if (recoveryRef.stepId == task.lessonStepReference) {
            errors.add(
              CompetencyValidationError(
                code: CompetencyValidationErrorCode.recoveryCycle,
                message:
                    'Recovery mapping for ${task.taskId} points back to the '
                    'diagnostic step',
              ),
            );
          }
        }
      }
    }

    return CompetencyValidationResult(List.unmodifiable(errors));
  }

  Set<String> _duplicates(Iterable<String> ids) {
    final seen = <String>{};
    final duplicates = <String>{};
    for (final id in ids) {
      if (!seen.add(id)) {
        duplicates.add(id);
      }
    }
    return duplicates;
  }
}
