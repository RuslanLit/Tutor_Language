import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/course.dart';
import 'package:tutor_language/core/content/curriculum_loader.dart';
import 'package:tutor_language/core/content/topic_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'course JSON parses into Course, Unit, Topic, and TopicSection',
    () async {
      final loader = CurriculumLoader(assetBundle: rootBundle);

      final course = await loader.loadCourse();

      expect(course.id, 'spanish_a1');
      expect(course.languageCode, 'es');
      expect(course.units, hasLength(1));
      expect(course.units.single.id, 'unit_001');
      expect(course.units.single.topics.single.id, 'topic_001');
      expect(course.units.single.topics.single.sections, hasLength(5));
    },
  );

  test('content reference parses correctly', () {
    final reference = ContentReference.fromJson(const {
      'type': 'vocabulary',
      'assetPath': 'assets/spanish/vocabulary/greetings.json',
      'referenceId': 'vocab.hola.v1',
    });

    expect(reference.type, 'vocabulary');
    expect(reference.assetPath, 'assets/spanish/vocabulary/greetings.json');
    expect(reference.referenceId, 'vocab.hola.v1');
    expect(reference.toJson(), {
      'type': 'vocabulary',
      'assetPath': 'assets/spanish/vocabulary/greetings.json',
      'referenceId': 'vocab.hola.v1',
    });
  });

  test('curriculum loader preserves declared order', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final course = await loader.loadCourse();
    final sections = course.units.single.topics.single.sections;

    expect(sections.map((section) => section.id), [
      'section_001',
      'section_002',
      'section_003',
      'section_004',
      'section_005',
    ]);
  });

  test('content loader parses every supported content type', () async {
    final loader = ContentLoader(assetBundle: rootBundle);

    final content = await loader.loadSpanishContent();

    final vocabulary = content.byType<VocabularyContent>().single;
    final grammar = content.byType<GrammarContent>().single;
    final dialogues = content.byType<DialogueContent>().single;
    final readings = content.byType<ReadingContent>().single;
    final templates = content.byType<ExerciseTemplateContent>().single;

    expect(vocabulary.entries.first, isA<VocabularyEntry>());
    expect(grammar.rules.first, isA<GrammarRule>());
    expect(dialogues.dialogues.first.lines.first, isA<DialogueLine>());
    expect(readings.readings.first, isA<Reading>());
    expect(templates.templates.first, isA<ExerciseTemplate>());
  });
}
