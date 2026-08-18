import '../../core/content/topic_content.dart';
import 'answer_evaluation_models.dart';
import 'answer_normalizer.dart';

/// Deterministic, curriculum-bounded evaluator for explicitly authored
/// communicative production contracts.
class StructuredProductionEvaluator {
  const StructuredProductionEvaluator({
    this.normalizer = const AnswerNormalizer(),
  });

  final AnswerNormalizer normalizer;

  AnswerEvaluationResult evaluate({
    required String learnerAnswer,
    required String canonicalAnswer,
    required ProductionContract contract,
  }) {
    if (contract.mode != 'ordered_functions' || contract.functions.isEmpty) {
      return _unsupported(canonicalAnswer);
    }

    final learnerTokens = _tokens(learnerAnswer);
    if (learnerTokens.isEmpty) {
      return _incorrect(canonicalAnswer);
    }

    final match = _matchFunctions(
      functions: contract.functions,
      learnerTokens: learnerTokens,
      functionIndex: 0,
      tokenIndex: 0,
    );
    if (match == null || match.tokenIndex != learnerTokens.length) {
      return _incorrect(
        canonicalAnswer,
        structure: _structureDiagnostic(
          learnerAnswer: learnerAnswer,
          canonicalAnswer: canonicalAnswer,
        ),
      );
    }

    final learnerTokensKey = learnerTokens.join(' ');
    final canonicalTokens = _tokens(canonicalAnswer);
    final normalizedLearner = normalizer.normalize(learnerAnswer).value;
    final normalizedCanonical = normalizer.normalize(canonicalAnswer).value;
    final surfaceFeedback =
        learnerTokensKey == canonicalTokens.join(' ') &&
        normalizedLearner != normalizedCanonical;
    final feedback = match.needsFeedback || surfaceFeedback;
    return AnswerEvaluationResult(
      status: feedback
          ? AnswerEvaluationStatus.acceptedWithFeedback
          : AnswerEvaluationStatus.correct,
      feedback: AnswerFeedback(
        key: feedback ? 'answer.accepted_with_feedback' : 'answer.correct',
        canonicalAnswer: canonicalAnswer,
      ),
      matchType: feedback
          ? AnswerMatchType.structuredProductionWithFeedback
          : AnswerMatchType.structuredProduction,
      normalizedLearnerAnswer: normalizedLearner,
      normalizedCanonicalAnswer: normalizedCanonical,
    );
  }

  _ProductionMatch? _matchFunctions({
    required List<ProductionFunction> functions,
    required List<String> learnerTokens,
    required int functionIndex,
    required int tokenIndex,
  }) {
    if (functionIndex == functions.length) {
      return tokenIndex == learnerTokens.length
          ? _ProductionMatch(tokenIndex: tokenIndex)
          : null;
    }

    final function = functions[functionIndex];
    final realizations = [
      ...function.acceptedRealizations.map(
        (value) => _Realization(value: value, feedback: false),
      ),
      ...function.acceptedWithFeedbackRealizations.map(
        (value) => _Realization(value: value, feedback: true),
      ),
    ];

    for (final realization in realizations) {
      final tokens = _tokens(realization.value);
      if (tokens.isEmpty || tokenIndex + tokens.length > learnerTokens.length) {
        continue;
      }
      final submitted = learnerTokens.sublist(
        tokenIndex,
        tokenIndex + tokens.length,
      );
      final quality = _quality(submitted, tokens);
      if (quality == null) {
        continue;
      }
      final remainder = _matchFunctions(
        functions: functions,
        learnerTokens: learnerTokens,
        functionIndex: functionIndex + 1,
        tokenIndex: tokenIndex + tokens.length,
      );
      if (remainder != null) {
        return _ProductionMatch(
          tokenIndex: remainder.tokenIndex,
          needsFeedback:
              remainder.needsFeedback ||
              realization.feedback ||
              quality == _MatchQuality.feedback,
        );
      }
    }

    if (!function.required) {
      return _matchFunctions(
        functions: functions,
        learnerTokens: learnerTokens,
        functionIndex: functionIndex + 1,
        tokenIndex: tokenIndex,
      );
    }
    return null;
  }

  _MatchQuality? _quality(List<String> submitted, List<String> expected) {
    if (submitted.length != expected.length) return null;
    if (submitted.join(' ') == expected.join(' ')) {
      return _MatchQuality.exact;
    }
    if (_stripDiacritics(submitted).join(' ') ==
        _stripDiacritics(expected).join(' ')) {
      return _MatchQuality.feedback;
    }
    return null;
  }

  List<String> _tokens(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[.!?¿¡,;:…]+'), ' ')
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .toList(growable: false);
  }

  List<String> _stripDiacritics(List<String> tokens) {
    return tokens
        .map(
          (token) => token
              .replaceAll('á', 'a')
              .replaceAll('é', 'e')
              .replaceAll('í', 'i')
              .replaceAll('ó', 'o')
              .replaceAll('ú', 'u'),
        )
        .toList(growable: false);
  }

  AnswerStructureDiagnostic? _structureDiagnostic({
    required String learnerAnswer,
    required String canonicalAnswer,
  }) {
    final expectedLines = _meaningfulLines(canonicalAnswer);
    final submittedLines = _meaningfulLines(learnerAnswer);
    if (expectedLines.length < 2 || submittedLines.isEmpty) {
      return null;
    }

    final comparableCount = submittedLines.length < expectedLines.length
        ? submittedLines.length
        : expectedLines.length;
    final correct = <int>[];
    final incorrect = <int>[];
    for (var index = 0; index < comparableCount; index++) {
      final submitted = _tokens(submittedLines[index]);
      final expected = _tokens(expectedLines[index]);
      if (_quality(submitted, expected) != null) {
        correct.add(index + 1);
      } else {
        incorrect.add(index + 1);
      }
    }

    return AnswerStructureDiagnostic(
      submittedLineCount: submittedLines.length,
      expectedLineCount: expectedLines.length,
      correctLineNumbers: List.unmodifiable(correct),
      incorrectLineNumbers: List.unmodifiable(incorrect),
    );
  }

  List<String> _meaningfulLines(String value) => value
      .split(RegExp(r'\r?\n'))
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList(growable: false);

  AnswerEvaluationResult _incorrect(
    String canonicalAnswer, {
    AnswerStructureDiagnostic? structure,
  }) => AnswerEvaluationResult(
    status: AnswerEvaluationStatus.incorrect,
    feedback: AnswerFeedback(
      key: 'answer.incorrect',
      canonicalAnswer: canonicalAnswer,
      structure: structure,
    ),
    matchType: AnswerMatchType.none,
  );

  AnswerEvaluationResult _unsupported(String canonicalAnswer) =>
      AnswerEvaluationResult(
        status: AnswerEvaluationStatus.unsupported,
        feedback: AnswerFeedback(
          key: 'answer.unsupported',
          canonicalAnswer: canonicalAnswer,
        ),
        matchType: AnswerMatchType.none,
      );
}

enum _MatchQuality { exact, feedback }

class _Realization {
  const _Realization({required this.value, required this.feedback});

  final String value;
  final bool feedback;
}

class _ProductionMatch {
  const _ProductionMatch({
    required this.tokenIndex,
    this.needsFeedback = false,
  });

  final int tokenIndex;
  final bool needsFeedback;
}
