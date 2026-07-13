import 'json_parsing.dart';

abstract class EducationalContent {
  const EducationalContent({required this.type, required this.assetPath});

  final String type;
  final String assetPath;
}

typedef TopicContent = EducationalContent;

class VocabularyContent extends EducationalContent {
  const VocabularyContent({required super.assetPath, required this.entries})
    : super(type: 'vocabulary');

  final List<VocabularyItem> entries;
}

class GrammarContent extends EducationalContent {
  const GrammarContent({
    required super.assetPath,
    List<GrammarTopic>? topics,
    List<GrammarTopic>? rules,
  }) : topics = topics ?? rules ?? const [],
       super(type: 'grammar');

  final List<GrammarTopic> topics;

  List<GrammarTopic> get rules => topics;
}

class DialogueContent extends EducationalContent {
  const DialogueContent({required super.assetPath, required this.dialogues})
    : super(type: 'dialogue');

  final List<Dialogue> dialogues;
}

class ReadingContent extends EducationalContent {
  const ReadingContent({
    required super.assetPath,
    List<ReadingText>? texts,
    List<ReadingText>? readings,
  }) : texts = texts ?? readings ?? const [],
       super(type: 'reading');

  final List<ReadingText> texts;

  List<ReadingText> get readings => texts;
}

class ExerciseTemplateContent extends EducationalContent {
  const ExerciseTemplateContent({
    required super.assetPath,
    required this.templates,
  }) : super(type: 'exercise_template');

  final List<ExerciseTemplate> templates;
}

class ContentReference {
  const ContentReference({required this.type, required this.id});

  factory ContentReference.fromJson(Map<String, Object?> json) {
    return ContentReference(
      type: requiredString(json, 'type'),
      id: requiredString(json, 'id'),
    );
  }

  final String type;
  final String id;
}

class VocabularyItem {
  const VocabularyItem({
    required this.id,
    required this.spanish,
    required this.nativeTranslation,
    required this.cefr,
    required this.example,
    this.pronunciation,
    this.notes,
  });

  factory VocabularyItem.fromJson(Map<String, Object?> json) {
    _rejectReverseLessonReferences(json, 'VocabularyItem');

    return VocabularyItem(
      id: requiredString(json, 'id'),
      spanish: requiredString(json, 'spanish'),
      nativeTranslation: requiredString(json, 'native_translation'),
      cefr: requiredString(json, 'cefr'),
      example: requiredString(json, 'example'),
      pronunciation: optionalString(json, 'pronunciation'),
      notes: optionalString(json, 'notes'),
    );
  }

  final String id;
  final String spanish;
  final String nativeTranslation;
  final String cefr;
  final String example;
  final String? pronunciation;
  final String? notes;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'spanish': spanish,
      'native_translation': nativeTranslation,
      'cefr': cefr,
      'example': example,
      if (pronunciation != null) 'pronunciation': pronunciation,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VocabularyItem &&
            other.id == id &&
            other.spanish == spanish &&
            other.nativeTranslation == nativeTranslation &&
            other.cefr == cefr &&
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
    example,
    pronunciation,
    notes,
  );
}

typedef VocabularyEntry = VocabularyItem;

void _rejectReverseLessonReferences(Map<String, Object?> json, String owner) {
  if (json.containsKey('lesson_ids')) {
    throw FormatException('$owner must not contain lesson_ids');
  }

  if (json.containsKey('topic_ids')) {
    throw FormatException('$owner must not contain topic_ids');
  }
}

class GrammarTopic {
  const GrammarTopic({
    required this.id,
    required this.title,
    required this.explanation,
    required this.examples,
    required this.prerequisiteIds,
  });

  factory GrammarTopic.fromJson(Map<String, Object?> json) {
    return GrammarTopic(
      id: requiredString(json, 'id'),
      title: requiredString(json, 'title'),
      explanation: requiredString(json, 'explanation'),
      examples: optionalStringList(json, 'examples'),
      prerequisiteIds: optionalStringList(json, 'prerequisite_ids'),
    );
  }

  final String id;
  final String title;
  final String explanation;
  final List<String> examples;
  final List<String> prerequisiteIds;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'explanation': explanation,
      'examples': examples,
      'prerequisite_ids': prerequisiteIds,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GrammarTopic &&
            other.id == id &&
            other.title == title &&
            other.explanation == explanation &&
            listEquals(other.examples, examples) &&
            listEquals(other.prerequisiteIds, prerequisiteIds);
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    explanation,
    Object.hashAll(examples),
    Object.hashAll(prerequisiteIds),
  );
}

typedef GrammarRule = GrammarTopic;

class Dialogue {
  const Dialogue({
    required this.id,
    required this.title,
    required this.vocabularyIds,
    required this.grammarIds,
    required this.lines,
  });

  factory Dialogue.fromJson(Map<String, Object?> json) {
    return Dialogue(
      id: requiredString(json, 'id'),
      title: requiredString(json, 'title'),
      vocabularyIds: optionalStringList(json, 'vocabulary_ids'),
      grammarIds: optionalStringList(json, 'grammar_ids'),
      lines: requiredList(json, 'lines', DialogueLine.fromJson),
    );
  }

  final String id;
  final String title;
  final List<String> vocabularyIds;
  final List<String> grammarIds;
  final List<DialogueLine> lines;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
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
            listEquals(other.vocabularyIds, vocabularyIds) &&
            listEquals(other.grammarIds, grammarIds) &&
            listEquals(other.lines, lines);
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
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

class ReadingText {
  const ReadingText({
    required this.id,
    required this.title,
    required this.vocabularyIds,
    required this.grammarIds,
    required this.text,
    required this.nativeTranslation,
  });

  factory ReadingText.fromJson(Map<String, Object?> json) {
    return ReadingText(
      id: requiredString(json, 'id'),
      title: requiredString(json, 'title'),
      vocabularyIds: optionalStringList(json, 'vocabulary_ids'),
      grammarIds: optionalStringList(json, 'grammar_ids'),
      text: requiredString(json, 'text'),
      nativeTranslation: requiredString(json, 'native_translation'),
    );
  }

  final String id;
  final String title;
  final List<String> vocabularyIds;
  final List<String> grammarIds;
  final String text;
  final String nativeTranslation;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'vocabulary_ids': vocabularyIds,
      'grammar_ids': grammarIds,
      'text': text,
      'native_translation': nativeTranslation,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ReadingText &&
            other.id == id &&
            other.title == title &&
            listEquals(other.vocabularyIds, vocabularyIds) &&
            listEquals(other.grammarIds, grammarIds) &&
            other.text == text &&
            other.nativeTranslation == nativeTranslation;
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    Object.hashAll(vocabularyIds),
    Object.hashAll(grammarIds),
    text,
    nativeTranslation,
  );
}

typedef Reading = ReadingText;

class ExerciseTemplate {
  const ExerciseTemplate({
    required this.id,
    required this.exerciseType,
    required this.supportedGoalTypes,
    required this.requiredObjectTypes,
    required this.promptTemplate,
    this.answerOptions = const [],
    this.correctOptionId,
    this.expectedAnswer,
    this.acceptedAnswers = const [],
    this.requiresExactAnswer = false,
    this.authoredMisconceptions = const [],
    this.reviewTemplateIds = const [],
  });

  factory ExerciseTemplate.fromJson(Map<String, Object?> json) {
    return ExerciseTemplate(
      id: requiredString(json, 'id'),
      exerciseType: requiredString(json, 'exercise_type'),
      supportedGoalTypes: optionalStringList(json, 'supported_goal_types'),
      requiredObjectTypes: optionalStringList(json, 'required_object_types'),
      promptTemplate: requiredString(json, 'prompt_template'),
      answerOptions: json['answer_options'] == null
          ? const []
          : requiredList(
              json,
              'answer_options',
              ExerciseTemplateOption.fromJson,
            ),
      correctOptionId: optionalString(json, 'correct_option_id'),
      expectedAnswer: optionalString(json, 'expected_answer'),
      acceptedAnswers: optionalStringList(json, 'accepted_answers'),
      requiresExactAnswer: optionalBool(json, 'requires_exact_answer') ?? false,
      authoredMisconceptions: json['authored_misconceptions'] == null
          ? const []
          : requiredList(
              json,
              'authored_misconceptions',
              AuthoredMisconception.fromJson,
            ),
      reviewTemplateIds: optionalStringList(json, 'review_template_ids'),
    );
  }

  final String id;
  final String exerciseType;
  final List<String> supportedGoalTypes;
  final List<String> requiredObjectTypes;
  final String promptTemplate;
  final List<ExerciseTemplateOption> answerOptions;
  final String? correctOptionId;
  final String? expectedAnswer;
  final List<String> acceptedAnswers;
  final bool requiresExactAnswer;
  final List<AuthoredMisconception> authoredMisconceptions;
  final List<String> reviewTemplateIds;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'exercise_type': exerciseType,
      'supported_goal_types': supportedGoalTypes,
      'required_object_types': requiredObjectTypes,
      'prompt_template': promptTemplate,
      if (answerOptions.isNotEmpty)
        'answer_options': answerOptions
            .map((option) => option.toJson())
            .toList(growable: false),
      if (correctOptionId != null) 'correct_option_id': correctOptionId,
      if (expectedAnswer != null) 'expected_answer': expectedAnswer,
      if (acceptedAnswers.isNotEmpty) 'accepted_answers': acceptedAnswers,
      if (requiresExactAnswer) 'requires_exact_answer': requiresExactAnswer,
      if (authoredMisconceptions.isNotEmpty)
        'authored_misconceptions': authoredMisconceptions
            .map((misconception) => misconception.toJson())
            .toList(growable: false),
      if (reviewTemplateIds.isNotEmpty)
        'review_template_ids': reviewTemplateIds,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ExerciseTemplate &&
            other.id == id &&
            other.exerciseType == exerciseType &&
            listEquals(other.supportedGoalTypes, supportedGoalTypes) &&
            listEquals(other.requiredObjectTypes, requiredObjectTypes) &&
            other.promptTemplate == promptTemplate &&
            listEquals(other.answerOptions, answerOptions) &&
            other.correctOptionId == correctOptionId &&
            other.expectedAnswer == expectedAnswer &&
            listEquals(other.acceptedAnswers, acceptedAnswers) &&
            other.requiresExactAnswer == requiresExactAnswer &&
            listEquals(other.authoredMisconceptions, authoredMisconceptions) &&
            listEquals(other.reviewTemplateIds, reviewTemplateIds);
  }

  @override
  int get hashCode => Object.hash(
    id,
    exerciseType,
    Object.hashAll(supportedGoalTypes),
    Object.hashAll(requiredObjectTypes),
    promptTemplate,
    Object.hashAll(answerOptions),
    correctOptionId,
    expectedAnswer,
    Object.hashAll(acceptedAnswers),
    requiresExactAnswer,
    Object.hashAll(authoredMisconceptions),
    Object.hashAll(reviewTemplateIds),
  );
}

class AuthoredMisconception {
  const AuthoredMisconception({
    required this.id,
    required this.matchingAnswers,
    required this.feedbackKey,
    this.canonicalAnswer,
    this.explanationReferenceId,
  });

  factory AuthoredMisconception.fromJson(Map<String, Object?> json) {
    return AuthoredMisconception(
      id: requiredString(json, 'id'),
      matchingAnswers: requiredStringList(json, 'matching_answers'),
      feedbackKey: requiredString(json, 'feedback_key'),
      canonicalAnswer: optionalString(json, 'canonical_answer'),
      explanationReferenceId: optionalString(json, 'explanation_reference_id'),
    );
  }

  final String id;
  final List<String> matchingAnswers;
  final String feedbackKey;
  final String? canonicalAnswer;
  final String? explanationReferenceId;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'matching_answers': matchingAnswers,
      'feedback_key': feedbackKey,
      if (canonicalAnswer != null) 'canonical_answer': canonicalAnswer,
      if (explanationReferenceId != null)
        'explanation_reference_id': explanationReferenceId,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AuthoredMisconception &&
            other.id == id &&
            listEquals(other.matchingAnswers, matchingAnswers) &&
            other.feedbackKey == feedbackKey &&
            other.canonicalAnswer == canonicalAnswer &&
            other.explanationReferenceId == explanationReferenceId;
  }

  @override
  int get hashCode => Object.hash(
    id,
    Object.hashAll(matchingAnswers),
    feedbackKey,
    canonicalAnswer,
    explanationReferenceId,
  );
}

class ExerciseTemplateOption {
  const ExerciseTemplateOption({required this.id, required this.label});

  factory ExerciseTemplateOption.fromJson(Map<String, Object?> json) {
    return ExerciseTemplateOption(
      id: requiredString(json, 'id'),
      label: requiredString(json, 'label'),
    );
  }

  final String id;
  final String label;

  Map<String, Object?> toJson() {
    return {'id': id, 'label': label};
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ExerciseTemplateOption &&
            other.id == id &&
            other.label == label;
  }

  @override
  int get hashCode => Object.hash(id, label);
}
