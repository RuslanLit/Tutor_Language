import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/content_providers.dart';
import '../../core/content/content_repository.dart';
import '../../core/learner/learner_progress.dart';
import '../../core/learner/learner_progress_providers.dart';
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
  bool _recordedTopicViewed = false;

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(topicDetailsProvider(widget.topicId));
    final rendererRegistry = ref.watch(topicContentRendererRegistryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Topic')),
      body: details.when(
        data: (details) {
          _recordTopicViewed(details);

          return TopicDetailsView(
            details: details,
            rendererRegistry: rendererRegistry,
            onProgressEvent: _recordProgressEvent,
          );
        },
        error: (error, stackTrace) => CourseBrowserError(message: '$error'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _recordTopicViewed(TopicDetails details) {
    if (_recordedTopicViewed) {
      return;
    }

    _recordedTopicViewed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _recordProgressEvent(
        ProgressEvent.create(
          eventType: ProgressEventType.topicViewed,
          topicId: details.topic.id,
        ),
      );
    });
  }

  void _recordProgressEvent(ProgressEvent event) {
    final repository = ref.read(learnerProgressRepositoryProvider);

    repository.recordEvent(event).then((_) {
      if (mounted) {
        ref.invalidate(topicProgressProvider(event.topicId));
      }
    });
  }
}

class TopicDetailsView extends StatelessWidget {
  const TopicDetailsView({
    required this.details,
    required this.rendererRegistry,
    this.onProgressEvent,
    super.key,
  });

  final TopicDetails details;
  final TopicContentRendererRegistry rendererRegistry;
  final ValueChanged<ProgressEvent>? onProgressEvent;

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
            onProgressEvent: onProgressEvent,
          ),
      ],
    );
  }
}
