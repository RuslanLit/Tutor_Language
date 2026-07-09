import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lesson_player/lesson_player_screen.dart';
import 'lesson_launch_providers.dart';

class LessonLaunchScreen extends ConsumerWidget {
  const LessonLaunchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(nextLessonPlanProvider);

    return plan.when(
      data: (plan) => LessonPlayerScreen(lessonId: plan.selectedLessonId),
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
