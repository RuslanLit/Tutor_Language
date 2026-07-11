import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/app/app.dart';
import 'package:tutor_language/core/content/content_providers.dart';
import 'package:tutor_language/core/content/content_repository.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/database/database_provider.dart';
import 'package:tutor_language/core/learner/lesson_attempt.dart';
import 'package:tutor_language/core/learner/learner_progress.dart';
import 'package:tutor_language/core/learner/learner_progress_repository.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_assembly_service.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_content.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_providers.dart';

void main() {
  testWidgets('course screen renders units and lessons in order', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(_app(database));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open course'));
    await tester.pumpAndSettle();

    expect(find.text('Spanish A0'), findsOneWidget);
    expect(find.text('Unit 1'), findsOneWidget);
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);
    expect(find.text('Unit 2'), findsOneWidget);
    expect(find.text('Gamma'), findsOneWidget);
    expect(find.text('Available next'), findsOneWidget);
    expect(find.text('Locked'), findsNWidgets(2));
  });

  testWidgets('completed lesson displays completed state and unlocks next', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await LearnerProgressRepository(database).recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.lessonCompleted,
        topicId: 'lesson.alpha',
        now: DateTime.utc(2026),
      ),
    );

    await tester.pumpWidget(_app(database));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open course'));
    await tester.pumpAndSettle();

    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Available next'), findsOneWidget);
    expect(find.text('Locked'), findsOneWidget);
  });

  testWidgets('available lesson opens through existing lesson route', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final assemblyService = _RecordingLessonAssemblyService();

    await tester.pumpWidget(_app(database, assemblyService: assemblyService));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open course'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();

    expect(assemblyService.requestedLessonIds, ['lesson.alpha']);
    expect(find.text('Alpha'), findsOneWidget);
  });

  testWidgets('locked lesson is visible but not launchable', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final assemblyService = _RecordingLessonAssemblyService();

    await tester.pumpWidget(_app(database, assemblyService: assemblyService));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open course'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beta'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(assemblyService.requestedLessonIds, isEmpty);
    expect(find.text('Spanish A0'), findsOneWidget);
  });

  testWidgets('final course state is displayed', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LearnerProgressRepository(database);
    for (final lessonId in ['lesson.alpha', 'lesson.beta', 'lesson.gamma']) {
      await repository.recordEvent(
        ProgressEvent.create(
          eventType: ProgressEventType.lessonCompleted,
          topicId: lessonId,
          now: DateTime.utc(2026),
        ),
      );
    }

    await tester.pumpWidget(_app(database));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open course'));
    await tester.pumpAndSettle();

    expect(find.text('3 of 3 lessons completed'), findsOneWidget);
    expect(find.text('Course complete'), findsOneWidget);
  });

  testWidgets('completed lesson continues directly to next course lesson', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final assemblyService = _RecordingLessonAssemblyService();

    await tester.pumpWidget(_app(database, assemblyService: assemblyService));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open course'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Finish Lesson'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue to next lesson'));
    await tester.pumpAndSettle();

    expect(assemblyService.requestedLessonIds, ['lesson.alpha', 'lesson.beta']);
    expect(find.text('Beta'), findsOneWidget);

    final latest = await LearnerProgressRepository(
      database,
    ).getLatestLessonAttempt('lesson.alpha');
    expect(latest?.purpose, LessonAttemptPurpose.normal);
  });

  testWidgets('completed lesson tile launches a manual repeat', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LearnerProgressRepository(database);
    await repository.recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.lessonCompleted,
        topicId: 'lesson.alpha',
        now: DateTime.utc(2026),
      ),
    );

    await tester.pumpWidget(
      _app(database, assemblyService: _RecordingLessonAssemblyService()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open course'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();

    expect(find.text('Fake Vocabulary'), findsOneWidget);
    expect(find.text('Lesson completed'), findsNothing);

    await tester.tap(find.text('Finish Lesson'));
    await tester.pumpAndSettle();

    final latest = await repository.getLatestLessonAttempt('lesson.alpha');
    expect(latest?.purpose, LessonAttemptPurpose.manualRepeat);
  });
}

ProviderScope _app(
  AppDatabase database, {
  LessonAssemblyService? assemblyService,
}) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWith((ref) => database),
      contentRepositoryProvider.overrideWith((ref) => _FakeContentRepository()),
      if (assemblyService != null)
        lessonAssemblyServiceProvider.overrideWith((ref) => assemblyService),
    ],
    child: const TutorLanguageApp(),
  );
}

class _FakeContentRepository extends ContentRepository {
  @override
  Future<LanguagePackDisplay> loadCurrentLanguage() async {
    return const LanguagePackDisplay(id: 'spanish', name: 'Spanish');
  }

  @override
  Future<Course> loadCourse() async {
    return _course;
  }
}

class _RecordingLessonAssemblyService extends LessonAssemblyService {
  final requestedLessonIds = <String>[];

  @override
  Future<LessonContent> assembleLesson(String lessonId) async {
    requestedLessonIds.add(lessonId);
    final lesson = _course.lessons.singleWhere(
      (candidate) => candidate.id == lessonId,
    );

    const activity = LessonActivity(
      id: 'activity.fake.vocabulary',
      title: 'Fake Vocabulary',
      type: 'vocabulary',
      order: 1,
    );
    const section = LessonSection(
      id: 'section.fake',
      title: 'Fake Section',
      order: 1,
      activities: [activity],
    );

    return LessonContent(
      lesson: lesson,
      sections: const [
        LessonContentSection(
          section: section,
          activities: [
            LessonContentActivity(
              activity: activity,
              resolvedContent: [
                VocabularyItem(
                  id: 'vocab.fake',
                  spanish: 'hola',
                  nativeTranslation: 'hello',
                  cefr: 'A0',
                  example: 'Hola.',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

const _course = Course(
  id: 'course.test',
  languageId: 'spanish',
  title: 'Spanish A0',
  level: 'A0',
  version: '1.0.0',
  modules: [
    Module(
      id: 'unit.1',
      title: 'Unit 1',
      lessonIds: ['lesson.alpha', 'lesson.beta'],
    ),
    Module(id: 'unit.2', title: 'Unit 2', lessonIds: ['lesson.gamma']),
  ],
  lessons: [
    Lesson(
      id: 'lesson.alpha',
      moduleId: 'unit.1',
      title: 'Alpha',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
    Lesson(
      id: 'lesson.beta',
      moduleId: 'unit.1',
      title: 'Beta',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
    Lesson(
      id: 'lesson.gamma',
      moduleId: 'unit.2',
      title: 'Gamma',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
  ],
);
