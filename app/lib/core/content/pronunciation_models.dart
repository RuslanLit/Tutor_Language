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

class PronunciationReadingRule {
  const PronunciationReadingRule({
    required this.id,
    required this.targetLanguage,
    required this.symbol,
    required this.pronunciationVariety,
    this.ipa,
    this.relatedGrammarIds = const [],
  });

  factory PronunciationReadingRule.fromJson(Map<String, Object?> json) {
    return PronunciationReadingRule(
      id: requiredString(json, 'id'),
      targetLanguage: requiredString(json, 'targetLanguage'),
      symbol: requiredString(json, 'symbol'),
      pronunciationVariety: PronunciationVariety(
        requiredString(json, 'pronunciationVariety'),
      ),
      ipa: optionalString(json, 'ipa') == null
          ? null
          : IpaTranscription(optionalString(json, 'ipa')!),
      relatedGrammarIds: optionalStringList(json, 'relatedGrammarIds'),
    );
  }

  final String id;
  final String targetLanguage;
  final String symbol;
  final PronunciationVariety pronunciationVariety;
  final IpaTranscription? ipa;
  final List<String> relatedGrammarIds;
}

class PronunciationUnit {
  const PronunciationUnit({
    required this.id,
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
  });

  factory PronunciationLocalizationEntry.fromJson(Map<String, Object?> json) {
    return PronunciationLocalizationEntry(
      id: requiredString(json, 'id'),
      learnerHints: _localizedStringMap(json, 'learnerHints'),
      explanations: _localizedStringMap(json, 'explanations'),
    );
  }

  final String id;
  final Map<String, String> learnerHints;
  final Map<String, String> explanations;
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

class PronunciationCoverageReport {
  const PronunciationCoverageReport({
    required this.legacyPronunciationFieldsDiscovered,
    required this.uniqueTargetForms,
    required this.pronunciationUnits,
    required this.unitsWithDeclaredVariety,
    required this.unitsWithIpa,
    required this.unitsWithEnglishLearnerHint,
    required this.unitsWithRussianLearnerHint,
    required this.unitsWithRussianExplanation,
    required this.readingRules,
    required this.unitsReferencingRules,
    required this.unmigratedLegacyEntries,
    required this.crossLocaleFallbackAttempts,
    required this.invalidUnits,
    required this.unknownReferences,
  });

  final int legacyPronunciationFieldsDiscovered;
  final int uniqueTargetForms;
  final int pronunciationUnits;
  final int unitsWithDeclaredVariety;
  final int unitsWithIpa;
  final int unitsWithEnglishLearnerHint;
  final int unitsWithRussianLearnerHint;
  final int unitsWithRussianExplanation;
  final int readingRules;
  final int unitsReferencingRules;
  final int unmigratedLegacyEntries;
  final int crossLocaleFallbackAttempts;
  final int invalidUnits;
  final int unknownReferences;
}

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

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is int) {
    return value;
  }
  throw FormatException('Missing required int field: $key');
}
