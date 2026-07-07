import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/educational_content_validator.dart';
import 'package:tutor_language/core/content/topic_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('content loader parses every supported content type', () async {
    final loader = ContentLoader(assetBundle: rootBundle);

    final content = await loader.loadSpanishContent();

    final vocabulary = content.byType<VocabularyContent>().single;
    final grammar = content.byType<GrammarContent>().single;
    final dialogues = content.byType<DialogueContent>().single;
    final readings = content.byType<ReadingContent>().single;
    final templates = content.byType<ExerciseTemplateContent>().single;

    expect(vocabulary.entries.first, isA<VocabularyItem>());
    expect(grammar.topics.first, isA<GrammarTopic>());
    expect(dialogues.dialogues.first.lines.first, isA<DialogueLine>());
    expect(readings.texts.first, isA<ReadingText>());
    expect(templates.templates.first, isA<ExerciseTemplate>());
  });

  test('Spanish vocabulary pool loads and validates', () async {
    final loader = ContentLoader(assetBundle: rootBundle);
    final validator = EducationalContentValidator();

    final content = await loader.loadSpanishContent();
    final vocabulary = content.byType<VocabularyContent>().single;
    final ids = vocabulary.entries.map((entry) => entry.id).toSet();

    expect(vocabulary.entries, hasLength(10));
    expect(ids, contains('vocab.hola.v1'));
    expect(ids, contains('vocab.mucho_gusto.v1'));
    expect(validator.validate(content), isEmpty);
    expect(
      vocabulary.entries.every((entry) {
        final json = entry.toJson();

        return !json.containsKey('lesson_ids') &&
            !json.containsKey('topic_ids');
      }),
      isTrue,
    );
  });
}
