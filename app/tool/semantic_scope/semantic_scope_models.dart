class SemanticScope {
  const SemanticScope({
    required this.courseId,
    required this.moduleId,
    required this.lessonIds,
    required this.requiredIdentities,
    required this.reusableDependencies,
    required this.unresolvedFields,
    required this.validationIssues,
  });

  final String courseId;
  final String moduleId;
  final List<String> lessonIds;
  final List<SemanticRequiredIdentity> requiredIdentities;
  final List<ReusableDependency> reusableDependencies;
  final List<String> unresolvedFields;
  final List<String> validationIssues;

  Map<String, int> get semanticTypeCounts =>
      _countsBy(requiredIdentities.map((identity) => identity.semanticType));

  Map<String, int> get sourceAssetCounts =>
      _countsBy(requiredIdentities.map((identity) => identity.sourceAssetPath));

  Map<String, int> get contentKindCounts =>
      _countsBy(requiredIdentities.map((identity) => identity.contentKind));
}

class SemanticRequiredIdentity {
  const SemanticRequiredIdentity({
    required this.stableIdentity,
    required this.sourceAssetPath,
    required this.sourceObjectId,
    required this.fieldPath,
    required this.contentKind,
    required this.semanticType,
    required this.ownership,
    required this.moduleId,
    required this.lessonIds,
    required this.pedagogicalRole,
    required this.englishSource,
    required this.protectedSpans,
    required this.requiredness,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.reason,
    required this.extractorLayer,
    required this.proposedExtractionRule,
  });

  final String stableIdentity;
  final String sourceAssetPath;
  final String sourceObjectId;
  final String fieldPath;
  final String contentKind;
  final String semanticType;
  final String ownership;
  final String moduleId;
  final List<String> lessonIds;
  final String pedagogicalRole;
  final String englishSource;
  final List<ProtectedSpanSpec> protectedSpans;
  final String requiredness;
  final String sourceLanguage;
  final String targetLanguage;
  final String reason;
  final String extractorLayer;
  final String proposedExtractionRule;

  String get sourceKey => '$sourceObjectId|$fieldPath|$semanticType';
}

class ProtectedSpanSpec {
  const ProtectedSpanSpec({
    required this.id,
    required this.type,
    required this.text,
  });

  final String id;
  final String type;
  final String text;

  Map<String, String> toJson() => {'id': id, 'type': type, 'text': text};
}

class ReusableDependency {
  const ReusableDependency({
    required this.lessonId,
    required this.type,
    required this.assetPath,
    required this.referenceId,
  });

  final String lessonId;
  final String type;
  final String assetPath;
  final String referenceId;
}

Map<String, int> _countsBy(Iterable<String> values) {
  final counts = <String, int>{};
  for (final value in values) {
    counts.update(value, (count) => count + 1, ifAbsent: () => 1);
  }
  return Map.unmodifiable(counts);
}
