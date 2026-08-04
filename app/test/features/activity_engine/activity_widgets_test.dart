import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/activity_engine/activity_template_state.dart';
import 'package:tutor_language/features/activity_engine/activity_widgets.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('fill_gap widget checks normalized answer', (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(
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
      _localizedApp(
        const Scaffold(
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

  testWidgets('parent rebuild does not erase active typed input', (
    tester,
  ) async {
    var state = const ActivityTemplateState();

    await tester.pumpWidget(
      _localizedApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: ActivityTemplateWidget(
                template: _textEntryTemplate,
                state: state,
                onStateChanged: (nextState) {
                  setState(() {
                    state = nextState;
                  });
                },
              ),
            );
          },
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'hola');
    await tester.pump();

    // Model the stale parent snapshot that can occur during rapid input.
    state = const ActivityTemplateState();
    await tester.pump();

    expect(find.byType(TextField), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'hola',
    );
  });

  testWidgets('activity prompt is exposed to accessibility semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(
          body: ActivityTemplateWidget(template: _textEntryTemplate),
        ),
      ),
    );

    expect(
      find.bySemanticsLabel('Exercise prompt: Type the greeting.'),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets(
    'accepted-with-feedback renders canonical answer and corrections',
    (tester) async {
      await tester.pumpWidget(
        _localizedApp(
          const Scaffold(
            body: ActivityTemplateWidget(template: _questionTemplate),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'que tal?');
      await tester.tap(find.text('Check'));
      await tester.pump();

      expect(find.text('Accepted with correction'), findsOneWidget);
      expect(find.text('Recommended answer: ¿Qué tal?'), findsOneWidget);
      expect(find.text('- Spanish questions begin with "¿".'), findsOneWidget);
      expect(
        find.text('- "qué" requires an accent in this question.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('editing and resubmitting clears stale feedback', (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(
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
    expect(find.text('Recommended answer: ¿Qué tal?'), findsNothing);
  });

  testWidgets('authored misconception explanation renders and resubmits', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(body: ActivityTemplateWidget(template: _nameTemplate)),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Soy Ana');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Not correct yet'), findsOneWidget);
    expect(find.text('Recommended answer: Me llamo Ana'), findsOneWidget);
    expect(
      find.text('- For this introduction pattern, use "me llamo".'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), 'Me llamo Ana');
    await tester.pump();

    expect(find.text('Not correct yet'), findsNothing);

    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
    expect(find.text('Recommended answer: Me llamo Ana'), findsNothing);
  });

  testWidgets('generic incorrect remains neutral', (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(body: ActivityTemplateWidget(template: _nameTemplate)),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Hasta luego');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Not correct yet'), findsOneWidget);
    expect(find.text('Recommended answer: Me llamo Ana'), findsOneWidget);
    expect(find.textContaining('me llamo'), findsNothing);
  });

  testWidgets('task-mismatch feedback becomes more helpful after retries', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(
          body: ActivityTemplateWidget(template: _questionExpectedTemplate),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Soy de Perú');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Not correct yet'), findsOneWidget);
    expect(
      find.text(
        '- This exercise asks for a question.\nYou wrote an answer.\nTry writing the Spanish question instead.',
      ),
      findsOneWidget,
    );
    expect(find.text('- Questions begin with: ¿...'), findsNothing);

    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('- Questions begin with: ¿...'), findsOneWidget);

    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('- Starts with: ¿De'), findsOneWidget);
  });

  testWidgets('long text_entry widget uses multiline editing', (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(body: ActivityTemplateWidget(template: _longTemplate)),
      ),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));

    expect(textField.minLines, 3);
    expect(textField.maxLines, 8);
    expect(textField.keyboardType, TextInputType.multiline);
    expect(textField.textInputAction, TextInputAction.newline);
  });

  testWidgets('short text_entry widget remains single-line', (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(
          body: ActivityTemplateWidget(template: _textEntryTemplate),
        ),
      ),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));

    expect(textField.minLines, 1);
    expect(textField.maxLines, 1);
    expect(textField.keyboardType, TextInputType.text);
    expect(textField.textInputAction, TextInputAction.done);
  });

  testWidgets('feedback does not leak between typed activities', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(
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
      _localizedApp(
        const Scaffold(
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

  testWidgets('matching widget does not prefill localized answers', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(
          body: ActivityTemplateWidget(template: _ukrainianMatchingTemplate),
        ),
      ),
    );

    expect(find.widgetWithText(TextField, 'hola'), findsOneWidget);
    expect(find.text('привіт'), findsNothing);
    expect(find.text('дякую'), findsNothing);
    expect(find.text('я не розумію'), findsNothing);
  });
}

Widget _localizedApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(useMaterial3: false),
    home: child,
  );
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

const _nameTemplate = ExerciseTemplate(
  id: 'template.widget.name',
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
  id: 'template.widget.question.expected',
  exerciseType: 'text_entry',
  supportedGoalTypes: ['review_grammar'],
  requiredObjectTypes: ['grammar'],
  promptTemplate: 'Type the Spanish question: "Where are you from?"',
  expectedAnswer: '¿De dónde eres?',
  authoredMisconceptions: [
    AuthoredMisconception(
      id: 'misconception.widget.question.expected.statement.v1',
      matchingAnswers: ['Soy de Perú'],
      feedbackKey: 'response.question_expected_statement_provided',
      canonicalAnswer: '¿De dónde eres?',
    ),
  ],
);

const _longTemplate = ExerciseTemplate(
  id: 'template.widget.long',
  exerciseType: 'text_entry',
  supportedGoalTypes: ['review_grammar'],
  requiredObjectTypes: ['grammar'],
  promptTemplate:
      'Write the short profile in Spanish using the details from the prompt.',
  expectedAnswer:
      'Me llamo Marta. Soy de Colombia. Vivo en Lima. Hablo español.',
);

const _matchingTemplate = ExerciseTemplate(
  id: 'template.widget.matching',
  exerciseType: 'matching',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Match greetings.',
  expectedAnswer: 'hola=hello; adiós=goodbye',
);

const _ukrainianMatchingTemplate = ExerciseTemplate(
  id: 'template.widget.matching.ukrainian',
  exerciseType: 'matching',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['vocabulary'],
  promptTemplate: 'Введіть українське значення для кожної іспанської форми.',
  expectedAnswer: 'hola=привіт; gracias=дякую; no entiendo=я не розумію',
);
