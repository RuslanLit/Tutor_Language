import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../../tool/semantic_scope/module_semantic_scope_extractor.dart';

void main() {
  test('Module 1 scope is derived from Course.modules[0]', () {
    final scope = ModuleSemanticScopeExtractor().extract('es.a0.m01');

    expect(scope.courseId, 'es.a0');
    expect(scope.moduleId, 'es.a0.m01');
    expect(scope.lessonIds, const [
      'es.a0.m06.l016',
      'es.a0.m01.l001',
      'es.a0.m06.l017',
      'es.a0.m01.l002',
      'es.a0.m01.l003',
      'es.a0.m01.l006',
      'es.a0.m04.l010',
    ]);
  });

  test('required support-language semantic scope is complete and stable', () {
    final scope = ModuleSemanticScopeExtractor().extract('es.a0.m01');
    final identities = scope.requiredIdentities
        .map((identity) => identity.stableIdentity)
        .toList();

    expect(scope.requiredIdentities, hasLength(277));
    expect(scope.unresolvedFields, isEmpty);
    expect(scope.validationIssues, isEmpty);
    expect(identities.toSet(), hasLength(identities.length));
    expect(scope.semanticTypeCounts['vocabularyMeaning'], 20);
    expect(scope.semanticTypeCounts['exercisePrompt'], 32);
    expect(scope.semanticTypeCounts['pronunciationHint'], 20);
    expect(scope.semanticTypeCounts['readingRuleTitle'], 11);
    expect(scope.semanticTypeCounts['accessibilityDescription'], 1);
  });

  test('locale-independent and target-owned fields are excluded', () {
    final scope = ModuleSemanticScopeExtractor().extract('es.a0.m01');
    final identities = scope.requiredIdentities
        .map((identity) => identity.stableIdentity)
        .toSet();

    expect(identities.any((identity) => identity.endsWith('|ipa')), isFalse);
    expect(
      identities.any((identity) => identity.contains('|lines.0.spanish|')),
      isFalse,
    );
    expect(
      identities.any(
        (identity) => identity.contains('|text|readingTranslation'),
      ),
      isFalse,
    );
    expect(
      identities.any((identity) => identity.contains('|canonical')),
      isFalse,
    );
  });

  test('same English source in different roles keeps distinct identities', () {
    final scope = ModuleSemanticScopeExtractor().extract('es.a0.m01');
    final option = scope.requiredIdentities.firstWhere(
      (identity) =>
          identity.sourceObjectId ==
              'template.es.a0.m01.l001.meaning_hola.v1' &&
          identity.fieldPath == 'answer_options.option.hello.label',
    );
    final vocabulary = scope.requiredIdentities.firstWhere(
      (identity) =>
          identity.sourceObjectId == 'vocab.es.a0.unit1.hola.v1' &&
          identity.fieldPath == 'native_translation',
    );

    expect(option.englishSource, vocabulary.englishSource);
    expect(option.stableIdentity, isNot(vocabulary.stableIdentity));
  });

  test('scaffold values remain empty and unapproved', () {
    final scaffold = _readScaffold('build/reports/uk_module_1_scaffold_a.json');
    final units = scaffold['units'] as List;

    expect(units, hasLength(280));
    for (final rawUnit in units) {
      final unit = Map<String, Object?>.from(rawUnit as Map);
      final values = Map<String, Object?>.from(unit['values'] as Map);
      final review = Map<String, Object?>.from(unit['review'] as Map);
      expect(values.values, everyElement(''));
      expect(review.values, everyElement('generated'));
    }
  });
}

Map<String, Object?> _readScaffold(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    return {'units': const []};
  }
  return Map<String, Object?>.from(jsonDecode(file.readAsStringSync()) as Map);
}
