import 'package:flutter/material.dart';

import '../../core/content/topic_content.dart';
import '../answer_evaluation/answer_evaluation.dart';
import 'activity_engine.dart';
import 'activity_result.dart';
import 'activity_template_state.dart';

class ActivityTemplateWidget extends StatelessWidget {
  const ActivityTemplateWidget({
    required this.template,
    this.engine = const ActivityEngine(),
    this.state,
    this.onStateChanged,
    this.showIncorrectDetails = true,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityEngine engine;
  final ActivityTemplateState? state;
  final ValueChanged<ActivityTemplateState>? onStateChanged;
  final bool showIncorrectDetails;

  @override
  Widget build(BuildContext context) {
    return switch (template.exerciseType) {
      'multiple_choice' => MultipleChoiceActivityWidget(
        template: template,
        engine: engine,
        state: state,
        onStateChanged: onStateChanged,
        showIncorrectDetails: showIncorrectDetails,
      ),
      'fill_gap' => FillGapActivityWidget(
        template: template,
        engine: engine,
        state: state,
        onStateChanged: onStateChanged,
        showIncorrectDetails: showIncorrectDetails,
      ),
      'text_entry' => FillGapActivityWidget(
        template: template,
        engine: engine,
        state: state,
        onStateChanged: onStateChanged,
        showIncorrectDetails: showIncorrectDetails,
      ),
      'matching' => MatchingActivityWidget(
        template: template,
        engine: engine,
        state: state,
        onStateChanged: onStateChanged,
        showIncorrectDetails: showIncorrectDetails,
      ),
      _ => Text('Unsupported activity type: ${template.exerciseType}'),
    };
  }
}

class MultipleChoiceActivityWidget extends StatefulWidget {
  const MultipleChoiceActivityWidget({
    required this.template,
    required this.engine,
    this.state,
    this.onStateChanged,
    this.showIncorrectDetails = true,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityEngine engine;
  final ActivityTemplateState? state;
  final ValueChanged<ActivityTemplateState>? onStateChanged;
  final bool showIncorrectDetails;

  @override
  State<MultipleChoiceActivityWidget> createState() =>
      _MultipleChoiceActivityWidgetState();
}

class _MultipleChoiceActivityWidgetState
    extends State<MultipleChoiceActivityWidget> {
  ActivityTemplateState _state = const ActivityTemplateState();

  ActivityTemplateState get _currentState => widget.state ?? _state;

  void _updateState(ActivityTemplateState state) {
    final onStateChanged = widget.onStateChanged;
    if (onStateChanged != null) {
      onStateChanged(state);
      return;
    }

    setState(() {
      _state = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = _currentState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.template.promptTemplate),
        const SizedBox(height: 8),
        for (final option in widget.template.answerOptions)
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: ChoiceChip(
              label: Text(option.label),
              selected: state.selectedOptionId == option.id,
              onSelected: (_) {
                _updateState(
                  state.copyWith(selectedOptionId: option.id, result: null),
                );
              },
            ),
          ),
        _CheckButton(
          onPressed: state.selectedOptionId == null
              ? null
              : () {
                  _updateState(
                    state.copyWith(
                      result: widget.engine.evaluate(
                        template: widget.template,
                        submission: ActivitySubmission(
                          selectedAnswerId: state.selectedOptionId,
                        ),
                      ),
                      attemptCount: state.attemptCount + 1,
                    ),
                  );
                },
        ),
        ActivityFeedback(
          result: state.result,
          attemptCount: state.attemptCount,
          showIncorrectDetails: widget.showIncorrectDetails,
        ),
      ],
    );
  }
}

class FillGapActivityWidget extends StatefulWidget {
  const FillGapActivityWidget({
    required this.template,
    required this.engine,
    this.state,
    this.onStateChanged,
    this.showIncorrectDetails = true,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityEngine engine;
  final ActivityTemplateState? state;
  final ValueChanged<ActivityTemplateState>? onStateChanged;
  final bool showIncorrectDetails;

  @override
  State<FillGapActivityWidget> createState() => _FillGapActivityWidgetState();
}

class _FillGapActivityWidgetState extends State<FillGapActivityWidget> {
  final TextEditingController _controller = TextEditingController();
  ActivityTemplateState _state = const ActivityTemplateState();

  ActivityTemplateState get _currentState => widget.state ?? _state;

  @override
  void initState() {
    super.initState();
    _controller.text = _currentState.submittedAnswer;
  }

  @override
  void didUpdateWidget(FillGapActivityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final submittedAnswer = _currentState.submittedAnswer;
    if (_controller.text != submittedAnswer) {
      _controller.text = submittedAnswer;
    }
  }

  void _updateState(ActivityTemplateState state) {
    final onStateChanged = widget.onStateChanged;
    if (onStateChanged != null) {
      onStateChanged(state);
      return;
    }

    setState(() {
      _state = state;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _currentState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.template.promptTemplate),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Answer'),
          keyboardType: _usesLongAnswerInput(widget.template)
              ? TextInputType.multiline
              : TextInputType.text,
          minLines: _usesLongAnswerInput(widget.template) ? 3 : 1,
          maxLines: _usesLongAnswerInput(widget.template) ? 8 : 1,
          textInputAction: _usesLongAnswerInput(widget.template)
              ? TextInputAction.newline
              : TextInputAction.done,
          onChanged: (value) {
            _updateState(state.copyWith(submittedAnswer: value, result: null));
          },
        ),
        _CheckButton(
          onPressed: () {
            _updateState(
              state.copyWith(
                submittedAnswer: _controller.text,
                result: widget.engine.evaluate(
                  template: widget.template,
                  submission: ActivitySubmission(
                    submittedAnswer: _controller.text,
                  ),
                ),
                attemptCount: state.attemptCount + 1,
              ),
            );
          },
        ),
        ActivityFeedback(
          result: state.result,
          attemptCount: state.attemptCount,
          showIncorrectDetails: widget.showIncorrectDetails,
        ),
      ],
    );
  }
}

class MatchingActivityWidget extends StatefulWidget {
  const MatchingActivityWidget({
    required this.template,
    required this.engine,
    this.state,
    this.onStateChanged,
    this.showIncorrectDetails = true,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityEngine engine;
  final ActivityTemplateState? state;
  final ValueChanged<ActivityTemplateState>? onStateChanged;
  final bool showIncorrectDetails;

  @override
  State<MatchingActivityWidget> createState() => _MatchingActivityWidgetState();
}

class _MatchingActivityWidgetState extends State<MatchingActivityWidget> {
  final Map<String, TextEditingController> _controllers = {};
  ActivityTemplateState _state = const ActivityTemplateState();

  ActivityTemplateState get _currentState => widget.state ?? _state;

  void _updateState(ActivityTemplateState state) {
    final onStateChanged = widget.onStateChanged;
    if (onStateChanged != null) {
      onStateChanged(state);
      return;
    }

    setState(() {
      _state = state;
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _currentState;
    final expectedPairs = widget.engine.expectedMatchingPairs(widget.template);

    if (expectedPairs.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.template.promptTemplate),
          const SizedBox(height: 8),
          const Text('This matching activity is not checkable yet.'),
        ],
      );
    }

    for (final left in expectedPairs.keys) {
      _controllers.putIfAbsent(left, TextEditingController.new);
      final controller = _controllers[left]!;
      final value = state.matchedPairs[left] ?? '';
      if (controller.text != value) {
        controller.text = value;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.template.promptTemplate),
        const SizedBox(height: 8),
        for (final left in expectedPairs.keys)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              controller: _controllers[left],
              decoration: InputDecoration(labelText: left),
              onChanged: (_) {
                _updateState(
                  state.copyWith(
                    matchedPairs: {
                      for (final entry in _controllers.entries)
                        entry.key: entry.value.text,
                    },
                    result: null,
                  ),
                );
              },
            ),
          ),
        _CheckButton(
          onPressed: () {
            final matchedPairs = {
              for (final entry in _controllers.entries)
                entry.key: entry.value.text,
            };
            _updateState(
              state.copyWith(
                matchedPairs: matchedPairs,
                result: widget.engine.evaluate(
                  template: widget.template,
                  submission: ActivitySubmission(matchedPairs: matchedPairs),
                ),
                attemptCount: state.attemptCount + 1,
              ),
            );
          },
        ),
        ActivityFeedback(
          result: state.result,
          attemptCount: state.attemptCount,
          showIncorrectDetails: widget.showIncorrectDetails,
        ),
      ],
    );
  }
}

class ActivityFeedback extends StatelessWidget {
  const ActivityFeedback({
    required this.result,
    this.attemptCount = 0,
    this.presenter = const AnswerFeedbackPresenter(),
    this.showIncorrectDetails = true,
    super.key,
  });

  final ActivityResult? result;
  final int attemptCount;
  final AnswerFeedbackPresenter presenter;
  final bool showIncorrectDetails;

  @override
  Widget build(BuildContext context) {
    final result = this.result;
    if (result == null) {
      return const SizedBox.shrink();
    }

    final evaluation = result.evaluation;
    if (evaluation != null) {
      if (evaluation.status == AnswerEvaluationStatus.incorrect &&
          !showIncorrectDetails) {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(result.feedbackText ?? _labelFor(result.status)),
        );
      }

      final feedback = presenter.present(
        evaluation,
        attemptCount: attemptCount,
      );
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(feedback.statusLabel),
            if (feedback.canonicalAnswer != null &&
                result.status != ActivityResultStatus.correct) ...[
              const SizedBox(height: 4),
              Text('Recommended answer: ${feedback.canonicalAnswer}'),
            ],
            for (final correction in feedback.corrections) ...[
              const SizedBox(height: 4),
              Text('- $correction'),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(result.feedbackText ?? _labelFor(result.status)),
    );
  }

  String _labelFor(ActivityResultStatus status) {
    return switch (status) {
      ActivityResultStatus.correct => 'Correct',
      ActivityResultStatus.acceptedWithFeedback => 'Accepted with correction',
      ActivityResultStatus.incorrect => 'Try again',
      ActivityResultStatus.unsupported => 'Unsupported activity type',
    };
  }
}

bool _usesLongAnswerInput(ExerciseTemplate template) {
  final expectedAnswer = template.expectedAnswer ?? '';
  return template.exerciseType == 'text_entry' &&
      (expectedAnswer.length > 48 || template.promptTemplate.length > 140);
}

class _CheckButton extends StatelessWidget {
  const _CheckButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: OutlinedButton(onPressed: onPressed, child: const Text('Check')),
    );
  }
}
