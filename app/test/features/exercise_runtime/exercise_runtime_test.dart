import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/topic_content.dart';
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
    );

    final session = ExerciseSession.fromTemplate(template);

    expect(session.id, 'session.template.multiple_choice_basic.v1');
    expect(session.items, hasLength(1));
    expect(session.items.single.templateId, template.id);
    expect(session.items.single.interactionType, 'multiple_choice');
    expect(session.items.single.prompt, 'Choose the correct meaning.');
    expect(session.items.single.answerOptions, isEmpty);
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

  testWidgets('exercise runtime does not show scoring or correctness', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ExerciseRuntimeWidget(session: _choiceSession)),
      ),
    );

    await tester.tap(find.text('hello'));
    await tester.pump();

    expect(find.textContaining('correct'), findsNothing);
    expect(find.textContaining('incorrect'), findsNothing);
    expect(find.textContaining('score'), findsNothing);
    expect(find.textContaining('progress'), findsNothing);
  });
}

const _choiceSession = ExerciseSession(
  id: 'session.greeting',
  items: [
    ExerciseItem(
      id: 'item.greeting',
      templateId: 'template.multiple_choice_basic.v1',
      interactionType: 'multiple_choice',
      prompt: 'Choose the matching meaning.',
      answerOptions: [
        ExerciseAnswer(id: 'answer.hello', label: 'hello'),
        ExerciseAnswer(id: 'answer.goodbye', label: 'goodbye'),
      ],
    ),
  ],
);
