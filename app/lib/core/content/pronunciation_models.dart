import 'json_parsing.dart';

class PronunciationUnitId {
  PronunciationUnitId(this.value) {
    if (value.trim().isEmpty) {
      throw FormatException('PronunciationUnitId must not be empty');
    }
  }

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PronunciationUnitId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

class PronunciationVariety {
  PronunciationVariety(this.id) {
    if (id.trim().isEmpty) {
      throw FormatException('PronunciationVariety must not be empty');
    }
  }

  final String id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PronunciationVariety && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class IpaTranscription {
  IpaTranscription(this.value) {
    if (value.trim().isEmpty) {
      throw FormatException('IpaTranscription must not be empty');
    }
    if (value.contains(RegExp(r'[A-Z]'))) {
      throw FormatException('IPA must not look like English respelling');
    }
  }

  final String value;
}

class LocalizedPronunciationHint {
  LocalizedPronunciationHint({required this.locale, required this.value}) {
    if (locale.trim().isEmpty || value.trim().isEmpty) {
      throw FormatException('LocalizedPronunciationHint must not be empty');
    }
  }

  final String locale;
  final String value;
}

class LocalizedPronunciationExplanation {
  LocalizedPronunciationExplanation({
    required this.locale,
    required this.value,
  }) {
    if (locale.trim().isEmpty || value.trim().isEmpty) {
      throw FormatException(
        'LocalizedPronunciationExplanation must not be empty',
      );
    }
  }

  final String locale;
  final String value;
}

class ReadingRule {
  const ReadingRule({
    required this.id,
    required this.schemaVersion,
    required this.knowledgeDomain,
    required this.ruleKind,
    required this.targetLanguage,
    required this.orthographicPattern,
    required this.pronunciationVariety,
    required this.examplePronunciationUnitIds,
    this.phoneticOutcome,
    this.ipa,
    this.applicability,
    this.graphemeComponents = const [],
    this.confusableGraphemes = const [],
    this.caseSensitive = false,
    this.exceptions = const [],
    this.relatedContentIds = const [],
    this.difficulty,
    this.relatedGrammarIds = const [],
    this.metadata = const {},
  });

  factory ReadingRule.fromJson(Map<String, Object?> json) {
    return ReadingRule(
      id: requiredString(json, 'id'),
      schemaVersion: _optionalInt(json, 'schemaVersion') ?? 1,
      knowledgeDomain: optionalString(json, 'knowledgeDomain') ?? 'language',
      ruleKind: optionalString(json, 'ruleKind') ?? 'reading',
      targetLanguage: requiredString(json, 'targetLanguage'),
      orthographicPattern:
          optionalString(json, 'orthographicPattern') ??
          requiredString(json, 'symbol'),
      pronunciationVariety: PronunciationVariety(
        optionalString(json, 'pronunciationVarietyId') ??
            requiredString(json, 'pronunciationVariety'),
      ),
      phoneticOutcome: optionalString(json, 'phoneticOutcome'),
      ipa: optionalString(json, 'ipa') == null
          ? null
          : IpaTranscription(optionalString(json, 'ipa')!),
      applicability: optionalString(json, 'applicability'),
      graphemeComponents: optionalStringList(json, 'graphemeComponents'),
      confusableGraphemes: optionalStringList(json, 'confusableGraphemes'),
      caseSensitive: _optionalBool(json, 'caseSensitive') ?? false,
      exceptions: optionalStringList(json, 'exceptions'),
      examplePronunciationUnitIds: optionalStringList(
        json,
        'examplePronunciationUnitIds',
      ),
      relatedContentIds: optionalStringList(json, 'relatedContentIds'),
      difficulty: optionalString(json, 'difficulty'),
      relatedGrammarIds: optionalStringList(json, 'relatedGrammarIds'),
      metadata: _stringMap(json, 'metadata'),
    );
  }

  final String id;
  final int schemaVersion;
  final String knowledgeDomain;
  final String ruleKind;
  final String targetLanguage;
  final String orthographicPattern;
  final PronunciationVariety pronunciationVariety;
  final String? phoneticOutcome;
  final IpaTranscription? ipa;
  final String? applicability;
  final List<String> graphemeComponents;
  final List<String> confusableGraphemes;
  final bool caseSensitive;
  final List<String> exceptions;
  final List<String> examplePronunciationUnitIds;
  final List<String> relatedContentIds;
  final String? difficulty;
  final List<String> relatedGrammarIds;
  final Map<String, String> metadata;
}

typedef PronunciationReadingRule = ReadingRule;

class PronunciationUnit {
  const PronunciationUnit({
    required this.id,
    required this.schemaVersion,
    required this.targetLanguage,
    required this.targetOrthography,
    required this.pronunciationVariety,
    required this.localizedLearnerHints,
    required this.relatedContentIds,
    this.ipa,
    this.readingRuleIds = const [],
    this.articulationHints = const [],
    this.audioReferenceId,
    this.difficulty,
    this.commonMistakes = const [],
    this.relatedVocabularyIds = const [],
    this.relatedGrammarIds = const [],
    this.metadata = const {},
  });

  factory PronunciationUnit.fromJson(Map<String, Object?> json) {
    return PronunciationUnit(
      id: PronunciationUnitId(requiredString(json, 'id')),
      schemaVersion: _optionalInt(json, 'schemaVersion') ?? 1,
      targetLanguage: requiredString(json, 'targetLanguage'),
      targetOrthography: requiredString(json, 'targetOrthography'),
      pronunciationVariety: PronunciationVariety(
        requiredString(json, 'pronunciationVariety'),
      ),
      ipa: optionalString(json, 'ipa') == null
          ? null
          : IpaTranscription(optionalString(json, 'ipa')!),
      readingRuleIds: optionalStringList(json, 'readingRuleIds'),
      articulationHints: optionalStringList(json, 'articulationHints'),
      localizedLearnerHints: _localizedStringMap(json, 'localizedLearnerHints'),
      audioReferenceId: optionalString(json, 'audioReferenceId'),
      difficulty: optionalString(json, 'difficulty'),
      commonMistakes: optionalStringList(json, 'commonMistakes'),
      relatedContentIds: requiredStringList(json, 'relatedContentIds'),
      relatedVocabularyIds: optionalStringList(json, 'relatedVocabularyIds'),
      relatedGrammarIds: optionalStringList(json, 'relatedGrammarIds'),
      metadata: _stringMap(json, 'metadata'),
    );
  }

  final PronunciationUnitId id;
  final int schemaVersion;
  final String targetLanguage;
  final String targetOrthography;
  final PronunciationVariety pronunciationVariety;
  final IpaTranscription? ipa;
  final List<String> readingRuleIds;
  final List<String> articulationHints;
  final Map<String, String> localizedLearnerHints;
  final String? audioReferenceId;
  final String? difficulty;
  final List<String> commonMistakes;
  final List<String> relatedContentIds;
  final List<String> relatedVocabularyIds;
  final List<String> relatedGrammarIds;
  final Map<String, String> metadata;
}

class PronunciationLocalizationEntry {
  const PronunciationLocalizationEntry({
    required this.id,
    required this.learnerHints,
    required this.explanations,
    this.titles = const {},
    this.shortExplanations = const {},
    this.detailedExplanations = const {},
    this.articulationHints = const {},
    this.commonMistakes = const {},
    this.contrastNotes = const {},
    this.graphemePresentations = const {},
    this.metadata = const {},
  });

  factory PronunciationLocalizationEntry.fromJson(Map<String, Object?> json) {
    return PronunciationLocalizationEntry(
      id: requiredString(json, 'id'),
      learnerHints: _localizedStringMap(json, 'learnerHints'),
      explanations: _localizedStringMap(json, 'explanations'),
      titles: _localizedStringMap(json, 'titles'),
      shortExplanations: _localizedStringMap(json, 'shortExplanations'),
      detailedExplanations: _localizedStringMap(json, 'detailedExplanations'),
      articulationHints: _localizedStringMap(json, 'articulationHints'),
      commonMistakes: _localizedStringMap(json, 'commonMistakes'),
      contrastNotes: _localizedStringMap(json, 'contrastNotes'),
      graphemePresentations: _localizedGraphemePresentationMap(
        json,
        'graphemePresentations',
      ),
      metadata: _stringMap(json, 'metadata'),
    );
  }

  final String id;
  final Map<String, String> learnerHints;
  final Map<String, String> explanations;
  final Map<String, String> titles;
  final Map<String, String> shortExplanations;
  final Map<String, String> detailedExplanations;
  final Map<String, String> articulationHints;
  final Map<String, String> commonMistakes;
  final Map<String, String> contrastNotes;
  final Map<String, LocalizedGraphemePresentation> graphemePresentations;
  final Map<String, String> metadata;
}

class LocalizedGraphemePresentation {
  const LocalizedGraphemePresentation({
    required this.canonicalDescription,
    required this.componentLetterNames,
    required this.confusableDescription,
    required this.confusableComponentLetterNames,
    required this.accessibilityDescription,
  });

  factory LocalizedGraphemePresentation.fromJson(Map<String, Object?> json) {
    return LocalizedGraphemePresentation(
      canonicalDescription: requiredString(json, 'canonicalDescription'),
      componentLetterNames: requiredStringList(json, 'componentLetterNames'),
      confusableDescription: requiredString(json, 'confusableDescription'),
      confusableComponentLetterNames: requiredStringList(
        json,
        'confusableComponentLetterNames',
      ),
      accessibilityDescription: requiredString(
        json,
        'accessibilityDescription',
      ),
    );
  }

  final String canonicalDescription;
  final List<String> componentLetterNames;
  final String confusableDescription;
  final List<String> confusableComponentLetterNames;
  final String accessibilityDescription;
}

class ReadingRulePresentationReference {
  const ReadingRulePresentationReference(this.ruleId);

  final String ruleId;
}

class LocalizedReadingRuleSupport {
  const LocalizedReadingRuleSupport({
    required this.readingRuleId,
    required this.supportLocale,
    this.title,
    this.shortExplanation,
    this.detailedExplanation,
    this.articulationHint,
    this.commonMistakes,
    this.contrastNote,
    this.metadata = const {},
  });

  final String readingRuleId;
  final String supportLocale;
  final String? title;
  final String? shortExplanation;
  final String? detailedExplanation;
  final String? articulationHint;
  final String? commonMistakes;
  final String? contrastNote;
  final Map<String, String> metadata;
}

class LocalizedPronunciationSupport {
  const LocalizedPronunciationSupport({
    required this.pronunciationUnitId,
    required this.supportLocale,
    this.learnerHint,
    this.explanation,
  });

  final String pronunciationUnitId;
  final String supportLocale;
  final LocalizedPronunciationHint? learnerHint;
  final LocalizedPronunciationExplanation? explanation;
}

class PronunciationBundle {
  const PronunciationBundle({
    required this.schemaVersion,
    required this.targetLanguage,
    required this.pronunciationVariety,
    required this.rules,
    required this.units,
    required this.localizations,
  });

  factory PronunciationBundle.fromJson(Map<String, Object?> json) {
    return PronunciationBundle(
      schemaVersion: _requiredInt(json, 'schemaVersion'),
      targetLanguage: requiredString(json, 'targetLanguage'),
      pronunciationVariety: PronunciationVariety(
        requiredString(json, 'pronunciationVariety'),
      ),
      rules: requiredList(json, 'rules', PronunciationReadingRule.fromJson),
      units: requiredList(json, 'units', PronunciationUnit.fromJson),
      localizations: requiredList(
        json,
        'localizations',
        PronunciationLocalizationEntry.fromJson,
      ),
    );
  }

  final int schemaVersion;
  final String targetLanguage;
  final PronunciationVariety pronunciationVariety;
  final List<PronunciationReadingRule> rules;
  final List<PronunciationUnit> units;
  final List<PronunciationLocalizationEntry> localizations;
}

enum PronunciationIssueSeverity { error, warning, deferred }

class PronunciationValidationIssue {
  const PronunciationValidationIssue({
    required this.code,
    required this.severity,
    required this.message,
  });

  final String code;
  final PronunciationIssueSeverity severity;
  final String message;

  @override
  String toString() => '$code: $message';
}

class PronunciationValidationResult {
  const PronunciationValidationResult({required this.issues});

  final List<PronunciationValidationIssue> issues;

  bool get hasErrors =>
      issues.any((issue) => issue.severity == PronunciationIssueSeverity.error);

  bool get hasWarnings => issues.any(
    (issue) => issue.severity == PronunciationIssueSeverity.warning,
  );
}

class PronunciationCoverageReport {
  const PronunciationCoverageReport({
    required this.legacyPronunciationFieldsDiscovered,
    required this.uniqueTargetForms,
    required this.pronunciationCapableVocabularyEntries,
    required this.pronunciationUnits,
    required this.unitsWithDeclaredVariety,
    required this.unitsWithIpa,
    required this.unitsWithEnglishLearnerHint,
    required this.unitsWithRussianLearnerHint,
    required this.multisyllabicRussianHintsWithStress,
    required this.unitsWithRussianExplanation,
    required this.unitsWithExample,
    required this.unitsRequiringExplanation,
    required this.unitsWithRequiredExplanation,
    required this.readingRules,
    required this.unitsReferencingRules,
    required this.unmigratedLegacyEntries,
    required this.crossLocaleFallbackAttempts,
    required this.invalidUnits,
    required this.unknownReferences,
    required this.readingRulesDiscovered,
    required this.readingRulesMigrated,
    required this.readingRulesWithVariety,
    required this.readingRulesWithPhoneticDefinition,
    required this.readingRulesWithEnglishLocalization,
    required this.readingRulesWithRussianLocalization,
    required this.readingRulesWithExamples,
    required this.readingRulesReferencedByPronunciationUnits,
    required this.readingRulesReferencedByLessons,
    required this.readingRulesReferencedByExercises,
    required this.unusedReadingRules,
    required this.invalidReadingRuleReferences,
    required this.crossLocaleReadingRuleFallbackAttempts,
    required this.llYPronunciationUnits,
    required this.llYUnitsConsistentWithSelectedVariety,
    required this.llYUnitsWithMatchingIpa,
    required this.llYUnitsWithRussianHint,
    required this.llYUnitsWithEnglishHint,
    required this.llYUnitsWithGraphemeExplanation,
    required this.llYVarietyMismatches,
    required this.nonYeistaHintsInYeistaProfile,
  });

  final int legacyPronunciationFieldsDiscovered;
  final int uniqueTargetForms;
  final int pronunciationCapableVocabularyEntries;
  final int pronunciationUnits;
  final int unitsWithDeclaredVariety;
  final int unitsWithIpa;
  final int unitsWithEnglishLearnerHint;
  final int unitsWithRussianLearnerHint;
  final int multisyllabicRussianHintsWithStress;
  final int unitsWithRussianExplanation;
  final int unitsWithExample;
  final int unitsRequiringExplanation;
  final int unitsWithRequiredExplanation;
  final int readingRules;
  final int unitsReferencingRules;
  final int unmigratedLegacyEntries;
  final int crossLocaleFallbackAttempts;
  final int invalidUnits;
  final int unknownReferences;
  final int readingRulesDiscovered;
  final int readingRulesMigrated;
  final int readingRulesWithVariety;
  final int readingRulesWithPhoneticDefinition;
  final int readingRulesWithEnglishLocalization;
  final int readingRulesWithRussianLocalization;
  final int readingRulesWithExamples;
  final int readingRulesReferencedByPronunciationUnits;
  final int readingRulesReferencedByLessons;
  final int readingRulesReferencedByExercises;
  final int unusedReadingRules;
  final int invalidReadingRuleReferences;
  final int crossLocaleReadingRuleFallbackAttempts;
  final int llYPronunciationUnits;
  final int llYUnitsConsistentWithSelectedVariety;
  final int llYUnitsWithMatchingIpa;
  final int llYUnitsWithRussianHint;
  final int llYUnitsWithEnglishHint;
  final int llYUnitsWithGraphemeExplanation;
  final int llYVarietyMismatches;
  final int nonYeistaHintsInYeistaProfile;
}

typedef ResolvedPronunciation = ResolvedPronunciationPresentation;

class ResolvedPronunciationPresentation {
  const ResolvedPronunciationPresentation({
    required this.targetOrthography,
    required this.pronunciationVariety,
    this.localizedLearnerHint,
    this.ipa,
    this.localizedExplanation,
    this.isLegacyEnglishHint = false,
    this.diagnosticCode,
  });

  final String targetOrthography;
  final String pronunciationVariety;
  final String? localizedLearnerHint;
  final String? ipa;
  final String? localizedExplanation;
  final bool isLegacyEnglishHint;
  final String? diagnosticCode;
}

class ResolvedReadingRulePresentation {
  const ResolvedReadingRulePresentation({
    required this.id,
    required this.targetLanguage,
    required this.pronunciationVariety,
    required this.orthographicPattern,
    required this.examplePronunciationUnitIds,
    this.title,
    this.shortExplanation,
    this.detailedExplanation,
    this.articulationHint,
    this.commonMistakes,
    this.contrastNote,
    this.phoneticOutcome,
    this.ipa,
    this.graphemePresentation,
    this.diagnosticCode,
  });

  final String id;
  final String targetLanguage;
  final String pronunciationVariety;
  final String orthographicPattern;
  final List<String> examplePronunciationUnitIds;
  final String? title;
  final String? shortExplanation;
  final String? detailedExplanation;
  final String? articulationHint;
  final String? commonMistakes;
  final String? contrastNote;
  final String? phoneticOutcome;
  final String? ipa;
  final LocalizedGraphemePresentation? graphemePresentation;
  final String? diagnosticCode;
}

Map<String, String> _localizedStringMap(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) {
    return const {};
  }
  if (value is! Map) {
    throw FormatException('Expected localized string map: $key');
  }

  return Map.unmodifiable(
    value.map((key, value) {
      if (value is! String || value.isEmpty) {
        throw FormatException('Invalid localized string for $key');
      }
      return MapEntry('$key', value);
    }),
  );
}

Map<String, LocalizedGraphemePresentation> _localizedGraphemePresentationMap(
  Map<String, Object?> json,
  String key,
) {
  final value = json[key];
  if (value == null) {
    return const {};
  }
  if (value is! Map) {
    throw FormatException('Expected localized grapheme presentation map: $key');
  }

  return Map.unmodifiable(
    value.map((key, value) {
      if (value is Map<String, Object?>) {
        return MapEntry('$key', LocalizedGraphemePresentation.fromJson(value));
      }
      if (value is Map) {
        return MapEntry(
          '$key',
          LocalizedGraphemePresentation.fromJson(
            Map<String, Object?>.from(value),
          ),
        );
      }
      throw FormatException('Invalid localized grapheme presentation for $key');
    }),
  );
}

Map<String, String> _stringMap(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) {
    return const {};
  }
  if (value is! Map) {
    throw FormatException('Expected string map: $key');
  }

  return Map.unmodifiable(
    value.map((key, value) {
      if (value is! String) {
        throw FormatException('Invalid string map value for $key');
      }
      return MapEntry('$key', value);
    }),
  );
}

bool? _optionalBool(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is bool) {
    return value;
  }
  throw FormatException('Expected bool field: $key');
}

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is int) {
    return value;
  }
  throw FormatException('Missing required int field: $key');
}

int? _optionalInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  throw FormatException('Invalid optional int field: $key');
}
