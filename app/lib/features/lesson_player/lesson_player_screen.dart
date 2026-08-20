import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/content/content_localization_providers.dart';
import '../../core/audio/reference_audio_button.dart';
import '../../core/content/pronunciation_models.dart';
import '../../core/content/pronunciation_providers.dart';
import '../../core/content/topic_content.dart';
import '../../core/content/spoken_practice.dart';
import '../../core/learner/lesson_attempt.dart';
import '../../core/learner/learner_progress.dart';
import '../../core/learner/learner_progress_providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/course_browser_error.dart';
import '../activity_engine/activity_template_state.dart';
import '../activity_engine/activity_widgets.dart';
import '../course_navigation/course_navigation_models.dart';
import '../curriculum/curriculum_models.dart';
import '../course_navigation/course_navigation_providers.dart';
import '../lesson_assembly/lesson_content.dart';
import '../lesson_launch/lesson_launch_intent.dart';
import '../lesson_session/lesson_attempt_snapshot_factory.dart';
import '../lesson_session/lesson_session_engine.dart';
import 'lesson_player_providers.dart';
import 'lesson_player_step.dart';
import 'spoken_practice_view.dart';
import 'spoken_practice_controller.dart';

class LessonPlayerScreen extends ConsumerWidget {
  const LessonPlayerScreen({
    required this.lessonId,
    this.attemptPurpose = LessonAttemptPurpose.normal,
    this.reviewMode = false,
    this.qaMode = false,
    this.initialStepId,
    this.persistCompletion = true,
    this.qaBannerLabel,
    super.key,
  });

  final String lessonId;
  final LessonAttemptPurpose attemptPurpose;
  final bool reviewMode;
  final bool qaMode;
  final String? initialStepId;
  final bool persistCompletion;
  final String? qaBannerLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lessonContent = ref.watch(assembledLessonProvider(lessonId));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _handleLessonExit(
          context,
          ref,
          lessonId: lessonId,
          dismissKeyboardFirst: true,
        );
      },
      child: Scaffold(
        appBar: AppBar(
          leading: _LessonExitButton(lessonId: lessonId),
          title: lessonContent.when(
            data: (content) => _LessonAppBarTitle(lesson: content.lesson),
            loading: () => Text(l10n.lessonPlayerTitle),
            error: (_, _) => Text(l10n.lessonPlayerTitle),
          ),
        ),
        body: lessonContent.when(
          data: (lessonContent) => LessonPlayerView(
            lessonContent: lessonContent,
            attemptPurpose: attemptPurpose,
            reviewMode: reviewMode,
            qaMode: qaMode,
            initialStepId: initialStepId,
            persistCompletion: persistCompletion,
            qaBannerLabel: qaBannerLabel,
          ),
          error: (error, stackTrace) => CourseBrowserError(message: '$error'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _LessonExitButton extends ConsumerWidget {
  const _LessonExitButton({required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return IconButton(
      tooltip: l10n.backToCourse,
      onPressed: () => _handleLessonExit(context, ref, lessonId: lessonId),
      icon: const Icon(Icons.arrow_back),
    );
  }
}

class _LessonAppBarTitle extends StatelessWidget {
  const _LessonAppBarTitle({required this.lesson});

  final LessonDefinition lesson;

  @override
  Widget build(BuildContext context) {
    return Text(lesson.title);
  }
}

Future<void> _handleLessonExit(
  BuildContext context,
  WidgetRef ref, {
  required String lessonId,
  bool dismissKeyboardFirst = false,
}) async {
  final focus = FocusManager.instance.primaryFocus;
  final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
  if (dismissKeyboardFirst &&
      isKeyboardVisible &&
      focus != null &&
      focus.hasFocus) {
    focus.unfocus();
    return;
  }

  final session = ref.read(lessonPlayerSessionProvider(lessonId));
  final isSessionCompleted =
      session.sessionState.status == LessonSessionStatus.completed ||
      session.completionPersistenceStatus ==
          LessonCompletionPersistenceStatus.persisted;
  final hasDurableCompletion = await _hasDurableLessonCompletion(ref, lessonId);

  if (!context.mounted) {
    return;
  }
  final l10n = context.l10n;

  if (isSessionCompleted || hasDurableCompletion) {
    _returnToCourse(context);
    return;
  }

  final shouldLeave = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.leaveLessonTitle),
      content: Text(l10n.leaveLessonBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.stay),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.leaveLesson),
        ),
      ],
    ),
  );

  if (shouldLeave != true || !context.mounted) {
    return;
  }

  ref.read(lessonPlayerSessionProvider(lessonId).notifier).state =
      const LessonPlayerSessionState();

  if (context.mounted) {
    _returnToCourse(context);
  }
}

Future<bool> _hasDurableLessonCompletion(WidgetRef ref, String lessonId) async {
  try {
    final progress = await ref.read(topicProgressProvider(lessonId).future);
    return progress.hasBeenCompleted;
  } catch (_) {
    return false;
  }
}

void _returnToCourse(BuildContext context) {
  if (context.canPop()) {
    context.pop();
    return;
  }

  context.goNamed(CourseRoute.name);
}

class LessonPlayerView extends ConsumerWidget {
  const LessonPlayerView({
    required this.lessonContent,
    this.attemptPurpose = LessonAttemptPurpose.normal,
    this.reviewMode = false,
    this.qaMode = false,
    this.initialStepId,
    this.persistCompletion = true,
    this.qaBannerLabel,
    super.key,
  });

  final LessonContent lessonContent;
  final LessonAttemptPurpose attemptPurpose;
  final bool reviewMode;
  final bool qaMode;
  final String? initialStepId;
  final bool persistCompletion;
  final String? qaBannerLabel;
  static const _stepBuilder = LessonPlayerStepBuilder();
  static const _sessionEngine = LessonSessionEngine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lesson = lessonContent.lesson;
    final lessonPosition = ref
        .watch(orderedCourseLessonsProvider)
        .maybeWhen(
          data: (orderedLessons) {
            for (final orderedLesson in orderedLessons) {
              if (orderedLesson.lesson.id == lesson.id) {
                return orderedLesson.position;
              }
            }
            return null;
          },
          orElse: () => null,
        );
    final steps = _stepBuilder.buildSteps(lessonContent);
    final resumeCursor = qaMode
        ? const AsyncValue<LessonResumeCursor?>.data(null)
        : ref.watch(
            lessonResumeCursorProvider(
              LessonResumeCursorRequest(
                lessonId: lesson.id,
                attemptPurpose: attemptPurpose,
              ),
            ),
          );
    if (resumeCursor.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final restoredCursor = resumeCursor.when(
      data: (cursor) => cursor,
      loading: () => null,
      error: (error, stackTrace) {
        if (kDebugMode) {
          debugPrint(
            '[lesson_resume] load-failed lesson=${lesson.id} error=$error',
          );
        }
        return null;
      },
    );
    final sessionProvider = lessonPlayerSessionProvider(lesson.id);
    final session = ref.watch(sessionProvider);
    final activeSession = session.ensureStarted(
      lessonId: lesson.id,
      steps: steps,
      attemptPurpose: attemptPurpose,
      reviewMode: reviewMode,
      resumeCursor: restoredCursor,
      initialStepId: initialStepId,
    );
    if (!identical(activeSession, session)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(sessionProvider.notifier).state = activeSession;
        if (!qaMode && activeSession.sessionState.currentStepId != null) {
          _persistResumeCursor(
            ref,
            lesson: lesson,
            session: activeSession,
            stepId: activeSession.sessionState.currentStepId!,
            stepIndex: activeSession.sessionState.currentStepIndex,
            furthestReachedStepIndex:
                activeSession.sessionState.furthestReachedStepIndex,
          );
        }
      });
    }
    final activeStepIds = activeSession.sessionState.orderedStepIds;
    final stepById = {for (final step in steps) step.id: step};
    final currentStepIndex = activeStepIds.isEmpty
        ? 0
        : activeSession.sessionState.currentStepIndex.clamp(
            0,
            activeStepIds.length - 1,
          );
    final currentStepId = activeStepIds.isEmpty
        ? null
        : activeStepIds[currentStepIndex];
    final currentStep = currentStepId == null
        ? null
        : _resolveRuntimeStep(
            runtimeStepId: currentStepId,
            stepById: stepById,
            sessionState: activeSession.sessionState,
          );
    final spokenPractice = currentStep == null
        ? null
        : _firstSpokenPractice(currentStep.content);
    final spokenPracticeController = spokenPractice == null
        ? null
        : ref.watch(spokenPracticeControllerProvider(spokenPractice));
    final canAdvanceCurrentStep =
        reviewMode ||
        spokenPracticeController == null ||
        spokenPracticeController.stage == SpokenPracticeStage.completed;
    if (kDebugMode && spokenPractice != null) {
      debugPrint(
        '[af4_spoken] lesson-player-gate activity=${spokenPractice.id} '
        'controller=${identityHashCode(spokenPracticeController)} '
        'stage=${spokenPracticeController?.stage} '
        'canAdvance=$canAdvanceCurrentStep',
      );
    }

    final stepView = currentStep == null
        ? null
        : LessonPlayerStepView(
            step: currentStep,
            state: activeSession.stepStates[currentStep.id],
            masteryAssessment: activeSession
                .sessionState
                .masteryAssessmentByStepId[currentStep.id],
            showRemediation: activeSession.sessionState.remediationShownByStepId
                .contains(currentStep.id),
            reviewMode: reviewMode,
            onStateChanged: (stepState) {
              final nextStepStates = {
                ...activeSession.stepStates,
                currentStep.id: stepState,
              };

              var nextSessionState = activeSession.sessionState;
              final result = stepState.result;
              final isIntermediateGuidedDialogue =
                  currentStep.content.whereType<ExerciseTemplate>().any(
                    (template) => template.exerciseType == 'guided_dialogue',
                  ) &&
                  !stepState.dialogueCompleted;
              if (result != null && !isIntermediateGuidedDialogue) {
                final decision = _sessionEngine.submitStepResult(
                  state: nextSessionState,
                  result: result,
                );
                nextSessionState = decision.updatedState;
              } else if (nextSessionState.resultByStepId.containsKey(
                currentStep.id,
              )) {
                final decision = _sessionEngine.restartCurrentStep(
                  nextSessionState,
                );
                nextSessionState = decision.updatedState;
              }

              ref.read(sessionProvider.notifier).state = activeSession.copyWith(
                sessionState: nextSessionState,
                stepStates: nextStepStates,
              );
            },
          );

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              key: ValueKey(
                'lesson.${lesson.id}.step.${currentStep?.id ?? 'empty'}',
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              children: [
                if (qaBannerLabel != null) ...[
                  _QaLessonBanner(label: qaBannerLabel!),
                  const SizedBox(height: 12),
                ],
                _LessonHeader(lesson: lesson, position: lessonPosition),
                if (activeStepIds.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _LessonProgressIndicator(
                    currentStepIndex: currentStepIndex,
                    stepCount: activeStepIds.length,
                  ),
                ],
                const SizedBox(height: 12),
                stepView ?? Text(l10n.noActivitiesAvailable),
              ],
            ),
          ),
          if (currentStep != null) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LessonNavigationControls(
                lessonId: lesson.id,
                lessonTitle: lesson.title,
                courseId: lesson.courseId,
                stepCount: activeStepIds.length,
                steps: steps,
                currentStepIndex: currentStepIndex,
                session: activeSession,
                persistCompletion: persistCompletion,
                canAdvanceCurrentStep: canAdvanceCurrentStep,
                reviewMode: reviewMode,
                qaMode: qaMode,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QaLessonBanner extends StatelessWidget {
  const _QaLessonBanner({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        color: Colors.yellow.shade100,
      ),
      child: Padding(padding: const EdgeInsets.all(12), child: Text(label)),
    );
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({required this.lesson, this.position});

  final LessonDefinition lesson;
  final LessonPosition? position;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (_moduleLabel(lesson.moduleId, l10n) != null)
              _MetadataChip(label: _moduleLabel(lesson.moduleId, l10n)!),
            if (position != null)
              _MetadataChip(
                label: l10n.lessonNumber('${position!.indexInCourse}'),
              ),
            if (lesson.difficulty.isNotEmpty)
              _MetadataChip(label: lesson.difficulty),
          ],
        ),
        if (lesson.description.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(lesson.description),
        ],
      ],
    );
  }
}

class _LessonProgressIndicator extends StatelessWidget {
  const _LessonProgressIndicator({
    required this.currentStepIndex,
    required this.stepCount,
  });

  final int currentStepIndex;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    final value = ((currentStepIndex + 1) / stepCount).clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 7,
        semanticsLabel: context.l10n.stepCounter(
          currentStepIndex + 1,
          stepCount,
        ),
      ),
    );
  }
}

LessonPlayerStep? _resolveRuntimeStep({
  required String runtimeStepId,
  required Map<String, LessonPlayerStep> stepById,
  required LessonSessionState sessionState,
}) {
  final canonicalStep = stepById[runtimeStepId];
  if (canonicalStep != null) {
    return canonicalStep;
  }

  final authoredSourceStepId =
      sessionState.authoredReviewStepIdByInsertedStepId[runtimeStepId];
  final authoredSourceStep = authoredSourceStepId == null
      ? null
      : stepById[authoredSourceStepId];
  if (authoredSourceStep == null) {
    return null;
  }

  return authoredSourceStep.copyWith(
    id: runtimeStepId,
    isInsertedReview: true,
    originatingStepId:
        sessionState.originatingStepIdByReviewStepId[runtimeStepId],
    authoredSourceStepId: authoredSourceStepId,
  );
}

class LessonNavigationControls extends ConsumerStatefulWidget {
  const LessonNavigationControls({
    required this.lessonId,
    required this.lessonTitle,
    required this.courseId,
    required this.stepCount,
    required this.steps,
    required this.currentStepIndex,
    required this.session,
    this.reviewMode = false,
    this.qaMode = false,
    this.persistCompletion = true,
    this.canAdvanceCurrentStep = true,
    super.key,
  });

  final String lessonId;
  final String lessonTitle;
  final String courseId;
  final int stepCount;
  final List<LessonPlayerStep> steps;
  final int currentStepIndex;
  final LessonPlayerSessionState session;
  final bool reviewMode;
  final bool qaMode;
  final bool persistCompletion;
  final bool canAdvanceCurrentStep;

  @override
  ConsumerState<LessonNavigationControls> createState() =>
      _LessonNavigationControlsState();
}

class _LessonNavigationControlsState
    extends ConsumerState<LessonNavigationControls> {
  bool _isCompleting = false;
  String? _completionError;
  static const _sessionEngine = LessonSessionEngine();
  static const _snapshotFactory = LessonAttemptSnapshotFactory();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final progress = ref.watch(topicProgressProvider(widget.lessonId));
    final isLastStep = widget.currentStepIndex == widget.stepCount - 1;
    final previousDecision = _sessionEngine.requestPrevious(
      widget.session.sessionState,
    );
    final nextDecision = _sessionEngine.requestNext(
      widget.session.sessionState,
      allowReviewNavigation: widget.reviewMode || widget.qaMode,
    );
    final finishDecision = _sessionEngine.finishSession(
      widget.session.sessionState,
    );
    final canGoPrevious =
        previousDecision.type == LessonSessionDecisionType.moveToPreviousStep;
    final canGoNext =
        widget.canAdvanceCurrentStep &&
        nextDecision.type == LessonSessionDecisionType.moveToNextStep;
    final isPersisting =
        widget.session.completionPersistenceStatus ==
        LessonCompletionPersistenceStatus.persisting;
    final canFinish =
        widget.canAdvanceCurrentStep &&
        finishDecision.type == LessonSessionDecisionType.finishLesson;
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: keyboardVisible ? 0 : 24),
      child: progress.when(
        data: (progress) {
          final isCompleted =
              !widget.reviewMode &&
              !widget.qaMode &&
              ((widget.session.attemptPurpose == LessonAttemptPurpose.normal &&
                      progress.hasBeenCompleted) ||
                  widget.session.sessionState.status ==
                      LessonSessionStatus.completed);
          if (!isCompleted) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_completionError != null ||
                    widget.session.completionError != null) ...[
                  Text(_completionError ?? widget.session.completionError!),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: canGoPrevious ? _goToPreviousStep : null,
                      style: _navigationButtonStyle(),
                      child: Text(l10n.previous),
                    ),
                    const Spacer(),
                    Text(
                      l10n.stepCounter(
                        widget.currentStepIndex + 1,
                        widget.stepCount,
                      ),
                    ),
                    const Spacer(),
                    if (isLastStep && widget.reviewMode)
                      _ReviewFinalStepAction(lessonId: widget.lessonId)
                    else if (isLastStep)
                      FilledButton(
                        onPressed: _isCompleting || isPersisting || !canFinish
                            ? null
                            : _completeLesson,
                        style: _navigationButtonStyle(),
                        child: Text(
                          _isCompleting || isPersisting
                              ? l10n.finishing
                              : l10n.finishLesson,
                        ),
                      )
                    else
                      FilledButton(
                        onPressed: canGoNext ? _goToNextStep : null,
                        style: _navigationButtonStyle(),
                        child: Text(l10n.next),
                      ),
                  ],
                ),
              ],
            );
          }

          final nextLesson = ref.watch(
            nextOrderedLessonProvider(widget.lessonId),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.lessonCompleted,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.lessonTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.session.lessonOutcome != null) ...[
                const SizedBox(height: 4),
                _LessonOutcomeLabel(outcome: widget.session.lessonOutcome!),
              ],
              const SizedBox(height: 8),
              nextLesson.when(
                data: (nextLesson) {
                  if (nextLesson == null) {
                    return _CourseCompletionActions(
                      lessonId: widget.lessonId,
                      lessonOutcome: widget.session.lessonOutcome,
                      steps: widget.steps,
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RepeatLessonButton(
                        lessonId: widget.lessonId,
                        steps: widget.steps,
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () {
                          context.goNamed(
                            LessonRoute.name,
                            pathParameters: {'lessonId': nextLesson.lesson.id},
                            extra: LessonLaunchIntent(
                              lessonId: nextLesson.lesson.id,
                              attemptPurpose: LessonAttemptPurpose.normal,
                            ),
                          );
                        },
                        child: Text(l10n.continueToNextLesson),
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) =>
                    CourseBrowserError(message: '$error'),
                loading: () => const CircularProgressIndicator(),
              ),
            ],
          );
        },
        error: (error, stackTrace) => CourseBrowserError(message: '$error'),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }

  ButtonStyle _navigationButtonStyle() {
    return TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    );
  }

  Future<void> _completeLesson() async {
    final l10n = context.l10n;
    if (_isCompleting ||
        widget.session.completionPersistenceStatus ==
            LessonCompletionPersistenceStatus.persisting ||
        widget.session.completionPersistenceStatus ==
            LessonCompletionPersistenceStatus.persisted) {
      return;
    }

    final decision = _sessionEngine.finishSession(widget.session.sessionState);
    if (decision.type != LessonSessionDecisionType.finishLesson) {
      return;
    }

    final completedAt =
        widget.session.completionCompletedAt ?? DateTime.now().toUtc();
    final attemptId =
        widget.session.attemptId ??
        widget.session.completionAttemptId ??
        '${completedAt.microsecondsSinceEpoch}.${widget.lessonId}.attempt';
    final pendingSession = widget.session.copyWith(
      completionAttemptId: attemptId,
      completionCompletedAt: completedAt,
      completionPersistenceStatus: LessonCompletionPersistenceStatus.persisting,
      completionError: null,
    );

    ref.read(lessonPlayerSessionProvider(widget.lessonId).notifier).state =
        pendingSession;

    setState(() {
      _isCompleting = true;
      _completionError = null;
    });

    if (!widget.persistCompletion) {
      ref
          .read(lessonPlayerSessionProvider(widget.lessonId).notifier)
          .state = pendingSession.copyWith(
        sessionState: decision.updatedState,
        lessonOutcome: decision.lessonOutcome,
        completionAttemptId: attemptId,
        completionCompletedAt: completedAt,
        completionPersistenceStatus:
            LessonCompletionPersistenceStatus.notRequested,
        completionError: null,
      );
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
      return;
    }

    try {
      final command = _snapshotFactory.create(
        attemptId: attemptId,
        lessonId: widget.lessonId,
        courseId: widget.courseId,
        purpose: widget.session.attemptPurpose,
        finalState: decision.updatedState,
        finishDecision: decision,
        completedAt: completedAt,
        startedAt: widget.session.attemptStartedAt,
      );
      final result = await ref
          .read(learnerProgressRepositoryProvider)
          .recordCompletedLessonAttempt(command);
      if (!result.isSuccess) {
        ref
            .read(lessonPlayerSessionProvider(widget.lessonId).notifier)
            .state = pendingSession.copyWith(
          completionPersistenceStatus: LessonCompletionPersistenceStatus.failed,
          completionError: l10n.completionSaveError,
        );
        if (mounted) {
          setState(() {
            _completionError = l10n.completionSaveError;
            _isCompleting = false;
          });
        }
        return;
      }
    } catch (_) {
      ref
          .read(lessonPlayerSessionProvider(widget.lessonId).notifier)
          .state = pendingSession.copyWith(
        completionPersistenceStatus: LessonCompletionPersistenceStatus.failed,
        completionError: l10n.completionSaveError,
      );
      if (mounted) {
        setState(() {
          _completionError = l10n.completionSaveError;
          _isCompleting = false;
        });
      }
      return;
    }

    ref
        .read(lessonPlayerSessionProvider(widget.lessonId).notifier)
        .state = pendingSession.copyWith(
      sessionState: decision.updatedState,
      lessonOutcome: decision.lessonOutcome,
      completionAttemptId: attemptId,
      completionCompletedAt: completedAt,
      completionPersistenceStatus: LessonCompletionPersistenceStatus.persisted,
      completionError: null,
    );

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
    final decision = _sessionEngine.requestPrevious(
      widget.session.sessionState,
    );
    if (decision.type != LessonSessionDecisionType.moveToPreviousStep) {
      return;
    }

    final updatedSession = widget.session.copyWith(
      sessionState: decision.updatedState,
    );
    ref.read(lessonPlayerSessionProvider(widget.lessonId).notifier).state =
        updatedSession;
    if (!widget.qaMode) {
      _persistResumeCursor(
        ref,
        lessonId: widget.lessonId,
        courseId: widget.courseId,
        session: updatedSession,
        stepId: decision.updatedState.currentStepId!,
        stepIndex: decision.updatedState.currentStepIndex,
        furthestReachedStepIndex:
            decision.updatedState.furthestReachedStepIndex,
      );
    }
  }

  void _goToNextStep() {
    final decision = _sessionEngine.requestNext(
      widget.session.sessionState,
      allowReviewNavigation: widget.reviewMode || widget.qaMode,
    );
    if (decision.type != LessonSessionDecisionType.moveToNextStep) {
      return;
    }

    final updatedSession = widget.session.copyWith(
      sessionState: decision.updatedState,
    );
    ref.read(lessonPlayerSessionProvider(widget.lessonId).notifier).state =
        updatedSession;
    if (!widget.qaMode) {
      _persistResumeCursor(
        ref,
        lessonId: widget.lessonId,
        courseId: widget.courseId,
        session: updatedSession,
        stepId: decision.updatedState.currentStepId!,
        stepIndex: decision.updatedState.currentStepIndex,
        furthestReachedStepIndex:
            decision.updatedState.furthestReachedStepIndex,
      );
    }
  }
}

void _persistResumeCursor(
  WidgetRef ref, {
  Lesson? lesson,
  String? lessonId,
  String? courseId,
  required LessonPlayerSessionState session,
  required String stepId,
  required int stepIndex,
  required int furthestReachedStepIndex,
}) {
  final resolvedLessonId = lesson?.id ?? lessonId;
  final resolvedCourseId = lesson?.courseId ?? courseId;
  final attemptId = session.attemptId;
  final startedAt = session.attemptStartedAt;
  if (resolvedLessonId == null ||
      resolvedCourseId == null ||
      attemptId == null ||
      startedAt == null) {
    return;
  }
  unawaited(
    ref
        .read(learnerProgressRepositoryProvider)
        .saveLessonResumeCursor(
          LessonResumeCursor(
            lessonId: resolvedLessonId,
            courseId: resolvedCourseId,
            attemptId: attemptId,
            attemptPurpose: session.attemptPurpose,
            stepId: stepId,
            stepIndex: stepIndex,
            furthestReachedStepIndex: furthestReachedStepIndex,
            startedAt: startedAt,
            savedAt: DateTime.now().toUtc(),
          ),
        )
        .catchError((error) {
          if (kDebugMode) {
            debugPrint('[lesson_resume] save-failed error=$error');
          }
        }),
  );
}

class _CourseCompletionActions extends ConsumerWidget {
  const _CourseCompletionActions({
    required this.lessonId,
    required this.steps,
    this.lessonOutcome,
  });

  final String lessonId;
  final List<LessonPlayerStep> steps;
  final LessonOutcome? lessonOutcome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.courseComplete,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (lessonOutcome != null) ...[
          const SizedBox(height: 4),
          _LessonOutcomeLabel(outcome: lessonOutcome!),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: () {
                context.goNamed(CourseRoute.name);
              },
              child: Text(l10n.backToCourse),
            ),
            OutlinedButton(
              onPressed: () {
                context.goNamed(CourseRoute.name);
              },
              child: Text(l10n.reviewCompletedLessons),
            ),
            _RepeatLessonButton(lessonId: lessonId, steps: steps),
          ],
        ),
      ],
    );
  }
}

class _ReviewFinalStepAction extends ConsumerWidget {
  const _ReviewFinalStepAction({required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final nextLesson = ref.watch(nextAvailableLessonProvider(lessonId));

    return nextLesson.when(
      data: (nextLesson) => FilledButton(
        onPressed: () {
          if (nextLesson == null) {
            context.goNamed(CourseRoute.name);
            return;
          }
          context.goNamed(
            LessonRoute.name,
            pathParameters: {'lessonId': nextLesson.lesson.id},
            extra: LessonLaunchIntent(
              lessonId: nextLesson.lesson.id,
              attemptPurpose: LessonAttemptPurpose.normal,
            ),
          );
        },
        child: Text(
          nextLesson == null ? l10n.backToCourse : l10n.continueToNextLesson,
        ),
      ),
      error: (error, stackTrace) => FilledButton(
        onPressed: () => context.goNamed(CourseRoute.name),
        child: Text(l10n.backToCourse),
      ),
      loading: () => const SizedBox(
        width: 48,
        height: 48,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _RepeatLessonButton extends ConsumerWidget {
  const _RepeatLessonButton({required this.lessonId, required this.steps});

  final String lessonId;
  final List<LessonPlayerStep> steps;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton(
          onPressed: () =>
              _startManualRepeat(context, ref, lessonId, steps: steps),
          child: Text(l10n.repeatLesson),
        ),
        OutlinedButton(
          onPressed: () => _chooseRepeatStep(context, ref, lessonId, steps),
          child: Text(l10n.repeatFromStep),
        ),
      ],
    );
  }
}

Future<void> _chooseRepeatStep(
  BuildContext context,
  WidgetRef ref,
  String lessonId,
  List<LessonPlayerStep> steps,
) async {
  final l10n = context.l10n;
  final selectedStep = await showDialog<LessonPlayerStep>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.repeatFromStep),
      content: SizedBox(
        width: 420,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final step = steps[index];
            return ListTile(
              title: Text(l10n.stepCounter(index + 1, steps.length)),
              subtitle: Text(step.sourceActivity.activity.title),
              onTap: () => Navigator.of(context).pop(step),
            );
          },
        ),
      ),
    ),
  );

  if (selectedStep != null && context.mounted) {
    _startManualRepeat(
      context,
      ref,
      lessonId,
      steps: steps,
      initialStepId: selectedStep.id,
    );
  }
}

void _startManualRepeat(
  BuildContext context,
  WidgetRef ref,
  String lessonId, {
  required List<LessonPlayerStep> steps,
  String? initialStepId,
}) {
  final session = const LessonPlayerSessionState().ensureStarted(
    lessonId: lessonId,
    steps: steps,
    attemptPurpose: LessonAttemptPurpose.manualRepeat,
    initialStepId: initialStepId,
  );
  ref.read(lessonPlayerSessionProvider(lessonId).notifier).state = session;
  context.goNamed(
    LessonRoute.name,
    pathParameters: {'lessonId': lessonId},
    extra: LessonLaunchIntent(
      lessonId: lessonId,
      attemptPurpose: LessonAttemptPurpose.manualRepeat,
      initialStepId: initialStepId,
    ),
  );
}

class _LessonOutcomeLabel extends StatelessWidget {
  const _LessonOutcomeLabel({required this.outcome});

  final LessonOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Text(switch (outcome.status) {
      LessonOutcomeStatus.mastered => l10n.lessonMastered,
      LessonOutcomeStatus.completedWithReinforcement =>
        l10n.someTopicsNeedReinforcement,
      LessonOutcomeStatus.incomplete => l10n.lessonIncompleteOutcome,
    });
  }
}

class LessonPlayerStepView extends StatelessWidget {
  const LessonPlayerStepView({
    required this.step,
    this.state,
    this.masteryAssessment,
    this.showRemediation = false,
    this.reviewMode = false,
    this.onStateChanged,
    super.key,
  });

  final LessonPlayerStep step;
  final ActivityTemplateState? state;
  final StepMasteryAssessment? masteryAssessment;
  final bool showRemediation;
  final bool reviewMode;
  final ValueChanged<ActivityTemplateState>? onStateChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step.isInsertedReview
                  ? l10n.quickReview
                  : step.sourceActivity.activity.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            if (step.isInsertedReview) ...[
              Text(
                step.sourceActivity.activity.title,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
            ],
            if (step.isInsertedReview && !_hasReadingRulePresentation(step))
              Text(
                _stepTypeLabel(step.stepType, l10n),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            const SizedBox(height: 12),
            for (final content in step.content)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: LessonContentObjectView(
                  content: content,
                  state: state,
                  showRemediation: showRemediation,
                  reviewMode: reviewMode,
                  onStateChanged: onStateChanged,
                ),
              ),
            if (_shouldShowMasteryLabel(masteryAssessment)) ...[
              const SizedBox(height: 4),
              Text(_masteryLabel(masteryAssessment!.status, l10n)),
            ],
          ],
        ),
      ),
    );
  }
}

bool _shouldShowMasteryLabel(StepMasteryAssessment? assessment) {
  return assessment?.status == StepMasteryStatus.mastered ||
      assessment?.status == StepMasteryStatus.fragile;
}

SpokenPracticeActivity? _firstSpokenPractice(List<Object> content) {
  for (final item in content) {
    if (item is SpokenPracticeActivity) return item;
  }
  return null;
}

bool _hasReadingRulePresentation(LessonPlayerStep step) {
  return step.content.any(
    (content) => content is ReadingRulePresentationReference,
  );
}

String _masteryLabel(StepMasteryStatus status, AppLocalizations l10n) {
  return switch (status) {
    StepMasteryStatus.mastered => l10n.mastered,
    StepMasteryStatus.fragile => l10n.fragileMastery,
    StepMasteryStatus.notMastered || StepMasteryStatus.notAssessed => '',
  };
}

String? _moduleLabel(String moduleId, AppLocalizations l10n) {
  final match = RegExp(r'\.m0*([0-9]+)$').firstMatch(moduleId);
  if (match == null) {
    return null;
  }
  return l10n.moduleNumber(match.group(1)!);
}

class LessonContentObjectView extends StatelessWidget {
  const LessonContentObjectView({
    required this.content,
    this.state,
    this.showRemediation = false,
    this.reviewMode = false,
    this.onStateChanged,
    super.key,
  });

  final Object content;
  final ActivityTemplateState? state;
  final bool showRemediation;
  final bool reviewMode;
  final ValueChanged<ActivityTemplateState>? onStateChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return switch (content) {
      VocabularyItem item => VocabularyItemView(item: item),
      GrammarTopic topic => GrammarTopicView(topic: topic),
      Dialogue dialogue => DialogueView(dialogue: dialogue),
      ReadingText reading => ReadingTextView(reading: reading),
      SpokenPracticeActivity practice => SpokenPracticeView(activity: practice),
      ReadingRulePresentationReference reference => ReadingRuleReferenceView(
        reference: reference,
      ),
      ExerciseTemplate template => ExerciseTemplateView(
        template: template,
        state: state,
        showRemediation: showRemediation,
        reviewMode: reviewMode,
        onStateChanged: onStateChanged,
      ),
      _ => Text(l10n.unsupportedContent('${content.runtimeType}')),
    };
  }
}

class ReadingRuleReferenceView extends ConsumerWidget {
  const ReadingRuleReferenceView({required this.reference, super.key});

  final ReadingRulePresentationReference reference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportLocale = ref.watch(supportLocaleControllerProvider);
    final catalog = ref.watch(pronunciationCatalogProvider);

    return catalog.when(
      data: (catalog) {
        final presentation = catalog.resolveReadingRule(
          reference.ruleId,
          supportLocaleCode: supportLocale.code,
        );
        if (presentation == null) {
          return Text(context.l10n.unsupportedContent(reference.ruleId));
        }
        return ReadingRuleView(presentation: presentation);
      },
      error: (error, stackTrace) => Text('$error'),
      loading: () => const LinearProgressIndicator(),
    );
  }
}

class VocabularyItemView extends ConsumerWidget {
  const VocabularyItemView({required this.item, super.key});

  final VocabularyItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pronunciation = ref.watch(resolvedPronunciationProvider(item));
    final presentation = pronunciation.value?.presentation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.spanish,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ReferenceAudioButton(referenceId: item.audioReferenceId),
          ],
        ),
        if (presentation?.ipa != null) Text(presentation!.ipa!),
        if (presentation?.localizedLearnerHint != null)
          Text(presentation!.localizedLearnerHint!),
        Text(item.nativeTranslation),
        if (item.example.isNotEmpty) Text(item.example),
        if (presentation?.localizedExplanation != null)
          Text(presentation!.localizedExplanation!),
        if (item.notes != null && item.notes!.isNotEmpty) Text(item.notes!),
      ],
    );
  }
}

class ReadingRuleView extends StatelessWidget {
  const ReadingRuleView({required this.presentation, super.key});

  final ResolvedReadingRulePresentation presentation;

  @override
  Widget build(BuildContext context) {
    final title = presentation.title ?? presentation.orthographicPattern;
    final theme = Theme.of(context);
    final grapheme = presentation.graphemePresentation;
    final explanationBlocks = _uniqueReadingRuleTextBlocks([
      presentation.shortExplanation,
      presentation.detailedExplanation,
      presentation.articulationHint,
      presentation.commonMistakes,
    ]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleSmall),
        const SizedBox(height: 4),
        if (grapheme != null) ...[
          GraphemeComparisonView(
            orthographicPattern: presentation.orthographicPattern,
            presentation: grapheme,
          ),
        ] else
          Text(presentation.orthographicPattern),
        for (final block in explanationBlocks) ...[
          const SizedBox(height: 8),
          Text(block),
        ],
        if (presentation.ipa != null) ...[
          const SizedBox(height: 8),
          Text(presentation.ipa!),
        ],
      ],
    );
  }
}

List<String> _uniqueReadingRuleTextBlocks(Iterable<String?> values) {
  final seen = <String>{};
  final blocks = <String>[];
  for (final value in values) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      continue;
    }
    final normalized = trimmed.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    if (seen.add(normalized)) {
      blocks.add(trimmed);
    }
  }
  return blocks;
}

class GraphemeComparisonView extends StatelessWidget {
  const GraphemeComparisonView({
    required this.orthographicPattern,
    required this.presentation,
    super.key,
  });

  final String orthographicPattern;
  final LocalizedGraphemePresentation presentation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monoStyle = theme.textTheme.headlineSmall?.copyWith(
      fontFamily: theme.textTheme.bodyMedium?.fontFamily,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    );
    final labelStyle = theme.textTheme.bodyMedium;

    return Semantics(
      label: presentation.accessibilityDescription,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(presentation.canonicalDescription, style: labelStyle),
            const SizedBox(height: 6),
            _GraphemeRow(
              components: const ['l', 'l'],
              combined: 'll',
              componentLabels: presentation.componentLetterNames,
              textStyle: monoStyle,
            ),
            const SizedBox(height: 12),
            Text(presentation.confusableDescription, style: labelStyle),
            const SizedBox(height: 6),
            _GraphemeRow(
              components: const ['I', 'I'],
              combined: 'II',
              componentLabels: presentation.confusableComponentLetterNames,
              textStyle: monoStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _GraphemeRow extends StatelessWidget {
  const _GraphemeRow({
    required this.components,
    required this.combined,
    required this.componentLabels,
    required this.textStyle,
  });

  final List<String> components;
  final String combined;
  final List<String> componentLabels;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final labels = componentLabels.map((label) => '«$label»').join(' + ');
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 6,
      children: [
        Text(components.join('  +  '), style: textStyle),
        Text('→', style: textStyle),
        Text(combined, style: textStyle),
        Text(labels),
      ],
    );
  }
}

class GrammarTopicView extends StatelessWidget {
  const GrammarTopicView({required this.topic, super.key});

  final GrammarTopic topic;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
          Text(l10n.buildsOnEarlierMaterial),
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
                Row(
                  children: [
                    Expanded(child: Text(line.spanish)),
                    ReferenceAudioButton(referenceId: line.audioReferenceId),
                  ],
                ),
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
    this.showRemediation = false,
    this.reviewMode = false,
    this.onStateChanged,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityTemplateState? state;
  final bool showRemediation;
  final bool reviewMode;
  final ValueChanged<ActivityTemplateState>? onStateChanged;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: reviewMode,
      child: ActivityTemplateWidget(
        template: template,
        state: state,
        showIncorrectDetails: showRemediation,
        reviewMode: reviewMode,
        onStateChanged: onStateChanged,
      ),
    );
  }
}

String _stepTypeLabel(LessonPlayerStepType stepType, AppLocalizations l10n) {
  return switch (stepType) {
    LessonPlayerStepType.vocabulary => l10n.stepTypeVocabulary,
    LessonPlayerStepType.grammar => l10n.stepTypeGrammar,
    LessonPlayerStepType.dialogue => l10n.stepTypeDialogue,
    LessonPlayerStepType.reading => l10n.stepTypeReading,
    LessonPlayerStepType.exercise => l10n.stepTypeExercise,
    LessonPlayerStepType.spokenPractice => l10n.spokenPractice,
    LessonPlayerStepType.mixed => l10n.stepTypeMixed,
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
