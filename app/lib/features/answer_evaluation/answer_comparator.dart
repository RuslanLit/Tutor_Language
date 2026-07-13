import 'answer_evaluation_models.dart';
import 'answer_normalizer.dart';

class AnswerComparator {
  const AnswerComparator({this.normalizer = const AnswerNormalizer()});

  final AnswerNormalizer normalizer;

  AnswerComparison compare({
    required String learnerAnswer,
    required ExpectedAnswerSet expectedAnswer,
    bool allowMeaningSupport = true,
  }) {
    if (learnerAnswer == expectedAnswer.canonicalAnswer) {
      return const AnswerComparison(matchType: AnswerMatchType.exactCanonical);
    }

    final normalizedLearner = normalizer.normalize(learnerAnswer).value;
    final normalizedCanonical = normalizer
        .normalize(expectedAnswer.canonicalAnswer)
        .value;

    if (normalizedLearner == normalizedCanonical) {
      return const AnswerComparison(
        matchType: AnswerMatchType.normalizedCanonical,
      );
    }

    for (final acceptedAnswer in expectedAnswer.acceptedAnswers) {
      if (normalizedLearner == normalizer.normalize(acceptedAnswer).value) {
        return const AnswerComparison(
          matchType: AnswerMatchType.acceptedAlternative,
        );
      }
    }

    if (!allowMeaningSupport) {
      return const AnswerComparison(matchType: AnswerMatchType.none);
    }

    final supportNormalizedLearner = normalizer
        .normalizeMeaningSupport(learnerAnswer)
        .value;
    final supportNormalizedCanonical = normalizer
        .normalizeMeaningSupport(expectedAnswer.canonicalAnswer)
        .value;

    if (supportNormalizedLearner == supportNormalizedCanonical) {
      return const AnswerComparison(
        matchType: AnswerMatchType.normalizedCanonical,
      );
    }

    for (final acceptedAnswer in expectedAnswer.acceptedAnswers) {
      if (supportNormalizedLearner ==
          normalizer.normalizeMeaningSupport(acceptedAnswer).value) {
        return const AnswerComparison(
          matchType: AnswerMatchType.acceptedAlternative,
        );
      }
    }

    return const AnswerComparison(matchType: AnswerMatchType.none);
  }
}
