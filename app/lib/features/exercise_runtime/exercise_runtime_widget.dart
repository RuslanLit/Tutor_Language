import 'package:flutter/material.dart';

import 'answer_check_models.dart';
import 'answer_checker.dart';
import 'exercise_runtime_models.dart';

class ExerciseRuntimeWidget extends StatefulWidget {
  const ExerciseRuntimeWidget({
    required this.session,
    this.onRuntimeEvent,
    super.key,
  });

  final ExerciseSession session;
  final ValueChanged<ExerciseRuntimeEvent>? onRuntimeEvent;

  @override
  State<ExerciseRuntimeWidget> createState() => _ExerciseRuntimeWidgetState();
}

class _ExerciseRuntimeWidgetState extends State<ExerciseRuntimeWidget> {
  ExerciseInteractionState _interactionState = const ExerciseInteractionState();
  final AnswerChecker _answerChecker = const AnswerChecker();
  final Map<String, AnswerCheckResult> _checkResults = {};

  void _recordAnswer(ExerciseItem item, ExerciseAnswer answer) {
    setState(() {
      _interactionState = _interactionState.recordResponse(
        ExerciseResponse(
          itemId: item.id,
          answer: answer,
          respondedAt: DateTime.now(),
        ),
      );
      _checkResults.remove(item.id);
    });
    widget.onRuntimeEvent?.call(
      ExerciseRuntimeEvent(
        eventType: ExerciseRuntimeEventType.answerSelected,
        itemId: item.id,
        templateId: item.templateId,
        interactionType: item.interactionType,
      ),
    );
  }

  void _checkAnswer(ExerciseItem item) {
    late final AnswerCheckResult result;

    setState(() {
      result = _answerChecker.check(
        AnswerCheckInput(
          item: item,
          response: _interactionState.responseFor(item.id),
          expectedAnswer: ExpectedAnswer(
            answerId: item.expectedAnswerId,
            text: item.expectedTextAnswer,
            authoredMisconceptions: item.authoredMisconceptions,
          ),
        ),
      );
      _checkResults[item.id] = result;
    });
    widget.onRuntimeEvent?.call(
      ExerciseRuntimeEvent(
        eventType: ExerciseRuntimeEventType.answerChecked,
        itemId: item.id,
        templateId: item.templateId,
        interactionType: item.interactionType,
        answerCheckStatus: result.status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in widget.session.items)
          _ExerciseItemView(
            item: item,
            response: _interactionState.responseFor(item.id),
            checkResult: _checkResults[item.id],
            onAnswerChanged: (answer) => _recordAnswer(item, answer),
            onCheckAnswer: () => _checkAnswer(item),
          ),
      ],
    );
  }
}

class _ExerciseItemView extends StatelessWidget {
  const _ExerciseItemView({
    required this.item,
    required this.response,
    required this.checkResult,
    required this.onAnswerChanged,
    required this.onCheckAnswer,
  });

  final ExerciseItem item;
  final ExerciseResponse? response;
  final AnswerCheckResult? checkResult;
  final ValueChanged<ExerciseAnswer> onAnswerChanged;
  final VoidCallback onCheckAnswer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.prompt),
        const SizedBox(height: 8),
        if (item.interactionType == 'multiple_choice')
          _MultipleChoiceInteraction(
            item: item,
            response: response,
            onAnswerChanged: onAnswerChanged,
          )
        else
          _TextInteraction(item: item, onAnswerChanged: onAnswerChanged),
        if (response != null) ...[
          const SizedBox(height: 8),
          Text('Selected answer: ${response!.answer.label}'),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onCheckAnswer,
            child: const Text('Check answer'),
          ),
        ],
        if (checkResult != null) ...[
          const SizedBox(height: 8),
          Text(_resultLabel(checkResult!.status)),
        ],
      ],
    );
  }

  String _resultLabel(AnswerCheckStatus status) {
    return switch (status) {
      AnswerCheckStatus.unchecked => 'Unchecked',
      AnswerCheckStatus.correct => 'Correct',
      AnswerCheckStatus.acceptedWithFeedback => 'Accepted with feedback',
      AnswerCheckStatus.incorrect => 'Incorrect',
      AnswerCheckStatus.unsupported => 'Unsupported exercise type',
    };
  }
}

class _MultipleChoiceInteraction extends StatelessWidget {
  const _MultipleChoiceInteraction({
    required this.item,
    required this.response,
    required this.onAnswerChanged,
  });

  final ExerciseItem item;
  final ExerciseResponse? response;
  final ValueChanged<ExerciseAnswer> onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    if (item.answerOptions.isEmpty) {
      return const Text('No answer choices are bundled with this template.');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in item.answerOptions)
          ChoiceChip(
            label: Text(option.label),
            selected: response?.answer.id == option.id,
            onSelected: (_) => onAnswerChanged(option),
          ),
      ],
    );
  }
}

class _TextInteraction extends StatefulWidget {
  const _TextInteraction({required this.item, required this.onAnswerChanged});

  final ExerciseItem item;
  final ValueChanged<ExerciseAnswer> onAnswerChanged;

  @override
  State<_TextInteraction> createState() => _TextInteractionState();
}

class _TextInteractionState extends State<_TextInteraction> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(labelText: 'Answer'),
      onChanged: (value) {
        widget.onAnswerChanged(
          ExerciseAnswer(id: '${widget.item.id}.text', label: value),
        );
      },
    );
  }
}
