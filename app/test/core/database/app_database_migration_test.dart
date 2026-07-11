import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/learner/learner_state_repository.dart';

void main() {
  test('migrates learner state from schema version 2 to 6', () async {
    final executor = NativeDatabase.memory(
      setup: (database) {
        database
          ..execute('''
            CREATE TABLE learner_states (
              id TEXT NOT NULL PRIMARY KEY,
              selected_language TEXT NOT NULL,
              current_course_id TEXT NOT NULL,
              current_lesson_id TEXT NOT NULL,
              created_at INTEGER NOT NULL,
              updated_at INTEGER NOT NULL
            );
          ''')
          ..execute('''
            INSERT INTO learner_states (
              id,
              selected_language,
              current_course_id,
              current_lesson_id,
              created_at,
              updated_at
            ) VALUES (
              'default',
              'spanish',
              'spanish_a1',
              'topic_001',
              1783296000000,
              1783296000000
            );
          ''')
          ..execute('PRAGMA user_version = 2');
      },
    );
    final database = AppDatabase(executor);
    final repository = LearnerStateRepository(database);

    addTearDown(database.close);

    final state = await repository.readState();
    final versionRow = await database
        .customSelect('PRAGMA user_version')
        .getSingle();
    final oldColumnRows = await database.customSelect('''
      SELECT name
      FROM pragma_table_info('learner_states')
      WHERE name = 'current_lesson_id'
    ''').get();
    final progressEventTableRows = await database.customSelect('''
      SELECT name
      FROM sqlite_master
      WHERE type = 'table'
        AND name = 'learner_progress_events'
    ''').get();

    expect(state, isNotNull);
    expect(state!.selectedLanguage, 'spanish');
    expect(state.currentCourseId, 'spanish_a1');
    expect(state.currentTopicId, 'topic_001');
    expect(versionRow.read<int>('user_version'), 6);
    expect(oldColumnRows, isEmpty);
    expect(progressEventTableRows, hasLength(1));
    expect(await _tableExists(database, 'lesson_attempts'), isTrue);
    expect(await _tableExists(database, 'lesson_attempt_step_results'), isTrue);
  });

  test('migrates durable attempts from schema version 5 to 6', () async {
    final executor = NativeDatabase.memory(
      setup: (database) {
        database
          ..execute('''
            CREATE TABLE learner_progress_events (
              id TEXT NOT NULL PRIMARY KEY,
              event_type TEXT NOT NULL,
              topic_id TEXT NOT NULL,
              section_id TEXT NULL,
              content_reference TEXT NULL,
              created_at INTEGER NOT NULL,
              metadata_json TEXT NULL
            );
          ''')
          ..execute('''
            CREATE TABLE lesson_attempts (
              attempt_id TEXT NOT NULL PRIMARY KEY,
              lesson_id TEXT NOT NULL,
              course_id TEXT NOT NULL,
              started_at INTEGER NULL,
              completed_at INTEGER NOT NULL,
              outcome_status TEXT NOT NULL,
              outcome_reason_code TEXT NOT NULL,
              assessed_step_count INTEGER NOT NULL,
              mastered_step_count INTEGER NOT NULL,
              fragile_step_count INTEGER NOT NULL,
              not_mastered_step_count INTEGER NOT NULL,
              unassessed_step_count INTEGER NOT NULL,
              canonical_checkable_step_count INTEGER NOT NULL,
              total_submission_count INTEGER NOT NULL,
              learning_policy_version TEXT NOT NULL
            );
          ''')
          ..execute('''
            CREATE TABLE lesson_attempt_step_results (
              attempt_id TEXT NOT NULL REFERENCES lesson_attempts(attempt_id) ON DELETE CASCADE,
              lesson_id TEXT NOT NULL,
              step_id TEXT NOT NULL,
              mastery_status TEXT NOT NULL,
              mastery_reason_code TEXT NOT NULL,
              attempt_count INTEGER NOT NULL,
              successful_submission_count INTEGER NOT NULL,
              latest_evaluation_outcome TEXT NOT NULL,
              remediation_was_required INTEGER NOT NULL,
              review_was_required INTEGER NOT NULL,
              confirmation_succeeded INTEGER NOT NULL,
              PRIMARY KEY (attempt_id, step_id)
            );
          ''')
          ..execute('''
            INSERT INTO lesson_attempts (
              attempt_id,
              lesson_id,
              course_id,
              completed_at,
              outcome_status,
              outcome_reason_code,
              assessed_step_count,
              mastered_step_count,
              fragile_step_count,
              not_mastered_step_count,
              unassessed_step_count,
              canonical_checkable_step_count,
              total_submission_count,
              learning_policy_version
            ) VALUES (
              'attempt.v5',
              'lesson.v5',
              'course.test',
              1783728000000,
              'mastered',
              'all_steps_mastered',
              1,
              1,
              0,
              0,
              0,
              1,
              1,
              'e20-v1'
            );
          ''')
          ..execute('''
            INSERT INTO lesson_attempt_step_results (
              attempt_id,
              lesson_id,
              step_id,
              mastery_status,
              mastery_reason_code,
              attempt_count,
              successful_submission_count,
              latest_evaluation_outcome,
              remediation_was_required,
              review_was_required,
              confirmation_succeeded
            ) VALUES (
              'attempt.v5',
              'lesson.v5',
              'step.practice',
              'mastered',
              'first_attempt_correct',
              1,
              1,
              'correct',
              0,
              0,
              0
            );
          ''')
          ..execute('PRAGMA user_version = 5');
      },
    );
    final database = AppDatabase(executor);
    addTearDown(database.close);

    await database.customSelect('SELECT 1').get();

    final versionRow = await database
        .customSelect('PRAGMA user_version')
        .getSingle();
    final purposeRows = await database.customSelect('''
      SELECT attempt_purpose
      FROM lesson_attempts
      WHERE attempt_id = 'attempt.v5'
    ''').get();
    final stepRows = await database.customSelect('''
      SELECT step_id
      FROM lesson_attempt_step_results
      WHERE attempt_id = 'attempt.v5'
    ''').get();

    expect(versionRow.read<int>('user_version'), 6);
    expect(purposeRows.single.read<String>('attempt_purpose'), 'normal');
    expect(stepRows.single.read<String>('step_id'), 'step.practice');
  });

  test('progress schema does not contain scoring or review fields', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await database.customSelect('SELECT 1').get();

    final columns = await database.customSelect('''
      SELECT name
      FROM pragma_table_info('learner_progress_events')
    ''').get();
    final columnNames = columns.map((row) => row.read<String>('name')).toSet();

    expect(columnNames, contains('event_type'));
    expect(columnNames, contains('topic_id'));
    expect(columnNames, isNot(contains('score')));
    expect(columnNames, isNot(contains('mastery')));
    expect(columnNames, isNot(contains('review_due_at')));
    expect(columnNames, isNot(contains('due_at')));
  });

  test('fresh database contains durable lesson attempt tables', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await database.customSelect('SELECT 1').get();

    expect(await _tableExists(database, 'lesson_attempts'), isTrue);
    expect(await _tableExists(database, 'lesson_attempt_step_results'), isTrue);
    final columns = await database.customSelect('''
      SELECT name, "notnull", dflt_value
      FROM pragma_table_info('lesson_attempts')
      WHERE name = 'attempt_purpose'
    ''').get();

    expect(columns, hasLength(1));
    expect(columns.single.read<int>('notnull'), 1);
    expect(columns.single.read<String>('dflt_value'), "'normal'");
  });
}

Future<bool> _tableExists(AppDatabase database, String tableName) async {
  final rows = await database
      .customSelect(
        '''
      SELECT name
      FROM sqlite_master
      WHERE type = 'table'
        AND name = ?
    ''',
        variables: [Variable.withString(tableName)],
      )
      .get();

  return rows.isNotEmpty;
}
