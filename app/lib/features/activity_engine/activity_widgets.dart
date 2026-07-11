import 'package:flutter/material.dart';

import '../../core/content/topic_content.dart';
import '../answer_evaluation/answer_evaluation.dart';
import 'activity_engine.dart';
import 'activity_result.dart';

class ActivityTemplateWidget extends StatelessWidget {
  const ActivityTemplateWidget({
    required this.template,
    this.engine = const ActivityEngine(),
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityEngine engine;

  @override
  Widget build(BuildContext context) {
    return switch (template.exerciseType) {
      'multiple_choice' => MultipleChoiceActivityWidget(
        template: template,
        engine: engine,
      ),
      'fill_gap' => FillGapActivityWidget(template: template, engine: engine),
      'text_entry' => FillGapActivityWidget(template: template, engine: engine),
      'matching' => MatchingActivityWidget(template: template, engine: engine),
      _ => Text('Unsupported activity type: ${template.exerciseType}'),
    };
  }
}

class MultipleChoiceActivityWidget extends StatefulWidget {
  const MultipleChoiceActivityWidget({
    required this.template,
    required this.engine,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityEngine engine;

  @override
  State<MultipleChoiceActivityWidget> createState() =>
      _MultipleChoiceActivityWidgetState();
}

class _MultipleChoiceActivityWidgetState
    extends State<MultipleChoiceActivityWidget> {
  String? _selectedOptionId;
  ActivityResult? _result;

  @override
  Widget build(BuildContext context) {
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
              selected: _selectedOptionId == option.id,
              onSelected: (_) {
                setState(() {
                  _selectedOptionId = option.id;
                  _result = null;
                });
              },
            ),
          ),
        _CheckButton(
          onPressed: _selectedOptionId == null
              ? null
              : () {
                  setState(() {
                    _result = widget.engine.evaluate(
                      template: widget.template,
                      submission: ActivitySubmission(
                        selectedAnswerId: _selectedOptionId,
                      ),
                    );
                  });
                },
        ),
        ActivityFeedback(result: _result),
      ],
    );
  }
}

class FillGapActivityWidget extends StatefulWidget {
  const FillGapActivityWidget({
    required this.template,
    required this.engine,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityEngine engine;

  @override
  State<FillGapActivityWidget> createState() => _FillGapActivityWidgetState();
}

class _FillGapActivityWidgetState extends State<FillGapActivityWidget> {
  final TextEditingController _controller = TextEditingController();
  ActivityResult? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.template.promptTemplate),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Answer'),
          onChanged: (_) {
            setState(() {
              _result = null;
            });
          },
        ),
        _CheckButton(
          onPressed: () {
            setState(() {
              _result = widget.engine.evaluate(
                template: widget.template,
                submission: ActivitySubmission(
                  submittedAnswer: _controller.text,
                ),
              );
            });
          },
        ),
        ActivityFeedback(result: _result),
      ],
    );
  }
}

class MatchingActivityWidget extends StatefulWidget {
  const MatchingActivityWidget({
    required this.template,
    required this.engine,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityEngine engine;

  @override
  State<MatchingActivityWidget> createState() => _MatchingActivityWidgetState();
}

class _MatchingActivityWidgetState extends State<MatchingActivityWidget> {
  final Map<String, TextEditingController> _controllers = {};
  ActivityResult? _result;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                setState(() {
                  _result = null;
                });
              },
            ),
          ),
        _CheckButton(
          onPressed: () {
            setState(() {
              _result = widget.engine.evaluate(
                template: widget.template,
                submission: ActivitySubmission(
                  matchedPairs: {
                    for (final entry in _controllers.entries)
                      entry.key: entry.value.text,
                  },
                ),
              );
            });
          },
        ),
        ActivityFeedback(result: _result),
      ],
    );
  }
}

class ActivityFeedback extends StatelessWidget {
  const ActivityFeedback({
    required this.result,
    this.presenter = const AnswerFeedbackPresenter(),
    super.key,
  });

  final ActivityResult? result;
  final AnswerFeedbackPresenter presenter;

  @override
  Widget build(BuildContext context) {
    final result = this.result;
    if (result == null) {
      return const SizedBox.shrink();
    }

    final evaluation = result.evaluation;
    if (evaluation != null) {
      final feedback = presenter.present(evaluation);
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(feedback.statusLabel),
            if (feedback.canonicalAnswer != null &&
                result.status != ActivityResultStatus.correct) ...[
              const SizedBox(height: 4),
              Text('Canonical answer: ${feedback.canonicalAnswer}'),
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
      ActivityResultStatus.acceptedWithFeedback => 'Accepted with feedback',
      ActivityResultStatus.incorrect => 'Try again',
      ActivityResultStatus.unsupported => 'Unsupported activity type',
    };
  }
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
