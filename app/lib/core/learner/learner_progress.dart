import 'lesson_attempt.dart';

enum ProgressEventType {
  topicViewed,
  exerciseAnswered,
  answerChecked,
  topicCompleted,
  lessonCompleted,
  lessonResumePosition,
}

class LessonResumeCursor {
  const LessonResumeCursor({
    required this.lessonId,
    required this.courseId,
    required this.attemptId,
    required this.attemptPurpose,
    required this.stepId,
    required this.stepIndex,
    this.furthestReachedStepIndex,
    required this.startedAt,
    required this.savedAt,
  });

  factory LessonResumeCursor.fromJson(Map<String, Object?> json) {
    final lessonId = json['lessonId'];
    final courseId = json['courseId'];
    final attemptId = json['attemptId'];
    final attemptPurpose = json['attemptPurpose'];
    final stepId = json['stepId'];
    final stepIndex = json['stepIndex'];
    final furthestReachedStepIndex = json['furthestReachedStepIndex'];
    final startedAt = json['startedAt'];
    final savedAt = json['savedAt'];
    if (lessonId is! String ||
        courseId is! String ||
        attemptId is! String ||
        attemptPurpose is! String ||
        stepId is! String ||
        stepIndex is! int ||
        startedAt is! String ||
        savedAt is! String ||
        stepIndex < 0) {
      throw const FormatException('Invalid lesson resume cursor.');
    }

    return LessonResumeCursor(
      lessonId: lessonId,
      courseId: courseId,
      attemptId: attemptId,
      attemptPurpose: LessonAttemptPurpose.fromCode(attemptPurpose),
      stepId: stepId,
      stepIndex: stepIndex,
      furthestReachedStepIndex:
          furthestReachedStepIndex is int && furthestReachedStepIndex >= 0
          ? furthestReachedStepIndex
          : null,
      startedAt: DateTime.parse(startedAt).toUtc(),
      savedAt: DateTime.parse(savedAt).toUtc(),
    );
  }

  final String lessonId;
  final String courseId;
  final String attemptId;
  final LessonAttemptPurpose attemptPurpose;
  final String stepId;
  final int stepIndex;
  // Optional keeps cursors written before frontier tracking fully readable.
  final int? furthestReachedStepIndex;
  int get effectiveFurthestReachedStepIndex =>
      furthestReachedStepIndex ?? stepIndex;
  final DateTime startedAt;
  final DateTime savedAt;

  Map<String, Object?> toJson() => {
    'lessonId': lessonId,
    'courseId': courseId,
    'attemptId': attemptId,
    'attemptPurpose': attemptPurpose.code,
    'stepId': stepId,
    'stepIndex': stepIndex,
    if (furthestReachedStepIndex != null)
      'furthestReachedStepIndex': furthestReachedStepIndex,
    'startedAt': startedAt.toIso8601String(),
    'savedAt': savedAt.toIso8601String(),
  };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LessonResumeCursor &&
            other.lessonId == lessonId &&
            other.courseId == courseId &&
            other.attemptId == attemptId &&
            other.attemptPurpose == attemptPurpose &&
            other.stepId == stepId &&
            other.stepIndex == stepIndex &&
            other.effectiveFurthestReachedStepIndex ==
                effectiveFurthestReachedStepIndex &&
            other.startedAt == startedAt &&
            other.savedAt == savedAt;
  }

  @override
  int get hashCode => Object.hash(
    lessonId,
    courseId,
    attemptId,
    attemptPurpose,
    stepId,
    stepIndex,
    startedAt,
    savedAt,
    effectiveFurthestReachedStepIndex,
  );
}

class LearnerProgress {
  const LearnerProgress({required this.events});

  final List<ProgressEvent> events;
}

class TopicProgress {
  const TopicProgress({
    required this.topicId,
    this.viewedAt,
    this.lastActivityAt,
    this.completedAt,
  });

  final String topicId;
  final DateTime? viewedAt;
  final DateTime? lastActivityAt;
  final DateTime? completedAt;

  bool get hasBeenViewed => viewedAt != null;
  bool get hasBeenCompleted => completedAt != null;
}

class ProgressEvent {
  const ProgressEvent({
    required this.id,
    required this.eventType,
    required this.topicId,
    required this.createdAt,
    this.sectionId,
    this.contentReference,
    this.metadataJson,
  });

  factory ProgressEvent.create({
    required ProgressEventType eventType,
    required String topicId,
    DateTime? now,
    String? sectionId,
    String? contentReference,
    String? metadataJson,
  }) {
    final timestamp = now ?? DateTime.now();

    return ProgressEvent(
      id:
          '${timestamp.microsecondsSinceEpoch}.${eventType.name}.'
          '$topicId',
      eventType: eventType,
      topicId: topicId,
      sectionId: sectionId,
      contentReference: contentReference,
      createdAt: timestamp,
      metadataJson: metadataJson,
    );
  }

  factory ProgressEvent.fromJson(Map<String, Object?> json) {
    return ProgressEvent(
      id: json['id']! as String,
      eventType: ProgressEventType.values.byName(json['eventType']! as String),
      topicId: json['topicId']! as String,
      sectionId: json['sectionId'] as String?,
      contentReference: json['contentReference'] as String?,
      createdAt: DateTime.parse(json['createdAt']! as String),
      metadataJson: json['metadataJson'] as String?,
    );
  }

  final String id;
  final ProgressEventType eventType;
  final String topicId;
  final String? sectionId;
  final String? contentReference;
  final DateTime createdAt;
  final String? metadataJson;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'eventType': eventType.name,
      'topicId': topicId,
      if (sectionId != null) 'sectionId': sectionId,
      if (contentReference != null) 'contentReference': contentReference,
      'createdAt': createdAt.toIso8601String(),
      if (metadataJson != null) 'metadataJson': metadataJson,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProgressEvent &&
            other.id == id &&
            other.eventType == eventType &&
            other.topicId == topicId &&
            other.sectionId == sectionId &&
            other.contentReference == contentReference &&
            other.createdAt == createdAt &&
            other.metadataJson == metadataJson;
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventType,
    topicId,
    sectionId,
    contentReference,
    createdAt,
    metadataJson,
  );
}
