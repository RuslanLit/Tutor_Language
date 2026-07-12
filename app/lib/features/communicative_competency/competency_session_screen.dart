import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/content/content_providers.dart';
import '../../core/learner/learner_progress.dart';
import '../../core/learner/learner_progress_providers.dart';
import '../../shared/widgets/course_browser_error.dart';
import '../activity_engine/activity_template_state.dart';
import '../activity_engine/activity_widgets.dart';
import '../course_navigation/course_navigation_providers.dart';
import 'communicative_competency.dart';

enum _CompetencyScreenPhase {
  diagnosticTask,
  recoveryTransition,
  recoveryTask,
  retryTask,
  finalizing,
  completed,
}

class CompetencySessionScreen extends ConsumerStatefulWidget {
  const CompetencySessionScreen({
    required this.courseId,
    required this.moduleId,
    required this.competencyId,
    this.forceNewAttempt = false,
    super.key,
  });

  final String courseId;
  final String moduleId;
  final String competencyId;
  final bool forceNewAttempt;

  @override
  ConsumerState<CompetencySessionScreen> createState() =>
      _CompetencySessionScreenState();
}

class _CompetencySessionScreenState
    extends ConsumerState<CompetencySessionScreen> {
  late Future<void> _initialization;
  CompetencyRuntimeState? _runtimeState;
  CompetencyTemplateBundle? _templateBundle;
  String? _currentTaskId;
  String? _currentRecoveryGapId;
  String? _currentRecoveryTemplateId;
  CompetencyOutcome? _outcome;
  _CompetencyScreenPhase _phase = _CompetencyScreenPhase.diagnosticTask;
  final Map<String, ActivityTemplateState> _activityStates = {};
  bool _busy = false;

  CompetencyRouteRequest get _request => CompetencyRouteRequest(
    courseId: widget.courseId,
    moduleId: widget.moduleId,
    competencyId: widget.competencyId,
    forceNewAttempt: widget.forceNewAttempt,
  );

  @override
  void initState() {
    super.initState();
    _initialization = _initialize();
  }

  Future<void> _initialize() async {
    final definition = ref.read(runtimeCompetencyDefinitionProvider(_request));
    if (definition == null) {
      throw StateError('Competency check not found.');
    }

    final repository = ref.read(competencyAttemptRepositoryProvider);
    final active = await repository.loadActiveCompetencyAttempt(
      widget.competencyId,
    );
    if (active == null && !await _isAvailable()) {
      throw StateError('Competency check is not available yet.');
    }

    final templates = await ref.read(
      competencyTemplatesProvider(_request).future,
    );
    final controller = ref.read(competencySessionControllerProvider(_request));
    if (controller == null) {
      throw StateError('Competency session could not be created.');
    }

    final attemptId =
        '${DateTime.now().toUtc().microsecondsSinceEpoch}.${widget.competencyId}.attempt';
    final runtime = await controller.startOrResume(
      competencyId: widget.competencyId,
      attemptId: attemptId,
    );

    _templateBundle = templates;
    _runtimeState = runtime;
    _currentTaskId = runtime.nextTaskId;
    if (_currentTaskId == null) {
      _outcome = await controller.finishIfReady(runtime);
      _phase = _CompetencyScreenPhase.completed;
    }
  }

  Future<bool> _isAvailable() async {
    final course = await ref.read(currentCourseProvider.future);
    final events = await ref.read(learnerProgressEventsProvider.future);
    final completedIds = {
      for (final event in events)
        if (event.eventType == ProgressEventType.lessonCompleted ||
            event.eventType == ProgressEventType.topicCompleted)
          event.topicId,
    };
    for (final module in course.modules) {
      if (module.id == widget.moduleId) {
        return module.lessonIds.isNotEmpty &&
            module.lessonIds.every(completedIds.contains);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Competency Check')),
      body: FutureBuilder<void>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return CourseBrowserError(message: '${snapshot.error}');
          }
          return _buildBody(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final bundle = _templateBundle;
    if (bundle == null) {
      return const Center(child: Text('Competency check unavailable.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          bundle.definition.competency.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(bundle.definition.competency.communicativeGoal),
        const SizedBox(height: 20),
        switch (_phase) {
          _CompetencyScreenPhase.diagnosticTask => _taskView(
            intro: 'Show what you can do without help.',
            taskId: _currentTaskId,
          ),
          _CompetencyScreenPhase.recoveryTransition => _recoveryTransition(),
          _CompetencyScreenPhase.recoveryTask => _recoveryTaskView(),
          _CompetencyScreenPhase.retryTask => _taskView(
            intro: 'Try the original task again.',
            taskId: _currentTaskId,
          ),
          _CompetencyScreenPhase.finalizing => const Center(
            child: CircularProgressIndicator(),
          ),
          _CompetencyScreenPhase.completed => _outcomeView(),
        },
      ],
    );
  }

  Widget _taskView({required String intro, required String? taskId}) {
    final bundle = _templateBundle!;
    if (taskId == null) {
      return _outcomeView();
    }
    final templateId = bundle.definition.diagnosticTaskTemplateIds[taskId];
    final template = templateId == null
        ? null
        : bundle.templatesById[templateId];
    if (template == null) {
      return const Text('This competency task is unavailable.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(intro),
        const SizedBox(height: 12),
        ActivityTemplateWidget(
          template: template,
          state: _activityStates[taskId],
          onStateChanged: (state) {
            setState(() {
              _activityStates[taskId] = state;
            });
            if (state.result != null) {
              _submitDiagnostic(taskId, state);
            }
          },
        ),
      ],
    );
  }

  Widget _recoveryTransition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Let's briefly review one part and try again."),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _busy
              ? null
              : () {
                  setState(() {
                    _phase = _CompetencyScreenPhase.recoveryTask;
                  });
                },
          child: const Text('Start review'),
        ),
      ],
    );
  }

  Widget _recoveryTaskView() {
    final templateId = _currentRecoveryTemplateId;
    final template = templateId == null
        ? null
        : _templateBundle!.templatesById[templateId];
    if (template == null) {
      return const Text('Recovery activity unavailable.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick review'),
        const SizedBox(height: 12),
        ActivityTemplateWidget(
          template: template,
          state: _activityStates['recovery::$templateId'],
          onStateChanged: (state) {
            setState(() {
              _activityStates['recovery::$templateId'] = state;
            });
            if (state.result?.isCorrect == true) {
              _completeRecovery();
            }
          },
        ),
      ],
    );
  }

  Widget _outcomeView() {
    final outcome = _outcome;
    if (outcome == null) {
      return const Text('Competency check complete.');
    }

    final canRetry =
        outcome.status == CompetencyOutcomeStatus.partiallyAchieved ||
        outcome.status == CompetencyOutcomeStatus.notYetAchieved;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_outcomeTitle(outcome.status)),
        const SizedBox(height: 8),
        Text(_outcomeDescription(outcome.status)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: () {
                ref.invalidate(learnerProgressEventsProvider);
                ref.invalidate(courseNavigationStateProvider);
                context.goNamed(CourseRoute.name);
              },
              child: const Text('Back to course'),
            ),
            if (canRetry)
              OutlinedButton(
                onPressed: () {
                  context.goNamed(
                    CompetencyRoute.name,
                    pathParameters: {
                      'courseId': widget.courseId,
                      'moduleId': widget.moduleId,
                      'competencyId': widget.competencyId,
                    },
                    queryParameters: const {'retry': 'true'},
                  );
                },
                child: const Text('Retry competency check'),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _submitDiagnostic(
    String taskId,
    ActivityTemplateState state,
  ) async {
    if (_busy) {
      return;
    }
    final result = state.result;
    final runtimeState = _runtimeState;
    if (result == null || runtimeState == null) {
      return;
    }
    setState(() {
      _busy = true;
    });

    try {
      final controller = ref.read(
        competencySessionControllerProvider(_request),
      );
      if (controller == null) {
        throw StateError('Competency session unavailable.');
      }
      final decision = await controller.submitDiagnosticResult(
        state: runtimeState,
        taskId: taskId,
        result: result,
      );
      var nextRuntime = decision.updatedState;
      var nextPhase = _CompetencyScreenPhase.diagnosticTask;
      String? nextTaskId = nextRuntime.nextTaskId;

      if (decision.competencyDecision.recoveryInsertions.isNotEmpty) {
        final insertion = decision.competencyDecision.recoveryInsertions.first;
        _currentRecoveryGapId = insertion.gapId;
        _currentRecoveryTemplateId = insertion.sourceStepId;
        nextTaskId = insertion.originAssessmentTaskId;
        nextPhase = _CompetencyScreenPhase.recoveryTransition;
      } else if (decision.competencyDecision.outcome != null) {
        _outcome = decision.competencyDecision.outcome;
        nextPhase = _CompetencyScreenPhase.completed;
      } else if (nextTaskId == null) {
        _outcome = await controller.finishIfReady(nextRuntime);
        nextPhase = _CompetencyScreenPhase.completed;
      }

      setState(() {
        _runtimeState = nextRuntime;
        _currentTaskId = nextTaskId;
        _phase = nextPhase;
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _completeRecovery() async {
    if (_busy) {
      return;
    }
    final runtimeState = _runtimeState;
    final gapId = _currentRecoveryGapId;
    if (runtimeState == null || gapId == null) {
      return;
    }

    setState(() {
      _busy = true;
    });

    try {
      final controller = ref.read(
        competencySessionControllerProvider(_request),
      );
      if (controller == null) {
        throw StateError('Competency session unavailable.');
      }
      final decision = await controller.completeRecovery(
        state: runtimeState,
        gapId: gapId,
      );
      setState(() {
        _runtimeState = decision.updatedState;
        _currentTaskId = decision.competencyDecision.assessmentTaskId;
        _phase = _CompetencyScreenPhase.retryTask;
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  String _outcomeTitle(CompetencyOutcomeStatus status) {
    return switch (status) {
      CompetencyOutcomeStatus.achieved => 'Competency achieved',
      CompetencyOutcomeStatus.achievedWithReinforcement =>
        'Competency achieved after review',
      CompetencyOutcomeStatus.partiallyAchieved =>
        'Competency needs more practice',
      CompetencyOutcomeStatus.notYetAchieved => 'Competency not yet achieved',
    };
  }

  String _outcomeDescription(CompetencyOutcomeStatus status) {
    return switch (status) {
      CompetencyOutcomeStatus.achieved =>
        'You completed the communicative task independently.',
      CompetencyOutcomeStatus.achievedWithReinforcement =>
        'You used review and then completed the communicative task.',
      CompetencyOutcomeStatus.partiallyAchieved =>
        'You demonstrated part of the goal. Retry when ready.',
      CompetencyOutcomeStatus.notYetAchieved =>
        'The core goal is not secure yet. Retry after review.',
    };
  }
}
