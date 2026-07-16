import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/content_localization.dart';
import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_loader.dart';
import 'package:tutor_language/core/content/semantic_localization.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Ukrainian and Russian Flutter UI locales remain supported', () {
    expect(
      AppLocalizations.supportedLocales.map((locale) => locale.languageCode),
      containsAll(['uk', 'ru']),
    );
  });

  test('semantic model still validates approved fixture units', () {
    final bundle = _fixtureSemanticBundle();

    expect(
      bundle.units.map((unit) => unit.semanticType),
      containsAll([
        SemanticLocalizationType.vocabularyMeaning,
        SemanticLocalizationType.pronunciationHint,
        SemanticLocalizationType.exercisePrompt,
      ]),
    );
    expect(
      const SemanticLocalizationValidator().validate(bundle: bundle),
      isEmpty,
    );
  });

  test('generated status is rejected for production semantic units', () {
    final bundle = _fixtureSemanticBundle();
    final generated = SemanticLocalizationBundle(
      schemaVersion: bundle.schemaVersion,
      targetLanguage: bundle.targetLanguage,
      sourceSupportLocale: bundle.sourceSupportLocale,
      supportLocales: bundle.supportLocales,
      units: [
        _copyUnit(
          bundle.units.first,
          review: const {'uk': SemanticReviewStatus.generated},
        ),
      ],
    );

    expect(
      const SemanticLocalizationValidator()
          .validate(bundle: generated)
          .map((issue) => issue.code),
      contains('semantic.reviewStatusNotReleaseReady'),
    );
  });

  test('deterministic serialization is stable', () {
    final bundle = _fixtureSemanticBundle();

    final first = serializeSemanticLocalizationBundle(bundle);
    final second = serializeSemanticLocalizationBundle(
      SemanticLocalizationBundle.fromJson(
        Map<String, Object?>.from(jsonDecode(first) as Map),
      ),
    );

    expect(second, first);
  });

  test('duplicate semantic identity conflict fails', () {
    final bundle = _fixtureSemanticBundle();
    final duplicate = SemanticLocalizationBundle(
      schemaVersion: bundle.schemaVersion,
      targetLanguage: bundle.targetLanguage,
      sourceSupportLocale: bundle.sourceSupportLocale,
      supportLocales: bundle.supportLocales,
      units: [
        bundle.units.first,
        _copyUnit(bundle.units.first, id: 'duplicate'),
      ],
    );

    expect(
      const SemanticLocalizationValidator()
          .validate(bundle: duplicate)
          .map((issue) => issue.code),
      contains('semantic.duplicateIdentityConflict'),
    );
  });

  test(
    'runtime semantic bundles contain no production Ukrainian or Russian units',
    () async {
      final semantic = await SemanticLocalizationRepository().loadBundle();

      expect(semantic.units, isEmpty);
      expect(semantic.requiredSemanticFields, isEmpty);
      expect(semantic.supportLocales, containsAll(['uk', 'ru']));
    },
  );

  test('English educational content remains available', () async {
    final localization = await EducationalContentLocalizationRepository()
        .loadBundle();
    final content = await ContentLoader().loadLanguagePackContent();
    final resolver = EducationalContentLocalizationResolver(localization);
    final hola = content.contents
        .whereType<VocabularyContent>()
        .expand((content) => content.entries)
        .firstWhere((item) => item.id == 'vocab.es.a0.unit1.hola.v1');

    final resolved = resolver.resolveVocabularyItem(
      hola,
      SupportLocale.english,
    );

    expect(resolved.nativeTranslation, hola.nativeTranslation);
  });

  test(
    'Ukrainian legacy educational values are inactive and fall back to English source',
    () async {
      final localization = await EducationalContentLocalizationRepository()
          .loadBundle();
      final content = await ContentLoader().loadLanguagePackContent();
      final resolver = EducationalContentLocalizationResolver(localization);
      final hola = content.contents
          .whereType<VocabularyContent>()
          .expand((content) => content.entries)
          .firstWhere((item) => item.id == 'vocab.es.a0.unit1.hola.v1');

      final resolved = resolver.resolveVocabularyItem(
        hola,
        SupportLocale.ukrainian,
      );

      expect(resolved.nativeTranslation, hola.nativeTranslation);
    },
  );

  test(
    'Russian legacy educational values are inactive and fall back to English source',
    () async {
      final localization = await EducationalContentLocalizationRepository()
          .loadBundle();
      final content = await ContentLoader().loadLanguagePackContent();
      final resolver = EducationalContentLocalizationResolver(localization);
      final hola = content.contents
          .whereType<VocabularyContent>()
          .expand((content) => content.entries)
          .firstWhere((item) => item.id == 'vocab.es.a0.unit1.hola.v1');

      final resolved = resolver.resolveVocabularyItem(
        hola,
        SupportLocale.russian,
      );

      expect(resolved.nativeTranslation, hola.nativeTranslation);
    },
  );

  test(
    'Ukrainian and Russian never cross-fallback through legacy data',
    () async {
      final raw = await _loadRawLegacyLocalization();

      for (final rawEntry in raw['entries'] as List? ?? const []) {
        final entry = Map<String, Object?>.from(rawEntry as Map);
        final fields = Map<String, Object?>.from(entry['fields'] as Map);
        for (final rawValues in fields.values) {
          final values = Map<String, Object?>.from(rawValues as Map);
          expect(values.containsKey('uk'), isFalse);
          expect(values.containsKey('ru'), isFalse);
        }
      }
    },
  );

  test(
    'readiness manifest declares uk and ru rebuilding with empty completed modules',
    () async {
      final manifest = await EducationalLocaleReadinessRepository()
          .loadManifest();
      final en = manifest.forLocale('en');
      final uk = manifest.forLocale('uk');
      final ru = manifest.forLocale('ru');

      expect(en.isEducationalProductionReady, isTrue);
      for (final locale in [uk, ru]) {
        expect(locale.uiAvailable, isTrue);
        expect(
          locale.educationalLocalizationState,
          EducationalLocalizationState.rebuilding,
        );
        expect(
          locale.educationalContentSource,
          EducationalContentSource.englishSourceFallback,
        );
        expect(locale.semanticProductionReady, isFalse);
        expect(locale.allowedFallbackLocale, 'en');
        expect(locale.crossLocaleFallbackProhibited, isTrue);
        expect(locale.completedModules, isEmpty);
        expect(locale.releaseEligible, isFalse);
      }
    },
  );

  test(
    'partial semantic lesson cannot mix with reset legacy content',
    () async {
      final localization = await EducationalContentLocalizationRepository()
          .loadBundle();
      final semantic = SemanticLocalizationBundle(
        schemaVersion: 1,
        targetLanguage: 'es',
        sourceSupportLocale: 'en',
        supportLocales: const ['uk'],
        units: [_fixtureSemanticBundle().units.first],
      );
      final content = await ContentLoader().loadLanguagePackContent();
      final resolver = EducationalContentLocalizationResolver(
        localization,
        semanticBundle: semantic,
      );
      final hola = content.contents
          .whereType<VocabularyContent>()
          .expand((content) => content.entries)
          .firstWhere((item) => item.id == 'vocab.es.a0.unit1.hola.v1');
      final adios = content.contents
          .whereType<VocabularyContent>()
          .expand((content) => content.entries)
          .firstWhere((item) => item.id == 'vocab.es.a0.unit1.adios.v1');

      expect(
        resolver
            .resolveVocabularyItem(hola, SupportLocale.ukrainian)
            .nativeTranslation,
        'fixture meaning',
      );
      expect(
        resolver
            .resolveVocabularyItem(adios, SupportLocale.ukrainian)
            .nativeTranslation,
        adios.nativeTranslation,
      );
    },
  );

  test('full Ukrainian migration gate reports not ready after reset', () async {
    final localization = await _loadRawLegacyLocalization();
    final semantic = await SemanticLocalizationRepository().loadBundle();

    final coverage = SemanticUkrainianMigrationCoverage.build(
      legacyLocalizationJson: localization,
      semanticBundle: semantic,
    );

    expect(coverage.legacyFields, 2742);
    expect(coverage.semanticApprovedFields, 0);
    expect(coverage.legacyFieldsCoveredBySemantic, 0);
    expect(coverage.remainingLegacyFields, 2742);
    expect(coverage.legacyResolutions, 0);
    expect(coverage.sourceFallbackCount, 2742);
    expect(coverage.isProductionComplete, isFalse);
  });

  test('full Russian migration gate reports not ready after reset', () async {
    final localization = await _loadRawLegacyLocalization();
    final semantic = await SemanticLocalizationRepository().loadBundle();

    final coverage = SemanticUkrainianMigrationCoverage.build(
      legacyLocalizationJson: localization,
      semanticBundle: semantic,
      locale: 'ru',
    );

    expect(coverage.semanticApprovedFields, 0);
    expect(coverage.legacyResolutions, 0);
    expect(coverage.sourceFallbackCount, 2742);
    expect(coverage.isProductionComplete, isFalse);
  });

  test('canonical Spanish target text is unchanged', () async {
    final content = await ContentLoader().loadLanguagePackContent();
    final hola = content.contents
        .whereType<VocabularyContent>()
        .expand((content) => content.entries)
        .firstWhere((item) => item.id == 'vocab.es.a0.unit1.hola.v1');

    expect(hola.spanish, 'hola');
  });

  test('IPA and pronunciation identifiers remain available', () async {
    final bundle = await PronunciationLoader().loadBundle();
    final catalog = PronunciationCatalog(bundle: bundle);
    final hola = catalog.unitById('pronunciation.es.word.hola.v1');

    expect(hola, isNotNull);
    expect(hola!.ipa?.value, '/ˈola/');
    expect(
      catalog
          .applicableRulesForPronunciationUnit('pronunciation.es.word.hola.v1')
          .map((rule) => rule.id),
      contains('pronunciation.es.rule.silent_h.v1'),
    );
  });

  test('Ukrainian and Russian pronunciation hints are inactive', () async {
    final bundle = await PronunciationLoader().loadBundle();

    for (final unit in bundle.units) {
      expect(unit.localizedLearnerHints.containsKey('uk'), isFalse);
      expect(unit.localizedLearnerHints.containsKey('ru'), isFalse);
    }
    for (final entry in bundle.localizations) {
      expect(entry.learnerHints.containsKey('uk'), isFalse);
      expect(entry.learnerHints.containsKey('ru'), isFalse);
      expect(entry.explanations.containsKey('uk'), isFalse);
      expect(entry.explanations.containsKey('ru'), isFalse);
    }
  });

  test(
    'scaffold generator is deterministic and derives canonical module lessons',
    () {
      final first = File('/tmp/r2e5r_scaffold_1.json');
      final second = File('/tmp/r2e5r_scaffold_2.json');
      for (final file in [first, second]) {
        if (file.existsSync()) {
          file.deleteSync();
        }
      }

      _runTool([
        'run',
        'tool/create_semantic_localization_scaffold.dart',
        '--locale',
        'uk',
        '--module',
        'es.a0.m01',
        '--output',
        first.path,
      ]);
      _runTool([
        'run',
        'tool/create_semantic_localization_scaffold.dart',
        '--locale',
        'uk',
        '--module',
        'es.a0.m01',
        '--output',
        second.path,
      ]);

      expect(second.readAsStringSync(), first.readAsStringSync());
      final scaffold = Map<String, Object?>.from(
        jsonDecode(first.readAsStringSync()) as Map,
      );
      final metadata = Map<String, Object?>.from(scaffold['scaffold'] as Map);
      expect(metadata['lessonIds'], [
        'es.a0.m06.l016',
        'es.a0.m01.l001',
        'es.a0.m06.l017',
        'es.a0.m01.l002',
        'es.a0.m01.l003',
        'es.a0.m01.l006',
        'es.a0.m04.l010',
      ]);
      final units = scaffold['units'] as List;
      expect(units, isNotEmpty);
      final firstUnit = Map<String, Object?>.from(units.first as Map);
      expect(Map<String, Object?>.from(firstUnit['values'] as Map)['uk'], '');
      expect(
        Map<String, Object?>.from(firstUnit['review'] as Map)['uk'],
        'generated',
      );
    },
  );

  test('scaffold generator preserves protected Spanish spans', () {
    final output = File('/tmp/r2e5r_scaffold_spans.json');
    if (output.existsSync()) {
      output.deleteSync();
    }
    _runTool([
      'run',
      'tool/create_semantic_localization_scaffold.dart',
      '--locale',
      'uk',
      '--module',
      'es.a0.m01',
      '--output',
      output.path,
    ]);
    final scaffold = Map<String, Object?>.from(
      jsonDecode(output.readAsStringSync()) as Map,
    );
    final units = (scaffold['units'] as List).whereType<Map>();

    expect(
      units.any((unit) {
        final spans = unit['protectedSpans'] as List? ?? const [];
        return spans.any((span) => (span as Map)['type'] == 'targetText');
      }),
      isTrue,
    );
  });

  test('archived generators cannot be used as production authoring tools', () {
    final uk = Process.runSync('dart', [
      'run',
      'tool/translate_content_localization_uk.dart',
    ]);
    final ru = Process.runSync('dart', [
      'run',
      'tool/translate_content_localization_ru.dart',
    ]);

    expect(uk.exitCode, isNot(0));
    expect('${uk.stderr}${uk.stdout}', contains('archived by R2E5R'));
    expect(ru.exitCode, isNot(0));
    expect('${ru.stderr}${ru.stdout}', contains('archived by R2E5R'));
  });

  test('reset audit passes', () {
    _runTool(['run', 'tool/audit_educational_localization_reset.dart']);
  });
}

Future<Map<String, Object?>> _loadRawLegacyLocalization() async {
  final raw = await rootBundle.loadString(
    'assets/languages/spanish/localization/support_localizations.json',
  );
  return Map<String, Object?>.from(jsonDecode(raw) as Map);
}

SemanticLocalizationBundle _fixtureSemanticBundle() {
  final context = SemanticLocalizationContext(
    courseId: 'es.a0',
    moduleId: 'es.a0.m01',
    lessonId: 'es.a0.m01.l001',
    contentObjectId: 'vocab.es.a0.unit1.hola.v1',
    fieldPath: 'native_translation',
    contentKind: 'vocabulary',
    pedagogicalRole: 'lexical support',
    targetLanguage: 'es',
    supportLocale: 'uk',
  );
  return SemanticLocalizationBundle(
    schemaVersion: 1,
    targetLanguage: 'es',
    sourceSupportLocale: 'en',
    supportLocales: const ['uk'],
    units: [
      SemanticLocalizationUnit(
        id: 'fixture.meaning',
        semanticType: SemanticLocalizationType.vocabularyMeaning,
        ownership: SemanticTextOwnership.supportLanguageOwned,
        sourceText: 'hello',
        values: const {'uk': 'fixture meaning'},
        review: const {'uk': SemanticReviewStatus.approved},
        context: context,
      ),
      SemanticLocalizationUnit(
        id: 'fixture.hint',
        semanticType: SemanticLocalizationType.pronunciationHint,
        ownership: SemanticTextOwnership.supportLanguageOwned,
        sourceText: 'hola',
        values: const {'uk': 'o-la'},
        review: const {'uk': SemanticReviewStatus.approved},
        context: const SemanticLocalizationContext(
          courseId: 'es.a0',
          moduleId: 'es.a0.m01',
          lessonId: 'es.a0.m01.l001',
          contentObjectId: 'pronunciation.es.word.hola.v1',
          fieldPath: 'localizedLearnerHints.uk',
          contentKind: 'pronunciation',
          pedagogicalRole: 'pronunciation support',
          targetLanguage: 'es',
          supportLocale: 'uk',
          sourceMeaning: 'hello',
        ),
      ),
      SemanticLocalizationUnit(
        id: 'fixture.prompt',
        semanticType: SemanticLocalizationType.exercisePrompt,
        ownership: SemanticTextOwnership.mixedStructured,
        sourceText: 'Use Soy de with a place.',
        values: const {'uk': 'Use Soy de with a place.'},
        review: const {'uk': SemanticReviewStatus.approved},
        protectedSpans: const [
          ProtectedLocalizationSpan(
            id: 'span_1',
            type: ProtectedSpanType.targetText,
            text: 'Soy de',
          ),
        ],
        context: const SemanticLocalizationContext(
          courseId: 'es.a0',
          moduleId: 'es.a0.m01',
          lessonId: 'es.a0.m01.l001',
          contentObjectId: 'template.fixture',
          fieldPath: 'prompt_template',
          contentKind: 'exercise_template',
          pedagogicalRole: 'exercise',
          targetLanguage: 'es',
          supportLocale: 'uk',
        ),
      ),
    ],
  );
}

SemanticLocalizationUnit _copyUnit(
  SemanticLocalizationUnit unit, {
  String? id,
  Map<String, SemanticReviewStatus>? review,
}) {
  return SemanticLocalizationUnit(
    id: id ?? unit.id,
    semanticType: unit.semanticType,
    ownership: unit.ownership,
    sourceText: unit.sourceText,
    values: unit.values,
    review: review ?? unit.review,
    context: unit.context,
    protectedSpans: unit.protectedSpans,
    notes: unit.notes,
  );
}

void _runTool(List<String> args) {
  final result = Process.runSync('dart', args);
  if (result.exitCode != 0) {
    fail('dart ${args.join(' ')} failed\n${result.stdout}\n${result.stderr}');
  }
}
