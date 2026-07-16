import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_localization.dart';
import 'package:tutor_language/core/content/content_localization_providers.dart';
import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_models.dart';
import 'package:tutor_language/core/content/pronunciation_providers.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_content.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_screen.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_step.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Russian support locale renders localized pronunciation hints', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supportLocaleControllerProvider.overrideWith(
            (ref) => SupportLocale.russian,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: VocabularyItemView(
              item: VocabularyItem(
                id: 'vocab.es.a0.u01.l01.hola.v1',
                spanish: 'hola',
                nativeTranslation: 'hello',
                cefr: 'A0',
                example: 'Hola.',
                pronunciation: 'OH-lah',
                pronunciationUnitId: 'pronunciation.es.word.hola.v1',
              ),
            ),
          ),
        ),
      ),
    );

    await _pumpUntilFound(tester, find.text('о́ла'));

    expect(find.text('hola'), findsOneWidget);
    expect(find.text('/ˈola/'), findsOneWidget);
    expect(find.text('о́ла'), findsOneWidget);
    expect(find.text('hello'), findsOneWidget);
    expect(find.text('OH-lah'), findsNothing);

    expect(
      tester.getTopLeft(find.text('hola')).dy,
      lessThan(tester.getTopLeft(find.text('/ˈola/')).dy),
    );
    expect(
      tester.getTopLeft(find.text('/ˈola/')).dy,
      lessThan(tester.getTopLeft(find.text('о́ла')).dy),
    );
    expect(
      tester.getTopLeft(find.text('о́ла')).dy,
      lessThan(tester.getTopLeft(find.text('hello')).dy),
    );
  });

  testWidgets('reading rule presentation renders localized rule support', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ReadingRuleView(
            presentation: ResolvedReadingRulePresentation(
              id: 'pronunciation.es.rule.silent_h.v1',
              targetLanguage: 'es',
              pronunciationVariety: 'es-general',
              orthographicPattern: 'h',
              examplePronunciationUnitIds: ['pronunciation.es.word.hola.v1'],
              title: 'Немая h',
              shortExplanation:
                  'В испанском буква h обычно пишется, но не произносится.',
              detailedExplanation:
                  'Читайте слово так, как будто h нет: hola начинается сразу с гласного звука.',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Немая h'), findsOneWidget);
    expect(find.text('h'), findsOneWidget);
    expect(find.textContaining('не произносится'), findsOneWidget);
    expect(find.textContaining('hola начинается'), findsOneWidget);
    expect(find.textContaining('Silent h'), findsNothing);
  });

  testWidgets('reading rule step hides generic mixed label', (tester) async {
    final catalog = await _loadReadingRuleCatalog();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supportLocaleControllerProvider.overrideWith(
            (ref) => SupportLocale.russian,
          ),
          pronunciationCatalogProvider.overrideWith((ref) async => catalog),
        ],
        child: const MaterialApp(
          locale: Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: LessonPlayerStepView(step: _readingRuleStep)),
        ),
      ),
    );

    await _pumpUntilFound(tester, find.text('Немая h'));

    expect(find.text('Правило чтения'), findsOneWidget);
    expect(find.text('Немая h'), findsOneWidget);
    expect(find.text('Пример'), findsOneWidget);
    expect(find.text('смешанное'), findsNothing);
  });

  testWidgets('ll reading rule renders unambiguous grapheme comparison', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ReadingRuleView(
            presentation: ResolvedReadingRulePresentation(
              id: 'pronunciation.es.rule.ll_y.v1',
              targetLanguage: 'es',
              pronunciationVariety: 'es-general',
              orthographicPattern: 'll and consonantal y',
              examplePronunciationUnitIds: ['pronunciation.es.word.llamo.v1'],
              title: 'll и y',
              shortExplanation: 'll — это две строчные латинские буквы «эль».',
              ipa: '/ʝ/',
              graphemePresentation: LocalizedGraphemePresentation(
                canonicalDescription:
                    'Изучаем: ll. Это две строчные латинские буквы «эль».',
                componentLetterNames: ['эль', 'эль'],
                confusableDescription:
                    'Не путайте с II: это две заглавные латинские буквы «и».',
                confusableComponentLetterNames: ['и', 'и'],
                accessibilityDescription:
                    'Две строчные латинские буквы эль: эль плюс эль, образуют ll. '
                    'Не путайте с двумя заглавными латинскими буквами и: I плюс I, образуют II.',
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.textContaining('Изучаем: ll'), findsOneWidget);
    expect(find.text('l  +  l'), findsOneWidget);
    expect(find.text('ll'), findsOneWidget);
    expect(find.text('I  +  I'), findsOneWidget);
    expect(find.text('II'), findsOneWidget);
    expect(find.textContaining('«эль» + «эль»'), findsOneWidget);
    expect(find.textContaining('«и» + «и»'), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(GraphemeComparisonView)).label,
      contains('строчные латинские буквы эль'),
    );
  });

  testWidgets('llamo card renders yeista IPA and Russian hint in order', (
    tester,
  ) async {
    final catalog = await _loadPronunciationCatalog();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supportLocaleControllerProvider.overrideWith(
            (ref) => SupportLocale.russian,
          ),
          pronunciationCatalogProvider.overrideWith((ref) async => catalog),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: VocabularyItemView(
              item: VocabularyItem(
                id: 'vocab.synthetic.llamo.v1',
                spanish: 'llamo',
                nativeTranslation: 'I call / I am called',
                cefr: 'A0',
                example: 'Me llamo Ana.',
                pronunciationUnitId: 'pronunciation.es.word.llamo.v1',
              ),
            ),
          ),
        ),
      ),
    );

    await _pumpUntilFound(tester, find.text('я́мо'));

    expect(find.text('llamo'), findsOneWidget);
    expect(find.text('/ˈʝamo/'), findsOneWidget);
    expect(find.text('я́мо'), findsOneWidget);
    expect(find.text('I call / I am called'), findsOneWidget);
    expect(find.text('Me llamo Ana.'), findsOneWidget);
    expect(find.text('лья́мо'), findsNothing);

    expect(
      tester.getTopLeft(find.text('llamo')).dy,
      lessThan(tester.getTopLeft(find.text('/ˈʝamo/')).dy),
    );
    expect(
      tester.getTopLeft(find.text('/ˈʝamo/')).dy,
      lessThan(tester.getTopLeft(find.text('я́мо')).dy),
    );
    expect(
      tester.getTopLeft(find.text('я́мо')).dy,
      lessThan(tester.getTopLeft(find.text('I call / I am called')).dy),
    );
    expect(
      tester.getTopLeft(find.text('I call / I am called')).dy,
      lessThan(tester.getTopLeft(find.text('Me llamo Ana.')).dy),
    );
  });
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 80; i += 1) {
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }

  expect(finder, findsOneWidget);
}

Future<PronunciationCatalog> _loadPronunciationCatalog() {
  final bundle = PronunciationBundle(
    schemaVersion: 1,
    targetLanguage: 'es',
    pronunciationVariety: PronunciationVariety('es-general'),
    rules: const [],
    units: [
      PronunciationUnit(
        id: PronunciationUnitId('pronunciation.es.word.llamo.v1'),
        schemaVersion: 1,
        targetLanguage: 'es',
        targetOrthography: 'llamo',
        pronunciationVariety: PronunciationVariety('es-general'),
        ipa: IpaTranscription('/ˈʝamo/'),
        localizedLearnerHints: const {'en': 'YAH-moh', 'ru': 'я́мо'},
        relatedContentIds: const ['vocab.synthetic.llamo.v1'],
      ),
    ],
    localizations: const [
      PronunciationLocalizationEntry(
        id: 'pronunciation.es.word.llamo.v1',
        learnerHints: {'en': 'YAH-moh', 'ru': 'я́мо'},
        explanations: {
          'en': 'The ll follows the course yeismo policy.',
          'ru': 'В общей норме курса ll произносится примерно как «й».',
        },
      ),
    ],
  );

  return Future.value(PronunciationCatalog(bundle: bundle));
}

Future<PronunciationCatalog> _loadReadingRuleCatalog() {
  final bundle = PronunciationBundle(
    schemaVersion: 1,
    targetLanguage: 'es',
    pronunciationVariety: PronunciationVariety('es-general'),
    rules: [
      PronunciationReadingRule(
        id: 'pronunciation.es.rule.silent_h.v1',
        schemaVersion: 1,
        knowledgeDomain: 'language',
        ruleKind: 'reading',
        targetLanguage: 'es',
        orthographicPattern: 'h',
        pronunciationVariety: PronunciationVariety('es-general'),
        examplePronunciationUnitIds: const ['pronunciation.es.word.hola.v1'],
      ),
    ],
    units: const [],
    localizations: const [
      PronunciationLocalizationEntry(
        id: 'pronunciation.es.rule.silent_h.v1',
        learnerHints: {},
        explanations: {},
        titles: {'ru': 'Немая h'},
        shortExplanations: {
          'ru': 'В испанском буква h обычно пишется, но не произносится.',
        },
      ),
    ],
  );

  return Future.value(PronunciationCatalog(bundle: bundle));
}

const _readingRuleStep = LessonPlayerStep(
  id: 'lesson.synthetic::activity.reading_rule::info.1',
  sourceActivity: LessonContentActivity(
    activity: LessonActivity(
      id: 'activity.reading_rule',
      title: 'Правило чтения',
      type: 'mixed',
    ),
    resolvedContent: [
      ReadingRulePresentationReference('pronunciation.es.rule.silent_h.v1'),
      ReadingText(
        id: 'reading.synthetic',
        title: 'Пример',
        vocabularyIds: [],
        grammarIds: [],
        text: 'hola',
        nativeTranslation: 'привет',
      ),
    ],
  ),
  content: [
    ReadingRulePresentationReference('pronunciation.es.rule.silent_h.v1'),
    ReadingText(
      id: 'reading.synthetic',
      title: 'Пример',
      vocabularyIds: [],
      grammarIds: [],
      text: 'hola',
      nativeTranslation: 'привет',
    ),
  ],
  stepType: LessonPlayerStepType.mixed,
);
