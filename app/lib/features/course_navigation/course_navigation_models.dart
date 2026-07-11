import '../curriculum/curriculum_models.dart';

class CourseNavigationState {
  const CourseNavigationState({
    required this.courseId,
    required this.courseTitle,
    required this.units,
    required this.completedLessonCount,
    required this.totalLessonCount,
    this.nextLessonId,
  });

  final String courseId;
  final String courseTitle;
  final List<UnitNavigationState> units;
  final String? nextLessonId;
  final int completedLessonCount;
  final int totalLessonCount;

  bool get isCourseCompleted =>
      totalLessonCount > 0 && completedLessonCount == totalLessonCount;
}

class UnitNavigationState {
  const UnitNavigationState({
    required this.unitId,
    required this.title,
    required this.lessons,
  });

  final String unitId;
  final String title;
  final List<LessonNavigationState> lessons;

  bool get isCompleted =>
      lessons.isNotEmpty &&
      lessons.every(
        (lesson) => lesson.status == LessonNavigationStatus.completed,
      );
}

enum LessonNavigationStatus { completed, available, locked }

class LessonNavigationState {
  const LessonNavigationState({
    required this.lessonId,
    required this.title,
    required this.status,
  });

  final String lessonId;
  final String title;
  final LessonNavigationStatus status;

  bool get isTappable => status != LessonNavigationStatus.locked;
}

class OrderedLesson {
  const OrderedLesson({required this.lesson, required this.unit});

  final Lesson lesson;
  final Module unit;
}
