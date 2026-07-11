import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/learner/learner_progress_providers.dart';
import 'learning_session_controller.dart';

final learningSessionControllerProvider = Provider.autoDispose
    .family<LearningSessionController, String>((ref, topicId) {
      final controller = LearningSessionController(
        progressRepository: ref.watch(learnerProgressRepositoryProvider),
        onProgressRecorded: (topicId) {
          ref.invalidate(topicProgressProvider(topicId));
          ref.invalidate(learnerProgressEventsProvider);
        },
      );

      controller.startSession(topicId);
      ref.onDispose(() {
        controller.finishSession();
      });

      return controller;
    });
