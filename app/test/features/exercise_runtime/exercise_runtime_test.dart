import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/exercise_runtime/answer_checker.dart';
import 'package:tutor_language/features/exercise_runtime/exercise_runtime_models.dart';
import 'package:tutor_language/features/exercise_runtime/exercise_runtime_widget.dart';

void main() {
  test('exercise runtime model creation', () {
    const template = ExerciseTemplate(
      id: 'template.multiple_choice_basic.v1',
      exerciseType: 'multiple_choice',
      supportedGoalTypes: ['introduce_vocabulary'],
      requiredObjectTypes: ['vocabulary'],
      promptTemplate: 'Choose the correct meaning.',
      answerOptions: [
        ExerciseTemplateOption(id: 'option.hello', label: 'hello'),
      ],
      correctOptionId: 'option.hello',
    );

    final session = ExerciseSession.fromTemplate(template);

    expect(session.id, 'session.template.multiple_choice_basic.v1');
    expect(session.items, hasLength(1));
    expect(session.items.single.templateId, template.id);
    expect(session.items.single.interactionType, 'multiple_choice');
    expect(session.items.single.prompt, 'Choose the correct meaning.');
    expect(session.items.single.answerOptions.single.id, 'option.hello');
    expect(session.items.single.expectedAnswerId, 'option.hello');
  });

  test('multiple-choice correct answer', () {
    final result = const AnswerChecker().check(
      AnswerCheckInput(
        item: _choiceSession.items.single,
        response: _responseFor(_choiceSession.items.single, _helloAnswer),
        expectedAnswer: const ExpectedAnswer(answerId: 'answer.hello'),
      ),
    );

    expect(result.status, AnswerCheckStatus.correct);
  });

  test('multiple-choice incorrect answer', () {
    final result = const AnswerChecker().check(
      AnswerCheckInput(
        item: _choiceSession.items.single,
        response: _responseFor(_choiceSession.items.single, _goodbyeAnswer),
        expectedAnswer: const ExpectedAnswer(answerId: 'answer.hello'),
      ),
    );

    expect(result.status, AnswerCheckStatus.incorrect);
  });

  test('text-entry normalized correct answer', () {
    final result = const AnswerChecker().check(
      AnswerCheckInput(
        item: _textEntryItem,
        response: _responseFor(
          _textEntryItem,
          const ExerciseAnswer(id: 'typed', label: '  HELLO   there '),
        ),
        expectedAnswer: const ExpectedAnswer(text: 'hello there'),
      ),
    );

    expect(result.status, AnswerCheckStatus.correct);
  });

  test('text-entry incorrect answer', () {
    final result = const AnswerChecker().check(
      AnswerCheckInput(
        item: _textEntryItem,
        response: _responseFor(
          _textEntryItem,
          const ExerciseAnswer(id: 'typed', label: 'goodbye'),
        ),
        expectedAnswer: const ExpectedAnswer(text: 'hello there'),
      ),
    );

    expect(result.status, AnswerCheckStatus.incorrect);
  });

  test('unsupported exercise type', () {
    final result = const AnswerChecker().check(
      AnswerCheckInput(
        item: _unsupportedItem,
        response: _responseFor(
          _unsupportedItem,
          const ExerciseAnswer(id: 'answer', label: 'hello'),
        ),
        expectedAnswer: const ExpectedAnswer(text: 'hello'),
      ),
    );

    expect(result.status, AnswerCheckStatus.unsupported);
  });

  test('exercise interaction state stores local response', () {
    const answer = ExerciseAnswer(id: 'answer.hello', label: 'hello');
    final response = ExerciseResponse(
      itemId: 'item.greeting',
      answer: answer,
      respondedAt: DateTime.utc(2026),
    );

    final state = const ExerciseInteractionState().recordResponse(response);

    expect(state.responseFor('item.greeting'), response);
    expect(state.responseFor('item.other'), isNull);
  });

  testWidgets('selecting an answer updates local state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ExerciseRuntimeWidget(session: _choiceSession)),
      ),
    );

    await tester.tap(find.text('hello'));
    await tester.pump();

    expect(find.text('Selected answer: hello'), findsOneWidget);
  });

  testWidgets('UI displays result after checking', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ExerciseRuntimeWidget(session: _choiceSession)),
      ),
    );

    await tester.tap(find.text('hello'));
    await tester.pump();
    await tester.tap(find.text('Check answer'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
  });

  testWidgets('exercise runtime does not show scoring, progress, or mastery', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ExerciseRuntimeWidget(session: _choiceSession)),
      ),
    );

    await tester.tap(find.text('hello'));
    await tester.pump();
    await tester.tap(find.text('Check answer'));
    await tester.pump();

    expect(find.textContaining('Score'), findsNothing);
    expect(find.textContaining('score'), findsNothing);
    expect(find.textContaining('Grade'), findsNothing);
    expect(find.textContaining('Percentage'), findsNothing);
    expect(find.textContaining('Progress'), findsNothing);
    expect(find.textContaining('progress'), findsNothing);
    expect(find.textContaining('Mastery'), findsNothing);
    expect(find.textContaining('mastery'), findsNothing);
  });
}

ExerciseResponse _responseFor(ExerciseItem item, ExerciseAnswer answer) {
  return ExerciseResponse(
    itemId: item.id,
    answer: answer,
    respondedAt: DateTime.utc(2026),
  );
}

const _helloAnswer = ExerciseAnswer(id: 'answer.hello', label: 'hello');
const _goodbyeAnswer = ExerciseAnswer(id: 'answer.goodbye', label: 'goodbye');

const _choiceSession = ExerciseSession(
  id: 'session.greeting',
  items: [
    ExerciseItem(
      id: 'item.greeting',
      templateId: 'template.multiple_choice_basic.v1',
      interactionType: 'multiple_choice',
      prompt: 'Choose the matching meaning.',
      answerOptions: [_helloAnswer, _goodbyeAnswer],
      expectedAnswerId: 'answer.hello',
    ),
  ],
);

const _textEntryItem = ExerciseItem(
  id: 'item.text',
  templateId: 'template.text_entry.v1',
  interactionType: 'text_entry',
  prompt: 'Type the phrase.',
  expectedTextAnswer: 'hello there',
);

const _unsupportedItem = ExerciseItem(
  id: 'item.unsupported',
  templateId: 'template.unsupported.v1',
  interactionType: 'matching',
  prompt: 'Match the items.',
);
