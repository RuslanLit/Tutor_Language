import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/app/app.dart';
import 'package:tutor_language/core/content/content_providers.dart';
import 'package:tutor_language/core/content/content_repository.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/database/database_provider.dart';
import 'package:tutor_language/core/learner/learner_progress.dart';
import 'package:tutor_language/core/learner/learner_progress_providers.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';

void main() {
  testWidgets('Home displays loaded Modules', (tester) async {
    await tester.pumpWidget(_testApp(_FakeContentRepository()));
    await tester.pumpAndSettle();

    expect(find.text('First Contacts'), findsOneWidget);
  });

  testWidgets('Expanding Module displays Lessons', (tester) async {
    await tester.pumpWidget(_testApp(_FakeContentRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('First Contacts'));
    await tester.pumpAndSettle();

    expect(find.text('Greetings'), findsOneWidget);
    expect(find.text('1 activities'), findsOneWidget);
  });

  testWidgets('Lesson list displays viewed status', (tester) async {
    await tester.pumpWidget(
      _testApp(
        _FakeContentRepository(),
        topicProgress: TopicProgress(
          topicId: _topic.id,
          viewedAt: DateTime.utc(2026),
          lastActivityAt: DateTime.utc(2026),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('First Contacts'));
    await tester.pumpAndSettle();

    expect(find.text('Viewed'), findsOneWidget);
  });

  testWidgets('Lesson list displays completed status', (tester) async {
    await tester.pumpWidget(
      _testApp(
        _FakeContentRepository(),
        topicProgress: TopicProgress(
          topicId: _topic.id,
          viewedAt: DateTime.utc(2026),
          lastActivityAt: DateTime.utc(2026),
          completedAt: DateTime.utc(2026),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('First Contacts'));
    await tester.pumpAndSettle();

    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Viewed'), findsNothing);
  });

  testWidgets('Opening Lesson shows activities', (tester) async {
    await tester.pumpWidget(_testApp(_FakeContentRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('First Contacts'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Greetings'));
    await tester.pumpAndSettle();

    expect(find.text('Greeting Words'), findsOneWidget);
    expect(find.text('vocabulary'), findsOneWidget);
    expect(find.text('hola - hello'), findsOneWidget);
  });

  testWidgets('Missing asset displays error widget', (tester) async {
    await tester.pumpWidget(_testApp(_FailingContentRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('First Contacts'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Greetings'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Unable to load course content.'),
      findsOneWidget,
    );
  });
}

ProviderScope _testApp(
  ContentRepository repository, {
  TopicProgress? topicProgress,
}) {
  return ProviderScope(
    overrides: [
      contentRepositoryProvider.overrideWith((ref) => repository),
      appDatabaseProvider.overrideWith((ref) {
        final database = AppDatabase(NativeDatabase.memory());
        ref.onDispose(database.close);
        return database;
      }),
      if (topicProgress != null)
        topicProgressProvider.overrideWith((ref, topicId) async {
          return topicProgress;
        }),
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

  @override
  Future<LessonDetails> loadLessonDetails(String topicId) async {
    return LessonDetails(
      lesson: _topic,
      activities: [
        LessonActivityContentDetails(
          activity: _activity,
          contentReference: _contentReference,
          content: const VocabularyContent(
            assetPath: 'assets/languages/spanish/vocabulary/greetings.json',
            entries: [
              VocabularyEntry(
                id: 'vocab.hola.v1',
                spanish: 'hola',
                nativeTranslation: 'hello',
                cefr: 'A0',
                example: 'Hola.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FailingContentRepository extends _FakeContentRepository {
  @override
  Future<LessonDetails> loadLessonDetails(String topicId) async {
    throw StateError('Missing asset');
  }
}

const _contentReference = LessonContentReference(
  type: 'vocabulary',
  assetPath: 'assets/languages/spanish/vocabulary/greetings.json',
);

const _activity = LessonActivity(
  id: 'activity_001',
  title: 'Greeting Words',
  type: 'vocabulary',
  contentReferences: [_contentReference],
);

const _topic = Lesson(
  id: 'lesson_001',
  moduleId: 'module_001',
  title: 'Greetings',
  primaryObjective: LessonObjective(
    id: 'objective.greetings',
    description: 'Recognize greetings.',
  ),
  activities: [_activity],
  prerequisites: [],
  estimatedDurationMinutes: 10,
  completionCriteria: LessonCompletionCriteria(
    type: 'checked_answers',
    minimumCheckedAnswers: 1,
    requiresAllCheckedAnswersCorrect: true,
  ),
);

const _course = Course(
  id: 'spanish_a1',
  languageId: 'spanish',
  title: 'Beginner Spanish',
  level: 'A1',
  version: '1.0.0',
  modules: [
    Module(
      id: 'module_001',
      title: 'First Contacts',
      lessonIds: ['lesson_001'],
    ),
  ],
  lessons: [_topic],
);
