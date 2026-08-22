import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../../core/content/topic_content.dart';
import '../../core/audio/reference_audio_button.dart';
import '../../core/audio/reference_audio.dart';
import '../../core/audio/reference_audio_providers.dart';
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
    this.reviewMode = false,
    this.showReferenceAudio = true,
    this.autoPlayReferenceAudio = true,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityEngine engine;
  final ActivityTemplateState? state;
  final ValueChanged<ActivityTemplateState>? onStateChanged;
  final bool showIncorrectDetails;
  final bool reviewMode;
  final bool showReferenceAudio;
  final bool autoPlayReferenceAudio;

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
        showReferenceAudio: showReferenceAudio,
        autoPlayReferenceAudio: autoPlayReferenceAudio,
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
      'guided_dialogue' => GuidedDialogueActivityWidget(
        template: template,
        engine: engine,
        state: state,
        onStateChanged: onStateChanged,
        showIncorrectDetails: showIncorrectDetails,
        reviewMode: reviewMode,
      ),
      'matching' => MatchingActivityWidget(
        template: template,
        engine: engine,
        state: state,
        onStateChanged: onStateChanged,
        showIncorrectDetails: showIncorrectDetails,
      ),
      'sentence_builder' => SentenceBuilderActivityWidget(
        template: template,
        engine: engine,
        state: state,
        onStateChanged: onStateChanged,
        showIncorrectDetails: showIncorrectDetails,
        showReferenceAudio: showReferenceAudio,
      ),
      _ => Text(l10n.unsupportedActivityTypeValue(template.exerciseType)),
    };
  }
}

class SentenceBuilderActivityWidget extends ConsumerStatefulWidget {
  const SentenceBuilderActivityWidget({
    required this.template,
    required this.engine,
    this.state,
    this.onStateChanged,
    this.showIncorrectDetails = true,
    this.showReferenceAudio = true,
    super.key,
  });
  final ExerciseTemplate template;
  final ActivityEngine engine;
  final ActivityTemplateState? state;
  final ValueChanged<ActivityTemplateState>? onStateChanged;
  final bool showIncorrectDetails;
  final bool showReferenceAudio;

  @override
  ConsumerState<SentenceBuilderActivityWidget> createState() =>
      _SentenceBuilderActivityWidgetState();
}

class _SentenceBuilderActivityWidgetState
    extends ConsumerState<SentenceBuilderActivityWidget> {
  ActivityTemplateState _state = const ActivityTemplateState();
  late List<String> _availableTokenIds;
  String? _autoPlayedReferenceId;
  ActivityTemplateState get _currentState => widget.state ?? _state;

  @override
  void initState() {
    super.initState();
    _availableTokenIds = _shuffleTokenIds(widget.template.sentenceBuilder);
  }

  @override
  void didUpdateWidget(covariant SentenceBuilderActivityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.template.id != widget.template.id) {
      _availableTokenIds = _shuffleTokenIds(widget.template.sentenceBuilder);
      _autoPlayedReferenceId = null;
    }
    final oldResult = oldWidget.state?.result;
    final newResult = widget.state?.result;
    if (newResult?.isCorrect != true) {
      _autoPlayedReferenceId = null;
    } else if (oldResult?.isCorrect != true) {
      _scheduleAutoPlay();
    }
  }

  void _update(ActivityTemplateState value) {
    final previous = _currentState;
    if (value.result?.isCorrect != true) {
      _autoPlayedReferenceId = null;
    }
    if (widget.onStateChanged != null) {
      widget.onStateChanged!(value);
    } else {
      setState(() => _state = value);
    }
    if (value.result?.isCorrect == true && previous.result?.isCorrect != true) {
      _scheduleAutoPlay();
    }
  }

  void _scheduleAutoPlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _autoPlayReferenceAudio();
    });
  }

  Future<void> _autoPlayReferenceAudio() async {
    final referenceId = widget.template.sentenceBuilder?.audioReferenceId;
    if (referenceId == null ||
        referenceId.isEmpty ||
        _autoPlayedReferenceId == referenceId) {
      return;
    }
    _autoPlayedReferenceId = referenceId;
    try {
      await ref.read(referenceAudioPlaybackServiceProvider).play(referenceId);
    } on ReferenceAudioFailure {
      // A missing/unavailable recording must not turn a correct answer into
      // an activity failure; the manual replay button remains available.
    }
  }

  @override
  Widget build(BuildContext context) {
    final builder = widget.template.sentenceBuilder;
    if (builder == null) return Text(context.l10n.unsupportedActivityType);
    final state = _currentState;
    final selected = state.selectedTokenIds;
    final tokensById = {for (final token in builder.tokens) token.id: token};
    final available = _availableTokenIds
        .where((id) => !selected.contains(id))
        .map((id) => tokensById[id]!)
        .toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ActivityPrompt(widget.template.promptTemplate),
        const SizedBox(height: 12),
        Text(
          context.l10n.sentenceBuilderAnswer,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selected.map((id) {
            final token = builder.tokens.firstWhere((item) => item.id == id);
            return InputChip(
              label: Text(token.label),
              onDeleted: () {
                final next = [...selected];
                next.removeAt(selected.indexOf(id));
                _update(state.copyWith(selectedTokenIds: next, result: null));
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Text(
          context.l10n.sentenceBuilderAvailableWords,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: available
              .map(
                (token) => ActionChip(
                  label: Text(token.label),
                  onPressed: () => _update(
                    state.copyWith(
                      selectedTokenIds: [...selected, token.id],
                      result: null,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        Row(
          children: [
            TextButton(
              onPressed: selected.isEmpty
                  ? null
                  : () => _update(
                      state.copyWith(selectedTokenIds: const [], result: null),
                    ),
              child: Text(context.l10n.sentenceBuilderClear),
            ),
            _CheckButton(
              onPressed: selected.isEmpty
                  ? null
                  : () => _update(
                      state.copyWith(
                        result: widget.engine.evaluate(
                          template: widget.template,
                          submission: ActivitySubmission(
                            selectedTokenIds: selected,
                          ),
                        ),
                        attemptCount: state.attemptCount + 1,
                      ),
                    ),
            ),
          ],
        ),
        ActivityFeedback(
          result: state.result,
          attemptCount: state.attemptCount,
          showIncorrectDetails: widget.showIncorrectDetails,
        ),
        if (state.result?.isCorrect == true)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              state.result?.expectedAnswer ??
                  selected
                      .map(
                        (id) => builder.tokens
                            .firstWhere((token) => token.id == id)
                            .label,
                      )
                      .join(' '),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        if (widget.showReferenceAudio &&
            state.result?.isCorrect == true &&
            builder.audioReferenceId != null)
          ReferenceAudioButton(referenceId: builder.audioReferenceId!),
      ],
    );
  }

  List<String> _shuffleTokenIds(SentenceBuilder? builder) {
    if (builder == null) return const [];
    final ids = builder.tokens.map((token) => token.id).toList();
    if (ids.length < 2) return ids;
    final seed = _stableSeed(widget.template.id);
    for (var attempt = 0; attempt < 32; attempt++) {
      final candidate = [...ids];
      candidate.shuffle(math.Random(seed + attempt));
      if (!_containsAcceptedSequence(builder, candidate)) return candidate;
    }
    return ids;
  }

  bool _containsAcceptedSequence(SentenceBuilder builder, List<String> order) {
    return builder.acceptedSequences.any((sequence) {
      if (sequence.length < 2 || sequence.length > order.length) return false;
      for (var start = 0; start <= order.length - sequence.length; start++) {
        var matches = true;
        for (var index = 0; index < sequence.length; index++) {
          if (order[start + index] != sequence[index]) {
            matches = false;
            break;
          }
        }
        if (matches) return true;
      }
      return false;
    });
  }

  int _stableSeed(String value) {
    var hash = 0x811c9dc5;
    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }
}

class MultipleChoiceActivityWidget extends ConsumerStatefulWidget {
  const MultipleChoiceActivityWidget({
    required this.template,
    required this.engine,
    this.state,
    this.onStateChanged,
    this.showIncorrectDetails = true,
    this.reviewMode = false,
    this.showReferenceAudio = true,
    this.autoPlayReferenceAudio = true,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityEngine engine;
  final ActivityTemplateState? state;
  final ValueChanged<ActivityTemplateState>? onStateChanged;
  final bool showIncorrectDetails;
  final bool reviewMode;
  final bool showReferenceAudio;
  final bool autoPlayReferenceAudio;

  @override
  ConsumerState<MultipleChoiceActivityWidget> createState() =>
      _MultipleChoiceActivityWidgetState();
}

class _MultipleChoiceActivityWidgetState
    extends ConsumerState<MultipleChoiceActivityWidget> {
  ActivityTemplateState _state = const ActivityTemplateState();
  String? _autoPlayedReferenceId;

  ActivityTemplateState get _currentState => widget.state ?? _state;

  @override
  void initState() {
    super.initState();
    _scheduleListeningStimulus();
  }

  @override
  void didUpdateWidget(covariant MultipleChoiceActivityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.template.id != widget.template.id) {
      _autoPlayedReferenceId = null;
      _scheduleListeningStimulus();
    }
  }

  void _scheduleListeningStimulus() {
    if (!widget.autoPlayReferenceAudio) return;
    final referenceId = widget.template.audioReferenceId;
    if (referenceId == null || referenceId.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _autoPlayedReferenceId == referenceId) return;
      _autoPlayedReferenceId = referenceId;
      _playInitialListeningStimulus(referenceId);
    });
  }

  Future<void> _playInitialListeningStimulus(String referenceId) async {
    try {
      await ref.read(referenceAudioPlaybackServiceProvider).play(referenceId);
    } on ReferenceAudioFailure catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.audioUnavailable)));
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
  Widget build(BuildContext context) {
    final state = _currentState;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ActivityPrompt(widget.template.promptTemplate),
        if (widget.showReferenceAudio &&
            widget.template.audioReferenceId != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ReferenceAudioButton(
              referenceId: widget.template.audioReferenceId!,
              showLabel: true,
            ),
          ),
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
        if (state.result?.isCorrect == true &&
            widget.template.audioTranscript != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.template.audioTranscript!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
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

class GuidedDialogueActivityWidget extends StatefulWidget {
  const GuidedDialogueActivityWidget({
    required this.template,
    required this.engine,
    this.state,
    this.onStateChanged,
    this.showIncorrectDetails = true,
    this.reviewMode = false,
    super.key,
  });

  final ExerciseTemplate template;
  final ActivityEngine engine;
  final ActivityTemplateState? state;
  final ValueChanged<ActivityTemplateState>? onStateChanged;
  final bool showIncorrectDetails;
  final bool reviewMode;

  @override
  State<GuidedDialogueActivityWidget> createState() =>
      _GuidedDialogueActivityWidgetState();
}

class _GuidedDialogueActivityWidgetState
    extends State<GuidedDialogueActivityWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  ActivityTemplateState _state = const ActivityTemplateState();

  ActivityTemplateState get _currentState => widget.state ?? _state;

  void _updateState(ActivityTemplateState value) {
    if (widget.onStateChanged != null) {
      widget.onStateChanged!(value);
    } else {
      setState(() => _state = value);
    }
  }

  @override
  void didUpdateWidget(covariant GuidedDialogueActivityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus) _controller.text = '';
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialogue = widget.template.guidedDialogue;
    if (dialogue == null || dialogue.turns.isEmpty) {
      return Text(context.l10n.unsupportedActivityType);
    }
    final state = _currentState;
    final turnIndex = widget.reviewMode
        ? dialogue.turns.length - 1
        : state.dialogueTurnIndex.clamp(0, dialogue.turns.length - 1);
    final groupStart = widget.reviewMode
        ? 0
        : _dialogueGroupStart(dialogue.turns, turnIndex);
    final learnerTurnIndex = widget.reviewMode
        ? dialogue.turns.length - 1
        : _firstLearnerAtOrAfter(dialogue.turns, groupStart);
    final learnerTurnCount = dialogue.turns
        .where((turn) => turn.learner)
        .length;
    final dialoguePosition = widget.reviewMode
        ? learnerTurnCount
        : _learnerPosition(dialogue.turns, learnerTurnIndex);
    final responseByTurn = <int, String>{};
    var learnerOrdinal = 0;
    for (var index = 0; index < dialogue.turns.length; index++) {
      if (!dialogue.turns[index].learner) continue;
      if (learnerOrdinal < state.dialogueResponses.length) {
        responseByTurn[index] = state.dialogueResponses[learnerOrdinal];
      }
      learnerOrdinal++;
    }
    final displayEnd = widget.reviewMode
        ? dialogue.turns.length - 1
        : state.dialogueCompleted
        ? _dialogueCompletionEnd(dialogue.turns, learnerTurnIndex)
        : _dialogueGroupEnd(dialogue.turns, turnIndex);
    final current = dialogue.turns[learnerTurnIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ActivityPrompt(widget.template.promptTemplate),
        const SizedBox(height: 12),
        Text(
          context.l10n.dialogueProgress(dialoguePosition, learnerTurnCount),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        for (var index = groupStart; index <= displayEnd; index++)
          _GuidedDialogueTurnView(
            turn: dialogue.turns[index],
            response:
                responseByTurn[index] ??
                (widget.reviewMode && dialogue.turns[index].learner
                    ? dialogue.turns[index].text
                    : null),
          ),
        if (!widget.reviewMode &&
            current.learner &&
            current.learnerCue != null &&
            !state.dialogueCompleted)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _ActivityPrompt(current.learnerCue!),
          ),
        if (!widget.reviewMode &&
            current.learner &&
            !state.dialogueCompleted) ...[
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(labelText: context.l10n.answerLabel),
            textInputAction: TextInputAction.done,
            onChanged: (value) => _updateState(
              state.copyWith(submittedAnswer: value, result: null),
            ),
          ),
          _CheckButton(
            onPressed: () {
              final result = widget.engine.evaluate(
                template: widget.template,
                submission: ActivitySubmission(
                  submittedAnswer: _controller.text,
                  dialogueTurnIndex: learnerTurnIndex,
                ),
              );
              if (!result.isCorrect) {
                _updateState(
                  state.copyWith(
                    submittedAnswer: _controller.text,
                    result: result,
                    attemptCount: state.attemptCount + 1,
                  ),
                );
                return;
              }
              final nextLearnerIndex = _nextLearnerIndex(
                dialogue.turns,
                learnerTurnIndex,
              );
              final responses = [...state.dialogueResponses, _controller.text];
              _controller.clear();
              _updateState(
                state.copyWith(
                  submittedAnswer: '',
                  result: result,
                  attemptCount: state.attemptCount + 1,
                  dialogueTurnIndex: nextLearnerIndex ?? learnerTurnIndex,
                  dialogueResponses: responses,
                  dialogueCompleted: nextLearnerIndex == null,
                ),
              );
            },
          ),
        ],
        ActivityFeedback(
          result: state.result,
          attemptCount: state.attemptCount,
          showIncorrectDetails: widget.showIncorrectDetails,
        ),
      ],
    );
  }

  int _dialogueGroupStart(List<GuidedDialogueTurn> turns, int turnIndex) {
    for (var index = turnIndex - 1; index >= 0; index--) {
      if (turns[index].learner) return index + 1;
    }
    return 0;
  }

  int _dialogueGroupEnd(List<GuidedDialogueTurn> turns, int turnIndex) {
    for (var index = turnIndex; index < turns.length; index++) {
      if (turns[index].learner) return index;
    }
    return turns.length - 1;
  }

  int _dialogueCompletionEnd(List<GuidedDialogueTurn> turns, int turnIndex) {
    for (var index = turnIndex + 1; index < turns.length; index++) {
      if (turns[index].learner) return index - 1;
    }
    return turns.length - 1;
  }

  int _firstLearnerAtOrAfter(List<GuidedDialogueTurn> turns, int startIndex) {
    for (var index = startIndex; index < turns.length; index++) {
      if (turns[index].learner) return index;
    }
    return turns.length - 1;
  }

  int _learnerPosition(List<GuidedDialogueTurn> turns, int turnIndex) {
    final position = turns
        .take(turnIndex + 1)
        .where((turn) => turn.learner)
        .length;
    return position.clamp(1, turns.where((turn) => turn.learner).length);
  }

  int? _nextLearnerIndex(List<GuidedDialogueTurn> turns, int turnIndex) {
    for (var index = turnIndex + 1; index < turns.length; index++) {
      if (turns[index].learner) return index;
    }
    return null;
  }
}

class _GuidedDialogueTurnView extends StatelessWidget {
  const _GuidedDialogueTurnView({required this.turn, this.response});

  final GuidedDialogueTurn turn;
  final String? response;

  @override
  Widget build(BuildContext context) {
    final text = turn.learner ? (response ?? '…') : turn.text;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            turn.learner ? context.l10n.learnerSpeakerLabel : turn.speaker,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(text)),
              if (!turn.learner)
                ReferenceAudioButton(referenceId: turn.audioReferenceId),
            ],
          ),
        ],
      ),
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
          !showIncorrectDetails &&
          evaluation.feedback.structure == null) {
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
      final hideCanonicalAnswer =
          evaluation.status == AnswerEvaluationStatus.incorrect &&
          !showIncorrectDetails;
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FeedbackStatus(status: evaluation.status),
            if (feedback.canonicalAnswer != null &&
                result.status != ActivityResultStatus.correct &&
                !hideCanonicalAnswer) ...[
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
      padding: const EdgeInsets.only(top: 12),
      child: _FeedbackStatus(
        status: result.status,
        fallback: result.feedbackText,
      ),
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
}

class _FeedbackStatus extends StatelessWidget {
  const _FeedbackStatus({required this.status, this.fallback});

  final Object status;
  final String? fallback;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isCorrect =
        status == ActivityResultStatus.correct ||
        status == AnswerEvaluationStatus.correct;
    final isAccepted =
        status == ActivityResultStatus.acceptedWithFeedback ||
        status == AnswerEvaluationStatus.acceptedWithFeedback;
    final text = isCorrect
        ? l10n.correct
        : fallback ??
              (isAccepted
                  ? l10n.acceptedWithCorrection
                  : status is ActivityResultStatus
                  ? _labelForActivity(status as ActivityResultStatus, l10n)
                  : l10n.notCorrectYet);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isCorrect ? Icons.check_circle : Icons.info_outline,
          color: isCorrect
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          size: 22,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: isCorrect
                ? Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

String _labelForActivity(ActivityResultStatus status, AppLocalizations l10n) {
  return switch (status) {
    ActivityResultStatus.correct => l10n.correct,
    ActivityResultStatus.acceptedWithFeedback => l10n.acceptedWithCorrection,
    ActivityResultStatus.incorrect => l10n.tryAgain,
    ActivityResultStatus.unsupported => l10n.unsupportedActivityType,
  };
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
