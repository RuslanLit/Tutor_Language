import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/content/content_providers.dart';
import '../../core/content/content_repository.dart';
import '../../core/learner/learner_progress.dart';
import '../../core/learner/learner_progress_providers.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/course_browser_error.dart';
import '../curriculum/curriculum_models.dart';
import '../exercise_runtime/exercise_runtime_models.dart';
import '../learning_session/learning_session_controller.dart';
import '../learning_session/learning_session_providers.dart';
import 'rendering/topic_content_renderer_registry.dart';
import 'widgets/topic_section_card.dart';

class TopicScreen extends ConsumerStatefulWidget {
  const TopicScreen({required this.topicId, super.key});

  final String topicId;

  @override
  ConsumerState<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends ConsumerState<TopicScreen> {
  LearningSessionController? _sessionController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final details = ref.watch(lessonDetailsProvider(widget.topicId));
    final course = ref.watch(currentCourseProvider);
    final progress = ref.watch(topicProgressProvider(widget.topicId));
    final rendererRegistry = ref.watch(topicContentRendererRegistryProvider);
    final topicOrderService = ref.watch(topicOrderServiceProvider);
    final sessionController = ref.watch(
      learningSessionControllerProvider(widget.topicId),
    );
    _sessionController = sessionController;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.lessonTitle)),
      body: details.when(
        data: (details) {
          final loadedCourse = course.asData?.value;
          final loadedProgress = progress.asData?.value;

          return LessonDetailsView(
            details: details,
            rendererRegistry: rendererRegistry,
            previousTopic: loadedCourse == null
                ? null
                : topicOrderService.previousLesson(
                    loadedCourse,
                    details.lesson.id,
                  ),
            nextTopic: loadedCourse == null
                ? null
                : topicOrderService.nextLesson(loadedCourse, details.lesson.id),
            topicProgress: loadedProgress,
            onRuntimeEvent: (event) => _recordRuntimeEvent(
              sessionController: sessionController,
              event: event,
            ),
          );
        },
        error: (error, stackTrace) => CourseBrowserError(message: '$error'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  void dispose() {
    _sessionController?.finishSession();
    super.dispose();
  }

  void _recordRuntimeEvent({
    required LearningSessionController sessionController,
    required ExerciseRuntimeEvent event,
  }) {
    final sectionId = event.sectionId;
    final contentReference = event.contentReference;

    if (sectionId == null || contentReference == null) {
      return;
    }

    sessionController.recordRuntimeEvent(
      event: event,
      sectionId: sectionId,
      contentReference: contentReference,
      metadataJson: event.metadataJson,
    );
  }
}

class LessonDetailsView extends StatelessWidget {
  const LessonDetailsView({
    required this.details,
    required this.rendererRegistry,
    this.previousTopic,
    this.nextTopic,
    this.topicProgress,
    this.onRuntimeEvent,
    super.key,
  });

  final LessonDetails details;
  final TopicContentRendererRegistry rendererRegistry;
  final Lesson? previousTopic;
  final Lesson? nextTopic;
  final TopicProgress? topicProgress;
  final ValueChanged<ExerciseRuntimeEvent>? onRuntimeEvent;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          details.lesson.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        for (final activity in details.activities)
          LessonActivityCard(
            topicId: details.lesson.id,
            activityDetails: activity,
            rendererRegistry: rendererRegistry,
            onRuntimeEvent: onRuntimeEvent,
          ),
        const SizedBox(height: 16),
        TopicNavigationControls(
          previousTopic: previousTopic,
          nextTopic: nextTopic,
          isCompleted: topicProgress?.hasBeenCompleted ?? false,
        ),
      ],
    );
  }
}

class TopicNavigationControls extends StatelessWidget {
  const TopicNavigationControls({
    required this.previousTopic,
    required this.nextTopic,
    required this.isCompleted,
    super.key,
  });

  final Lesson? previousTopic;
  final Lesson? nextTopic;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (previousTopic != null)
          OutlinedButton(
            onPressed: () => _openTopic(context, previousTopic!),
            child: Text(l10n.previousLesson),
          ),
        if (nextTopic != null)
          OutlinedButton(
            onPressed: () => _openTopic(context, nextTopic!),
            child: Text(l10n.nextLesson),
          ),
        if (isCompleted && nextTopic != null)
          FilledButton(
            onPressed: () => _openTopic(context, nextTopic!),
            child: Text(l10n.continueToNextLesson),
          ),
      ],
    );
  }

  void _openTopic(BuildContext context, Lesson lesson) {
    context.goNamed(TopicRoute.name, pathParameters: {'topicId': lesson.id});
  }
}
