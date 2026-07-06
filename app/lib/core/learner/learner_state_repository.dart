import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'learner_state.dart';

class LearnerStateRepository {
  LearnerStateRepository(this._database);

  static const _stateId = 'default';

  final AppDatabase _database;

  Future<LearnerState?> readState() async {
    final row = await (_database.select(
      _database.learnerStates,
    )..where((table) => table.id.equals(_stateId))).getSingleOrNull();

    if (row == null) {
      return null;
    }

    return LearnerState(
      selectedLanguage: row.selectedLanguage,
      currentCourseId: row.currentCourseId,
      currentTopicId: row.currentTopicId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<void> saveState(LearnerState state) async {
    await _database
        .into(_database.learnerStates)
        .insertOnConflictUpdate(
          LearnerStatesCompanion(
            id: const Value(_stateId),
            selectedLanguage: Value(state.selectedLanguage),
            currentCourseId: Value(state.currentCourseId),
            currentTopicId: Value(state.currentTopicId),
            createdAt: Value(state.createdAt),
            updatedAt: Value(state.updatedAt),
          ),
        );
  }
}
