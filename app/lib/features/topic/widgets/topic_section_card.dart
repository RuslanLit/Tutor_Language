import 'package:flutter/material.dart';

import '../../../core/content/content_repository.dart';
import '../rendering/topic_content_renderer_registry.dart';
import 'section_header.dart';

class TopicSectionCard extends StatelessWidget {
  const TopicSectionCard({
    required this.sectionDetails,
    required this.rendererRegistry,
    super.key,
  });

  final TopicSectionDetails sectionDetails;
  final TopicContentRendererRegistry rendererRegistry;

  @override
  Widget build(BuildContext context) {
    final section = sectionDetails.section;
    final content = sectionDetails.content;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: section.title, contentType: content.type),
            const SizedBox(height: 12),
            rendererRegistry.build(context, content),
          ],
        ),
      ),
    );
  }
}
