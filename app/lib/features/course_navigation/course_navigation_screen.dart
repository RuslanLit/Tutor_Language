import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../shared/widgets/course_browser_error.dart';
import 'course_navigation_models.dart';
import 'course_navigation_providers.dart';

class CourseNavigationScreen extends ConsumerWidget {
  const CourseNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(courseNavigationStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Course')),
      body: navigationState.when(
        data: (state) => CourseNavigationView(state: state),
        error: (error, stackTrace) => CourseBrowserError(message: '$error'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class CourseNavigationView extends StatelessWidget {
  const CourseNavigationView({required this.state, super.key});

  final CourseNavigationState state;

  @override
  Widget build(BuildContext context) {
    if (state.units.isEmpty) {
      return const Center(child: Text('No units available.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          state.courseTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          '${state.completedLessonCount} of ${state.totalLessonCount} lessons completed',
        ),
        if (state.isCourseCompleted) ...[
          const SizedBox(height: 8),
          const Text('Course complete'),
        ],
        const SizedBox(height: 16),
        for (final unit in state.units) UnitNavigationSection(unit: unit),
      ],
    );
  }
}

class UnitNavigationSection extends StatelessWidget {
  const UnitNavigationSection({required this.unit, super.key});

  final UnitNavigationState unit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(unit.title, style: Theme.of(context).textTheme.titleLarge),
          if (unit.lessons.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('No lessons available.'),
            )
          else
            for (final lesson in unit.lessons)
              LessonNavigationTile(lesson: lesson),
        ],
      ),
    );
  }
}

class LessonNavigationTile extends StatelessWidget {
  const LessonNavigationTile({required this.lesson, super.key});

  final LessonNavigationState lesson;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(_statusIcon(lesson.status)),
      title: Text(lesson.title),
      subtitle: Text(_statusLabel(lesson.status)),
      enabled: lesson.isTappable,
      onTap: lesson.isTappable
          ? () {
              context.goNamed(
                LessonRoute.name,
                pathParameters: {'lessonId': lesson.lessonId},
              );
            }
          : null,
    );
  }

  IconData _statusIcon(LessonNavigationStatus status) {
    return switch (status) {
      LessonNavigationStatus.completed => Icons.check_circle_outline,
      LessonNavigationStatus.available => Icons.play_circle_outline,
      LessonNavigationStatus.locked => Icons.lock_outline,
    };
  }

  String _statusLabel(LessonNavigationStatus status) {
    return switch (status) {
      LessonNavigationStatus.completed => 'Completed',
      LessonNavigationStatus.available => 'Available next',
      LessonNavigationStatus.locked => 'Locked',
    };
  }
}
