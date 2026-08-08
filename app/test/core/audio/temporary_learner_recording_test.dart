import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/audio/reference_audio.dart';
import 'package:tutor_language/core/audio/temporary_learner_recording.dart';
import 'package:tutor_language/core/content/audio_reference_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('permission is requested only when recording starts', () async {
    final recorder = _FakeRecorder();
    final service = _service(recorder: recorder);

    expect(recorder.permissionChecks, 0);
    expect(service.state, LearnerRecordingState.idle);

    await service.start();

    expect(recorder.permissionChecks, 1);
    expect(service.state, LearnerRecordingState.recording);
    await service.shutdown();
  });

  test('start and stop produce one temporary recording', () async {
    final files = _FakeFiles();
    final recorder = _FakeRecorder(files: files);
    final service = _service(recorder: recorder, files: files);

    await service.start();
    await service.stop();

    expect(service.state, LearnerRecordingState.recorded);
    expect(service.hasRecording, isTrue);
    expect(files.deleted, isEmpty);
    await service.shutdown();
    expect(files.deleted, hasLength(1));
  });

  test(
    'denied permission is recoverable and does not start recording',
    () async {
      final recorder = _FakeRecorder(permission: false);
      final service = _service(recorder: recorder);

      await service.start();

      expect(service.state, LearnerRecordingState.permissionDenied);
      expect(recorder.startCalls, 0);
      await service.shutdown();
    },
  );

  test('record again removes the prior temporary recording', () async {
    final files = _FakeFiles();
    final recorder = _FakeRecorder(files: files);
    final service = _service(recorder: recorder, files: files);

    await service.start();
    await service.stop();
    await service.start();

    expect(files.deleted, hasLength(1));
    expect(service.state, LearnerRecordingState.recording);
    await service.shutdown();
  });

  test('cancel and clear delete temporary audio idempotently', () async {
    final files = _FakeFiles();
    final recorder = _FakeRecorder(files: files);
    final service = _service(recorder: recorder, files: files);

    await service.start();
    await service.cancel();
    await service.clear();

    expect(service.state, LearnerRecordingState.idle);
    expect(files.deleted, hasLength(1));
    await service.shutdown();
  });

  test('recording playback returns to recorded state', () async {
    final files = _FakeFiles();
    final recorder = _FakeRecorder(files: files);
    final playback = _FakePlayback();
    final service = _service(
      recorder: recorder,
      files: files,
      playback: playback,
    );

    await service.start();
    await service.stop();
    await service.play();

    expect(service.state, LearnerRecordingState.recorded);
    expect(playback.filePaths, hasLength(1));
    await service.shutdown();
  });

  test(
    'app interruption cancels recording and removes the partial file',
    () async {
      final files = _FakeFiles();
      final recorder = _FakeRecorder(files: files);
      final service = _service(recorder: recorder, files: files);

      await service.start();
      service.didChangeAppLifecycleState(AppLifecycleState.paused);
      await Future<void>.delayed(Duration.zero);

      expect(service.state, LearnerRecordingState.idle);
      expect(files.deleted, hasLength(1));
      await service.shutdown();
    },
  );

  test('stale cleanup is delegated to the narrow recording store', () async {
    final files = _FakeFiles();
    final service = _service(files: files);

    await Future<void>.delayed(Duration.zero);

    expect(files.cleanupCalls, 1);
    await service.shutdown();
  });
}

TemporaryLearnerRecordingService _service({
  _FakeRecorder? recorder,
  _FakeFiles? files,
  _FakePlayback? playback,
}) {
  final actualFiles = files ?? _FakeFiles();
  return TemporaryLearnerRecordingService(
    recorder: recorder ?? _FakeRecorder(files: actualFiles),
    files: actualFiles,
    referencePlayback: ReferenceAudioPlaybackService(
      repository: Future.value(
        const ReferenceAudioRepository(
          AudioReferenceManifest(
            schemaVersion: 1,
            audioRoot: 'assets',
            assets: [],
          ),
        ),
      ),
      backend: playback ?? _FakePlayback(),
    ),
  );
}

class _FakeRecorder implements LearnerRecorderBackend {
  _FakeRecorder({this.files, this.permission = true});

  final _FakeFiles? files;
  final bool permission;
  int permissionChecks = 0;
  int startCalls = 0;
  String? currentPath;

  @override
  Future<bool> hasPermission() async {
    permissionChecks++;
    return permission;
  }

  @override
  Future<void> start(String path) async {
    startCalls++;
    currentPath = path;
  }

  @override
  Future<String?> stop() async {
    final path = currentPath;
    if (path != null) files?.existing.add(path);
    currentPath = null;
    return path;
  }

  @override
  Future<void> cancel() async {
    currentPath = null;
  }

  @override
  Future<void> dispose() async {}
}

class _FakeFiles implements LearnerRecordingFileStore {
  final existing = <String>{};
  final deleted = <String>[];
  int cleanupCalls = 0;
  int _next = 0;

  @override
  Future<String> createPath() async => 'temporary-${_next++}.wav';

  @override
  Future<bool> exists(String filePath) async => existing.contains(filePath);

  @override
  Future<int> length(String filePath) async =>
      existing.contains(filePath) ? 1 : 0;

  @override
  Future<void> delete(String filePath) async {
    existing.remove(filePath);
    deleted.add(filePath);
  }

  @override
  Future<void> cleanupStale() async => cleanupCalls++;
}

class _FakePlayback implements ReferenceAudioBackend {
  final filePaths = <String>[];

  @override
  Future<void> setAsset(String assetPath) async {}

  @override
  Future<void> setFile(String filePath) async => filePaths.add(filePath);

  @override
  Future<void> play() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}
