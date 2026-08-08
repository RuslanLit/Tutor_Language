import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../content/audio_reference_models.dart';

enum ReferenceAudioFailureCode {
  unknownReference,
  notApproved,
  assetUnavailable,
  playbackFailure,
}

class ReferenceAudioFailure implements Exception {
  const ReferenceAudioFailure(this.code, this.message);

  final ReferenceAudioFailureCode code;
  final String message;

  @override
  String toString() => message;
}

class ReferenceAudioRepository {
  const ReferenceAudioRepository(this.manifest);

  final AudioReferenceManifest manifest;

  AudioReferenceAsset getById(String id) {
    final asset = _find(id);
    if (asset == null) {
      throw const ReferenceAudioFailure(
        ReferenceAudioFailureCode.unknownReference,
        'The requested audio reference does not exist.',
      );
    }
    return asset;
  }

  AudioReferenceAsset getApprovedById(String id) {
    final asset = getById(id);
    if (asset.qaStatus != AudioReferenceQaStatus.approved) {
      throw const ReferenceAudioFailure(
        ReferenceAudioFailureCode.notApproved,
        'The requested audio reference is not approved for learners.',
      );
    }
    return asset;
  }

  AudioReferenceAsset resolveApproved(String id) => getApprovedById(id);

  AudioReferenceAsset? _find(String id) {
    for (final asset in manifest.assets) {
      if (asset.id == id) return asset;
    }
    return null;
  }
}

abstract interface class ReferenceAudioBackend {
  Future<void> setAsset(String assetPath);
  Future<void> setFile(String filePath);
  Future<void> play();
  Future<void> stop();
  Future<void> dispose();
}

class JustAudioReferenceBackend implements ReferenceAudioBackend {
  JustAudioReferenceBackend() : _player = AudioPlayer() {
    _player.playerStateStream.listen((state) {
      _debugAudio(
        'playerState processingState=${state.processingState} playing=${state.playing}',
      );
    });
    _player.processingStateStream.listen(
      (state) => _debugAudio('processingState=$state'),
    );
    _debugAudio('player-instance=${identityHashCode(_player)}');
  }

  final AudioPlayer _player;

  @override
  Future<void> setAsset(String assetPath) async {
    _debugAudio('setAsset-start path=$assetPath');
    final duration = await _player.setAsset(assetPath);
    _debugAudio(
      'setAsset-complete duration=$duration volume=${_player.volume} '
      'speed=${_player.speed} processingState=${_player.processingState} '
      'playing=${_player.playing} position=${_player.position}',
    );
  }

  @override
  Future<void> setFile(String filePath) async {
    _debugAudio('setFile-start path=$filePath');
    final duration = await _player.setFilePath(filePath);
    _debugAudio(
      'setFile-complete duration=$duration volume=${_player.volume} '
      'speed=${_player.speed} processingState=${_player.processingState} '
      'playing=${_player.playing} position=${_player.position}',
    );
  }

  @override
  Future<void> play() async {
    _debugAudio(
      'play-called volume=${_player.volume} speed=${_player.speed} '
      'processingState=${_player.processingState} playing=${_player.playing}',
    );
    await _player.play();
    _debugAudio('play-complete position=${_player.position}');
  }

  @override
  Future<void> stop() async {
    _debugAudio('stop-called');
    await _player.stop();
  }

  @override
  Future<void> dispose() async {
    _debugAudio('dispose-called player-instance=${identityHashCode(_player)}');
    await _player.dispose();
  }
}

class ReferenceAudioPlaybackService {
  ReferenceAudioPlaybackService({
    required this.repository,
    required this.backend,
  });

  final Future<ReferenceAudioRepository> repository;
  final ReferenceAudioBackend backend;
  String? _activeReferenceId;
  bool _disposed = false;

  Future<void> Function()? beforeLearnerRecording;

  String? get activeReferenceId => _activeReferenceId;

  Future<void> play(String referenceId) async {
    if (_disposed) return;
    _debugAudio('play-request reference-id=$referenceId');
    try {
      await beforeLearnerRecording?.call();
      final asset = (await repository).getApprovedById(referenceId);
      _debugAudio('resolved-asset-path=${asset.assetPath}');
      // One backend/player is deliberately shared: every play request stops
      // the previous item and reloads the requested asset from the beginning.
      await backend.stop();
      try {
        await backend.setAsset(asset.assetPath);
      } on Object catch (error) {
        throw ReferenceAudioFailure(
          ReferenceAudioFailureCode.assetUnavailable,
          'Reference audio asset is unavailable: $error',
        );
      }
      _activeReferenceId = referenceId;
      await backend.play();
    } on ReferenceAudioFailure {
      rethrow;
    } on Object catch (error) {
      throw ReferenceAudioFailure(
        ReferenceAudioFailureCode.playbackFailure,
        'Reference audio playback failed: $error',
      );
    }
  }

  Future<void> playFile(
    String filePath, {
    bool notifyBeforeLearnerRecording = true,
  }) async {
    if (_disposed) return;
    try {
      if (notifyBeforeLearnerRecording) {
        await beforeLearnerRecording?.call();
      }
      await backend.stop();
      await backend.setFile(filePath);
      await backend.play();
    } on Object catch (error) {
      throw ReferenceAudioFailure(
        ReferenceAudioFailureCode.playbackFailure,
        'Temporary recording playback failed: $error',
      );
    }
  }

  Future<void> stop() async {
    if (_disposed) return;
    _debugAudio('service-stop-called');
    await backend.stop();
    _activeReferenceId = null;
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _debugAudio('service-dispose-called');
    _disposed = true;
    _activeReferenceId = null;
    await backend.stop();
    await backend.dispose();
  }
}

void _debugAudio(String message) {
  if (kDebugMode) {
    debugPrint('[reference_audio] $message');
  }
}
