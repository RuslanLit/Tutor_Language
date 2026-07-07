import 'curriculum_models.dart';

class LessonOrderService {
  const LessonOrderService();

  List<Lesson> orderedLessons(Course course) {
    final lessonsById = {
      for (final lesson in course.lessons) lesson.id: lesson,
    };

    return [
      for (final module in course.modules)
        for (final lessonId in module.lessonIds)
          if (lessonsById[lessonId] != null) lessonsById[lessonId]!,
    ];
  }

  Lesson? lessonById(Course course, String lessonId) {
    for (final lesson in orderedLessons(course)) {
      if (lesson.id == lessonId) {
        return lesson;
      }
    }

    return null;
  }

  Lesson? previousLesson(Course course, String lessonId) {
    final lessons = orderedLessons(course);
    final index = lessons.indexWhere((lesson) => lesson.id == lessonId);

    if (index <= 0) {
      return null;
    }

    return lessons[index - 1];
  }

  Lesson? nextLesson(Course course, String lessonId) {
    final lessons = orderedLessons(course);
    final index = lessons.indexWhere((lesson) => lesson.id == lessonId);

    if (index < 0 || index == lessons.length - 1) {
      return null;
    }

    return lessons[index + 1];
  }

  bool isFirstLesson(Course course, String lessonId) {
    return previousLesson(course, lessonId) == null &&
        lessonById(course, lessonId) != null;
  }

  bool isLastLesson(Course course, String lessonId) {
    return nextLesson(course, lessonId) == null &&
        lessonById(course, lessonId) != null;
  }
}
