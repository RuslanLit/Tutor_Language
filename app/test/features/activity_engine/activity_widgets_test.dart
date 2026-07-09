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

const _matchingTemplate = ExerciseTemplate(
  id: 'template.widget.matching',
  exerciseType: 'matching',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Match greetings.',
  expectedAnswer: 'hola=hello; adiós=goodbye',
);
