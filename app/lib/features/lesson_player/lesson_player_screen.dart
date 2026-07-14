import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/content/topic_content.dart';
import '../../core/learner/lesson_attempt.dart';
import '../../core/learner/learner_progress_providers.dart';
import '../../shared/widgets/course_browser_error.dart';
import '../activity_engine/activity_template_state.dart';
import '../activity_engine/activity_widgets.dart';
import '../curriculum/curriculum_models.dart';
import '../course_navigation/course_navigation_providers.dart';
import '../lesson_assembly/lesson_content.dart';
import '../lesson_launch/lesson_launch_intent.dart';
import '../lesson_session/lesson_attempt_snapshot_factory.dart';
import '../lesson_session/lesson_session_engine.dart';
import 'lesson_player_providers.dart';
import 'lesson_player_step.dart';

class LessonPlayerScreen extends ConsumerWidget {
  const LessonPlayerScreen({
    required this.lessonId,
    this.attemptPurpose = LessonAttemptPurpose.normal,
    super.key,
  });

  final String lessonId;
  final LessonAttemptPurpose attemptPurpose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          title: const Text('Lesson Player'),
        ),
        body: lessonContent.when(
          data: (lessonContent) => LessonPlayerView(
            lessonContent: lessonContent,
            attemptPurpose: attemptPurpose,
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
    return IconButton(
      tooltip: 'Back to course',
      onPressed: () => _handleLessonExit(context, ref, lessonId: lessonId),
      icon: const Icon(Icons.arrow_back),
    );
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

  if (isSessionCompleted || hasDurableCompletion) {
    _returnToCourse(context);
    return;
  }

  final shouldLeave = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Leave lesson?'),
      content: const Text(
        'This unfinished lesson will restart when you open it again.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Stay'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Leave lesson'),
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
    super.key,
  });

  final LessonContent lessonContent;
  final LessonAttemptPurpose attemptPurpose;
  static const _stepBuilder = LessonPlayerStepBuilder();
  static const _sessionEngine = LessonSessionEngine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = lessonContent.lesson;
    final steps = _stepBuilder.buildSteps(lessonContent);
    final sessionProvider = lessonPlayerSessionProvider(lesson.id);
    final session = ref.watch(sessionProvider);
    final activeSession = session.ensureStarted(
      lessonId: lesson.id,
      steps: steps,
      attemptPurpose: attemptPurpose,
    );
    if (!identical(activeSession, session)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(sessionProvider.notifier).state = activeSession;
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
            onStateChanged: (stepState) {
              final nextStepStates = {
                ...activeSession.stepStates,
                currentStep.id: stepState,
              };

              var nextSessionState = activeSession.sessionState;
              final result = stepState.result;
              if (result != null) {
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
                if (currentStep?.isCheckable == true)
                  _CompactLessonHeader(title: lesson.title)
                else
                  _LessonHeader(lesson: lesson),
                const SizedBox(height: 12),
                stepView ?? const Text('No activities available.'),
              ],
            ),
          ),
          if (currentStep != null) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LessonNavigationControls(
                lessonId: lesson.id,
                courseId: lesson.courseId,
                stepCount: activeStepIds.length,
                currentStepIndex: currentStepIndex,
                session: activeSession,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({required this.lesson});

  final LessonDefinition lesson;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lesson.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (_moduleLabel(lesson.moduleId) != null)
              _MetadataChip(label: _moduleLabel(lesson.moduleId)!),
            if (_lessonNumberLabel(lesson.id) != null)
              _MetadataChip(label: _lessonNumberLabel(lesson.id)!),
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

class _CompactLessonHeader extends StatelessWidget {
  const _CompactLessonHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
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
    required this.courseId,
    required this.stepCount,
    required this.currentStepIndex,
    required this.session,
    super.key,
  });

  final String lessonId;
  final String courseId;
  final int stepCount;
  final int currentStepIndex;
  final LessonPlayerSessionState session;

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
    final progress = ref.watch(topicProgressProvider(widget.lessonId));
    final isLastStep = widget.currentStepIndex == widget.stepCount - 1;
    final previousDecision = _sessionEngine.requestPrevious(
      widget.session.sessionState,
    );
    final nextDecision = _sessionEngine.requestNext(
      widget.session.sessionState,
    );
    final finishDecision = _sessionEngine.finishSession(
      widget.session.sessionState,
    );
    final canGoPrevious =
        previousDecision.type == LessonSessionDecisionType.moveToPreviousStep;
    final canGoNext =
        nextDecision.type == LessonSessionDecisionType.moveToNextStep;
    final isPersisting =
        widget.session.completionPersistenceStatus ==
        LessonCompletionPersistenceStatus.persisting;
    final canFinish =
        finishDecision.type == LessonSessionDecisionType.finishLesson;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: progress.when(
        data: (progress) {
          final isCompleted =
              (widget.session.attemptPurpose == LessonAttemptPurpose.normal &&
                  progress.hasBeenCompleted) ||
              widget.session.sessionState.status ==
                  LessonSessionStatus.completed;
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
                      child: const Text('← Previous'),
                    ),
                    const Spacer(),
                    Text(
                      'Step ${widget.currentStepIndex + 1} / '
                      '${widget.stepCount}',
                    ),
                    const Spacer(),
                    if (isLastStep)
                      FilledButton(
                        onPressed: _isCompleting || isPersisting || !canFinish
                            ? null
                            : _completeLesson,
                        child: Text(
                          _isCompleting || isPersisting
                              ? 'Finishing...'
                              : 'Finish Lesson',
                        ),
                      )
                    else
                      FilledButton(
                        onPressed: canGoNext ? _goToNextStep : null,
                        child: const Text('Next →'),
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
              const Text('Lesson completed'),
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
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RepeatLessonButton(lessonId: widget.lessonId),
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
                        child: const Text('Continue to next lesson'),
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

  Future<void> _completeLesson() async {
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

    try {
      final result = await ref
          .read(learnerProgressRepositoryProvider)
          .recordCompletedLessonAttempt(command);
      if (!result.isSuccess) {
        ref
            .read(lessonPlayerSessionProvider(widget.lessonId).notifier)
            .state = pendingSession.copyWith(
          completionPersistenceStatus: LessonCompletionPersistenceStatus.failed,
          completionError:
              'Could not save lesson completion. Please try again.',
        );
        if (mounted) {
          setState(() {
            _completionError =
                'Could not save lesson completion. Please try again.';
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
        completionError: 'Could not save lesson completion. Please try again.',
      );
      if (mounted) {
        setState(() {
          _completionError =
              'Could not save lesson completion. Please try again.';
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

    ref.read(lessonPlayerSessionProvider(widget.lessonId).notifier).state =
        widget.session.copyWith(sessionState: decision.updatedState);
  }

  void _goToNextStep() {
    final decision = _sessionEngine.requestNext(widget.session.sessionState);
    if (decision.type != LessonSessionDecisionType.moveToNextStep) {
      return;
    }

    ref.read(lessonPlayerSessionProvider(widget.lessonId).notifier).state =
        widget.session.copyWith(sessionState: decision.updatedState);
  }
}

class _CourseCompletionActions extends ConsumerWidget {
  const _CourseCompletionActions({required this.lessonId, this.lessonOutcome});

  final String lessonId;
  final LessonOutcome? lessonOutcome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Course complete', style: Theme.of(context).textTheme.titleMedium),
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
                _startManualRepeat(context, ref, lessonId);
              },
              child: const Text('Repeat lesson'),
            ),
          ],
        ),
      ],
    );
  }
}

class _RepeatLessonButton extends ConsumerWidget {
  const _RepeatLessonButton({required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      onPressed: () => _startManualRepeat(context, ref, lessonId),
      child: const Text('Repeat lesson'),
    );
  }
}

void _startManualRepeat(BuildContext context, WidgetRef ref, String lessonId) {
  ref.read(lessonPlayerSessionProvider(lessonId).notifier).state =
      const LessonPlayerSessionState();
  context.goNamed(
    LessonRoute.name,
    pathParameters: {'lessonId': lessonId},
    extra: LessonLaunchIntent(
      lessonId: lessonId,
      attemptPurpose: LessonAttemptPurpose.manualRepeat,
    ),
  );
}

class _LessonOutcomeLabel extends StatelessWidget {
  const _LessonOutcomeLabel({required this.outcome});

  final LessonOutcome outcome;

  @override
  Widget build(BuildContext context) {
    return Text(switch (outcome.status) {
      LessonOutcomeStatus.mastered => 'Lesson mastered',
      LessonOutcomeStatus.completedWithReinforcement =>
        'Some topics will need reinforcement.',
      LessonOutcomeStatus.incomplete => 'Lesson incomplete',
    });
  }
}

class LessonPlayerStepView extends StatelessWidget {
  const LessonPlayerStepView({
    required this.step,
    this.state,
    this.masteryAssessment,
    this.showRemediation = false,
    this.onStateChanged,
    super.key,
  });

  final LessonPlayerStep step;
  final ActivityTemplateState? state;
  final StepMasteryAssessment? masteryAssessment;
  final bool showRemediation;
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
              step.isInsertedReview
                  ? 'Quick Review'
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
                  showRemediation: showRemediation,
                  onStateChanged: onStateChanged,
                ),
              ),
            if (_shouldShowMasteryLabel(masteryAssessment)) ...[
              const SizedBox(height: 4),
              Text(_masteryLabel(masteryAssessment!.status)),
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

String _masteryLabel(StepMasteryStatus status) {
  return switch (status) {
    StepMasteryStatus.mastered => 'Mastered',
    StepMasteryStatus.fragile =>
      'Good work. This needs a little more practice.',
    StepMasteryStatus.notMastered || StepMasteryStatus.notAssessed => '',
  };
}

String? _moduleLabel(String moduleId) {
  final match = RegExp(r'\.m0*([0-9]+)$').firstMatch(moduleId);
  if (match == null) {
    return null;
  }
  return 'Module ${match.group(1)}';
}

String? _lessonNumberLabel(String lessonId) {
  final match = RegExp(r'\.l0*([0-9]+)$').firstMatch(lessonId);
  if (match == null) {
    return null;
  }
  return 'Lesson ${match.group(1)}';
}

class LessonContentObjectView extends StatelessWidget {
  const LessonContentObjectView({
    required this.content,
    this.state,
    this.showRemediation = false,
    this.onStateChanged,
    super.key,
  });

  final Object content;
  final ActivityTemplateState? state;
  final bool showRemediation;
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
        showRemediation: showRemediation,
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
          const Text('Builds on earlier material.'),
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
    this.showRemediation = false,
    this.onStateChanged,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityTemplateState? state;
  final bool showRemediation;
  final ValueChanged<ActivityTemplateState>? onStateChanged;

  @override
  Widget build(BuildContext context) {
    return ActivityTemplateWidget(
      template: template,
      state: state,
      showIncorrectDetails: showRemediation,
      onStateChanged: onStateChanged,
    );
  }
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
