import 'dart:convert';

import 'json_parsing.dart';

enum SemanticLocalizationType {
  courseTitle,
  moduleTitle,
  lessonTitle,
  lessonDescription,
  lessonObjective,
  communicativeOutcome,
  learnerInstruction,
  exercisePrompt,
  answerOptionLabel,
  feedback,
  remediation,
  misconceptionExplanation,
  vocabularyMeaning,
  vocabularyUsageNote,
  exampleTranslation,
  grammarTitle,
  grammarExplanation,
  dialogueTitle,
  dialogueTranslation,
  readingTitle,
  readingTranslation,
  readingRuleTitle,
  readingRuleShortExplanation,
  readingRuleDetailedExplanation,
  articulationHint,
  commonMistakeExplanation,
  contrastNote,
  pronunciationHint,
  pronunciationExplanation,
  graphemeDesignation,
  graphemeExplanation,
  accessibilityDescription,
  metadataLabel,
  properNounMeaning,
  countryName,
  cityName,
  nationality,
  grammaticalMetalanguage,
}

enum SemanticTextOwnership {
  targetLanguageOwned,
  supportLanguageOwned,
  localeIndependent,
  mixedStructured,
}

enum ProtectedSpanType {
  targetText,
  targetExample,
  targetTerm,
  ipa,
  placeholder,
  properNameTargetForm,
  codeOrId,
}

enum SemanticReviewStatus {
  generated,
  structurallyValidated,
  semanticallyValidated,
  editoriallyReviewed,
  approved,
}

enum NamedEntityType {
  person,
  country,
  city,
  region,
  language,
  nationality,
  institution,
  other,
}

enum GrammaticalGender { masculine, feminine, neuter, common, mixed, unknown }

enum GrammaticalNumber { singular, plural, invariant, unknown }

enum GrammaticalPerson { first, second, third, impersonal, unknown }

class SemanticLocalizationBundle {
  const SemanticLocalizationBundle({
    required this.schemaVersion,
    required this.targetLanguage,
    required this.sourceSupportLocale,
    required this.supportLocales,
    required this.units,
  });

  factory SemanticLocalizationBundle.fromJson(Map<String, Object?> json) {
    return SemanticLocalizationBundle(
      schemaVersion: _requiredInt(json, 'schemaVersion'),
      targetLanguage: requiredString(json, 'targetLanguage'),
      sourceSupportLocale: requiredString(json, 'sourceSupportLocale'),
      supportLocales: requiredStringList(json, 'supportLocales'),
      units: requiredList(json, 'units', SemanticLocalizationUnit.fromJson),
    );
  }

  final int schemaVersion;
  final String targetLanguage;
  final String sourceSupportLocale;
  final List<String> supportLocales;
  final List<SemanticLocalizationUnit> units;

  Map<String, Object?> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'targetLanguage': targetLanguage,
      'sourceSupportLocale': sourceSupportLocale,
      'supportLocales': supportLocales,
      'units': units.map((unit) => unit.toJson()).toList(growable: false),
    };
  }
}

class SemanticLocalizationUnit {
  const SemanticLocalizationUnit({
    required this.id,
    required this.semanticType,
    required this.ownership,
    required this.sourceText,
    required this.values,
    required this.review,
    required this.context,
    this.protectedSpans = const [],
    this.notes,
  });

  factory SemanticLocalizationUnit.fromJson(Map<String, Object?> json) {
    return SemanticLocalizationUnit(
      id: requiredString(json, 'id'),
      semanticType: _enumByName(
        SemanticLocalizationType.values,
        requiredString(json, 'semanticType'),
        'semanticType',
      ),
      ownership: _enumByName(
        SemanticTextOwnership.values,
        requiredString(json, 'ownership'),
        'ownership',
      ),
      sourceText: requiredString(json, 'sourceText'),
      values: _stringMap(json, 'values'),
      review: _reviewMap(json, 'review'),
      protectedSpans: requiredList(
        json,
        'protectedSpans',
        ProtectedLocalizationSpan.fromJson,
      ),
      context: SemanticLocalizationContext.fromJson(
        requiredMap(json, 'context'),
      ),
      notes: optionalString(json, 'notes'),
    );
  }

  final String id;
  final SemanticLocalizationType semanticType;
  final SemanticTextOwnership ownership;
  final String sourceText;
  final Map<String, String> values;
  final Map<String, SemanticReviewStatus> review;
  final List<ProtectedLocalizationSpan> protectedSpans;
  final SemanticLocalizationContext context;
  final String? notes;

  String get identityKey =>
      '${context.contentObjectId}|${context.fieldPath}|${semanticType.name}';

  String? valueFor(String supportLocale) => values[supportLocale];

  SemanticReviewStatus? reviewStatusFor(String supportLocale) {
    return review[supportLocale];
  }

  bool isApprovedFor(String supportLocale) {
    return reviewStatusFor(supportLocale) == SemanticReviewStatus.approved;
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'semanticType': semanticType.name,
      'ownership': ownership.name,
      'sourceText': sourceText,
      'values': _sortedStringMap(values),
      'review': {
        for (final entry in _sortedReviewEntries(review))
          entry.key: entry.value.name,
      },
      'protectedSpans': protectedSpans
          .map((span) => span.toJson())
          .toList(growable: false),
      'context': context.toJson(),
      if (notes != null) 'notes': notes,
    };
  }
}

class ProtectedLocalizationSpan {
  const ProtectedLocalizationSpan({
    required this.id,
    required this.type,
    required this.text,
  });

  factory ProtectedLocalizationSpan.fromJson(Map<String, Object?> json) {
    return ProtectedLocalizationSpan(
      id: requiredString(json, 'id'),
      type: _enumByName(
        ProtectedSpanType.values,
        requiredString(json, 'type'),
        'protectedSpan.type',
      ),
      text: requiredString(json, 'text'),
    );
  }

  final String id;
  final ProtectedSpanType type;
  final String text;

  Map<String, Object?> toJson() {
    return {'id': id, 'type': type.name, 'text': text};
  }
}

class SemanticLocalizationContext {
  const SemanticLocalizationContext({
    required this.courseId,
    this.moduleId,
    this.lessonId,
    this.activityId,
    required this.contentObjectId,
    required this.fieldPath,
    required this.contentKind,
    required this.pedagogicalRole,
    required this.targetLanguage,
    required this.supportLocale,
    this.grammaticalGender,
    this.grammaticalNumber,
    this.grammaticalPerson,
    this.animacy,
    this.namedEntityType,
    this.expectedAnswerContext,
    this.sourceMeaning,
  });

  factory SemanticLocalizationContext.fromJson(Map<String, Object?> json) {
    return SemanticLocalizationContext(
      courseId: requiredString(json, 'courseId'),
      moduleId: optionalString(json, 'moduleId'),
      lessonId: optionalString(json, 'lessonId'),
      activityId: optionalString(json, 'activityId'),
      contentObjectId: requiredString(json, 'contentObjectId'),
      fieldPath: requiredString(json, 'fieldPath'),
      contentKind: requiredString(json, 'contentKind'),
      pedagogicalRole: requiredString(json, 'pedagogicalRole'),
      targetLanguage: requiredString(json, 'targetLanguage'),
      supportLocale: requiredString(json, 'supportLocale'),
      grammaticalGender: _optionalEnumByName(
        GrammaticalGender.values,
        optionalString(json, 'grammaticalGender'),
        'grammaticalGender',
      ),
      grammaticalNumber: _optionalEnumByName(
        GrammaticalNumber.values,
        optionalString(json, 'grammaticalNumber'),
        'grammaticalNumber',
      ),
      grammaticalPerson: _optionalEnumByName(
        GrammaticalPerson.values,
        optionalString(json, 'grammaticalPerson'),
        'grammaticalPerson',
      ),
      animacy: optionalString(json, 'animacy'),
      namedEntityType: _optionalEnumByName(
        NamedEntityType.values,
        optionalString(json, 'namedEntityType'),
        'namedEntityType',
      ),
      expectedAnswerContext: optionalString(json, 'expectedAnswerContext'),
      sourceMeaning: optionalString(json, 'sourceMeaning'),
    );
  }

  final String courseId;
  final String? moduleId;
  final String? lessonId;
  final String? activityId;
  final String contentObjectId;
  final String fieldPath;
  final String contentKind;
  final String pedagogicalRole;
  final String targetLanguage;
  final String supportLocale;
  final GrammaticalGender? grammaticalGender;
  final GrammaticalNumber? grammaticalNumber;
  final GrammaticalPerson? grammaticalPerson;
  final String? animacy;
  final NamedEntityType? namedEntityType;
  final String? expectedAnswerContext;
  final String? sourceMeaning;

  Map<String, Object?> toJson() {
    return {
      'courseId': courseId,
      if (moduleId != null) 'moduleId': moduleId,
      if (lessonId != null) 'lessonId': lessonId,
      if (activityId != null) 'activityId': activityId,
      'contentObjectId': contentObjectId,
      'fieldPath': fieldPath,
      'contentKind': contentKind,
      'pedagogicalRole': pedagogicalRole,
      'targetLanguage': targetLanguage,
      'supportLocale': supportLocale,
      if (grammaticalGender != null)
        'grammaticalGender': grammaticalGender!.name,
      if (grammaticalNumber != null)
        'grammaticalNumber': grammaticalNumber!.name,
      if (grammaticalPerson != null)
        'grammaticalPerson': grammaticalPerson!.name,
      if (animacy != null) 'animacy': animacy,
      if (namedEntityType != null) 'namedEntityType': namedEntityType!.name,
      if (expectedAnswerContext != null)
        'expectedAnswerContext': expectedAnswerContext,
      if (sourceMeaning != null) 'sourceMeaning': sourceMeaning,
    };
  }
}

class SemanticLocalizationResolver {
  SemanticLocalizationResolver(SemanticLocalizationBundle bundle)
    : _unitsByField = {
        for (final unit in bundle.units)
          '${unit.context.contentObjectId}|${unit.context.fieldPath}': unit,
      };

  final Map<String, SemanticLocalizationUnit> _unitsByField;

  SemanticLocalizationUnit? unitForField(
    String contentObjectId,
    String fieldPath,
  ) {
    return _unitsByField['$contentObjectId|$fieldPath'];
  }

  String? approvedValueForField({
    required String contentObjectId,
    required String fieldPath,
    required String supportLocale,
  }) {
    final unit = unitForField(contentObjectId, fieldPath);
    if (unit == null || !unit.isApprovedFor(supportLocale)) {
      return null;
    }
    return unit.valueFor(supportLocale);
  }
}

class SemanticLocalizationValidationIssue {
  const SemanticLocalizationValidationIssue({
    required this.code,
    required this.message,
    this.unitId,
  });

  final String code;
  final String message;
  final String? unitId;

  @override
  String toString() {
    final prefix = unitId == null ? code : '$code[$unitId]';
    return '$prefix: $message';
  }
}

class SemanticLocalizationValidator {
  const SemanticLocalizationValidator();

  List<SemanticLocalizationValidationIssue> validate({
    required SemanticLocalizationBundle bundle,
    bool production = true,
  }) {
    final issues = <SemanticLocalizationValidationIssue>[];
    final ids = <String>{};
    final identities = <String>{};

    for (final unit in bundle.units) {
      if (!ids.add(unit.id)) {
        issues.add(
          SemanticLocalizationValidationIssue(
            code: 'semantic.duplicateUnitId',
            unitId: unit.id,
            message: 'Duplicate semantic unit id.',
          ),
        );
      }
      if (!identities.add(unit.identityKey)) {
        issues.add(
          SemanticLocalizationValidationIssue(
            code: 'semantic.duplicateIdentityConflict',
            unitId: unit.id,
            message: 'Duplicate semantic identity ${unit.identityKey}.',
          ),
        );
      }
      _validateRequiredContext(unit, issues);
      _validateProtectedSpans(unit, issues);
      _validateRoleSeparation(unit, issues);
      _validateReview(unit, issues, production: production);
    }

    return List.unmodifiable(issues);
  }

  void _validateRequiredContext(
    SemanticLocalizationUnit unit,
    List<SemanticLocalizationValidationIssue> issues,
  ) {
    if (unit.context.courseId.trim().isEmpty ||
        unit.context.contentObjectId.trim().isEmpty ||
        unit.context.fieldPath.trim().isEmpty ||
        unit.context.contentKind.trim().isEmpty ||
        unit.context.pedagogicalRole.trim().isEmpty ||
        unit.context.targetLanguage.trim().isEmpty ||
        unit.context.supportLocale.trim().isEmpty) {
      issues.add(
        SemanticLocalizationValidationIssue(
          code: 'semantic.missingRequiredContext',
          unitId: unit.id,
          message: 'Required semantic context is missing.',
        ),
      );
    }

    if (_requiresNamedEntity(unit) && unit.context.namedEntityType == null) {
      issues.add(
        SemanticLocalizationValidationIssue(
          code: 'semantic.namedEntityTypeMissing',
          unitId: unit.id,
          message: 'Named entity semantic type is required.',
        ),
      );
    }

    if (_requiresGender(unit) && unit.context.grammaticalGender == null) {
      issues.add(
        SemanticLocalizationValidationIssue(
          code: 'semantic.grammaticalGenderMissing',
          unitId: unit.id,
          message: 'Grammatical gender context is required.',
        ),
      );
    }
  }

  void _validateProtectedSpans(
    SemanticLocalizationUnit unit,
    List<SemanticLocalizationValidationIssue> issues,
  ) {
    for (final span in unit.protectedSpans) {
      if (!unit.sourceText.contains(span.text)) {
        issues.add(
          SemanticLocalizationValidationIssue(
            code: 'semantic.protectedSpanMissingFromSource',
            unitId: unit.id,
            message: 'Protected span ${span.id} is absent from source text.',
          ),
        );
      }
      for (final localeValue in unit.values.entries) {
        if ((unit.ownership == SemanticTextOwnership.mixedStructured ||
                unit.ownership == SemanticTextOwnership.localeIndependent ||
                unit.ownership == SemanticTextOwnership.targetLanguageOwned) &&
            !localeValue.value.contains(span.text)) {
          issues.add(
            SemanticLocalizationValidationIssue(
              code: 'semantic.protectedSpanMutated',
              unitId: unit.id,
              message:
                  'Protected span ${span.id} is not preserved in ${localeValue.key}.',
            ),
          );
        }
      }
    }

    if (unit.ownership == SemanticTextOwnership.mixedStructured &&
        unit.protectedSpans.isEmpty) {
      issues.add(
        SemanticLocalizationValidationIssue(
          code: 'semantic.mixedStructuredWithoutProtectedSpans',
          unitId: unit.id,
          message: 'Mixed structured unit must declare protected spans.',
        ),
      );
    }
  }

  void _validateRoleSeparation(
    SemanticLocalizationUnit unit,
    List<SemanticLocalizationValidationIssue> issues,
  ) {
    if (unit.semanticType == SemanticLocalizationType.pronunciationHint &&
        unit.context.sourceMeaning != null) {
      for (final entry in unit.values.entries) {
        if (_normalized(entry.value) ==
            _normalized(unit.context.sourceMeaning!)) {
          issues.add(
            SemanticLocalizationValidationIssue(
              code: 'semantic.pronunciationHintEqualsMeaning',
              unitId: unit.id,
              message: 'Pronunciation hint equals meaning in ${entry.key}.',
            ),
          );
        }
      }
    }

    if (unit.semanticType == SemanticLocalizationType.vocabularyMeaning ||
        unit.semanticType == SemanticLocalizationType.countryName ||
        unit.semanticType == SemanticLocalizationType.cityName ||
        unit.semanticType == SemanticLocalizationType.properNounMeaning) {
      if (unit.values.values.any(
        (value) => value.contains('ˈ') || RegExp(r'/[^/]+/').hasMatch(value),
      )) {
        issues.add(
          SemanticLocalizationValidationIssue(
            code: 'semantic.meaningLooksLikePronunciation',
            unitId: unit.id,
            message: 'Meaning field contains pronunciation-like notation.',
          ),
        );
      }
    }

    if (unit.ownership == SemanticTextOwnership.localeIndependent) {
      for (final entry in unit.values.entries) {
        if (entry.value != unit.sourceText) {
          issues.add(
            SemanticLocalizationValidationIssue(
              code: 'semantic.localeIndependentMutated',
              unitId: unit.id,
              message: 'Locale-independent value changed in ${entry.key}.',
            ),
          );
        }
      }
    }
  }

  void _validateReview(
    SemanticLocalizationUnit unit,
    List<SemanticLocalizationValidationIssue> issues, {
    required bool production,
  }) {
    for (final locale in unit.values.keys) {
      final status = unit.review[locale];
      if (status == null) {
        issues.add(
          SemanticLocalizationValidationIssue(
            code: 'semantic.reviewStatusMissing',
            unitId: unit.id,
            message: 'Missing review status for $locale.',
          ),
        );
        continue;
      }
      if (production &&
          _isLearnerFacing(unit) &&
          status != SemanticReviewStatus.approved) {
        issues.add(
          SemanticLocalizationValidationIssue(
            code: 'semantic.reviewStatusNotReleaseReady',
            unitId: unit.id,
            message:
                'Learner-facing production unit for $locale must be approved, not ${status.name}.',
          ),
        );
      }
    }
  }

  bool _requiresNamedEntity(SemanticLocalizationUnit unit) {
    return switch (unit.semanticType) {
      SemanticLocalizationType.properNounMeaning ||
      SemanticLocalizationType.countryName ||
      SemanticLocalizationType.cityName ||
      SemanticLocalizationType.nationality => true,
      _ => false,
    };
  }

  bool _requiresGender(SemanticLocalizationUnit unit) {
    return unit.context.expectedAnswerContext?.contains('gendered') ?? false;
  }

  bool _isLearnerFacing(SemanticLocalizationUnit unit) {
    return unit.semanticType != SemanticLocalizationType.metadataLabel &&
        unit.ownership != SemanticTextOwnership.localeIndependent;
  }
}

String serializeSemanticLocalizationBundle(SemanticLocalizationBundle bundle) {
  return const JsonEncoder.withIndent('  ').convert(bundle.toJson());
}

T _enumByName<T extends Enum>(List<T> values, String name, String fieldName) {
  for (final value in values) {
    if (value.name == name) {
      return value;
    }
  }
  throw FormatException('Unsupported $fieldName: $name');
}

T? _optionalEnumByName<T extends Enum>(
  List<T> values,
  String? name,
  String fieldName,
) {
  if (name == null) {
    return null;
  }
  return _enumByName(values, name, fieldName);
}

Map<String, String> _stringMap(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! Map) {
    throw FormatException('Expected string map: $key');
  }
  return Map.unmodifiable(
    value.map((key, value) {
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('Invalid string map value for $key');
      }
      return MapEntry('$key', value);
    }),
  );
}

Map<String, SemanticReviewStatus> _reviewMap(
  Map<String, Object?> json,
  String key,
) {
  final value = json[key];
  if (value is! Map) {
    throw FormatException('Expected review map: $key');
  }
  return Map.unmodifiable(
    value.map((key, value) {
      if (value is! String) {
        throw FormatException('Invalid review value for $key');
      }
      return MapEntry(
        '$key',
        _enumByName(SemanticReviewStatus.values, value, 'reviewStatus'),
      );
    }),
  );
}

Map<String, String> _sortedStringMap(Map<String, String> input) {
  return {
    for (final entry
        in input.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
      entry.key: entry.value,
  };
}

List<MapEntry<String, SemanticReviewStatus>> _sortedReviewEntries(
  Map<String, SemanticReviewStatus> input,
) {
  return input.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
}

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is int) {
    return value;
  }
  throw FormatException('Expected integer: $key');
}

String _normalized(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), ' ')
      .trim();
}
