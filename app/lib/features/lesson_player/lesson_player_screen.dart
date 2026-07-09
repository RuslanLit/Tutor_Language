import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/topic_content.dart';
import '../../shared/widgets/course_browser_error.dart';
import '../activity_engine/activity_widgets.dart';
import '../lesson_assembly/lesson_content.dart';
import 'lesson_player_providers.dart';

class LessonPlayerScreen extends ConsumerWidget {
  const LessonPlayerScreen({required this.lessonId, super.key});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonContent = ref.watch(assembledLessonProvider(lessonId));

    return Scaffold(
      appBar: AppBar(title: const Text('Lesson Player')),
      body: lessonContent.when(
        data: (lessonContent) => LessonPlayerView(lessonContent: lessonContent),
        error: (error, stackTrace) => CourseBrowserError(message: '$error'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class LessonPlayerView extends StatelessWidget {
  const LessonPlayerView({required this.lessonContent, super.key});

  final LessonContent lessonContent;

  @override
  Widget build(BuildContext context) {
    final lesson = lessonContent.lesson;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(lesson.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MetadataChip(label: lesson.id),
            if (lesson.difficulty.isNotEmpty)
              _MetadataChip(label: lesson.difficulty),
            if (lesson.courseId.isNotEmpty)
              _MetadataChip(label: lesson.courseId),
            if (lesson.moduleId.isNotEmpty)
              _MetadataChip(label: lesson.moduleId),
          ],
        ),
        if (lesson.description.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(lesson.description),
        ],
        const SizedBox(height: 20),
        for (final section in lessonContent.sections)
          LessonSectionView(sectionContent: section),
      ],
    );
  }
}

class LessonSectionView extends StatelessWidget {
  const LessonSectionView({required this.sectionContent, super.key});

  final LessonContentSection sectionContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionContent.section.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          for (final activity in sectionContent.activities)
            LessonActivityView(activityContent: activity),
        ],
      ),
    );
  }
}

class LessonActivityView extends StatelessWidget {
  const LessonActivityView({required this.activityContent, super.key});

  final LessonContentActivity activityContent;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activityContent.activity.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              activityContent.activity.type,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 12),
            for (final content in activityContent.resolvedContent)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: LessonContentObjectView(content: content),
              ),
          ],
        ),
      ),
    );
  }
}

class LessonContentObjectView extends StatelessWidget {
  const LessonContentObjectView({required this.content, super.key});

  final Object content;

  @override
  Widget build(BuildContext context) {
    return switch (content) {
      VocabularyItem item => VocabularyItemView(item: item),
      GrammarTopic topic => GrammarTopicView(topic: topic),
      Dialogue dialogue => DialogueView(dialogue: dialogue),
      ReadingText reading => ReadingTextView(reading: reading),
      ExerciseTemplate template => ExerciseTemplateView(template: template),
      _ => Text('Unsupported content: ${content.runtimeType}'),
    };
  }
}

class VocabularyItemView extends StatelessWidget {
  const VocabularyItemView({required this.item, super.key});

  final VocabularyItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.spanish, style: Theme.of(context).textTheme.titleSmall),
        Text(item.nativeTranslation),
        if (item.pronunciation != null && item.pronunciation!.isNotEmpty)
          Text(item.pronunciation!),
        if (item.example.isNotEmpty) Text(item.example),
        if (item.notes != null && item.notes!.isNotEmpty) Text(item.notes!),
      ],
    );
  }
}

class GrammarTopicView extends StatelessWidget {
  const GrammarTopicView({required this.topic, super.key});

  final GrammarTopic topic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(topic.title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(topic.explanation),
        if (topic.examples.isNotEmpty) ...[
          const SizedBox(height: 8),
          for (final example in topic.examples) Text(example),
        ],
        if (topic.prerequisiteIds.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('Prerequisites: ${topic.prerequisiteIds.join(', ')}'),
        ],
      ],
    );
  }
}

class DialogueView extends StatelessWidget {
  const DialogueView({required this.dialogue, super.key});

  final Dialogue dialogue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(dialogue.title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        for (final line in dialogue.lines)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.speaker,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(line.spanish),
                Text(line.nativeTranslation),
              ],
            ),
          ),
      ],
    );
  }
}

class ReadingTextView extends StatelessWidget {
  const ReadingTextView({required this.reading, super.key});

  final ReadingText reading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(reading.title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Text(reading.text),
        const SizedBox(height: 8),
        Text(reading.nativeTranslation),
      ],
    );
  }
}

class ExerciseTemplateView extends StatelessWidget {
  const ExerciseTemplateView({required this.template, super.key});

  final ExerciseTemplate template;

  @override
  Widget build(BuildContext context) {
    return ActivityTemplateWidget(template: template);
  }
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
