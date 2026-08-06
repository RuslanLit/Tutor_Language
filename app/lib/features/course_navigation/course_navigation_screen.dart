import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/learner/lesson_attempt.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../communicative_competency/communicative_competency.dart';
import '../lesson_launch/lesson_launch_intent.dart';
import '../pronunciation_primer/pronunciation_primer.dart';
import '../../shared/widgets/course_browser_error.dart';
import 'course_navigation_models.dart';
import 'course_navigation_providers.dart';

class CourseNavigationScreen extends ConsumerWidget {
  const CourseNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final navigationState = ref.watch(courseNavigationStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.courseTitle)),
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
    final l10n = context.l10n;

    if (state.units.isEmpty) {
      return Center(child: Text(l10n.noUnitsAvailable));
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
          l10n.courseProgress(
            state.completedLessonCount,
            state.totalLessonCount,
          ),
        ),
        if (state.isCourseCompleted) ...[
          const SizedBox(height: 8),
          Text(l10n.courseComplete),
        ],
        const SizedBox(height: 16),
        if (state.courseId == 'es.a0') const PronunciationPrimerTile(),
        for (final unit in state.units)
          UnitNavigationSection(courseId: state.courseId, unit: unit),
      ],
    );
  }
}

class PronunciationPrimerTile extends ConsumerWidget {
  const PronunciationPrimerTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final primerState = ref.watch(pronunciationPrimerStateProvider);

    return primerState.when(
      data: (state) => Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: Icon(
            state.isFinished ? Icons.verified_outlined : Icons.menu_book,
          ),
          title: Text(l10n.primerTitle),
          subtitle: Text(_subtitle(state, l10n)),
          trailing: Text(_action(state, l10n)),
          onTap: () => context.goNamed(PronunciationPrimerRoute.name),
        ),
      ),
      error: (error, stackTrace) => Card(
        child: ListTile(
          leading: const Icon(Icons.menu_book),
          title: Text(l10n.primerTitle),
          subtitle: Text(l10n.primerUnavailable),
          onTap: () => context.goNamed(PronunciationPrimerRoute.name),
        ),
      ),
      loading: () => const Card(
        child: ListTile(leading: Icon(Icons.menu_book), title: Text('…')),
      ),
    );
  }

  String _subtitle(PronunciationPrimerState state, AppLocalizations l10n) {
    return switch (state.status) {
      PronunciationPrimerStatus.notSeen => l10n.primerSubtitle,
      PronunciationPrimerStatus.started => l10n.primerInProgress,
      PronunciationPrimerStatus.completed => l10n.primerCompleted,
      PronunciationPrimerStatus.skipped => l10n.primerSkipped,
    };
  }

  String _action(PronunciationPrimerState state, AppLocalizations l10n) {
    return switch (state.status) {
      PronunciationPrimerStatus.notSeen => l10n.primerStart,
      PronunciationPrimerStatus.started => l10n.continueAction,
      PronunciationPrimerStatus.completed => l10n.primerReview,
      PronunciationPrimerStatus.skipped => l10n.primerReview,
    };
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
    final l10n = context.l10n;
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
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(l10n.noLessonsAvailable),
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
                Text(l10n.competencyUnavailableWithError('$error')),
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
    final l10n = context.l10n;
    final action = _actionLabel(projection, l10n);
    final enabled =
        projection.canStart || projection.canContinue || projection.canRetry;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(_icon(projection.state)),
      title: Text(_title(projection.state, l10n)),
      subtitle: Text(_subtitle(projection.state, l10n)),
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

  String _title(ModuleCompetencyState state, AppLocalizations l10n) {
    return switch (state) {
      ModuleCompetencyState.moduleContentIncomplete => l10n.competencyCheck,
      ModuleCompetencyState.moduleContentCompleteCompetencyNotStarted =>
        l10n.competencyCheck,
      ModuleCompetencyState.competencyInProgress => l10n.competencyCheck,
      ModuleCompetencyState.competencyAchieved => l10n.competencyAchieved,
      ModuleCompetencyState.competencyAchievedWithReinforcement =>
        l10n.competencyAchievedAfterReview,
      ModuleCompetencyState.competencyPartiallyAchieved =>
        l10n.competencyNeedsPractice,
      ModuleCompetencyState.competencyNotYetAchieved =>
        l10n.competencyNotYetAchieved,
    };
  }

  String _subtitle(ModuleCompetencyState state, AppLocalizations l10n) {
    return switch (state) {
      ModuleCompetencyState.moduleContentIncomplete =>
        l10n.competencyCompleteModuleFirst,
      ModuleCompetencyState.moduleContentCompleteCompetencyNotStarted =>
        l10n.competencyReadyToStart,
      ModuleCompetencyState.competencyInProgress =>
        l10n.competencyContinueCheck,
      ModuleCompetencyState.competencyAchieved =>
        l10n.competencyGoalDemonstrated,
      ModuleCompetencyState.competencyAchievedWithReinforcement =>
        l10n.competencySucceededAfterReview,
      ModuleCompetencyState.competencyPartiallyAchieved =>
        l10n.competencyRetryWhenReady,
      ModuleCompetencyState.competencyNotYetAchieved =>
        l10n.competencyRetryWhenReady,
    };
  }

  String? _actionLabel(
    ModuleCompetencyProjection projection,
    AppLocalizations l10n,
  ) {
    if (projection.canStart) {
      return l10n.start;
    }
    if (projection.canContinue) {
      return l10n.continueAction;
    }
    if (projection.canRetry) {
      return l10n.retry;
    }
    return null;
  }
}

class LessonNavigationTile extends StatelessWidget {
  const LessonNavigationTile({required this.lesson, super.key});

  final LessonNavigationState lesson;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(_statusIcon(lesson.status)),
      title: Text(lesson.title),
      subtitle: Text(
        '${l10n.lessonNumber('${lesson.position.indexInCourse}')} · '
        '${_statusLabel(lesson.status, l10n)}',
      ),
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

  String _statusLabel(LessonNavigationStatus status, AppLocalizations l10n) {
    return switch (status) {
      LessonNavigationStatus.completed => l10n.lessonStatusCompleted,
      LessonNavigationStatus.available => l10n.lessonStatusAvailableNext,
      LessonNavigationStatus.locked => l10n.lessonStatusLocked,
    };
  }
}
