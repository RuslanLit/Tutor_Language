import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/activity_engine/activity_widgets.dart';

void main() {
  testWidgets('fill_gap widget checks normalized answer', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ActivityTemplateWidget(template: _fillGapTemplate),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '  hOlA ');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
  });

  testWidgets('text_entry widget renders typed input and checks answer', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ActivityTemplateWidget(template: _textEntryTemplate),
        ),
      ),
    );

    expect(find.text('Type the greeting.'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'hola');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
  });

  testWidgets(
    'accepted-with-feedback renders canonical answer and corrections',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ActivityTemplateWidget(template: _questionTemplate),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'que tal?');
      await tester.tap(find.text('Check'));
      await tester.pump();

      expect(find.text('Accepted with correction'), findsOneWidget);
      expect(find.text('Canonical answer: ¿Qué tal?'), findsOneWidget);
      expect(find.text('- Spanish questions begin with "¿".'), findsOneWidget);
      expect(
        find.text('- "qué" requires an accent in this question.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('editing and resubmitting clears stale feedback', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ActivityTemplateWidget(template: _questionTemplate),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'que tal?');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Accepted with correction'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '¿Qué tal?');
    await tester.pump();

    expect(find.text('Accepted with correction'), findsNothing);

    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
    expect(find.text('Canonical answer: ¿Qué tal?'), findsNothing);
  });

  testWidgets('feedback does not leak between typed activities', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ActivityTemplateWidget(template: _questionTemplate),
              ActivityTemplateWidget(template: _textEntryTemplate),
            ],
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'que tal?');
    await tester.tap(find.text('Check').first);
    await tester.pump();

    expect(find.text('Accepted with correction'), findsOneWidget);
    expect(find.text('Correct'), findsNothing);
  });

  testWidgets('matching widget checks submitted pairs', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ActivityTemplateWidget(template: _matchingTemplate),
        ),
      ),
    );

    await tester.enterText(find.widgetWithText(TextField, 'hola'), 'hello');
    await tester.enterText(find.widgetWithText(TextField, 'adiós'), 'goodbye');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
  });
}

const _fillGapTemplate = ExerciseTemplate(
  id: 'template.widget.fill',
  exerciseType: 'fill_gap',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Complete: ____',
  expectedAnswer: 'Hola',
);

const _textEntryTemplate = ExerciseTemplate(
  id: 'template.widget.text',
  exerciseType: 'text_entry',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Type the greeting.',
  expectedAnswer: 'Hola',
);

const _questionTemplate = ExerciseTemplate(
  id: 'template.widget.question',
  exerciseType: 'fill_gap',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Type the question.',
  expectedAnswer: '¿Qué tal?',
);

const _matchingTemplate = ExerciseTemplate(
  id: 'template.widget.matching',
  exerciseType: 'matching',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Match greetings.',
  expectedAnswer: 'hola=hello; adiós=goodbye',
);
