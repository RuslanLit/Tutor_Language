import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_loader.dart';
import 'package:tutor_language/core/content/pronunciation_models.dart';
import 'package:tutor_language/core/content/topic_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('pronunciation reference slice loads and validates', () async {
    final catalog = await _loadCatalog();
    final issues = catalog.validate();

    expect(issues, isEmpty);
    expect(catalog.unitById('pronunciation.es.word.hola.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.adios.v1'), isNotNull);
    expect(
      catalog.unitById('pronunciation.es.phrase.hasta_luego.v1'),
      isNotNull,
    );
    expect(catalog.unitById('pronunciation.es.word.jose.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.espana.v1'), isNotNull);
  });

  test(
    'Russian support locale never falls back to English learner hint',
    () async {
      final catalog = await _loadCatalog();

      final hola = catalog.resolveUnit(
        'pronunciation.es.word.hola.v1',
        supportLocaleCode: 'ru-UA',
      );
      final adios = catalog.resolveUnit(
        'pronunciation.es.word.adios.v1',
        supportLocaleCode: 'ru-RU',
      );
      final hastaLuego = catalog.resolveUnit(
        'pronunciation.es.phrase.hasta_luego.v1',
        supportLocaleCode: 'ru',
      );

      expect(hola?.localizedLearnerHint, 'о́ла');
      expect(adios?.localizedLearnerHint, 'адьо́с');
      expect(hastaLuego?.localizedLearnerHint, 'а́ста луэ́го');
      expect(hola?.localizedLearnerHint, isNot('OH-lah'));
      expect(adios?.localizedLearnerHint, isNot('ah-DYOHS'));
      expect(hastaLuego?.localizedLearnerHint, isNot('AHS-tah LWEH-goh'));
      expect(catalog.crossLocaleFallbackAttempts, 0);
    },
  );

  test('missing Russian hint does not return English hint', () {
    final unit = PronunciationUnit(
      id: PronunciationUnitId('pronunciation.es.word.test.v1'),
      targetLanguage: 'es',
      targetOrthography: 'test',
      pronunciationVariety: PronunciationVariety('es-general'),
      localizedLearnerHints: const {'en': 'TEST'},
      relatedContentIds: const ['vocab.test.v1'],
      ipa: IpaTranscription('/test/'),
    );
    final bundle = PronunciationBundle(
      schemaVersion: 1,
      targetLanguage: 'es',
      pronunciationVariety: PronunciationVariety('es-general'),
      rules: const [],
      units: [unit],
      localizations: const [],
    );
    final catalog = PronunciationCatalog(bundle: bundle);

    final presentation = catalog.resolveUnit(
      unit.id.value,
      supportLocaleCode: 'ru',
    );

    expect(presentation?.localizedLearnerHint, isNull);
    expect(presentation?.ipa, '/test/');
    expect(catalog.crossLocaleFallbackAttempts, 1);
  });

  test('unsupported locale does not return unrelated English hint', () async {
    final catalog = await _loadCatalog();

    final presentation = catalog.resolveUnit(
      'pronunciation.es.word.hola.v1',
      supportLocaleCode: 'fr',
    );

    expect(presentation?.localizedLearnerHint, isNull);
    expect(presentation?.ipa, '/ˈola/');
    expect(catalog.crossLocaleFallbackAttempts, 1);
  });

  test('legacy English hint is hidden for Russian vocabulary', () async {
    final catalog = await _loadCatalog();
    const unmigrated = VocabularyItem(
      id: 'vocab.unmigrated.v1',
      spanish: 'prueba',
      nativeTranslation: 'test',
      cefr: 'A0',
      example: 'prueba',
      pronunciation: 'PROO-eh-bah',
    );

    final english = catalog.resolveForVocabularyItem(
      item: unmigrated,
      supportLocaleCode: 'en',
    );
    final russian = catalog.resolveForVocabularyItem(
      item: unmigrated,
      supportLocaleCode: 'ru',
    );

    expect(english?.localizedLearnerHint, 'PROO-eh-bah');
    expect(english?.isLegacyEnglishHint, isTrue);
    expect(russian?.localizedLearnerHint, isNull);
    expect(
      russian?.diagnosticCode,
      'pronunciation.legacyEnglishHintInNonEnglishLocale',
    );
  });

  test('reading rule reuse and related content references are real', () async {
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    final bundle = await contentLoader.loadSpanishContent();
    final contentCatalog = EducationalContentCatalog(bundle);
    final catalog = await _loadCatalog();

    final silentHUnits = catalog.units
        .where(
          (unit) =>
              unit.readingRuleIds.contains('pronunciation.es.rule.silent_h.v1'),
        )
        .toList();
    expect(silentHUnits.length, greaterThanOrEqualTo(3));

    for (final unit in catalog.units) {
      for (final id in unit.relatedContentIds) {
        expect(
          contentCatalog.contains(id),
          isTrue,
          reason: 'Unknown related content id $id in ${unit.id.value}',
        );
      }
    }
  });

  test('coverage report is explicit about partial migration', () async {
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    final bundle = await contentLoader.loadSpanishContent();
    final vocabulary = bundle.byType<VocabularyContent>();
    final legacyItems = vocabulary
        .expand((content) => content.entries)
        .where((entry) => entry.pronunciation != null)
        .toList();
    final uniqueTargets = legacyItems.map((entry) => entry.spanish).toSet();
    final catalog = await _loadCatalog();

    final report = catalog.coverageReport(
      legacyPronunciationFieldsDiscovered: legacyItems.length,
      uniqueTargetForms: uniqueTargets.length,
    );

    expect(report.legacyPronunciationFieldsDiscovered, greaterThan(0));
    expect(report.uniqueTargetForms, greaterThan(0));
    expect(report.pronunciationUnits, greaterThanOrEqualTo(17));
    expect(report.unitsWithRussianLearnerHint, report.pronunciationUnits);
    expect(report.crossLocaleFallbackAttempts, 0);
    expect(report.invalidUnits, 0);
    expect(report.unmigratedLegacyEntries, greaterThan(0));
  });
}

Future<PronunciationCatalog> _loadCatalog() async {
  final contentLoader = ContentLoader(assetBundle: rootBundle);
  final contentBundle = await contentLoader.loadSpanishContent();
  final vocabulary = contentBundle.byType<VocabularyContent>();

  return PronunciationLoader(
    assetBundle: rootBundle,
  ).loadCatalog(vocabularyContents: vocabulary);
}
