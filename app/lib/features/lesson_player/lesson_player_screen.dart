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
import 'lesson_player_step.dart';

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
  static const _stepBuilder = LessonPlayerStepBuilder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = lessonContent.lesson;
    final steps = _stepBuilder.buildSteps(lessonContent);
    final sessionProvider = lessonPlayerSessionProvider(lesson.id);
    final session = ref.watch(sessionProvider);
    final currentStepIndex = steps.isEmpty
        ? 0
        : session.currentStepIndex.clamp(0, steps.length - 1);
    final currentStep = steps.isEmpty ? null : steps[currentStepIndex];

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
        if (currentStep == null)
          const Text('No activities available.')
        else ...[
          LessonPlayerStepView(
            step: currentStep,
            state: session.stepStates[currentStep.id],
            onStateChanged: (stepState) {
              final nextStepStates = {
                ...session.stepStates,
                currentStep.id: stepState,
              };
              final nextCompletedStepIds = <String>{
                ...session.completedStepIds,
              };
              if (_isStepCompleted(currentStep, nextStepStates)) {
                nextCompletedStepIds.add(currentStep.id);
              } else {
                nextCompletedStepIds.remove(currentStep.id);
              }

              ref.read(sessionProvider.notifier).state = session.copyWith(
                completedStepIds: nextCompletedStepIds,
                stepStates: nextStepStates,
              );
            },
          ),
          LessonNavigationControls(
            lessonId: lesson.id,
            steps: steps,
            currentStepIndex: currentStepIndex,
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
    required this.steps,
    required this.currentStepIndex,
    required this.session,
    super.key,
  });

  final String lessonId;
  final List<LessonPlayerStep> steps;
  final int currentStepIndex;
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
    final isFirstStep = widget.currentStepIndex == 0;
    final isLastStep = widget.currentStepIndex == widget.steps.length - 1;
    final currentStep = widget.steps[widget.currentStepIndex];
    final isCurrentStepCompleted = _isStepCompleted(
      currentStep,
      widget.session.stepStates,
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
                  onPressed: isFirstStep ? null : _goToPreviousStep,
                  child: const Text('← Previous'),
                ),
                const Spacer(),
                Text(
                  'Step ${widget.currentStepIndex + 1} / '
                  '${widget.steps.length}',
                ),
                const Spacer(),
                if (isLastStep)
                  FilledButton(
                    onPressed: _isCompleting || !isCurrentStepCompleted
                        ? null
                        : _completeLesson,
                    child: Text(
                      _isCompleting ? 'Finishing...' : 'Finish Lesson',
                    ),
                  )
                else
                  FilledButton(
                    onPressed: isCurrentStepCompleted ? _goToNextStep : null,
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
                return _CourseCompletionActions(lessonId: widget.lessonId);
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
    final currentStep = widget.steps[widget.currentStepIndex];
    if (!_isStepCompleted(currentStep, widget.session.stepStates)) {
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

  void _goToPreviousStep() {
    if (widget.currentStepIndex <= 0) {
      return;
    }

    ref.read(lessonPlayerSessionProvider(widget.lessonId).notifier).state =
        widget.session.copyWith(currentStepIndex: widget.currentStepIndex - 1);
  }

  void _goToNextStep() {
    if (widget.currentStepIndex >= widget.steps.length - 1) {
      return;
    }

    final currentStep = widget.steps[widget.currentStepIndex];
    if (!_isStepCompleted(currentStep, widget.session.stepStates)) {
      return;
    }

    ref
        .read(lessonPlayerSessionProvider(widget.lessonId).notifier)
        .state = widget.session.copyWith(
      currentStepIndex: widget.currentStepIndex + 1,
      completedStepIds: {...widget.session.completedStepIds, currentStep.id},
    );
  }
}

class _CourseCompletionActions extends ConsumerWidget {
  const _CourseCompletionActions({required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Course complete', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: () {
                context.goNamed(CourseRoute.name);
              },
              child: const Text('Back to course'),
            ),
            OutlinedButton(
              onPressed: () {
                context.goNamed(CourseRoute.name);
              },
              child: const Text('Review completed lessons'),
            ),
            OutlinedButton(
              onPressed: () {
                ref.read(lessonPlayerSessionProvider(lessonId).notifier).state =
                    const LessonPlayerSessionState();
                context.goNamed(
                  LessonRoute.name,
                  pathParameters: {'lessonId': lessonId},
                );
              },
              child: const Text('Repeat checkpoint'),
            ),
          ],
        ),
      ],
    );
  }
}

class LessonPlayerStepView extends StatelessWidget {
  const LessonPlayerStepView({
    required this.step,
    this.state,
    this.onStateChanged,
    super.key,
  });

  final LessonPlayerStep step;
  final ActivityTemplateState? state;
  final ValueChanged<ActivityTemplateState>? onStateChanged;

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
              step.sourceActivity.activity.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              _stepTypeLabel(step.stepType),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 12),
            for (final content in step.content)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: LessonContentObjectView(
                  content: content,
                  state: state,
                  onStateChanged: onStateChanged,
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
    this.state,
    this.onStateChanged,
    super.key,
  });

  final Object content;
  final ActivityTemplateState? state;
  final ValueChanged<ActivityTemplateState>? onStateChanged;

  @override
  Widget build(BuildContext context) {
    return switch (content) {
      VocabularyItem item => VocabularyItemView(item: item),
      GrammarTopic topic => GrammarTopicView(topic: topic),
      Dialogue dialogue => DialogueView(dialogue: dialogue),
      ReadingText reading => ReadingTextView(reading: reading),
      ExerciseTemplate template => ExerciseTemplateView(
        template: template,
        state: state,
        onStateChanged: onStateChanged,
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

bool _isStepCompleted(
  LessonPlayerStep step,
  Map<String, ActivityTemplateState> stepStates,
) {
  if (!step.isCheckable) {
    return true;
  }

  return stepStates[step.id]?.isCompleted ?? false;
}

String _stepTypeLabel(LessonPlayerStepType stepType) {
  return switch (stepType) {
    LessonPlayerStepType.vocabulary => 'vocabulary',
    LessonPlayerStepType.grammar => 'grammar',
    LessonPlayerStepType.dialogue => 'dialogue',
    LessonPlayerStepType.reading => 'reading',
    LessonPlayerStepType.exercise => 'exercise',
    LessonPlayerStepType.mixed => 'mixed',
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
