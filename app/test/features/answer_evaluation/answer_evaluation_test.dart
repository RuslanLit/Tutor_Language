import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/features/answer_evaluation/answer_evaluation.dart';

void main() {
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

    test('does not accept unsupported punctuation changes', () {
      final result = const AnswerEvaluator().evaluateTypedAnswer(
        learnerAnswer: 'hola?',
        canonicalAnswer: 'hola',
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

        final presented = const AnswerFeedbackPresenter().present(result);

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
  });
}
