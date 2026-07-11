import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/content/topic_content.dart';
import '../../core/learner/learner_progress_providers.dart';
import '../../shared/widgets/course_browser_error.dart';
import '../activity_engine/activity_template_state.dart';
import '../activity_engine/activity_widgets.dart';
import '../course_navigation/course_navigation_providers.dart';
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

class LessonPlayerView extends ConsumerWidget {
  const LessonPlayerView({required this.lessonContent, super.key});

  final LessonContent lessonContent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = lessonContent.lesson;
    final activities = lessonContent.activities;
    final sessionProvider = lessonPlayerSessionProvider(lesson.id);
    final session = ref.watch(sessionProvider);
    final currentActivityIndex = activities.isEmpty
        ? 0
        : session.currentActivityIndex.clamp(0, activities.length - 1);
    final currentActivity = activities.isEmpty
        ? null
        : activities[currentActivityIndex];

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
        if (currentActivity == null)
          const Text('No activities available.')
        else ...[
          LessonActivityView(
            activityContent: currentActivity,
            activityStates: session.activityStates,
            onActivityStateChanged: (templateId, activityState) {
              final nextActivityStates = {
                ...session.activityStates,
                templateId: activityState,
              };
              final nextCompletedActivityIds = <String>{
                ...session.completedActivityIds,
              };
              if (_isActivityCompleted(currentActivity, nextActivityStates)) {
                nextCompletedActivityIds.add(currentActivity.activity.id);
              } else {
                nextCompletedActivityIds.remove(currentActivity.activity.id);
              }

              ref.read(sessionProvider.notifier).state = session.copyWith(
                completedActivityIds: nextCompletedActivityIds,
                activityStates: nextActivityStates,
              );
            },
          ),
          LessonNavigationControls(
            lessonId: lesson.id,
            activities: activities,
            currentActivityIndex: currentActivityIndex,
            session: session,
          ),
        ],
      ],
    );
  }
}

class LessonNavigationControls extends ConsumerStatefulWidget {
  const LessonNavigationControls({
    required this.lessonId,
    required this.activities,
    required this.currentActivityIndex,
    required this.session,
    super.key,
  });

  final String lessonId;
  final List<LessonContentActivity> activities;
  final int currentActivityIndex;
  final LessonPlayerSessionState session;

  @override
  ConsumerState<LessonNavigationControls> createState() =>
      _LessonNavigationControlsState();
}

class _LessonNavigationControlsState
    extends ConsumerState<LessonNavigationControls> {
  bool _isCompleting = false;

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(topicProgressProvider(widget.lessonId));
    final isFirstActivity = widget.currentActivityIndex == 0;
    final isLastActivity =
        widget.currentActivityIndex == widget.activities.length - 1;
    final currentActivity = widget.activities[widget.currentActivityIndex];
    final isCurrentActivityCompleted = _isActivityCompleted(
      currentActivity,
      widget.session.activityStates,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: progress.when(
        data: (progress) {
          final isCompleted = progress.hasBeenCompleted;
          if (!isCompleted) {
            return Row(
              children: [
                OutlinedButton(
                  onPressed: isFirstActivity ? null : _goToPreviousActivity,
                  child: const Text('← Previous'),
                ),
                const Spacer(),
                Text(
                  'Activity ${widget.currentActivityIndex + 1} / '
                  '${widget.activities.length}',
                ),
                const Spacer(),
                if (isLastActivity)
                  FilledButton(
                    onPressed: _isCompleting || !isCurrentActivityCompleted
                        ? null
                        : _completeLesson,
                    child: Text(
                      _isCompleting ? 'Finishing...' : 'Finish Lesson',
                    ),
                  )
                else
                  FilledButton(
                    onPressed: isCurrentActivityCompleted
                        ? _goToNextActivity
                        : null,
                    child: const Text('Next →'),
                  ),
              ],
            );
          }

          final nextLesson = ref.watch(
            nextOrderedLessonProvider(widget.lessonId),
          );

          return nextLesson.when(
            data: (nextLesson) {
              if (nextLesson == null) {
                return const Text('Course complete');
              }

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  const Text('Lesson completed'),
                  FilledButton(
                    onPressed: () {
                      context.goNamed(
                        LessonRoute.name,
                        pathParameters: {'lessonId': nextLesson.lesson.id},
                      );
                    },
                    child: const Text('Continue to next lesson'),
                  ),
                ],
              );
            },
            error: (error, stackTrace) => CourseBrowserError(message: '$error'),
            loading: () => const CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) => CourseBrowserError(message: '$error'),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _completeLesson() async {
    final currentActivity = widget.activities[widget.currentActivityIndex];
    if (!_isActivityCompleted(currentActivity, widget.session.activityStates)) {
      return;
    }

    setState(() {
      _isCompleting = true;
    });

    await ref
        .read(learnerProgressRepositoryProvider)
        .recordLessonCompleted(widget.lessonId);

    ref.invalidate(topicProgressProvider(widget.lessonId));
    ref.invalidate(learnerProgressEventsProvider);
    ref.invalidate(courseNavigationStateProvider);

    if (mounted) {
      setState(() {
        _isCompleting = false;
      });
    }
  }

  void _goToPreviousActivity() {
    if (widget.currentActivityIndex <= 0) {
      return;
    }

    ref
        .read(lessonPlayerSessionProvider(widget.lessonId).notifier)
        .state = widget.session.copyWith(
      currentActivityIndex: widget.currentActivityIndex - 1,
    );
  }

  void _goToNextActivity() {
    if (widget.currentActivityIndex >= widget.activities.length - 1) {
      return;
    }

    final currentActivity = widget.activities[widget.currentActivityIndex];
    if (!_isActivityCompleted(currentActivity, widget.session.activityStates)) {
      return;
    }

    ref
        .read(lessonPlayerSessionProvider(widget.lessonId).notifier)
        .state = widget.session.copyWith(
      currentActivityIndex: widget.currentActivityIndex + 1,
      completedActivityIds: {
        ...widget.session.completedActivityIds,
        currentActivity.activity.id,
      },
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
  const LessonActivityView({
    required this.activityContent,
    this.activityStates = const {},
    this.onActivityStateChanged,
    super.key,
  });

  final LessonContentActivity activityContent;
  final Map<String, ActivityTemplateState> activityStates;
  final void Function(String templateId, ActivityTemplateState state)?
  onActivityStateChanged;

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
                child: LessonContentObjectView(
                  content: content,
                  activityStates: activityStates,
                  onActivityStateChanged: onActivityStateChanged,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LessonContentObjectView extends StatelessWidget {
  const LessonContentObjectView({
    required this.content,
    this.activityStates = const {},
    this.onActivityStateChanged,
    super.key,
  });

  final Object content;
  final Map<String, ActivityTemplateState> activityStates;
  final void Function(String templateId, ActivityTemplateState state)?
  onActivityStateChanged;

  @override
  Widget build(BuildContext context) {
    return switch (content) {
      VocabularyItem item => VocabularyItemView(item: item),
      GrammarTopic topic => GrammarTopicView(topic: topic),
      Dialogue dialogue => DialogueView(dialogue: dialogue),
      ReadingText reading => ReadingTextView(reading: reading),
      ExerciseTemplate template => ExerciseTemplateView(
        template: template,
        state: activityStates[template.id],
        onStateChanged: (state) {
          onActivityStateChanged?.call(template.id, state);
        },
      ),
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
  const ExerciseTemplateView({
    required this.template,
    this.state,
    this.onStateChanged,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityTemplateState? state;
  final ValueChanged<ActivityTemplateState>? onStateChanged;

  @override
  Widget build(BuildContext context) {
    return ActivityTemplateWidget(
      template: template,
      state: state,
      onStateChanged: onStateChanged,
    );
  }
}

bool _isActivityCompleted(
  LessonContentActivity activity,
  Map<String, ActivityTemplateState> activityStates,
) {
  final requiredTemplates = activity.resolvedContent
      .whereType<ExerciseTemplate>()
      .where(_requiresCompletion)
      .toList(growable: false);

  if (requiredTemplates.isEmpty) {
    return true;
  }

  return requiredTemplates.every((template) {
    return activityStates[template.id]?.isCompleted ?? false;
  });
}

bool _requiresCompletion(ExerciseTemplate template) {
  return switch (template.exerciseType) {
    'multiple_choice' => template.correctOptionId != null,
    'fill_gap' || 'text_entry' => template.expectedAnswer != null,
    'matching' => template.expectedAnswer != null,
    _ => false,
  };
}

class _MetadataChip extends StatelessWidget {
  const _MetadataChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label));
  }
}
