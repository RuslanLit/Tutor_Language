class LearningSession {
  const LearningSession({
    required this.sessionId,
    required this.topicId,
    required this.startedAt,
    this.currentExerciseIndex = 0,
    this.interactionCount = 0,
    this.checkedAnswerCount = 0,
    this.finishedAt,
  });

  factory LearningSession.start({required String topicId, DateTime? now}) {
    final timestamp = now ?? DateTime.now();

    return LearningSession(
      sessionId: '${timestamp.microsecondsSinceEpoch}.$topicId',
      topicId: topicId,
      startedAt: timestamp,
    );
  }

  final String sessionId;
  final String topicId;
  final DateTime startedAt;
  final int currentExerciseIndex;
  final int interactionCount;
  final int checkedAnswerCount;
  final DateTime? finishedAt;

  LearningSession copyWith({
    int? currentExerciseIndex,
    int? interactionCount,
    int? checkedAnswerCount,
    DateTime? finishedAt,
  }) {
    return LearningSession(
      sessionId: sessionId,
      topicId: topicId,
      startedAt: startedAt,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      interactionCount: interactionCount ?? this.interactionCount,
      checkedAnswerCount: checkedAnswerCount ?? this.checkedAnswerCount,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }
}
