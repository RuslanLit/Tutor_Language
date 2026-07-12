import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../lesson_planning/lesson_plan.dart';
import '../lesson_player/lesson_player_screen.dart';
import 'lesson_launch_intent.dart';
import 'lesson_launch_providers.dart';

class LessonLaunchScreen extends ConsumerWidget {
  const LessonLaunchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(nextLessonPlanProvider);

    return plan.when(
      data: (plan) {
        if (plan.planType == LessonPlanType.courseComplete) {
          return const _CourseCompleteLaunchScreen();
        }
        final intent = LessonLaunchIntent.fromPlan(plan);
        return Column(
          children: [
            if (plan.planType == LessonPlanType.reinforcementRepeat)
              const MaterialBanner(
                content: Text(
                  'A quick repeat is recommended before continuing.',
                ),
                actions: [SizedBox.shrink()],
              ),
            Expanded(
              child: LessonPlayerScreen(
                lessonId: intent.lessonId,
                attemptPurpose: intent.attemptPurpose,
              ),
            ),
          ],
        );
      },
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('Lesson')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Unable to launch lesson.\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Lesson')),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _CourseCompleteLaunchScreen extends StatelessWidget {
  const _CourseCompleteLaunchScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Course complete',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.goNamed(CourseRoute.name),
                child: const Text('Back to course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
