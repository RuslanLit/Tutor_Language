import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/topic_content.dart';

void main() {
  test('VocabularyItem round-trips through JSON', () {
    final entry = VocabularyItem.fromJson(_vocabularyItemJson);

    expect(VocabularyItem.fromJson(entry.toJson()), entry);
  });

  test('GrammarTopic round-trips through JSON', () {
    final rule = GrammarTopic.fromJson(_grammarTopicJson);

    expect(GrammarTopic.fromJson(rule.toJson()), rule);
  });

  test('Dialogue round-trips through JSON', () {
    final dialogue = Dialogue.fromJson(_dialogueJson);

    expect(Dialogue.fromJson(dialogue.toJson()), dialogue);
  });

  test('DialogueLine round-trips through JSON', () {
    final line = DialogueLine.fromJson(_dialogueLineJson);

    expect(DialogueLine.fromJson(line.toJson()), line);
  });

  test('ReadingText round-trips through JSON', () {
    final reading = ReadingText.fromJson(_readingTextJson);

    expect(ReadingText.fromJson(reading.toJson()), reading);
  });

  test('ExerciseTemplate round-trips through JSON', () {
    final template = ExerciseTemplate.fromJson(_exerciseTemplateJson);

    expect(ExerciseTemplate.fromJson(template.toJson()), template);
  });

  test('ContentReference parses from JSON', () {
    final reference = ContentReference.fromJson(const {
      'type': 'vocabulary',
      'id': 'vocab.hola.v1',
    });

    expect(reference.type, 'vocabulary');
    expect(reference.id, 'vocab.hola.v1');
  });
}

const _vocabularyItemJson = {
  'id': 'vocab.hola.v1',
  'spanish': 'hola',
  'native_translation': 'hello',
  'cefr': 'A0',
  'example': 'Hola.',
  'pronunciation': 'OH-lah',
};

const _grammarTopicJson = {
  'id': 'grammar.llamarse_basic.v1',
  'title': 'llamarse basics',
  'explanation': 'Use llamarse to say what someone is called.',
  'examples': ['Me llamo Ana.'],
  'prerequisite_ids': <String>[],
};

const _dialogueLineJson = {
  'speaker': 'Ana',
  'spanish': 'Hola.',
  'native_translation': 'Hello.',
};

const _dialogueJson = {
  'id': 'dialogue.greetings_001.v1',
  'title': 'A simple greeting',
  'vocabulary_ids': ['vocab.hola.v1'],
  'grammar_ids': ['grammar.llamarse_basic.v1'],
  'lines': [_dialogueLineJson],
};

const _readingTextJson = {
  'id': 'reading.basic_greeting.v1',
  'title': 'Ana says hello',
  'vocabulary_ids': ['vocab.hola.v1'],
  'grammar_ids': ['grammar.llamarse_basic.v1'],
  'text': 'Hola. Me llamo Ana.',
  'native_translation': 'Hello. My name is Ana.',
};

const _exerciseTemplateJson = {
  'id': 'template.multiple_choice_basic.v1',
  'exercise_type': 'multiple_choice',
  'supported_goal_types': ['introduce_vocabulary'],
  'required_object_types': ['vocabulary'],
  'prompt_template': 'Choose the correct meaning.',
  'answer_options': [
    {'id': 'option.hello', 'label': 'hello'},
    {'id': 'option.goodbye', 'label': 'goodbye'},
  ],
  'correct_option_id': 'option.hello',
  'authored_misconceptions': [
    {
      'id': 'misconception.name.soy_ana.v1',
      'matching_answers': ['Soy Ana'],
      'feedback_key': 'spanish.name_pattern.use_me_llamo',
      'canonical_answer': 'Me llamo Ana',
      'explanation_reference_id': 'grammar.llamarse_basic.v1',
    },
  ],
};
