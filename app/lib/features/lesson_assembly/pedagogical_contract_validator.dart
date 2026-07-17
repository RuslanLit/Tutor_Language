import '../../core/content/pronunciation_catalog.dart';
import '../../core/content/pronunciation_models.dart';
import '../../core/content/semantic_localization.dart';
import '../../core/content/topic_content.dart';
import 'lesson_content.dart';

enum PedagogicalIssueSeverity { blocker, error, warning }

enum ExercisePedagogicalClass {
  presentation,
  recognition,
  guidedRecall,
  independentRecall,
  transfer,
  review,
}

class PedagogicalContract {
  const PedagogicalContract({
    required this.educationalIntent,
    required this.knowledgePresented,
    required this.knowledgeHidden,
    required this.expectedRecall,
    required this.assessmentTarget,
    required this.allowedVisibleInformation,
    required this.successCriteria,
    required this.exerciseClass,
  });

  final String educationalIntent;
  final String knowledgePresented;
  final String knowledgeHidden;
  final String expectedRecall;
  final String assessmentTarget;
  final String allowedVisibleInformation;
  final String successCriteria;
  final ExercisePedagogicalClass exerciseClass;
}

class PedagogicalContractIssue {
  const PedagogicalContractIssue({
    required this.code,
    required this.severity,
    required this.message,
    this.objectId,
    this.field,
    this.sourcePath,
  });

  final String code;
  final PedagogicalIssueSeverity severity;
  final String message;
  final String? objectId;
  final String? field;
  final String? sourcePath;

  @override
  String toString() {
    final id = objectId == null ? code : '$code[$objectId]';
    final location = [
      if (field != null) field,
      if (sourcePath != null) sourcePath,
    ].join(' ');
    final suffix = location.isEmpty ? '' : ' ($location)';
    return '$id: ${severity.name}$suffix: $message';
  }
}

class PedagogicalContractValidator {
  const PedagogicalContractValidator();

  List<PedagogicalContractIssue> validateLessonContent({
    required LessonContent lessonContent,
    PronunciationCatalog? pronunciationCatalog,
    String supportLocale = 'en',
  }) {
    final issues = <PedagogicalContractIssue>[];
    final seenEducationalObjects = <String>{};
    var seenAssessment = false;

    for (final activity in lessonContent.activities) {
      for (final content in activity.resolvedContent) {
        final objectId = _objectId(content);
        if (objectId != null && !seenEducationalObjects.add(objectId)) {
          issues.add(
            PedagogicalContractIssue(
              code: 'DUPLICATE_EDUCATIONAL_UNIT',
              severity: PedagogicalIssueSeverity.error,
              objectId: objectId,
              field: 'resolvedContent',
              message: 'Duplicate educational object in assembled lesson.',
            ),
          );
        }

        if (content is ExerciseTemplate) {
          seenAssessment = true;
          issues.addAll(validateExerciseTemplate(content));
        }

        if (content is ReadingRulePresentationReference &&
            pronunciationCatalog != null) {
          final rule = pronunciationCatalog.readingRuleById(content.ruleId);
          if (rule == null) {
            issues.add(
              PedagogicalContractIssue(
                code: 'UNKNOWN_READING_RULE',
                severity: PedagogicalIssueSeverity.blocker,
                objectId: content.ruleId,
                field: 'readingRuleId',
                message: 'Assembled lesson references an unknown ReadingRule.',
              ),
            );
          } else {
            issues.addAll(
              validateReadingRule(
                rule,
                pronunciationCatalog: pronunciationCatalog,
                supportLocale: supportLocale,
              ),
            );
          }
        }
      }
    }

    if (!seenAssessment) {
      issues.add(
        PedagogicalContractIssue(
          code: 'LESSON_WITHOUT_ASSESSMENT',
          severity: PedagogicalIssueSeverity.error,
          objectId: lessonContent.lesson.id,
          field: 'activities',
          message:
              'Assembled lesson must include at least one assessment step.',
        ),
      );
    }

    return List.unmodifiable(issues);
  }

  List<PedagogicalContractIssue> validateExerciseTemplate(
    ExerciseTemplate template,
  ) {
    return validateExerciseContract(template: template);
  }

  List<PedagogicalContractIssue> validateExerciseContract({
    required ExerciseTemplate template,
    Iterable<String> visibleHints = const [],
    Iterable<String> visibleContent = const [],
    Iterable<String> visibleExamples = const [],
    Iterable<String> visibleCopyFields = const [],
    bool hiddenKnowledgeDeclared = true,
    bool assessmentTargetDeclared = true,
    bool expectedResponseRequired = true,
    bool feedbackRequired = false,
    bool feedbackPresent = true,
    bool remediationRequired = false,
    bool remediationPresent = true,
    ExercisePedagogicalClass? declaredExerciseClass,
    String? sourcePath,
  }) {
    final issues = <PedagogicalContractIssue>[];
    final contract = contractForExercise(template);
    final exerciseClass = contract.exerciseClass;
    final answers = _answerStrings(template).toList();

    if (answers.isEmpty && expectedResponseRequired) {
      issues.add(
        PedagogicalContractIssue(
          code: 'EXPECTED_RESPONSE_MISSING',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: template.id,
          field: 'expectedAnswer',
          sourcePath: sourcePath,
          message: 'Checkable exercise must declare expected recall.',
        ),
      );
    }

    if (!assessmentTargetDeclared) {
      issues.add(
        PedagogicalContractIssue(
          code: 'ASSESSMENT_TARGET_MISSING',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: template.id,
          field: 'assessmentTarget',
          sourcePath: sourcePath,
          message: 'Assessment step must declare its assessment target.',
        ),
      );
    }

    if (exerciseClass == ExercisePedagogicalClass.independentRecall &&
        !hiddenKnowledgeDeclared) {
      issues.add(
        PedagogicalContractIssue(
          code: 'RECALL_HIDDEN_KNOWLEDGE_UNDECLARED',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: template.id,
          field: 'knowledgeHidden',
          sourcePath: sourcePath,
          message: 'Independent recall must declare hidden target knowledge.',
        ),
      );
    }

    if (declaredExerciseClass != null &&
        declaredExerciseClass != exerciseClass) {
      issues.add(
        PedagogicalContractIssue(
          code: 'EXERCISE_CLASSIFICATION_CONTRACT_VIOLATION',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: template.id,
          field: 'exerciseClass',
          sourcePath: sourcePath,
          message:
              'Declared exercise class ${declaredExerciseClass.name} conflicts with behavior ${exerciseClass.name}.',
        ),
      );
    }

    if (feedbackRequired && !feedbackPresent) {
      issues.add(
        PedagogicalContractIssue(
          code: 'ASSESSMENT_FEEDBACK_MISSING',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: template.id,
          field: 'feedback',
          sourcePath: sourcePath,
          message: 'Required assessment feedback is missing.',
        ),
      );
    }

    if (remediationRequired && !remediationPresent) {
      issues.add(
        PedagogicalContractIssue(
          code: 'REMEDIATION_PATH_MISSING',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: template.id,
          field: 'remediation',
          sourcePath: sourcePath,
          message: 'Required recoverable error path has no remediation.',
        ),
      );
    }

    if (exerciseClass == ExercisePedagogicalClass.recognition &&
        template.answerOptions.isEmpty) {
      issues.add(
        PedagogicalContractIssue(
          code: 'EXERCISE_CLASSIFICATION_CONTRACT_VIOLATION',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: template.id,
          field: 'answerOptions',
          sourcePath: sourcePath,
          message: 'Recognition exercise must provide answer options.',
        ),
      );
    }

    if (exerciseClass == ExercisePedagogicalClass.independentRecall &&
        template.answerOptions.isNotEmpty) {
      issues.add(
        PedagogicalContractIssue(
          code: 'RECALL_ANSWER_COPYABLE',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: template.id,
          field: 'answerOptions',
          sourcePath: sourcePath,
          message:
              'Independent recall must not provide answer options to copy.',
        ),
      );
    }

    final visibleText = <String>[
      template.promptTemplate,
      if (exerciseClass == ExercisePedagogicalClass.recognition)
        for (final option in template.answerOptions) option.label,
    ];
    final leakSources = <_LeakSource>[
      _LeakSource(
        field: 'prompt',
        text: template.promptTemplate,
        expectedCode: 'ANSWER_LEAK_IN_PROMPT',
        acceptedCode: 'ACCEPTED_ANSWER_LEAK',
      ),
      for (final hint in visibleHints)
        _LeakSource(
          field: 'hint',
          text: hint,
          expectedCode: 'ANSWER_LEAK_IN_HINT',
          acceptedCode: 'ACCEPTED_ANSWER_LEAK',
        ),
      for (final content in visibleContent)
        _LeakSource(
          field: 'visibleContent',
          text: content,
          expectedCode: 'ANSWER_LEAK_IN_VISIBLE_CONTENT',
          acceptedCode: 'ACCEPTED_ANSWER_LEAK',
        ),
      for (final example in visibleExamples)
        _LeakSource(
          field: 'visibleExample',
          text: example,
          expectedCode: 'ANSWER_LEAK_IN_VISIBLE_EXAMPLE',
          acceptedCode: 'ACCEPTED_ANSWER_LEAK',
        ),
    ];
    if (exerciseClass != ExercisePedagogicalClass.recognition) {
      for (final option in template.answerOptions) {
        leakSources.add(
          _LeakSource(
            field: 'answerOption:${option.id}',
            text: option.label,
            expectedCode: 'RECALL_ANSWER_COPYABLE',
            acceptedCode: 'ACCEPTED_ANSWER_LEAK',
          ),
        );
      }
    }

    for (final answer in _answerCandidates(template)) {
      for (final source in leakSources) {
        if (_containsAnswer(source.text, answer.value)) {
          issues.add(
            PedagogicalContractIssue(
              code: answer.isAcceptedAnswer
                  ? source.acceptedCode
                  : source.expectedCode,
              severity: PedagogicalIssueSeverity.blocker,
              objectId: template.id,
              field: source.field,
              sourcePath: sourcePath,
              message:
                  'Expected answer "${answer.value}" appears in visible ${source.field}.',
            ),
          );
        }
      }
    }

    if (exerciseClass == ExercisePedagogicalClass.independentRecall &&
        _isCopyInstruction(template.promptTemplate)) {
      issues.add(
        PedagogicalContractIssue(
          code: 'COPY_TASK_MISCLASSIFIED_AS_RECALL',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: template.id,
          field: 'promptTemplate',
          sourcePath: sourcePath,
          message:
              'Copy-the-text instruction cannot be classified as independent recall.',
        ),
      );
    }

    for (final copyField in visibleCopyFields) {
      for (final answer in answers) {
        if (_containsAnswer(copyField, answer)) {
          issues.add(
            PedagogicalContractIssue(
              code: 'RECALL_ANSWER_COPYABLE',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: template.id,
              field: 'visibleCopyField',
              sourcePath: sourcePath,
              message:
                  'Required response can be copied from another visible field.',
            ),
          );
        }
      }
    }

    if (exerciseClass == ExercisePedagogicalClass.presentation &&
        visibleText.every((text) => text.trim().isEmpty)) {
      issues.add(
        PedagogicalContractIssue(
          code: 'EMPTY_PRESENTATION',
          severity: PedagogicalIssueSeverity.error,
          objectId: template.id,
          field: 'promptTemplate',
          sourcePath: sourcePath,
          message: 'Presentation step must present visible knowledge.',
        ),
      );
    }

    return List.unmodifiable(issues);
  }

  List<PedagogicalContractIssue> validateReadingRule(
    PronunciationReadingRule rule, {
    required PronunciationCatalog pronunciationCatalog,
    required String supportLocale,
  }) {
    final issues = <PedagogicalContractIssue>[];
    final resolved = pronunciationCatalog.resolveReadingRule(
      rule.id,
      supportLocaleCode: supportLocale,
    );
    final localization = pronunciationCatalog.localizationById(rule.id);
    final localizedNameHint = localization?.learnerHints[supportLocale] ?? '';

    void require(bool condition, String code, String field, String message) {
      if (!condition) {
        issues.add(
          PedagogicalContractIssue(
            code: code,
            severity: PedagogicalIssueSeverity.blocker,
            objectId: rule.id,
            field: field,
            message: message,
          ),
        );
      }
    }

    require(
      rule.orthographicPattern.trim().isNotEmpty,
      'READING_RULE_WRITTEN_FORM_MISSING',
      'orthographicPattern',
      'ReadingRule must declare Spanish written form.',
    );
    require(
      rule.ruleKind.trim().isNotEmpty && rule.knowledgeDomain.trim().isNotEmpty,
      'READING_RULE_DESIGNATION_MISSING',
      'ruleKind',
      'ReadingRule must declare grammatical/educational designation.',
    );
    require(
      resolved?.title?.trim().isNotEmpty ?? false,
      'READING_RULE_NAME_MISSING',
      'title.$supportLocale',
      'ReadingRule must provide localized letter/digraph name.',
    );
    if ((resolved?.title?.trim().isNotEmpty ?? false) &&
        _sameNormalized(resolved!.title!, rule.orthographicPattern)) {
      issues.add(
        PedagogicalContractIssue(
          code: 'READING_RULE_NAME_PLACEHOLDER',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: rule.id,
          field: 'title.$supportLocale',
          message: 'ReadingRule conventional name cannot repeat the symbol.',
        ),
      );
    }
    require(
      _hasStressMark(resolved?.title ?? '') ||
          _hasStressMark(resolved?.shortExplanation ?? '') ||
          localizedNameHint.trim().isNotEmpty ||
          supportLocale == 'en',
      'READING_RULE_LOCALIZED_PRONUNCIATION_HINT_MISSING',
      'shortExplanation.$supportLocale',
      'ReadingRule must include localized pronunciation of the name.',
    );
    require(
      rule.ipa != null || (rule.phoneticOutcome?.contains('/') ?? false),
      'READING_RULE_IPA_MISSING',
      'ipa',
      'ReadingRule must include IPA or phonetic outcome.',
    );
    require(
      resolved?.shortExplanation?.trim().isNotEmpty ?? false,
      'READING_RULE_EXPLANATION_MISSING',
      'shortExplanation.$supportLocale',
      'ReadingRule must include learner explanation.',
    );
    require(
      resolved?.detailedExplanation?.trim().isNotEmpty ?? false,
      'READING_RULE_EXPLANATION_MISSING',
      'detailedExplanation.$supportLocale',
      'ReadingRule must include reading explanation.',
    );
    require(
      rule.examplePronunciationUnitIds.isNotEmpty,
      'READING_RULE_EXAMPLES_MISSING',
      'examplePronunciationUnitIds',
      'ReadingRule must include examples.',
    );
    require(
      resolved?.commonMistakes?.trim().isNotEmpty ?? false,
      'READING_RULE_EXPLANATION_MISSING',
      'commonMistakes.$supportLocale',
      'ReadingRule must include common misconception guidance.',
    );

    final semanticFields = <String, String>{
      'symbol': rule.orthographicPattern,
      if (rule.ipa?.value != null) 'ipa': rule.ipa!.value,
      if (resolved?.title != null) 'name': resolved!.title!,
      if (resolved?.shortExplanation != null)
        'learnerHint': resolved!.shortExplanation!,
      if (resolved?.detailedExplanation != null)
        'explanation': resolved!.detailedExplanation!,
      if (resolved?.phoneticOutcome != null)
        'reading': resolved!.phoneticOutcome!,
    };
    if (_hasInvalidReadingRuleSubstitution(rule, semanticFields)) {
      issues.add(
        PedagogicalContractIssue(
          code: 'READING_RULE_FIELD_SEMANTICS_INVALID',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: rule.id,
          message:
              'ReadingRule fields reuse values with incompatible semantics.',
        ),
      );
    }
    if (_hasDuplicatePlaceholderFields(
      rule.orthographicPattern,
      semanticFields,
    )) {
      issues.add(
        PedagogicalContractIssue(
          code: 'READING_RULE_DUPLICATE_PLACEHOLDER_FIELDS',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: rule.id,
          message:
              'ReadingRule repeats the symbol as multiple semantic fields.',
        ),
      );
    }

    return List.unmodifiable(issues);
  }

  List<PedagogicalContractIssue> validatePronunciationCompleteness({
    required PronunciationCatalog pronunciationCatalog,
    required Iterable<String> pronunciationUnitIds,
    required String supportLocale,
  }) {
    final issues = <PedagogicalContractIssue>[];
    for (final unitId in pronunciationUnitIds) {
      final unit = pronunciationCatalog.unitById(unitId);
      final resolved = pronunciationCatalog.resolveUnit(
        unitId,
        supportLocaleCode: supportLocale,
      );
      if (unit == null) {
        issues.add(
          PedagogicalContractIssue(
            code: 'UNKNOWN_PRONUNCIATION_UNIT',
            severity: PedagogicalIssueSeverity.blocker,
            objectId: unitId,
            message: 'Pronunciation unit is missing.',
          ),
        );
        continue;
      }
      if (unit.targetOrthography.trim().isEmpty) {
        issues.add(
          PedagogicalContractIssue(
            code: 'PRONUNCIATION_ORTHOGRAPHY_MISSING',
            severity: PedagogicalIssueSeverity.blocker,
            objectId: unitId,
            field: 'targetOrthography',
            message: 'Pronunciation unit must preserve Spanish orthography.',
          ),
        );
      }
      if (unit.ipa == null) {
        issues.add(
          PedagogicalContractIssue(
            code: 'PRONUNCIATION_IPA_MISSING',
            severity: PedagogicalIssueSeverity.blocker,
            objectId: unitId,
            field: 'ipa',
            message: 'Pronunciation unit must include IPA.',
          ),
        );
      }
      if (resolved?.localizedLearnerHint?.trim().isEmpty ?? true) {
        issues.add(
          PedagogicalContractIssue(
            code: 'PRONUNCIATION_LOCALIZED_HINT_MISSING',
            severity: PedagogicalIssueSeverity.blocker,
            objectId: unitId,
            field: 'learnerHints.$supportLocale',
            message: 'Pronunciation unit must include localized learner hint.',
          ),
        );
        final localization = pronunciationCatalog.localizationById(unitId);
        if (localization?.learnerHints.keys.any(
              (locale) => locale != supportLocale && locale != 'en',
            ) ??
            false) {
          issues.add(
            PedagogicalContractIssue(
              code: 'PRONUNCIATION_CROSS_LOCALE_FALLBACK',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: unitId,
              field: 'learnerHints.$supportLocale',
              message:
                  'Pronunciation support must not use another support locale as fallback.',
            ),
          );
        }
        if ((localization?.learnerHints.containsKey('en') ?? false) ||
            unit.localizedLearnerHints.containsKey('en')) {
          issues.add(
            PedagogicalContractIssue(
              code: 'PRONUNCIATION_ENGLISH_RESPelling_FALLBACK_FORBIDDEN',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: unitId,
              field: 'learnerHints.en',
              message:
                  'English respelling must not be used as universal fallback.',
            ),
          );
        }
      }
      if (resolved?.localizedExplanation?.trim().isEmpty ?? true) {
        issues.add(
          PedagogicalContractIssue(
            code: 'PRONUNCIATION_LOCALIZED_EXPLANATION_MISSING',
            severity: PedagogicalIssueSeverity.blocker,
            objectId: unitId,
            field: 'explanations.$supportLocale',
            message: 'Pronunciation unit must include localized explanation.',
          ),
        );
      }
      if (!_looksLikeSpanishOrthography(unit.targetOrthography)) {
        issues.add(
          PedagogicalContractIssue(
            code: 'TARGET_ORTHOGRAPHY_LOCALIZED',
            severity: PedagogicalIssueSeverity.blocker,
            objectId: unitId,
            field: 'targetOrthography',
            message: 'Pronunciation target orthography must remain Spanish.',
          ),
        );
      }
      if (unit.relatedContentIds.isEmpty && unit.relatedVocabularyIds.isEmpty) {
        issues.add(
          PedagogicalContractIssue(
            code: 'PRONUNCIATION_EXAMPLES_MISSING',
            severity: PedagogicalIssueSeverity.blocker,
            objectId: unitId,
            message: 'Pronunciation unit must be connected to examples.',
          ),
        );
      }
    }
    return List.unmodifiable(issues);
  }

  List<PedagogicalContractIssue> validateSemanticApproval(
    SemanticLocalizationBundle bundle,
  ) {
    final issues = <PedagogicalContractIssue>[];
    for (final unit in bundle.units) {
      for (final entry in unit.review.entries) {
        if (entry.value == SemanticReviewStatus.generated &&
            unit.values[entry.key]?.trim().isNotEmpty == true) {
          issues.add(
            PedagogicalContractIssue(
              code: 'GENERATED_CONTENT_HAS_VALUE',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: unit.id,
              field: 'values.${entry.key}',
              message:
                  'Generated semantic content must not carry production values.',
            ),
          );
        }
        if (entry.value == SemanticReviewStatus.approved) {
          issues.add(
            PedagogicalContractIssue(
              code: 'LEGACY_APPROVAL_STATE_FORBIDDEN',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: unit.id,
              field: 'review.${entry.key}',
              message:
                  'Legacy approved state bypasses pedagogical verification.',
            ),
          );
        }
        if (entry.value != SemanticReviewStatus.productionApproved) {
          continue;
        }
        final value = unit.values[entry.key]?.trim() ?? '';
        if (value.isEmpty) {
          issues.add(
            PedagogicalContractIssue(
              code: 'PRODUCTION_LOCALIZATION_FALLBACK_USED',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: unit.id,
              field: 'values.${entry.key}',
              message: 'Production-approved localization must not be empty.',
            ),
          );
          issues.add(
            PedagogicalContractIssue(
              code: 'INVALID_UNIT_PRODUCTION_APPROVED',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: unit.id,
              field: 'review.${entry.key}',
              message: 'Invalid unit cannot be production approved.',
            ),
          );
        }
        if ((unit.notes ?? '').contains('generated')) {
          issues.add(
            PedagogicalContractIssue(
              code: 'AUTOMATED_PRODUCTION_APPROVAL_FORBIDDEN',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: unit.id,
              field: 'review.${entry.key}',
              message:
                  'Automated generation cannot assign production approval.',
            ),
          );
        }
        if (entry.key == 'uk') {
          if (_containsUnexpectedEnglish(unit, value)) {
            issues.add(
              PedagogicalContractIssue(
                code: 'UNEXPECTED_ENGLISH_IN_UKRAINIAN_CONTENT',
                severity: PedagogicalIssueSeverity.blocker,
                objectId: unit.id,
                field: 'values.uk',
                message:
                    'Ukrainian production content contains unapproved English prose.',
              ),
            );
          }
          if (_containsRussianContamination(value)) {
            issues.add(
              PedagogicalContractIssue(
                code: 'UNEXPECTED_RUSSIAN_IN_UKRAINIAN_CONTENT',
                severity: PedagogicalIssueSeverity.blocker,
                objectId: unit.id,
                field: 'values.uk',
                message:
                    'Ukrainian production content contains deterministic Russian contamination.',
              ),
            );
          }
        }
        if (_hasSemanticFieldCategoryMismatch(unit, value)) {
          issues.add(
            PedagogicalContractIssue(
              code: 'SEMANTIC_FIELD_CATEGORY_MISMATCH',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: unit.id,
              field: 'semanticType',
              message:
                  'Semantic unit value conflicts with its typed field category.',
            ),
          );
        }
        if (_hasEntityTypeConflict(unit)) {
          issues.add(
            PedagogicalContractIssue(
              code: 'SEMANTIC_ENTITY_TYPE_CONFLICT',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: unit.id,
              field: 'semanticType',
              message:
                  'Semantic unit entity type conflicts with typed context metadata.',
            ),
          );
        }
      }
    }
    return List.unmodifiable(issues);
  }

  List<PedagogicalContractIssue> validateRuntimeAssembly({
    required ExerciseTemplate template,
    Iterable<String> persistentVisibleContent = const [],
    bool presentationRecallCollision = false,
    bool duplicateUnitExposesAnswer = false,
    bool pronunciationDataLost = false,
    String? sourcePath,
  }) {
    final issues = <PedagogicalContractIssue>[];
    final answers = _answerStrings(template).toList();
    for (final visible in persistentVisibleContent) {
      for (final answer in answers) {
        if (_containsAnswer(visible, answer)) {
          issues.addAll([
            PedagogicalContractIssue(
              code: 'RECALL_TARGET_NOT_HIDDEN',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: template.id,
              field: 'persistentVisibleContent',
              sourcePath: sourcePath,
              message:
                  'Recall target remains visible in persistent runtime context.',
            ),
            PedagogicalContractIssue(
              code: 'RUNTIME_ASSEMBLED_ANSWER_LEAK',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: template.id,
              field: 'persistentVisibleContent',
              sourcePath: sourcePath,
              message:
                  'Assembled lesson reintroduced an answer leak at runtime.',
            ),
            PedagogicalContractIssue(
              code: 'RUNTIME_HIDDEN_KNOWLEDGE_EXPOSED',
              severity: PedagogicalIssueSeverity.blocker,
              objectId: template.id,
              field: 'persistentVisibleContent',
              sourcePath: sourcePath,
              message:
                  'Hidden knowledge is visible through shared runtime context.',
            ),
          ]);
        }
      }
    }
    if (presentationRecallCollision) {
      issues.add(
        PedagogicalContractIssue(
          code: 'RUNTIME_PRESENTATION_RECALL_COLLISION',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: template.id,
          field: 'runtimeStep',
          sourcePath: sourcePath,
          message: 'Presentation and recall collapse into one visible step.',
        ),
      );
    }
    if (duplicateUnitExposesAnswer) {
      issues.add(
        PedagogicalContractIssue(
          code: 'RUNTIME_DUPLICATE_UNIT_EXPOSES_ANSWER',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: template.id,
          field: 'resolvedContent',
          sourcePath: sourcePath,
          message: 'Duplicate educational unit exposes the recall answer.',
        ),
      );
    }
    if (pronunciationDataLost) {
      issues.add(
        PedagogicalContractIssue(
          code: 'RUNTIME_PRONUNCIATION_DATA_LOST',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: template.id,
          field: 'pronunciation',
          sourcePath: sourcePath,
          message:
              'Required localized pronunciation data was lost in assembly.',
        ),
      );
    }
    return List.unmodifiable(issues);
  }

  List<PedagogicalContractIssue> validateApprovalTransition({
    required String objectId,
    required SemanticReviewStatus from,
    required SemanticReviewStatus to,
  }) {
    if (from == SemanticReviewStatus.draft &&
        to == SemanticReviewStatus.productionApproved) {
      return [
        PedagogicalContractIssue(
          code: 'APPROVAL_STATE_TRANSITION_INVALID',
          severity: PedagogicalIssueSeverity.blocker,
          objectId: objectId,
          field: 'review',
          message: 'Approval transition skips mandatory review gates.',
        ),
      ];
    }
    return const [];
  }

  List<PedagogicalContractIssue> validateProductionManifest({
    required Iterable<SemanticLocalizationUnit> units,
    required String supportLocale,
  }) {
    return [
      for (final unit in units)
        if (!unit.isApprovedFor(supportLocale))
          PedagogicalContractIssue(
            code: 'NON_APPROVED_UNIT_IN_PRODUCTION_MANIFEST',
            severity: PedagogicalIssueSeverity.blocker,
            objectId: unit.id,
            field: 'review.$supportLocale',
            message:
                'Production manifest includes a non-production-approved unit.',
          ),
    ];
  }

  PedagogicalContract contractForExercise(ExerciseTemplate template) {
    final exerciseClass = _classify(template);
    return PedagogicalContract(
      educationalIntent: exerciseClass.name,
      knowledgePresented: exerciseClass == ExercisePedagogicalClass.presentation
          ? template.promptTemplate
          : '',
      knowledgeHidden:
          exerciseClass == ExercisePedagogicalClass.independentRecall
          ? _answerStrings(template).join(', ')
          : '',
      expectedRecall: _answerStrings(template).join(', '),
      assessmentTarget: template.exerciseType,
      allowedVisibleInformation: switch (exerciseClass) {
        ExercisePedagogicalClass.presentation => 'target answer allowed',
        ExercisePedagogicalClass.recognition => 'answer options allowed',
        ExercisePedagogicalClass.guidedRecall => 'hints allowed',
        ExercisePedagogicalClass.independentRecall =>
          'prompt only; target response hidden',
        ExercisePedagogicalClass.transfer => 'new context; target hidden',
        ExercisePedagogicalClass.review => 'recall rules enforced',
      },
      successCriteria:
          template.expectedAnswer ?? template.correctOptionId ?? '',
      exerciseClass: exerciseClass,
    );
  }

  ExercisePedagogicalClass _classify(ExerciseTemplate template) {
    final id = template.id.toLowerCase();
    final type = template.exerciseType.toLowerCase();
    if (type == 'presentation' || id.contains('presentation')) {
      return ExercisePedagogicalClass.presentation;
    }
    if (type == 'multiple_choice') {
      return ExercisePedagogicalClass.recognition;
    }
    if (id.contains('review')) {
      return ExercisePedagogicalClass.review;
    }
    if (type == 'text_entry' || type == 'fill_gap' || type == 'matching') {
      return ExercisePedagogicalClass.independentRecall;
    }
    return ExercisePedagogicalClass.guidedRecall;
  }

  Iterable<String> _answerStrings(ExerciseTemplate template) sync* {
    if (template.expectedAnswer != null) {
      yield template.expectedAnswer!;
    }
    if (template.correctOptionId != null) {
      for (final option in template.answerOptions) {
        if (option.id == template.correctOptionId) {
          yield option.label;
        }
      }
    }
    yield* template.acceptedAnswers;
    for (final answer in template.acceptedWithFeedbackAnswers) {
      yield answer.answer;
      if (answer.canonicalAnswer != null) {
        yield answer.canonicalAnswer!;
      }
    }
  }

  Iterable<_AnswerCandidate> _answerCandidates(
    ExerciseTemplate template,
  ) sync* {
    if (template.expectedAnswer != null) {
      yield _AnswerCandidate(template.expectedAnswer!, false);
    }
    if (template.correctOptionId != null) {
      for (final option in template.answerOptions) {
        if (option.id == template.correctOptionId) {
          yield _AnswerCandidate(option.label, false);
        }
      }
    }
    for (final answer in template.acceptedAnswers) {
      yield _AnswerCandidate(answer, true);
    }
    for (final answer in template.acceptedWithFeedbackAnswers) {
      yield _AnswerCandidate(answer.answer, true);
      if (answer.canonicalAnswer != null) {
        yield _AnswerCandidate(answer.canonicalAnswer!, true);
      }
    }
  }

  bool _containsAnswer(String visible, String answer) {
    final normalizedVisible = _normalize(visible);
    final normalizedAnswer = _normalize(answer);
    if (normalizedAnswer.length < 2) {
      return false;
    }
    return RegExp(
      '(^|[^a-z0-9])${RegExp.escape(normalizedAnswer)}([^a-z0-9]|\$)',
    ).hasMatch(normalizedVisible);
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[_]+'), ' ')
        .replaceAll(RegExp(r'[^a-z0-9áéíóúüñ]+'), ' ')
        .trim();
  }

  bool _isCopyInstruction(String value) {
    final lower = value.toLowerCase();
    return lower.contains('copy') ||
        lower.contains('rewrite') ||
        lower.contains('перепиш') ||
        lower.contains('скопію');
  }

  String? _objectId(Object content) {
    return switch (content) {
      VocabularyItem() => content.id,
      GrammarTopic() => content.id,
      Dialogue() => content.id,
      ReadingText() => content.id,
      ExerciseTemplate() => content.id,
      ReadingRulePresentationReference() => content.ruleId,
      _ => null,
    };
  }

  bool _hasStressMark(String value) {
    return RegExp(r'[\u0301ÁÉÍÓÚáéíóú]').hasMatch(value);
  }

  bool _sameNormalized(String left, String right) {
    final normalizedLeft = _normalizeComparableField(left);
    final normalizedRight = _normalizeComparableField(right);
    return normalizedLeft.isNotEmpty &&
        normalizedRight.isNotEmpty &&
        normalizedLeft == normalizedRight;
  }

  String _normalizeComparableField(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9áéíóúüñа-яіїєґ]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  bool _hasInvalidReadingRuleSubstitution(
    PronunciationReadingRule rule,
    Map<String, String> fields,
  ) {
    final ipa = fields['ipa'] ?? '';
    final name = fields['name'] ?? '';
    final hint = fields['learnerHint'] ?? '';
    final explanation = fields['explanation'] ?? '';
    final reading = fields['reading'] ?? '';
    return (hint.isNotEmpty && ipa.isNotEmpty && _sameNormalized(hint, ipa)) ||
        (name.isNotEmpty &&
            explanation.isNotEmpty &&
            _sameNormalized(name, explanation)) ||
        (reading.isNotEmpty &&
            name.isNotEmpty &&
            _sameNormalized(reading, name));
  }

  bool _hasDuplicatePlaceholderFields(
    String symbol,
    Map<String, String> fields,
  ) {
    var duplicateCount = 0;
    for (final value in fields.values) {
      if (_sameNormalized(value, symbol)) {
        duplicateCount += 1;
      }
    }
    return duplicateCount >= 3;
  }

  bool _looksLikeSpanishOrthography(String value) {
    return !RegExp(r'[А-Яа-яІіЇїЄєҐґ]').hasMatch(value);
  }

  bool _containsUnexpectedEnglish(SemanticLocalizationUnit unit, String value) {
    const allowed = {
      'IPA',
      'A0',
      'no',
      'entiendo',
      'repite',
      'despacio',
      'hola',
      'adios',
      'hasta',
      'luego',
      'gracias',
      'por',
      'favor',
      'buenas',
      'noches',
      'jose',
      'javier',
      'laura',
    };
    var visibleValue = value;
    for (final span in unit.protectedSpans) {
      visibleValue = visibleValue.replaceAll(span.text, ' ');
    }
    final englishWords = RegExp(r'\b[A-Za-z]{2,}\b')
        .allMatches(visibleValue)
        .map((match) => match.group(0)!)
        .where((word) => !allowed.contains(word.toLowerCase()))
        .toList();
    if (englishWords.isEmpty) {
      return false;
    }
    return visibleValue.contains('ll and consonantal y') ||
        englishWords.length >= 3;
  }

  bool _containsRussianContamination(String value) {
    return RegExp(r'[ыэёъ]').hasMatch(value.toLowerCase()) ||
        RegExp(
          r'\b(это|что|как|привет|хорошо)\b',
          caseSensitive: false,
        ).hasMatch(value);
  }

  bool _hasSemanticFieldCategoryMismatch(
    SemanticLocalizationUnit unit,
    String value,
  ) {
    if (unit.semanticType == SemanticLocalizationType.vocabularyMeaning &&
        RegExp(r'/[^/]+/').hasMatch(value)) {
      return true;
    }
    if (unit.semanticType ==
            SemanticLocalizationType.pronunciationExplanation &&
        unit.context.fieldPath.contains('native_translation')) {
      return true;
    }
    if (unit.semanticType == SemanticLocalizationType.readingRuleTitle &&
        value.contains('/')) {
      return true;
    }
    return false;
  }

  bool _hasEntityTypeConflict(SemanticLocalizationUnit unit) {
    return (unit.semanticType == SemanticLocalizationType.countryName &&
            (unit.context.contentKind == 'city' ||
                unit.context.fieldPath.contains('city'))) ||
        (unit.semanticType == SemanticLocalizationType.cityName &&
            (unit.context.contentKind == 'country' ||
                unit.context.fieldPath.contains('country')));
  }
}

class _LeakSource {
  const _LeakSource({
    required this.field,
    required this.text,
    required this.expectedCode,
    required this.acceptedCode,
  });

  final String field;
  final String text;
  final String expectedCode;
  final String acceptedCode;
}

class _AnswerCandidate {
  const _AnswerCandidate(this.value, this.isAcceptedAnswer);

  final String value;
  final bool isAcceptedAnswer;
}
