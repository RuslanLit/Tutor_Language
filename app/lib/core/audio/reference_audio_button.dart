import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import 'reference_audio.dart';
import 'reference_audio_providers.dart';

class ReferenceAudioButton extends ConsumerStatefulWidget {
  const ReferenceAudioButton({
    required this.referenceId,
    this.showLabel = false,
    super.key,
  });

  final String? referenceId;
  final bool showLabel;

  @override
  ConsumerState<ReferenceAudioButton> createState() =>
      _ReferenceAudioButtonState();
}

class _ReferenceAudioButtonState extends ConsumerState<ReferenceAudioButton> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final referenceId = widget.referenceId;
    if (referenceId == null || referenceId.isEmpty) {
      return const SizedBox.shrink();
    }

    final label = context.l10n.audioListen;
    final playbackService = ref.watch(referenceAudioPlaybackServiceProvider);
    final control = widget.showLabel
        ? OutlinedButton.icon(
            onPressed: _busy ? null : () => _play(playbackService, referenceId),
            icon: _busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.volume_up_outlined),
            label: Text(label),
          )
        : IconButton(
            tooltip: label,
            onPressed: _busy ? null : () => _play(playbackService, referenceId),
            icon: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.volume_up_outlined),
          );
    return Semantics(
      button: true,
      label: label,
      child: widget.showLabel
          ? Tooltip(message: label, child: control)
          : control,
    );
  }

  Future<void> _play(
    ReferenceAudioPlaybackService playbackService,
    String referenceId,
  ) async {
    setState(() => _busy = true);
    try {
      await playbackService.play(referenceId);
    } on ReferenceAudioFailure catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.audioUnavailable)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
