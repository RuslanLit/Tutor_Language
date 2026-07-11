import 'answer_comparator.dart';
import 'answer_evaluation_models.dart';
import 'answer_normalizer.dart';
import 'spanish_orthography.dart';

class AnswerEvaluator {
  const AnswerEvaluator({
    this.normalizer = const AnswerNormalizer(),
    this.comparator = const AnswerComparator(),
    this.spanishOrthography = const SpanishOrthographicClassifier(),
  });

  final AnswerNormalizer normalizer;
  final AnswerComparator comparator;
  final SpanishOrthographicClassifier spanishOrthography;

  AnswerEvaluationResult evaluateTypedAnswer({
    required String learnerAnswer,
    required String? canonicalAnswer,
    List<String> acceptedAnswers = const [],
  }) {
    if (canonicalAnswer == null || canonicalAnswer.trim().isEmpty) {
      return const AnswerEvaluationResult(
        status: AnswerEvaluationStatus.unsupported,
        feedback: AnswerFeedback(key: 'answer.unsupported'),
        matchType: AnswerMatchType.none,
      );
    }

    final expectedAnswer = ExpectedAnswerSet(
      canonicalAnswer: canonicalAnswer,
      acceptedAnswers: acceptedAnswers,
    );
    final comparison = comparator.compare(
      learnerAnswer: learnerAnswer,
      expectedAnswer: expectedAnswer,
    );
    final normalizedLearnerAnswer = normalizer.normalize(learnerAnswer).value;
    final normalizedCanonicalAnswer = normalizer
        .normalize(canonicalAnswer)
        .value;

    if (comparison.isMatch) {
      return AnswerEvaluationResult(
        status: AnswerEvaluationStatus.correct,
        feedback: AnswerFeedback(
          key: 'answer.correct',
          canonicalAnswer: _matchedAnswerFor(
            learnerAnswer: learnerAnswer,
            canonicalAnswer: canonicalAnswer,
            acceptedAnswers: acceptedAnswers,
          ),
        ),
        matchType: comparison.matchType,
        normalizedLearnerAnswer: normalizedLearnerAnswer,
        normalizedCanonicalAnswer: normalizedCanonicalAnswer,
      );
    }

    final orthographicAnalysis = _orthographicAnalysisFor(
      learnerAnswer: learnerAnswer,
      canonicalAnswer: canonicalAnswer,
      acceptedAnswers: acceptedAnswers,
    );
    if (orthographicAnalysis != null) {
      return AnswerEvaluationResult(
        status: AnswerEvaluationStatus.acceptedWithFeedback,
        feedback: AnswerFeedback(
          key: 'answer.accepted_with_feedback',
          canonicalAnswer: orthographicAnalysis.canonicalAnswer,
          differences: orthographicAnalysis.differences,
        ),
        matchType: AnswerMatchType.orthographicEquivalent,
        normalizedLearnerAnswer: normalizedLearnerAnswer,
        normalizedCanonicalAnswer: normalizer
            .normalize(orthographicAnalysis.canonicalAnswer)
            .value,
      );
    }

    return AnswerEvaluationResult(
      status: AnswerEvaluationStatus.incorrect,
      feedback: AnswerFeedback(
        key: 'answer.incorrect',
        canonicalAnswer: canonicalAnswer,
      ),
      matchType: comparison.matchType,
      normalizedLearnerAnswer: normalizedLearnerAnswer,
      normalizedCanonicalAnswer: normalizedCanonicalAnswer,
    );
  }

  String _matchedAnswerFor({
    required String learnerAnswer,
    required String canonicalAnswer,
    required List<String> acceptedAnswers,
  }) {
    final normalizedLearner = normalizer.normalize(learnerAnswer).value;
    if (normalizedLearner == normalizer.normalize(canonicalAnswer).value) {
      return canonicalAnswer;
    }

    for (final acceptedAnswer in acceptedAnswers) {
      if (normalizedLearner == normalizer.normalize(acceptedAnswer).value) {
        return acceptedAnswer;
      }
    }

    return canonicalAnswer;
  }

  SpanishOrthographicAnalysis? _orthographicAnalysisFor({
    required String learnerAnswer,
    required String canonicalAnswer,
    required List<String> acceptedAnswers,
  }) {
    final canonicalAnalysis = spanishOrthography.classify(
      learnerAnswer: learnerAnswer,
      canonicalAnswer: canonicalAnswer,
    );
    if (canonicalAnalysis != null) {
      return canonicalAnalysis;
    }

    for (final acceptedAnswer in acceptedAnswers) {
      final acceptedAnalysis = spanishOrthography.classify(
        learnerAnswer: learnerAnswer,
        canonicalAnswer: acceptedAnswer,
      );
      if (acceptedAnalysis != null) {
        return acceptedAnalysis;
      }
    }

    return null;
  }
}
