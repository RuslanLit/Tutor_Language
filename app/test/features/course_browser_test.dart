import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/app/app.dart';
import 'package:tutor_language/core/content/content_providers.dart';
import 'package:tutor_language/core/content/content_repository.dart';
import 'package:tutor_language/core/content/course.dart';
import 'package:tutor_language/core/content/topic_content.dart';

void main() {
  testWidgets('Home displays loaded Units', (tester) async {
    await tester.pumpWidget(_testApp(_FakeContentRepository()));
    await tester.pumpAndSettle();

    expect(find.text('First Contacts'), findsOneWidget);
  });

  testWidgets('Expanding Unit displays Topics', (tester) async {
    await tester.pumpWidget(_testApp(_FakeContentRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('First Contacts'));
    await tester.pumpAndSettle();

    expect(find.text('Greetings'), findsOneWidget);
    expect(find.text('1 sections'), findsOneWidget);
  });

  testWidgets('Opening Topic shows TopicSections', (tester) async {
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

ProviderScope _testApp(ContentRepository repository) {
  return ProviderScope(
    overrides: [contentRepositoryProvider.overrideWith((ref) => repository)],
    child: const TutorLanguageApp(),
  );
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
        TopicSectionDetails(
          section: _section,
          content: const VocabularyContent(
            assetPath: 'assets/spanish/vocabulary/greetings.json',
            entries: [
              VocabularyEntry(
                id: 'vocab.hola.v1',
                spanish: 'hola',
                nativeTranslation: 'hello',
                cefr: 'A0',
                topicIds: ['topic_001'],
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
  Future<TopicDetails> loadTopicDetails(String topicId) async {
    throw StateError('Missing asset');
  }
}

const _section = TopicSection(
  id: 'section_001',
  title: 'Greeting Words',
  contentReference: ContentReference(
    type: 'vocabulary',
    assetPath: 'assets/spanish/vocabulary/greetings.json',
  ),
);

const _topic = Topic(id: 'topic_001', title: 'Greetings', sections: [_section]);

const _course = Course(
  id: 'spanish_a1',
  languageCode: 'es',
  title: 'Beginner Spanish',
  units: [
    Unit(id: 'unit_001', title: 'First Contacts', topics: [_topic]),
  ],
);
