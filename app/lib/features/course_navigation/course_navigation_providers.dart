import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/content_providers.dart';
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
  final course = await ref.watch(currentCourseProvider.future);
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
    final course = await ref.watch(currentCourseProvider.future);

    return ref
        .watch(courseNavigationServiceProvider)
        .nextOrderedLesson(course, lessonId);
  },
);

final orderedCourseLessonsProvider = FutureProvider<List<OrderedLesson>>((
  ref,
) async {
  final course = await ref.watch(currentCourseProvider.future);

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
