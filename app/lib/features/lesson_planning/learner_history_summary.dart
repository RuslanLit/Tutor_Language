import 'dart:convert';

import '../../core/learner/learner_progress.dart';

class LearnerHistorySummary {
  const LearnerHistorySummary({
    this.completedLessonIds = const {},
    this.currentLessonId,
    this.incompleteLessonIds = const {},
    this.recentCheckedAnswersCount = 0,
    this.recentCorrectAnswersCount = 0,
    this.lastAttemptedLessonId,
  });

  factory LearnerHistorySummary.fromProgressEvents(
    Iterable<ProgressEvent> events,
  ) {
    final completedLessonIds = <String>{};
    final attemptedLessonIds = <String>{};
    var recentCheckedAnswersCount = 0;
    var recentCorrectAnswersCount = 0;

    final orderedEvents = events.toList(growable: false)
      ..sort((left, right) => left.createdAt.compareTo(right.createdAt));

    for (final event in orderedEvents) {
      attemptedLessonIds.add(event.topicId);

      if (event.eventType == ProgressEventType.topicCompleted) {
        completedLessonIds.add(event.topicId);
      }

      if (event.eventType == ProgressEventType.answerChecked) {
        recentCheckedAnswersCount += 1;
        if (_metadataIndicatesCorrect(event.metadataJson)) {
          recentCorrectAnswersCount += 1;
        }
      }
    }

    final lastAttemptedLessonId = orderedEvents.isEmpty
        ? null
        : orderedEvents.last.topicId;

    return LearnerHistorySummary(
      completedLessonIds: Set.unmodifiable(completedLessonIds),
      incompleteLessonIds: Set.unmodifiable(
        attemptedLessonIds.difference(completedLessonIds),
      ),
      recentCheckedAnswersCount: recentCheckedAnswersCount,
      recentCorrectAnswersCount: recentCorrectAnswersCount,
      lastAttemptedLessonId: lastAttemptedLessonId,
    );
  }

  final Set<String> completedLessonIds;
  final String? currentLessonId;
  final Set<String> incompleteLessonIds;
  final int recentCheckedAnswersCount;
  final int recentCorrectAnswersCount;
  final String? lastAttemptedLessonId;

  double? get recentAccuracy {
    if (recentCheckedAnswersCount == 0) {
      return null;
    }

    return recentCorrectAnswersCount / recentCheckedAnswersCount;
  }

  bool get hasHistory {
    return completedLessonIds.isNotEmpty ||
        currentLessonId != null ||
        incompleteLessonIds.isNotEmpty ||
        recentCheckedAnswersCount > 0 ||
        lastAttemptedLessonId != null;
  }

  static bool _metadataIndicatesCorrect(String? metadataJson) {
    if (metadataJson == null || metadataJson.trim().isEmpty) {
      return false;
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(metadataJson);
    } on FormatException {
      return false;
    }

    if (decoded is! Map) {
      return false;
    }

    final status = decoded['answerCheckStatus'] ?? decoded['status'];
    return status == 'correct';
  }
}
