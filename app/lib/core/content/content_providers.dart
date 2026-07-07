import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/curriculum/curriculum_models.dart';
import '../../features/curriculum/lesson_order_service.dart';
import 'content_repository.dart';

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

final currentLanguageProvider = FutureProvider<LanguagePackDisplay>((ref) {
  return ref.watch(contentRepositoryProvider).loadCurrentLanguage();
});

final currentCourseProvider = FutureProvider<Course>((ref) {
  return ref.watch(contentRepositoryProvider).loadCourse();
});

final lessonDetailsProvider = FutureProvider.family<LessonDetails, String>((
  ref,
  lessonId,
) {
  return ref.watch(contentRepositoryProvider).loadLessonDetails(lessonId);
});

final topicOrderServiceProvider = Provider<LessonOrderService>((ref) {
  return const LessonOrderService();
});
