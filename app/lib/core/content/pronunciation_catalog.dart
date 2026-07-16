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
       _vocabularyById = {
         for (final content in vocabularyContents)
           for (final item in content.entries) item.id: item,
       },
       _unitsByRelatedContentId = _indexUnitsByRelatedContentId(bundle.units);

  final PronunciationBundle _bundle;
  final Map<String, PronunciationUnit> _unitsById;
  final Map<String, PronunciationReadingRule> _rulesById;
  final Map<String, PronunciationLocalizationEntry> _localizationsById;
  final Map<String, VocabularyItem> _vocabularyById;
  final Map<String, PronunciationUnit> _unitsByRelatedContentId;
  int _crossLocaleFallbackAttempts = 0;
  int _crossLocaleReadingRuleFallbackAttempts = 0;

  Iterable<PronunciationUnit> get units => _bundle.units;
  Iterable<PronunciationReadingRule> get rules => _bundle.rules;
  int get crossLocaleFallbackAttempts => _crossLocaleFallbackAttempts;
  int get crossLocaleReadingRuleFallbackAttempts =>
      _crossLocaleReadingRuleFallbackAttempts;

  PronunciationUnit? unitById(String id) => _unitsById[id];
  PronunciationReadingRule? readingRuleById(String id) => _rulesById[id];

  PronunciationUnit? unitForContentId(String contentId) {
    return _unitsByRelatedContentId[contentId];
  }

  List<PronunciationReadingRule> rulesForPronunciationUnit(String unitId) {
    final unit = _unitsById[unitId];
    if (unit == null) {
      return const [];
    }
    return List.unmodifiable([
      for (final ruleId in unit.readingRuleIds)
        if (_rulesById[ruleId] != null) _rulesById[ruleId]!,
    ]);
  }

  List<PronunciationReadingRule> applicableRulesForPronunciationUnit(
    String unitId,
  ) {
    final unit = _unitsById[unitId];
    if (unit == null) {
      return const [];
    }
    return List.unmodifiable([
      for (final ruleId in unit.readingRuleIds)
        if (_rulesById[ruleId] != null &&
            isReadingRuleApplicableToTarget(
              rule: _rulesById[ruleId]!,
              targetOrthography: unit.targetOrthography,
            ))
          _rulesById[ruleId]!,
    ]);
  }

  List<PronunciationUnit> exampleUnitsForReadingRule(String ruleId) {
    final rule = _rulesById[ruleId];
    if (rule == null) {
      return const [];
    }
    return List.unmodifiable([
      for (final unitId in rule.examplePronunciationUnitIds)
        if (_unitsById[unitId] != null) _unitsById[unitId]!,
    ]);
  }

  ResolvedPronunciationPresentation? resolveForVocabularyItem({
    required VocabularyItem item,
    required String supportLocaleCode,
  }) {
    final directUnitId = item.pronunciationUnitId;
    if (directUnitId != null && directUnitId.trim().isNotEmpty) {
      final resolved = resolveUnit(
        directUnitId,
        supportLocaleCode: supportLocaleCode,
      );
      if (resolved != null) {
        return resolved;
      }
      return ResolvedPronunciationPresentation(
        targetOrthography: item.spanish,
        pronunciationVariety: 'unknown',
        diagnosticCode: 'pronunciation.unknownUnitReference',
      );
    }

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

  ResolvedReadingRulePresentation? resolveReadingRule(
    String ruleId, {
    required String supportLocaleCode,
  }) {
    final rule = _rulesById[ruleId];
    if (rule == null) {
      return null;
    }

    final localization = _localizationsById[rule.id];
    final locale = _normalizeSupportLocale(supportLocaleCode);
    final title = localization?.titles[locale];
    final shortExplanation =
        localization?.shortExplanations[locale] ??
        localization?.explanations[locale];
    final detailedExplanation = localization?.detailedExplanations[locale];
    final articulationHint = localization?.articulationHints[locale];
    final commonMistakes = localization?.commonMistakes[locale];
    final contrastNote = localization?.contrastNotes[locale];
    final graphemePresentation = localization?.graphemePresentations[locale];

    if ((title == null || shortExplanation == null) &&
        locale != 'en' &&
        ((localization?.titles.containsKey('en') ?? false) ||
            (localization?.shortExplanations.containsKey('en') ?? false) ||
            (localization?.explanations.containsKey('en') ?? false))) {
      _crossLocaleReadingRuleFallbackAttempts += 1;
    }

    return ResolvedReadingRulePresentation(
      id: rule.id,
      targetLanguage: rule.targetLanguage,
      pronunciationVariety: rule.pronunciationVariety.id,
      orthographicPattern: rule.orthographicPattern,
      examplePronunciationUnitIds: rule.examplePronunciationUnitIds,
      title: title,
      shortExplanation: shortExplanation,
      detailedExplanation: detailedExplanation,
      articulationHint: articulationHint,
      commonMistakes: commonMistakes,
      contrastNote: contrastNote,
      phoneticOutcome: rule.phoneticOutcome,
      ipa: rule.ipa?.value,
      graphemePresentation: graphemePresentation,
      diagnosticCode: title == null || shortExplanation == null
          ? 'readingRule.missingLocalizedExplanation'
          : null,
    );
  }

  List<PronunciationValidationIssue> validate() {
    final issues = <PronunciationValidationIssue>[];
    final unitIds = <String>{};
    final ruleIds = <String>{};
    final rulesReferencedByUnits = <String>{
      for (final unit in _bundle.units) ...unit.readingRuleIds,
    };

    for (final rule in _bundle.rules) {
      if (!ruleIds.add(rule.id)) {
        issues.add(
          const PronunciationValidationIssue(
            code: 'readingRule.duplicateId',
            severity: PronunciationIssueSeverity.error,
            message: 'Duplicate reading rule id',
          ),
        );
      }
      if (rule.targetLanguage != _bundle.targetLanguage) {
        issues.add(
          PronunciationValidationIssue(
            code: 'readingRule.targetLanguageMismatch',
            severity: PronunciationIssueSeverity.error,
            message: 'Rule ${rule.id} uses ${rule.targetLanguage}',
          ),
        );
      }
      if (rule.knowledgeDomain != 'language') {
        issues.add(
          PronunciationValidationIssue(
            code: 'readingRule.missingTargetLanguage',
            severity: PronunciationIssueSeverity.error,
            message: 'Rule ${rule.id} must use language knowledge domain',
          ),
        );
      }
      if (rule.ruleKind != 'reading') {
        issues.add(
          PronunciationValidationIssue(
            code: 'readingRule.missingOrthographicPattern',
            severity: PronunciationIssueSeverity.error,
            message: 'Rule ${rule.id} must use reading rule kind',
          ),
        );
      }
      if (rule.targetLanguage.trim().isEmpty) {
        issues.add(
          PronunciationValidationIssue(
            code: 'readingRule.missingTargetLanguage',
            severity: PronunciationIssueSeverity.error,
            message: 'Missing target language for ${rule.id}',
          ),
        );
      }
      if (rule.pronunciationVariety.id.trim().isEmpty) {
        issues.add(
          PronunciationValidationIssue(
            code: 'readingRule.missingVariety',
            severity: PronunciationIssueSeverity.error,
            message: 'Missing variety for ${rule.id}',
          ),
        );
      }
      if (rule.orthographicPattern.trim().isEmpty) {
        issues.add(
          PronunciationValidationIssue(
            code: 'readingRule.missingOrthographicPattern',
            severity: PronunciationIssueSeverity.error,
            message: 'Missing orthographic pattern for ${rule.id}',
          ),
        );
      }
      if (_requiresRulePhoneticDefinition(rule) &&
          rule.phoneticOutcome == null &&
          rule.ipa == null) {
        issues.add(
          PronunciationValidationIssue(
            code: 'readingRule.missingPhoneticDefinition',
            severity: PronunciationIssueSeverity.error,
            message: 'Missing phonetic definition for ${rule.id}',
          ),
        );
      }
      if (rule.examplePronunciationUnitIds.isEmpty) {
        issues.add(
          PronunciationValidationIssue(
            code: 'readingRule.noExamples',
            severity: PronunciationIssueSeverity.error,
            message: 'Rule ${rule.id} has no example units',
          ),
        );
      }
      if (!rulesReferencedByUnits.contains(rule.id)) {
        issues.add(
          PronunciationValidationIssue(
            code: 'readingRule.unusedRule',
            severity: PronunciationIssueSeverity.warning,
            message: 'Rule ${rule.id} is not referenced by pronunciation units',
          ),
        );
      }
      final examples = <String>{};
      for (final unitId in rule.examplePronunciationUnitIds) {
        if (!examples.add(unitId)) {
          issues.add(
            PronunciationValidationIssue(
              code: 'readingRule.duplicateExampleReference',
              severity: PronunciationIssueSeverity.error,
              message: 'Duplicate example $unitId in ${rule.id}',
            ),
          );
        }
        final unit = _unitsById[unitId];
        if (unit == null) {
          issues.add(
            PronunciationValidationIssue(
              code: 'readingRule.unknownPronunciationUnitReference',
              severity: PronunciationIssueSeverity.error,
              message: 'Unknown example $unitId in ${rule.id}',
            ),
          );
          continue;
        }
        if (unit.targetLanguage != rule.targetLanguage) {
          issues.add(
            PronunciationValidationIssue(
              code: 'readingRule.targetLanguageMismatch',
              severity: PronunciationIssueSeverity.error,
              message: 'Example $unitId language mismatch in ${rule.id}',
            ),
          );
        }
        if (unit.pronunciationVariety.id != rule.pronunciationVariety.id) {
          issues.add(
            PronunciationValidationIssue(
              code: 'readingRule.varietyMismatch',
              severity: PronunciationIssueSeverity.error,
              message: 'Example $unitId variety mismatch in ${rule.id}',
            ),
          );
        }
      }
      final localization = _localizationsById[rule.id];
      if (localization == null) {
        issues.add(
          PronunciationValidationIssue(
            code: 'readingRule.missingLocalizedTitle',
            severity: PronunciationIssueSeverity.error,
            message: 'Missing localization for ${rule.id}',
          ),
        );
      } else {
        for (final locale in const ['en', 'ru']) {
          if ((localization.titles[locale]?.trim().isEmpty ?? true)) {
            issues.add(
              PronunciationValidationIssue(
                code: 'readingRule.missingLocalizedTitle',
                severity: locale == 'en'
                    ? PronunciationIssueSeverity.error
                    : PronunciationIssueSeverity.deferred,
                message: 'Missing $locale title for ${rule.id}',
              ),
            );
          }
          final explanation =
              localization.shortExplanations[locale] ??
              localization.explanations[locale];
          if (explanation == null || explanation.trim().isEmpty) {
            issues.add(
              PronunciationValidationIssue(
                code: 'readingRule.missingLocalizedExplanation',
                severity: locale == 'en'
                    ? PronunciationIssueSeverity.error
                    : PronunciationIssueSeverity.deferred,
                message: 'Missing $locale explanation for ${rule.id}',
              ),
            );
          }
        }
      }
      if (_isLlYRule(rule)) {
        if (rule.metadata['llYPolicy'] != 'yeismo' ||
            rule.ipa?.value != '/ʝ/' ||
            !(rule.phoneticOutcome?.contains('/ʝ/') ?? false)) {
          issues.add(
            PronunciationValidationIssue(
              code: 'readingRule.varietyOutcomeMismatch',
              severity: PronunciationIssueSeverity.error,
              message: 'Rule ${rule.id} must declare yeismo with /ʝ/',
            ),
          );
        }
        if (!_hasLlYGraphemeExplanation(localization)) {
          issues.add(
            PronunciationValidationIssue(
              code: 'pronunciation.ambiguousGraphemeExplanation',
              severity: PronunciationIssueSeverity.deferred,
              message:
                  'Rule ${rule.id} must distinguish lowercase ll from uppercase II',
            ),
          );
        }
        if (rule.graphemeComponents.join() != 'll' ||
            !rule.confusableGraphemes.contains('II') ||
            rule.caseSensitive != true) {
          issues.add(
            PronunciationValidationIssue(
              code: 'readingRule.missingGraphemePresentation',
              severity: PronunciationIssueSeverity.error,
              message:
                  'Rule ${rule.id} must model lowercase ll and confusable II',
            ),
          );
        }
        final ruGrapheme = localization?.graphemePresentations['ru'];
        if (ruGrapheme == null ||
            !ruGrapheme.componentLetterNames.contains('эль') ||
            !ruGrapheme.confusableComponentLetterNames.contains('и') ||
            !_containsAll(ruGrapheme.accessibilityDescription, const [
              'строчн',
              'латинск',
              'букв',
              'эль',
            ]) ||
            !_containsAll(ruGrapheme.accessibilityDescription, const [
              'заглавн',
              'латинск',
              'букв',
              'и',
            ])) {
          issues.add(
            PronunciationValidationIssue(
              code: 'readingRule.missingAccessibleGraphemePresentation',
              severity: PronunciationIssueSeverity.deferred,
              message:
                  'Rule ${rule.id} must provide accessible Russian ll/II presentation',
            ),
          );
        }
        if (_localizedRuleContradictsYeismo(localization)) {
          issues.add(
            PronunciationValidationIssue(
              code: 'readingRule.localizedExplanationContradictsBaseRule',
              severity: PronunciationIssueSeverity.error,
              message: 'Rule ${rule.id} localization contradicts yeismo',
            ),
          );
        }
      }
    }

    for (final unit in _bundle.units) {
      if (!unitIds.add(unit.id.value)) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.duplicateUnitId',
            severity: PronunciationIssueSeverity.error,
            message: 'Duplicate unit id ${unit.id.value}',
          ),
        );
      }
      if (unit.targetLanguage != _bundle.targetLanguage) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.targetLanguageMismatch',
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
              code: 'pronunciation.unknownRuleReference',
              severity: PronunciationIssueSeverity.error,
              message: 'Unknown rule $ruleId in ${unit.id.value}',
            ),
          );
        }
      }

      final releaseReference = _isReleaseReferenceUnit(unit);
      final localization = _localizationsById[unit.id.value];
      final ruHint =
          localization?.learnerHints['ru'] ?? unit.localizedLearnerHints['ru'];
      final enHint =
          localization?.learnerHints['en'] ?? unit.localizedLearnerHints['en'];

      if (releaseReference && unit.ipa == null) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.missingIpa',
            severity: PronunciationIssueSeverity.error,
            message: 'Missing IPA for ${unit.id.value}',
          ),
        );
      }
      if (releaseReference && ruHint == null) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.missingLocalizedHint',
            severity: PronunciationIssueSeverity.deferred,
            message: 'Missing ru hint for ${unit.id.value}',
          ),
        );
      }
      if (releaseReference &&
          ruHint != null &&
          _requiresStress(unit.targetOrthography) &&
          !_hasStressMark(ruHint)) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.missingStressMark',
            severity: PronunciationIssueSeverity.error,
            message: 'Missing stress mark in ru hint for ${unit.id.value}',
          ),
        );
      }
      if (releaseReference &&
          ruHint != null &&
          enHint != null &&
          ruHint.trim().toLowerCase() == enHint.trim().toLowerCase()) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.crossLocaleHintReuse',
            severity: PronunciationIssueSeverity.error,
            message: 'ru hint reuses en hint for ${unit.id.value}',
          ),
        );
      }
      if (releaseReference &&
          ruHint != null &&
          RegExp(r'[A-Za-z]').hasMatch(ruHint)) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.legacyHintInNonEnglishLocale',
            severity: PronunciationIssueSeverity.error,
            message: 'ru hint contains Latin letters in ${unit.id.value}',
          ),
        );
      }
      if (_isLlYUnit(unit)) {
        final unitRule = _rulesById['pronunciation.es.rule.ll_y.v1'];
        if (unitRule?.metadata['llYPolicy'] != 'yeismo') {
          issues.add(
            PronunciationValidationIssue(
              code: 'pronunciation.llYPolicyMismatch',
              severity: PronunciationIssueSeverity.error,
              message:
                  'Unit ${unit.id.value} has no matching yeismo rule policy',
            ),
          );
        }
        if (unit.ipa?.value.contains('ʎ') ?? false) {
          issues.add(
            PronunciationValidationIssue(
              code: 'pronunciation.varietyIpaMismatch',
              severity: PronunciationIssueSeverity.error,
              message: 'Unit ${unit.id.value} uses non-yeista IPA',
            ),
          );
        }
        if (unit.ipa != null && !unit.ipa!.value.contains('ʝ')) {
          issues.add(
            PronunciationValidationIssue(
              code: 'pronunciation.llYPolicyMismatch',
              severity: PronunciationIssueSeverity.error,
              message: 'Unit ${unit.id.value} must use /ʝ/ for yeismo ll/y',
            ),
          );
        }
        if (ruHint != null && _containsNonYeistaRussianHint(ruHint)) {
          issues.add(
            PronunciationValidationIssue(
              code: 'pronunciation.nonYeistaHintInYeistaProfile',
              severity: PronunciationIssueSeverity.error,
              message: 'Unit ${unit.id.value} has non-yeista Russian hint',
            ),
          );
          issues.add(
            PronunciationValidationIssue(
              code: 'pronunciation.varietyLearnerHintMismatch',
              severity: PronunciationIssueSeverity.error,
              message:
                  'Unit ${unit.id.value} Russian hint conflicts with yeismo',
            ),
          );
        }
      }

      for (final id in unit.relatedVocabularyIds) {
        final item = _vocabularyById[id];
        if (item == null) {
          issues.add(
            PronunciationValidationIssue(
              code: 'pronunciation.unknownUnitReference',
              severity: PronunciationIssueSeverity.error,
              message: 'Unknown vocabulary reference $id in ${unit.id.value}',
            ),
          );
          continue;
        }
        if (_pronunciationComparable(item.spanish) !=
            _pronunciationComparable(unit.targetOrthography)) {
          issues.add(
            PronunciationValidationIssue(
              code: 'pronunciation.targetOrthographyMismatch',
              severity: PronunciationIssueSeverity.error,
              message:
                  'Vocabulary $id has ${item.spanish}; ${unit.id.value} has ${unit.targetOrthography}',
            ),
          );
        }
        if (releaseReference && item.example.trim().isEmpty) {
          issues.add(
            PronunciationValidationIssue(
              code: 'pronunciation.missingExample',
              severity: PronunciationIssueSeverity.error,
              message: 'Missing example for $id',
            ),
          );
        }
      }

      if (_requiresExplanation(unit)) {
        final hasRequiredExplanation =
            localization?.explanations['en']?.trim().isNotEmpty ?? false;
        if (!hasRequiredExplanation) {
          issues.add(
            PronunciationValidationIssue(
              code: 'pronunciation.explanationRequired',
              severity: PronunciationIssueSeverity.error,
              message: 'Missing required explanation for ${unit.id.value}',
            ),
          );
        }
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
      if (!_unitsById.containsKey(localization.id) &&
          !_rulesById.containsKey(localization.id) &&
          localization.titles.isNotEmpty) {
        issues.add(
          PronunciationValidationIssue(
            code: 'readingRule.localizedEntryWithoutBaseRule',
            severity: PronunciationIssueSeverity.error,
            message: 'Unknown localized reading rule id ${localization.id}',
          ),
        );
      }
    }

    for (final item in _vocabularyById.values) {
      final directUnitId = item.pronunciationUnitId;
      if (directUnitId != null &&
          directUnitId.trim().isNotEmpty &&
          !_unitsById.containsKey(directUnitId)) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.unknownUnitReference',
            severity: PronunciationIssueSeverity.error,
            message: 'Vocabulary ${item.id} references $directUnitId',
          ),
        );
      }
      if (directUnitId != null &&
          _unitsById[directUnitId]?.targetLanguage != null &&
          _unitsById[directUnitId]!.targetLanguage != _bundle.targetLanguage) {
        issues.add(
          PronunciationValidationIssue(
            code: 'pronunciation.targetLanguageMismatch',
            severity: PronunciationIssueSeverity.error,
            message: 'Vocabulary ${item.id} references wrong target language',
          ),
        );
      }
    }

    return List.unmodifiable(issues);
  }

  PronunciationValidationResult validationResult() {
    return PronunciationValidationResult(issues: validate());
  }

  PronunciationCoverageReport coverageReport({
    required int legacyPronunciationFieldsDiscovered,
    required int uniqueTargetForms,
    int? pronunciationCapableVocabularyEntries,
    int readingRulesReferencedByLessons = 0,
    int readingRulesReferencedByExercises = 0,
  }) {
    final issues = validate();
    final invalidUnits = issues
        .where((issue) => issue.severity == PronunciationIssueSeverity.error)
        .length;
    final releaseReferenceUnits = _bundle.units.where(_isReleaseReferenceUnit);
    final rulesReferencedByUnits = <String>{
      for (final unit in _bundle.units) ...unit.readingRuleIds,
    };
    final llYUnits = _bundle.units.where(_isLlYUnit).toList();
    final llYMismatches = issues.where((issue) {
      return issue.code == 'pronunciation.varietyIpaMismatch' ||
          issue.code == 'pronunciation.varietyLearnerHintMismatch' ||
          issue.code == 'pronunciation.llYPolicyMismatch' ||
          issue.code == 'readingRule.varietyOutcomeMismatch';
    }).length;
    final nonYeistaHints = issues
        .where(
          (issue) => issue.code == 'pronunciation.nonYeistaHintInYeistaProfile',
        )
        .length;

    return PronunciationCoverageReport(
      legacyPronunciationFieldsDiscovered: legacyPronunciationFieldsDiscovered,
      uniqueTargetForms: uniqueTargetForms,
      pronunciationCapableVocabularyEntries:
          pronunciationCapableVocabularyEntries ??
          legacyPronunciationFieldsDiscovered,
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
      multisyllabicRussianHintsWithStress: _bundle.units.where((unit) {
        final hint =
            _localizationsById[unit.id.value]?.learnerHints['ru'] ??
            unit.localizedLearnerHints['ru'];
        return hint != null &&
            _requiresStress(unit.targetOrthography) &&
            _hasStressMark(hint);
      }).length,
      unitsWithRussianExplanation: _bundle.localizations
          .where((entry) => entry.explanations.containsKey('ru'))
          .length,
      unitsWithExample: releaseReferenceUnits.where((unit) {
        return unit.relatedVocabularyIds.any((id) {
          final item = _vocabularyById[id];
          return item != null && item.example.trim().isNotEmpty;
        });
      }).length,
      unitsRequiringExplanation: _bundle.units
          .where(_requiresExplanation)
          .length,
      unitsWithRequiredExplanation: _bundle.units.where((unit) {
        if (!_requiresExplanation(unit)) {
          return false;
        }
        final localization = _localizationsById[unit.id.value];
        return (localization?.explanations['en']?.trim().isNotEmpty ?? false) &&
            (localization?.explanations['ru']?.trim().isNotEmpty ?? false);
      }).length,
      readingRules: _bundle.rules.length,
      unitsReferencingRules: _bundle.units
          .where((unit) => unit.readingRuleIds.isNotEmpty)
          .length,
      unmigratedLegacyEntries:
          legacyPronunciationFieldsDiscovered > _bundle.units.length
          ? legacyPronunciationFieldsDiscovered - _bundle.units.length
          : 0,
      crossLocaleFallbackAttempts: _crossLocaleFallbackAttempts,
      invalidUnits: invalidUnits,
      unknownReferences: issues
          .where(
            (issue) =>
                issue.code == 'pronunciation.unknownRuleReference' ||
                issue.code == 'pronunciation.unknownUnitReference',
          )
          .length,
      readingRulesDiscovered: _bundle.rules.length,
      readingRulesMigrated: _bundle.rules.length,
      readingRulesWithVariety: _bundle.rules
          .where((rule) => rule.pronunciationVariety.id.isNotEmpty)
          .length,
      readingRulesWithPhoneticDefinition: _bundle.rules
          .where((rule) => rule.phoneticOutcome != null || rule.ipa != null)
          .length,
      readingRulesWithEnglishLocalization: _bundle.rules.where((rule) {
        final localization = _localizationsById[rule.id];
        return localization != null &&
            localization.titles.containsKey('en') &&
            (localization.shortExplanations.containsKey('en') ||
                localization.explanations.containsKey('en'));
      }).length,
      readingRulesWithRussianLocalization: _bundle.rules.where((rule) {
        final localization = _localizationsById[rule.id];
        return localization != null &&
            localization.titles.containsKey('ru') &&
            (localization.shortExplanations.containsKey('ru') ||
                localization.explanations.containsKey('ru'));
      }).length,
      readingRulesWithExamples: _bundle.rules
          .where((rule) => rule.examplePronunciationUnitIds.isNotEmpty)
          .length,
      readingRulesReferencedByPronunciationUnits: rulesReferencedByUnits.length,
      readingRulesReferencedByLessons: readingRulesReferencedByLessons,
      readingRulesReferencedByExercises: readingRulesReferencedByExercises,
      unusedReadingRules: _bundle.rules
          .where((rule) => !rulesReferencedByUnits.contains(rule.id))
          .length,
      invalidReadingRuleReferences: issues.where((issue) {
        return issue.code.startsWith('readingRule.') &&
            issue.severity == PronunciationIssueSeverity.error;
      }).length,
      crossLocaleReadingRuleFallbackAttempts:
          _crossLocaleReadingRuleFallbackAttempts,
      llYPronunciationUnits: llYUnits.length,
      llYUnitsConsistentWithSelectedVariety: llYUnits.length - llYMismatches,
      llYUnitsWithMatchingIpa: llYUnits.where((unit) {
        return unit.ipa != null &&
            unit.ipa!.value.contains('ʝ') &&
            !unit.ipa!.value.contains('ʎ');
      }).length,
      llYUnitsWithRussianHint: llYUnits.where((unit) {
        final hint =
            _localizationsById[unit.id.value]?.learnerHints['ru'] ??
            unit.localizedLearnerHints['ru'];
        return hint != null && !_containsNonYeistaRussianHint(hint);
      }).length,
      llYUnitsWithEnglishHint: llYUnits.where((unit) {
        final hint =
            _localizationsById[unit.id.value]?.learnerHints['en'] ??
            unit.localizedLearnerHints['en'];
        return hint != null && !hint.toLowerCase().contains('ly');
      }).length,
      llYUnitsWithGraphemeExplanation: llYUnits.where((unit) {
        final explanation =
            _localizationsById[unit.id.value]?.explanations['ru'];
        return explanation != null &&
            (explanation.contains('ll') ||
                unit.targetOrthography.toLowerCase().startsWith('y')) &&
            !_containsNonYeistaRussianHint(explanation);
      }).length,
      llYVarietyMismatches: llYMismatches,
      nonYeistaHintsInYeistaProfile: nonYeistaHints,
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

bool isReadingRuleApplicableToTarget({
  required PronunciationReadingRule rule,
  required String targetOrthography,
}) {
  final pattern = rule.orthographicPattern.trim().toLowerCase();
  if (pattern.isEmpty) {
    return false;
  }
  if (pattern.contains('/') ||
      pattern.contains(' ') ||
      pattern.contains('+') ||
      pattern.contains(' and ')) {
    return true;
  }
  final graphemes = segmentSpanishGraphemes(targetOrthography);
  if (pattern.length == 1) {
    return graphemes.contains(pattern);
  }
  return graphemes.contains(pattern) ||
      targetOrthography.toLowerCase().contains(pattern);
}

List<String> segmentSpanishGraphemes(String value) {
  const multiGraphemes = ['ch', 'll', 'rr', 'qu', 'gu'];
  final lower = value.toLowerCase();
  final graphemes = <String>[];
  var index = 0;
  while (index < lower.length) {
    final char = lower[index];
    if (!RegExp(r'[a-záéíóúüñ]').hasMatch(char)) {
      index += 1;
      continue;
    }
    String? match;
    for (final candidate in multiGraphemes) {
      if (lower.startsWith(candidate, index)) {
        match = candidate;
        break;
      }
    }
    if (match != null) {
      graphemes.add(match);
      index += match.length;
    } else {
      graphemes.add(char);
      index += 1;
    }
  }
  return List.unmodifiable(graphemes);
}

bool _isReleaseReferenceUnit(PronunciationUnit unit) {
  return unit.relatedVocabularyIds.isNotEmpty ||
      unit.metadata['releaseReference'] == 'true';
}

bool _requiresExplanation(PronunciationUnit unit) {
  return unit.metadata['explanationRequired'] == 'true';
}

bool _requiresRulePhoneticDefinition(PronunciationReadingRule rule) {
  return rule.metadata['releaseReference'] == 'true' ||
      rule.orthographicPattern.length <= 4 ||
      rule.ipa != null;
}

bool _isLlYRule(PronunciationReadingRule rule) {
  return rule.id == 'pronunciation.es.rule.ll_y.v1';
}

bool _isLlYUnit(PronunciationUnit unit) {
  return unit.readingRuleIds.contains('pronunciation.es.rule.ll_y.v1');
}

bool _hasLlYGraphemeExplanation(PronunciationLocalizationEntry? localization) {
  final english = localization?.detailedExplanations['en'] ?? '';
  return english.contains('two lowercase l') && english.contains('uppercase I');
}

bool _localizedRuleContradictsYeismo(
  PronunciationLocalizationEntry? localization,
) {
  if (localization == null) {
    return false;
  }
  final values = [
    ...localization.learnerHints.values,
    ...localization.explanations.values,
    ...localization.titles.values,
    ...localization.shortExplanations.values,
    ...localization.detailedExplanations.values,
    ...localization.articulationHints.values,
    ...localization.commonMistakes.values,
    ...localization.contrastNotes.values,
  ];
  return values.any(_containsNonYeistaRussianHint);
}

bool _containsNonYeistaRussianHint(String value) {
  final lower = value.toLowerCase();
  return lower.contains('лья') ||
      lower.contains('лье') ||
      lower.contains('льё') ||
      lower.contains('лью') ||
      lower.contains('э́лья') ||
      lower.contains('как ль') ||
      lower.contains('читается как ль');
}

bool _containsAll(String value, Iterable<String> fragments) {
  final lower = value.toLowerCase();
  return fragments.every(lower.contains);
}

bool _requiresStress(String targetOrthography) {
  final lower = targetOrthography.toLowerCase();
  final vowelGroups = RegExp(r'[aeiouáéíóúü]+').allMatches(lower).length;
  return vowelGroups > 1 || lower.contains(' ');
}

String _pronunciationComparable(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[¡!¿?.,;:"“”«»]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

bool _hasStressMark(String hint) {
  return hint.contains('\u0301') ||
      RegExp('[áéíóúÁÉÍÓÚа́е́ё́и́о́у́ы́э́ю́я́]').hasMatch(hint);
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
