import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_provider.dart';
import 'learner_progress.dart';
import 'learner_progress_repository.dart';

final learnerProgressRepositoryProvider = Provider<LearnerProgressRepository>((
  ref,
) {
  return LearnerProgressRepository(ref.watch(appDatabaseProvider));
});

final topicProgressProvider = FutureProvider.family<TopicProgress, String>((
  ref,
  topicId,
) {
  return ref
      .watch(learnerProgressRepositoryProvider)
      .readTopicProgress(topicId);
});
