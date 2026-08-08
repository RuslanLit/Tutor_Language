import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import 'reference_audio_providers.dart';
import 'temporary_learner_recording.dart';

class TemporaryLearnerRecordingControl extends ConsumerWidget {
  const TemporaryLearnerRecordingControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(temporaryLearnerRecordingServiceProvider);
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.recordingPurpose),
        const SizedBox(height: 12),
        switch (service.state) {
          LearnerRecordingState.idle => FilledButton.icon(
            onPressed: service.start,
            icon: const Icon(Icons.mic_none),
            label: Text(l10n.record),
          ),
          LearnerRecordingState.requestingPermission => const Center(
            child: CircularProgressIndicator(),
          ),
          LearnerRecordingState.recording => FilledButton.icon(
            onPressed: service.stop,
            icon: const Icon(Icons.stop),
            label: Text(l10n.stopRecording),
          ),
          LearnerRecordingState.recorded => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: service.play,
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.playMyRecording),
              ),
              OutlinedButton.icon(
                onPressed: service.start,
                icon: const Icon(Icons.mic_none),
                label: Text(l10n.recordAgain),
              ),
              TextButton.icon(
                onPressed: service.clear,
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.deleteRecording),
              ),
            ],
          ),
          LearnerRecordingState.playing => const Center(
            child: CircularProgressIndicator(),
          ),
          LearnerRecordingState.permissionDenied => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.microphoneDenied),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: service.start,
                child: Text(l10n.tryRecordingAgain),
              ),
            ],
          ),
          LearnerRecordingState.error => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.recordingFailed),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: service.clear,
                child: Text(l10n.continueWithoutRecording),
              ),
            ],
          ),
        },
      ],
    );
  }
}
