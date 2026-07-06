class LearnerState {
  const LearnerState({
    required this.selectedLanguage,
    required this.currentCourseId,
    required this.currentTopicId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LearnerState.initial({
    required String currentCourseId,
    required String currentTopicId,
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now();

    return LearnerState(
      selectedLanguage: 'spanish',
      currentCourseId: currentCourseId,
      currentTopicId: currentTopicId,
      createdAt: timestamp,
      updatedAt: timestamp,
    );
  }

  final String selectedLanguage;
  final String currentCourseId;
  final String currentTopicId;
  final DateTime createdAt;
  final DateTime updatedAt;

  LearnerState copyWith({
    String? selectedLanguage,
    String? currentCourseId,
    String? currentTopicId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LearnerState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      currentCourseId: currentCourseId ?? this.currentCourseId,
      currentTopicId: currentTopicId ?? this.currentTopicId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
