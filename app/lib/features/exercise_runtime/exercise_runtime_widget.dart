import 'package:flutter/material.dart';

import 'exercise_runtime_models.dart';

class ExerciseRuntimeWidget extends StatefulWidget {
  const ExerciseRuntimeWidget({required this.session, super.key});

  final ExerciseSession session;

  @override
  State<ExerciseRuntimeWidget> createState() => _ExerciseRuntimeWidgetState();
}

class _ExerciseRuntimeWidgetState extends State<ExerciseRuntimeWidget> {
  ExerciseInteractionState _interactionState = const ExerciseInteractionState();

  void _recordAnswer(ExerciseItem item, ExerciseAnswer answer) {
    setState(() {
      _interactionState = _interactionState.recordResponse(
        ExerciseResponse(
          itemId: item.id,
          answer: answer,
          respondedAt: DateTime.now(),
        ),
      );
    });
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
            onAnswerChanged: (answer) => _recordAnswer(item, answer),
          ),
      ],
    );
  }
}

class _ExerciseItemView extends StatelessWidget {
  const _ExerciseItemView({
    required this.item,
    required this.response,
    required this.onAnswerChanged,
  });

  final ExerciseItem item;
  final ExerciseResponse? response;
  final ValueChanged<ExerciseAnswer> onAnswerChanged;

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
        ],
      ],
    );
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
