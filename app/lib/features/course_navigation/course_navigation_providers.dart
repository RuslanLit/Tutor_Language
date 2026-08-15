import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/content_localization_providers.dart';
import '../../core/learner/learner_progress.dart';
import '../../core/learner/learner_progress_providers.dart';
import 'course_navigation_models.dart';
import 'course_navigation_service.dart';

final courseNavigationServiceProvider = Provider<CourseNavigationService>((
  ref,
) {
  return const CourseNavigationService();
});

final courseNavigationStateProvider = FutureProvider<CourseNavigationState>((
  ref,
) async {
  final course = await ref.watch(localizedCurrentCourseProvider.future);
  final progressEvents = await ref.watch(learnerProgressEventsProvider.future);
  final completedLessonIds = _completedLessonIds(progressEvents);

  return ref
      .watch(courseNavigationServiceProvider)
      .buildNavigationState(
        course: course,
        completedLessonIds: completedLessonIds,
      );
});

final nextOrderedLessonProvider = FutureProvider.family<OrderedLesson?, String>(
  (ref, lessonId) async {
    final course = await ref.watch(localizedCurrentCourseProvider.future);

    return ref
        .watch(courseNavigationServiceProvider)
        .nextOrderedLesson(course, lessonId);
  },
);

final nextAvailableLessonProvider =
    FutureProvider.family<OrderedLesson?, String>((ref, lessonId) async {
      final nextLesson = await ref.watch(
        nextOrderedLessonProvider(lessonId).future,
      );
      if (nextLesson == null) {
        return null;
      }

      final navigation = await ref.watch(courseNavigationStateProvider.future);
      LessonNavigationStatus? nextStatus;
      for (final unit in navigation.units) {
        for (final lesson in unit.lessons) {
          if (lesson.lessonId == nextLesson.lesson.id) {
            nextStatus = lesson.status;
          }
        }
      }
      return nextStatus == LessonNavigationStatus.available ? nextLesson : null;
    });

final orderedCourseLessonsProvider = FutureProvider<List<OrderedLesson>>((
  ref,
) async {
  final course = await ref.watch(localizedCurrentCourseProvider.future);

  return ref
      .watch(courseNavigationServiceProvider)
      .orderedCourseLessons(course);
});

Set<String> _completedLessonIds(List<ProgressEvent> events) {
  return {
    for (final event in events)
      if (event.eventType == ProgressEventType.lessonCompleted ||
          event.eventType == ProgressEventType.topicCompleted)
        event.topicId,
  };
}
