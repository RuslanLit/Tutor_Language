import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
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

    return LearningPathView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      state: state,
    );
  }
}

class LearningPathView extends StatelessWidget {
  const LearningPathView({
    required this.state,
    required this.padding,
    super.key,
  });

  final CourseNavigationState state;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding,
      children: [
        _CoursePathSummary(state: state),
        const SizedBox(height: 20),
        if (state.courseId == 'es.a0') const PronunciationPrimerTile(),
        if (state.courseId == 'es.a0') const SizedBox(height: 20),
        for (var unitIndex = 0; unitIndex < state.units.length; unitIndex++)
          ModulePathSection(
            courseId: state.courseId,
            unit: state.units[unitIndex],
            moduleIndex: unitIndex,
          ),
      ],
    );
  }
}

class _CoursePathSummary extends StatelessWidget {
  const _CoursePathSummary({required this.state});

  final CourseNavigationState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colors.primaryContainer.withValues(alpha: 0.42),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.courseTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colors.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.courseProgress(
                state.completedLessonCount,
                state.totalLessonCount,
              ),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onPrimaryContainer,
              ),
            ),
            if (state.isCourseCompleted) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.verified_outlined, color: colors.primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.courseComplete,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ModulePathSection extends ConsumerWidget {
  const ModulePathSection({
    required this.courseId,
    required this.unit,
    required this.moduleIndex,
    super.key,
  });

  final String courseId;
  final UnitNavigationState unit;
  final int moduleIndex;

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
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModulePathHeader(
            title: unit.title,
            moduleIndex: moduleIndex,
            moduleId: unit.unitId,
          ),
          if (unit.lessons.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(l10n.noLessonsAvailable),
            )
          else
            for (var index = 0; index < unit.lessons.length; index++)
              LessonPathNode(
                lesson: unit.lessons[index],
                ordinal: unit.lessons[index].position.indexInCourse,
              ),
          competencyProjections.when(
            data: (projections) => Column(
              children: [
                for (var index = 0; index < projections.length; index++)
                  CompetencyPathNode(
                    courseId: courseId,
                    projection: projections[index],
                    ordinal: unit.lessons.isEmpty
                        ? index + 1
                        : unit.lessons.last.position.indexInCourse + index + 1,
                  ),
              ],
            ),
            error: (error, stackTrace) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(l10n.competencyUnavailableWithError('$error')),
            ),
            loading: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class ModulePathHeader extends StatelessWidget {
  const ModulePathHeader({
    required this.title,
    required this.moduleIndex,
    required this.moduleId,
    super.key,
  });

  final String title;
  final int moduleIndex;
  final String moduleId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l10n = context.l10n;
    final moduleLabel = _moduleLabel(moduleId, l10n);

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4, bottom: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              '${moduleIndex + 1}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.onSecondaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleLarge),
                if (moduleLabel != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    moduleLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String? _moduleLabel(String moduleId, AppLocalizations l10n) {
  final match = RegExp(r'\.m0*([0-9]+)$').firstMatch(moduleId);
  if (match == null) {
    return null;
  }
  return l10n.moduleNumber(match.group(1)!);
}

class _PathNodeFrame extends StatelessWidget {
  const _PathNodeFrame({required this.ordinal, required this.child});

  final int ordinal;
  final Widget child;

  AlignmentDirectional get _alignment {
    return switch (ordinal % 3) {
      1 => const AlignmentDirectional(-0.72, 0),
      2 => AlignmentDirectional.center,
      _ => const AlignmentDirectional(0.72, 0),
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final nodeWidth = math.min(
          330.0,
          math.max(220.0, constraints.maxWidth - 24),
        );
        final colors = Theme.of(context).colorScheme;
        final connectorColor = colors.outlineVariant.withValues(alpha: 0.7);

        return SizedBox(
          height: 116,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PositionedDirectional(
                top: 0,
                bottom: 0,
                start: constraints.maxWidth / 2,
                child: Container(width: 2, color: connectorColor),
              ),
              Align(
                alignment: _alignment,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: nodeWidth),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LessonPathNode extends StatelessWidget {
  const LessonPathNode({
    required this.lesson,
    required this.ordinal,
    super.key,
  });

  final LessonNavigationState lesson;
  final int ordinal;

  @override
  Widget build(BuildContext context) {
    return _PathNodeFrame(
      ordinal: ordinal,
      child: _LessonNodeCard(lesson: lesson),
    );
  }
}

class _LessonNodeCard extends StatelessWidget {
  const _LessonNodeCard({required this.lesson});

  final LessonNavigationState lesson;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDebugQa = kDebugMode;
    final isCurrent = lesson.status == LessonNavigationStatus.available;
    final isCompleted = lesson.status == LessonNavigationStatus.completed;
    final foreground = lesson.status == LessonNavigationStatus.locked
        ? colors.onSurfaceVariant
        : colors.onSurface;

    return Card(
      margin: EdgeInsets.zero,
      elevation: isCurrent ? 4 : 0,
      color: isCurrent
          ? colors.primaryContainer
          : colors.surfaceContainerHighest.withValues(
              alpha: lesson.status == LessonNavigationStatus.locked
                  ? 0.52
                  : 0.82,
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isCurrent ? 22 : 18),
        side: BorderSide(
          color: isCurrent
              ? colors.primary
              : colors.outlineVariant.withValues(
                  alpha: lesson.status == LessonNavigationStatus.locked
                      ? 0.5
                      : 0.75,
                ),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(isCurrent ? 22 : 18),
        onTap: lesson.isTappable || isDebugQa
            ? () {
                context.goNamed(
                  LessonRoute.name,
                  pathParameters: {'lessonId': lesson.lessonId},
                  extra: LessonLaunchIntent(
                    lessonId: lesson.lessonId,
                    mode: isDebugQa
                        ? LessonLaunchMode.qa
                        : isCompleted
                        ? LessonLaunchMode.review
                        : LessonLaunchMode.learning,
                  ),
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              _PathStatusMarker(status: lesson.status),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: foreground,
                        fontWeight: isCurrent ? FontWeight.w700 : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${l10n.lessonNumber('${lesson.position.indexInCourse}')} · '
                      '${_statusLabel(lesson.status, l10n)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: foreground,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrent) ...[
                const SizedBox(width: 8),
                FilledButton.tonal(
                  onPressed: () {
                    context.goNamed(
                      LessonRoute.name,
                      pathParameters: {'lessonId': lesson.lessonId},
                      extra: LessonLaunchIntent(
                        lessonId: lesson.lessonId,
                        mode: isDebugQa
                            ? LessonLaunchMode.qa
                            : isCompleted
                            ? LessonLaunchMode.review
                            : LessonLaunchMode.learning,
                      ),
                    );
                  },
                  child: Text(l10n.start),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(LessonNavigationStatus status, AppLocalizations l10n) {
    return switch (status) {
      LessonNavigationStatus.completed => l10n.lessonStatusCompleted,
      LessonNavigationStatus.available => l10n.lessonStatusAvailableNext,
      LessonNavigationStatus.locked => l10n.lessonStatusLocked,
    };
  }
}

class _PathStatusMarker extends StatelessWidget {
  const _PathStatusMarker({required this.status});

  final LessonNavigationStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isCurrent = status == LessonNavigationStatus.available;
    final isLocked = status == LessonNavigationStatus.locked;
    final color = isLocked
        ? colors.onSurfaceVariant
        : isCurrent
        ? colors.primary
        : colors.tertiary;

    return Container(
      width: isCurrent ? 46 : 40,
      height: isCurrent ? 46 : 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: isLocked ? 0.12 : 0.16),
        border: Border.all(color: color, width: isCurrent ? 2 : 1.5),
      ),
      alignment: Alignment.center,
      child: Icon(switch (status) {
        LessonNavigationStatus.completed => Icons.check,
        LessonNavigationStatus.available => Icons.play_arrow_rounded,
        LessonNavigationStatus.locked => Icons.lock_outline,
      }, color: color),
    );
  }
}

class CompetencyPathNode extends StatelessWidget {
  const CompetencyPathNode({
    required this.courseId,
    required this.projection,
    required this.ordinal,
    super.key,
  });

  final String courseId;
  final ModuleCompetencyProjection projection;
  final int ordinal;

  @override
  Widget build(BuildContext context) {
    return _PathNodeFrame(
      ordinal: ordinal,
      child: _CompetencyNodeCard(courseId: courseId, projection: projection),
    );
  }
}

class _CompetencyNodeCard extends StatelessWidget {
  const _CompetencyNodeCard({required this.courseId, required this.projection});

  final String courseId;
  final ModuleCompetencyProjection projection;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final action = _actionLabel(projection, l10n);
    final enabled =
        projection.canStart || projection.canContinue || projection.canRetry;

    return Card(
      margin: EdgeInsets.zero,
      elevation: enabled ? 1 : 0,
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colors.secondary, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              _CheckpointMarker(state: projection.state),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title(projection.state, l10n),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(_subtitle(projection.state, l10n)),
                  ],
                ),
              ),
              if (action != null) ...[
                const SizedBox(width: 8),
                Text(action, style: theme.textTheme.labelLarge),
              ],
            ],
          ),
        ),
      ),
    );
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
    if (projection.canStart) return l10n.start;
    if (projection.canContinue) return l10n.continueAction;
    if (projection.canRetry) return l10n.retry;
    return null;
  }
}

class _CheckpointMarker extends StatelessWidget {
  const _CheckpointMarker({required this.state});

  final ModuleCompetencyState state;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final enabled = state != ModuleCompetencyState.moduleContentIncomplete;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colors.secondaryContainer.withValues(
          alpha: enabled ? 0.8 : 0.35,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.secondary),
      ),
      alignment: Alignment.center,
      child: Icon(_icon(state), color: colors.secondary),
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
