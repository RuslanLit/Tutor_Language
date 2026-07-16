import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/content_localization.dart';
import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_loader.dart';
import 'package:tutor_language/core/content/semantic_localization.dart';
import 'package:tutor_language/core/content/topic_content.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'semantic type and ownership parsing covers the reference slice',
    () async {
      final bundle = await _loadSemanticBundle();

      expect(bundle.units, isNotEmpty);
      expect(
        bundle.units.map((unit) => unit.semanticType),
        containsAll([
          SemanticLocalizationType.vocabularyMeaning,
          SemanticLocalizationType.pronunciationHint,
          SemanticLocalizationType.exercisePrompt,
          SemanticLocalizationType.feedback,
          SemanticLocalizationType.remediation,
        ]),
      );
      expect(
        bundle.units.map((unit) => unit.ownership),
        containsAll([
          SemanticTextOwnership.supportLanguageOwned,
          SemanticTextOwnership.localeIndependent,
          SemanticTextOwnership.mixedStructured,
        ]),
      );
    },
  );

  test('protected spans and Spanish target text are preserved', () async {
    final bundle = await _loadSemanticBundle();
    final instruction = bundle.units.firstWhere(
      (unit) => unit.id == 'semantic.es.a0.instruction.use_soy_de.uk.v1',
    );

    expect(instruction.protectedSpans.single.text, 'Soy de');
    expect(instruction.values['uk'], contains('Soy de'));
    expect(
      const SemanticLocalizationValidator().validate(bundle: bundle),
      isEmpty,
    );
  });

  test('IPA remains locale independent and unchanged', () async {
    final bundle = await _loadSemanticBundle();
    final ipa = bundle.units.firstWhere(
      (unit) => unit.id == 'semantic.es.a0.pron.hola.ipa.v1',
    );

    expect(ipa.ownership, SemanticTextOwnership.localeIndependent);
    expect(ipa.values['en'], '/ˈola/');
    expect(ipa.values['uk'], '/ˈola/');
  });

  test('meaning and pronunciation hint roles are separated', () async {
    final bundle = await _loadSemanticBundle();
    final mexico = bundle.units.firstWhere(
      (unit) => unit.id == 'semantic.es.a0.entity.mexico.country.meaning.uk.v1',
    );
    final mexicoHint = bundle.units.firstWhere(
      (unit) =>
          unit.id == 'semantic.es.a0.entity.mexico.country.pronunciation.uk.v1',
    );

    expect(mexico.semanticType, SemanticLocalizationType.countryName);
    expect(mexico.values['uk'], 'Мексика');
    expect(mexicoHint.semanticType, SemanticLocalizationType.pronunciationHint);
    expect(mexicoHint.values['uk'], 'ме́хіко');
    expect(mexico.values['uk'], isNot(mexicoHint.values['uk']));
  });

  test('Mexico country and Ciudad de Mexico city remain distinct', () async {
    final bundle = await _loadSemanticBundle();
    final country = bundle.units.firstWhere(
      (unit) => unit.id == 'semantic.es.a0.entity.mexico.country.meaning.uk.v1',
    );
    final city = bundle.units.firstWhere(
      (unit) =>
          unit.id ==
          'semantic.es.a0.entity.ciudad_de_mexico.city.meaning.uk.v1',
    );

    expect(country.context.namedEntityType, NamedEntityType.country);
    expect(city.context.namedEntityType, NamedEntityType.city);
    expect(country.values['uk'], 'Мексика');
    expect(city.values['uk'], 'Мехіко');
  });

  test('se llama context and Como es context are explicit', () async {
    final bundle = await _loadSemanticBundle();
    final seLlama = bundle.units.firstWhere(
      (unit) => unit.id == 'semantic.es.a0.phrase.se_llama.meaning.uk.v1',
    );
    final comoEs = bundle.units.firstWhere(
      (unit) => unit.id == 'semantic.es.a0.prompt.como_es.meaning.uk.v1',
    );

    expect(seLlama.context.grammaticalPerson, GrammaticalPerson.third);
    expect(seLlama.values['uk'], contains('se llama'));
    expect(comoEs.context.expectedAnswerContext, contains('gender-neutral'));
    expect(comoEs.values['uk'], contains('¿Cómo es?'));
  });

  test('simpatico and simpatica carry gender metadata', () async {
    final bundle = await _loadSemanticBundle();
    final feminine = bundle.units.firstWhere(
      (unit) => unit.id == 'semantic.es.a0.word.simpatica.meaning.uk.v1',
    );
    final masculine = bundle.units.firstWhere(
      (unit) => unit.id == 'semantic.es.a0.word.simpatico.meaning.uk.v1',
    );

    expect(feminine.context.grammaticalGender, GrammaticalGender.feminine);
    expect(feminine.values['uk'], 'приємна');
    expect(masculine.context.grammaticalGender, GrammaticalGender.masculine);
    expect(masculine.values['uk'], 'приємний');
  });

  test(
    'generated status is rejected and approved status is accepted',
    () async {
      final bundle = await _loadSemanticBundle();
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
      expect(
        const SemanticLocalizationValidator().validate(bundle: bundle),
        isEmpty,
      );
    },
  );

  test('deterministic serialization is stable', () async {
    final bundle = await _loadSemanticBundle();

    final first = serializeSemanticLocalizationBundle(bundle);
    final second = serializeSemanticLocalizationBundle(
      SemanticLocalizationBundle.fromJson(
        Map<String, Object?>.from(jsonDecode(first) as Map),
      ),
    );

    expect(second, first);
  });

  test('duplicate semantic identity conflict fails', () async {
    final bundle = await _loadSemanticBundle();
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
    'semantic units override legacy values for migrated vocabulary',
    () async {
      final localization = await _loadLegacyLocalization();
      final semantic = await _loadSemanticBundle();
      final content = await ContentLoader().loadLanguagePackContent();
      final resolver = EducationalContentLocalizationResolver(
        localization,
        semanticBundle: semantic,
      );
      final mexico = content.contents
          .whereType<VocabularyContent>()
          .expand((content) => content.entries)
          .firstWhere((item) => item.id == 'vocab.es.a0.m03.mexico.v1');

      final resolved = resolver.resolveVocabularyItem(
        mexico,
        SupportLocale.ukrainian,
      );

      expect(resolved.nativeTranslation, 'Мексика');
    },
  );

  test('legacy fallback still works for unmigrated content', () async {
    final localization = await _loadLegacyLocalization();
    final semantic = await _loadSemanticBundle();
    final content = await ContentLoader().loadLanguagePackContent();
    final resolver = EducationalContentLocalizationResolver(
      localization,
      semanticBundle: semantic,
    );
    final adios = content.contents
        .whereType<VocabularyContent>()
        .expand((content) => content.entries)
        .firstWhere((item) => item.id == 'vocab.es.a0.unit1.adios.v1');

    final resolved = resolver.resolveVocabularyItem(
      adios,
      SupportLocale.ukrainian,
    );

    expect(resolved.nativeTranslation, isNotEmpty);
    expect(resolved.nativeTranslation, isNot(adios.nativeTranslation));
  });

  test(
    'R2E5 Ukrainian migration coverage exposes remaining legacy fields',
    () async {
      final localization = await _loadRawLegacyLocalization();
      final semantic = await _loadRuntimeSemanticBundle();

      final coverage = SemanticUkrainianMigrationCoverage.build(
        legacyLocalizationJson: localization,
        semanticBundle: semantic,
      );

      expect(coverage.legacyFields, 2742);
      expect(coverage.semanticApprovedFields, 381);
      expect(coverage.legacyFieldsCoveredBySemantic, 168);
      expect(coverage.remainingLegacyFields, 2574);
      expect(coverage.semanticResolutions, 168);
      expect(coverage.legacyResolutions, 2574);
      expect(coverage.sourceFallbackCount, 0);
      expect(coverage.missingCount, 0);
      expect(coverage.isProductionComplete, isFalse);
    },
  );

  test('semantic prompt override preserves protected target span', () async {
    final localization = await _loadLegacyLocalization();
    final semantic = await _loadSemanticBundle();
    final content = await ContentLoader().loadLanguagePackContent();
    final resolver = EducationalContentLocalizationResolver(
      localization,
      semanticBundle: semantic,
    );
    final template = content.contents
        .whereType<ExerciseTemplateContent>()
        .expand((content) => content.templates)
        .firstWhere(
          (template) =>
              template.id == 'template.es.a0.m03.l013.type_soy_de_mexico.v1',
        );

    final resolved = resolver.resolveExerciseTemplate(
      template,
      SupportLocale.ukrainian,
    );

    expect(
      resolved.promptTemplate,
      'Використайте конструкцію «Soy de» з назвою місця.',
    );
  });

  test('reading rule applicability is grapheme aware', () async {
    final bundle = await PronunciationLoader().loadBundle();
    final catalog = PronunciationCatalog(bundle: bundle);

    expect(
      catalog
          .applicableRulesForPronunciationUnit('pronunciation.es.word.hola.v1')
          .map((rule) => rule.id),
      contains('pronunciation.es.rule.silent_h.v1'),
    );
    expect(
      catalog
          .applicableRulesForPronunciationUnit('pronunciation.es.word.chile.v1')
          .map((rule) => rule.id),
      isNot(contains('pronunciation.es.rule.silent_h.v1')),
    );
  });

  test('digraph precedence covers ll, rr, qu, and ch', () {
    final graphemes = segmentSpanishGraphemes('ll rr que Chile');

    expect(graphemes, containsAll(['ll', 'rr', 'qu', 'ch']));
    expect(graphemes.where((grapheme) => grapheme == 'q'), isEmpty);
    expect(graphemes.where((grapheme) => grapheme == 'h'), isEmpty);
  });
}

Future<SemanticLocalizationBundle> _loadSemanticBundle() async {
  final raw = await rootBundle.loadString(
    'assets/languages/spanish/localization/semantic_reference_slice.json',
  );
  return SemanticLocalizationBundle.fromJson(
    Map<String, Object?>.from(jsonDecode(raw) as Map),
  );
}

Future<EducationalContentLocalizationBundle> _loadLegacyLocalization() {
  return EducationalContentLocalizationRepository().loadBundle();
}

Future<Map<String, Object?>> _loadRawLegacyLocalization() async {
  final raw = await rootBundle.loadString(
    'assets/languages/spanish/localization/support_localizations.json',
  );
  return Map<String, Object?>.from(jsonDecode(raw) as Map);
}

Future<SemanticLocalizationBundle> _loadRuntimeSemanticBundle() {
  return SemanticLocalizationRepository().loadBundle();
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
