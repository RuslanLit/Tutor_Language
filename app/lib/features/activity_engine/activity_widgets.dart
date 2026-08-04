import 'package:flutter/material.dart';

import '../../core/content/topic_content.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/l10n.dart';
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
    final l10n = context.l10n;

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
      _ => Text(l10n.unsupportedActivityTypeValue(template.exerciseType)),
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
        _ActivityPrompt(widget.template.promptTemplate),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in widget.template.answerOptions)
              ChoiceChip(
                label: Text(option.label),
                selected: state.selectedOptionId == option.id,
                onSelected: (_) {
                  _updateState(
                    state.copyWith(selectedOptionId: option.id, result: null),
                  );
                },
              ),
          ],
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
  final FocusNode _focusNode = FocusNode();
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
    // A parent rebuild can arrive while the parent-held state still trails
    // the controller's latest onChanged event. Do not overwrite active input
    // in that case; only reset the controller when this element is reused for
    // another exercise template.
    if (oldWidget.template.id != widget.template.id || !_focusNode.hasFocus) {
      _controller.text = _currentState.submittedAnswer;
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
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = _currentState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ActivityPrompt(widget.template.promptTemplate),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(labelText: l10n.answerLabel),
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
    final l10n = context.l10n;
    final state = _currentState;
    final expectedPairs = widget.engine.expectedMatchingPairs(widget.template);

    if (expectedPairs.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ActivityPrompt(widget.template.promptTemplate),
          const SizedBox(height: 8),
          Text(l10n.matchingNotCheckableYet),
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
        _ActivityPrompt(widget.template.promptTemplate),
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
    final l10n = context.l10n;
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
          child: Text(result.feedbackText ?? _labelFor(result.status, l10n)),
        );
      }

      final feedback = presenter.present(
        l10n,
        evaluation,
        attemptCount: attemptCount,
      );
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_statusLabelFor(evaluation.status, l10n)),
            if (feedback.canonicalAnswer != null &&
                result.status != ActivityResultStatus.correct) ...[
              const SizedBox(height: 4),
              Text(l10n.recommendedAnswer(feedback.canonicalAnswer!)),
            ],
            for (final correction in feedback.corrections) ...[
              const SizedBox(height: 4),
              Text(l10n.feedbackBullet(correction)),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(result.feedbackText ?? _labelFor(result.status, l10n)),
    );
  }

  String _labelFor(ActivityResultStatus status, AppLocalizations l10n) {
    return switch (status) {
      ActivityResultStatus.correct => l10n.correct,
      ActivityResultStatus.acceptedWithFeedback => l10n.acceptedWithCorrection,
      ActivityResultStatus.incorrect => l10n.tryAgain,
      ActivityResultStatus.unsupported => l10n.unsupportedActivityType,
    };
  }

  String _statusLabelFor(AnswerEvaluationStatus status, AppLocalizations l10n) {
    return switch (status) {
      AnswerEvaluationStatus.correct => l10n.correct,
      AnswerEvaluationStatus.acceptedWithFeedback =>
        l10n.acceptedWithCorrection,
      AnswerEvaluationStatus.incorrect => l10n.notCorrectYet,
      AnswerEvaluationStatus.unsupported => l10n.unsupportedActivityType,
    };
  }
}

class _ActivityPrompt extends StatelessWidget {
  const _ActivityPrompt(this.prompt);

  final String prompt;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Text(prompt, semanticsLabel: l10n.exercisePromptSemantics(prompt));
  }
}

bool _usesLongAnswerInput(ExerciseTemplate template) {
  final expectedAnswer = template.expectedAnswer ?? '';
  return _isTypedAnswerExercise(template.exerciseType) &&
      _expectsMultiSentenceAnswer(expectedAnswer);
}

bool _isTypedAnswerExercise(String exerciseType) {
  return exerciseType == 'fill_gap' || exerciseType == 'text_entry';
}

bool _expectsMultiSentenceAnswer(String expectedAnswer) {
  // Input size follows the learner's required answer, not prompt length:
  // long instructions can still ask for a short answer such as "Hola, Adiós".
  final answer = expectedAnswer.trim();
  if (answer.contains('\n')) {
    return true;
  }

  final sentenceCount = RegExp(r'[.!?¿¡]').allMatches(answer).length;
  return answer.length > 48 || sentenceCount > 1;
}

class _CheckButton extends StatelessWidget {
  const _CheckButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(l10n.checkAnswer),
      ),
    );
  }
}
