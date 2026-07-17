import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/exercise_runtime/answer_check_models.dart';
import 'package:tutor_language/features/exercise_runtime/answer_checker.dart';
import 'package:tutor_language/features/exercise_runtime/exercise_runtime_models.dart';
import 'package:tutor_language/features/exercise_runtime/exercise_runtime_widget.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

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

  test('exercise runtime model carries typed accepted answers', () {
    const template = ExerciseTemplate(
      id: 'template.typed.accepted.v1',
      exerciseType: 'fill_gap',
      supportedGoalTypes: ['review_vocabulary'],
      requiredObjectTypes: ['vocabulary'],
      promptTemplate: 'Type the greeting.',
      expectedAnswer: 'hola',
      acceptedAnswers: ['Hola'],
      acceptedWithFeedbackAnswers: [
        AcceptedWithFeedbackAnswer(
          answer: 'ola',
          feedbackKey: 'answer.keep_silent_h',
          canonicalAnswer: 'hola',
        ),
      ],
    );

    final item = ExerciseSession.fromTemplate(template).items.single;

    expect(item.interactionType, 'fill_gap');
    expect(item.acceptedTextAnswers, ['Hola']);
    expect(
      item.acceptedWithFeedbackAnswers.single.feedbackKey,
      'answer.keep_silent_h',
    );
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
    expect(result.feedbackKey, 'answer.correct');
  });

  test('text-entry accepted alternative answer', () {
    final result = const AnswerChecker().check(
      AnswerCheckInput(
        item: _textEntryItem,
        response: _responseFor(
          _textEntryItem,
          const ExerciseAnswer(id: 'typed', label: 'hi there'),
        ),
        expectedAnswer: const ExpectedAnswer(
          text: 'hello there',
          acceptedTextAnswers: ['hi there'],
        ),
      ),
    );

    expect(result.status, AnswerCheckStatus.correct);
    expect(result.feedbackKey, 'answer.correct');
  });

  test('text-entry accepted with orthographic feedback', () {
    final result = const AnswerChecker().check(
      AnswerCheckInput(
        item: _textEntryItem,
        response: _responseFor(
          _textEntryItem,
          const ExerciseAnswer(id: 'typed', label: 'que'),
        ),
        expectedAnswer: const ExpectedAnswer(text: 'qué'),
      ),
    );

    expect(result.status, AnswerCheckStatus.acceptedWithFeedback);
    expect(result.feedbackKey, 'answer.accepted_with_feedback');
  });

  test('fill-gap accepted-with-feedback answer is supported', () {
    final result = const AnswerChecker().check(
      AnswerCheckInput(
        item: _fillGapItem,
        response: _responseFor(
          _fillGapItem,
          const ExerciseAnswer(id: 'typed', label: 'ola'),
        ),
        expectedAnswer: const ExpectedAnswer(
          text: 'hola',
          acceptedWithFeedbackAnswers: [
            AcceptedWithFeedbackAnswer(
              answer: 'ola',
              feedbackKey: 'answer.keep_silent_h',
              canonicalAnswer: 'hola',
            ),
          ],
        ),
      ),
    );

    expect(result.status, AnswerCheckStatus.acceptedWithFeedback);
    expect(result.feedbackKey, 'answer.keep_silent_h');
  });

  test('text-entry authored misconception remains incorrect with feedback', () {
    final result = const AnswerChecker().check(
      AnswerCheckInput(
        item: _textEntryItem,
        response: _responseFor(
          _textEntryItem,
          const ExerciseAnswer(id: 'typed', label: 'Soy Ana'),
        ),
        expectedAnswer: const ExpectedAnswer(
          text: 'Me llamo Ana',
          authoredMisconceptions: [
            AuthoredMisconception(
              id: 'misconception.name.soy_ana.v1',
              matchingAnswers: ['Soy Ana'],
              feedbackKey: 'spanish.name_pattern.use_me_llamo',
              canonicalAnswer: 'Me llamo Ana',
              explanationReferenceId: 'grammar.es.a0.unit1.name_pattern.v1',
            ),
          ],
        ),
      ),
    );

    expect(result.status, AnswerCheckStatus.incorrect);
    expect(result.feedbackKey, 'spanish.name_pattern.use_me_llamo');
    expect(result.explanationReference, 'grammar.es.a0.unit1.name_pattern.v1');
  });

  test('exercise session carries authored misconceptions from template', () {
    const template = ExerciseTemplate(
      id: 'template.name',
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
        ),
      ],
    );

    final session = ExerciseSession.fromTemplate(template);

    expect(session.items.single.authoredMisconceptions, hasLength(1));
    expect(
      session.items.single.authoredMisconceptions.single.id,
      'misconception.name.soy_ana.v1',
    );
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
    expect(result.feedbackKey, 'answer.unsupported');
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
      _localizedApp(
        const Scaffold(body: ExerciseRuntimeWidget(session: _choiceSession)),
      ),
    );

    await tester.tap(find.text('hello'));
    await tester.pump();

    expect(find.text('Selected answer: hello'), findsOneWidget);
  });

  testWidgets('UI displays result after checking', (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(body: ExerciseRuntimeWidget(session: _choiceSession)),
      ),
    );

    await tester.tap(find.text('hello'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
  });

  testWidgets('runtime emits progress-neutral callback events', (tester) async {
    final events = <ExerciseRuntimeEvent>[];

    await tester.pumpWidget(
      _localizedApp(
        Scaffold(
          body: ExerciseRuntimeWidget(
            session: _choiceSession,
            onRuntimeEvent: events.add,
          ),
        ),
      ),
    );

    await tester.tap(find.text('hello'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(events.map((event) => event.eventType), [
      ExerciseRuntimeEventType.answerSelected,
      ExerciseRuntimeEventType.answerChecked,
    ]);
    expect(events.last.answerCheckStatus, AnswerCheckStatus.correct);
  });

  testWidgets('exercise runtime does not show scoring, progress, or mastery', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(body: ExerciseRuntimeWidget(session: _choiceSession)),
      ),
    );

    await tester.tap(find.text('hello'));
    await tester.pump();
    await tester.tap(find.text('Check'));
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

  test('runtime and checker do not import progress persistence', () {
    final runtimeSource = File(
      'lib/features/exercise_runtime/exercise_runtime_widget.dart',
    ).readAsStringSync();
    final checkerSource = File(
      'lib/features/exercise_runtime/answer_checker.dart',
    ).readAsStringSync();

    expect(runtimeSource, isNot(contains('learner_progress_repository')));
    expect(runtimeSource, isNot(contains('app_database')));
    expect(checkerSource, isNot(contains('learner_progress')));
    expect(checkerSource, isNot(contains('app_database')));
  });
}

ExerciseResponse _responseFor(ExerciseItem item, ExerciseAnswer answer) {
  return ExerciseResponse(
    itemId: item.id,
    answer: answer,
    respondedAt: DateTime.utc(2026),
  );
}

Widget _localizedApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(useMaterial3: false),
    home: child,
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

const _fillGapItem = ExerciseItem(
  id: 'item.fill',
  templateId: 'template.fill',
  interactionType: 'fill_gap',
  prompt: 'Complete the word.',
  expectedTextAnswer: 'hola',
);

const _unsupportedItem = ExerciseItem(
  id: 'item.unsupported',
  templateId: 'template.unsupported.v1',
  interactionType: 'matching',
  prompt: 'Match the items.',
);
