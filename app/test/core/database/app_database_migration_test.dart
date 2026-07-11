import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/learner/learner_state_repository.dart';

void main() {
  test('migrates learner state from schema version 2 to 5', () async {
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
    expect(versionRow.read<int>('user_version'), 5);
    expect(oldColumnRows, isEmpty);
    expect(progressEventTableRows, hasLength(1));
    expect(await _tableExists(database, 'lesson_attempts'), isTrue);
    expect(await _tableExists(database, 'lesson_attempt_step_results'), isTrue);
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
