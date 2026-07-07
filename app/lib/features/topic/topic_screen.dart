import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/content_providers.dart';
import '../../core/content/content_repository.dart';
import '../exercise_runtime/exercise_runtime_models.dart';
import '../learning_session/learning_session_controller.dart';
import '../learning_session/learning_session_providers.dart';
import '../../shared/widgets/course_browser_error.dart';
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
    final details = ref.watch(topicDetailsProvider(widget.topicId));
    final rendererRegistry = ref.watch(topicContentRendererRegistryProvider);
    final sessionController = ref.watch(
      learningSessionControllerProvider(widget.topicId),
    );
    _sessionController = sessionController;

    return Scaffold(
      appBar: AppBar(title: const Text('Topic')),
      body: details.when(
        data: (details) {
          return TopicDetailsView(
            details: details,
            rendererRegistry: rendererRegistry,
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

class TopicDetailsView extends StatelessWidget {
  const TopicDetailsView({
    required this.details,
    required this.rendererRegistry,
    this.onRuntimeEvent,
    super.key,
  });

  final TopicDetails details;
  final TopicContentRendererRegistry rendererRegistry;
  final ValueChanged<ExerciseRuntimeEvent>? onRuntimeEvent;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          details.topic.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        for (final section in details.sections)
          TopicSectionCard(
            topicId: details.topic.id,
            sectionDetails: section,
            rendererRegistry: rendererRegistry,
            onRuntimeEvent: onRuntimeEvent,
          ),
      ],
    );
  }
}
