import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/audio/reference_audio.dart';
import 'package:tutor_language/core/audio/reference_audio_providers.dart';
import 'package:tutor_language/core/audio/temporary_learner_recording.dart';
import 'package:tutor_language/core/content/audio_reference_models.dart';
import 'package:tutor_language/core/content/content_localization.dart';
import 'package:tutor_language/core/content/content_localization_providers.dart';
import 'package:tutor_language/core/content/spoken_practice.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_content.dart';
import 'package:tutor_language/features/lesson_player/spoken_practice_controller.dart';
import 'package:tutor_language/features/lesson_player/spoken_practice_view.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('spoken recall hides target and reference until reveal', () async {
    final recording = _recording();
    final controller = SpokenPracticeController(
      activity: _activity(SpokenPracticeMode.spokenRecall),
      recording: recording,
      referencePlayback: _playback(),
    );

    expect(controller.targetVisible, isFalse);
    expect(controller.referencePlayable, isFalse);
    expect(controller.stage, SpokenPracticeStage.readyForAttempt);

    controller.finishAttemptWithoutRecording();
    await controller.revealReference();

    expect(controller.targetVisible, isTrue);
    expect(controller.referencePlayable, isTrue);
    await controller.retry();
    expect(controller.targetVisible, isFalse);
    expect(controller.stage, SpokenPracticeStage.readyForAttempt);
    controller.dispose();
  });

  test(
    'delayed imitation has a real retrieval gap and deterministic retry',
    () async {
      final controller = SpokenPracticeController(
        activity: _activity(SpokenPracticeMode.delayedImitation),
        recording: _recording(),
        referencePlayback: _playback(),
      );

      expect(controller.targetVisible, isTrue);
      await controller.playReference();
      controller.tryFromMemory();
      expect(controller.targetVisible, isFalse);
      expect(controller.stage, SpokenPracticeStage.readyForAttempt);
      controller.finishAttemptWithoutRecording();
      await controller.revealReference();
      expect(controller.targetVisible, isTrue);
      await controller.retry();
      expect(controller.stage, SpokenPracticeStage.readyForExposure);
      expect(controller.targetVisible, isTrue);
      controller.dispose();
    },
  );

  test('spoken practice completion is not an evaluated result', () async {
    final controller = SpokenPracticeController(
      activity: _activity(SpokenPracticeMode.spokenRecall),
      recording: _recording(),
      referencePlayback: _playback(),
    );

    controller.finishAttemptWithoutRecording();
    await controller.revealReference();
    await controller.continuePractice();

    expect(controller.stage, SpokenPracticeStage.completed);
    controller.dispose();
  });

  test('recreated spoken recall starts safely before reveal', () async {
    final first = SpokenPracticeController(
      activity: _activity(SpokenPracticeMode.spokenRecall),
      recording: _recording(),
      referencePlayback: _playback(),
    );
    first.finishAttemptWithoutRecording();
    await first.revealReference();
    expect(first.targetVisible, isTrue);
    first.dispose();

    final recreated = SpokenPracticeController(
      activity: _activity(SpokenPracticeMode.spokenRecall),
      recording: _recording(),
      referencePlayback: _playback(),
    );
    expect(recreated.targetVisible, isFalse);
    expect(recreated.referencePlayable, isFalse);
    expect(recreated.recording.hasRecording, isFalse);
    recreated.dispose();
  });

  testWidgets('listen and repeat continues without recording and unlocks UI', (
    tester,
  ) async {
    final recording = _recording();
    final activity = _activity(SpokenPracticeMode.listenRepeat);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          temporaryLearnerRecordingServiceProvider.overrideWith(
            (ref) => recording,
          ),
          referenceAudioPlaybackServiceProvider.overrideWith(
            (ref) => _playback(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: SpokenPracticeView(activity: activity)),
        ),
      ),
    );

    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(find.text('Practice complete'), findsOneWidget);
    expect(find.text('Listen to reference'), findsOneWidget);
    expect(recording.state, LearnerRecordingState.idle);
  });

  testWidgets('permission denial is visible and does not block continue', (
    tester,
  ) async {
    final recording = _recording(permissionGranted: false);
    final activity = _activity(SpokenPracticeMode.listenRepeat);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          temporaryLearnerRecordingServiceProvider.overrideWith(
            (ref) => recording,
          ),
          referenceAudioPlaybackServiceProvider.overrideWith(
            (ref) => _playback(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: SpokenPracticeView(activity: activity)),
        ),
      ),
    );

    await tester.tap(find.text('Record'));
    await tester.pump();
    expect(find.textContaining('Microphone access was denied'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(find.text('Practice complete'), findsOneWidget);
  });

  testWidgets('record action reaches the live AF3 service', (tester) async {
    final recording = _recording();
    final activity = _activity(SpokenPracticeMode.listenRepeat);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          temporaryLearnerRecordingServiceProvider.overrideWith(
            (ref) => recording,
          ),
          referenceAudioPlaybackServiceProvider.overrideWith(
            (ref) => _playback(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: SpokenPracticeView(activity: activity)),
        ),
      ),
    );

    await tester.tap(find.text('Record'));
    await tester.pump();

    expect(recording.state, LearnerRecordingState.recording);
    expect(find.text('Stop recording'), findsOneWidget);
  });

  test('equivalent activity rebuild keeps one provider controller', () {
    final recording = _recording();
    final playback = _playback();
    final container = ProviderContainer(
      overrides: [
        temporaryLearnerRecordingServiceProvider.overrideWith(
          (ref) => recording,
        ),
        referenceAudioPlaybackServiceProvider.overrideWith((ref) => playback),
      ],
    );
    addTearDown(container.dispose);
    final activity = _activity(SpokenPracticeMode.listenRepeat);
    final subscription = container.listen(
      spokenPracticeControllerProvider(activity),
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    final first = container.read(spokenPracticeControllerProvider(activity));
    final second = container.read(
      spokenPracticeControllerProvider(
        _activity(SpokenPracticeMode.listenRepeat),
      ),
    );

    expect(identical(first, second), isTrue);
  });

  test(
    'Ukrainian localization updates the rendered spoken-practice object',
    () {
      const activityId = 'spoken.localization.test';
      final activity = LessonActivity(
        id: activityId,
        title: 'Repeat the greeting aloud',
        type: 'spoken_practice',
        spokenPractice: const SpokenPracticeDefinition(
          mode: SpokenPracticeMode.listenRepeat,
          audioReferenceId: 'es.audio.phrase.me_llamo',
          prompt: 'Listen and repeat the greeting aloud.',
          targetText: 'Hola.',
          focusCue: 'Notice the rhythm.',
        ),
      );
      final lesson = Lesson(
        metadata: const LessonMetadata(
          id: 'lesson.localization.test',
          title: 'Test lesson',
          moduleId: 'module.test',
          courseId: 'course.test',
          estimatedDurationMinutes: 5,
          difficulty: 'A0',
          tags: [],
          version: '1',
          prerequisites: [],
        ),
        completionCriteria: const LessonCompletionCriteria(),
        sections: [
          LessonSection(
            id: 'section.test',
            title: 'Section',
            order: 1,
            activities: [activity],
          ),
        ],
      );
      final localized = resolveLocalizedLessonContent(
        lessonContent: LessonContent(
          lesson: lesson,
          sections: [
            LessonContentSection(
              section: lesson.sections.single,
              activities: [
                LessonContentActivity(
                  activity: activity,
                  resolvedContent: [
                    SpokenPracticeActivity(
                      id: activityId,
                      definition: activity.spokenPractice!,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        resolver: EducationalContentLocalizationResolver(
          const EducationalContentLocalizationBundle(
            schemaVersion: 1,
            targetLanguage: 'es',
            sourceSupportLocale: 'en',
            supportLocales: ['en', 'uk'],
            entries: [
              LocalizedEducationalEntry(
                type: 'lesson_activity',
                id: activityId,
                fields: {
                  'title': {'uk': 'Повторіть привітання вголос'},
                  'spokenPractice.prompt': {
                    'uk': 'Послухайте й повторіть привітання вголос.',
                  },
                  'spokenPractice.focusCue': {'uk': 'Зверніть увагу на ритм.'},
                },
              ),
            ],
          ),
        ),
        supportLocale: SupportLocale.ukrainian,
      );

      final rendered = localized.activities.single.resolvedContent
          .whereType<SpokenPracticeActivity>()
          .single;
      expect(
        rendered.definition.prompt,
        'Послухайте й повторіть привітання вголос.',
      );
      expect(rendered.definition.focusCue, 'Зверніть увагу на ритм.');
    },
  );

  testWidgets('spoken recall semantics do not contain the hidden answer', (
    tester,
  ) async {
    final recording = _recording();
    final playback = _playback();
    final activity = _activity(SpokenPracticeMode.spokenRecall);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          temporaryLearnerRecordingServiceProvider.overrideWith(
            (ref) => recording,
          ),
          referenceAudioPlaybackServiceProvider.overrideWith((ref) => playback),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: SpokenPracticeView(activity: activity)),
        ),
      ),
    );

    expect(find.text('Me llamo Ana.'), findsNothing);
    expect(find.text('Listen to reference'), findsNothing);
    expect(find.text('Say in Spanish: My name is Ana.'), findsOneWidget);

    await tester.tap(find.text('Finish attempt'));
    await tester.pump();
    await tester.tap(find.text('Show reference'));
    await tester.pump();

    expect(find.text('Me llamo Ana.'), findsOneWidget);
    expect(find.text('Listen to reference'), findsOneWidget);
  });
}

SpokenPracticeActivity _activity(SpokenPracticeMode mode) {
  return SpokenPracticeActivity(
    id: 'spoken.test',
    definition: SpokenPracticeDefinition(
      mode: mode,
      audioReferenceId: 'es.audio.phrase.me_llamo',
      prompt: 'Say in Spanish: My name is Ana.',
      targetText: 'Me llamo Ana.',
    ),
  );
}

TemporaryLearnerRecordingService _recording({bool permissionGranted = true}) {
  final files = _FakeFiles();
  return TemporaryLearnerRecordingService(
    recorder: _FakeRecorder(files, permissionGranted: permissionGranted),
    files: files,
    referencePlayback: _playback(),
  );
}

ReferenceAudioPlaybackService _playback() {
  return ReferenceAudioPlaybackService(
    repository: Future.value(
      const ReferenceAudioRepository(
        AudioReferenceManifest(
          schemaVersion: 1,
          audioRoot: 'assets',
          assets: [
            AudioReferenceAsset(
              id: 'es.audio.phrase.me_llamo',
              assetPath: 'assets/me_llamo.wav',
              transcript: 'Me llamo Ana.',
              languageCode: 'es',
              locale: 'es_ES',
              voiceId: 'test',
              purpose: AudioReferencePurpose.phrase,
              qaStatus: AudioReferenceQaStatus.approved,
              provenance: AudioReferenceProvenance(
                engine: 'test',
                voice: 'test',
                locale: 'es_ES',
                generationRole: 'test',
              ),
            ),
          ],
        ),
      ),
    ),
    backend: _FakeBackend(),
  );
}

class _FakeRecorder implements LearnerRecorderBackend {
  _FakeRecorder(this.files, {required this.permissionGranted});

  final _FakeFiles files;
  final bool permissionGranted;
  String? currentPath;

  @override
  Future<bool> hasPermission() async => permissionGranted;

  @override
  Future<void> start(String path) async => currentPath = path;

  @override
  Future<String?> stop() async {
    final path = currentPath;
    if (path != null) files.existing.add(path);
    currentPath = null;
    return path;
  }

  @override
  Future<void> cancel() async => currentPath = null;

  @override
  Future<void> dispose() async {}
}

class _FakeFiles implements LearnerRecordingFileStore {
  int next = 0;
  final existing = <String>{};
  final deleted = <String>[];

  @override
  Future<String> createPath() async => 'recording-${next++}.wav';

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
  Future<void> cleanupStale() async {}
}

class _FakeBackend implements ReferenceAudioBackend {
  @override
  Future<void> setAsset(String assetPath) async {}

  @override
  Future<void> setFile(String filePath) async {}

  @override
  Future<void> setSpeed(double speed) async {}

  @override
  Future<void> play() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}
