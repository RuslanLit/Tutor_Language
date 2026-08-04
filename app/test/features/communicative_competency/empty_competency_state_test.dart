import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/database/database_provider.dart';
import 'package:tutor_language/features/communicative_competency/competency_attempt.dart';
import 'package:tutor_language/features/communicative_competency/competency_attempt_repository.dart';
import 'package:tutor_language/features/communicative_competency/competency_definition_registry.dart';
import 'package:tutor_language/features/communicative_competency/competency_providers.dart';
import 'package:tutor_language/features/communicative_competency/competency_session_screen.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

void main() {
  test('default registry has no canonical Module 1 competency', () {
    const registry = CompetencyDefinitionRegistry();

    expect(registry.definitions, isEmpty);
    expect(registry.definitionsForModule('es.a0.m01'), isEmpty);
    expect(
      registry.lookup(
        moduleId: 'es.a0.m01',
        competencyId: 'competency.es.a0.m01.missing',
      ),
      isNull,
    );
  });

  test('orphaned stored attempts do not create a current competency', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = CompetencyAttemptRepository(database);

    await repository.startCompetencyAttempt(
      StartCompetencyAttemptCommand(
        attempt: DurableCompetencyAttempt(
          attemptId: 'old-attempt',
          competencyId: 'competency.es.a0.m03.legacy',
          moduleId: 'es.a0.m03',
          startedAt: DateTime.utc(2026),
          status: CompetencyAttemptStatus.inProgress,
          definitionFingerprint: 'legacy',
        ),
      ),
    );

    expect(
      await repository.loadActiveCompetencyAttempt(
        'competency.es.a0.m03.legacy',
      ),
      isNotNull,
    );

    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);

    final projections = await container.read(
      moduleCompetencyProjectionsProvider(
        const ModuleCompetencyProjectionRequest(
          moduleId: 'es.a0.m01',
          moduleContentComplete: true,
          checkpointComplete: true,
        ),
      ).future,
    );

    expect(projections, isEmpty);
  });

  testWidgets('missing canonical competency route shows a controlled error', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CompetencySessionScreen(
            courseId: 'es.a0',
            moduleId: 'es.a0.m01',
            competencyId: 'competency.es.a0.m01.missing',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Competency check not found.'), findsOneWidget);
  });
}
