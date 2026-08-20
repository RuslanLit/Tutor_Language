import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/activity_engine/activity_engine.dart';
import 'package:tutor_language/features/activity_engine/activity_result.dart';
import 'package:tutor_language/features/answer_evaluation/answer_evaluation.dart';

void main() {
  test('evaluates multiple_choice correctly', () {
    final result = const ActivityEngine().evaluate(
      template: _multipleChoiceTemplate,
      submission: const ActivitySubmission(selectedAnswerId: 'option.hello'),
    );

    expect(result.exerciseId, _multipleChoiceTemplate.id);
    expect(result.isCorrect, isTrue);
    expect(result.selectedAnswer, 'option.hello');
    expect(result.expectedAnswer, 'option.hello');
  });

  test('evaluates multiple_choice incorrectly', () {
    final result = const ActivityEngine().evaluate(
      template: _multipleChoiceTemplate,
      submission: const ActivitySubmission(selectedAnswerId: 'option.goodbye'),
    );

    expect(result.isCorrect, isFalse);
    expect(result.feedbackKey, 'answer.incorrect');
  });

  test('evaluates fill_gap with trim and case-insensitive normalization', () {
    final result = const ActivityEngine().evaluate(
      template: _fillGapTemplate,
      submission: const ActivitySubmission(submittedAnswer: '  hOlA  '),
    );

    expect(result.isCorrect, isTrue);
    expect(result.submittedAnswer, '  hOlA  ');
    expect(result.expectedAnswer, 'Hola');
    expect(result.evaluation?.matchType, AnswerMatchType.normalizedCanonical);
  });

  test('evaluates text_entry with the reusable typed-answer evaluator', () {
    final result = const ActivityEngine().evaluate(
      template: _textEntryTemplate,
      submission: const ActivitySubmission(submittedAnswer: '  hOlA  '),
    );

    expect(result.isCorrect, isTrue);
    expect(result.status, ActivityResultStatus.correct);
    expect(result.feedbackKey, 'answer.correct');
  });

  test('guided dialogue accepts any nonempty value after its construction', () {
    const engine = ActivityEngine();
    final accepted = engine.evaluate(
      template: _guidedDialogueTemplate,
      submission: const ActivitySubmission(
        submittedAnswer: 'Soy de Marte.',
        dialogueTurnIndex: 1,
      ),
    );
    final rejected = engine.evaluate(
      template: _guidedDialogueTemplate,
      submission: const ActivitySubmission(
        submittedAnswer: 'Soy Marte.',
        dialogueTurnIndex: 1,
      ),
    );

    expect(accepted.isCorrect, isTrue);
    expect(rejected.isCorrect, isFalse);
  });

  test('guided dialogue prefix mode allows an optional tail', () {
    const template = ExerciseTemplate(
      id: 'template.guided.prefix',
      exerciseType: 'guided_dialogue',
      supportedGoalTypes: ['test'],
      requiredObjectTypes: ['dialogue'],
      promptTemplate: 'Reply.',
      guidedDialogue: GuidedDialogue(
        turns: [
          GuidedDialogueTurn(
            speaker: 'Tú',
            text: 'No hablo.',
            learner: true,
            responsePatterns: ['No hablo'],
            responseMode: 'prefix',
          ),
        ],
      ),
    );
    expect(
      const ActivityEngine()
          .evaluate(
            template: template,
            submission: const ActivitySubmission(submittedAnswer: 'No hablo.'),
          )
          .isCorrect,
      isTrue,
    );
    expect(
      const ActivityEngine()
          .evaluate(
            template: template,
            submission: const ActivitySubmission(
              submittedAnswer: 'No habla francés.',
            ),
          )
          .isCorrect,
      isFalse,
    );
  });

  test(
    'guided exact dialogue accepts harmless terminal punctuation variation',
    () {
      const template = ExerciseTemplate(
        id: 'template.guided.exact.punctuation',
        exerciseType: 'guided_dialogue',
        supportedGoalTypes: ['test'],
        requiredObjectTypes: ['dialogue'],
        promptTemplate: 'Reply.',
        guidedDialogue: GuidedDialogue(
          turns: [
            GuidedDialogueTurn(
              speaker: 'Tú',
              text: 'Igualmente.',
              learner: true,
              responsePatterns: ['Igualmente.'],
              responseMode: 'exact',
            ),
          ],
        ),
      );

      for (final answer in ['Igualmente', 'Igualmente.']) {
        final result = const ActivityEngine().evaluate(
          template: template,
          submission: ActivitySubmission(submittedAnswer: answer),
        );
        expect(result.isCorrect, isTrue, reason: answer);
      }
    },
  );

  test(
    'sentence builder evaluates equivalent visible tokens, not token IDs',
    () {
      const template = ExerciseTemplate(
        id: 'template.sentence.duplicate-visible-token',
        exerciseType: 'sentence_builder',
        supportedGoalTypes: ['test'],
        requiredObjectTypes: ['dialogue'],
        promptTemplate: 'Build it.',
        sentenceBuilder: SentenceBuilder(
          tokens: [
            SentenceBuilderToken(id: 'me', label: 'Me'),
            SentenceBuilderToken(id: 'llamo', label: 'llamo'),
            SentenceBuilderToken(id: 'marta.target', label: 'Marta.'),
            SentenceBuilderToken(id: 'marta.distractor', label: 'Marta.'),
          ],
          acceptedSequences: [
            ['me', 'llamo', 'marta.target'],
          ],
        ),
      );

      final result = const ActivityEngine().evaluate(
        template: template,
        submission: const ActivitySubmission(
          selectedTokenIds: ['me', 'llamo', 'marta.distractor'],
        ),
      );
      expect(result.isCorrect, isTrue);
    },
  );

  test('propagates accepted-with-feedback through ActivityResult', () {
    final result = const ActivityEngine().evaluate(
      template: _accentTemplate,
      submission: const ActivitySubmission(submittedAnswer: 'que'),
    );

    expect(result.status, ActivityResultStatus.acceptedWithFeedback);
    expect(result.isCorrect, isTrue);
    expect(result.feedbackKey, 'answer.accepted_with_feedback');
    expect(result.evaluation?.feedback.canonicalAnswer, 'Qué');
  });

  test('propagates authored misconception feedback as incorrect', () {
    final result = const ActivityEngine().evaluate(
      template: _nameTextTemplate,
      submission: const ActivitySubmission(submittedAnswer: 'Soy Ana'),
    );

    expect(result.status, ActivityResultStatus.incorrect);
    expect(result.isCorrect, isFalse);
    expect(result.feedbackKey, 'spanish.name_pattern.use_me_llamo');
    expect(result.evaluation?.matchType, AnswerMatchType.authoredMisconception);
    expect(result.evaluation?.feedback.canonicalAnswer, 'Me llamo Ana');
  });

  test('propagates authored task-mismatch feedback as incorrect', () {
    final result = const ActivityEngine().evaluate(
      template: _questionExpectedTemplate,
      submission: const ActivitySubmission(submittedAnswer: 'Soy de Perú'),
    );

    expect(result.status, ActivityResultStatus.incorrect);
    expect(result.isCorrect, isFalse);
    expect(result.feedbackKey, 'response.question_expected_statement_provided');
    expect(result.evaluation?.matchType, AnswerMatchType.authoredMisconception);
  });

  test('evaluates matching correctly', () {
    final result = const ActivityEngine().evaluate(
      template: _matchingTemplate,
      submission: const ActivitySubmission(
        matchedPairs: {'hola': 'hello', 'adiós': 'goodbye'},
      ),
    );

    expect(result.isCorrect, isTrue);
    expect(result.matchedPairs, {'hola': 'hello', 'adiós': 'goodbye'});
  });

  test('evaluates localized Ukrainian matching meanings correctly', () {
    final result = const ActivityEngine().evaluate(
      template: _ukrainianMatchingTemplate,
      submission: const ActivitySubmission(
        matchedPairs: {
          'hola': 'привіт',
          'gracias': 'дякую',
          'no entiendo': 'я не розумію',
        },
      ),
    );

    expect(result.isCorrect, isTrue);
    expect(result.expectedAnswer, contains('hola = привіт'));
    expect(result.expectedAnswer, isNot(contains('/ɾ/')));
  });

  test('rejects swapped localized matching meanings', () {
    final result = const ActivityEngine().evaluate(
      template: _ukrainianMatchingTemplate,
      submission: const ActivitySubmission(
        matchedPairs: {
          'hola': 'дякую',
          'gracias': 'привіт',
          'no entiendo': 'я не розумію',
        },
      ),
    );

    expect(result.isCorrect, isFalse);
    expect(result.status, ActivityResultStatus.incorrect);
  });

  test('uses authored accepted answers for typed activities', () {
    final result = const ActivityEngine().evaluate(
      template: _acceptedAnswerTemplate,
      submission: const ActivitySubmission(submittedAnswer: 'Hi'),
    );

    expect(result.isCorrect, isTrue);
    expect(result.status, ActivityResultStatus.correct);
  });

  test('uses authored accepted-with-feedback answers for typed activities', () {
    final result = const ActivityEngine().evaluate(
      template: _acceptedWithFeedbackAnswerTemplate,
      submission: const ActivitySubmission(
        submittedAnswer: 'Me llamo Marta. Hola',
      ),
    );

    expect(result.isCorrect, isTrue);
    expect(result.status, ActivityResultStatus.acceptedWithFeedback);
    expect(result.feedbackKey, 'answer.preferred_order');
    expect(
      result.evaluation?.matchType,
      AnswerMatchType.acceptedAlternativeWithFeedback,
    );
  });

  test('accepts controlled contraction equivalents in matching activities', () {
    final result = const ActivityEngine().evaluate(
      template: _matchingMeaningTemplate,
      submission: const ActivitySubmission(
        matchedPairs: {'no entiendo': "I don't understand"},
      ),
    );

    expect(result.isCorrect, isTrue);
  });

  test('allows exact-form activities to reject support equivalents', () {
    final result = const ActivityEngine().evaluate(
      template: _exactFormTemplate,
      submission: const ActivitySubmission(
        submittedAnswer: "I don't understand",
      ),
    );

    expect(result.isCorrect, isFalse);
    expect(result.status, ActivityResultStatus.incorrect);
  });
}

const _multipleChoiceTemplate = ExerciseTemplate(
  id: 'template.choice',
  exerciseType: 'multiple_choice',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Choose the meaning.',
  answerOptions: [
    ExerciseTemplateOption(id: 'option.hello', label: 'hello'),
    ExerciseTemplateOption(id: 'option.goodbye', label: 'goodbye'),
  ],
  correctOptionId: 'option.hello',
);

const _fillGapTemplate = ExerciseTemplate(
  id: 'template.fill',
  exerciseType: 'fill_gap',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Complete: ____',
  expectedAnswer: 'Hola',
);

const _textEntryTemplate = ExerciseTemplate(
  id: 'template.text',
  exerciseType: 'text_entry',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Type the greeting.',
  expectedAnswer: 'Hola',
);

const _accentTemplate = ExerciseTemplate(
  id: 'template.accent',
  exerciseType: 'fill_gap',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Complete: ¿____ tal?',
  expectedAnswer: 'Qué',
);

const _nameTextTemplate = ExerciseTemplate(
  id: 'template.name.text',
  exerciseType: 'text_entry',
  supportedGoalTypes: ['review_grammar'],
  requiredObjectTypes: ['grammar'],
  promptTemplate: 'Type: My name is Ana.',
  expectedAnswer: 'Me llamo Ana',
  authoredMisconceptions: [
    AuthoredMisconception(
      id: 'misconception.name.soy_ana.v1',
      matchingAnswers: ['Soy Ana'],
      feedbackKey: 'spanish.name_pattern.use_me_llamo',
      canonicalAnswer: 'Me llamo Ana',
      explanationReferenceId: 'grammar.es.a0.unit1.name_pattern.v1',
    ),
  ],
);

const _questionExpectedTemplate = ExerciseTemplate(
  id: 'template.question.expected',
  exerciseType: 'text_entry',
  supportedGoalTypes: ['review_grammar'],
  requiredObjectTypes: ['grammar'],
  promptTemplate: 'Type the Spanish question: "Where are you from?"',
  expectedAnswer: '¿De dónde eres?',
  authoredMisconceptions: [
    AuthoredMisconception(
      id: 'misconception.question.expected.statement.v1',
      matchingAnswers: ['Soy de Perú'],
      feedbackKey: 'response.question_expected_statement_provided',
      canonicalAnswer: '¿De dónde eres?',
    ),
  ],
);

const _matchingTemplate = ExerciseTemplate(
  id: 'template.matching',
  exerciseType: 'matching',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Match greetings.',
  expectedAnswer: 'hola=hello; adiós=goodbye',
);

const _matchingMeaningTemplate = ExerciseTemplate(
  id: 'template.matching.meaning',
  exerciseType: 'matching',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Match meanings.',
  expectedAnswer: 'no entiendo=I do not understand',
);

const _ukrainianMatchingTemplate = ExerciseTemplate(
  id: 'template.matching.ukrainian.meaning',
  exerciseType: 'matching',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Введіть українське значення для кожної іспанської форми.',
  expectedAnswer: 'hola=привіт;gracias=дякую;no entiendo=я не розумію',
);

const _acceptedAnswerTemplate = ExerciseTemplate(
  id: 'template.accepted.answer',
  exerciseType: 'text_entry',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Type another accepted English greeting.',
  expectedAnswer: 'Hello',
  acceptedAnswers: ['Hi'],
);

const _acceptedWithFeedbackAnswerTemplate = ExerciseTemplate(
  id: 'template.accepted.feedback.answer',
  exerciseType: 'text_entry',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Greet and introduce yourself.',
  expectedAnswer: 'Hola. Me llamo Marta',
  acceptedWithFeedbackAnswers: [
    AcceptedWithFeedbackAnswer(
      answer: 'Me llamo Marta. Hola',
      feedbackKey: 'answer.preferred_order',
      canonicalAnswer: 'Hola. Me llamo Marta',
    ),
  ],
);

const _exactFormTemplate = ExerciseTemplate(
  id: 'template.exact.form',
  exerciseType: 'text_entry',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Type the exact full English form.',
  expectedAnswer: 'I do not understand',
  requiresExactAnswer: true,
);

const _guidedDialogueTemplate = ExerciseTemplate(
  id: 'template.guided.test',
  exerciseType: 'guided_dialogue',
  supportedGoalTypes: ['test'],
  requiredObjectTypes: ['dialogue'],
  promptTemplate: 'Reply.',
  guidedDialogue: GuidedDialogue(
    turns: [
      GuidedDialogueTurn(
        speaker: 'Ana',
        text: '¿De dónde eres?',
        learner: false,
        audioReferenceId: 'es.audio.question.de_donde_eres',
      ),
      GuidedDialogueTurn(
        speaker: 'Tú',
        text: 'Soy de {place}.',
        learner: true,
        responsePatterns: ['Soy de {place}.'],
        responseMode: 'prefix_with_value',
        allowedSlots: {
          'place': ['Ucrania', 'España'],
        },
      ),
    ],
  ),
);
