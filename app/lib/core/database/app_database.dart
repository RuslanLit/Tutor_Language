import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('LearnerStateRow')
class LearnerStates extends Table {
  TextColumn get id => text()();
  TextColumn get selectedLanguage => text()();
  TextColumn get currentCourseId => text()();
  TextColumn get currentTopicId => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LearnerProgressEventRow')
class LearnerProgressEvents extends Table {
  TextColumn get id => text()();
  TextColumn get eventType => text()();
  TextColumn get topicId => text()();
  TextColumn get sectionId => text().nullable()();
  TextColumn get contentReference => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get metadataJson => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LessonAttemptRow')
class LessonAttempts extends Table {
  TextColumn get attemptId => text()();
  TextColumn get lessonId => text()();
  TextColumn get courseId => text()();
  TextColumn get attemptPurpose =>
      text().withDefault(const Constant('normal'))();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get outcomeStatus => text()();
  TextColumn get outcomeReasonCode => text()();
  IntColumn get assessedStepCount => integer()();
  IntColumn get masteredStepCount => integer()();
  IntColumn get fragileStepCount => integer()();
  IntColumn get notMasteredStepCount => integer()();
  IntColumn get unassessedStepCount => integer()();
  IntColumn get canonicalCheckableStepCount => integer()();
  IntColumn get totalSubmissionCount => integer()();
  TextColumn get learningPolicyVersion => text()();

  @override
  Set<Column<Object>> get primaryKey => {attemptId};
}

@DataClassName('LessonAttemptStepResultRow')
class LessonAttemptStepResults extends Table {
  TextColumn get attemptId => text().references(
    LessonAttempts,
    #attemptId,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get lessonId => text()();
  TextColumn get stepId => text()();
  TextColumn get masteryStatus => text()();
  TextColumn get masteryReasonCode => text()();
  IntColumn get attemptCount => integer()();
  IntColumn get successfulSubmissionCount => integer()();
  TextColumn get latestEvaluationOutcome => text()();
  BoolColumn get remediationWasRequired => boolean()();
  BoolColumn get reviewWasRequired => boolean()();
  BoolColumn get confirmationSucceeded => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {attemptId, stepId};
}

@DataClassName('CompetencyAttemptRow')
class CompetencyAttempts extends Table {
  TextColumn get attemptId => text()();
  TextColumn get competencyId => text()();
  TextColumn get moduleId => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get status => text()();
  TextColumn get finalOutcome => text().nullable()();
  TextColumn get definitionFingerprint => text()();

  @override
  Set<Column<Object>> get primaryKey => {attemptId};
}

@DataClassName('CompetencyTaskResultRow')
class CompetencyTaskResults extends Table {
  TextColumn get resultId => text()();
  TextColumn get attemptId => text().references(
    CompetencyAttempts,
    #attemptId,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get assessmentTaskId => text()();
  TextColumn get microCompetencyIdsJson => text()();
  IntColumn get attemptSequence => integer()();
  TextColumn get phase => text()();
  TextColumn get activityResultStatus => text()();
  TextColumn get reasonCode => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {resultId};
}

@DataClassName('CompetencyGapRow')
class CompetencyGaps extends Table {
  TextColumn get gapId => text()();
  TextColumn get attemptId => text().references(
    CompetencyAttempts,
    #attemptId,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get assessmentTaskId => text()();
  TextColumn get microCompetencyId => text()();
  TextColumn get reasonCode => text()();
  TextColumn get sourceModuleId => text()();
  TextColumn get sourceLessonId => text()();
  TextColumn get sourceStepId => text()();
  DateTimeColumn get detectedAt => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
  TextColumn get resolutionStatus => text()();

  @override
  Set<Column<Object>> get primaryKey => {attemptId, gapId};
}

@DataClassName('CompetencyRecoveryExecutionRow')
class CompetencyRecoveryExecutions extends Table {
  TextColumn get recoveryExecutionId => text()();
  TextColumn get attemptId => text().references(
    CompetencyAttempts,
    #attemptId,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get gapId => text()();
  TextColumn get recoveryStepId => text()();
  TextColumn get sourceModuleId => text()();
  TextColumn get sourceLessonId => text()();
  TextColumn get sourceStepId => text()();
  TextColumn get status => text()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  BoolColumn get succeeded => boolean().nullable()();
  BoolColumn get retryOccurred =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {recoveryExecutionId};
}

@DriftDatabase(
  tables: [
    LearnerStates,
    LearnerProgressEvents,
    LessonAttempts,
    LessonAttemptStepResults,
    CompetencyAttempts,
    CompetencyTaskResults,
    CompetencyGaps,
    CompetencyRecoveryExecutions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'tutor_language'));

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onCreate: (migrator) async {
        await migrator.createAll();
      },
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await migrator.createTable(learnerStates);
        }
        if (from == 2) {
          await customStatement(
            'ALTER TABLE learner_states '
            'RENAME COLUMN current_lesson_id TO current_topic_id',
          );
        }
        if (from < 4) {
          await migrator.createTable(learnerProgressEvents);
        }
        if (from < 5) {
          await migrator.createTable(lessonAttempts);
          await migrator.createTable(lessonAttemptStepResults);
        }
        if (from >= 5 && from < 6) {
          await migrator.addColumn(
            lessonAttempts,
            lessonAttempts.attemptPurpose,
          );
        }
        if (from < 7) {
          await migrator.createTable(competencyAttempts);
          await migrator.createTable(competencyTaskResults);
          await migrator.createTable(competencyGaps);
          await migrator.createTable(competencyRecoveryExecutions);
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_competency_attempts_competency '
            'ON competency_attempts (competency_id, status)',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_competency_task_results_attempt '
            'ON competency_task_results (attempt_id, assessment_task_id)',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_competency_gaps_attempt '
            'ON competency_gaps (attempt_id, resolution_status)',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_competency_recovery_attempt '
            'ON competency_recovery_executions (attempt_id, gap_id)',
          );
        }
      },
    );
  }
}
