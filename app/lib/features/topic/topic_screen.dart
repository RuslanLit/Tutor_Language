import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/content_providers.dart';
import '../../core/content/content_repository.dart';
import '../../shared/widgets/course_browser_error.dart';
import 'rendering/topic_content_renderer_registry.dart';
import 'widgets/topic_section_card.dart';

class TopicScreen extends ConsumerWidget {
  const TopicScreen({required this.topicId, super.key});

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(topicDetailsProvider(topicId));
    final rendererRegistry = ref.watch(topicContentRendererRegistryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Topic')),
      body: details.when(
        data: (details) => TopicDetailsView(
          details: details,
          rendererRegistry: rendererRegistry,
        ),
        error: (error, stackTrace) => CourseBrowserError(message: '$error'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class TopicDetailsView extends StatelessWidget {
  const TopicDetailsView({
    required this.details,
    required this.rendererRegistry,
    super.key,
  });

  final TopicDetails details;
  final TopicContentRendererRegistry rendererRegistry;

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
            sectionDetails: section,
            rendererRegistry: rendererRegistry,
          ),
      ],
    );
  }
}
