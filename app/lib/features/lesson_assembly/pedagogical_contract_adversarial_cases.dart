import '../../core/content/pronunciation_catalog.dart';
import '../../core/content/pronunciation_models.dart';
import '../../core/content/semantic_localization.dart';
import '../../core/content/topic_content.dart';
import 'pedagogical_contract_validator.dart';

typedef PedagogicalCaseRunner =
    List<PedagogicalContractIssue> Function(PedagogicalContractValidator);

class PedagogicalAdversarialCase {
  const PedagogicalAdversarialCase({
    required this.id,
    required this.category,
    required this.expectedCodes,
    required this.runInvalid,
    required this.runValidControl,
  });

  final String id;
  final String category;
  final Set<String> expectedCodes;
  final PedagogicalCaseRunner runInvalid;
  final PedagogicalCaseRunner runValidControl;
}

List<PedagogicalAdversarialCase> pedagogicalAdversarialCases() {
  return [
    _exerciseCase(
      id: 'A1.exact-answer-in-prompt',
      category: 'Answer leakage',
      expectedCodes: const {'ANSWER_LEAK_IN_PROMPT'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.a1',
          prompt: 'Напишіть слово hola.',
          expectedAnswer: 'hola',
        ),
      ),
    ),
    _exerciseCase(
      id: 'A2.exact-answer-in-hint',
      category: 'Answer leakage',
      expectedCodes: const {'ANSWER_LEAK_IN_HINT'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.a2',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        visibleHints: const ['Починається як hola.'],
      ),
    ),
    _exerciseCase(
      id: 'A3.answer-in-visible-content',
      category: 'Answer leakage',
      expectedCodes: const {'ANSWER_LEAK_IN_VISIBLE_CONTENT'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.a3',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        visibleContent: const ['Поточна картка: hola'],
      ),
    ),
    _exerciseCase(
      id: 'A4.answer-in-visible-example',
      category: 'Answer leakage',
      expectedCodes: const {'ANSWER_LEAK_IN_VISIBLE_EXAMPLE'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.a4',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        visibleExamples: const ['hola'],
      ),
    ),
    _exerciseCase(
      id: 'A5.normalized-answer-in-prompt',
      category: 'Answer leakage',
      expectedCodes: const {'ANSWER_LEAK_IN_PROMPT'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.a5',
          prompt: 'Введіть hola',
          expectedAnswer: '¡Hola!',
        ),
      ),
    ),
    _exerciseCase(
      id: 'A6.accepted-answer-in-hint',
      category: 'Answer leakage',
      expectedCodes: const {'ACCEPTED_ANSWER_LEAK'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.a6',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'buenos días',
          acceptedAnswers: const ['hola'],
        ),
        visibleHints: const ['Починається як hola.'],
      ),
    ),
    _exerciseCase(
      id: 'B1.copy-task-as-recall',
      category: 'Copy-as-recall',
      expectedCodes: const {'COPY_TASK_MISCLASSIFIED_AS_RECALL'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.b1',
          prompt: 'Перепишіть наведений текст.',
          expectedAnswer: 'hola',
        ),
      ),
    ),
    _exerciseCase(
      id: 'B2.target-visible-from-presentation',
      category: 'Copy-as-recall',
      expectedCodes: const {
        'RECALL_TARGET_NOT_HIDDEN',
        'RUNTIME_ASSEMBLED_ANSWER_LEAK',
        'RUNTIME_HIDDEN_KNOWLEDGE_EXPOSED',
      },
      invalid: (validator) => validator.validateRuntimeAssembly(
        template: _recall(
          id: 'adversarial.b2',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        persistentVisibleContent: const ['Presentation card: hola'],
      ),
    ),
    _exerciseCase(
      id: 'B3.copyable-visible-field',
      category: 'Copy-as-recall',
      expectedCodes: const {'RECALL_ANSWER_COPYABLE'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.b3',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        visibleCopyFields: const ['Pronunciation card heading: hola'],
      ),
    ),
    ..._readingRuleCases(),
    ..._pronunciationCases(),
    ..._semanticCases(),
    ..._exerciseContractCases(),
    ..._runtimeCases(),
    ..._approvalCases(),
  ];
}

PedagogicalAdversarialCase _exerciseCase({
  required String id,
  required String category,
  required Set<String> expectedCodes,
  required PedagogicalCaseRunner invalid,
}) {
  return PedagogicalAdversarialCase(
    id: id,
    category: category,
    expectedCodes: expectedCodes,
    runInvalid: invalid,
    runValidControl: (validator) => validator.validateExerciseContract(
      template: _recall(
        id: '$id.valid',
        prompt: 'Напишіть іспанське привітання.',
        expectedAnswer: 'hola',
      ),
    ),
  );
}

List<PedagogicalAdversarialCase> _readingRuleCases() {
  PedagogicalAdversarialCase readingCase({
    required String id,
    required Set<String> expectedCodes,
    required ReadingRule rule,
    required PronunciationLocalizationEntry localization,
  }) {
    return PedagogicalAdversarialCase(
      id: id,
      category: 'ReadingRule completeness',
      expectedCodes: expectedCodes,
      runInvalid: (validator) {
        final catalog = PronunciationCatalog(
          bundle: _pronunciationBundle(
            rules: [rule],
            localizations: [localization],
          ),
        );
        return validator.validateReadingRule(
          rule,
          pronunciationCatalog: catalog,
          supportLocale: 'uk',
        );
      },
      runValidControl: (validator) {
        final rule = _readingRule(id: '$id.valid');
        final catalog = PronunciationCatalog(
          bundle: _pronunciationBundle(
            rules: [rule],
            localizations: [_validRuleLocalization(rule.id)],
          ),
        );
        return validator.validateReadingRule(
          rule,
          pronunciationCatalog: catalog,
          supportLocale: 'uk',
        );
      },
    );
  }

  return [
    readingCase(
      id: 'C1.missing-conventional-name',
      expectedCodes: const {'READING_RULE_NAME_MISSING'},
      rule: _readingRule(id: 'rule.c1'),
      localization: _validRuleLocalization('rule.c1', title: ''),
    ),
    readingCase(
      id: 'C2.symbol-repeated-as-name',
      expectedCodes: const {'READING_RULE_NAME_PLACEHOLDER'},
      rule: _readingRule(id: 'rule.c2'),
      localization: _validRuleLocalization('rule.c2', title: 'h'),
    ),
    readingCase(
      id: 'C3.missing-ipa',
      expectedCodes: const {'READING_RULE_IPA_MISSING'},
      rule: _readingRule(id: 'rule.c3', ipa: null),
      localization: _validRuleLocalization('rule.c3'),
    ),
    readingCase(
      id: 'C4.missing-localized-pronunciation-hint',
      expectedCodes: const {
        'READING_RULE_LOCALIZED_PRONUNCIATION_HINT_MISSING',
      },
      rule: _readingRule(id: 'rule.c4'),
      localization: _validRuleLocalization(
        'rule.c4',
        title: 'аче',
        learnerHint: '',
        shortExplanation: 'Літера не вимовляється.',
      ),
    ),
    readingCase(
      id: 'C5.missing-localized-explanation',
      expectedCodes: const {'READING_RULE_EXPLANATION_MISSING'},
      rule: _readingRule(id: 'rule.c5'),
      localization: _validRuleLocalization(
        'rule.c5',
        shortExplanation: '',
        explanation: '',
      ),
    ),
    readingCase(
      id: 'C6.missing-examples',
      expectedCodes: const {'READING_RULE_EXAMPLES_MISSING'},
      rule: _readingRule(id: 'rule.c6', examples: const []),
      localization: _validRuleLocalization('rule.c6'),
    ),
    readingCase(
      id: 'C7.invalid-field-substitution',
      expectedCodes: const {'READING_RULE_FIELD_SEMANTICS_INVALID'},
      rule: _readingRule(id: 'rule.c7', ipa: '/a/'),
      localization: _validRuleLocalization('rule.c7', shortExplanation: '/a/'),
    ),
    readingCase(
      id: 'C8.placeholder-duplication',
      expectedCodes: const {
        'READING_RULE_NAME_PLACEHOLDER',
        'READING_RULE_FIELD_SEMANTICS_INVALID',
        'READING_RULE_DUPLICATE_PLACEHOLDER_FIELDS',
      },
      rule: _readingRule(id: 'rule.c8', ipa: '/s/'),
      localization: _validRuleLocalization(
        'rule.c8',
        title: 'h',
        shortExplanation: 'h',
        detailedExplanation: 'h',
      ),
    ),
    readingCase(
      id: 'C9.latin-r-misidentified-as-ukrainian',
      expectedCodes: const {'READING_RULE_SCRIPT_MISIDENTIFIED'},
      rule: _readingRule(
        id: 'pronunciation.es.rule.r.v1',
        orthographicPattern: 'r',
        ipa: '/ɾ/',
      ),
      localization: _validRuleLocalization(
        'pronunciation.es.rule.r.v1',
        title: 'Одинарна r',
        learnerHint: 'Назва r — «е́ре».',
        shortExplanation: 'Українська буква r передає звук /ɾ/.',
        detailedExplanation: 'У слові pero одинарна r звучить коротко.',
      ),
    ),
    readingCase(
      id: 'C10.latin-r-misidentified-as-cyrillic',
      expectedCodes: const {
        'READING_RULE_SCRIPT_MISIDENTIFIED',
        'READING_RULE_AUTHORING_LANGUAGE_EXPOSED',
      },
      rule: _readingRule(
        id: 'pronunciation.es.rule.r.v1',
        orthographicPattern: 'r',
        ipa: '/ɾ/',
      ),
      localization: _validRuleLocalization(
        'pronunciation.es.rule.r.v1',
        title: 'Одинарна r',
        learnerHint: 'Назва r — «е́ре».',
        shortExplanation: 'Кирилична r читається як /ɾ/.',
        detailedExplanation: 'У слові pero одинарна r звучить коротко.',
      ),
    ),
    readingCase(
      id: 'C11.cyrillic-vowels-substitute-latin-vowels',
      expectedCodes: const {'READING_RULE_CYRILLIC_SUBSTITUTES_LATIN_GRAPHEME'},
      rule: _readingRule(
        id: 'pronunciation.es.rule.stable_vowels.v1',
        orthographicPattern: 'a e i o u',
        ipa: '/a e i o u/',
        phoneticOutcome: 'stable Spanish vowel sounds',
      ),
      localization: _validRuleLocalization(
        'pronunciation.es.rule.stable_vowels.v1',
        title: 'Іспанські голосні',
        learnerHint: 'Голосні a, e, i, o, u звучать стабільно.',
        shortExplanation: 'Іспанські голосні а е і о у звучать стабільно.',
        detailedExplanation: 'У слові hola голосна o звучить коротко й рівно.',
      ),
    ),
    readingCase(
      id: 'C12.mixed-script-vowel-sequence',
      expectedCodes: const {'READING_RULE_MIXED_SCRIPT_GRAPHEME'},
      rule: _readingRule(
        id: 'pronunciation.es.rule.stable_vowels.v1',
        orthographicPattern: 'a e i o u',
        ipa: '/a e i o u/',
        phoneticOutcome: 'stable Spanish vowel sounds',
      ),
      localization: _validRuleLocalization(
        'pronunciation.es.rule.stable_vowels.v1',
        title: 'Іспанські голосні',
        learnerHint: 'Голосні a, e, i, o, u звучать стабільно.',
        shortExplanation: 'Форма a е i о u змішує системи письма.',
        detailedExplanation: 'У слові hola голосна o звучить коротко й рівно.',
      ),
    ),
    readingCase(
      id: 'C13.authoring-language-exposed',
      expectedCodes: const {'READING_RULE_AUTHORING_LANGUAGE_EXPOSED'},
      rule: _readingRule(
        id: 'pronunciation.es.rule.r.v1',
        orthographicPattern: 'r',
        ipa: '/ɾ/',
      ),
      localization: _validRuleLocalization(
        'pronunciation.es.rule.r.v1',
        title: 'Одинарна латинська літера r',
        learnerHint: 'Назва r — «е́ре».',
        shortExplanation: 'Латинська форма r належить до латиниці.',
        detailedExplanation: 'У слові pero r звучить коротко.',
      ),
    ),
    readingCase(
      id: 'C14.generic-duplicate-reading-rule-explanation',
      expectedCodes: const {
        'READING_RULE_GENERIC_FALLBACK_EXPLANATION',
        'READING_RULE_DUPLICATE_EXPLANATION',
        'READING_RULE_AUTHORING_LANGUAGE_EXPOSED',
      },
      rule: _readingRule(
        id: 'pronunciation.es.rule.r.v1',
        orthographicPattern: 'r',
        ipa: '/ɾ/',
      ),
      localization: _validRuleLocalization(
        'pronunciation.es.rule.r.v1',
        title: 'Одинарна r',
        learnerHint: 'Назва r — «е́ре».',
        shortExplanation:
            'Пояснення для початківця: зверніть увагу на іспанське написання. Ключова іспанська форма: r, /ɾ/.',
        detailedExplanation:
            'Пояснення для початківця: зверніть увагу на іспанське написання. Ключова іспанська форма: r, /ɾ/.',
      ),
    ),
  ];
}

List<PedagogicalAdversarialCase> _pronunciationCases() {
  PedagogicalAdversarialCase pronunciationCase({
    required String id,
    required Set<String> expectedCodes,
    required PronunciationUnit unit,
    required PronunciationLocalizationEntry localization,
  }) {
    return PedagogicalAdversarialCase(
      id: id,
      category: 'Pronunciation integrity',
      expectedCodes: expectedCodes,
      runInvalid: (validator) => validator.validatePronunciationCompleteness(
        pronunciationCatalog: PronunciationCatalog(
          bundle: _pronunciationBundle(
            units: [unit],
            localizations: [localization],
          ),
        ),
        pronunciationUnitIds: [unit.id.value],
        supportLocale: 'uk',
      ),
      runValidControl: (validator) =>
          validator.validatePronunciationCompleteness(
            pronunciationCatalog: PronunciationCatalog(
              bundle: _pronunciationBundle(),
            ),
            pronunciationUnitIds: const ['pronunciation.valid.hola'],
            supportLocale: 'uk',
          ),
    );
  }

  return [
    pronunciationCase(
      id: 'D1.ipa-missing',
      expectedCodes: const {'PRONUNCIATION_IPA_MISSING'},
      unit: _pronunciationUnit(id: 'pron.d1', ipa: null),
      localization: _validUnitLocalization('pron.d1'),
    ),
    pronunciationCase(
      id: 'D2.localized-hint-missing',
      expectedCodes: const {'PRONUNCIATION_LOCALIZED_HINT_MISSING'},
      unit: _pronunciationUnit(id: 'pron.d2'),
      localization: _validUnitLocalization('pron.d2', hint: ''),
    ),
    pronunciationCase(
      id: 'D3.cross-locale-fallback',
      expectedCodes: const {
        'PRONUNCIATION_LOCALIZED_HINT_MISSING',
        'PRONUNCIATION_CROSS_LOCALE_FALLBACK',
      },
      unit: _pronunciationUnit(id: 'pron.d3'),
      localization: const PronunciationLocalizationEntry(
        id: 'pron.d3',
        learnerHints: {'ru': 'ола'},
        explanations: {'uk': 'Українське пояснення.'},
      ),
    ),
    pronunciationCase(
      id: 'D4.english-respelling-fallback',
      expectedCodes: const {
        'PRONUNCIATION_LOCALIZED_HINT_MISSING',
        'PRONUNCIATION_ENGLISH_RESPelling_FALLBACK_FORBIDDEN',
      },
      unit: _pronunciationUnit(
        id: 'pron.d4',
        localizedLearnerHints: const {'en': 'OH-lah'},
      ),
      localization: const PronunciationLocalizationEntry(
        id: 'pron.d4',
        learnerHints: {},
        explanations: {'uk': 'Українське пояснення.'},
      ),
    ),
    pronunciationCase(
      id: 'D5.target-orthography-localized',
      expectedCodes: const {'TARGET_ORTHOGRAPHY_LOCALIZED'},
      unit: _pronunciationUnit(id: 'pron.d5', orthography: 'привіт'),
      localization: _validUnitLocalization('pron.d5'),
    ),
    pronunciationCase(
      id: 'D6.authoring-language-exposed',
      expectedCodes: const {'PRONUNCIATION_AUTHORING_LANGUAGE_EXPOSED'},
      unit: _pronunciationUnit(id: 'pron.d6'),
      localization: _validUnitLocalization(
        'pron.d6',
        explanation:
            'Пояснення для початківця: зверніть увагу на іспанське написання. Ключова іспанська форма: hola, /ˈola/.',
      ),
    ),
  ];
}

List<PedagogicalAdversarialCase> _semanticCases() {
  PedagogicalAdversarialCase semanticCase({
    required String id,
    required String category,
    required Set<String> expectedCodes,
    required SemanticLocalizationUnit unit,
  }) {
    return PedagogicalAdversarialCase(
      id: id,
      category: category,
      expectedCodes: expectedCodes,
      runInvalid: (validator) =>
          validator.validateSemanticApproval(_semanticBundle([unit])),
      runValidControl: (validator) => validator.validateSemanticApproval(
        _semanticBundle([_semanticUnit(id: '$id.valid', value: 'Привіт')]),
      ),
    );
  }

  return [
    semanticCase(
      id: 'E1.english-in-ukrainian',
      category: 'Locale purity',
      expectedCodes: const {'UNEXPECTED_ENGLISH_IN_UKRAINIAN_CONTENT'},
      unit: _semanticUnit(
        id: 'semantic.e1',
        value: 'll and consonantal y пояснюються тут.',
      ),
    ),
    semanticCase(
      id: 'E2.russian-in-ukrainian',
      category: 'Locale purity',
      expectedCodes: const {'UNEXPECTED_RUSSIAN_IN_UKRAINIAN_CONTENT'},
      unit: _semanticUnit(id: 'semantic.e2', value: 'Это привітання.'),
    ),
    semanticCase(
      id: 'E3.empty-production-fallback',
      category: 'Locale purity',
      expectedCodes: const {
        'PRODUCTION_LOCALIZATION_FALLBACK_USED',
        'INVALID_UNIT_PRODUCTION_APPROVED',
      },
      unit: _semanticUnit(id: 'semantic.e3', value: ''),
    ),
    semanticCase(
      id: 'F1.entity-type-conflict',
      category: 'Semantic correctness',
      expectedCodes: const {'SEMANTIC_ENTITY_TYPE_CONFLICT'},
      unit: _semanticUnit(
        id: 'semantic.f1',
        value: 'Мексика',
        semanticType: SemanticLocalizationType.countryName,
        contentKind: 'city',
        fieldPath: 'city_name',
      ),
    ),
    semanticCase(
      id: 'F2.field-category-mismatch',
      category: 'Semantic correctness',
      expectedCodes: const {'SEMANTIC_FIELD_CATEGORY_MISMATCH'},
      unit: _semanticUnit(
        id: 'semantic.f2',
        value: '/ˈola/',
        semanticType: SemanticLocalizationType.vocabularyMeaning,
      ),
    ),
  ];
}

List<PedagogicalAdversarialCase> _exerciseContractCases() {
  return [
    _exerciseCase(
      id: 'G1.hidden-knowledge-undeclared',
      category: 'Exercise contract',
      expectedCodes: const {'RECALL_HIDDEN_KNOWLEDGE_UNDECLARED'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.g1',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        hiddenKnowledgeDeclared: false,
      ),
    ),
    _exerciseCase(
      id: 'G2.assessment-target-missing',
      category: 'Exercise contract',
      expectedCodes: const {'ASSESSMENT_TARGET_MISSING'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.g2',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        assessmentTargetDeclared: false,
      ),
    ),
    _exerciseCase(
      id: 'G3.expected-response-missing',
      category: 'Exercise contract',
      expectedCodes: const {'EXPECTED_RESPONSE_MISSING'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.g3',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: null,
        ),
      ),
    ),
    _exerciseCase(
      id: 'G4.classification-contract-violation',
      category: 'Exercise contract',
      expectedCodes: const {'EXERCISE_CLASSIFICATION_CONTRACT_VIOLATION'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.g4',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        declaredExerciseClass: ExercisePedagogicalClass.presentation,
      ),
    ),
    _exerciseCase(
      id: 'G5.feedback-missing',
      category: 'Exercise contract',
      expectedCodes: const {'ASSESSMENT_FEEDBACK_MISSING'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.g5',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        feedbackRequired: true,
        feedbackPresent: false,
      ),
    ),
    _exerciseCase(
      id: 'G6.remediation-missing',
      category: 'Exercise contract',
      expectedCodes: const {'REMEDIATION_PATH_MISSING'},
      invalid: (validator) => validator.validateExerciseContract(
        template: _recall(
          id: 'adversarial.g6',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        remediationRequired: true,
        remediationPresent: false,
      ),
    ),
  ];
}

List<PedagogicalAdversarialCase> _runtimeCases() {
  return [
    _exerciseCase(
      id: 'H1.assembled-answer-leak',
      category: 'Runtime assembly',
      expectedCodes: const {
        'RECALL_TARGET_NOT_HIDDEN',
        'RUNTIME_ASSEMBLED_ANSWER_LEAK',
        'RUNTIME_HIDDEN_KNOWLEDGE_EXPOSED',
      },
      invalid: (validator) => validator.validateRuntimeAssembly(
        template: _recall(
          id: 'adversarial.h1',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        persistentVisibleContent: const ['Shared card: hola'],
      ),
    ),
    _exerciseCase(
      id: 'H2.presentation-recall-collision',
      category: 'Runtime assembly',
      expectedCodes: const {'RUNTIME_PRESENTATION_RECALL_COLLISION'},
      invalid: (validator) => validator.validateRuntimeAssembly(
        template: _recall(
          id: 'adversarial.h2',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        presentationRecallCollision: true,
      ),
    ),
    _exerciseCase(
      id: 'H3.hidden-knowledge-exposed',
      category: 'Runtime assembly',
      expectedCodes: const {
        'RECALL_TARGET_NOT_HIDDEN',
        'RUNTIME_ASSEMBLED_ANSWER_LEAK',
        'RUNTIME_HIDDEN_KNOWLEDGE_EXPOSED',
      },
      invalid: (validator) => validator.validateRuntimeAssembly(
        template: _recall(
          id: 'adversarial.h3',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        persistentVisibleContent: const ['Header: hola'],
      ),
    ),
    _exerciseCase(
      id: 'H4.duplicate-unit-exposes-answer',
      category: 'Runtime assembly',
      expectedCodes: const {'RUNTIME_DUPLICATE_UNIT_EXPOSES_ANSWER'},
      invalid: (validator) => validator.validateRuntimeAssembly(
        template: _recall(
          id: 'adversarial.h4',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        duplicateUnitExposesAnswer: true,
      ),
    ),
    _exerciseCase(
      id: 'H5.pronunciation-data-lost',
      category: 'Runtime assembly',
      expectedCodes: const {'RUNTIME_PRONUNCIATION_DATA_LOST'},
      invalid: (validator) => validator.validateRuntimeAssembly(
        template: _recall(
          id: 'adversarial.h5',
          prompt: 'Напишіть іспанське привітання.',
          expectedAnswer: 'hola',
        ),
        pronunciationDataLost: true,
      ),
    ),
  ];
}

List<PedagogicalAdversarialCase> _approvalCases() {
  return [
    PedagogicalAdversarialCase(
      id: 'I1.generator-production-approval',
      category: 'Approval integrity',
      expectedCodes: const {'AUTOMATED_PRODUCTION_APPROVAL_FORBIDDEN'},
      runInvalid: (validator) => validator.validateSemanticApproval(
        _semanticBundle([
          _semanticUnit(
            id: 'semantic.i1',
            value: 'Привіт',
            notes: 'generated by scaffold',
          ),
        ]),
      ),
      runValidControl: (validator) => validator.validateSemanticApproval(
        _semanticBundle([
          _semanticUnit(id: 'semantic.i1.valid', value: 'Привіт'),
        ]),
      ),
    ),
    PedagogicalAdversarialCase(
      id: 'I2.invalid-unit-production-approved',
      category: 'Approval integrity',
      expectedCodes: const {
        'PRODUCTION_LOCALIZATION_FALLBACK_USED',
        'INVALID_UNIT_PRODUCTION_APPROVED',
      },
      runInvalid: (validator) => validator.validateSemanticApproval(
        _semanticBundle([_semanticUnit(id: 'semantic.i2', value: '')]),
      ),
      runValidControl: (validator) => validator.validateSemanticApproval(
        _semanticBundle([
          _semanticUnit(id: 'semantic.i2.valid', value: 'Привіт'),
        ]),
      ),
    ),
    PedagogicalAdversarialCase(
      id: 'I3.invalid-state-transition',
      category: 'Approval integrity',
      expectedCodes: const {'APPROVAL_STATE_TRANSITION_INVALID'},
      runInvalid: (validator) => validator.validateApprovalTransition(
        objectId: 'semantic.i3',
        from: SemanticReviewStatus.draft,
        to: SemanticReviewStatus.productionApproved,
      ),
      runValidControl: (validator) => validator.validateApprovalTransition(
        objectId: 'semantic.i3.valid',
        from: SemanticReviewStatus.editoriallyReviewed,
        to: SemanticReviewStatus.pedagogicallyVerified,
      ),
    ),
    PedagogicalAdversarialCase(
      id: 'I4.non-approved-production-manifest-unit',
      category: 'Approval integrity',
      expectedCodes: const {'NON_APPROVED_UNIT_IN_PRODUCTION_MANIFEST'},
      runInvalid: (validator) => validator.validateProductionManifest(
        units: [
          _semanticUnit(id: 'semantic.i4', value: 'Привіт', production: false),
        ],
        supportLocale: 'uk',
      ),
      runValidControl: (validator) => validator.validateProductionManifest(
        units: [_semanticUnit(id: 'semantic.i4.valid', value: 'Привіт')],
        supportLocale: 'uk',
      ),
    ),
  ];
}

ExerciseTemplate _recall({
  required String id,
  required String prompt,
  required String? expectedAnswer,
  List<String> acceptedAnswers = const [],
}) {
  return ExerciseTemplate(
    id: id,
    exerciseType: 'text_entry',
    supportedGoalTypes: const ['recall'],
    requiredObjectTypes: const ['vocabulary'],
    promptTemplate: prompt,
    expectedAnswer: expectedAnswer,
    acceptedAnswers: acceptedAnswers,
  );
}

ReadingRule _readingRule({
  required String id,
  String? ipa = '/∅/',
  String orthographicPattern = 'h',
  String? phoneticOutcome,
  List<String> examples = const ['pronunciation.valid.hola'],
}) {
  return ReadingRule(
    id: id,
    schemaVersion: 1,
    knowledgeDomain: 'language',
    ruleKind: 'reading',
    targetLanguage: 'es',
    orthographicPattern: orthographicPattern,
    pronunciationVariety: PronunciationVariety('es-general'),
    ipa: ipa == null ? null : IpaTranscription(ipa),
    phoneticOutcome: phoneticOutcome ?? ipa,
    examplePronunciationUnitIds: examples,
  );
}

PronunciationUnit _pronunciationUnit({
  required String id,
  String orthography = 'hola',
  String? ipa = '/ˈola/',
  Map<String, String> localizedLearnerHints = const {},
}) {
  return PronunciationUnit(
    id: PronunciationUnitId(id),
    schemaVersion: 1,
    targetLanguage: 'es',
    targetOrthography: orthography,
    pronunciationVariety: PronunciationVariety('es-general'),
    ipa: ipa == null ? null : IpaTranscription(ipa),
    localizedLearnerHints: localizedLearnerHints,
    relatedContentIds: const ['vocab.hola'],
    readingRuleIds: const ['rule.valid'],
  );
}

PronunciationBundle _pronunciationBundle({
  List<ReadingRule>? rules,
  List<PronunciationUnit>? units,
  List<PronunciationLocalizationEntry>? localizations,
}) {
  return PronunciationBundle(
    schemaVersion: 1,
    targetLanguage: 'es',
    pronunciationVariety: PronunciationVariety('es-general'),
    rules: rules ?? [_readingRule(id: 'rule.valid')],
    units: units ?? [_pronunciationUnit(id: 'pronunciation.valid.hola')],
    localizations:
        localizations ??
        [
          _validUnitLocalization('pronunciation.valid.hola'),
          _validRuleLocalization('rule.valid'),
        ],
  );
}

PronunciationLocalizationEntry _validRuleLocalization(
  String id, {
  String title = 'а́че',
  String learnerHint = 'а́че',
  String shortExplanation = 'Назва h — а́че; у цьому слові вона німа.',
  String explanation = 'h не вимовляється як окремий звук.',
  String detailedExplanation =
      'Іспанська h пишеться, але у слові hola не дає окремого звука.',
}) {
  return PronunciationLocalizationEntry(
    id: id,
    learnerHints: learnerHint.isEmpty ? const {} : {'uk': learnerHint},
    explanations: explanation.isEmpty ? const {} : {'uk': explanation},
    titles: title.isEmpty ? const {} : {'uk': title},
    shortExplanations: shortExplanation.isEmpty
        ? const {}
        : {'uk': shortExplanation},
    detailedExplanations: detailedExplanation.isEmpty
        ? const {}
        : {'uk': detailedExplanation},
    commonMistakes: const {'uk': 'Не вимовляйте h як українське г.'},
  );
}

PronunciationLocalizationEntry _validUnitLocalization(
  String id, {
  String hint = 'о́ла',
  String explanation = 'Вимовляйте hola з німою h.',
}) {
  return PronunciationLocalizationEntry(
    id: id,
    learnerHints: hint.isEmpty ? const {} : {'uk': hint},
    explanations: explanation.isEmpty ? const {} : {'uk': explanation},
  );
}

SemanticLocalizationBundle _semanticBundle(
  List<SemanticLocalizationUnit> units,
) {
  return SemanticLocalizationBundle(
    schemaVersion: 1,
    targetLanguage: 'es',
    sourceSupportLocale: 'en',
    supportLocales: const ['uk'],
    units: units,
  );
}

SemanticLocalizationUnit _semanticUnit({
  required String id,
  required String value,
  SemanticLocalizationType semanticType =
      SemanticLocalizationType.exercisePrompt,
  String contentKind = 'exercise_template',
  String fieldPath = 'prompt_template',
  bool production = true,
  String? notes,
}) {
  return SemanticLocalizationUnit(
    id: id,
    semanticType: semanticType,
    ownership: SemanticTextOwnership.supportLanguageOwned,
    sourceText: 'hello',
    values: {'uk': value},
    review: {
      'uk': production
          ? SemanticReviewStatus.productionApproved
          : SemanticReviewStatus.editoriallyReviewed,
    },
    context: SemanticLocalizationContext(
      courseId: 'es.a0',
      moduleId: 'es.a0.m01',
      lessonId: 'es.a0.m01.l001',
      contentObjectId: id,
      fieldPath: fieldPath,
      contentKind: contentKind,
      pedagogicalRole: 'adversarial',
      targetLanguage: 'es',
      supportLocale: 'uk',
    ),
    notes: notes,
  );
}
