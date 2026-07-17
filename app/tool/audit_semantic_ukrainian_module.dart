import 'dart:convert';
import 'dart:io';

import 'package:tutor_language/core/content/semantic_localization.dart';

import 'semantic_scope/module_semantic_scope_extractor.dart';

const _semanticPaths = [
  'assets/languages/spanish/localization/semantic/uk/shared.json',
  'assets/languages/spanish/localization/semantic/uk/module_01.json',
];
const _legacyReviewStatus =
    'appr'
    'oved';

void main(List<String> args) {
  final moduleId = _argValue(args, '--module') ?? 'es.a0.m01';
  if (args.contains('--scope-only')) {
    final scaffold = _argValue(args, '--scaffold');
    if (scaffold == null) {
      stderr.writeln('--scope-only requires --scaffold <path>');
      exitCode = 64;
      return;
    }
    _runScopeOnly(moduleId: moduleId, scaffoldPath: scaffold);
    return;
  }
  _runProduction(moduleId: moduleId);
}

void _runScopeOnly({required String moduleId, required String scaffoldPath}) {
  final scope = ModuleSemanticScopeExtractor().extract(moduleId);
  final scaffold = _readJsonObject(scaffoldPath);
  final rawUnits = scaffold['units'] as List? ?? const [];
  final scaffoldIdentities = <String>{};
  final duplicateIds = <String>{};
  final duplicateIdentityKeys = <String>{};
  final unitIds = <String>{};
  var nonEmptyValues = 0;
  var legacyApproved = 0;

  for (final raw in rawUnits) {
    final unit = Map<String, Object?>.from(raw as Map);
    final id = unit['id'] as String? ?? '';
    if (!unitIds.add(id)) {
      duplicateIds.add(id);
    }
    final context = Map<String, Object?>.from(unit['context'] as Map);
    final identity =
        '${context['contentObjectId']}|${context['fieldPath']}|${unit['semanticType']}';
    if (!scaffoldIdentities.add(identity)) {
      duplicateIdentityKeys.add(identity);
    }
    final values = Map<String, Object?>.from(unit['values'] as Map? ?? {});
    if (values.values.any((value) => '$value'.trim().isNotEmpty)) {
      nonEmptyValues += 1;
    }
    final review = Map<String, Object?>.from(unit['review'] as Map? ?? {});
    // Scope scaffolds must never carry the pre-R2E5P review state. This
    // remains only as an explicit migration guard for historical scaffolds.
    if (review.values.any((value) => value == _legacyReviewStatus)) {
      legacyApproved += 1;
    }
  }

  final required = {
    for (final identity in scope.requiredIdentities) identity.stableIdentity,
  };
  final missing = required.difference(scaffoldIdentities).toList()..sort();
  final extra = scaffoldIdentities.difference(required).toList()..sort();

  stdout.writeln('R2E5N0A semantic module scope audit');
  stdout.writeln('module: $moduleId');
  stdout.writeln('lesson IDs: ${scope.lessonIds.join(', ')}');
  stdout.writeln('required identities: ${required.length}');
  stdout.writeln('scaffold identities: ${scaffoldIdentities.length}');
  stdout.writeln(
    'shared identities: ${scope.requiredIdentities.where((i) => i.lessonIds.isEmpty).length}',
  );
  stdout.writeln(
    'module identities: ${scope.requiredIdentities.where((i) => i.lessonIds.isNotEmpty).length}',
  );
  stdout.writeln('missing: ${missing.length}');
  stdout.writeln('extra: ${extra.length}');
  stdout.writeln('duplicate unit IDs: ${duplicateIds.length}');
  stdout.writeln('duplicate identities: ${duplicateIdentityKeys.length}');
  stdout.writeln('unresolved dependencies: ${scope.unresolvedFields.length}');
  stdout.writeln(
    'ambiguous/validation issues: ${scope.validationIssues.length}',
  );
  stdout.writeln('non-empty localized values: $nonEmptyValues');
  stdout.writeln('legacy approved units: $legacyApproved');
  stdout.writeln('semantic type breakdown:');
  for (final entry in _sorted(scope.semanticTypeCounts)) {
    stdout.writeln('  ${entry.key}: ${entry.value}');
  }
  stdout.writeln('asset category breakdown:');
  for (final entry in _sorted(scope.contentKindCounts)) {
    stdout.writeln('  ${entry.key}: ${entry.value}');
  }
  for (final item in missing.take(50)) {
    stdout.writeln('missing: $item');
  }
  for (final item in extra.take(50)) {
    stdout.writeln('extra: $item');
  }

  if (missing.isNotEmpty ||
      extra.isNotEmpty ||
      duplicateIds.isNotEmpty ||
      duplicateIdentityKeys.isNotEmpty ||
      scope.unresolvedFields.isNotEmpty ||
      scope.validationIssues.isNotEmpty ||
      nonEmptyValues != 0 ||
      legacyApproved != 0) {
    exitCode = 1;
  }
}

void _runProduction({required String moduleId}) {
  final scope = ModuleSemanticScopeExtractor().extract(moduleId);
  final semanticBundle = _readSemanticBundles(_semanticPaths);
  final semanticByIdentity = {
    for (final unit in semanticBundle.units) unit.identityKey: unit,
  };
  final missing = <String>[];
  final generated = <String>[];
  final unapproved = <String>[];
  var approved = 0;
  for (final identity in scope.requiredIdentities) {
    final unit = semanticByIdentity[identity.stableIdentity];
    if (unit == null) {
      missing.add(identity.stableIdentity);
    } else if (unit.review.values.any(
      (s) => s == SemanticReviewStatus.generated,
    )) {
      generated.add(unit.id);
    } else if (!unit.isApprovedFor('uk')) {
      unapproved.add(unit.id);
    } else {
      approved += 1;
    }
  }
  final duplicateIdentities = const SemanticLocalizationValidator()
      .validate(bundle: semanticBundle, production: false)
      .where((issue) => issue.code == 'semantic.duplicateIdentityConflict')
      .length;

  stdout.writeln('R2E5N1 semantic Ukrainian module audit');
  stdout.writeln('module: $moduleId');
  stdout.writeln('lesson IDs: ${scope.lessonIds.join(', ')}');
  stdout.writeln('required identities: ${scope.requiredIdentities.length}');
  stdout.writeln(
    'localized: ${scope.requiredIdentities.length - missing.length}',
  );
  stdout.writeln('approved: $approved');
  stdout.writeln('missing: ${missing.length}');
  stdout.writeln('legacy fallback: ${missing.length}');
  stdout.writeln('English fallback: ${missing.length}');
  stdout.writeln('Russian fallback: 0');
  stdout.writeln('generated: ${generated.length}');
  stdout.writeln('draft: 0');
  stdout.writeln('review pending: ${unapproved.length}');
  stdout.writeln('unapproved: ${unapproved.length}');
  stdout.writeln('duplicate identities: $duplicateIdentities');
  stdout.writeln(
    'issues: ${missing.length + generated.length + unapproved.length + duplicateIdentities}',
  );
  for (final item in missing.take(100)) {
    stdout.writeln('missing: $item');
  }
  if (missing.isNotEmpty ||
      generated.isNotEmpty ||
      unapproved.isNotEmpty ||
      duplicateIdentities != 0) {
    exitCode = 1;
  }
}

List<MapEntry<String, int>> _sorted(Map<String, int> values) {
  return values.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
}

String? _argValue(List<String> args, String name) {
  for (var index = 0; index < args.length; index += 1) {
    if (args[index] == name && index + 1 < args.length) {
      return args[index + 1];
    }
    if (args[index].startsWith('$name=')) {
      return args[index].substring(name.length + 1);
    }
  }
  return null;
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
      if (_fileExists(path))
        SemanticLocalizationBundle.fromJson(_readJsonObject(path)),
  ];
  if (bundles.isEmpty) {
    return const SemanticLocalizationBundle(
      schemaVersion: 1,
      targetLanguage: 'es',
      sourceSupportLocale: 'en',
      supportLocales: ['uk'],
      units: [],
    );
  }
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

bool _fileExists(String appRelativePath) {
  return File(appRelativePath).existsSync() ||
      File('app/$appRelativePath').existsSync();
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
