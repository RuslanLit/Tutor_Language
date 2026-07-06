import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/learner/learner_state_repository.dart';

void main() {
  test('migrates learner state from schema version 2 to 3', () async {
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

    expect(state, isNotNull);
    expect(state!.selectedLanguage, 'spanish');
    expect(state.currentCourseId, 'spanish_a1');
    expect(state.currentTopicId, 'topic_001');
    expect(versionRow.read<int>('user_version'), 3);
    expect(oldColumnRows, isEmpty);
  });
}
