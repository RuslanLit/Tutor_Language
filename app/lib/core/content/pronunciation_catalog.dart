import 'pronunciation_models.dart';
import 'topic_content.dart';

class PronunciationCatalog {
  PronunciationCatalog({
    required PronunciationBundle bundle,
    Iterable<VocabularyContent> vocabularyContents = const [],
  }) : _bundle = bundle,
       _unitsById = {for (final unit in bundle.units) unit.id.value: unit},
       _rulesById = {for (final rule in bundle.rules) rule.id: rule},
       _localizationsById = {
         for (final entry in bundle.localizations) entry.id: entry,
       },
       _unitsByRelatedContentId = _indexUnitsByRelatedContentId(bundle.units);

  final PronunciationBundle _bundle;
  final Map<String, PronunciationUnit> _unitsById;
  final Map<String, PronunciationReadingRule> _rulesById;
  final Map<String, PronunciationLocalizationEntry> _localizationsById;
  final Map<String, PronunciationUnit> _unitsByRelatedContentId;
  int _crossLocaleFallbackAttempts = 0;

  Iterable<PronunciationUnit> get units => _bundle.units;
  Iterable<PronunciationReadingRule> get rules => _bundle.rules;
  int get crossLocaleFallbackAttempts => _crossLocaleFallbackAttempts;

  PronunciationUnit? unitById(String id) => _unitsById[id];

  PronunciationUnit? unitForContentId(String contentId) {
    return _unitsByRelatedContentId[contentId];
  }

  ResolvedPronunciationPresentation? resolveForVocabularyItem({
    required VocabularyItem item,
    required String supportLocaleCode,
  }) {
    final unit = unitForContentId(item.id);
    if (unit != null) {
      return resolveUnit(unit.id.value, supportLocaleCode: supportLocaleCode);
    }

    if (supportLocaleCode == 'en' &&
        item.pronunciation != null &&
        item.pronunciation!.trim().isNotEmpty) {
      return ResolvedPronunciationPresentation(
        targetOrthography: item.spanish,
        pronunciationVariety: 'legacy',
        localizedLearnerHint: item.pronunciation,
        isLegacyEnglishHint: true,
      );
    }

    if (item.pronunciation != null &&
        item.pronunciation!.trim().isNotEmpty &&
        supportLocaleCode != 'en') {
      return ResolvedPronunciationPresentation(
        targetOrthography: item.spanish,
        pronunciationVariety: 'legacy',
        diagnosticCode: 'pronunciation.legacyEnglishHintInNonEnglishLocale',
      );
    }

    return null;
  }

  ResolvedPronunciationPresentation? resolveUnit(
    String unitId, {
    required String supportLocaleCode,
  }) {
    final unit = _unitsById[unitId];
    if (unit == null) {
      return null;
    }
    final localization = _localizationsById[unit.id.value];
    final locale = _normalizeSupportLocale(supportLocaleCode);
    final localizedHint =
        localization?.learnerHints[locale] ??
        unit.localizedLearnerHints[locale];
    final localizedExplanation = localization?.explanations[locale];

    if (localizedHint == null &&
        locale != 'en' &&
        ((localization?.learnerHints.containsKey('en') ?? false) ||
            unit.localizedLearnerHints.containsKey('en'))) {
      _crossLocaleFallbackAttempts += 1;
    }

    return ResolvedPronunciationPresentation(
      targetOrthography: unit.targetOrthography,
      pronunciationVariety: unit.pronunciationVariety.id,
      localizedLearnerHint: localizedHint,
      ipa: unit.ipa?.value,
      localizedExplanation: localizedExplanation,
      diagnosticCode: localizedHint == null && unit.ipa == null
          ? 'pronunciation.missingLearnerHint'
          : null,
    );
  }

  List<PronunciationValidationIssue> validate() {
    final issues = <PronunciationValidationIssue>[];
    final unitIds = <String>{};
    final ruleIds = <String>{};

    for (final rule in _bundle.rules) {
      if (!ruleIds.add(rule.id)) {
        issues.add(
          const PronunciationValidationIssue(
            code: 'pronunciation.duplicateId',
            severity: PronunciationIssueSeverity.error,
            message: 'Duplicate reading rule id',
          ),
        );
      }
      if (rule.targetLanguage != _bundle.targetLanguage) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.targetMismatch',
            severity: PronunciationIssueSeverity.error,
            message: 'Rule ${rule.id} uses ${rule.targetLanguage}',
          ),
        );
      }
    }

    for (final unit in _bundle.units) {
      if (!unitIds.add(unit.id.value)) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.duplicateId',
            severity: PronunciationIssueSeverity.error,
            message: 'Duplicate unit id ${unit.id.value}',
          ),
        );
      }
      if (unit.targetLanguage != _bundle.targetLanguage) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.targetMismatch',
            severity: PronunciationIssueSeverity.error,
            message: 'Unit ${unit.id.value} uses ${unit.targetLanguage}',
          ),
        );
      }
      if (unit.pronunciationVariety.id.trim().isEmpty) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.missingVariety',
            severity: PronunciationIssueSeverity.error,
            message: 'Missing variety for ${unit.id.value}',
          ),
        );
      }
      if (unit.targetOrthography.trim().isEmpty) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.missingTargetOrthography',
            severity: PronunciationIssueSeverity.error,
            message: 'Missing target orthography for ${unit.id.value}',
          ),
        );
      }
      for (final ruleId in unit.readingRuleIds) {
        if (!_rulesById.containsKey(ruleId)) {
          issues.add(
            PronunciationValidationIssue(
              code: 'pronunciation.unknownReference',
              severity: PronunciationIssueSeverity.error,
              message: 'Unknown rule $ruleId in ${unit.id.value}',
            ),
          );
        }
      }
      if (!unit.localizedLearnerHints.containsKey('ru')) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.missingRequiredHint',
            severity: PronunciationIssueSeverity.warning,
            message: 'Missing ru hint for ${unit.id.value}',
          ),
        );
      }
    }

    for (final localization in _bundle.localizations) {
      if (!_unitsById.containsKey(localization.id) &&
          !_rulesById.containsKey(localization.id)) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.localizedEntryWithoutBaseUnit',
            severity: PronunciationIssueSeverity.error,
            message: 'Unknown localized pronunciation id ${localization.id}',
          ),
        );
      }
    }

    return List.unmodifiable(issues);
  }

  PronunciationCoverageReport coverageReport({
    required int legacyPronunciationFieldsDiscovered,
    required int uniqueTargetForms,
  }) {
    final invalidUnits = validate()
        .where((issue) => issue.severity == PronunciationIssueSeverity.error)
        .length;

    return PronunciationCoverageReport(
      legacyPronunciationFieldsDiscovered: legacyPronunciationFieldsDiscovered,
      uniqueTargetForms: uniqueTargetForms,
      pronunciationUnits: _bundle.units.length,
      unitsWithDeclaredVariety: _bundle.units
          .where((unit) => unit.pronunciationVariety.id.isNotEmpty)
          .length,
      unitsWithIpa: _bundle.units.where((unit) => unit.ipa != null).length,
      unitsWithEnglishLearnerHint: _bundle.units
          .where((unit) => unit.localizedLearnerHints.containsKey('en'))
          .length,
      unitsWithRussianLearnerHint: _bundle.units
          .where((unit) => unit.localizedLearnerHints.containsKey('ru'))
          .length,
      unitsWithRussianExplanation: _bundle.localizations
          .where((entry) => entry.explanations.containsKey('ru'))
          .length,
      readingRules: _bundle.rules.length,
      unitsReferencingRules: _bundle.units
          .where((unit) => unit.readingRuleIds.isNotEmpty)
          .length,
      unmigratedLegacyEntries:
          legacyPronunciationFieldsDiscovered - _bundle.units.length,
      crossLocaleFallbackAttempts: _crossLocaleFallbackAttempts,
      invalidUnits: invalidUnits,
      unknownReferences: validate()
          .where((issue) => issue.code == 'pronunciation.unknownReference')
          .length,
    );
  }

  static Map<String, PronunciationUnit> _indexUnitsByRelatedContentId(
    Iterable<PronunciationUnit> units,
  ) {
    final index = <String, PronunciationUnit>{};
    for (final unit in units) {
      for (final id in unit.relatedContentIds) {
        index[id] = unit;
      }
      for (final id in unit.relatedVocabularyIds) {
        index[id] = unit;
      }
    }
    return Map.unmodifiable(index);
  }
}

String _normalizeSupportLocale(String supportLocaleCode) {
  final lower = supportLocaleCode.toLowerCase();
  if (lower.startsWith('en')) {
    return 'en';
  }
  if (lower.startsWith('ru')) {
    return 'ru';
  }
  if (lower.startsWith('uk')) {
    return 'uk';
  }
  if (lower.startsWith('pl')) {
    return 'pl';
  }
  if (lower.startsWith('de')) {
    return 'de';
  }
  return lower.split('-').first;
}
