import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/content_providers.dart';
import '../../core/content/content_repository.dart';
import '../../core/content/topic_content.dart';
import '../../shared/widgets/course_browser_error.dart';

class TopicScreen extends ConsumerWidget {
  const TopicScreen({required this.topicId, super.key});

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(topicDetailsProvider(topicId));

    return Scaffold(
      appBar: AppBar(title: const Text('Topic')),
      body: details.when(
        data: (details) => TopicDetailsView(details: details),
        error: (error, stackTrace) => CourseBrowserError(message: '$error'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class TopicDetailsView extends StatelessWidget {
  const TopicDetailsView({required this.details, super.key});

  final TopicDetails details;

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
          TopicSectionCard(sectionDetails: section),
      ],
    );
  }
}

class TopicSectionCard extends StatelessWidget {
  const TopicSectionCard({required this.sectionDetails, super.key});

  final TopicSectionDetails sectionDetails;

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
            Text(section.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(content.type, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 12),
            ContentView(content: content),
          ],
        ),
      ),
    );
  }
}

class ContentView extends StatelessWidget {
  const ContentView({required this.content, super.key});

  final TopicContent content;

  @override
  Widget build(BuildContext context) {
    return switch (content) {
      VocabularyContent(:final entries) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in entries)
            Text('${entry.spanish} - ${entry.nativeTranslation}'),
        ],
      ),
      GrammarContent(:final rules) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final rule in rules) ...[
            Text(rule.title, style: Theme.of(context).textTheme.titleSmall),
            Text(rule.explanation),
          ],
        ],
      ),
      DialogueContent(:final dialogues) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final dialogue in dialogues)
            for (final line in dialogue.lines)
              Text('${line.speaker}: ${line.spanish}'),
        ],
      ),
      ReadingContent(:final readings) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final reading in readings) ...[
            Text(reading.title, style: Theme.of(context).textTheme.titleSmall),
            for (final paragraph in reading.text.split('\n')) Text(paragraph),
          ],
        ],
      ),
      ExerciseTemplateContent(:final templates) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final template in templates) ...[
            Text(template.id),
            Text('Type: ${template.exerciseType}'),
            Text('Prompt: ${template.promptTemplate}'),
          ],
        ],
      ),
      TopicContent() => Text(content.type),
    };
  }
}
