import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/audio_reference_models.dart';

void main() {
  group('AudioReferenceManifest', () {
    test('loads a valid manifest and preserves transcript punctuation', () {
      final manifest = AudioReferenceManifest.fromJson(
        jsonDecode(_manifestJson()) as Map<String, Object?>,
      );

      expect(manifest.assets, hasLength(1));
      expect(manifest.assets.single.transcript, '¿Cómo te llamas?');
      expect(manifest.assets.single.purposeValue, 'phrase');
    });

    test('rejects an empty transcript', () {
      expect(
        () => AudioReferenceAsset.fromJson(_asset(transcript: '')),
        throwsFormatException,
      );
    });

    test('rejects an invalid purpose and QA status', () {
      expect(
        () => AudioReferenceAsset.fromJson(_asset(purpose: 'conversation')),
        throwsFormatException,
      );
      expect(
        () => AudioReferenceAsset.fromJson(_asset(qaStatus: 'pending')),
        throwsFormatException,
      );
    });
  });

  group('AudioReferenceValidator', () {
    test('accepts a valid reference asset', () {
      final manifest = _parse(_manifestJson());
      final issues = _validator(
        'assets/languages/spanish/audio/reference/sample.wav',
      ).validate(manifest);

      expect(issues, isEmpty);
    });

    test('rejects duplicate IDs and paths', () {
      final asset = _asset();
      final manifest = AudioReferenceManifest(
        schemaVersion: 1,
        audioRoot: _audioRoot,
        assets: [
          AudioReferenceAsset.fromJson(asset),
          AudioReferenceAsset.fromJson(asset),
        ],
      );

      final codes = _validator(
        'assets/languages/spanish/audio/reference/a.wav',
      ).validate(manifest).map((issue) => issue.code);
      expect(codes, contains('audio.duplicateId'));
      expect(codes, contains('audio.duplicatePath'));
    });

    test('rejects a missing asset', () {
      final issues = _validator(
        'assets/languages/spanish/audio/reference/other.wav',
      ).validate(_parse(_manifestJson()));

      expect(issues.map((issue) => issue.code), contains('audio.missingAsset'));
    });

    test('rejects invalid language and locale', () {
      final issues =
          _validator(
            'assets/languages/spanish/audio/reference/sample.wav',
          ).validate(
            _parse(_manifestJson(languageCode: 'spanish', locale: 'es-es')),
          );

      final codes = issues.map((issue) => issue.code);
      expect(codes, contains('audio.invalidLanguage'));
      expect(codes, contains('audio.invalidLocale'));
    });

    test('rejects path escape and unsupported extension', () {
      final issues = _validator(
        '../outside.mp3',
      ).validate(_parse(_manifestJson(assetPath: '../outside.mp3')));

      final codes = issues.map((issue) => issue.code);
      expect(codes, contains('audio.invalidPath'));
      expect(codes, contains('audio.invalidExtension'));
    });

    test('rejects unstable IDs and mismatched provenance', () {
      final asset = _asset(id: 'random-id');
      asset['voiceId'] = 'other-voice';
      final issues =
          _validator(
            'assets/languages/spanish/audio/reference/sample.wav',
          ).validate(
            AudioReferenceManifest(
              schemaVersion: 1,
              audioRoot: _audioRoot,
              assets: [AudioReferenceAsset.fromJson(asset)],
            ),
          );

      final codes = issues.map((issue) => issue.code);
      expect(codes, contains('audio.invalidId'));
      expect(codes, contains('audio.provenanceMismatch'));
    });
  });

  group('AudioReferenceQaStateUpdater', () {
    test('performs a valid QA transition', () {
      final manifest = _parse(_manifestJson());
      final updated =
          _updater(
            'assets/languages/spanish/audio/reference/sample.wav',
          ).update(
            manifest: manifest,
            id: 'es.audio.phrase.sample',
            state: 'reviewed',
          );

      expect(updated.assets.single.qaStatusValue, 'reviewed');
    });

    test('rejects an unknown ID', () {
      expect(
        () => _updater('assets/languages/spanish/audio/reference/sample.wav')
            .update(
              manifest: _parse(_manifestJson()),
              id: 'es.audio.phrase.unknown',
              state: 'approved',
            ),
        throwsFormatException,
      );
    });

    test('rejects an invalid state', () {
      expect(
        () => _updater('assets/languages/spanish/audio/reference/sample.wav')
            .update(
              manifest: _parse(_manifestJson()),
              id: 'es.audio.phrase.sample',
              state: 'pending',
            ),
        throwsFormatException,
      );
    });

    test('cannot approve an entry whose asset is missing', () {
      expect(
        () => _updater('assets/languages/spanish/audio/reference/other.wav')
            .update(
              manifest: _parse(_manifestJson()),
              id: 'es.audio.phrase.sample',
              state: 'approved',
            ),
        throwsFormatException,
      );
    });

    test('changes only the selected entry', () {
      final first = _asset();
      final second = _asset(
        id: 'es.audio.phrase.other',
        assetPath: 'assets/languages/spanish/audio/reference/other.wav',
        transcript: 'Hola.',
      );
      final manifest = AudioReferenceManifest(
        schemaVersion: 1,
        audioRoot: _audioRoot,
        assets: [
          AudioReferenceAsset.fromJson(first),
          AudioReferenceAsset.fromJson(second),
        ],
      );
      final updated =
          _updater(
            'assets/languages/spanish/audio/reference/sample.wav',
            additionalPath:
                'assets/languages/spanish/audio/reference/other.wav',
          ).update(
            manifest: manifest,
            id: 'es.audio.phrase.sample',
            state: 'approved',
          );

      expect(updated.assets.first.qaStatusValue, 'approved');
      expect(updated.assets[1].id, manifest.assets[1].id);
      expect(updated.assets[1].transcript, manifest.assets[1].transcript);
      expect(updated.assets[1].qaStatus, manifest.assets[1].qaStatus);
    });
  });
}

const _audioRoot = 'assets/languages/spanish/audio/reference';

AudioReferenceValidator _validator(String availablePath) {
  return AudioReferenceValidator(
    expectedAudioRoot: _audioRoot,
    availableAssetPaths: {availablePath},
  );
}

AudioReferenceQaStateUpdater _updater(
  String availablePath, {
  String? additionalPath,
}) {
  return AudioReferenceQaStateUpdater(
    expectedAudioRoot: _audioRoot,
    availableAssetPaths: {availablePath, ?additionalPath},
  );
}

AudioReferenceManifest _parse(
  String value, {
  String? languageCode,
  String? locale,
}) {
  final decoded = jsonDecode(value) as Map<String, Object?>;
  final asset = (decoded['assets']! as List).single as Map<String, Object?>;
  if (languageCode != null) asset['languageCode'] = languageCode;
  if (locale != null) asset['locale'] = locale;
  return AudioReferenceManifest.fromJson(decoded);
}

String _manifestJson({
  String assetPath = 'assets/languages/spanish/audio/reference/sample.wav',
  String languageCode = 'es',
  String locale = 'es_ES',
}) {
  return jsonEncode({
    'schemaVersion': 1,
    'audioRoot': _audioRoot,
    'assets': [
      _asset(assetPath: assetPath, languageCode: languageCode, locale: locale),
    ],
  });
}

Map<String, Object?> _asset({
  String id = 'es.audio.phrase.sample',
  String assetPath = 'assets/languages/spanish/audio/reference/sample.wav',
  String transcript = '¿Cómo te llamas?',
  String languageCode = 'es',
  String locale = 'es_ES',
  String purpose = 'phrase',
  String qaStatus = 'generated',
}) {
  return {
    'id': id,
    'assetPath': assetPath,
    'transcript': transcript,
    'languageCode': languageCode,
    'locale': locale,
    'voiceId': 'es_ES-sharvard-medium',
    'purpose': purpose,
    'qaStatus': qaStatus,
    'provenance': {
      'engine': 'Piper',
      'voice': 'es_ES-sharvard-medium',
      'locale': 'es_ES',
      'generationRole': 'authoring-time only',
    },
  };
}
