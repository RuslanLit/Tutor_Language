import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/audio/reference_audio.dart';
import '../../core/audio/reference_audio_providers.dart';
import '../../core/audio/temporary_learner_recording.dart';
import '../../core/content/spoken_practice.dart';
import '../../features/curriculum/curriculum_models.dart';

enum SpokenPracticeStage {
  readyForExposure,
  exposureAvailable,
  readyForAttempt,
  recording,
  attemptCompleted,
  referenceRevealed,
  completed,
}

class SpokenPracticeController extends ChangeNotifier {
  SpokenPracticeController({
    required this.activity,
    required this.recording,
    required this.referencePlayback,
  }) {
    _debugSpokenPractice(
      'controller-created activity=${activity.id} '
      'mode=${activity.definition.mode.code} identity=${identityHashCode(this)}',
    );
    recording.addListener(_onRecordingChanged);
    _stage = switch (activity.definition.mode) {
      SpokenPracticeMode.listenRepeat => SpokenPracticeStage.exposureAvailable,
      SpokenPracticeMode.delayedImitation =>
        SpokenPracticeStage.readyForExposure,
      SpokenPracticeMode.spokenRecall => SpokenPracticeStage.readyForAttempt,
    };
  }

  final SpokenPracticeActivity activity;
  final TemporaryLearnerRecordingService recording;
  final ReferenceAudioPlaybackService referencePlayback;

  late SpokenPracticeStage _stage;
  bool _closed = false;

  SpokenPracticeDefinition get definition => activity.definition;
  SpokenPracticeStage get stage => _stage;
  bool get targetVisible {
    if (definition.mode == SpokenPracticeMode.listenRepeat) return true;
    if (definition.mode == SpokenPracticeMode.delayedImitation) {
      return _stage != SpokenPracticeStage.readyForAttempt &&
          _stage != SpokenPracticeStage.recording &&
          _stage != SpokenPracticeStage.attemptCompleted;
    }
    return _stage == SpokenPracticeStage.referenceRevealed ||
        _stage == SpokenPracticeStage.completed;
  }

  bool get referencePlayable =>
      definition.mode != SpokenPracticeMode.spokenRecall || targetVisible;
  bool get canRecord =>
      _stage == SpokenPracticeStage.exposureAvailable ||
      _stage == SpokenPracticeStage.readyForAttempt;
  bool get isBeforeReveal =>
      definition.mode == SpokenPracticeMode.spokenRecall && !targetVisible;

  Future<void> playReference() async {
    if (!referencePlayable || _stage == SpokenPracticeStage.recording) {
      _debugSpokenPractice(
        'play-reference-ignored activity=${activity.id} stage=$_stage',
      );
      return;
    }
    _debugSpokenPractice(
      'play-reference activity=${activity.id} stage=$_stage',
    );
    await referencePlayback.play(definition.audioReferenceId);
    if (_stage == SpokenPracticeStage.readyForExposure) {
      _setStage(SpokenPracticeStage.exposureAvailable);
    }
  }

  void tryFromMemory() {
    _debugSpokenPractice(
      'try-from-memory activity=${activity.id} stage=$_stage',
    );
    if (definition.mode == SpokenPracticeMode.delayedImitation &&
        _stage == SpokenPracticeStage.exposureAvailable) {
      _setStage(SpokenPracticeStage.readyForAttempt);
    }
  }

  Future<void> startRecording() async {
    if (!canRecord) {
      _debugSpokenPractice(
        'record-ignored activity=${activity.id} stage=$_stage',
      );
      return;
    }
    _debugSpokenPractice(
      'record-request activity=${activity.id} stage=$_stage '
      'recordingState=${recording.state}',
    );
    try {
      await recording.start();
    } on Object catch (error) {
      _debugSpokenPractice('record-error activity=${activity.id} error=$error');
      notifyListeners();
      return;
    }
    _debugSpokenPractice(
      'record-result activity=${activity.id} state=${recording.state}',
    );
    if (recording.state == LearnerRecordingState.recording) {
      _setStage(SpokenPracticeStage.recording);
    }
  }

  Future<void> stopRecording() async {
    if (_stage != SpokenPracticeStage.recording) {
      _debugSpokenPractice(
        'stop-ignored activity=${activity.id} stage=$_stage',
      );
      return;
    }
    _debugSpokenPractice('stop-request activity=${activity.id} stage=$_stage');
    await recording.stop();
    if (recording.hasRecording) {
      _setStage(SpokenPracticeStage.attemptCompleted);
    }
  }

  void finishAttemptWithoutRecording() {
    if (_stage == SpokenPracticeStage.readyForAttempt ||
        _stage == SpokenPracticeStage.exposureAvailable) {
      _setStage(SpokenPracticeStage.attemptCompleted);
    }
  }

  Future<void> revealReference() async {
    if (_stage != SpokenPracticeStage.attemptCompleted) {
      _debugSpokenPractice(
        'reveal-ignored activity=${activity.id} stage=$_stage',
      );
      return;
    }
    _debugSpokenPractice('reveal activity=${activity.id} stage=$_stage');
    _setStage(SpokenPracticeStage.referenceRevealed);
  }

  Future<void> playLearnerRecording() => recording.play();

  Future<void> retry() async {
    _debugSpokenPractice('retry activity=${activity.id} stage=$_stage');
    await recording.clear();
    _setStage(switch (definition.mode) {
      SpokenPracticeMode.listenRepeat => SpokenPracticeStage.exposureAvailable,
      SpokenPracticeMode.delayedImitation =>
        SpokenPracticeStage.readyForExposure,
      SpokenPracticeMode.spokenRecall => SpokenPracticeStage.readyForAttempt,
    });
  }

  Future<void> continuePractice() async {
    final allowed = definition.mode == SpokenPracticeMode.listenRepeat
        ? _stage == SpokenPracticeStage.exposureAvailable ||
              _stage == SpokenPracticeStage.attemptCompleted ||
              _stage == SpokenPracticeStage.referenceRevealed
        : _stage == SpokenPracticeStage.referenceRevealed;
    if (!allowed) {
      _debugSpokenPractice(
        'continue-ignored activity=${activity.id} stage=$_stage',
      );
      return;
    }
    _debugSpokenPractice(
      'continue-request activity=${activity.id} stage=$_stage',
    );
    try {
      await recording.clear();
    } on Object catch (error) {
      // Completion is a learner-flow transition. AF3 owns best-effort cleanup;
      // a playback cleanup failure must not strand the learner on this step.
      _debugSpokenPractice(
        'continue-cleanup-error activity=${activity.id} error=$error',
      );
    }
    _setStage(SpokenPracticeStage.completed);
  }

  void _onRecordingChanged() {
    if (_closed) return;
    if (recording.state == LearnerRecordingState.recording &&
        _stage != SpokenPracticeStage.recording) {
      _setStage(SpokenPracticeStage.recording);
    } else if (recording.state == LearnerRecordingState.recorded &&
        _stage == SpokenPracticeStage.recording) {
      _setStage(SpokenPracticeStage.attemptCompleted);
    } else if (recording.state == LearnerRecordingState.permissionDenied ||
        recording.state == LearnerRecordingState.error) {
      _debugSpokenPractice(
        'recording-failure activity=${activity.id} state=${recording.state} '
        'failure=${recording.failure}',
      );
      notifyListeners();
    }
  }

  void _setStage(SpokenPracticeStage stage) {
    if (_closed || _stage == stage) return;
    _stage = stage;
    _debugSpokenPractice('stage activity=${activity.id} stage=$stage');
    notifyListeners();
  }

  @override
  void dispose() {
    _closed = true;
    recording.removeListener(_onRecordingChanged);
    _debugSpokenPractice(
      'controller-disposed activity=${activity.id} identity=${identityHashCode(this)}',
    );
    super.dispose();
  }
}

final spokenPracticeControllerProvider = ChangeNotifierProvider.autoDispose
    .family<SpokenPracticeController, SpokenPracticeActivity>((ref, activity) {
      // Keep the AF3 service alive without making its ChangeNotifier updates
      // invalidate this controller provider. The controller listens to those
      // updates explicitly in its constructor.
      final recording = ref.watch(
        temporaryLearnerRecordingServiceProvider.notifier,
      );
      final referencePlayback = ref.watch(
        referenceAudioPlaybackServiceProvider,
      );
      final controller = SpokenPracticeController(
        activity: activity,
        recording: recording,
        referencePlayback: referencePlayback,
      );
      if (kDebugMode) {
        debugPrint(
          '[af4_spoken] provider-watch activity=${activity.id} '
          'controller=${identityHashCode(controller)}',
        );
      }
      ref.onDispose(() {
        if (kDebugMode) {
          debugPrint(
            '[af4_spoken] provider-dispose activity=${activity.id} '
            'controller=${identityHashCode(controller)}',
          );
        }
      });
      return controller;
    });

void _debugSpokenPractice(String message) {
  if (kDebugMode) debugPrint('[af4_spoken] $message');
}
