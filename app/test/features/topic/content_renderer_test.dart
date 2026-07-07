import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_providers.dart';
import 'package:tutor_language/core/content/content_repository.dart';
import 'package:tutor_language/core/content/course.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/database/database_provider.dart';
import 'package:tutor_language/core/learner/learner_progress_repository.dart';
import 'package:tutor_language/features/topic/rendering/dialogue_content_renderer.dart';
import 'package:tutor_language/features/topic/rendering/exercise_template_content_renderer.dart';
import 'package:tutor_language/features/topic/rendering/grammar_content_renderer.dart';
import 'package:tutor_language/features/topic/rendering/reading_content_renderer.dart';
import 'package:tutor_language/features/topic/rendering/topic_content_renderer.dart';
import 'package:tutor_language/features/topic/rendering/topic_content_renderer_registry.dart';
import 'package:tutor_language/features/topic/rendering/unsupported_content_renderer.dart';
import 'package:tutor_language/features/topic/rendering/vocabulary_content_renderer.dart';
import 'package:tutor_language/features/topic/topic_screen.dart';
import 'package:tutor_language/features/learning_session/learning_session_controller.dart';
import 'package:tutor_language/features/learning_session/learning_session_providers.dart';

void main() {
  testWidgets('Vocabulary renderer displays term and translation', (
    tester,
  ) async {
    await tester.pumpWidget(
      _renderWithContext(
        (context) => const VocabularyContentRenderer().build(
          context,
          _vocabularyContent,
        ),
      ),
    );

    expect(find.text('hola - hello'), findsOneWidget);
  });

  testWidgets('Grammar renderer displays title and explanation', (
    tester,
  ) async {
    await tester.pumpWidget(
      _renderWithContext(
        (context) =>
            const GrammarContentRenderer().build(context, _grammarContent),
      ),
    );

    expect(find.text('Using llamarse'), findsOneWidget);
    expect(find.text('Use llamarse to say your name.'), findsOneWidget);
  });

  testWidgets('Dialogue renderer displays speaker and text', (tester) async {
    await tester.pumpWidget(
      _renderWithContext(
        (context) =>
            const DialogueContentRenderer().build(context, _dialogueContent),
      ),
    );

    expect(find.text('Ana: Hola.'), findsOneWidget);
  });

  testWidgets('Reading renderer displays title and paragraph', (tester) async {
    await tester.pumpWidget(
      _renderWithContext(
        (context) =>
            const ReadingContentRenderer().build(context, _readingContent),
      ),
    );

    expect(find.text('A Greeting'), findsOneWidget);
    expect(find.text('Hola, me llamo Ana.'), findsOneWidget);
  });

  testWidgets('ExerciseTemplate renderer displays metadata only', (
    tester,
  ) async {
    await tester.pumpWidget(
      _renderWithContext(
        (context) => const ExerciseTemplateContentRenderer().build(
          context,
          _exerciseTemplateContent,
        ),
      ),
    );

    expect(find.text('template.multiple_choice_basic.v1'), findsOneWidget);
    expect(find.text('Type: multiple_choice'), findsOneWidget);
    expect(find.text('Prompt: Choose the correct answer.'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(TextFormField), findsNothing);
  });

  test('Renderer registry returns expected renderers for known types', () {
    final registry = TopicContentRendererRegistry.defaultRegistry();

    expect(
      registry.rendererFor(_vocabularyContent),
      isA<VocabularyContentRenderer>(),
    );
    expect(
      registry.rendererFor(_grammarContent),
      isA<GrammarContentRenderer>(),
    );
    expect(
      registry.rendererFor(_dialogueContent),
      isA<DialogueContentRenderer>(),
    );
    expect(
      registry.rendererFor(_readingContent),
      isA<ReadingContentRenderer>(),
    );
    expect(
      registry.rendererFor(_exerciseTemplateContent),
      isA<ExerciseTemplateContentRenderer>(),
    );
  });

  test('Renderer registry falls back for unknown content', () {
    final registry = TopicContentRendererRegistry.defaultRegistry();

    expect(
      registry.rendererFor(const _UnknownContent()),
      isA<UnsupportedContentRenderer>(),
    );
  });

  testWidgets('TopicScreen delegates rendering through registry', (
    tester,
  ) async {
    final registry = TopicContentRendererRegistry(
      renderers: const [_DelegatingRenderer()],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentRepositoryProvider.overrideWith(
            (ref) => _FakeContentRepository(),
          ),
          appDatabaseProvider.overrideWith((ref) {
            final database = AppDatabase(NativeDatabase.memory());
            ref.onDispose(database.close);
            return database;
          }),
          topicContentRendererRegistryProvider.overrideWith((ref) => registry),
        ],
        child: const MaterialApp(
          home: TopicScreen(topicId: 'topic.greetings.v1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Greeting Words'), findsOneWidget);
    expect(find.text('delegated renderer'), findsOneWidget);
  });

  testWidgets('TopicScreen starts session', (tester) async {
    late AppDatabase database;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentRepositoryProvider.overrideWith(
            (ref) => _FakeContentRepository(),
          ),
          appDatabaseProvider.overrideWith((ref) {
            database = AppDatabase(NativeDatabase.memory());
            ref.onDispose(database.close);
            return database;
          }),
        ],
        child: const MaterialApp(
          home: TopicScreen(topicId: 'topic.greetings.v1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final repository = LearnerProgressRepository(database);
    final events = await repository.readEventsForTopic('topic.greetings.v1');

    expect(events.single.eventType.name, 'topicViewed');
  });

  testWidgets('TopicScreen disposes session', (tester) async {
    late _RecordingLearningSessionController controller;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentRepositoryProvider.overrideWith(
            (ref) => _FakeContentRepository(),
          ),
          learningSessionControllerProvider.overrideWith((ref, topicId) {
            final database = AppDatabase(NativeDatabase.memory());
            ref.onDispose(database.close);
            controller = _RecordingLearningSessionController(
              progressRepository: LearnerProgressRepository(database),
            );
            return controller;
          }),
        ],
        child: const MaterialApp(
          home: TopicScreen(topicId: 'topic.greetings.v1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();

    expect(controller.finishCount, 1);
  });
}

Widget _renderWithContext(Widget Function(BuildContext context) builder) {
  return MaterialApp(
    home: Scaffold(body: Builder(builder: builder)),
  );
}

class _DelegatingRenderer extends TopicContentRenderer<TopicContent> {
  const _DelegatingRenderer();

  @override
  bool canRender(TopicContent content) => true;

  @override
  Widget build(
    BuildContext context,
    TopicContent content, {
    TopicContentRenderContext? renderContext,
  }) {
    return const Text('delegated renderer');
  }
}

class _UnknownContent extends TopicContent {
  const _UnknownContent()
    : super(type: 'unknown', assetPath: 'assets/spanish/unknown.json');
}

class _RecordingLearningSessionController extends LearningSessionController {
  _RecordingLearningSessionController({required super.progressRepository});

  int finishCount = 0;

  @override
  Future<void> finishSession() {
    finishCount += 1;
    return super.finishSession();
  }
}

class _FakeContentRepository extends ContentRepository {
  @override
  Future<Language> loadCurrentLanguage() async {
    return const Language(code: 'es', name: 'Spanish');
  }

  @override
  Future<Course> loadCourse() async {
    return _course;
  }

  @override
  Future<TopicDetails> loadTopicDetails(String topicId) async {
    return TopicDetails(
      topic: _topic,
      sections: [
        TopicSectionDetails(section: _section, content: _vocabularyContent),
      ],
    );
  }
}

const _vocabularyContent = VocabularyContent(
  assetPath: 'assets/spanish/vocabulary/greetings.json',
  entries: [
    VocabularyEntry(
      id: 'vocab.hola.v1',
      spanish: 'hola',
      nativeTranslation: 'hello',
      cefr: 'A0',
      topicIds: ['topic.greetings.v1'],
      example: 'Hola.',
      notes: 'Common greeting.',
    ),
  ],
);

const _grammarContent = GrammarContent(
  assetPath: 'assets/spanish/grammar/llamarse_basic.json',
  rules: [
    GrammarRule(
      id: 'grammar.llamarse_basic.v1',
      title: 'Using llamarse',
      explanation: 'Use llamarse to say your name.',
      examples: ['Me llamo Ana.'],
      prerequisiteIds: [],
      topicIds: ['topic.greetings.v1'],
    ),
  ],
);

const _dialogueContent = DialogueContent(
  assetPath: 'assets/spanish/dialogues/greetings.json',
  dialogues: [
    Dialogue(
      id: 'dialogue.greetings.v1',
      title: 'Greeting Dialogue',
      topicIds: ['topic.greetings.v1'],
      vocabularyIds: ['vocab.hola.v1'],
      grammarIds: [],
      lines: [
        DialogueLine(
          speaker: 'Ana',
          spanish: 'Hola.',
          nativeTranslation: 'Hello.',
        ),
      ],
    ),
  ],
);

const _readingContent = ReadingContent(
  assetPath: 'assets/spanish/readings/basic_greeting.json',
  readings: [
    Reading(
      id: 'reading.basic_greeting.v1',
      title: 'A Greeting',
      topicIds: ['topic.greetings.v1'],
      vocabularyIds: ['vocab.hola.v1'],
      grammarIds: [],
      text: 'Hola, me llamo Ana.',
      nativeTranslation: 'Hello, my name is Ana.',
    ),
  ],
);

const _exerciseTemplateContent = ExerciseTemplateContent(
  assetPath: 'assets/spanish/templates/multiple_choice_basic.json',
  templates: [
    ExerciseTemplate(
      id: 'template.multiple_choice_basic.v1',
      exerciseType: 'multiple_choice',
      supportedGoalTypes: ['introduce_vocabulary'],
      requiredObjectTypes: ['vocabulary'],
      promptTemplate: 'Choose the correct answer.',
    ),
  ],
);

const _section = TopicSection(
  id: 'section.greeting_words.v1',
  title: 'Greeting Words',
  contentReference: ContentReference(
    type: 'vocabulary',
    assetPath: 'assets/spanish/vocabulary/greetings.json',
  ),
);

const _topic = Topic(
  id: 'topic.greetings.v1',
  title: 'Greetings',
  sections: [_section],
);

const _course = Course(
  id: 'course.spanish_beginner.v1',
  languageCode: 'es',
  title: 'Beginner Spanish',
  units: [
    Unit(
      id: 'unit.first_contacts.v1',
      title: 'First Contacts',
      topics: [_topic],
    ),
  ],
);
