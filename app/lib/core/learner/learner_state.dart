class LearnerState {
  const LearnerState({
    required this.selectedLanguage,
    required this.currentCourseId,
    required this.currentLessonId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LearnerState.initial({
    required String currentCourseId,
    required String currentLessonId,
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now();

    return LearnerState(
      selectedLanguage: 'spanish',
      currentCourseId: currentCourseId,
      currentLessonId: currentLessonId,
      createdAt: timestamp,
      updatedAt: timestamp,
    );
  }

  final String selectedLanguage;
  final String currentCourseId;
  final String currentLessonId;
  final DateTime createdAt;
  final DateTime updatedAt;

  LearnerState copyWith({
    String? selectedLanguage,
    String? currentCourseId,
    String? currentLessonId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LearnerState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      currentCourseId: currentCourseId ?? this.currentCourseId,
      currentLessonId: currentLessonId ?? this.currentLessonId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
