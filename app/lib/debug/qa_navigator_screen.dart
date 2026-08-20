import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/router/app_router.dart';
import '../core/content/topic_content.dart';
import '../features/course_navigation/course_navigation_models.dart';
import '../features/course_navigation/course_navigation_providers.dart';
import '../features/lesson_assembly/lesson_content.dart';
import '../features/lesson_launch/lesson_launch_intent.dart';
import '../features/lesson_player/lesson_player_providers.dart';
import '../features/lesson_player/lesson_player_step.dart';
import 'qa_navigator.dart';

class QaNavigatorScreen extends ConsumerWidget {
  const QaNavigatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!qaNavigatorEnabled) {
      return const Scaffold(body: Center(child: Text('QA unavailable.')));
    }

    final lessons = ref.watch(orderedCourseLessonsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('QA Navigator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(SettingsRoute.name),
        ),
      ),
      body: lessons.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (orderedLessons) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'DEBUG ONLY. Select any authored lesson step. The target '
              'remains incomplete and uses the real Lesson Player.',
            ),
            const SizedBox(height: 12),
            for (final orderedLesson in orderedLessons)
              _QaLessonSection(orderedLesson: orderedLesson),
          ],
        ),
      ),
    );
  }
}

class _QaLessonSection extends ConsumerWidget {
  const _QaLessonSection({required this.orderedLesson});

  final OrderedLesson orderedLesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(assembledLessonProvider(orderedLesson.lesson.id));
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          'Lesson ${orderedLesson.position.indexInCourse} · '
          '${orderedLesson.lesson.title}',
        ),
        subtitle: content.when(
          loading: () => const Text('Loading steps…'),
          error: (error, stack) => const Text('Unable to assemble steps'),
          data: (lessonContent) {
            final count = const LessonPlayerStepBuilder()
                .buildSteps(lessonContent)
                .length;
            return Text('$count steps · ${orderedLesson.lesson.id}');
          },
        ),
        children: [
          content.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('$error'),
            ),
            data: (lessonContent) => _QaStepList(
              lessonContent: lessonContent,
              lessonPosition: orderedLesson.position,
            ),
          ),
        ],
      ),
    );
  }
}

class _QaStepList extends ConsumerWidget {
  const _QaStepList({
    required this.lessonContent,
    required this.lessonPosition,
  });

  final LessonContent lessonContent;
  final LessonPosition lessonPosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = const LessonPlayerStepBuilder().buildSteps(lessonContent);
    return Column(
      children: [
        for (var index = 0; index < steps.length; index++)
          _QaStepTile(
            lessonContent: lessonContent,
            steps: steps,
            step: steps[index],
            stepIndex: index,
            lessonPosition: lessonPosition,
          ),
      ],
    );
  }
}

class _QaStepTile extends ConsumerWidget {
  const _QaStepTile({
    required this.lessonContent,
    required this.steps,
    required this.step,
    required this.stepIndex,
    required this.lessonPosition,
  });

  final LessonContent lessonContent;
  final List<LessonPlayerStep> steps;
  final LessonPlayerStep step;
  final int stepIndex;
  final LessonPosition lessonPosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final template = step.content.whereType<ExerciseTemplate>().firstOrNull;
    final type = template?.exerciseType ?? _stepType(step);
    final title =
        template?.promptTemplate ?? step.sourceActivity.activity.title;
    return ListTile(
      dense: true,
      title: Text('${stepIndex + 1} · $type'),
      subtitle: Text(
        '${_shorten(title)}\n${template?.id ?? step.id}',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      isThreeLine: true,
      trailing: const Icon(Icons.open_in_new),
      onTap: () => _launchQaStep(
        context,
        ref,
        lessonContent: lessonContent,
        targetStep: step,
      ),
    );
  }
}

String _stepType(LessonPlayerStep step) => step.stepType.name;

String _shorten(String value) {
  final normalized = value.replaceAll('\n', ' ');
  return normalized.length <= 100
      ? normalized
      : '${normalized.substring(0, 97)}…';
}

Future<void> _launchQaStep(
  BuildContext context,
  WidgetRef ref, {
  required LessonContent lessonContent,
  required LessonPlayerStep targetStep,
}) async {
  final lessonId = lessonContent.lesson.id;
  final sessionProvider = lessonPlayerSessionProvider(lessonId);
  ref.read(sessionProvider.notifier).state = const LessonPlayerSessionState();

  if (context.mounted) {
    context.goNamed(
      LessonRoute.name,
      pathParameters: {'lessonId': lessonId},
      extra: LessonLaunchIntent(
        lessonId: lessonId,
        mode: LessonLaunchMode.qa,
        initialStepId: targetStep.id,
      ),
    );
  }
}
