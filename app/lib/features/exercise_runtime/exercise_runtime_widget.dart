import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../l10n/l10n.dart';
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
            acceptedTextAnswers: item.acceptedTextAnswers,
            acceptedWithFeedbackAnswers: item.acceptedWithFeedbackAnswers,
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
    final l10n = context.l10n;

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
          Text(l10n.selectedAnswer(response!.answer.label)),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onCheckAnswer,
            child: Text(l10n.checkAnswer),
          ),
        ],
        if (checkResult != null) ...[
          const SizedBox(height: 8),
          Text(_resultLabel(checkResult!.status, l10n)),
        ],
      ],
    );
  }

  String _resultLabel(AnswerCheckStatus status, AppLocalizations l10n) {
    return switch (status) {
      AnswerCheckStatus.unchecked => l10n.unchecked,
      AnswerCheckStatus.correct => l10n.correct,
      AnswerCheckStatus.acceptedWithFeedback => l10n.acceptedWithCorrection,
      AnswerCheckStatus.incorrect => l10n.incorrect,
      AnswerCheckStatus.unsupported => l10n.unsupportedActivityType,
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
    final l10n = context.l10n;

    if (item.answerOptions.isEmpty) {
      return Text(l10n.noAnswerChoices);
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
    final l10n = context.l10n;

    return TextField(
      controller: _controller,
      decoration: InputDecoration(labelText: l10n.answerLabel),
      keyboardType: _usesLongAnswerInput(widget.item)
          ? TextInputType.multiline
          : TextInputType.text,
      minLines: _usesLongAnswerInput(widget.item) ? 3 : 1,
      maxLines: _usesLongAnswerInput(widget.item) ? 8 : 1,
      textInputAction: _usesLongAnswerInput(widget.item)
          ? TextInputAction.newline
          : TextInputAction.done,
      onChanged: (value) {
        widget.onAnswerChanged(
          ExerciseAnswer(id: '${widget.item.id}.text', label: value),
        );
      },
    );
  }
}

bool _usesLongAnswerInput(ExerciseItem item) {
  final expectedAnswer = item.expectedTextAnswer ?? '';
  return expectedAnswer.length > 48 || item.prompt.length > 140;
}
