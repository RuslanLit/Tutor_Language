import 'dart:convert';
import 'dart:io';

import 'semantic_scope/module_semantic_scope_extractor.dart';
import 'semantic_scope/semantic_scope_models.dart';

const _allowedLocales = {'uk', 'ru'};

void main(List<String> args) {
  final locale = _argValue(args, '--locale');
  final moduleId = _argValue(args, '--module');
  final output = _argValue(args, '--output');
  final force = args.contains('--force');
  final strict = args.contains('--strict');
  if (locale == null || moduleId == null || output == null) {
    stderr.writeln(
      'Usage: dart run tool/create_semantic_localization_scaffold.dart '
      '--locale <uk|ru> --module <moduleId> --output <path> '
      '[--force] [--strict]',
    );
    exitCode = 64;
    return;
  }
  if (!_allowedLocales.contains(locale)) {
    throw StateError('Unsupported scaffold locale: $locale');
  }

  final outputFile = File(output);
  if (outputFile.existsSync() &&
      outputFile.readAsStringSync().trim().isNotEmpty &&
      !force) {
    throw StateError('Refusing to overwrite non-empty scaffold: $output');
  }

  final scope = ModuleSemanticScopeExtractor().extract(moduleId);
  if (strict &&
      (scope.unresolvedFields.isNotEmpty ||
          scope.validationIssues.isNotEmpty)) {
    throw StateError(
      'Semantic scope has unresolved fields or validation issues: '
      '${scope.unresolvedFields.length + scope.validationIssues.length}',
    );
  }

  final bundle = {
    'schemaVersion': 1,
    'targetLanguage': 'es',
    'sourceSupportLocale': 'en',
    'supportLocales': [locale],
    'scaffold': {
      'moduleId': moduleId,
      'courseId': scope.courseId,
      'lessonIds': scope.lessonIds,
      'status': 'draft',
      'localizedValuesAreIntentionallyEmpty': true,
      'requiredIdentityCount': scope.requiredIdentities.length,
      'reusableDependencyCount': scope.reusableDependencies.length,
      'semanticTypeCounts': scope.semanticTypeCounts,
      'sourceAssetCounts': scope.sourceAssetCounts,
      'unresolvedFields': scope.unresolvedFields,
      'validationIssues': scope.validationIssues,
    },
    'units': [
      for (final identity in scope.requiredIdentities)
        _unitFor(locale: locale, moduleId: moduleId, identity: identity),
    ],
  };

  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(bundle)}\n',
  );
  stdout.writeln('semantic scaffold units: ${scope.requiredIdentities.length}');
  stdout.writeln('module: $moduleId');
  stdout.writeln('lesson IDs: ${scope.lessonIds.join(', ')}');
  stdout.writeln('unresolved fields: ${scope.unresolvedFields.length}');
  stdout.writeln('validation issues: ${scope.validationIssues.length}');
  stdout.writeln('output: $output');
}

Map<String, Object?> _unitFor({
  required String locale,
  required String moduleId,
  required SemanticRequiredIdentity identity,
}) {
  return {
    'id': _unitId(locale, moduleId, identity.stableIdentity),
    'semanticType': identity.semanticType,
    'ownership': identity.ownership,
    'sourceAssetPath': identity.sourceAssetPath,
    'requiredness': identity.requiredness,
    'sourceText': identity.englishSource,
    'values': {locale: ''},
    'review': {locale: 'generated'},
    'protectedSpans': [
      for (final span in identity.protectedSpans) span.toJson(),
    ],
    'context': {
      'courseId': 'es.a0',
      'moduleId': identity.moduleId,
      if (identity.lessonIds.isNotEmpty) 'lessonId': identity.lessonIds.first,
      'contentObjectId': identity.sourceObjectId,
      'fieldPath': identity.fieldPath,
      'contentKind': identity.contentKind,
      'pedagogicalRole': identity.pedagogicalRole,
      'targetLanguage': identity.targetLanguage,
      'supportLocale': locale,
      'expectedAnswerContext':
          'R2E5N0A scaffold inventory only; author localized value manually.',
      if (identity.semanticType == 'pronunciationHint')
        'sourceMeaning': identity.englishSource,
    },
    'notes':
        'R2E5N0A scaffold only. Localized value intentionally empty; do not approve without authoring review.',
  };
}

String _unitId(String locale, String moduleId, String identity) {
  final normalized = identity
      .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '')
      .toLowerCase();
  return 'semantic.scaffold.$locale.${moduleId.replaceAll('.', '_')}.$normalized';
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
