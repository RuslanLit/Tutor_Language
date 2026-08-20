import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/audio/reference_audio.dart';
import 'package:tutor_language/core/audio/reference_audio_button.dart';
import 'package:tutor_language/core/audio/reference_audio_providers.dart';
import 'package:tutor_language/core/content/audio_reference_models.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/activity_engine/activity_engine.dart';
import 'package:tutor_language/features/activity_engine/activity_result.dart';
import 'package:tutor_language/features/activity_engine/activity_template_state.dart';
import 'package:tutor_language/features/activity_engine/activity_widgets.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

void main() {
  testWidgets(
    'sentence builder plays approved reference audio only after success',
    (tester) async {
      final backend = _SentenceBuilderFakeBackend();
      final service = ReferenceAudioPlaybackService(
        repository: Future.value(
          ReferenceAudioRepository(_sentenceBuilderManifest),
        ),
        backend: backend,
      );

      await tester.pumpWidget(
        _localizedApp(
          const Scaffold(
            body: ActivityTemplateWidget(template: _sentenceBuilderTemplate),
          ),
          overrides: [
            referenceAudioPlaybackServiceProvider.overrideWithValue(service),
          ],
        ),
      );
      expect(backend.playCalls, 0);
      expect(find.byType(ReferenceAudioButton), findsNothing);

      await tester.tap(find.widgetWithText(ActionChip, 'Hola.'));
      await tester.pump();
      await tester.tap(find.text('Check'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Hola.'), findsAtLeastNWidgets(2));
      expect(find.byType(ReferenceAudioButton), findsOneWidget);
      expect(backend.playCalls, 1);

      await tester.pump();
      expect(backend.playCalls, 1);
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(backend.playCalls, 2);
      await service.dispose();
    },
  );

  testWidgets('incorrect sentence builder answer does not play target audio', (
    tester,
  ) async {
    final backend = _SentenceBuilderFakeBackend();
    final service = ReferenceAudioPlaybackService(
      repository: Future.value(
        ReferenceAudioRepository(_sentenceBuilderManifest),
      ),
      backend: backend,
    );
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(
          body: ActivityTemplateWidget(template: _sentenceBuilderWrongTemplate),
        ),
        overrides: [
          referenceAudioPlaybackServiceProvider.overrideWithValue(service),
        ],
      ),
    );
    await tester.tap(find.widgetWithText(ActionChip, 'Adiós.'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();
    expect(backend.playCalls, 0);
    expect(find.byType(ReferenceAudioButton), findsNothing);

    await service.dispose();
  });

  testWidgets('sentence builder labels are localized in Ukrainian', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(
          body: ActivityTemplateWidget(template: _sentenceBuilderTemplate),
        ),
        locale: const Locale('uk'),
      ),
    );

    expect(find.text('Твоя відповідь'), findsOneWidget);
    expect(find.text('Доступні слова'), findsOneWidget);
    expect(find.text('Очистити'), findsOneWidget);
    expect(find.text('YOUR ANSWER'), findsNothing);
    expect(find.text('AVAILABLE WORDS'), findsNothing);
    expect(find.text('Reset'), findsNothing);
  });

  testWidgets(
    'sentence builder keeps one shuffled pool across rebuild and clear',
    (tester) async {
      await tester.pumpWidget(
        _localizedApp(
          const Scaffold(
            body: ActivityTemplateWidget(
              template: _shuffledSentenceBuilderTemplate,
            ),
          ),
        ),
      );
      final initial = _actionChipLabels(tester);
      expect(initial, isNot(equals(['¿Cómo', 'te', 'llamas?', 'Soy', 'de'])));
      expect(initial, containsAll(['¿Cómo', 'te', 'llamas?', 'Soy', 'de']));

      await tester.pumpWidget(
        _localizedApp(
          const Scaffold(
            body: ActivityTemplateWidget(
              template: _shuffledSentenceBuilderTemplate,
            ),
          ),
        ),
      );
      expect(_actionChipLabels(tester), initial);

      await tester.tap(find.widgetWithText(ActionChip, '¿Cómo'));
      await tester.pump();
      await tester.tap(find.text('Clear'));
      await tester.pump();
      expect(_actionChipLabels(tester), initial);

      await tester.tap(find.widgetWithText(ActionChip, 'de'));
      await tester.pump();
      await tester.tap(find.text('Check'));
      await tester.pump();
      expect(find.text('Correct'), findsNothing);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pump();
      expect(_actionChipLabels(tester), initial);
    },
  );

  testWidgets(
    'guided dialogue opens on the first learner turn, not an audio-only state',
    (tester) async {
      final template = _canonicalLesson2Templates().first;

      await tester.pumpWidget(
        _localizedApp(
          Scaffold(body: ActivityTemplateWidget(template: template)),
          locale: const Locale('uk'),
        ),
      );

      expect(find.text('Hola. Buenos días.'), findsOneWidget);
      expect(find.text('Me llamo Marta.'), findsOneWidget);
      expect(find.text('¿Cómo te llamas?'), findsOneWidget);
      expect(find.text('Ти'), findsOneWidget);
      expect(find.text('Діалог 1 / 6'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Перевірити'), findsOneWidget);
    },
  );

  testWidgets('guided dialogue keeps incorrect response on the same turn', (
    tester,
  ) async {
    final template = _canonicalLesson2Templates().first;

    await tester.pumpWidget(
      _localizedApp(
        Scaffold(body: ActivityTemplateWidget(template: template)),
        locale: const Locale('uk'),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Soy Marta.');
    await tester.tap(find.text('Перевірити'));
    await tester.pump();

    expect(find.text('¿Cómo te llamas?'), findsOneWidget);
    expect(find.text('Діалог 1 / 6'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Перевірити'), findsOneWidget);
  });

  testWidgets('accepted guided response advances to the next turn group', (
    tester,
  ) async {
    final template = _canonicalLesson2Templates().first;

    await tester.pumpWidget(
      _localizedApp(
        Scaffold(body: ActivityTemplateWidget(template: template)),
        locale: const Locale('uk'),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Me llamo Ana.');
    await tester.tap(find.text('Перевірити'));
    await tester.pump();

    expect(find.text('Mucho gusto.'), findsOneWidget);
    expect(find.text('¿De dónde eres?'), findsOneWidget);
    expect(find.text('Ти'), findsOneWidget);
    expect(find.text('Діалог 2 / 6'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('final learner response renders authored closing turn', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(
          body: ActivityTemplateWidget(template: _closingDialogueTemplate),
        ),
        locale: Locale('uk'),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Hasta luego.');
    await tester.tap(find.text('Перевірити'));
    await tester.pump();

    expect(find.text('Gracias.'), findsOneWidget);
    expect(find.text('Діалог 1 / 1'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

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

  testWidgets(
    'Lesson 2 incomplete multiline feedback remains visible when remediation is hidden',
    (tester) async {
      final template = _canonicalLesson2Templates().firstWhere(
        (template) =>
            template.id ==
            'template.es.a0.m01.l002.independent_complete_intro_dialogue',
      );

      await tester.pumpWidget(
        _localizedApp(
          Scaffold(
            body: ActivityTemplateWidget(
              template: template,
              showIncorrectDetails: false,
            ),
          ),
          locale: const Locale('uk'),
        ),
      );

      await tester.enterText(
        find.byType(TextField),
        'Hola. Buenos días.\n'
        'Me llamo Marta.\n'
        '¿Cómo te llamas?\n'
        'Me llamo Ana.\n'
        'Mucho gusto.\n'
        '¿De dónde eres?\n'
        'Soy de Ucrania.\n'
        '¿Dónde vives?',
      );
      await tester.tap(find.text('Перевірити'));
      await tester.pump();

      expect(
        find.textContaining('Введено 8 реплік. Доповни діалог.'),
        findsOneWidget,
      );
      expect(find.text('Спробувати ще раз'), findsNothing);
    },
  );

  testWidgets('Lesson 2 near-complete answer shows incorrect line numbers', (
    tester,
  ) async {
    final template = _canonicalLesson2Templates().firstWhere(
      (template) =>
          template.id ==
          'template.es.a0.m01.l002.independent_complete_intro_dialogue',
    );

    await tester.pumpWidget(
      _localizedApp(
        Scaffold(
          body: ActivityTemplateWidget(
            template: template,
            showIncorrectDetails: false,
          ),
        ),
        locale: const Locale('uk'),
      ),
    );

    await tester.enterText(
      find.byType(TextField),
      'Hola. Buenos días.\n'
      'Me llamo Marta.\n'
      '¿Cómo te llamas?\n'
      'Me llamo Ana.\n'
      'Mucho gusto.\n'
      '¿De dónde eres?\n'
      'Soy de Ucrania.\n'
      '¿Dónde vives?\n'
      'Vivo en Lima.\n'
      '¿Qué idiomas hablas?\n'
      'Hablo francés e inglés.\n'
      'También hablo inglés. Hablo un poco de español.\n'
      'No hablo francés.\n'
      'Gracias. Hasta luego.',
    );
    await tester.tap(find.text('Перевірити'));
    await tester.pump();

    expect(
      find.textContaining('12 з 14 реплік правильні. Перевір репліки: 9, 11.'),
      findsOneWidget,
    );
  });

  test('Lesson 2 authored 13, 14, and 15 line variants are accepted', () {
    final template = _canonicalLesson2Templates().firstWhere(
      (template) =>
          template.id ==
          'template.es.a0.m01.l002.independent_complete_intro_dialogue',
    );
    final engine = const ActivityEngine();
    final variants = [
      template.acceptedAnswers.first,
      template.expectedAnswer!,
      template.expectedAnswer!.replaceFirst(
        'También hablo inglés. Hablo un poco de español.',
        'También hablo inglés.\nHablo un poco de español.',
      ),
    ];

    for (final answer in variants) {
      final result = engine.evaluate(
        template: template,
        submission: ActivitySubmission(submittedAnswer: answer),
      );
      expect(result.isCorrect, isTrue, reason: answer);
    }
  });

  test('Lesson 2 wrong French-person form remains incorrect', () {
    final template = _canonicalLesson2Templates().firstWhere(
      (template) =>
          template.id ==
          'template.es.a0.m01.l002.independent_complete_intro_dialogue',
    );
    final answer = template.expectedAnswer!.replaceFirst(
      'No hablo francés.',
      'No habla francés.',
    );
    final result = const ActivityEngine().evaluate(
      template: template,
      submission: ActivitySubmission(submittedAnswer: answer),
    );

    expect(result.isCorrect, isFalse);
    expect(result.evaluation?.feedback.structure?.incorrectLineNumbers, [13]);
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

  testWidgets('canonical Lesson 1 final answer uses multiline editing', (
    tester,
  ) async {
    final template = _canonicalLesson1Templates().firstWhere(
      (template) =>
          template.id == 'template.es.a0.m01.l001.independent_full_contact',
    );

    await tester.pumpWidget(
      _localizedApp(Scaffold(body: ActivityTemplateWidget(template: template))),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));

    expect(textField.minLines, 3);
    expect(textField.maxLines, 8);
    expect(textField.keyboardType, TextInputType.multiline);
    expect(textField.textInputAction, TextInputAction.newline);
  });

  testWidgets('canonical Lesson 1 Step 4 uses multiline editing', (
    tester,
  ) async {
    final template = _canonicalLesson1Templates().firstWhere(
      (template) =>
          template.id == 'template.es.a0.m01.l001.guided_full_contact',
    );

    await tester.pumpWidget(
      _localizedApp(Scaffold(body: ActivityTemplateWidget(template: template))),
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

  testWidgets('long prompt with short expected answer remains single-line', (
    tester,
  ) async {
    await tester.pumpWidget(
      _localizedApp(
        const Scaffold(
          body: ActivityTemplateWidget(
            template: _longPromptShortExpectedTemplate,
          ),
        ),
      ),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));

    expect(textField.minLines, 1);
    expect(textField.maxLines, 1);
    expect(textField.keyboardType, TextInputType.text);
    expect(textField.textInputAction, TextInputAction.done);
  });

  test('canonical Lesson 1 Step 4 restores the short first contact', () {
    final template = _canonicalLesson1Templates().firstWhere(
      (template) =>
          template.id == 'template.es.a0.m01.l001.guided_full_contact',
    );

    expect(template.exerciseType, 'fill_gap');
    expect(template.promptTemplate, contains('Заповни всі пропуски'));
    expect(
      template.promptTemplate,
      contains('Кожен рядок пиши з нового рядка'),
    );
    expect(template.promptTemplate, contains('H__a. Buenos d__s.'));
    expect(template.promptTemplate, contains('Hasta l____.'));
    expect(
      template.expectedAnswer,
      'Hola. Buenos días.\n'
      'Me llamo Marta.\n'
      '¿Cómo te llamas?\n'
      'Me llamo Ana.\n'
      'Mucho gusto.\n'
      'Hasta luego.',
    );

    final result = const ActivityEngine().evaluate(
      template: template,
      submission: const ActivitySubmission(
        submittedAnswer:
            'Hola. Buenos días. Me llamo Marta. ¿Cómo te llamas? Me llamo Ana. Mucho gusto. Hasta luego.',
      ),
    );

    expect(result.status, ActivityResultStatus.correct);
  });

  test('canonical Lesson 1 Step 4 is case-insensitive', () {
    final template = _canonicalLesson1Templates().firstWhere(
      (template) =>
          template.id == 'template.es.a0.m01.l001.guided_full_contact',
    );

    for (final greeting in ['hola.', 'HOLA.', 'HoLa.']) {
      final result = const ActivityEngine().evaluate(
        template: template,
        submission: ActivitySubmission(
          submittedAnswer:
              '$greeting Buenos días.\n'
              'Me llamo Marta.\n'
              '¿Cómo te llamas?\n'
              'Me llamo Ana.\n'
              'Mucho gusto.\n'
              'Hasta luego.',
        ),
      );

      expect(result.isCorrect, isTrue);
    }
  });

  test('canonical Lesson 1 Step 5 is case-insensitive', () {
    final template = _canonicalLesson1Templates().firstWhere(
      (template) =>
          template.id == 'template.es.a0.m01.l001.independent_full_contact',
    );

    for (final greeting in ['hola.', 'HOLA.', 'HoLa.']) {
      final result = const ActivityEngine().evaluate(
        template: template,
        submission: ActivitySubmission(
          submittedAnswer:
              '$greeting Buenos días.\n'
              'Me llamo Marta.\n'
              '¿Cómo te llamas?\n'
              'Me llamo Ana.\n'
              'Mucho gusto.\n'
              'Hasta luego.',
        ),
      );

      expect(result.isCorrect, isTrue);
    }
  });

  test('canonical Lesson 1 rejects obsolete profile expansion', () {
    final template = _canonicalLesson1Templates().firstWhere(
      (template) =>
          template.id == 'template.es.a0.m01.l001.independent_full_contact',
    );

    final result = const ActivityEngine().evaluate(
      template: template,
      submission: const ActivitySubmission(
        submittedAnswer:
            'Hola. Buenos días.\n'
            'Me llamo Marta.\n'
            '¿Cómo te llamas?\n'
            'Me llamo Ana.\n'
            'Mucho gusto.\n'
            '¿De dónde eres?\n'
            'Soy de España.\n'
            '¿Hablas español?\n'
            'Sí.\n'
            'Gracias. Hasta luego.',
      ),
    );

    expect(result.status, ActivityResultStatus.incorrect);
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

Widget _localizedApp(
  Widget child, {
  Locale? locale,
  List overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(useMaterial3: false),
      home: child,
    ),
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

const _sentenceBuilderTemplate = ExerciseTemplate(
  id: 'template.widget.sentence_builder',
  exerciseType: 'sentence_builder',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['dialogue'],
  promptTemplate: 'Склади привітання.',
  sentenceBuilder: SentenceBuilder(
    tokens: [
      SentenceBuilderToken(id: 'hola', label: 'Hola.'),
      SentenceBuilderToken(id: 'adios', label: 'Adiós.'),
    ],
    acceptedSequences: [
      ['hola'],
    ],
    audioReferenceId: 'es.audio.test.hola',
  ),
);

const _sentenceBuilderWrongTemplate = ExerciseTemplate(
  id: 'template.widget.sentence_builder_wrong',
  exerciseType: 'sentence_builder',
  supportedGoalTypes: ['review_vocabulary'],
  requiredObjectTypes: ['dialogue'],
  promptTemplate: 'Склади привітання.',
  sentenceBuilder: SentenceBuilder(
    tokens: [
      SentenceBuilderToken(id: 'hola', label: 'Hola.'),
      SentenceBuilderToken(id: 'adios', label: 'Adiós.'),
    ],
    acceptedSequences: [
      ['hola'],
    ],
    audioReferenceId: 'es.audio.test.hola',
  ),
);

final _sentenceBuilderManifest = AudioReferenceManifest(
  schemaVersion: 1,
  audioRoot: 'assets/languages/spanish/audio/reference',
  assets: [
    AudioReferenceAsset(
      id: 'es.audio.test.hola',
      assetPath: 'assets/languages/spanish/audio/reference/test.wav',
      transcript: 'Hola.',
      languageCode: 'es',
      locale: 'es_ES',
      voiceId: 'test',
      purpose: AudioReferencePurpose.phrase,
      qaStatus: AudioReferenceQaStatus.approved,
      provenance: AudioReferenceProvenance(
        engine: 'test',
        voice: 'test',
        locale: 'es_ES',
        generationRole: 'test',
      ),
    ),
  ],
);

class _SentenceBuilderFakeBackend implements ReferenceAudioBackend {
  int playCalls = 0;

  @override
  Future<void> dispose() async {}

  @override
  Future<void> play() async => playCalls++;

  @override
  Future<void> setAsset(String assetPath) async {}

  @override
  Future<void> setFile(String filePath) async {}

  @override
  Future<void> stop() async {}
}

List<String> _actionChipLabels(WidgetTester tester) {
  return tester
      .widgetList<ActionChip>(find.byType(ActionChip))
      .map((chip) => (chip.label as Text).data!)
      .toList();
}

const _shuffledSentenceBuilderTemplate = ExerciseTemplate(
  id: 'template.widget.sentence_builder.shuffle',
  exerciseType: 'sentence_builder',
  supportedGoalTypes: ['review_grammar'],
  requiredObjectTypes: ['dialogue'],
  promptTemplate: 'Склади питання.',
  sentenceBuilder: SentenceBuilder(
    tokens: [
      SentenceBuilderToken(id: 'como', label: '¿Cómo'),
      SentenceBuilderToken(id: 'te', label: 'te'),
      SentenceBuilderToken(id: 'llamas', label: 'llamas?'),
      SentenceBuilderToken(id: 'soy', label: 'Soy'),
      SentenceBuilderToken(id: 'de', label: 'de'),
    ],
    acceptedSequences: [
      ['como', 'te', 'llamas'],
    ],
  ),
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

const _longPromptShortExpectedTemplate = ExerciseTemplate(
  id: 'template.widget.long_prompt_short_expected',
  exerciseType: 'text_entry',
  supportedGoalTypes: ['guided_full_exchange'],
  requiredObjectTypes: ['dialogue'],
  promptTemplate:
      'This prompt is deliberately long because it explains a realistic '
      'context, but the learner action is still just two short expressions.',
  expectedAnswer: 'Hola, Adiós',
);

const _closingDialogueTemplate = ExerciseTemplate(
  id: 'template.widget.closing_dialogue',
  exerciseType: 'guided_dialogue',
  supportedGoalTypes: ['test'],
  requiredObjectTypes: ['dialogue'],
  promptTemplate: 'Reply and finish the dialogue.',
  guidedDialogue: GuidedDialogue(
    turns: [
      GuidedDialogueTurn(speaker: 'Marta', text: 'Adiós.', learner: false),
      GuidedDialogueTurn(
        speaker: 'Tú',
        text: 'Hasta luego.',
        learner: true,
        responsePatterns: ['Hasta luego.'],
      ),
      GuidedDialogueTurn(speaker: 'Marta', text: 'Gracias.', learner: false),
    ],
  ),
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

List<ExerciseTemplate> _canonicalLesson1Templates() {
  final raw = File(
    'assets/languages/spanish/templates/canonical_lesson_1.json',
  ).readAsStringSync();
  final decoded = jsonDecode(raw) as List<Object?>;
  return decoded
      .cast<Map<String, Object?>>()
      .map(ExerciseTemplate.fromJson)
      .toList(growable: false);
}

List<ExerciseTemplate> _canonicalLesson2Templates() {
  final raw = File(
    'assets/languages/spanish/templates/canonical_lesson_2.json',
  ).readAsStringSync();
  final decoded = jsonDecode(raw) as List<Object?>;
  return decoded
      .cast<Map<String, Object?>>()
      .map(ExerciseTemplate.fromJson)
      .toList(growable: false);
}
