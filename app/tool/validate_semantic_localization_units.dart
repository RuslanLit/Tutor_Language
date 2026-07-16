import 'dart:convert';
import 'dart:io';

import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_models.dart';
import 'package:tutor_language/core/content/semantic_localization.dart';

const _semanticPaths = [
  'assets/languages/spanish/localization/semantic_reference_slice.json',
  'assets/languages/spanish/localization/semantic_pilot_lessons.json',
];
const _pronunciationPath =
    'assets/languages/spanish/pronunciation/reference_slice.json';

void main() {
  final semanticBundle = _readSemanticBundles(_semanticPaths);
  final pronunciationBundle = PronunciationBundle.fromJson(
    _readJsonObject(_pronunciationPath),
  );
  final catalog = PronunciationCatalog(bundle: pronunciationBundle);

  final issues = <SemanticLocalizationValidationIssue>[
    ...const SemanticLocalizationValidator().validate(bundle: semanticBundle),
    ..._validateReferenceSliceSemantics(semanticBundle),
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

List<SemanticLocalizationValidationIssue> _validateReferenceSliceSemantics(
  SemanticLocalizationBundle bundle,
) {
  final issues = <SemanticLocalizationValidationIssue>[];
  final unitsById = {for (final unit in bundle.units) unit.id: unit};

  void expectUnit(String id) {
    if (!unitsById.containsKey(id)) {
      issues.add(
        SemanticLocalizationValidationIssue(
          code: 'semantic.requiredReferenceUnitMissing',
          unitId: id,
          message: 'Required R2E4B reference unit is missing.',
        ),
      );
    }
  }

  for (final id in const [
    'semantic.es.a0.vocab.hola.meaning.uk.v1',
    'semantic.es.a0.pron.hola.hint.uk.v1',
    'semantic.es.a0.vocab.hambre.meaning.uk.v1',
    'semantic.es.a0.pron.hambre.hint.uk.v1',
    'semantic.es.a0.entity.mexico.country.meaning.uk.v1',
    'semantic.es.a0.entity.mexico.country.pronunciation.uk.v1',
    'semantic.es.a0.entity.ciudad_de_mexico.city.meaning.uk.v1',
    'semantic.es.a0.entity.chile.country.meaning.uk.v1',
    'semantic.es.a0.phrase.me_llamo.meaning.uk.v1',
    'semantic.es.a0.phrase.se_llama.meaning.uk.v1',
    'semantic.es.a0.prompt.como_es.meaning.uk.v1',
    'semantic.es.a0.word.simpatica.meaning.uk.v1',
    'semantic.es.a0.word.simpatico.meaning.uk.v1',
    'semantic.es.a0.grapheme.ll.designation.uk.v1',
    'semantic.es.a0.instruction.use_soy_de.uk.v1',
    'semantic.es.a0.feedback.silent_h.hola.uk.v1',
    'semantic.es.a0.remediation.me_llamo.uk.v1',
  ]) {
    expectUnit(id);
  }

  final mexico =
      unitsById['semantic.es.a0.entity.mexico.country.meaning.uk.v1'];
  final mexicoHint =
      unitsById['semantic.es.a0.entity.mexico.country.pronunciation.uk.v1'];
  final city =
      unitsById['semantic.es.a0.entity.ciudad_de_mexico.city.meaning.uk.v1'];
  if (mexico?.context.namedEntityType != NamedEntityType.country ||
      mexico?.values['uk'] != 'Мексика') {
    issues.add(
      const SemanticLocalizationValidationIssue(
        code: 'semantic.countryMeaningInvalid',
        unitId: 'semantic.es.a0.entity.mexico.country.meaning.uk.v1',
        message: 'México country must resolve to Ukrainian meaning Мексика.',
      ),
    );
  }
  if (mexicoHint?.semanticType != SemanticLocalizationType.pronunciationHint ||
      mexicoHint?.values['uk'] != 'ме́хіко') {
    issues.add(
      const SemanticLocalizationValidationIssue(
        code: 'semantic.pronunciationHintInvalid',
        unitId: 'semantic.es.a0.entity.mexico.country.pronunciation.uk.v1',
        message: 'México pronunciation hint must remain ме́хіко.',
      ),
    );
  }
  if (city?.context.namedEntityType != NamedEntityType.city ||
      city?.values['uk'] != 'Мехіко') {
    issues.add(
      const SemanticLocalizationValidationIssue(
        code: 'semantic.cityMeaningInvalid',
        unitId: 'semantic.es.a0.entity.ciudad_de_mexico.city.meaning.uk.v1',
        message:
            'Ciudad de México city must resolve to Ukrainian meaning Мехіко.',
      ),
    );
  }
  if (mexico?.values['uk'] == city?.values['uk']) {
    issues.add(
      const SemanticLocalizationValidationIssue(
        code: 'semantic.countryCityCollapsed',
        message: 'Country and city meanings must not collapse.',
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
