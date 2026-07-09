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

    final vocabulary = content.byType<VocabularyContent>();
    final grammar = content.byType<GrammarContent>();
    final dialogues = content.byType<DialogueContent>();
    final readings = content.byType<ReadingContent>();
    final templates = content.byType<ExerciseTemplateContent>();

    expect(
      vocabulary.expand((content) => content.entries).first,
      isA<VocabularyItem>(),
    );
    expect(
      grammar.expand((content) => content.topics).first,
      isA<GrammarTopic>(),
    );
    expect(
      dialogues.expand((content) => content.dialogues).first.lines.first,
      isA<DialogueLine>(),
    );
    expect(
      readings.expand((content) => content.texts).first,
      isA<ReadingText>(),
    );
    expect(
      templates.expand((content) => content.templates).first,
      isA<ExerciseTemplate>(),
    );
  });

  test('Spanish vocabulary pool loads and validates', () async {
    final loader = ContentLoader(assetBundle: rootBundle);
    final validator = EducationalContentValidator();

    final content = await loader.loadSpanishContent();
    final vocabulary = content.byType<VocabularyContent>();
    final entries = vocabulary.expand((content) => content.entries).toList();
    final ids = entries.map((entry) => entry.id).toSet();

    expect(entries.length, greaterThanOrEqualTo(15));
    expect(ids, contains('vocab.hola.v1'));
    expect(ids, contains('vocab.mucho_gusto.v1'));
    expect(ids, contains('vocab.es.a0.u01.l01.hola.v1'));
    expect(ids, contains('vocab.es.a0.u01.l01.adios.v1'));
    expect(validator.validate(content), isEmpty);
    expect(
      entries.every((entry) {
        final json = entry.toJson();

        return !json.containsKey('lesson_ids') &&
            !json.containsKey('topic_ids');
      }),
      isTrue,
    );
  });
}
