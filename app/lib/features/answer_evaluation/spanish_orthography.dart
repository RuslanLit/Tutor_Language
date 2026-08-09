import 'answer_evaluation_models.dart';
import 'answer_normalizer.dart';

class SpanishOrthographicAnalysis {
  const SpanishOrthographicAnalysis({
    required this.canonicalAnswer,
    required this.differences,
  });

  final String canonicalAnswer;
  final List<AnswerDifference> differences;
}

class SpanishOrthographicClassifier {
  const SpanishOrthographicClassifier({
    this.normalizer = const AnswerNormalizer(),
    this.ruleRegistry = const SpanishOrthographicRuleRegistry(),
  });

  final AnswerNormalizer normalizer;
  final SpanishOrthographicRuleRegistry ruleRegistry;

  SpanishOrthographicAnalysis? classify({
    required String learnerAnswer,
    required String canonicalAnswer,
  }) {
    final learner = normalizer.normalize(learnerAnswer).value;
    final canonical = normalizer.normalize(canonicalAnswer).value;

    if (learner.isEmpty || canonical.isEmpty) {
      return null;
    }

    final punctuationAnalysis = _stripSupportedBoundaryPunctuation(
      learner: learner,
      canonical: canonical,
    );
    if (punctuationAnalysis == null) {
      return null;
    }

    final learnerCore = punctuationAnalysis.learnerCore;
    final canonicalCore = punctuationAnalysis.canonicalCore;
    final differences = [...punctuationAnalysis.differences];

    if (learnerCore == canonicalCore) {
      return differences.isEmpty
          ? null
          : SpanishOrthographicAnalysis(
              canonicalAnswer: canonicalAnswer,
              differences: List.unmodifiable(differences),
            );
    }

    if (_baseLetters(learnerCore) != _baseLetters(canonicalCore)) {
      return null;
    }

    final diacriticDifferences = _diacriticDifferences(
      learnerCore: learnerCore,
      canonicalCore: canonicalCore,
    );
    if (diacriticDifferences == null || diacriticDifferences.isEmpty) {
      return null;
    }

    differences.addAll(diacriticDifferences);

    return SpanishOrthographicAnalysis(
      canonicalAnswer: canonicalAnswer,
      differences: List.unmodifiable(differences),
    );
  }

  _BoundaryPunctuationAnalysis? _stripSupportedBoundaryPunctuation({
    required String learner,
    required String canonical,
  }) {
    var learnerCore = learner;
    var canonicalCore = canonical;
    final differences = <AnswerDifference>[];

    final questionAnalysis = _stripPunctuationPair(
      learner: learnerCore,
      canonical: canonicalCore,
      openingMark: '¿',
      closingMark: '?',
      missingOpeningType: AnswerDifferenceType.missingOpeningQuestionMark,
      missingClosingType: AnswerDifferenceType.missingClosingQuestionMark,
      missingOpeningKey: 'spanish.question.missing_opening_mark',
      missingClosingKey: 'spanish.question.missing_closing_mark',
    );
    if (questionAnalysis == null) {
      return null;
    }
    learnerCore = questionAnalysis.learnerCore;
    canonicalCore = questionAnalysis.canonicalCore;
    differences.addAll(questionAnalysis.differences);

    final exclamationAnalysis = _stripPunctuationPair(
      learner: learnerCore,
      canonical: canonicalCore,
      openingMark: '¡',
      closingMark: '!',
      missingOpeningType: AnswerDifferenceType.missingOpeningExclamationMark,
      missingClosingType: AnswerDifferenceType.missingClosingExclamationMark,
      missingOpeningKey: 'spanish.exclamation.missing_opening_mark',
      missingClosingKey: 'spanish.exclamation.missing_closing_mark',
    );
    if (exclamationAnalysis == null) {
      return null;
    }

    return _BoundaryPunctuationAnalysis(
      learnerCore: exclamationAnalysis.learnerCore,
      canonicalCore: exclamationAnalysis.canonicalCore,
      differences: [...differences, ...exclamationAnalysis.differences],
    );
  }

  _BoundaryPunctuationAnalysis? _stripPunctuationPair({
    required String learner,
    required String canonical,
    required String openingMark,
    required String closingMark,
    required AnswerDifferenceType missingOpeningType,
    required AnswerDifferenceType missingClosingType,
    required String missingOpeningKey,
    required String missingClosingKey,
  }) {
    var learnerCore = learner;
    var canonicalCore = canonical;
    final differences = <AnswerDifference>[];

    final canonicalHasOpening = canonicalCore.startsWith(openingMark);
    final learnerHasOpening = learnerCore.startsWith(openingMark);
    if (canonicalHasOpening) {
      canonicalCore = canonicalCore.substring(openingMark.length).trimLeft();
      if (learnerHasOpening) {
        learnerCore = learnerCore.substring(openingMark.length).trimLeft();
      } else {
        differences.add(
          AnswerDifference(
            type: missingOpeningType,
            feedbackKey: missingOpeningKey,
            canonicalFragment: openingMark,
          ),
        );
      }
    } else if (learnerHasOpening) {
      return null;
    }

    final canonicalHasClosing = canonicalCore.endsWith(closingMark);
    final learnerHasClosing = learnerCore.endsWith(closingMark);
    if (canonicalHasClosing) {
      canonicalCore = canonicalCore
          .substring(0, canonicalCore.length - closingMark.length)
          .trimRight();
      if (learnerHasClosing) {
        learnerCore = learnerCore
            .substring(0, learnerCore.length - closingMark.length)
            .trimRight();
      } else {
        differences.add(
          AnswerDifference(
            type: missingClosingType,
            feedbackKey: missingClosingKey,
            canonicalFragment: closingMark,
          ),
        );
      }
    } else if (learnerHasClosing) {
      return null;
    }

    return _BoundaryPunctuationAnalysis(
      learnerCore: learnerCore,
      canonicalCore: canonicalCore,
      differences: differences,
    );
  }

  List<AnswerDifference>? _diacriticDifferences({
    required String learnerCore,
    required String canonicalCore,
  }) {
    final learnerWords = learnerCore.split(' ');
    final canonicalWords = canonicalCore.split(' ');
    if (learnerWords.length != canonicalWords.length) {
      return null;
    }

    final differences = <AnswerDifference>[];

    for (var index = 0; index < learnerWords.length; index += 1) {
      final learnerWord = learnerWords[index];
      final canonicalWord = canonicalWords[index];
      if (learnerWord == canonicalWord) {
        continue;
      }

      if (_baseLetters(learnerWord) != _baseLetters(canonicalWord)) {
        return null;
      }

      final learnerLetters = learnerWord.runes.toList(growable: false);
      final canonicalLetters = canonicalWord.runes.toList(growable: false);
      if (learnerLetters.length != canonicalLetters.length) {
        return null;
      }

      var differenceType = AnswerDifferenceType.missingDiacritic;
      for (
        var letterIndex = 0;
        letterIndex < learnerLetters.length;
        letterIndex += 1
      ) {
        final learnerLetter = String.fromCharCode(learnerLetters[letterIndex]);
        final canonicalLetter = String.fromCharCode(
          canonicalLetters[letterIndex],
        );
        if (learnerLetter == canonicalLetter) {
          continue;
        }
        if (_baseLetters(learnerLetter) != _baseLetters(canonicalLetter)) {
          return null;
        }
        if (learnerLetter != _baseLetters(canonicalLetter)) {
          differenceType = AnswerDifferenceType.incorrectDiacritic;
        }
      }

      differences.add(
        AnswerDifference(
          type: differenceType,
          feedbackKey: ruleRegistry.diacriticFeedbackKey(canonicalWord),
          learnerFragment: learnerWord,
          canonicalFragment: canonicalWord,
        ),
      );
    }

    return differences;
  }

  String _baseLetters(String value) {
    return value
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');
  }
}

class SpanishOrthographicRuleRegistry {
  const SpanishOrthographicRuleRegistry();

  String diacriticFeedbackKey(String canonicalWord) {
    return switch (canonicalWord.toLowerCase()) {
      'qué' => 'spanish.interrogative.que_requires_accent',
      'cómo' => 'spanish.interrogative.como_requires_accent',
      _ => 'spanish.missing_diacritic',
    };
  }
}

class _BoundaryPunctuationAnalysis {
  const _BoundaryPunctuationAnalysis({
    required this.learnerCore,
    required this.canonicalCore,
    required this.differences,
  });

  final String learnerCore;
  final String canonicalCore;
  final List<AnswerDifference> differences;
}
