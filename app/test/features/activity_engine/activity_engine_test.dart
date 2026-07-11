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

const _matchingTemplate = ExerciseTemplate(
  id: 'template.matching',
  exerciseType: 'matching',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Match greetings.',
  expectedAnswer: 'hola=hello; adiós=goodbye',
);
