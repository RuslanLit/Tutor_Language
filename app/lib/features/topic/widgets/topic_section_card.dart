import 'package:flutter/material.dart';

import '../../../core/content/content_repository.dart';
import '../../exercise_runtime/exercise_runtime_models.dart';
import '../rendering/topic_content_renderer.dart';
import '../rendering/topic_content_renderer_registry.dart';
import 'section_header.dart';

class LessonActivityCard extends StatelessWidget {
  const LessonActivityCard({
    required this.topicId,
    required this.activityDetails,
    required this.rendererRegistry,
    this.onRuntimeEvent,
    super.key,
  });

  final String topicId;
  final LessonActivityContentDetails activityDetails;
  final TopicContentRendererRegistry rendererRegistry;
  final ValueChanged<ExerciseRuntimeEvent>? onRuntimeEvent;

  @override
  Widget build(BuildContext context) {
    final activity = activityDetails.activity;
    final content = activityDetails.content;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: activity.title, contentType: content.type),
            const SizedBox(height: 12),
            rendererRegistry.build(
              context,
              content,
              renderContext: TopicContentRenderContext(
                topicId: topicId,
                sectionId: activity.id,
                contentReference: activityDetails.contentReference.assetPath,
                onRuntimeEvent: onRuntimeEvent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
