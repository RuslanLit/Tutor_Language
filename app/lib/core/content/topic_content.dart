import 'course.dart';

abstract class TopicContent {
  const TopicContent({required this.type, required this.assetPath});

  final String type;
  final String assetPath;
}

class VocabularyContent extends TopicContent {
  const VocabularyContent({required super.assetPath, required this.entries})
    : super(type: 'vocabulary');

  final List<VocabularyEntry> entries;
}

class GrammarContent extends TopicContent {
  const GrammarContent({required super.assetPath, required this.rules})
    : super(type: 'grammar');

  final List<GrammarRule> rules;
}

class DialogueContent extends TopicContent {
  const DialogueContent({required super.assetPath, required this.dialogues})
    : super(type: 'dialogue');

  final List<Dialogue> dialogues;
}

class ReadingContent extends TopicContent {
  const ReadingContent({required super.assetPath, required this.readings})
    : super(type: 'reading');

  final List<Reading> readings;
}

class ExerciseTemplateContent extends TopicContent {
  const ExerciseTemplateContent({
    required super.assetPath,
    required this.templates,
  }) : super(type: 'exercise_template');

  final List<ExerciseTemplate> templates;
}

class VocabularyEntry {
  const VocabularyEntry({
    required this.id,
    required this.spanish,
    required this.nativeTranslation,
    required this.cefr,
    required this.topicIds,
    required this.example,
    this.pronunciation,
    this.notes,
  });

  factory VocabularyEntry.fromJson(Map<String, Object?> json) {
    return VocabularyEntry(
      id: requiredString(json, 'id'),
      spanish: requiredString(json, 'spanish'),
      nativeTranslation: requiredString(json, 'native_translation'),
      cefr: requiredString(json, 'cefr'),
      topicIds: optionalStringList(json, 'topic_ids'),
      example: requiredString(json, 'example'),
      pronunciation: optionalString(json, 'pronunciation'),
      notes: optionalString(json, 'notes'),
    );
  }

  final String id;
  final String spanish;
  final String nativeTranslation;
  final String cefr;
  final List<String> topicIds;
  final String example;
  final String? pronunciation;
  final String? notes;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'spanish': spanish,
      'native_translation': nativeTranslation,
      'cefr': cefr,
      'topic_ids': topicIds,
      'example': example,
      if (pronunciation != null) 'pronunciation': pronunciation,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VocabularyEntry &&
            other.id == id &&
            other.spanish == spanish &&
            other.nativeTranslation == nativeTranslation &&
            other.cefr == cefr &&
            _listEquals(other.topicIds, topicIds) &&
            other.example == example &&
            other.pronunciation == pronunciation &&
            other.notes == notes;
  }

  @override
  int get hashCode => Object.hash(
    id,
    spanish,
    nativeTranslation,
    cefr,
    Object.hashAll(topicIds),
    example,
    pronunciation,
    notes,
  );
}

class GrammarRule {
  const GrammarRule({
    required this.id,
    required this.title,
    required this.explanation,
    required this.examples,
    required this.prerequisiteIds,
    required this.topicIds,
  });

  factory GrammarRule.fromJson(Map<String, Object?> json) {
    return GrammarRule(
      id: requiredString(json, 'id'),
      title: requiredString(json, 'title'),
      explanation: requiredString(json, 'explanation'),
      examples: optionalStringList(json, 'examples'),
      prerequisiteIds: optionalStringList(json, 'prerequisite_ids'),
      topicIds: optionalStringList(json, 'topic_ids'),
    );
  }

  final String id;
  final String title;
  final String explanation;
  final List<String> examples;
  final List<String> prerequisiteIds;
  final List<String> topicIds;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'explanation': explanation,
      'examples': examples,
      'prerequisite_ids': prerequisiteIds,
      'topic_ids': topicIds,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GrammarRule &&
            other.id == id &&
            other.title == title &&
            other.explanation == explanation &&
            _listEquals(other.examples, examples) &&
            _listEquals(other.prerequisiteIds, prerequisiteIds) &&
            _listEquals(other.topicIds, topicIds);
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    explanation,
    Object.hashAll(examples),
    Object.hashAll(prerequisiteIds),
    Object.hashAll(topicIds),
  );
}

class Dialogue {
  const Dialogue({
    required this.id,
    required this.title,
    required this.topicIds,
    required this.vocabularyIds,
    required this.grammarIds,
    required this.lines,
  });

  factory Dialogue.fromJson(Map<String, Object?> json) {
    return Dialogue(
      id: requiredString(json, 'id'),
      title: requiredString(json, 'title'),
      topicIds: optionalStringList(json, 'topic_ids'),
      vocabularyIds: optionalStringList(json, 'vocabulary_ids'),
      grammarIds: optionalStringList(json, 'grammar_ids'),
      lines: requiredList(json, 'lines', DialogueLine.fromJson),
    );
  }

  final String id;
  final String title;
  final List<String> topicIds;
  final List<String> vocabularyIds;
  final List<String> grammarIds;
  final List<DialogueLine> lines;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'topic_ids': topicIds,
      'vocabulary_ids': vocabularyIds,
      'grammar_ids': grammarIds,
      'lines': lines.map((line) => line.toJson()).toList(growable: false),
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Dialogue &&
            other.id == id &&
            other.title == title &&
            _listEquals(other.topicIds, topicIds) &&
            _listEquals(other.vocabularyIds, vocabularyIds) &&
            _listEquals(other.grammarIds, grammarIds) &&
            _listEquals(other.lines, lines);
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    Object.hashAll(topicIds),
    Object.hashAll(vocabularyIds),
    Object.hashAll(grammarIds),
    Object.hashAll(lines),
  );
}

class DialogueLine {
  const DialogueLine({
    required this.speaker,
    required this.spanish,
    required this.nativeTranslation,
  });

  factory DialogueLine.fromJson(Map<String, Object?> json) {
    return DialogueLine(
      speaker: requiredString(json, 'speaker'),
      spanish: requiredString(json, 'spanish'),
      nativeTranslation: requiredString(json, 'native_translation'),
    );
  }

  final String speaker;
  final String spanish;
  final String nativeTranslation;

  Map<String, Object?> toJson() {
    return {
      'speaker': speaker,
      'spanish': spanish,
      'native_translation': nativeTranslation,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DialogueLine &&
            other.speaker == speaker &&
            other.spanish == spanish &&
            other.nativeTranslation == nativeTranslation;
  }

  @override
  int get hashCode => Object.hash(speaker, spanish, nativeTranslation);
}

class Reading {
  const Reading({
    required this.id,
    required this.title,
    required this.topicIds,
    required this.vocabularyIds,
    required this.grammarIds,
    required this.text,
    required this.nativeTranslation,
  });

  factory Reading.fromJson(Map<String, Object?> json) {
    return Reading(
      id: requiredString(json, 'id'),
      title: requiredString(json, 'title'),
      topicIds: optionalStringList(json, 'topic_ids'),
      vocabularyIds: optionalStringList(json, 'vocabulary_ids'),
      grammarIds: optionalStringList(json, 'grammar_ids'),
      text: requiredString(json, 'text'),
      nativeTranslation: requiredString(json, 'native_translation'),
    );
  }

  final String id;
  final String title;
  final List<String> topicIds;
  final List<String> vocabularyIds;
  final List<String> grammarIds;
  final String text;
  final String nativeTranslation;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'topic_ids': topicIds,
      'vocabulary_ids': vocabularyIds,
      'grammar_ids': grammarIds,
      'text': text,
      'native_translation': nativeTranslation,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Reading &&
            other.id == id &&
            other.title == title &&
            _listEquals(other.topicIds, topicIds) &&
            _listEquals(other.vocabularyIds, vocabularyIds) &&
            _listEquals(other.grammarIds, grammarIds) &&
            other.text == text &&
            other.nativeTranslation == nativeTranslation;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    Object.hashAll(topicIds),
    Object.hashAll(vocabularyIds),
    Object.hashAll(grammarIds),
    text,
    nativeTranslation,
  );
}

class ExerciseTemplate {
  const ExerciseTemplate({
    required this.id,
    required this.exerciseType,
    required this.supportedGoalTypes,
    required this.requiredObjectTypes,
    required this.promptTemplate,
  });

  factory ExerciseTemplate.fromJson(Map<String, Object?> json) {
    return ExerciseTemplate(
      id: requiredString(json, 'id'),
      exerciseType: requiredString(json, 'exercise_type'),
      supportedGoalTypes: optionalStringList(json, 'supported_goal_types'),
      requiredObjectTypes: optionalStringList(json, 'required_object_types'),
      promptTemplate: requiredString(json, 'prompt_template'),
    );
  }

  final String id;
  final String exerciseType;
  final List<String> supportedGoalTypes;
  final List<String> requiredObjectTypes;
  final String promptTemplate;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'exercise_type': exerciseType,
      'supported_goal_types': supportedGoalTypes,
      'required_object_types': requiredObjectTypes,
      'prompt_template': promptTemplate,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ExerciseTemplate &&
            other.id == id &&
            other.exerciseType == exerciseType &&
            _listEquals(other.supportedGoalTypes, supportedGoalTypes) &&
            _listEquals(other.requiredObjectTypes, requiredObjectTypes) &&
            other.promptTemplate == promptTemplate;
  }

  @override
  int get hashCode => Object.hash(
    id,
    exerciseType,
    Object.hashAll(supportedGoalTypes),
    Object.hashAll(requiredObjectTypes),
    promptTemplate,
  );
}

bool _listEquals<T>(List<T> left, List<T> right) {
  if (identical(left, right)) {
    return true;
  }

  if (left.length != right.length) {
    return false;
  }

  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }

  return true;
}
