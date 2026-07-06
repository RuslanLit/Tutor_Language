import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/learner/learner_state.dart';
import 'package:tutor_language/core/learner/learner_state_repository.dart';

void main() {
  late AppDatabase database;
  late LearnerStateRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = LearnerStateRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('reads null before learner state is saved', () async {
    final state = await repository.readState();

    expect(state, isNull);
  });

  test('saves and reads learner state', () async {
    final now = DateTime.utc(2026, 7, 6);
    final state = LearnerState.initial(
      currentCourseId: 'spanish_a1',
      currentTopicId: 'topic_001',
      now: now,
    );

    await repository.saveState(state);
    final savedState = await repository.readState();

    expect(savedState, isNotNull);
    expect(savedState!.selectedLanguage, 'spanish');
    expect(savedState.currentCourseId, 'spanish_a1');
    expect(savedState.currentTopicId, 'topic_001');
    expect(savedState.createdAt.isAtSameMomentAs(now), isTrue);
    expect(savedState.updatedAt.isAtSameMomentAs(now), isTrue);
  });
}
