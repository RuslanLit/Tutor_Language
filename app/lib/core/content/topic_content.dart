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
    this.audioReferenceId,
    this.pronunciationUnitId,
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
      audioReferenceId: optionalString(json, 'audioReferenceId'),
      pronunciationUnitId:
          optionalString(json, 'pronunciationUnitId') ??
          optionalString(json, 'pronunciation_unit_id'),
      pronunciation: optionalString(json, 'pronunciation'),
      notes: optionalString(json, 'notes'),
    );
  }

  final String id;
  final String spanish;
  final String nativeTranslation;
  final String cefr;
  final String example;
  final String? audioReferenceId;
  final String? pronunciationUnitId;
  final String? pronunciation;
  final String? notes;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'spanish': spanish,
      'native_translation': nativeTranslation,
      'cefr': cefr,
      'example': example,
      if (audioReferenceId != null) 'audioReferenceId': audioReferenceId,
      if (pronunciationUnitId != null)
        'pronunciationUnitId': pronunciationUnitId,
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
            other.audioReferenceId == audioReferenceId &&
            other.pronunciationUnitId == pronunciationUnitId &&
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
    audioReferenceId,
    pronunciationUnitId,
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
    this.audioReferenceId,
  });

  factory DialogueLine.fromJson(Map<String, Object?> json) {
    return DialogueLine(
      speaker: requiredString(json, 'speaker'),
      spanish: requiredString(json, 'spanish'),
      nativeTranslation: requiredString(json, 'native_translation'),
      audioReferenceId: optionalString(json, 'audioReferenceId'),
    );
  }

  final String speaker;
  final String spanish;
  final String nativeTranslation;
  final String? audioReferenceId;

  Map<String, Object?> toJson() {
    return {
      'speaker': speaker,
      'spanish': spanish,
      'native_translation': nativeTranslation,
      if (audioReferenceId != null) 'audioReferenceId': audioReferenceId,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DialogueLine &&
            other.speaker == speaker &&
            other.spanish == spanish &&
            other.nativeTranslation == nativeTranslation &&
            other.audioReferenceId == audioReferenceId;
  }

  @override
  int get hashCode =>
      Object.hash(speaker, spanish, nativeTranslation, audioReferenceId);
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
    this.audioReferenceId,
    this.audioTranscript,
    this.expectedAnswer,
    this.acceptedAnswers = const [],
    this.acceptedWithFeedbackAnswers = const [],
    this.requiresExactAnswer = false,
    this.authoredMisconceptions = const [],
    this.reviewTemplateIds = const [],
    this.productionContract,
    this.guidedDialogue,
    this.sentenceBuilder,
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
      audioReferenceId: optionalString(json, 'audio_reference_id'),
      audioTranscript: optionalString(json, 'audio_transcript'),
      expectedAnswer: optionalString(json, 'expected_answer'),
      acceptedAnswers: optionalStringList(json, 'accepted_answers'),
      acceptedWithFeedbackAnswers:
          json['accepted_with_feedback_answers'] == null
          ? const []
          : requiredList(
              json,
              'accepted_with_feedback_answers',
              AcceptedWithFeedbackAnswer.fromJson,
            ),
      requiresExactAnswer: optionalBool(json, 'requires_exact_answer') ?? false,
      authoredMisconceptions: json['authored_misconceptions'] == null
          ? const []
          : requiredList(
              json,
              'authored_misconceptions',
              AuthoredMisconception.fromJson,
            ),
      reviewTemplateIds: optionalStringList(json, 'review_template_ids'),
      productionContract: json['production_contract'] == null
          ? null
          : ProductionContract.fromJson(
              requiredMap(json, 'production_contract'),
            ),
      guidedDialogue: json['guided_dialogue'] == null
          ? null
          : GuidedDialogue.fromJson(requiredMap(json, 'guided_dialogue')),
      sentenceBuilder: json['sentence_builder'] == null
          ? null
          : SentenceBuilder.fromJson(requiredMap(json, 'sentence_builder')),
    );
  }

  final String id;
  final String exerciseType;
  final List<String> supportedGoalTypes;
  final List<String> requiredObjectTypes;
  final String promptTemplate;
  final List<ExerciseTemplateOption> answerOptions;
  final String? correctOptionId;
  final String? audioReferenceId;
  final String? audioTranscript;
  final String? expectedAnswer;
  final List<String> acceptedAnswers;
  final List<AcceptedWithFeedbackAnswer> acceptedWithFeedbackAnswers;
  final bool requiresExactAnswer;
  final List<AuthoredMisconception> authoredMisconceptions;
  final List<String> reviewTemplateIds;
  final ProductionContract? productionContract;
  final GuidedDialogue? guidedDialogue;
  final SentenceBuilder? sentenceBuilder;

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
      if (audioReferenceId != null) 'audio_reference_id': audioReferenceId,
      if (audioTranscript != null) 'audio_transcript': audioTranscript,
      if (expectedAnswer != null) 'expected_answer': expectedAnswer,
      if (acceptedAnswers.isNotEmpty) 'accepted_answers': acceptedAnswers,
      if (acceptedWithFeedbackAnswers.isNotEmpty)
        'accepted_with_feedback_answers': acceptedWithFeedbackAnswers
            .map((answer) => answer.toJson())
            .toList(growable: false),
      if (requiresExactAnswer) 'requires_exact_answer': requiresExactAnswer,
      if (authoredMisconceptions.isNotEmpty)
        'authored_misconceptions': authoredMisconceptions
            .map((misconception) => misconception.toJson())
            .toList(growable: false),
      if (reviewTemplateIds.isNotEmpty)
        'review_template_ids': reviewTemplateIds,
      if (productionContract != null)
        'production_contract': productionContract!.toJson(),
      if (guidedDialogue != null) 'guided_dialogue': guidedDialogue!.toJson(),
      if (sentenceBuilder != null)
        'sentence_builder': sentenceBuilder!.toJson(),
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
            other.audioReferenceId == audioReferenceId &&
            other.audioTranscript == audioTranscript &&
            other.expectedAnswer == expectedAnswer &&
            listEquals(other.acceptedAnswers, acceptedAnswers) &&
            listEquals(
              other.acceptedWithFeedbackAnswers,
              acceptedWithFeedbackAnswers,
            ) &&
            other.requiresExactAnswer == requiresExactAnswer &&
            listEquals(other.authoredMisconceptions, authoredMisconceptions) &&
            listEquals(other.reviewTemplateIds, reviewTemplateIds) &&
            other.productionContract == productionContract &&
            other.guidedDialogue == guidedDialogue;
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
    audioReferenceId,
    audioTranscript,
    expectedAnswer,
    Object.hashAll(acceptedAnswers),
    Object.hashAll(acceptedWithFeedbackAnswers),
    requiresExactAnswer,
    Object.hashAll(authoredMisconceptions),
    Object.hashAll(reviewTemplateIds),
    productionContract,
    guidedDialogue,
    sentenceBuilder,
  );
}

class SentenceBuilder {
  const SentenceBuilder({
    required this.tokens,
    required this.acceptedSequences,
    this.audioReferenceId,
  });
  factory SentenceBuilder.fromJson(Map<String, Object?> json) =>
      SentenceBuilder(
        tokens: requiredList(json, 'tokens', SentenceBuilderToken.fromJson),
        acceptedSequences: (json['accepted_sequences'] as List<Object?>)
            .map(
              (sequence) => (sequence as List<Object?>).cast<String>().toList(
                growable: false,
              ),
            )
            .toList(growable: false),
        audioReferenceId: optionalString(json, 'audioReferenceId'),
      );
  final List<SentenceBuilderToken> tokens;
  final List<List<String>> acceptedSequences;
  final String? audioReferenceId;
  Map<String, Object?> toJson() => {
    'tokens': tokens.map((token) => token.toJson()).toList(growable: false),
    'accepted_sequences': acceptedSequences,
    if (audioReferenceId != null) 'audioReferenceId': audioReferenceId,
  };
  @override
  bool operator ==(Object other) =>
      other is SentenceBuilder &&
      other.audioReferenceId == audioReferenceId &&
      listEquals(other.tokens, tokens) &&
      listEquals(other.acceptedSequences, acceptedSequences);
  @override
  int get hashCode => Object.hash(
    audioReferenceId,
    Object.hashAll(tokens),
    Object.hashAll(acceptedSequences),
  );
}

class SentenceBuilderToken {
  const SentenceBuilderToken({required this.id, required this.label});
  factory SentenceBuilderToken.fromJson(Map<String, Object?> json) =>
      SentenceBuilderToken(
        id: requiredString(json, 'id'),
        label: requiredString(json, 'label'),
      );
  final String id;
  final String label;
  Map<String, Object?> toJson() => {'id': id, 'label': label};
  @override
  bool operator ==(Object other) =>
      other is SentenceBuilderToken && other.id == id && other.label == label;
  @override
  int get hashCode => Object.hash(id, label);
}

class GuidedDialogue {
  const GuidedDialogue({required this.turns});

  factory GuidedDialogue.fromJson(Map<String, Object?> json) {
    return GuidedDialogue(
      turns: requiredList(json, 'turns', GuidedDialogueTurn.fromJson),
    );
  }

  final List<GuidedDialogueTurn> turns;

  Map<String, Object?> toJson() => {
    'turns': turns.map((turn) => turn.toJson()).toList(growable: false),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuidedDialogue && listEquals(other.turns, turns);

  @override
  int get hashCode => Object.hashAll(turns);
}

class GuidedDialogueTurn {
  const GuidedDialogueTurn({
    required this.speaker,
    required this.text,
    required this.learner,
    this.audioReferenceId,
    this.learnerCue,
    this.responsePatterns = const [],
    this.allowedSlots = const {},
    this.responseMode = 'exact',
  });

  factory GuidedDialogueTurn.fromJson(Map<String, Object?> json) {
    final slots = json['allowed_slots'];
    return GuidedDialogueTurn(
      speaker: requiredString(json, 'speaker'),
      text: requiredString(json, 'text'),
      learner: optionalBool(json, 'learner') ?? false,
      audioReferenceId: optionalString(json, 'audioReferenceId'),
      learnerCue: optionalString(json, 'learner_cue'),
      responsePatterns: optionalStringList(json, 'response_patterns'),
      allowedSlots: slots == null
          ? const {}
          : Map.unmodifiable(
              Map<String, Object?>.from(slots as Map).map(
                (key, value) => MapEntry(
                  key,
                  (value as List).map((item) => item.toString()).toList(),
                ),
              ),
            ),
      responseMode: optionalString(json, 'response_mode') ?? 'exact',
    );
  }

  final String speaker;
  final String text;
  final bool learner;
  final String? audioReferenceId;
  final String? learnerCue;
  final List<String> responsePatterns;
  final Map<String, List<String>> allowedSlots;

  /// `exact`, `prefix`, or `prefix_with_value`.
  final String responseMode;

  Map<String, Object?> toJson() => {
    'speaker': speaker,
    'text': text,
    if (learner) 'learner': true,
    if (audioReferenceId != null) 'audioReferenceId': audioReferenceId,
    if (learnerCue != null) 'learner_cue': learnerCue,
    if (responsePatterns.isNotEmpty) 'response_patterns': responsePatterns,
    if (allowedSlots.isNotEmpty) 'allowed_slots': allowedSlots,
    if (responseMode != 'exact') 'response_mode': responseMode,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuidedDialogueTurn &&
          other.speaker == speaker &&
          other.text == text &&
          other.learner == learner &&
          other.audioReferenceId == audioReferenceId &&
          other.learnerCue == learnerCue &&
          listEquals(other.responsePatterns, responsePatterns) &&
          _guidedSlotsEqual(other.allowedSlots, allowedSlots) &&
          other.responseMode == responseMode;

  @override
  int get hashCode => Object.hash(
    speaker,
    text,
    learner,
    audioReferenceId,
    learnerCue,
    Object.hashAll(responsePatterns),
    Object.hashAll(allowedSlots.entries),
    responseMode,
  );
}

bool _guidedSlotsEqual(
  Map<String, List<String>> left,
  Map<String, List<String>> right,
) {
  if (left.length != right.length) return false;
  for (final entry in left.entries) {
    if (!listEquals(entry.value, right[entry.key] ?? const [])) return false;
  }
  return true;
}

class ProductionContract {
  const ProductionContract({required this.mode, required this.functions});

  factory ProductionContract.fromJson(Map<String, Object?> json) {
    return ProductionContract(
      mode: requiredString(json, 'mode'),
      functions: requiredList(json, 'functions', ProductionFunction.fromJson),
    );
  }

  final String mode;
  final List<ProductionFunction> functions;

  Map<String, Object?> toJson() => {
    'mode': mode,
    'functions': functions.map((function) => function.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionContract &&
          other.mode == mode &&
          listEquals(other.functions, functions);

  @override
  int get hashCode => Object.hash(mode, Object.hashAll(functions));
}

class ProductionFunction {
  const ProductionFunction({
    required this.id,
    required this.required,
    this.acceptedRealizations = const [],
    this.acceptedWithFeedbackRealizations = const [],
  });

  factory ProductionFunction.fromJson(Map<String, Object?> json) {
    return ProductionFunction(
      id: requiredString(json, 'id'),
      required: optionalBool(json, 'required') ?? true,
      acceptedRealizations: optionalStringList(json, 'accepted'),
      acceptedWithFeedbackRealizations: optionalStringList(
        json,
        'accepted_with_feedback',
      ),
    );
  }

  final String id;
  final bool required;
  final List<String> acceptedRealizations;
  final List<String> acceptedWithFeedbackRealizations;

  Map<String, Object?> toJson() => {
    'id': id,
    if (!required) 'required': false,
    'accepted': acceptedRealizations,
    if (acceptedWithFeedbackRealizations.isNotEmpty)
      'accepted_with_feedback': acceptedWithFeedbackRealizations,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionFunction &&
          other.id == id &&
          other.required == required &&
          listEquals(other.acceptedRealizations, acceptedRealizations) &&
          listEquals(
            other.acceptedWithFeedbackRealizations,
            acceptedWithFeedbackRealizations,
          );

  @override
  int get hashCode => Object.hash(
    id,
    required,
    Object.hashAll(acceptedRealizations),
    Object.hashAll(acceptedWithFeedbackRealizations),
  );
}

class AcceptedWithFeedbackAnswer {
  const AcceptedWithFeedbackAnswer({
    required this.answer,
    required this.feedbackKey,
    this.canonicalAnswer,
  });

  factory AcceptedWithFeedbackAnswer.fromJson(Map<String, Object?> json) {
    return AcceptedWithFeedbackAnswer(
      answer: requiredString(json, 'answer'),
      feedbackKey: requiredString(json, 'feedback_key'),
      canonicalAnswer: optionalString(json, 'canonical_answer'),
    );
  }

  final String answer;
  final String feedbackKey;
  final String? canonicalAnswer;

  Map<String, Object?> toJson() {
    return {
      'answer': answer,
      'feedback_key': feedbackKey,
      if (canonicalAnswer != null) 'canonical_answer': canonicalAnswer,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AcceptedWithFeedbackAnswer &&
            other.answer == answer &&
            other.feedbackKey == feedbackKey &&
            other.canonicalAnswer == canonicalAnswer;
  }

  @override
  int get hashCode => Object.hash(answer, feedbackKey, canonicalAnswer);
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
