import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_loader.dart';
import 'package:tutor_language/core/content/pronunciation_models.dart';
import 'package:tutor_language/core/content/reading_rule_prerequisite_validator.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('pronunciation reference slice loads and validates', () async {
    final catalog = await _loadCatalog();
    final issues = catalog.validate();

    expect(
      issues.where(
        (issue) => issue.severity == PronunciationIssueSeverity.error,
      ),
      isEmpty,
    );
    expect(
      issues.map((issue) => issue.severity),
      contains(PronunciationIssueSeverity.deferred),
    );
    expect(catalog.unitById('pronunciation.es.word.hola.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.adios.v1'), isNotNull);
    expect(
      catalog.unitById('pronunciation.es.phrase.hasta_luego.v1'),
      isNotNull,
    );
    expect(catalog.unitById('pronunciation.es.word.jose.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.espana.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.hambre.v1'), isNotNull);
    final gracias = catalog.unitById('pronunciation.es.word.gracias.v1');
    expect(gracias, isNotNull);
    expect(gracias!.ipa?.value, '/ˈɡɾasjas/');
    expect(gracias.ipa?.value, isNot('/r/'));
    expect(
      gracias.readingRuleIds,
      containsAll([
        'pronunciation.es.rule.r.v1',
        'pronunciation.es.rule.c_z.v1',
        'pronunciation.es.rule.stable_vowels.v1',
        'pronunciation.es.rule.primary_stress.v1',
      ]),
    );
    expect(
      catalog
          .resolveUnit(
            'pronunciation.es.word.gracias.v1',
            supportLocaleCode: 'ru',
          )
          ?.localizedLearnerHint,
      isNull,
    );
    expect(catalog.unitById('pronunciation.es.phrase.me_llamo.v1'), isNotNull);
    expect(
      catalog.unitById('pronunciation.es.phrase.mucho_gusto.v1'),
      isNotNull,
    );
    expect(catalog.unitById('pronunciation.es.word.igualmente.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.amigo.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.amiga.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.profesor.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.profesora.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.companero.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.companera.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.joven.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.simpatico.v1'), isNotNull);
    expect(catalog.unitById('pronunciation.es.word.simpatica.v1'), isNotNull);

    expect(catalog.rules.length, 12);
    expect(
      catalog.readingRuleById('pronunciation.es.rule.silent_h.v1'),
      isNotNull,
    );
    expect(
      catalog.readingRuleById('pronunciation.es.rule.stable_vowels.v1'),
      isNotNull,
    );
  });

  test(
    'Russian support locale has no reset learner hints and never falls back',
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

      expect(hola?.localizedLearnerHint, isNull);
      expect(adios?.localizedLearnerHint, isNull);
      expect(hastaLuego?.localizedLearnerHint, isNull);
      expect(hola?.ipa, '/ˈola/');
      expect(catalog.crossLocaleFallbackAttempts, greaterThan(0));
    },
  );

  test(
    'Ukrainian Module 1 pronunciation support resolves without Russian fallback',
    () async {
      final catalog = await _loadCatalog();

      final hola = catalog.resolveUnit(
        'pronunciation.es.word.hola.v1',
        supportLocaleCode: 'uk-UA',
      );
      final silentH = catalog.resolveReadingRule(
        'pronunciation.es.rule.silent_h.v1',
        supportLocaleCode: 'uk-UA',
      );
      final russianHola = catalog.resolveUnit(
        'pronunciation.es.word.hola.v1',
        supportLocaleCode: 'ru',
      );

      expect(hola?.localizedLearnerHint, isNotEmpty);
      expect(hola?.localizedExplanation, isNotEmpty);
      expect(silentH?.title, isNotEmpty);
      expect(silentH?.shortExplanation, isNotEmpty);
      expect(silentH?.diagnosticCode, isNull);
      expect(russianHola?.localizedLearnerHint, isNull);
      expect(catalog.crossLocaleFallbackAttempts, greaterThan(0));
    },
  );

  test(
    'Ukrainian reading rules follow learner presentation standard',
    () async {
      final catalog = await _loadCatalog();

      final singleR = catalog.resolveReadingRule(
        'pronunciation.es.rule.r.v1',
        supportLocaleCode: 'uk-UA',
      )!;
      final vowels = catalog.resolveReadingRule(
        'pronunciation.es.rule.stable_vowels.v1',
        supportLocaleCode: 'uk-UA',
      )!;

      expect(singleR.title, 'Одинарна r');
      expect(singleR.orthographicPattern, 'r');
      expect(singleR.ipa, '/ɾ/');
      expect(singleR.shortExplanation, contains('Назва літери: е́ре'));
      expect(singleR.shortExplanation, contains('коротке р'));
      expect(singleR.detailedExplanation, contains('pero'));
      expect(singleR.commonMistakes, contains('rr'));
      expect(
        _uniqueBlocks([
          singleR.shortExplanation,
          singleR.detailedExplanation,
          singleR.articulationHint,
          singleR.commonMistakes,
        ]),
        hasLength(4),
      );
      expect(
        [
          singleR.title,
          singleR.shortExplanation,
          singleR.detailedExplanation,
          singleR.articulationHint,
          singleR.commonMistakes,
        ].join('\n'),
        allOf(
          isNot(contains('англійськ')),
          isNot(contains('латинськ')),
          isNot(contains('кирилиц')),
          isNot(contains('не плутайте')),
        ),
      );

      expect(vowels.title, 'Іспанські голосні');
      expect(vowels.orthographicPattern, 'a e i o u');
      expect(vowels.ipa, '/a e i o u/');
      expect(vowels.shortExplanation, contains('a, e, i, o, u'));
      expect(vowels.shortExplanation, contains('коротко й рівно'));
      expect(vowels.shortExplanation, isNot(contains('голосні а е і о у')));
      expect(vowels.shortExplanation, isNot(contains('a е i о u')));
      expect(vowels.shortExplanation, isNot(contains('латинськ')));
      expect(vowels.shortExplanation, isNot(contains('кирилиц')));
    },
  );

  test('missing Russian hint does not return English hint', () {
    final unit = PronunciationUnit(
      id: PronunciationUnitId('pronunciation.es.word.test.v1'),
      schemaVersion: 1,
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

  test('reading rules preserve English text and reset Russian prose', () async {
    final catalog = await _loadCatalog();

    final english = catalog.resolveReadingRule(
      'pronunciation.es.rule.silent_h.v1',
      supportLocaleCode: 'en',
    );
    final russian = catalog.resolveReadingRule(
      'pronunciation.es.rule.silent_h.v1',
      supportLocaleCode: 'ru-UA',
    );

    expect(english?.title, 'Silent h');
    expect(english?.shortExplanation, contains('silent'));
    expect(russian?.title, isNull);
    expect(russian?.shortExplanation, isNull);
    expect(russian?.orthographicPattern, 'h');
    expect(
      russian?.examplePronunciationUnitIds,
      contains('pronunciation.es.word.hola.v1'),
    );
    expect(catalog.crossLocaleReadingRuleFallbackAttempts, 1);
  });

  test(
    'reading rule relationships are bidirectional through stable ids',
    () async {
      final catalog = await _loadCatalog();

      final rulesForHola = catalog.rulesForPronunciationUnit(
        'pronunciation.es.word.hola.v1',
      );
      final silentHExamples = catalog.exampleUnitsForReadingRule(
        'pronunciation.es.rule.silent_h.v1',
      );

      expect(
        rulesForHola.map((rule) => rule.id),
        contains('pronunciation.es.rule.silent_h.v1'),
      );
      expect(
        rulesForHola.map((rule) => rule.id),
        contains('pronunciation.es.rule.stable_vowels.v1'),
      );
      expect(
        silentHExamples.map((unit) => unit.id.value),
        contains('pronunciation.es.word.hola.v1'),
      );
      expect(
        silentHExamples.map((unit) => unit.id.value),
        contains('pronunciation.es.word.hambre.v1'),
      );
    },
  );

  test('reading rule support never falls back to English text', () {
    final rule = ReadingRule(
      id: 'pronunciation.es.rule.test.v1',
      schemaVersion: 1,
      knowledgeDomain: 'language',
      ruleKind: 'reading',
      targetLanguage: 'es',
      orthographicPattern: 'x',
      pronunciationVariety: PronunciationVariety('es-general'),
      phoneticOutcome: 'test sound',
      examplePronunciationUnitIds: ['pronunciation.es.word.test.v1'],
    );
    final unit = PronunciationUnit(
      id: PronunciationUnitId('pronunciation.es.word.test.v1'),
      schemaVersion: 1,
      targetLanguage: 'es',
      targetOrthography: 'test',
      pronunciationVariety: PronunciationVariety('es-general'),
      localizedLearnerHints: const {'en': 'TEST'},
      relatedContentIds: const ['vocab.test.v1'],
      readingRuleIds: const ['pronunciation.es.rule.test.v1'],
      ipa: IpaTranscription('/test/'),
    );
    const localization = PronunciationLocalizationEntry(
      id: 'pronunciation.es.rule.test.v1',
      learnerHints: {},
      explanations: {},
      titles: {'en': 'Test rule'},
      shortExplanations: {'en': 'English only.'},
    );
    final bundle = PronunciationBundle(
      schemaVersion: 1,
      targetLanguage: 'es',
      pronunciationVariety: PronunciationVariety('es-general'),
      rules: [rule],
      units: [unit],
      localizations: const [localization],
    );
    final catalog = PronunciationCatalog(bundle: bundle);

    final presentation = catalog.resolveReadingRule(
      rule.id,
      supportLocaleCode: 'ru',
    );

    expect(presentation?.title, isNull);
    expect(presentation?.shortExplanation, isNull);
    expect(
      presentation?.diagnosticCode,
      'readingRule.missingLocalizedExplanation',
    );
    expect(catalog.crossLocaleReadingRuleFallbackAttempts, 1);
  });

  test('Spanish ll/y policy is yeista and internally consistent', () async {
    final catalog = await _loadCatalog();

    final rule = catalog.readingRuleById('pronunciation.es.rule.ll_y.v1');
    final rulePresentation = catalog.resolveReadingRule(
      'pronunciation.es.rule.ll_y.v1',
      supportLocaleCode: 'ru',
    );
    final llamo = catalog.resolveUnit(
      'pronunciation.es.word.llamo.v1',
      supportLocaleCode: 'ru',
    );
    final llave = catalog.resolveUnit(
      'pronunciation.es.word.llave.v1',
      supportLocaleCode: 'ru',
    );
    final yo = catalog.resolveUnit(
      'pronunciation.es.word.yo.v1',
      supportLocaleCode: 'ru',
    );

    expect(rule?.metadata['llYPolicy'], 'yeismo');
    expect(rule?.ipa?.value, '/ʝ/');
    expect(rulePresentation?.detailedExplanation, isNull);

    expect(llamo?.ipa, '/ˈʝamo/');
    expect(llamo?.localizedLearnerHint, isNull);
    expect(llave?.localizedLearnerHint, isNull);
    expect(yo?.localizedLearnerHint, isNull);

    final llamoRules = catalog.rulesForPronunciationUnit(
      'pronunciation.es.word.llamo.v1',
    );
    final llaveRules = catalog.rulesForPronunciationUnit(
      'pronunciation.es.word.llave.v1',
    );
    final yoRules = catalog.rulesForPronunciationUnit(
      'pronunciation.es.word.yo.v1',
    );

    expect(
      llamoRules.map((rule) => rule.id),
      contains('pronunciation.es.rule.ll_y.v1'),
    );
    expect(
      llaveRules.map((rule) => rule.id),
      contains('pronunciation.es.rule.ll_y.v1'),
    );
    expect(
      yoRules.map((rule) => rule.id),
      contains('pronunciation.es.rule.ll_y.v1'),
    );
  });

  test('yeista validation rejects non-yeista ll/y IPA and Russian hints', () {
    final rule = ReadingRule(
      id: 'pronunciation.es.rule.ll_y.v1',
      schemaVersion: 1,
      knowledgeDomain: 'language',
      ruleKind: 'reading',
      targetLanguage: 'es',
      orthographicPattern: 'll and consonantal y',
      pronunciationVariety: PronunciationVariety('es-general'),
      phoneticOutcome: 'general yeista /ʝ/ category',
      ipa: IpaTranscription('/ʝ/'),
      examplePronunciationUnitIds: const ['pronunciation.es.word.llamo.v1'],
      metadata: const {
        'releaseReference': 'true',
        'llYPolicy': 'yeismo',
        'graphemeClarificationRequired': 'true',
      },
    );
    final unit = PronunciationUnit(
      id: PronunciationUnitId('pronunciation.es.word.llamo.v1'),
      schemaVersion: 1,
      targetLanguage: 'es',
      targetOrthography: 'llamo',
      pronunciationVariety: PronunciationVariety('es-general'),
      ipa: IpaTranscription('/ˈʎamo/'),
      readingRuleIds: const ['pronunciation.es.rule.ll_y.v1'],
      localizedLearnerHints: const {'en': 'LYAH-moh', 'ru': 'лья́мо'},
      relatedContentIds: const ['template.test.llamo.v1'],
      metadata: const {'releaseReference': 'true'},
    );
    const localization = PronunciationLocalizationEntry(
      id: 'pronunciation.es.rule.ll_y.v1',
      learnerHints: {'en': 'y-like', 'ru': 'близко к й'},
      explanations: {'en': 'yeismo', 'ru': 'yeismo'},
      titles: {'en': 'll and y', 'ru': 'll и y'},
      shortExplanations: {'en': 'Broad yeismo.', 'ru': 'Общая yeísta-норма.'},
      detailedExplanations: {
        'en': 'll is two lowercase l letters, not two uppercase I letters.',
        'ru':
            'll — это две строчные буквы l: l + l. Не путайте их с двумя заглавными буквами I.',
      },
    );
    final bundle = PronunciationBundle(
      schemaVersion: 1,
      targetLanguage: 'es',
      pronunciationVariety: PronunciationVariety('es-general'),
      rules: [rule],
      units: [unit],
      localizations: const [localization],
    );
    final catalog = PronunciationCatalog(bundle: bundle);

    final codes = catalog.validate().map((issue) => issue.code).toSet();

    expect(codes, contains('pronunciation.varietyIpaMismatch'));
    expect(codes, contains('pronunciation.nonYeistaHintInYeistaProfile'));
    expect(codes, contains('pronunciation.varietyLearnerHintMismatch'));
  });

  test('direct vocabulary pronunciation reference has priority', () async {
    final catalog = await _loadCatalog();
    const item = VocabularyItem(
      id: 'vocab.synthetic.hola.v1',
      spanish: 'hola',
      nativeTranslation: 'hello',
      cefr: 'A0',
      example: 'Hola.',
      pronunciation: 'OH-lah',
      pronunciationUnitId: 'pronunciation.es.word.hola.v1',
    );

    final presentation = catalog.resolveForVocabularyItem(
      item: item,
      supportLocaleCode: 'ru-UA',
    );

    expect(presentation?.ipa, '/ˈola/');
    expect(presentation?.localizedLearnerHint, isNull);
    expect(presentation?.isLegacyEnglishHint, isFalse);
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

  test(
    'coverage report is explicit about complete production migration',
    () async {
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
      expect(report.unitsWithRussianLearnerHint, 0);
      expect(report.multisyllabicRussianHintsWithStress, 0);
      expect(report.unitsWithExample, greaterThanOrEqualTo(18));
      expect(report.crossLocaleFallbackAttempts, 0);
      expect(report.invalidUnits, 0);
      expect(report.unmigratedLegacyEntries, 0);
      expect(report.readingRulesDiscovered, 12);
      expect(report.readingRulesMigrated, 12);
      expect(report.readingRulesWithVariety, 12);
      expect(report.readingRulesWithPhoneticDefinition, 12);
      expect(report.readingRulesWithEnglishLocalization, 12);
      expect(report.readingRulesWithRussianLocalization, 0);
      expect(report.readingRulesWithExamples, 12);
      expect(report.readingRulesReferencedByPronunciationUnits, 12);
      expect(report.unusedReadingRules, 0);
      expect(report.invalidReadingRuleReferences, 0);
      expect(report.crossLocaleReadingRuleFallbackAttempts, 0);
      expect(report.llYPronunciationUnits, greaterThanOrEqualTo(6));
      expect(
        report.llYUnitsConsistentWithSelectedVariety,
        report.llYPronunciationUnits,
      );
      expect(report.llYUnitsWithMatchingIpa, report.llYPronunciationUnits);
      expect(report.llYUnitsWithRussianHint, 0);
      expect(report.llYUnitsWithEnglishHint, 6);
      expect(report.llYUnitsWithGraphemeExplanation, 0);
      expect(report.llYVarietyMismatches, 0);
      expect(report.nonYeistaHintsInYeistaProfile, 0);
    },
  );

  test('ll/y rule exposure precedes llamo recall exercise', () async {
    final rawCourse = await rootBundle.loadString(
      'assets/languages/spanish/curriculum/spanish_a0_course.json',
    );
    final course = Course.fromJson(
      Map<String, Object?>.from(jsonDecode(rawCourse) as Map),
    );
    final catalog = await _loadCatalog();
    const validator = ReadingRulePrerequisiteValidator();
    final result = validator.validateCourse(
      course: course,
      pronunciationCatalog: catalog,
    );
    final myNameLesson = course.lessons.singleWhere(
      (lesson) => lesson.id == 'es.a0.m02.l004',
    );
    final orderedActivities = myNameLesson.sections.first.activities.toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    expect(
      result.issues.where((issue) => issue.severity.name == 'error'),
      isEmpty,
    );
    expect(
      course.modules
          .singleWhere((module) => module.id == 'es.a0.m01')
          .lessonIds,
      contains('es.a0.m06.l017'),
    );
    expect(
      course.modules
          .singleWhere((module) => module.id == 'es.a0.m02')
          .lessonIds,
      isNot(contains('es.a0.m06.l017')),
    );
    expect(orderedActivities.first.id, 'activity.reading_rule.ll_y_intro');
    expect(
      orderedActivities.first.reviewedReadingRuleIds,
      contains('pronunciation.es.rule.ll_y.v1'),
    );
    expect(
      orderedActivities
          .singleWhere(
            (activity) => activity.id == 'activity.practice.name_intro',
          )
          .requiredReadingRuleIds,
      contains('pronunciation.es.rule.ll_y.v1'),
    );

    final namesSoundLesson = course.lessons.singleWhere(
      (lesson) => lesson.id == 'es.a0.m06.l017',
    );
    expect(
      namesSoundLesson.activities
          .singleWhere(
            (activity) => activity.id == 'es.a0.m06.l017.activity.grammar',
          )
          .introducedReadingRuleIds,
      contains('pronunciation.es.rule.ll_y.v1'),
    );
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

Set<String> _uniqueBlocks(Iterable<String?> values) {
  return values
      .whereType<String>()
      .map((value) => value.trim().toLowerCase())
      .where((value) => value.isNotEmpty)
      .toSet();
}
