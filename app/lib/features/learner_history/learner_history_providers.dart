import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_provider.dart';
import '../../core/learner/learner_progress_providers.dart';
import '../../core/learner/learner_state_repository.dart';
import '../lesson_planning/learner_history_summary.dart';
import 'learner_history_projection.dart';

final learnerStateRepositoryProvider = Provider<LearnerStateRepository>((ref) {
  return LearnerStateRepository(ref.watch(appDatabaseProvider));
});

final learnerHistoryProjectionProvider = Provider<LearnerHistoryProjection>((
  ref,
) {
  return LearnerHistoryProjection(
    learnerProgressRepository: ref.watch(learnerProgressRepositoryProvider),
    learnerStateRepository: ref.watch(learnerStateRepositoryProvider),
  );
});

final learnerHistorySummaryProvider = FutureProvider<LearnerHistorySummary>((
  ref,
) {
  return ref.watch(learnerHistoryProjectionProvider).project();
});
