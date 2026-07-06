import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/course.dart';
import 'package:tutor_language/core/content/topic_content.dart';

void main() {
  test('Course round-trips through JSON', () {
    final course = Course.fromJson(_courseJson);

    expect(Course.fromJson(course.toJson()), course);
  });

  test('Unit round-trips through JSON', () {
    final unit = Unit.fromJson(_unitJson);

    expect(Unit.fromJson(unit.toJson()), unit);
  });

  test('Topic round-trips through JSON', () {
    final topic = Topic.fromJson(_topicJson);

    expect(Topic.fromJson(topic.toJson()), topic);
  });

  test('TopicSection round-trips through JSON', () {
    final section = TopicSection.fromJson(_sectionJson);

    expect(TopicSection.fromJson(section.toJson()), section);
  });

  test('ContentReference round-trips through JSON', () {
    final reference = ContentReference.fromJson(_contentReferenceJson);

    expect(ContentReference.fromJson(reference.toJson()), reference);
  });

  test('VocabularyEntry round-trips through JSON', () {
    final entry = VocabularyEntry.fromJson(_vocabularyEntryJson);

    expect(VocabularyEntry.fromJson(entry.toJson()), entry);
  });

  test('GrammarRule round-trips through JSON', () {
    final rule = GrammarRule.fromJson(_grammarRuleJson);

    expect(GrammarRule.fromJson(rule.toJson()), rule);
  });

  test('Dialogue round-trips through JSON', () {
    final dialogue = Dialogue.fromJson(_dialogueJson);

    expect(Dialogue.fromJson(dialogue.toJson()), dialogue);
  });

  test('DialogueLine round-trips through JSON', () {
    final line = DialogueLine.fromJson(_dialogueLineJson);

    expect(DialogueLine.fromJson(line.toJson()), line);
  });

  test('Reading round-trips through JSON', () {
    final reading = Reading.fromJson(_readingJson);

    expect(Reading.fromJson(reading.toJson()), reading);
  });

  test('ExerciseTemplate round-trips through JSON', () {
    final template = ExerciseTemplate.fromJson(_exerciseTemplateJson);

    expect(ExerciseTemplate.fromJson(template.toJson()), template);
  });
}

const _contentReferenceJson = {
  'type': 'vocabulary',
  'assetPath': 'assets/spanish/vocabulary/greetings.json',
  'referenceId': 'vocab.hola.v1',
};

const _sectionJson = {
  'id': 'section_001',
  'title': 'Greeting words',
  'contentReference': _contentReferenceJson,
};

const _topicJson = {
  'id': 'topic_001',
  'title': 'Greetings',
  'sections': [_sectionJson],
};

const _unitJson = {
  'id': 'unit_001',
  'title': 'First contacts',
  'topics': [_topicJson],
};

const _courseJson = {
  'id': 'spanish_a1',
  'languageCode': 'es',
  'title': 'Beginner Spanish',
  'units': [_unitJson],
};

const _vocabularyEntryJson = {
  'id': 'vocab.hola.v1',
  'spanish': 'hola',
  'native_translation': 'hello',
  'cefr': 'A0',
  'topic_ids': ['topic_001'],
  'example': 'Hola.',
  'pronunciation': 'OH-lah',
};

const _grammarRuleJson = {
  'id': 'grammar.llamarse_basic.v1',
  'title': 'llamarse basics',
  'explanation': 'Use llamarse to say what someone is called.',
  'examples': ['Me llamo Ana.'],
  'prerequisite_ids': <String>[],
  'topic_ids': ['topic_001'],
};

const _dialogueLineJson = {
  'speaker': 'Ana',
  'spanish': 'Hola.',
  'native_translation': 'Hello.',
};

const _dialogueJson = {
  'id': 'dialogue.greetings_001.v1',
  'title': 'A simple greeting',
  'topic_ids': ['topic_001'],
  'vocabulary_ids': ['vocab.hola.v1'],
  'grammar_ids': ['grammar.llamarse_basic.v1'],
  'lines': [_dialogueLineJson],
};

const _readingJson = {
  'id': 'reading.basic_greeting.v1',
  'title': 'Ana says hello',
  'topic_ids': ['topic_001'],
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
};
