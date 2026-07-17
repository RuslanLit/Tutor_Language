import 'dart:convert';
import 'dart:io';

import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_models.dart';
import 'package:tutor_language/core/content/semantic_localization.dart';
import 'package:tutor_language/features/lesson_assembly/pedagogical_contract_validator.dart';

import 'semantic_scope/module_semantic_scope_extractor.dart';

const _semanticPaths = [
  'assets/languages/spanish/localization/semantic/uk/shared.json',
  'assets/languages/spanish/localization/semantic/uk/module_01.json',
  'assets/languages/spanish/localization/semantic/ru/shared.json',
];
const _pronunciationPath =
    'assets/languages/spanish/pronunciation/reference_slice.json';

void main() {
  final semanticBundle = _readSemanticBundles(_semanticPaths);
  final module1Scope = ModuleSemanticScopeExtractor().extract('es.a0.m01');
  final pronunciationBundle = PronunciationBundle.fromJson(
    _readJsonObject(_pronunciationPath),
  );
  final catalog = PronunciationCatalog(bundle: pronunciationBundle);

  final issues = <SemanticLocalizationValidationIssue>[
    ...const SemanticLocalizationValidator().validate(bundle: semanticBundle),
    ...const PedagogicalContractValidator()
        .validateSemanticApproval(semanticBundle)
        .map(
          (issue) => SemanticLocalizationValidationIssue(
            code: issue.code,
            unitId: issue.objectId,
            message: issue.message,
          ),
        ),
    ..._validateProductionState(
      semanticBundle,
      allowedUkrainianIdentities: {
        for (final identity in module1Scope.requiredIdentities)
          identity.stableIdentity,
      },
    ),
    ..._validateReadingRuleApplicability(catalog),
  ];

  stdout.writeln('Semantic localization unit validation');
  stdout.writeln('units: ${semanticBundle.units.length}');
  stdout.writeln('issues: ${issues.length}');
  final byCode = <String, int>{};
  for (final issue in issues) {
    byCode.update(issue.code, (count) => count + 1, ifAbsent: () => 1);
  }
  for (final entry
      in byCode.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    stdout.writeln('  ${entry.key}: ${entry.value}');
  }
  for (final issue in issues.take(200)) {
    stdout.writeln(issue);
  }
  if (issues.isNotEmpty) {
    exitCode = 1;
  }
}

List<SemanticLocalizationValidationIssue> _validateProductionState(
  SemanticLocalizationBundle bundle, {
  required Set<String> allowedUkrainianIdentities,
}) {
  final issues = <SemanticLocalizationValidationIssue>[];
  final approvedUkrainianIdentities = <String>{};
  for (final unit in bundle.units) {
    for (final entry in unit.review.entries) {
      if (entry.key == 'ru' &&
          entry.value == SemanticReviewStatus.productionApproved) {
        issues.add(
          SemanticLocalizationValidationIssue(
            code: 'semantic.russianApprovedProductionUnit',
            unitId: unit.id,
            message: 'Russian production semantic units are outside R2E5N1.',
          ),
        );
      }
      if (entry.key == 'uk') {
        if (!allowedUkrainianIdentities.contains(unit.identityKey)) {
          issues.add(
            SemanticLocalizationValidationIssue(
              code: 'semantic.ukrainianUnitOutsideModule1Scope',
              unitId: unit.id,
              message:
                  'Ukrainian production unit is outside the R2E5N1 Module 1 scope.',
            ),
          );
        }
        if (entry.value == SemanticReviewStatus.productionApproved) {
          approvedUkrainianIdentities.add(unit.identityKey);
        }
      }
    }
    for (final entry in unit.values.entries) {
      if (entry.value.trim().isEmpty) {
        issues.add(
          SemanticLocalizationValidationIssue(
            code: 'semantic.emptyValue',
            unitId: unit.id,
            message: 'Empty localized value must not be treated as valid.',
          ),
        );
      }
    }
  }
  final missing =
      allowedUkrainianIdentities
          .difference(approvedUkrainianIdentities)
          .toList()
        ..sort();
  for (final identity in missing) {
    issues.add(
      SemanticLocalizationValidationIssue(
        code: 'semantic.ukrainianModule1ApprovedUnitMissing',
        message: 'Missing approved Ukrainian semantic unit for $identity.',
      ),
    );
  }
  return issues;
}

List<SemanticLocalizationValidationIssue> _validateReadingRuleApplicability(
  PronunciationCatalog catalog,
) {
  final issues = <SemanticLocalizationValidationIssue>[];

  final holaRules = catalog.applicableRulesForPronunciationUnit(
    'pronunciation.es.word.hola.v1',
  );
  if (!holaRules.any(
    (rule) => rule.id == 'pronunciation.es.rule.silent_h.v1',
  )) {
    issues.add(
      const SemanticLocalizationValidationIssue(
        code: 'readingRule.holaSilentHMissing',
        unitId: 'pronunciation.es.word.hola.v1',
        message: 'hola must receive the silent-h rule.',
      ),
    );
  }

  final chileRules = catalog.applicableRulesForPronunciationUnit(
    'pronunciation.es.word.chile.v1',
  );
  if (chileRules.any(
    (rule) => rule.id == 'pronunciation.es.rule.silent_h.v1',
  )) {
    issues.add(
      const SemanticLocalizationValidationIssue(
        code: 'readingRule.chileSilentHInvalid',
        unitId: 'pronunciation.es.word.chile.v1',
        message: 'Chile must not receive a silent-h rule; ch is a digraph.',
      ),
    );
  }

  final llGraphemes = segmentSpanishGraphemes('ll');
  final graphemes = segmentSpanishGraphemes('rr que Chile');
  if (!llGraphemes.contains('ll') ||
      llGraphemes.where((grapheme) => grapheme == 'l').isNotEmpty) {
    issues.add(
      const SemanticLocalizationValidationIssue(
        code: 'readingRule.llDigraphSegmentationInvalid',
        message:
            'll must be segmented as a digraph, not two independent l units.',
      ),
    );
  }
  if (!graphemes.contains('rr')) {
    issues.add(
      const SemanticLocalizationValidationIssue(
        code: 'readingRule.rrDigraphSegmentationInvalid',
        message: 'rr must be segmented as its own digraph.',
      ),
    );
  }
  if (!graphemes.contains('qu') ||
      graphemes.contains('q') ||
      graphemes.contains('u')) {
    issues.add(
      const SemanticLocalizationValidationIssue(
        code: 'readingRule.quDigraphSegmentationInvalid',
        message: 'qu must use digraph precedence over independent q/u.',
      ),
    );
  }
  if (!graphemes.contains('ch') || graphemes.contains('h')) {
    issues.add(
      const SemanticLocalizationValidationIssue(
        code: 'readingRule.chDigraphSegmentationInvalid',
        message: 'ch must use digraph precedence over independent h.',
      ),
    );
  }

  return issues;
}

Map<String, Object?> _readJsonObject(String path) {
  final raw = jsonDecode(_resolveFile(path).readAsStringSync());
  if (raw is! Map) {
    throw FormatException('Expected JSON object at $path');
  }
  return Map<String, Object?>.from(raw);
}

SemanticLocalizationBundle _readSemanticBundles(List<String> paths) {
  final bundles = [
    for (final path in paths)
      SemanticLocalizationBundle.fromJson(_readJsonObject(path)),
  ];
  final first = bundles.first;
  return SemanticLocalizationBundle(
    schemaVersion: first.schemaVersion,
    targetLanguage: first.targetLanguage,
    sourceSupportLocale: first.sourceSupportLocale,
    supportLocales: List.unmodifiable(
      {for (final bundle in bundles) ...bundle.supportLocales}.toList()..sort(),
    ),
    requiredSemanticFields: Set.unmodifiable({
      for (final bundle in bundles) ...bundle.requiredSemanticFields,
    }),
    units: List.unmodifiable([for (final bundle in bundles) ...bundle.units]),
  );
}

File _resolveFile(String appRelativePath) {
  final candidates = [File(appRelativePath), File('app/$appRelativePath')];
  for (final candidate in candidates) {
    if (candidate.existsSync()) {
      return candidate;
    }
  }
  throw StateError('File not found: $appRelativePath');
}
