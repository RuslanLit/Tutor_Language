import 'dart:convert';
import 'dart:io';

import 'package:tutor_language/core/content/semantic_localization.dart';

const _semanticPaths = [
  'assets/languages/spanish/localization/semantic_reference_slice.json',
  'assets/languages/spanish/localization/semantic_pilot_lessons.json',
];
const _legacyPath =
    'assets/languages/spanish/localization/support_localizations.json';

void main() {
  final semanticBundle = _readSemanticBundles(_semanticPaths);
  final legacy = _readJsonObject(_legacyPath);
  final ukrainianMigration = SemanticUkrainianMigrationCoverage.build(
    legacyLocalizationJson: legacy,
    semanticBundle: semanticBundle,
  );
  final validationIssues = const SemanticLocalizationValidator().validate(
    bundle: semanticBundle,
  );

  final generatedUnits = semanticBundle.units.where((unit) {
    return unit.review.values.any(
      (status) => status == SemanticReviewStatus.generated,
    );
  }).length;
  final approvedUnits = semanticBundle.units.where((unit) {
    return unit.review.values.every(
      (status) => status == SemanticReviewStatus.approved,
    );
  }).length;
  final migratedFieldKeys = {
    for (final unit in semanticBundle.units)
      '${unit.context.contentObjectId}|${unit.context.fieldPath}',
  };
  final legacyFieldKeys = _legacyFieldKeys(legacy);
  final legacyOnlyFields = legacyFieldKeys.difference(migratedFieldKeys);

  final byType = <String, int>{};
  for (final unit in semanticBundle.units) {
    byType.update(
      unit.semanticType.name,
      (count) => count + 1,
      ifAbsent: () => 1,
    );
  }

  final protectedSpanViolations = validationIssues
      .where((issue) => issue.code.startsWith('semantic.protectedSpan'))
      .length;
  final missingContext = validationIssues
      .where((issue) => issue.code == 'semantic.missingRequiredContext')
      .length;
  final namedEntityAmbiguities = validationIssues
      .where((issue) => issue.code.contains('namedEntity'))
      .length;

  stdout.writeln('Semantic localization coverage');
  stdout.writeln('scope: reference slice + R2E4C pilot lessons');
  stdout.writeln('semantic units: ${semanticBundle.units.length}');
  stdout.writeln('approved units: $approvedUnits');
  stdout.writeln('generated units: $generatedUnits');
  stdout.writeln('migrated field keys: ${migratedFieldKeys.length}');
  stdout.writeln('legacy fields: ${legacyFieldKeys.length}');
  stdout.writeln('legacy-only fields: ${legacyOnlyFields.length}');
  stdout.writeln('missing context issues: $missingContext');
  stdout.writeln('protected-span violations: $protectedSpanViolations');
  stdout.writeln('named-entity ambiguities: $namedEntityAmbiguities');
  stdout.writeln('validation issues: ${validationIssues.length}');
  stdout.writeln('ukrainian semantic migration:');
  stdout.writeln(
    '  verdict: ${ukrainianMigration.isProductionComplete ? 'PASS' : 'FAIL'}',
  );
  stdout.writeln(
    '  legacy Ukrainian fields: ${ukrainianMigration.legacyFields}',
  );
  stdout.writeln(
    '  approved semantic Ukrainian fields: '
    '${ukrainianMigration.semanticApprovedFields}',
  );
  stdout.writeln(
    '  legacy fields covered by semantic: '
    '${ukrainianMigration.legacyFieldsCoveredBySemantic}',
  );
  stdout.writeln(
    '  semantic legacy-field coverage: '
    '${(ukrainianMigration.legacyFieldSemanticCoverage * 100).toStringAsFixed(1)}%',
  );
  stdout.writeln(
    '  remaining legacy fields: ${ukrainianMigration.remainingLegacyFields}',
  );
  stdout.writeln(
    '  semantic resolutions: ${ukrainianMigration.semanticResolutions}',
  );
  stdout.writeln(
    '  legacy resolutions: ${ukrainianMigration.legacyResolutions}',
  );
  stdout.writeln(
    '  source fallback count: ${ukrainianMigration.sourceFallbackCount}',
  );
  stdout.writeln('  missing count: ${ukrainianMigration.missingCount}');
  stdout.writeln('by semantic type:');
  for (final entry
      in byType.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    stdout.writeln('  ${entry.key}: ${entry.value}');
  }
}

Set<String> _legacyFieldKeys(Map<String, Object?> legacy) {
  final keys = <String>{};
  for (final rawEntry
      in (legacy['entries'] as List? ?? const []).whereType<Map>()) {
    final entry = Map<String, Object?>.from(rawEntry);
    final id = entry['id'] as String? ?? '';
    final fields = Map<String, Object?>.from(
      entry['fields'] as Map? ?? const {},
    );
    for (final field in fields.keys) {
      keys.add('$id|$field');
    }
  }
  return keys;
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
