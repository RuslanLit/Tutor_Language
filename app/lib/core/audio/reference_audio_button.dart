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
  ReferenceAudioPlaybackMode? _busyMode;

  @override
  Widget build(BuildContext context) {
    final referenceId = widget.referenceId;
    if (referenceId == null || referenceId.isEmpty) {
      return const SizedBox.shrink();
    }

    final label = context.l10n.audioListen;
    final playbackService = ref.watch(referenceAudioPlaybackServiceProvider);
    final normalControl = widget.showLabel
        ? OutlinedButton.icon(
            onPressed: _busy ? null : () => _play(playbackService, referenceId),
            icon: _busy
                ? _busyMode == ReferenceAudioPlaybackMode.normal
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.volume_up_outlined)
                : const Icon(Icons.volume_up_outlined),
            label: Text(label),
          )
        : IconButton(
            tooltip: label,
            onPressed: _busy ? null : () => _play(playbackService, referenceId),
            icon: _busy
                ? _busyMode == ReferenceAudioPlaybackMode.normal
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.volume_up_outlined)
                : const Icon(Icons.volume_up_outlined),
          );
    const slowLabel = '0.75×';
    final slowControl = widget.showLabel
        ? OutlinedButton.icon(
            onPressed: _busy
                ? null
                : () => _play(
                    playbackService,
                    referenceId,
                    mode: ReferenceAudioPlaybackMode.slow,
                  ),
            icon: _busy && _busyMode == ReferenceAudioPlaybackMode.slow
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.slow_motion_video_outlined),
            label: const Text(slowLabel),
          )
        : IconButton(
            tooltip: slowLabel,
            onPressed: _busy
                ? null
                : () => _play(
                    playbackService,
                    referenceId,
                    mode: ReferenceAudioPlaybackMode.slow,
                  ),
            icon: _busy && _busyMode == ReferenceAudioPlaybackMode.slow
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.slow_motion_video_outlined),
          );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: label,
          child: widget.showLabel
              ? Tooltip(message: label, child: normalControl)
              : normalControl,
        ),
        Semantics(
          button: true,
          label: slowLabel,
          child: widget.showLabel
              ? Tooltip(message: slowLabel, child: slowControl)
              : slowControl,
        ),
      ],
    );
  }

  Future<void> _play(
    ReferenceAudioPlaybackService playbackService,
    String referenceId, {
    ReferenceAudioPlaybackMode mode = ReferenceAudioPlaybackMode.normal,
  }) async {
    setState(() {
      _busy = true;
      _busyMode = mode;
    });
    try {
      await playbackService.play(referenceId, mode: mode);
    } on ReferenceAudioFailure catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.audioUnavailable)));
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _busyMode = null;
        });
      }
    }
  }
}
