import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'reference_audio.dart';

enum LearnerRecordingState {
  idle,
  requestingPermission,
  recording,
  recorded,
  playing,
  permissionDenied,
  error,
}

enum LearnerRecordingFailureCode {
  permissionDenied,
  recordingStartFailed,
  recordingStopFailed,
  recordingUnavailable,
  playbackFailed,
  cleanupFailed,
}

class LearnerRecordingFailure implements Exception {
  const LearnerRecordingFailure(this.code, this.message);

  final LearnerRecordingFailureCode code;
  final String message;

  @override
  String toString() => message;
}

abstract interface class LearnerRecorderBackend {
  Future<bool> hasPermission();
  Future<void> start(String path);
  Future<String?> stop();
  Future<void> cancel();
  Future<void> dispose();
}

class RecordLearnerRecorderBackend implements LearnerRecorderBackend {
  RecordLearnerRecorderBackend() : _recorder = AudioRecorder();

  final AudioRecorder _recorder;

  @override
  Future<bool> hasPermission() => _recorder.hasPermission();

  @override
  Future<void> start(String filePath) async {
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: filePath,
    );
  }

  @override
  Future<String?> stop() => _recorder.stop();

  @override
  Future<void> cancel() => _recorder.cancel();

  @override
  Future<void> dispose() => _recorder.dispose();
}

abstract interface class LearnerRecordingFileStore {
  Future<String> createPath();
  Future<bool> exists(String filePath);
  Future<int> length(String filePath);
  Future<void> delete(String filePath);
  Future<void> cleanupStale();
}

class AppTemporaryLearnerRecordingFileStore
    implements LearnerRecordingFileStore {
  AppTemporaryLearnerRecordingFileStore({Future<Directory>? directory})
    : _directory = directory ?? getTemporaryDirectory();

  static const prefix = 'tutor_language_recording_';
  final Future<Directory> _directory;

  @override
  Future<String> createPath() async {
    final directory = await _directory;
    await directory.create(recursive: true);
    final opaque = DateTime.now().microsecondsSinceEpoch.toString();
    return path.join(directory.path, '$prefix$opaque.wav');
  }

  @override
  Future<bool> exists(String filePath) => File(filePath).exists();

  @override
  Future<int> length(String filePath) => File(filePath).length();

  @override
  Future<void> delete(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) await file.delete();
  }

  @override
  Future<void> cleanupStale() async {
    final directory = await _directory;
    if (!await directory.exists()) return;
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is File && path.basename(entity.path).startsWith(prefix)) {
        await entity.delete();
      }
    }
  }
}

class TemporaryLearnerRecordingService extends ChangeNotifier
    with WidgetsBindingObserver {
  TemporaryLearnerRecordingService({
    required this.recorder,
    required this.files,
    required this.referencePlayback,
  }) {
    _debugRecording('service-created');
    WidgetsBinding.instance.addObserver(this);
    unawaited(_cleanupStaleFiles());
  }

  final LearnerRecorderBackend recorder;
  final LearnerRecordingFileStore files;
  final ReferenceAudioPlaybackService referencePlayback;

  LearnerRecordingState _state = LearnerRecordingState.idle;
  String? _filePath;
  LearnerRecordingFailure? _failure;
  bool _closed = false;

  LearnerRecordingState get state => _state;
  LearnerRecordingFailure? get failure => _failure;
  bool get hasRecording => _state == LearnerRecordingState.recorded;

  Future<void> start() async {
    if (_closed || _state == LearnerRecordingState.recording) return;
    _debugRecording('start-request');
    await clear();
    _setState(LearnerRecordingState.requestingPermission);
    final permitted = await recorder.hasPermission();
    _debugRecording('permission-result permitted=$permitted');
    if (!permitted) {
      _setState(LearnerRecordingState.permissionDenied);
      return;
    }

    await referencePlayback.stop();
    final filePath = await files.createPath();
    try {
      await recorder.start(filePath);
      _debugRecording('recording-started');
      _filePath = filePath;
      _setState(LearnerRecordingState.recording);
    } on Object catch (error) {
      await _deleteFile(filePath);
      _fail(
        LearnerRecordingFailureCode.recordingStartFailed,
        'Recording could not start: $error',
      );
    }
  }

  Future<void> stop() async {
    if (_state != LearnerRecordingState.recording) return;
    _debugRecording('stop-request');
    try {
      final stoppedPath = await recorder.stop();
      final filePath = stoppedPath ?? _filePath;
      if (filePath == null ||
          !await files.exists(filePath) ||
          await files.length(filePath) == 0) {
        throw const LearnerRecordingFailure(
          LearnerRecordingFailureCode.recordingUnavailable,
          'Recording file is unavailable.',
        );
      }
      _filePath = filePath;
      _debugRecording('recording-stopped file-ready=true');
      _setState(LearnerRecordingState.recorded);
    } on LearnerRecordingFailure catch (error) {
      await _deleteCurrentFile();
      _failure = error;
      _setState(LearnerRecordingState.error);
    } on Object catch (error) {
      await _deleteCurrentFile();
      _fail(
        LearnerRecordingFailureCode.recordingStopFailed,
        'Recording could not stop: $error',
      );
    }
  }

  Future<void> cancel() async {
    _debugRecording('cancel-request');
    if (_state == LearnerRecordingState.recording) {
      await recorder.cancel();
    }
    await _deleteCurrentFile();
    _setState(LearnerRecordingState.idle);
  }

  Future<void> play() async {
    final filePath = _filePath;
    if (_state != LearnerRecordingState.recorded || filePath == null) return;
    if (!await files.exists(filePath)) {
      _fail(
        LearnerRecordingFailureCode.recordingUnavailable,
        'Recording file is unavailable.',
      );
      return;
    }
    try {
      _debugRecording('play-request');
      await referencePlayback.stop();
      _setState(LearnerRecordingState.playing);
      await referencePlayback.playFile(
        filePath,
        notifyBeforeLearnerRecording: false,
      );
      _setState(LearnerRecordingState.recorded);
    } on Object catch (error) {
      _fail(
        LearnerRecordingFailureCode.playbackFailed,
        'Recording playback failed: $error',
      );
    }
  }

  Future<void> clear() async {
    _debugRecording('clear-request');
    if (_state == LearnerRecordingState.recording) {
      await recorder.cancel();
    }
    await referencePlayback.stop();
    await _deleteCurrentFile();
    _setState(LearnerRecordingState.idle);
  }

  Future<void> stopForReferencePlayback() async {
    _debugRecording('reference-playback-coordination state=$_state');
    if (_state == LearnerRecordingState.recording) {
      await cancel();
    } else if (_state == LearnerRecordingState.playing) {
      await referencePlayback.stop();
      _setState(LearnerRecordingState.recorded);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      unawaited(cancel());
    }
  }

  Future<void> _cleanupStaleFiles() async {
    try {
      await files.cleanupStale();
    } on Object catch (_) {
      // Stale cleanup is best effort and never blocks the recording control.
    }
  }

  Future<void> _deleteCurrentFile() async {
    final filePath = _filePath;
    _filePath = null;
    if (filePath != null) await _deleteFile(filePath);
  }

  Future<void> _deleteFile(String filePath) async {
    try {
      await files.delete(filePath);
    } on Object catch (error) {
      _fail(
        LearnerRecordingFailureCode.cleanupFailed,
        'Temporary recording cleanup failed: $error',
      );
    }
  }

  void _fail(LearnerRecordingFailureCode code, String message) {
    _failure = LearnerRecordingFailure(code, message);
    _setState(LearnerRecordingState.error);
  }

  void _setState(LearnerRecordingState state) {
    if (_closed) return;
    _state = state;
    notifyListeners();
  }

  Future<void> shutdown() async {
    if (_closed) return;
    _debugRecording('shutdown');
    _closed = true;
    WidgetsBinding.instance.removeObserver(this);
    if (_state == LearnerRecordingState.recording) {
      await recorder.cancel();
    }
    await referencePlayback.stop();
    await _deleteCurrentFile();
    await recorder.dispose();
  }

  @override
  void dispose() {
    unawaited(shutdown());
    super.dispose();
  }
}

void _debugRecording(String message) {
  if (kDebugMode) {
    debugPrint('[learner_recording] $message');
  }
}
