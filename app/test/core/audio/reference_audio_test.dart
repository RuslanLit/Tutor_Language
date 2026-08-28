import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutor_language/core/audio/reference_audio.dart';
import 'package:tutor_language/core/audio/reference_audio_button.dart';
import 'package:tutor_language/core/audio/reference_audio_providers.dart';
import 'package:tutor_language/core/content/audio_reference_models.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

void main() {
  test('resolves only approved audio by stable ID', () {
    final repository = ReferenceAudioRepository(_manifest());

    expect(repository.resolveApproved('approved').assetPath, 'assets/a.wav');
    expect(
      () => repository.resolveApproved('generated'),
      throwsA(
        isA<ReferenceAudioFailure>().having(
          (failure) => failure.code,
          'code',
          ReferenceAudioFailureCode.notApproved,
        ),
      ),
    );
    expect(
      () => repository.resolveApproved('missing'),
      throwsA(
        isA<ReferenceAudioFailure>().having(
          (failure) => failure.code,
          'code',
          ReferenceAudioFailureCode.unknownReference,
        ),
      ),
    );
  });

  test('restarts playback and keeps one active backend', () async {
    final backend = _FakeBackend();
    final service = ReferenceAudioPlaybackService(
      repository: Future.value(ReferenceAudioRepository(_manifest())),
      backend: backend,
    );

    await service.play('approved');
    await service.play('approved');

    expect(backend.calls, [
      'stop',
      'set:assets/a.wav',
      'speed:1.0',
      'play',
      'stop',
      'set:assets/a.wav',
      'speed:1.0',
      'play',
    ]);
    expect(service.activeReferenceId, 'approved');

    await service.stop();
    expect(service.activeReferenceId, isNull);
    await service.dispose();
    expect(backend.calls.last, 'dispose');
  });

  test('slow playback uses 0.6x', () async {
    final backend = _FakeBackend();
    final service = ReferenceAudioPlaybackService(
      repository: Future.value(ReferenceAudioRepository(_manifest())),
      backend: backend,
    );

    await service.play('approved', mode: ReferenceAudioPlaybackMode.slow);

    expect(backend.calls, ['stop', 'set:assets/a.wav', 'speed:0.6', 'play']);
    await service.dispose();
  });

  test('normal playback restores 1.0x after slow playback', () async {
    final backend = _FakeBackend();
    final service = ReferenceAudioPlaybackService(
      repository: Future.value(ReferenceAudioRepository(_manifest())),
      backend: backend,
    );

    await service.play('approved', mode: ReferenceAudioPlaybackMode.slow);
    await service.play('approved');

    expect(backend.calls, [
      'stop',
      'set:assets/a.wav',
      'speed:0.6',
      'play',
      'stop',
      'set:assets/a.wav',
      'speed:1.0',
      'play',
    ]);
    await service.dispose();
  });

  testWidgets(
    'audio control is optional and invokes project playback service',
    (tester) async {
      final backend = _FakeBackend();
      final service = ReferenceAudioPlaybackService(
        repository: Future.value(ReferenceAudioRepository(_manifest())),
        backend: backend,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            referenceAudioPlaybackServiceProvider.overrideWithValue(service),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
              body: ReferenceAudioButton(referenceId: 'approved'),
            ),
          ),
        ),
      );

      expect(find.byTooltip('Listen'), findsOneWidget);
      await tester.tap(find.byTooltip('Listen'));
      await tester.pumpAndSettle();
      expect(backend.calls, contains('play'));
      expect(find.byTooltip('0.6×'), findsOneWidget);
      await tester.tap(find.byTooltip('0.6×'));
      await tester.pumpAndSettle();
      expect(backend.calls, contains('speed:0.6'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            referenceAudioPlaybackServiceProvider.overrideWithValue(service),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
              body: ReferenceAudioButton(referenceId: 'approved'),
            ),
          ),
        ),
      );
      expect(backend.calls, isNot(contains('dispose')));

      await tester.pumpWidget(const SizedBox.shrink());
      await service.dispose();
    },
  );
}

AudioReferenceManifest _manifest() {
  return AudioReferenceManifest(
    schemaVersion: 1,
    audioRoot: 'assets',
    assets: [_asset('approved', 'approved'), _asset('generated', 'generated')],
  );
}

AudioReferenceAsset _asset(String id, String qaStatus) {
  return AudioReferenceAsset(
    id: id,
    assetPath: 'assets/a.wav',
    transcript: 'Hola.',
    languageCode: 'es',
    locale: 'es_ES',
    voiceId: 'voice',
    purpose: AudioReferencePurpose.phrase,
    qaStatus: parseAudioReferenceQaStatus(qaStatus),
    provenance: const AudioReferenceProvenance(
      engine: 'Piper',
      voice: 'voice',
      locale: 'es_ES',
      generationRole: 'authoring-time only',
    ),
  );
}

class _FakeBackend implements ReferenceAudioBackend {
  final calls = <String>[];

  @override
  Future<void> setAsset(String assetPath) async => calls.add('set:$assetPath');

  @override
  Future<void> setFile(String filePath) async => calls.add('file:$filePath');

  @override
  Future<void> setSpeed(double speed) async => calls.add('speed:$speed');

  @override
  Future<void> play() async => calls.add('play');

  @override
  Future<void> stop() async => calls.add('stop');

  @override
  Future<void> dispose() async => calls.add('dispose');
}
