import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_models.dart';
import 'package:tutor_language/core/content/semantic_localization.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/lesson_assembly/pedagogical_contract_validator.dart';

void main() {
  const validator = PedagogicalContractValidator();

  test('independent recall rejects prompt answer leakage', () {
    final template = _textEntry(
      prompt: 'Type the Spanish word "hola".',
      expectedAnswer: 'hola',
    );

    final issues = validator.validateExerciseTemplate(template);

    expect(_codes(issues), contains('ANSWER_LEAK_IN_PROMPT'));
    expect(
      issues
          .firstWhere((issue) => issue.code == 'ANSWER_LEAK_IN_PROMPT')
          .severity,
      PedagogicalIssueSeverity.blocker,
    );
  });

  test('independent recall rejects copy-the-text answer options', () {
    final template = ExerciseTemplate(
      id: 'template.copy.text.v1',
      exerciseType: 'text_entry',
      supportedGoalTypes: const ['recall'],
      requiredObjectTypes: const ['vocabulary'],
      promptTemplate: 'Type the Spanish word for hello.',
      expectedAnswer: 'hola',
      answerOptions: const [ExerciseTemplateOption(id: 'hola', label: 'hola')],
    );

    final issues = validator.validateExerciseTemplate(template);

    expect(_codes(issues), contains('RECALL_ANSWER_COPYABLE'));
  });

  test('recognition may display answer options without prompt leakage', () {
    const template = ExerciseTemplate(
      id: 'template.recognition.v1',
      exerciseType: 'multiple_choice',
      supportedGoalTypes: ['recognition'],
      requiredObjectTypes: ['vocabulary'],
      promptTemplate: 'Choose the Spanish greeting.',
      correctOptionId: 'hola',
      answerOptions: [
        ExerciseTemplateOption(id: 'hola', label: 'hola'),
        ExerciseTemplateOption(id: 'adios', label: 'adios'),
      ],
    );

    final issues = validator.validateExerciseTemplate(template);

    expect(_codes(issues), isNot(contains('ANSWER_LEAK_IN_PROMPT')));
  });

  test('ReadingRule contract rejects pedagogically incomplete rules', () {
    final catalog = PronunciationCatalog(bundle: _pronunciationBundle());
    final rule = catalog.readingRuleById('pronunciation.es.rule.h.v1')!;

    final issues = validator.validateReadingRule(
      rule,
      pronunciationCatalog: catalog,
      supportLocale: 'uk',
    );

    expect(_codes(issues), contains('READING_RULE_IPA_MISSING'));
    expect(_codes(issues), contains('READING_RULE_EXPLANATION_MISSING'));
  });

  test(
    'pronunciation completeness requires localized hint and explanation',
    () {
      final catalog = PronunciationCatalog(bundle: _pronunciationBundle());

      final issues = validator.validatePronunciationCompleteness(
        pronunciationCatalog: catalog,
        pronunciationUnitIds: const ['pronunciation.es.word.hola.v1'],
        supportLocale: 'uk',
      );

      expect(_codes(issues), contains('PRONUNCIATION_LOCALIZED_HINT_MISSING'));
      expect(
        _codes(issues),
        contains('PRONUNCIATION_LOCALIZED_EXPLANATION_MISSING'),
      );
    },
  );

  test('legacy semantic approved state cannot bypass pedagogy', () {
    final bundle = SemanticLocalizationBundle(
      schemaVersion: 1,
      targetLanguage: 'es',
      sourceSupportLocale: 'en',
      supportLocales: const ['uk'],
      units: [
        SemanticLocalizationUnit(
          id: 'semantic.test',
          semanticType: SemanticLocalizationType.exercisePrompt,
          ownership: SemanticTextOwnership.supportLanguageOwned,
          sourceText: 'Type hello.',
          values: const {'uk': 'Надрукуйте привіт.'},
          review: const {'uk': SemanticReviewStatus.approved},
          context: const SemanticLocalizationContext(
            courseId: 'es.a0',
            contentObjectId: 'template.test',
            fieldPath: 'prompt_template',
            contentKind: 'exercise_template',
            pedagogicalRole: 'exercise prompt',
            targetLanguage: 'es',
            supportLocale: 'uk',
          ),
        ),
      ],
    );

    final issues = validator.validateSemanticApproval(bundle);

    expect(_codes(issues), contains('LEGACY_APPROVAL_STATE_FORBIDDEN'));
  });
}

ExerciseTemplate _textEntry({
  required String prompt,
  required String expectedAnswer,
}) {
  return ExerciseTemplate(
    id: 'template.independent.recall.v1',
    exerciseType: 'text_entry',
    supportedGoalTypes: const ['recall'],
    requiredObjectTypes: const ['vocabulary'],
    promptTemplate: prompt,
    expectedAnswer: expectedAnswer,
  );
}

PronunciationBundle _pronunciationBundle() {
  return PronunciationBundle(
    schemaVersion: 1,
    targetLanguage: 'es',
    pronunciationVariety: PronunciationVariety('es-general'),
    rules: [
      ReadingRule(
        id: 'pronunciation.es.rule.h.v1',
        schemaVersion: 1,
        knowledgeDomain: 'language',
        ruleKind: 'reading',
        targetLanguage: 'es',
        orthographicPattern: 'h',
        pronunciationVariety: PronunciationVariety('es-general'),
        examplePronunciationUnitIds: const ['pronunciation.es.word.hola.v1'],
      ),
    ],
    units: [
      PronunciationUnit(
        id: PronunciationUnitId('pronunciation.es.word.hola.v1'),
        schemaVersion: 1,
        targetLanguage: 'es',
        targetOrthography: 'hola',
        pronunciationVariety: PronunciationVariety('es-general'),
        ipa: IpaTranscription('/ˈola/'),
        localizedLearnerHints: const {'en': 'OH-lah'},
        relatedContentIds: const ['vocab.test.hola'],
        readingRuleIds: const ['pronunciation.es.rule.h.v1'],
      ),
    ],
    localizations: const [],
  );
}

Set<String> _codes(List<PedagogicalContractIssue> issues) {
  return issues.map((issue) => issue.code).toSet();
}
