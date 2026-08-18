import '../../core/content/topic_content.dart';
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
    List<AcceptedWithFeedbackAnswer> acceptedWithFeedbackAnswers = const [],
    List<AuthoredMisconception> authoredMisconceptions = const [],
    bool allowMeaningSupport = true,
    ({int minimum, int maximum})? multilineLineRange,
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
      allowMeaningSupport: allowMeaningSupport,
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
            allowMeaningSupport: allowMeaningSupport,
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

    final acceptedWithFeedback = _acceptedWithFeedbackFor(
      learnerAnswer: learnerAnswer,
      acceptedWithFeedbackAnswers: acceptedWithFeedbackAnswers,
    );
    if (acceptedWithFeedback != null) {
      final feedbackCanonicalAnswer =
          acceptedWithFeedback.canonicalAnswer ?? canonicalAnswer;
      return AnswerEvaluationResult(
        status: AnswerEvaluationStatus.acceptedWithFeedback,
        feedback: AnswerFeedback(
          key: acceptedWithFeedback.feedbackKey,
          canonicalAnswer: feedbackCanonicalAnswer,
        ),
        matchType: AnswerMatchType.acceptedAlternativeWithFeedback,
        normalizedLearnerAnswer: normalizedLearnerAnswer,
        normalizedCanonicalAnswer: normalizer
            .normalize(feedbackCanonicalAnswer)
            .value,
      );
    }

    final multilineMatch = multilineLineRange == null
        ? null
        : _evaluateAuthoredMultiline(
            learnerAnswer: learnerAnswer,
            canonicalAnswer: canonicalAnswer,
            acceptedAnswers: acceptedAnswers,
            lineRange: multilineLineRange,
          );
    if (multilineMatch != null) {
      return multilineMatch;
    }

    final misconception = _authoredMisconceptionFor(
      learnerAnswer: learnerAnswer,
      authoredMisconceptions: authoredMisconceptions,
    );
    if (misconception != null) {
      return AnswerEvaluationResult(
        status: AnswerEvaluationStatus.incorrect,
        feedback: AnswerFeedback(
          key: misconception.feedbackKey,
          canonicalAnswer: misconception.canonicalAnswer ?? canonicalAnswer,
          misconceptionId: misconception.id,
          explanationReference: misconception.explanationReferenceId,
        ),
        matchType: AnswerMatchType.authoredMisconception,
        normalizedLearnerAnswer: normalizedLearnerAnswer,
        normalizedCanonicalAnswer: normalizedCanonicalAnswer,
      );
    }

    return AnswerEvaluationResult(
      status: AnswerEvaluationStatus.incorrect,
      feedback: AnswerFeedback(
        key: 'answer.incorrect',
        canonicalAnswer: canonicalAnswer,
        structure: _structureDiagnostic(
          learnerAnswer: learnerAnswer,
          canonicalAnswer: canonicalAnswer,
          acceptedAnswers: acceptedAnswers,
          lineRange: multilineLineRange,
        ),
      ),
      matchType: comparison.matchType,
      normalizedLearnerAnswer: normalizedLearnerAnswer,
      normalizedCanonicalAnswer: normalizedCanonicalAnswer,
    );
  }

  AnswerStructureDiagnostic? _structureDiagnostic({
    required String learnerAnswer,
    required String canonicalAnswer,
    required List<String> acceptedAnswers,
    ({int minimum, int maximum})? lineRange,
  }) {
    final submittedLines = _meaningfulLines(learnerAnswer);
    if (submittedLines.isEmpty) {
      return null;
    }

    final expectedLines = _diagnosticExpectedLines(
      learnerLines: submittedLines,
      canonicalAnswer: canonicalAnswer,
      acceptedAnswers: acceptedAnswers,
      lineRange: lineRange,
    );
    if (expectedLines.length < 2) return null;

    final comparableCount = submittedLines.length < expectedLines.length
        ? submittedLines.length
        : expectedLines.length;
    final correct = <int>[];
    final incorrect = <int>[];
    for (var index = 0; index < comparableCount; index++) {
      final expected = ExpectedAnswerSet(canonicalAnswer: expectedLines[index]);
      final comparison = comparator.compare(
        learnerAnswer: submittedLines[index],
        expectedAnswer: expected,
        allowMeaningSupport: false,
      );
      final orthographic = spanishOrthography.classify(
        learnerAnswer: submittedLines[index],
        canonicalAnswer: expectedLines[index],
      );
      if (comparison.isMatch || orthographic != null) {
        correct.add(index + 1);
      } else {
        incorrect.add(index + 1);
      }
    }

    return AnswerStructureDiagnostic(
      submittedLineCount: submittedLines.length,
      expectedLineCount: expectedLines.length,
      minimumExpectedLineCount: lineRange?.minimum,
      maximumExpectedLineCount: lineRange?.maximum,
      correctLineNumbers: List.unmodifiable(correct),
      incorrectLineNumbers: List.unmodifiable(incorrect),
    );
  }

  List<String> _diagnosticExpectedLines({
    required List<String> learnerLines,
    required String canonicalAnswer,
    required List<String> acceptedAnswers,
    ({int minimum, int maximum})? lineRange,
  }) {
    final candidates = _authoredMultilineCandidates(
      canonicalAnswer: canonicalAnswer,
      acceptedAnswers: acceptedAnswers,
    );
    final expectedLength =
        lineRange != null &&
            learnerLines.length >= lineRange.minimum &&
            learnerLines.length <= lineRange.maximum
        ? learnerLines.length
        : _meaningfulLines(canonicalAnswer).length;
    _MultilineCandidate? best;
    List<String>? bestLines;
    for (final candidate in candidates) {
      if (candidate.length != expectedLength) continue;
      final qualities = [
        for (var index = 0; index < learnerLines.length; index++)
          _lineQuality(learnerLines[index], candidate[index]),
      ];
      final current = _MultilineCandidate(
        matches: qualities.where((q) => q != _LineQuality.incorrect).length,
        qualities: qualities,
      );
      if (best == null || current.matches > best.matches) {
        best = current;
        bestLines = candidate;
      }
    }
    return bestLines ?? _meaningfulLines(canonicalAnswer);
  }

  List<String> _meaningfulLines(String value) => value
      .split(RegExp(r'\r?\n'))
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList(growable: false);

  AnswerEvaluationResult? _evaluateAuthoredMultiline({
    required String learnerAnswer,
    required String canonicalAnswer,
    required List<String> acceptedAnswers,
    required ({int minimum, int maximum}) lineRange,
  }) {
    final learnerLines = _meaningfulLines(learnerAnswer);
    if (learnerLines.length < lineRange.minimum ||
        learnerLines.length > lineRange.maximum ||
        learnerLines.length < 2) {
      return null;
    }

    final candidates = _authoredMultilineCandidates(
      canonicalAnswer: canonicalAnswer,
      acceptedAnswers: acceptedAnswers,
    );
    _MultilineCandidate? best;
    for (final candidate in candidates) {
      if (candidate.length != learnerLines.length) continue;
      final qualities = <_LineQuality>[];
      var matches = 0;
      for (var index = 0; index < learnerLines.length; index++) {
        final quality = _lineQuality(learnerLines[index], candidate[index]);
        qualities.add(quality);
        if (quality != _LineQuality.incorrect) matches++;
      }
      final current = _MultilineCandidate(
        matches: matches,
        qualities: qualities,
      );
      if (best == null || current.matches > best.matches) best = current;
    }

    if (best == null || best.matches != learnerLines.length) return null;
    final hasFeedback = best.qualities.contains(_LineQuality.feedback);
    return AnswerEvaluationResult(
      status: hasFeedback
          ? AnswerEvaluationStatus.acceptedWithFeedback
          : AnswerEvaluationStatus.correct,
      feedback: AnswerFeedback(
        key: hasFeedback ? 'answer.accepted_with_feedback' : 'answer.correct',
        canonicalAnswer: canonicalAnswer,
      ),
      matchType: hasFeedback
          ? AnswerMatchType.orthographicEquivalent
          : AnswerMatchType.structuredProduction,
    );
  }

  List<List<String>> _authoredMultilineCandidates({
    required String canonicalAnswer,
    required List<String> acceptedAnswers,
  }) {
    final authoredLines = <String>{};
    for (final answer in [canonicalAnswer, ...acceptedAnswers]) {
      final lines = _meaningfulLines(answer);
      authoredLines.addAll(lines);
      for (final line in lines) {
        authoredLines.addAll(_splitAuthoredLine(line));
      }
    }

    final candidates = <List<String>>[
      _meaningfulLines(canonicalAnswer),
      ...acceptedAnswers.map(_meaningfulLines),
    ];
    final canonicalLines = _meaningfulLines(canonicalAnswer);
    for (var index = 0; index < canonicalLines.length; index++) {
      final split = _splitAuthoredLine(canonicalLines[index]);
      if (split.length > 1) {
        candidates.add([
          ...canonicalLines.sublist(0, index),
          ...split,
          ...canonicalLines.sublist(index + 1),
        ]);
      }
    }
    for (var index = 0; index <= canonicalLines.length; index++) {
      for (final inserted in authoredLines) {
        candidates.add([
          ...canonicalLines.sublist(0, index),
          inserted,
          ...canonicalLines.sublist(index),
        ]);
      }
    }
    return candidates;
  }

  List<String> _splitAuthoredLine(String line) => line
      .split(RegExp(r'(?<=\.)\s+'))
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList(growable: false);

  _LineQuality _lineQuality(String learner, String expected) {
    final comparison = comparator.compare(
      learnerAnswer: learner,
      expectedAnswer: ExpectedAnswerSet(canonicalAnswer: expected),
      allowMeaningSupport: false,
    );
    if (comparison.isMatch) return _LineQuality.exact;
    if (spanishOrthography.classify(
          learnerAnswer: learner,
          canonicalAnswer: expected,
        ) !=
        null) {
      return _LineQuality.feedback;
    }
    return _LineQuality.incorrect;
  }

  String _matchedAnswerFor({
    required String learnerAnswer,
    required String canonicalAnswer,
    required List<String> acceptedAnswers,
    required bool allowMeaningSupport,
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

    if (!allowMeaningSupport) {
      return canonicalAnswer;
    }

    final supportNormalizedLearner = normalizer
        .normalizeMeaningSupport(learnerAnswer)
        .value;
    if (supportNormalizedLearner ==
        normalizer.normalizeMeaningSupport(canonicalAnswer).value) {
      return canonicalAnswer;
    }

    for (final acceptedAnswer in acceptedAnswers) {
      if (supportNormalizedLearner ==
          normalizer.normalizeMeaningSupport(acceptedAnswer).value) {
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

  AcceptedWithFeedbackAnswer? _acceptedWithFeedbackFor({
    required String learnerAnswer,
    required List<AcceptedWithFeedbackAnswer> acceptedWithFeedbackAnswers,
  }) {
    final normalizedLearner = normalizer.normalize(learnerAnswer).value;
    final supportNormalizedLearner = normalizer
        .normalizeMeaningSupport(learnerAnswer)
        .value;

    for (final acceptedAnswer in acceptedWithFeedbackAnswers) {
      if (learnerAnswer == acceptedAnswer.answer ||
          normalizedLearner ==
              normalizer.normalize(acceptedAnswer.answer).value ||
          supportNormalizedLearner ==
              normalizer.normalizeMeaningSupport(acceptedAnswer.answer).value) {
        return acceptedAnswer;
      }
    }

    return null;
  }

  AuthoredMisconception? _authoredMisconceptionFor({
    required String learnerAnswer,
    required List<AuthoredMisconception> authoredMisconceptions,
  }) {
    final normalizedLearner = normalizer.normalize(learnerAnswer).value;
    final supportNormalizedLearner = normalizer
        .normalizeMeaningSupport(learnerAnswer)
        .value;

    for (final misconception in authoredMisconceptions) {
      for (final matchingAnswer in misconception.matchingAnswers) {
        if (learnerAnswer == matchingAnswer ||
            normalizedLearner == normalizer.normalize(matchingAnswer).value ||
            supportNormalizedLearner ==
                normalizer.normalizeMeaningSupport(matchingAnswer).value) {
          return misconception;
        }
      }
    }

    return null;
  }
}

enum _LineQuality { exact, feedback, incorrect }

class _MultilineCandidate {
  const _MultilineCandidate({required this.matches, required this.qualities});

  final int matches;
  final List<_LineQuality> qualities;
}
