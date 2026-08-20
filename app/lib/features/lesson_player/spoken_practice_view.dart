import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/content/spoken_practice.dart';
import '../../core/audio/temporary_learner_recording.dart';
import '../curriculum/curriculum_models.dart';
import '../../l10n/l10n.dart';
import 'spoken_practice_controller.dart';

class SpokenPracticeView extends ConsumerWidget {
  const SpokenPracticeView({required this.activity, super.key});

  final SpokenPracticeActivity activity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(spokenPracticeControllerProvider(activity));
    final definition = controller.definition;
    final l10n = context.l10n;
    final targetVisible = controller.targetVisible;
    if (kDebugMode) {
      debugPrint(
        '[af4_spoken] view-build activity=${activity.id} '
        'controller=${identityHashCode(controller)} stage=${controller.stage} '
        'recording=${controller.recording.state}',
      );
    }

    return Semantics(
      container: true,
      label: l10n.spokenPractice,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(definition.prompt),
          if (targetVisible) ...[
            const SizedBox(height: 12),
            Text(
              definition.targetText,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
          if (definition.focusCue != null &&
              definition.focusCue!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(definition.focusCue!),
          ],
          const SizedBox(height: 12),
          _ActionArea(controller: controller),
          if (controller.recording.state ==
                  LearnerRecordingState.permissionDenied ||
              controller.recording.state == LearnerRecordingState.error) ...[
            const SizedBox(height: 8),
            Text(
              controller.recording.state ==
                      LearnerRecordingState.permissionDenied
                  ? l10n.microphoneDenied
                  : l10n.recordingFailed,
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionArea extends StatelessWidget {
  const _ActionArea({required this.controller});

  final SpokenPracticeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stage = controller.stage;
    final hasRecording = controller.recording.hasRecording;
    final actions = <Widget>[];

    switch (stage) {
      case SpokenPracticeStage.readyForExposure:
        actions.add(
          FilledButton.icon(
            onPressed: controller.playReference,
            icon: const Icon(Icons.volume_up),
            label: Text(l10n.listen),
          ),
        );
      case SpokenPracticeStage.exposureAvailable:
        if (controller.definition.mode == SpokenPracticeMode.delayedImitation) {
          actions.add(
            FilledButton(
              onPressed: controller.tryFromMemory,
              child: Text(l10n.tryFromMemory),
            ),
          );
        } else {
          actions.add(_recordButton(context));
          actions.add(
            OutlinedButton.icon(
              onPressed: controller.playReference,
              icon: const Icon(Icons.volume_up),
              label: Text(l10n.listenToReference),
            ),
          );
          actions.add(
            TextButton(
              onPressed: controller.continuePractice,
              child: Text(l10n.continuePractice),
            ),
          );
        }
      case SpokenPracticeStage.readyForAttempt:
        actions.add(_recordButton(context));
        actions.add(
          OutlinedButton(
            onPressed: controller.finishAttemptWithoutRecording,
            child: Text(l10n.finishAttempt),
          ),
        );
      case SpokenPracticeStage.recording:
        actions.add(
          FilledButton.icon(
            onPressed: controller.stopRecording,
            icon: const Icon(Icons.stop),
            label: Text(l10n.stopRecording),
          ),
        );
      case SpokenPracticeStage.attemptCompleted:
        if (hasRecording) actions.add(_playRecordingButton(context));
        actions.add(
          FilledButton(
            onPressed: controller.revealReference,
            child: Text(l10n.showReference),
          ),
        );
      case SpokenPracticeStage.referenceRevealed:
        if (hasRecording) actions.add(_playRecordingButton(context));
        actions.add(
          OutlinedButton.icon(
            onPressed: controller.playReference,
            icon: const Icon(Icons.volume_up),
            label: Text(l10n.listenToReference),
          ),
        );
        actions.add(
          OutlinedButton(
            onPressed: controller.retry,
            child: Text(l10n.tryAgain),
          ),
        );
        actions.add(
          FilledButton(
            onPressed: controller.continuePractice,
            child: Text(l10n.continuePractice),
          ),
        );
      case SpokenPracticeStage.completed:
        actions.add(Text(l10n.practiceComplete));
        actions.add(
          OutlinedButton.icon(
            onPressed: controller.playReference,
            icon: const Icon(Icons.volume_up),
            label: Text(l10n.listenToReference),
          ),
        );
    }

    return Wrap(spacing: 8, runSpacing: 8, children: actions);
  }

  Widget _recordButton(BuildContext context) {
    final l10n = context.l10n;
    return FilledButton.icon(
      onPressed: controller.startRecording,
      icon: const Icon(Icons.mic_none),
      label: Text(l10n.record),
    );
  }

  Widget _playRecordingButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: controller.playLearnerRecording,
      icon: const Icon(Icons.play_arrow),
      label: Text(context.l10n.playMyRecording),
    );
  }
}
