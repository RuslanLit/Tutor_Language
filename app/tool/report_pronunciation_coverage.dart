import 'dart:convert';
import 'dart:io';

import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_models.dart';
import 'package:tutor_language/core/content/topic_content.dart';

import 'spanish_a0_pronunciation_inventory_support.dart';

void main() {
  final root = Directory('assets/languages/spanish');
  if (!root.existsSync()) {
    stderr.writeln('Run from app/.');
    exitCode = 1;
    return;
  }

  final vocabulary = _loadVocabulary(root);
  final productionInventory = buildSpanishA0PronunciationInventory(
    appDirectory: Directory.current,
  );
  final allEntries = vocabulary.expand((content) => content.entries).toList();
  final legacyEntries = allEntries
      .where((entry) => entry.pronunciation != null)
      .toList();
  final pronunciationCapableEntries = allEntries.where((entry) {
    return entry.pronunciation != null || entry.pronunciationUnitId != null;
  }).toList();
  final uniqueTargets = legacyEntries.map((entry) => entry.spanish).toSet();

  final catalog = _loadCatalog(root, vocabulary);
  final ruleIds = catalog.rules.map((rule) => rule.id).toSet();
  final ruleRefsInLessons =
      _countRuleReferencesInDirectory(
        Directory('${root.path}/curriculum'),
        ruleIds,
      ) +
      _countRulesWithRelatedContentInDirectory(
        catalog.rules,
        Directory('${root.path}/curriculum'),
      );
  final ruleRefsInExercises =
      _countRuleReferencesInDirectory(
        Directory('${root.path}/templates'),
        ruleIds,
      ) +
      _countRulesWithRelatedContentInDirectory(
        catalog.rules,
        Directory('${root.path}/templates'),
      );
  final report = catalog.coverageReport(
    legacyPronunciationFieldsDiscovered: legacyEntries.length,
    uniqueTargetForms: uniqueTargets.length,
    pronunciationCapableVocabularyEntries: pronunciationCapableEntries.length,
    readingRulesReferencedByLessons: ruleRefsInLessons,
    readingRulesReferencedByExercises: ruleRefsInExercises,
  );

  stdout.writeln('Pronunciation coverage');
  stdout.writeln(
    'productionLessonsAudited=${productionInventory.lessonsAudited}',
  );
  stdout.writeln(
    'productionLearnerFacingForms=${productionInventory.totalItems}',
  );
  stdout.writeln(
    'productionPronunciationCovered=${productionInventory.coveredItems}',
  );
  stdout.writeln(
    'productionPronunciationMissing=${productionInventory.missingItems}',
  );
  stdout.writeln('productionUniqueForms=${productionInventory.uniqueForms}');
  stdout.writeln(
    'productionMissingUniqueForms=${productionInventory.missingUniqueForms}',
  );
  stdout.writeln(
    'legacyPronunciationFields=${report.legacyPronunciationFieldsDiscovered}',
  );
  stdout.writeln('uniqueTargetForms=${report.uniqueTargetForms}');
  stdout.writeln(
    'pronunciationCapableVocabularyEntries=${report.pronunciationCapableVocabularyEntries}',
  );
  stdout.writeln('pronunciationUnits=${report.pronunciationUnits}');
  stdout.writeln('unitsWithDeclaredVariety=${report.unitsWithDeclaredVariety}');
  stdout.writeln('unitsWithIpa=${report.unitsWithIpa}');
  stdout.writeln(
    'unitsWithEnglishLearnerHint=${report.unitsWithEnglishLearnerHint}',
  );
  stdout.writeln(
    'unitsWithRussianLearnerHint=${report.unitsWithRussianLearnerHint}',
  );
  stdout.writeln(
    'multisyllabicRussianHintsWithStress=${report.multisyllabicRussianHintsWithStress}',
  );
  stdout.writeln(
    'unitsWithRussianExplanation=${report.unitsWithRussianExplanation}',
  );
  stdout.writeln('unitsWithExample=${report.unitsWithExample}');
  stdout.writeln(
    'unitsRequiringExplanation=${report.unitsRequiringExplanation}',
  );
  stdout.writeln(
    'unitsWithRequiredExplanation=${report.unitsWithRequiredExplanation}',
  );
  stdout.writeln('readingRules=${report.readingRules}');
  stdout.writeln('unitsReferencingRules=${report.unitsReferencingRules}');
  stdout.writeln('readingRulesDiscovered=${report.readingRulesDiscovered}');
  stdout.writeln('readingRulesMigrated=${report.readingRulesMigrated}');
  stdout.writeln('readingRulesWithVariety=${report.readingRulesWithVariety}');
  stdout.writeln(
    'readingRulesWithPhoneticDefinition=${report.readingRulesWithPhoneticDefinition}',
  );
  stdout.writeln(
    'readingRulesWithEnglishLocalization=${report.readingRulesWithEnglishLocalization}',
  );
  stdout.writeln(
    'readingRulesWithRussianLocalization=${report.readingRulesWithRussianLocalization}',
  );
  stdout.writeln('readingRulesWithExamples=${report.readingRulesWithExamples}');
  stdout.writeln(
    'readingRulesReferencedByPronunciationUnits=${report.readingRulesReferencedByPronunciationUnits}',
  );
  stdout.writeln(
    'readingRulesReferencedByLessons=${report.readingRulesReferencedByLessons}',
  );
  stdout.writeln(
    'readingRulesReferencedByExercises=${report.readingRulesReferencedByExercises}',
  );
  stdout.writeln('unusedReadingRules=${report.unusedReadingRules}');
  stdout.writeln(
    'invalidReadingRuleReferences=${report.invalidReadingRuleReferences}',
  );
  stdout.writeln(
    'crossLocaleReadingRuleFallbackAttempts=${report.crossLocaleReadingRuleFallbackAttempts}',
  );
  stdout.writeln('llYPronunciationUnits=${report.llYPronunciationUnits}');
  stdout.writeln(
    'llYUnitsConsistentWithSelectedVariety=${report.llYUnitsConsistentWithSelectedVariety}',
  );
  stdout.writeln('llYUnitsWithMatchingIpa=${report.llYUnitsWithMatchingIpa}');
  stdout.writeln('llYUnitsWithRussianHint=${report.llYUnitsWithRussianHint}');
  stdout.writeln('llYUnitsWithEnglishHint=${report.llYUnitsWithEnglishHint}');
  stdout.writeln(
    'llYUnitsWithGraphemeExplanation=${report.llYUnitsWithGraphemeExplanation}',
  );
  stdout.writeln('llYVarietyMismatches=${report.llYVarietyMismatches}');
  stdout.writeln(
    'nonYeistaHintsInYeistaProfile=${report.nonYeistaHintsInYeistaProfile}',
  );
  stdout.writeln('unmigratedLegacyEntries=${report.unmigratedLegacyEntries}');
  stdout.writeln(
    'crossLocaleFallbackAttempts=${report.crossLocaleFallbackAttempts}',
  );
  stdout.writeln('invalidUnits=${report.invalidUnits}');
  stdout.writeln('unknownReferences=${report.unknownReferences}');

  if (!productionInventory.isComplete) {
    exitCode = 1;
  }
}

int _countRuleReferencesInDirectory(Directory directory, Set<String> ruleIds) {
  if (!directory.existsSync()) {
    return 0;
  }
  final referenced = <String>{};
  for (final file in _jsonFiles(directory)) {
    final text = file.readAsStringSync();
    for (final ruleId in ruleIds) {
      if (text.contains(ruleId)) {
        referenced.add(ruleId);
      }
    }
  }
  return referenced.length;
}

int _countRulesWithRelatedContentInDirectory(
  Iterable<PronunciationReadingRule> rules,
  Directory directory,
) {
  if (!directory.existsSync()) {
    return 0;
  }
  final text = _jsonFiles(
    directory,
  ).map((file) => file.readAsStringSync()).join('\n');
  return rules.where((rule) {
    return rule.relatedContentIds.any(text.contains);
  }).length;
}

PronunciationCatalog _loadCatalog(
  Directory root,
  List<VocabularyContent> vocabulary,
) {
  final pronunciationFile = File(
    '${root.path}/pronunciation/reference_slice.json',
  );
  final decoded = jsonDecode(pronunciationFile.readAsStringSync());
  if (decoded is! Map) {
    throw const FormatException('Pronunciation bundle must be an object');
  }

  final bundle = PronunciationBundle.fromJson(
    Map<String, Object?>.from(decoded),
  );
  return PronunciationCatalog(bundle: bundle, vocabularyContents: vocabulary);
}

List<VocabularyContent> _loadVocabulary(Directory root) {
  final vocabularyDir = Directory('${root.path}/vocabulary');
  return [
    for (final file in _jsonFiles(vocabularyDir))
      VocabularyContent(
        assetPath: file.path,
        entries: _loadVocabularyItems(file),
      ),
  ];
}

List<VocabularyItem> _loadVocabularyItems(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! List) {
    return const [];
  }

  return [
    for (final item in decoded)
      if (item is Map) VocabularyItem.fromJson(Map<String, Object?>.from(item)),
  ];
}

Iterable<File> _jsonFiles(Directory directory) sync* {
  final files =
      directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    yield file;
  }
}
