import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/content_providers.dart';
import '../../core/content/topic_content.dart';
import '../../core/database/database_provider.dart';
import 'competency_attempt_repository.dart';
import 'competency_definition_registry.dart';
import 'competency_module_projection.dart';
import 'competency_session_controller.dart';

final competencyDefinitionRegistryProvider =
    Provider<CompetencyDefinitionRegistry>((ref) {
      return const CompetencyDefinitionRegistry();
    });

final competencyAttemptRepositoryProvider =
    Provider<CompetencyAttemptRepository>((ref) {
      return CompetencyAttemptRepository(ref.watch(appDatabaseProvider));
    });

final competencyProjectionServiceProvider =
    Provider<ModuleCompetencyProjectionService>((ref) {
      return ModuleCompetencyProjectionService(
        repository: ref.watch(competencyAttemptRepositoryProvider),
      );
    });

final moduleCompetencyProjectionsProvider =
    FutureProvider.family<
      List<ModuleCompetencyProjection>,
      ModuleCompetencyProjectionRequest
    >((ref, request) async {
      final registry = ref.watch(competencyDefinitionRegistryProvider);
      final service = ref.watch(competencyProjectionServiceProvider);
      final definitions = registry.definitionsForModule(request.moduleId);

      final projections = <ModuleCompetencyProjection>[];
      for (final definition in definitions) {
        projections.add(
          await service.project(
            competency: definition.competency,
            moduleContentComplete: request.moduleContentComplete,
            checkpointComplete: request.checkpointComplete,
          ),
        );
      }
      return List.unmodifiable(projections);
    });

final runtimeCompetencyDefinitionProvider =
    Provider.family<RuntimeCompetencyDefinition?, CompetencyRouteRequest>((
      ref,
      request,
    ) {
      return ref
          .watch(competencyDefinitionRegistryProvider)
          .lookup(
            moduleId: request.moduleId,
            competencyId: request.competencyId,
          );
    });

final competencySessionControllerProvider =
    Provider.family<CompetencySessionController?, CompetencyRouteRequest>((
      ref,
      request,
    ) {
      final definition = ref.watch(
        runtimeCompetencyDefinitionProvider(request),
      );
      if (definition == null) {
        return null;
      }
      final registry = ref.watch(competencyDefinitionRegistryProvider);
      return CompetencySessionController(
        catalog: registry.catalogFor(definition),
        repository: ref.watch(competencyAttemptRepositoryProvider),
      );
    });

final competencyTemplatesProvider =
    FutureProvider.family<CompetencyTemplateBundle, CompetencyRouteRequest>((
      ref,
      request,
    ) async {
      final definition = ref.watch(
        runtimeCompetencyDefinitionProvider(request),
      );
      if (definition == null) {
        throw StateError('Competency definition not found.');
      }

      final repository = ref.watch(contentRepositoryProvider);
      final templateIds = {
        ...definition.diagnosticTaskTemplateIds.values,
        ...definition.recoveryTemplateIds.values,
      };
      final templates = <String, ExerciseTemplate>{};
      for (final templateId in templateIds) {
        final content = await repository.loadContent(
          templateReference(templateId),
        );
        if (content is! ExerciseTemplateContent) {
          throw StateError('Template content not found for $templateId.');
        }
        ExerciseTemplate? template;
        for (final candidate in content.templates) {
          if (candidate.id == templateId) {
            template = candidate;
            break;
          }
        }
        if (template == null) {
          throw StateError('Template not found: $templateId.');
        }
        templates[templateId] = template;
      }

      return CompetencyTemplateBundle(
        definition: definition,
        templatesById: Map.unmodifiable(templates),
      );
    });

class ModuleCompetencyProjectionRequest {
  const ModuleCompetencyProjectionRequest({
    required this.moduleId,
    required this.moduleContentComplete,
    required this.checkpointComplete,
  });

  final String moduleId;
  final bool moduleContentComplete;
  final bool checkpointComplete;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ModuleCompetencyProjectionRequest &&
            other.moduleId == moduleId &&
            other.moduleContentComplete == moduleContentComplete &&
            other.checkpointComplete == checkpointComplete;
  }

  @override
  int get hashCode =>
      Object.hash(moduleId, moduleContentComplete, checkpointComplete);
}

class CompetencyRouteRequest {
  const CompetencyRouteRequest({
    required this.courseId,
    required this.moduleId,
    required this.competencyId,
    this.forceNewAttempt = false,
  });

  final String courseId;
  final String moduleId;
  final String competencyId;
  final bool forceNewAttempt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CompetencyRouteRequest &&
            other.courseId == courseId &&
            other.moduleId == moduleId &&
            other.competencyId == competencyId &&
            other.forceNewAttempt == forceNewAttempt;
  }

  @override
  int get hashCode =>
      Object.hash(courseId, moduleId, competencyId, forceNewAttempt);
}

class CompetencyTemplateBundle {
  const CompetencyTemplateBundle({
    required this.definition,
    required this.templatesById,
  });

  final RuntimeCompetencyDefinition definition;
  final Map<String, ExerciseTemplate> templatesById;
}
