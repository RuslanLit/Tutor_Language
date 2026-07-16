import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/app/app.dart';
import 'package:tutor_language/core/content/content_localization.dart';
import 'package:tutor_language/core/content/content_localization_providers.dart';
import 'package:tutor_language/core/content/content_providers.dart';
import 'package:tutor_language/core/content/content_repository.dart';
import 'package:tutor_language/core/content/semantic_localization.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/database/database_provider.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Home displays course entry point', (tester) async {
    await tester.pumpWidget(_testApp(_FakeContentRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Spanish'), findsOneWidget);
    expect(find.text('Beginner Spanish'), findsOneWidget);
    expect(find.text('Open course'), findsOneWidget);
  });
}

ProviderScope _testApp(ContentRepository repository) {
  return ProviderScope(
    overrides: [
      _emptyLocalizationOverride,
      _emptySemanticLocalizationOverride,
      contentRepositoryProvider.overrideWith((ref) => repository),
      appDatabaseProvider.overrideWith((ref) {
        final database = AppDatabase(NativeDatabase.memory());
        ref.onDispose(database.close);
        return database;
      }),
    ],
    child: const TutorLanguageApp(),
  );
}

final _emptyLocalizationOverride = educationalContentLocalizationBundleProvider
    .overrideWith((ref) async => _emptyLocalizationBundle);

final _emptySemanticLocalizationOverride = semanticLocalizationBundleProvider
    .overrideWith((ref) async => _emptySemanticLocalizationBundle);

const _emptyLocalizationBundle = EducationalContentLocalizationBundle(
  schemaVersion: 1,
  targetLanguage: 'es',
  sourceSupportLocale: 'en',
  supportLocales: ['en'],
  entries: [],
);

const _emptySemanticLocalizationBundle = SemanticLocalizationBundle(
  schemaVersion: 1,
  targetLanguage: 'es',
  sourceSupportLocale: 'en',
  supportLocales: ['uk'],
  units: [],
);

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

const _topic = Lesson(
  id: 'lesson_001',
  moduleId: 'module_001',
  title: 'Greetings',
  primaryObjective: LessonObjective(
    id: 'objective.greetings',
    description: 'Recognize greetings.',
  ),
  activities: [],
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
