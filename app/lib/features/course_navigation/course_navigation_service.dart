import '../curriculum/curriculum_models.dart';
import 'course_navigation_models.dart';

class CourseNavigationService {
  const CourseNavigationService();

  CourseNavigationState buildNavigationState({
    required Course course,
    required Set<String> completedLessonIds,
  }) {
    final lessonsById = {
      for (final lesson in course.lessons) lesson.id: lesson,
    };
    final orderedLessons = <OrderedLesson>[];

    for (final unit in course.modules) {
      for (final lessonId in unit.lessonIds) {
        final lesson = lessonsById[lessonId];
        if (lesson != null) {
          orderedLessons.add(OrderedLesson(lesson: lesson, unit: unit));
        }
      }
    }

    final orderedLessonIds = orderedLessons
        .map((orderedLesson) => orderedLesson.lesson.id)
        .toSet();
    final knownCompletedLessonIds = completedLessonIds.intersection(
      orderedLessonIds,
    );
    final firstIncompleteLessonId = _firstIncompleteLessonId(
      orderedLessons,
      knownCompletedLessonIds,
    );

    return CourseNavigationState(
      courseId: course.id,
      courseTitle: course.title,
      nextLessonId: firstIncompleteLessonId,
      completedLessonCount: knownCompletedLessonIds.length,
      totalLessonCount: orderedLessons.length,
      units: List.unmodifiable(
        course.modules.map((unit) {
          return UnitNavigationState(
            unitId: unit.id,
            title: unit.title,
            lessons: List.unmodifiable(
              unit.lessonIds
                  .map((lessonId) => lessonsById[lessonId])
                  .whereType<Lesson>()
                  .map((lesson) {
                    return LessonNavigationState(
                      lessonId: lesson.id,
                      title: lesson.title,
                      status: _lessonStatus(
                        lesson.id,
                        knownCompletedLessonIds,
                        firstIncompleteLessonId,
                      ),
                    );
                  }),
            ),
          );
        }),
      ),
    );
  }

  OrderedLesson? nextOrderedLesson(Course course, String lessonId) {
    final orderedLessons = orderedCourseLessons(course);
    final index = orderedLessons.indexWhere(
      (orderedLesson) => orderedLesson.lesson.id == lessonId,
    );

    if (index < 0 || index + 1 >= orderedLessons.length) {
      return null;
    }

    return orderedLessons[index + 1];
  }

  List<OrderedLesson> orderedCourseLessons(Course course) {
    final lessonsById = {
      for (final lesson in course.lessons) lesson.id: lesson,
    };

    return List.unmodifiable([
      for (final unit in course.modules)
        for (final lessonId in unit.lessonIds)
          if (lessonsById[lessonId] != null)
            OrderedLesson(lesson: lessonsById[lessonId]!, unit: unit),
    ]);
  }

  String? _firstIncompleteLessonId(
    List<OrderedLesson> orderedLessons,
    Set<String> completedLessonIds,
  ) {
    for (final orderedLesson in orderedLessons) {
      if (!completedLessonIds.contains(orderedLesson.lesson.id)) {
        return orderedLesson.lesson.id;
      }
    }

    return null;
  }

  LessonNavigationStatus _lessonStatus(
    String lessonId,
    Set<String> completedLessonIds,
    String? firstIncompleteLessonId,
  ) {
    if (completedLessonIds.contains(lessonId)) {
      return LessonNavigationStatus.completed;
    }

    if (lessonId == firstIncompleteLessonId) {
      return LessonNavigationStatus.available;
    }

    return LessonNavigationStatus.locked;
  }
}
