import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'content_repository.dart';
import 'course.dart';

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

final currentLanguageProvider = FutureProvider<Language>((ref) {
  return ref.watch(contentRepositoryProvider).loadCurrentLanguage();
});

final currentCourseProvider = FutureProvider<Course>((ref) {
  return ref.watch(contentRepositoryProvider).loadCourse();
});

final topicDetailsProvider = FutureProvider.family<TopicDetails, String>((
  ref,
  topicId,
) {
  return ref.watch(contentRepositoryProvider).loadTopicDetails(topicId);
});
