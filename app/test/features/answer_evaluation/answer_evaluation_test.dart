import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/answer_evaluation/answer_evaluation.dart';
import 'package:tutor_language/l10n/generated/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('AnswerNormalizer', () {
    test('trims, collapses whitespace, and compares case-insensitively', () {
      final normalized = const AnswerNormalizer().normalize('  HoLa   Ana  ');

      expect(normalized.raw, '  HoLa   Ana  ');
      expect(normalized.value, 'hola ana');
    });

    test('treats non-breaking spaces as ordinary spaces', () {
      final normalized = const AnswerNormalizer().normalize(
        'hola\u00A0\u00A0Ana',
      );

      expect(normalized.value, 'hola ana');
    });

    test('keeps accents and punctuation available for classification', () {
      final normalized = const AnswerNormalizer().normalize(' ¿Qué tal? ');

      expect(normalized.value, '¿qué tal?');
    });

    test('support normalization expands controlled English contractions', () {
      final normalizer = const AnswerNormalizer();

      expect(
        normalizer.normalizeMeaningSupport("I don't understand").value,
        'i do not understand',
      );
      expect(
        normalizer.normalizeMeaningSupport("I'm from Ukraine.").value,
        'i am from ukraine',
      );
      expect(
        normalizer.normalizeMeaningSupport("He's my friend").value,
        'he is my friend',
      );
    });

    test('support normalization ignores weak punctuation only', () {
      final normalizer = const AnswerNormalizer();

      expect(
        normalizer.normalizeMeaningSupport('repite, por favor').value,
        'repite por favor',
      );
      expect(
        normalizer.normalizeMeaningSupport('repite por favor.').value,
        'repite por favor',
      );
      expect(normalizer.normalizeMeaningSupport('que tal?').value, 'que tal?');
    });
  });

  group('AnswerComparator', () {
    test('detects exact canonical matches', () {
      final comparison = const AnswerComparator().compare(
        learnerAnswer: 'hola',
        expectedAnswer: const ExpectedAnswerSet(canonicalAnswer: 'hola'),
      );

      expect(comparison.matchType, AnswerMatchType.exactCanonical);
      expect(comparison.isMatch, isTrue);
    });

    test('detects normalized canonical matches', () {
      final comparison = const AnswerComparator().compare(
        learnerAnswer: '  HOLA  ',
        expectedAnswer: const ExpectedAnswerSet(canonicalAnswer: 'hola'),
      );

      expect(comparison.matchType, AnswerMatchType.normalizedCanonical);
      expect(comparison.isMatch, isTrue);
    });

    test('ignores ordinary capitalization in name sentences', () {
      final comparison = const AnswerComparator().compare(
        learnerAnswer: 'me llamo marta.',
        expectedAnswer: const ExpectedAnswerSet(
          canonicalAnswer: 'Me llamo Marta.',
        ),
      );

      expect(comparison.matchType, AnswerMatchType.normalizedCanonical);
      expect(comparison.isMatch, isTrue);
    });

    test('detects accepted alternatives', () {
      final comparison = const AnswerComparator().compare(
        learnerAnswer: 'buen día',
        expectedAnswer: const ExpectedAnswerSet(
          canonicalAnswer: 'buenos días',
          acceptedAnswers: ['buen día'],
        ),
      );

      expect(comparison.matchType, AnswerMatchType.acceptedAlternative);
      expect(comparison.isMatch, isTrue);
    });

    test('detects controlled contraction equivalents', () {
      final comparison = const AnswerComparator().compare(
        learnerAnswer: "I don't understand",
        expectedAnswer: const ExpectedAnswerSet(
          canonicalAnswer: 'I do not understand',
        ),
      );

      expect(comparison.matchType, AnswerMatchType.normalizedCanonical);
      expect(comparison.isMatch, isTrue);
    });

    test('detects weak punctuation equivalents without erasing questions', () {
      final commaComparison = const AnswerComparator().compare(
        learnerAnswer: 'repite por favor',
        expectedAnswer: const ExpectedAnswerSet(
          canonicalAnswer: 'repite, por favor',
        ),
      );
      final questionComparison = const AnswerComparator().compare(
        learnerAnswer: 'Qué tal',
        expectedAnswer: const ExpectedAnswerSet(canonicalAnswer: 'Qué tal?'),
      );

      expect(commaComparison.isMatch, isTrue);
      expect(questionComparison.isMatch, isFalse);
    });

    test('can disable support equivalence for exact-form tasks', () {
      final comparison = const AnswerComparator().compare(
        learnerAnswer: "I don't understand",
        expectedAnswer: const ExpectedAnswerSet(
          canonicalAnswer: 'I do not understand',
        ),
        allowMeaningSupport: false,
      );

      expect(comparison.isMatch, isFalse);
    });
  });

  group('AnswerEvaluator', () {
    test('case A returns correct for exact canonical answer', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: '¿Qué tal?',
        canonicalAnswer: '¿Qué tal?',
      );

      expect(result.status, AnswerEvaluationStatus.correct);
      expect(result.feedback.key, 'answer.correct');
      expect(result.matchType, AnswerMatchType.exactCanonical);
    });

    test('case B returns correct for case-only difference', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'hola',
        canonicalAnswer: 'Hola',
      );

      expect(result.status, AnswerEvaluationStatus.correct);
      expect(result.matchType, AnswerMatchType.normalizedCanonical);
      expect(result.isAccepted, isTrue);
    });

    test('case C accepts missing question-word accent with feedback', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'que',
        canonicalAnswer: 'qué',
      );

      expect(result.status, AnswerEvaluationStatus.acceptedWithFeedback);
      expect(result.matchType, AnswerMatchType.orthographicEquivalent);
      expect(result.feedback.canonicalAnswer, 'qué');
      expect(result.feedback.differences, hasLength(1));
      expect(
        result.feedback.differences.single.type,
        AnswerDifferenceType.missingDiacritic,
      );
      expect(
        result.feedback.differences.single.feedbackKey,
        'spanish.interrogative.que_requires_accent',
      );
    });

    test('case D accepts missing opening question mark with feedback', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'Qué tal?',
        canonicalAnswer: '¿Qué tal?',
      );

      expect(result.status, AnswerEvaluationStatus.acceptedWithFeedback);
      expect(result.feedback.differences.map((difference) => difference.type), [
        AnswerDifferenceType.missingOpeningQuestionMark,
      ]);
    });

    test('case E accepts missing accent and opening mark with feedback', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'que tal?',
        canonicalAnswer: '¿Qué tal?',
      );

      expect(result.status, AnswerEvaluationStatus.acceptedWithFeedback);
      expect(result.feedback.differences.map((difference) => difference.type), [
        AnswerDifferenceType.missingOpeningQuestionMark,
        AnswerDifferenceType.missingDiacritic,
      ]);
    });

    test('case F accepts multiple missing accents and opening mark', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'Como estas?',
        canonicalAnswer: '¿Cómo estás?',
      );

      expect(result.status, AnswerEvaluationStatus.acceptedWithFeedback);
      expect(
        result.feedback.differences.map(
          (difference) => difference.canonicalFragment,
        ),
        ['¿', 'cómo', 'estás'],
      );
    });

    test('case G accepts accent missing in fixed word', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'adios',
        canonicalAnswer: 'adiós',
      );

      expect(result.status, AnswerEvaluationStatus.acceptedWithFeedback);
      expect(result.feedback.differences.single.canonicalFragment, 'adiós');
      expect(
        result.feedback.differences.single.feedbackKey,
        'spanish.missing_diacritic',
      );
    });

    test('case H keeps wrong word incorrect', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'Hasta luego',
        canonicalAnswer: '¿Qué tal?',
      );

      expect(result.status, AnswerEvaluationStatus.incorrect);
      expect(result.feedback.key, 'answer.incorrect');
    });

    test('case I keeps missing word incorrect', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'por',
        canonicalAnswer: 'por favor',
      );

      expect(result.status, AnswerEvaluationStatus.incorrect);
    });

    test('case J keeps extra word incorrect', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'por favor gracias',
        canonicalAnswer: 'por favor',
      );

      expect(result.status, AnswerEvaluationStatus.incorrect);
    });

    test('case K keeps wrong word order incorrect', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'Ana llamo me',
        canonicalAnswer: 'Me llamo Ana',
      );

      expect(result.status, AnswerEvaluationStatus.incorrect);
    });

    test('case L accepts alternatives before orthographic feedback', () {
      final exactAlternative = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'Qué pasa?',
        canonicalAnswer: '¿Qué tal?',
        acceptedAnswers: ['Qué pasa?'],
      );

      final orthographicAlternative = const AnswerEvaluator()
          .evaluateTypedAnswer(
            learnerAnswer: 'Que pasa?',
            canonicalAnswer: '¿Qué tal?',
            acceptedAnswers: ['¿Qué pasa?'],
          );

      expect(exactAlternative.status, AnswerEvaluationStatus.correct);
      expect(exactAlternative.matchType, AnswerMatchType.acceptedAlternative);
      expect(
        orthographicAlternative.status,
        AnswerEvaluationStatus.acceptedWithFeedback,
      );
      expect(orthographicAlternative.feedback.canonicalAnswer, '¿Qué pasa?');
    });

    test(
      'canonical exact answer takes precedence over accepted alternatives',
      () {
        final result = const AnswerEvaluator().evaluateTypedAnswer(
          learnerAnswer: '¿Qué tal?',
          canonicalAnswer: '¿Qué tal?',
          acceptedAnswers: ['que tal'],
        );

        expect(result.status, AnswerEvaluationStatus.correct);
        expect(result.matchType, AnswerMatchType.exactCanonical);
      },
    );

    test(
      'authored preferred-order alternative is accepted with correction',
      () {
        final result = const AnswerEvaluator().evaluateTypedAnswer(
          learnerAnswer: 'Me llamo Marta. Hola.',
          canonicalAnswer: 'Hola. Me llamo Marta.',
          acceptedWithFeedbackAnswers: const [
            AcceptedWithFeedbackAnswer(
              answer: 'Me llamo Marta. Hola.',
              feedbackKey: 'answer.preferred_order',
              canonicalAnswer: 'Hola. Me llamo Marta.',
            ),
          ],
        );

        expect(result.status, AnswerEvaluationStatus.acceptedWithFeedback);
        expect(result.isAccepted, isTrue);
        expect(
          result.matchType,
          AnswerMatchType.acceptedAlternativeWithFeedback,
        );
        expect(result.feedback.key, 'answer.preferred_order');
        expect(result.feedback.canonicalAnswer, 'Hola. Me llamo Marta.');
      },
    );

    test('preferred-order alternatives remain explicitly authored', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'Ana llamo me. Hola.',
        canonicalAnswer: 'Hola. Me llamo Ana.',
        acceptedWithFeedbackAnswers: const [
          AcceptedWithFeedbackAnswer(
            answer: 'Me llamo Ana. Hola.',
            feedbackKey: 'answer.preferred_order',
            canonicalAnswer: 'Hola. Me llamo Ana.',
          ),
        ],
      );

      expect(result.status, AnswerEvaluationStatus.incorrect);
      expect(result.matchType, AnswerMatchType.none);
    });

    test('exact authored misconception is incorrect with explanation', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'Soy Ana',
        canonicalAnswer: 'Me llamo Ana',
        authoredMisconceptions: [_nameMisconception],
      );

      expect(result.status, AnswerEvaluationStatus.incorrect);
      expect(result.isAccepted, isFalse);
      expect(result.matchType, AnswerMatchType.authoredMisconception);
      expect(result.feedback.key, 'spanish.name_pattern.use_me_llamo');
      expect(
        result.feedback.misconceptionId,
        'misconception.es.a0.unit1.name_pattern.soy_ana.v1',
      );
      expect(result.feedback.canonicalAnswer, 'Me llamo Ana');
      expect(
        result.feedback.explanationReference,
        'grammar.es.a0.unit1.name_pattern.v1',
      );
    });

    test(
      'question expected statement provided gets task-mismatch feedback',
      () {
        final result = const AnswerEvaluator().evaluateTypedAnswer(
          learnerAnswer: 'Soy de Perú',
          canonicalAnswer: '¿De dónde eres?',
          authoredMisconceptions: const [
            AuthoredMisconception(
              id: 'misconception.response.question_expected_statement.v1',
              matchingAnswers: ['Soy de Perú'],
              feedbackKey: 'response.question_expected_statement_provided',
              canonicalAnswer: '¿De dónde eres?',
            ),
          ],
        );

        expect(result.status, AnswerEvaluationStatus.incorrect);
        expect(result.matchType, AnswerMatchType.authoredMisconception);
        expect(
          result.feedback.key,
          'response.question_expected_statement_provided',
        );
      },
    );

    test('answer expected question provided gets task-mismatch feedback', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: '¿Cómo estás?',
        canonicalAnswer: 'Bien, gracias',
        authoredMisconceptions: const [
          AuthoredMisconception(
            id: 'misconception.response.answer_expected_question.v1',
            matchingAnswers: ['¿Cómo estás?'],
            feedbackKey: 'response.answer_expected_question',
            canonicalAnswer: 'Bien, gracias',
          ),
        ],
      );

      expect(result.status, AnswerEvaluationStatus.incorrect);
      expect(result.feedback.key, 'response.answer_expected_question');
    });

    test(
      'statement expected question provided gets task-mismatch feedback',
      () {
        final result = const AnswerEvaluator().evaluateTypedAnswer(
          learnerAnswer: '¿De dónde eres?',
          canonicalAnswer: 'Soy de Colombia',
          authoredMisconceptions: const [
            AuthoredMisconception(
              id: 'misconception.response.statement_expected_question.v1',
              matchingAnswers: ['¿De dónde eres?'],
              feedbackKey: 'response.statement_expected_question_provided',
              canonicalAnswer: 'Soy de Colombia',
            ),
          ],
        );

        expect(result.status, AnswerEvaluationStatus.incorrect);
        expect(
          result.feedback.key,
          'response.statement_expected_question_provided',
        );
      },
    );

    test('normalized authored misconception matches conservatively', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: '  yo SOY ana  ',
        canonicalAnswer: 'Me llamo Ana',
        authoredMisconceptions: [_nameMisconception],
      );

      expect(result.status, AnswerEvaluationStatus.incorrect);
      expect(result.matchType, AnswerMatchType.authoredMisconception);
    });

    test('unrelated wrong answer remains generic incorrect', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'Hasta luego',
        canonicalAnswer: 'Me llamo Ana',
        authoredMisconceptions: [_nameMisconception],
      );

      expect(result.status, AnswerEvaluationStatus.incorrect);
      expect(result.matchType, AnswerMatchType.none);
      expect(result.feedback.key, 'answer.incorrect');
      expect(result.feedback.misconceptionId, isNull);
    });

    test('orthographic feedback takes precedence over misconceptions', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'que',
        canonicalAnswer: 'qué',
        authoredMisconceptions: [
          const AuthoredMisconception(
            id: 'misconception.unused.v1',
            matchingAnswers: ['que'],
            feedbackKey: 'unused.feedback',
          ),
        ],
      );

      expect(result.status, AnswerEvaluationStatus.acceptedWithFeedback);
      expect(result.matchType, AnswerMatchType.orthographicEquivalent);
    });

    test('authored misconceptions are exercise-specific inputs', () {
      final genericResult = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'Soy Ana',
        canonicalAnswer: 'Me llamo Ana',
      );
      final scopedResult = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'Soy Ana',
        canonicalAnswer: 'Me llamo Ana',
        authoredMisconceptions: [_nameMisconception],
      );

      expect(genericResult.feedback.key, 'answer.incorrect');
      expect(scopedResult.feedback.key, 'spanish.name_pattern.use_me_llamo');
    });

    test('does not accept unsupported punctuation changes', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'hola?',
        canonicalAnswer: 'hola',
      );

      expect(result.status, AnswerEvaluationStatus.incorrect);
    });

    test('accepts weak punctuation difference in short phrase', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'repite por favor',
        canonicalAnswer: 'repite, por favor',
      );

      expect(result.status, AnswerEvaluationStatus.correct);
      expect(result.isAccepted, isTrue);
    });

    test('can require explicit form when authored as exact', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: "I don't understand",
        canonicalAnswer: 'I do not understand',
        allowMeaningSupport: false,
      );

      expect(result.status, AnswerEvaluationStatus.incorrect);
    });

    test('returns unsupported when no canonical answer exists', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'hola',
        canonicalAnswer: null,
      );

      expect(result.status, AnswerEvaluationStatus.unsupported);
      expect(result.feedback.key, 'answer.unsupported');
    });

    test(
      'defines accepted-with-feedback as an architectural result category',
      () {
        expect(
          AnswerEvaluationStatus.values,
          contains(AnswerEvaluationStatus.acceptedWithFeedback),
        );
      },
    );
  });

  group('AnswerFeedbackPresenter', () {
    test(
      'renders accepted-with-feedback label, canonical answer, and corrections',
      () {
        final result = const AnswerEvaluator().evaluateTypedAnswer(
          learnerAnswer: 'que tal?',
          canonicalAnswer: '¿Qué tal?',
        );

        final presented = const AnswerFeedbackPresenter().present(l10n, result);

        expect(presented.statusLabel, 'Accepted with correction');
        expect(presented.canonicalAnswer, '¿Qué tal?');
        expect(
          presented.corrections,
          contains('Spanish questions begin with "¿".'),
        );
        expect(
          presented.corrections,
          contains('"qué" requires an accent in this question.'),
        );
      },
    );

    test('renders authored misconception explanation', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'Soy Ana',
        canonicalAnswer: 'Me llamo Ana',
        authoredMisconceptions: [_nameMisconception],
      );

      final presented = const AnswerFeedbackPresenter().present(l10n, result);

      expect(presented.statusLabel, 'Not correct yet');
      expect(presented.canonicalAnswer, 'Me llamo Ana');
      expect(
        presented.corrections,
        contains('For this introduction pattern, use "me llamo".'),
      );
    });

    test('renders preferred-order correction', () {
      final presented = const AnswerFeedbackPresenter().present(
        l10n,
        const AnswerEvaluationResult(
          status: AnswerEvaluationStatus.acceptedWithFeedback,
          feedback: AnswerFeedback(
            key: 'answer.preferred_order',
            canonicalAnswer: 'Hola. Me llamo Marta.',
          ),
          matchType: AnswerMatchType.acceptedAlternativeWithFeedback,
        ),
      );

      expect(presented.statusLabel, 'Accepted with correction');
      expect(presented.corrections, [
        'A more natural order is: Hola. Me llamo Marta.',
      ]);
    });

    test('renders progressive task-mismatch hints', () {
      const result = AnswerEvaluationResult(
        status: AnswerEvaluationStatus.incorrect,
        feedback: AnswerFeedback(
          key: 'response.question_expected_statement_provided',
          canonicalAnswer: '¿De dónde eres?',
        ),
        matchType: AnswerMatchType.authoredMisconception,
      );

      final first = const AnswerFeedbackPresenter().present(
        l10n,
        result,
        attemptCount: 1,
      );
      final third = const AnswerFeedbackPresenter().present(
        l10n,
        result,
        attemptCount: 3,
      );

      expect(
        first.corrections,
        contains(
          'This exercise asks for a question.\nYou wrote an answer.\nTry writing the Spanish question instead.',
        ),
      );
      expect(third.corrections, contains('Questions begin with: ¿...'));
      expect(third.corrections, contains('Starts with: ¿De'));
    });
  });
}

const _nameMisconception = AuthoredMisconception(
  id: 'misconception.es.a0.unit1.name_pattern.soy_ana.v1',
  matchingAnswers: ['Soy Ana', 'Yo soy Ana'],
  feedbackKey: 'spanish.name_pattern.use_me_llamo',
  canonicalAnswer: 'Me llamo Ana',
  explanationReferenceId: 'grammar.es.a0.unit1.name_pattern.v1',
);
