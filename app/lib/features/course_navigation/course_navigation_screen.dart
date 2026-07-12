import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/learner/lesson_attempt.dart';
import '../communicative_competency/communicative_competency.dart';
import '../lesson_launch/lesson_launch_intent.dart';
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
        for (final unit in state.units)
          UnitNavigationSection(courseId: state.courseId, unit: unit),
      ],
    );
  }
}

class UnitNavigationSection extends ConsumerWidget {
  const UnitNavigationSection({
    required this.courseId,
    required this.unit,
    super.key,
  });

  final String courseId;
  final UnitNavigationState unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final competencyProjections = ref.watch(
      moduleCompetencyProjectionsProvider(
        ModuleCompetencyProjectionRequest(
          moduleId: unit.unitId,
          moduleContentComplete: unit.isCompleted,
          checkpointComplete: unit.isCompleted,
        ),
      ),
    );

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
          competencyProjections.when(
            data: (projections) => Column(
              children: [
                for (final projection in projections)
                  CompetencyNavigationTile(
                    courseId: courseId,
                    projection: projection,
                  ),
              ],
            ),
            error: (error, stackTrace) =>
                Text('Competency check unavailable: $error'),
            loading: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class CompetencyNavigationTile extends StatelessWidget {
  const CompetencyNavigationTile({
    required this.courseId,
    required this.projection,
    super.key,
  });

  final String courseId;
  final ModuleCompetencyProjection projection;

  @override
  Widget build(BuildContext context) {
    final action = _actionLabel(projection);
    final enabled =
        projection.canStart || projection.canContinue || projection.canRetry;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(_icon(projection.state)),
      title: Text(_title(projection.state)),
      subtitle: Text(_subtitle(projection.state)),
      trailing: action == null ? null : Text(action),
      enabled: enabled,
      onTap: enabled
          ? () {
              context.goNamed(
                CompetencyRoute.name,
                pathParameters: {
                  'courseId': courseId,
                  'moduleId': projection.moduleId,
                  'competencyId': projection.competencyId,
                },
                queryParameters: {if (projection.canRetry) 'retry': 'true'},
              );
            }
          : null,
    );
  }

  IconData _icon(ModuleCompetencyState state) {
    return switch (state) {
      ModuleCompetencyState.moduleContentIncomplete => Icons.lock_outline,
      ModuleCompetencyState.moduleContentCompleteCompetencyNotStarted =>
        Icons.flag_outlined,
      ModuleCompetencyState.competencyInProgress => Icons.play_circle_outline,
      ModuleCompetencyState.competencyAchieved => Icons.verified_outlined,
      ModuleCompetencyState.competencyAchievedWithReinforcement =>
        Icons.task_alt_outlined,
      ModuleCompetencyState.competencyPartiallyAchieved =>
        Icons.replay_circle_filled_outlined,
      ModuleCompetencyState.competencyNotYetAchieved =>
        Icons.replay_circle_filled_outlined,
    };
  }

  String _title(ModuleCompetencyState state) {
    return switch (state) {
      ModuleCompetencyState.moduleContentIncomplete =>
        'Communicative competency check',
      ModuleCompetencyState.moduleContentCompleteCompetencyNotStarted =>
        'Communicative competency check',
      ModuleCompetencyState.competencyInProgress =>
        'Communicative competency check',
      ModuleCompetencyState.competencyAchieved =>
        'Communicative competency achieved',
      ModuleCompetencyState.competencyAchievedWithReinforcement =>
        'Communicative competency achieved after review',
      ModuleCompetencyState.competencyPartiallyAchieved =>
        'Communicative competency needs more practice',
      ModuleCompetencyState.competencyNotYetAchieved =>
        'Communicative competency not yet achieved',
    };
  }

  String _subtitle(ModuleCompetencyState state) {
    return switch (state) {
      ModuleCompetencyState.moduleContentIncomplete =>
        'Complete this module first',
      ModuleCompetencyState.moduleContentCompleteCompetencyNotStarted =>
        'Ready to start',
      ModuleCompetencyState.competencyInProgress => 'Continue your check',
      ModuleCompetencyState.competencyAchieved =>
        'You demonstrated this module goal',
      ModuleCompetencyState.competencyAchievedWithReinforcement =>
        'You succeeded after targeted review',
      ModuleCompetencyState.competencyPartiallyAchieved =>
        'Retry the check when ready',
      ModuleCompetencyState.competencyNotYetAchieved =>
        'Retry the check when ready',
    };
  }

  String? _actionLabel(ModuleCompetencyProjection projection) {
    if (projection.canStart) {
      return 'Start';
    }
    if (projection.canContinue) {
      return 'Continue';
    }
    if (projection.canRetry) {
      return 'Retry';
    }
    return null;
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
                extra: LessonLaunchIntent(
                  lessonId: lesson.lessonId,
                  attemptPurpose:
                      lesson.status == LessonNavigationStatus.completed
                      ? LessonAttemptPurpose.manualRepeat
                      : LessonAttemptPurpose.normal,
                ),
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
