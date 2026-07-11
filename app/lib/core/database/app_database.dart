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

@DriftDatabase(
  tables: [
    LearnerStates,
    LearnerProgressEvents,
    LessonAttempts,
    LessonAttemptStepResults,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'tutor_language'));

  @override
  int get schemaVersion => 5;

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
      },
    );
  }
}
