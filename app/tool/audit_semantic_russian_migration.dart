import 'dart:convert';
import 'dart:io';

import 'package:tutor_language/core/content/semantic_localization.dart';

const _legacyPath =
    'assets/languages/spanish/localization/support_localizations.json';
const _semanticPaths = [
  'assets/languages/spanish/localization/semantic/uk/shared.json',
  'assets/languages/spanish/localization/semantic/ru/shared.json',
];

void main() {
  final legacy = _readJsonObject(_legacyPath);
  final semanticBundle = _readSemanticBundles(_semanticPaths);
  final coverage = SemanticUkrainianMigrationCoverage.build(
    legacyLocalizationJson: legacy,
    semanticBundle: semanticBundle,
    locale: 'ru',
  );
  final validationIssues = const SemanticLocalizationValidator().validate(
    bundle: semanticBundle,
  );

  stdout.writeln('R2E5R semantic Russian migration audit');
  stdout.writeln('verdict: ${coverage.isProductionComplete ? 'PASS' : 'FAIL'}');
  stdout.writeln('locale: ${coverage.locale}');
  stdout.writeln('legacy Russian fields: ${coverage.legacyFields}');
  stdout.writeln(
    'approved semantic Russian fields: ${coverage.semanticApprovedFields}',
  );
  stdout.writeln(
    'legacy fields covered by semantic: '
    '${coverage.legacyFieldsCoveredBySemantic}',
  );
  stdout.writeln('remaining legacy fields: ${coverage.remainingLegacyFields}');
  stdout.writeln('semantic resolutions: ${coverage.semanticResolutions}');
  stdout.writeln('legacy resolutions: ${coverage.legacyResolutions}');
  stdout.writeln('legacy fallback count: ${coverage.legacyFallbackCount}');
  stdout.writeln('source fallback count: ${coverage.sourceFallbackCount}');
  stdout.writeln('missing count: ${coverage.missingCount}');
  stdout.writeln('generated semantic units: ${coverage.generatedUnits}');
  stdout.writeln('unapproved semantic units: ${coverage.unapprovedUnits}');
  stdout.writeln('semantic validation issues: ${validationIssues.length}');

  if (coverage.isProductionComplete || validationIssues.isNotEmpty) {
    exitCode = 1;
  }
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
