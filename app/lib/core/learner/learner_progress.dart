enum ProgressEventType {
  topicViewed,
  exerciseAnswered,
  answerChecked,
  topicCompleted,
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
