// ignore_for_file: prefer_interpolation_to_compose_strings

enum AudioReferencePurpose {
  word,
  phrase,
  communicativeChunk,
  dialogueTurn,
  listeningStimulus,
  pronunciationReference,
}

enum AudioReferenceQaStatus { generated, reviewed, approved, rejected }

class AudioReferenceProvenance {
  const AudioReferenceProvenance({
    required this.engine,
    required this.voice,
    required this.locale,
    required this.generationRole,
  });

  factory AudioReferenceProvenance.fromJson(Map<String, Object?> json) {
    return AudioReferenceProvenance(
      engine: _requiredString(json, 'engine'),
      voice: _requiredString(json, 'voice'),
      locale: _requiredString(json, 'locale'),
      generationRole: _requiredString(json, 'generationRole'),
    );
  }

  final String engine;
  final String voice;
  final String locale;
  final String generationRole;
}

class AudioReferenceAsset {
  const AudioReferenceAsset({
    required this.id,
    required this.assetPath,
    required this.transcript,
    required this.languageCode,
    required this.locale,
    required this.voiceId,
    required this.purpose,
    required this.qaStatus,
    required this.provenance,
  });

  factory AudioReferenceAsset.fromJson(Map<String, Object?> json) {
    return AudioReferenceAsset(
      id: _requiredString(json, 'id'),
      assetPath: _requiredString(json, 'assetPath'),
      transcript: _requiredString(json, 'transcript'),
      languageCode: _requiredString(json, 'languageCode'),
      locale: _requiredString(json, 'locale'),
      voiceId: _requiredString(json, 'voiceId'),
      purpose: _purpose(_requiredString(json, 'purpose')),
      qaStatus: _qaStatus(_requiredString(json, 'qaStatus')),
      provenance: AudioReferenceProvenance.fromJson(
        _requiredMap(json, 'provenance'),
      ),
    );
  }

  final String id;
  final String assetPath;
  final String transcript;
  final String languageCode;
  final String locale;
  final String voiceId;
  final AudioReferencePurpose purpose;
  final AudioReferenceQaStatus qaStatus;
  final AudioReferenceProvenance provenance;

  String get purposeValue => purpose.name;
  String get qaStatusValue => qaStatus.name;

  AudioReferenceAsset copyWith({AudioReferenceQaStatus? qaStatus}) {
    return AudioReferenceAsset(
      id: id,
      assetPath: assetPath,
      transcript: transcript,
      languageCode: languageCode,
      locale: locale,
      voiceId: voiceId,
      purpose: purpose,
      qaStatus: qaStatus ?? this.qaStatus,
      provenance: provenance,
    );
  }
}

class AudioReferenceManifest {
  const AudioReferenceManifest({
    required this.schemaVersion,
    required this.audioRoot,
    required this.assets,
  });

  factory AudioReferenceManifest.fromJson(Map<String, Object?> json) {
    final rawAssets = json['assets'];
    if (rawAssets is! List) {
      throw const FormatException('Audio manifest assets must be a list');
    }

    return AudioReferenceManifest(
      schemaVersion: _optionalInt(json, 'schemaVersion') ?? 1,
      audioRoot: _requiredString(json, 'audioRoot'),
      assets: List.unmodifiable([
        for (final raw in rawAssets)
          AudioReferenceAsset.fromJson(_requiredMapValue(raw, 'assets[]')),
      ]),
    );
  }

  final int schemaVersion;
  final String audioRoot;
  final List<AudioReferenceAsset> assets;
}

AudioReferenceQaStatus parseAudioReferenceQaStatus(String value) {
  return AudioReferenceQaStatus.values.firstWhere(
    (item) => item.name == value,
    orElse: () => throw FormatException('Invalid audio QA status: ' + value),
  );
}

class AudioReferenceQaStateUpdater {
  const AudioReferenceQaStateUpdater({
    required this.expectedAudioRoot,
    required this.availableAssetPaths,
  });

  final String expectedAudioRoot;
  final Set<String> availableAssetPaths;

  AudioReferenceManifest update({
    required AudioReferenceManifest manifest,
    required String id,
    required String state,
  }) {
    final currentIssues = AudioReferenceValidator(
      expectedAudioRoot: expectedAudioRoot,
      availableAssetPaths: availableAssetPaths,
    ).validate(manifest);
    if (currentIssues.isNotEmpty) {
      throw FormatException(
        'Manifest is invalid: ' +
            currentIssues.map((issue) => issue.code).join(', '),
      );
    }

    final qaStatus = parseAudioReferenceQaStatus(state);
    var found = false;
    final updatedAssets = <AudioReferenceAsset>[];
    for (final asset in manifest.assets) {
      if (asset.id == id) {
        found = true;
        updatedAssets.add(asset.copyWith(qaStatus: qaStatus));
      } else {
        updatedAssets.add(asset);
      }
    }
    if (!found) {
      throw FormatException('Unknown audio ID: ' + id);
    }

    final updated = AudioReferenceManifest(
      schemaVersion: manifest.schemaVersion,
      audioRoot: manifest.audioRoot,
      assets: List.unmodifiable(updatedAssets),
    );
    final updatedIssues = AudioReferenceValidator(
      expectedAudioRoot: expectedAudioRoot,
      availableAssetPaths: availableAssetPaths,
    ).validate(updated);
    if (updatedIssues.isNotEmpty) {
      throw FormatException(
        'Updated manifest is invalid: ' +
            updatedIssues.map((issue) => issue.code).join(', '),
      );
    }
    return updated;
  }
}

class AudioReferenceValidationIssue {
  const AudioReferenceValidationIssue({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;
}

class AudioReferenceValidator {
  const AudioReferenceValidator({
    required this.expectedAudioRoot,
    required this.availableAssetPaths,
  });

  final String expectedAudioRoot;
  final Set<String> availableAssetPaths;

  List<AudioReferenceValidationIssue> validate(
    AudioReferenceManifest manifest,
  ) {
    final issues = <AudioReferenceValidationIssue>[];
    if (manifest.audioRoot != expectedAudioRoot) {
      issues.add(
        _issue(
          'audio.rootMismatch',
          'Expected audio root ' +
              expectedAudioRoot +
              ', got ' +
              manifest.audioRoot +
              '.',
        ),
      );
    }

    final ids = <String>{};
    final paths = <String>{};
    for (final asset in manifest.assets) {
      if (!_isStableId(asset.id)) {
        issues.add(
          _issue(
            'audio.invalidId',
            'Audio ID must use the stable language.audio.namespace.slug form.',
          ),
        );
      }
      if (!ids.add(asset.id)) {
        issues.add(
          _issue('audio.duplicateId', 'Duplicate audio ID ' + asset.id + '.'),
        );
      }
      if (!paths.add(asset.assetPath)) {
        issues.add(
          _issue(
            'audio.duplicatePath',
            'Duplicate canonical audio path ' + asset.assetPath + '.',
          ),
        );
      }
      if (asset.assetPath != _canonicalPath(asset.assetPath)) {
        issues.add(
          _issue(
            'audio.invalidPath',
            'Audio path must be relative and remain under the audio root.',
          ),
        );
      }
      if (!_isAllowedExtension(asset.assetPath)) {
        issues.add(
          _issue(
            'audio.invalidExtension',
            'Unsupported audio extension in ' + asset.assetPath + '.',
          ),
        );
      }
      if (!availableAssetPaths.contains(asset.assetPath)) {
        issues.add(
          _issue(
            'audio.missingAsset',
            'Referenced audio file does not exist: ' + asset.assetPath + '.',
          ),
        );
      }
      if (!_isLanguageCode(asset.languageCode)) {
        issues.add(
          _issue(
            'audio.invalidLanguage',
            'Invalid language code ' + asset.languageCode + '.',
          ),
        );
      }
      if (!_isLocale(asset.locale)) {
        issues.add(
          _issue('audio.invalidLocale', 'Invalid locale ' + asset.locale + '.'),
        );
      }
      if (asset.transcript.trim().isEmpty) {
        issues.add(
          _issue('audio.emptyTranscript', 'Transcript must not be empty.'),
        );
      }
      if (asset.voiceId.trim().isEmpty ||
          asset.provenance.engine.trim().isEmpty ||
          asset.provenance.voice.trim().isEmpty ||
          asset.provenance.locale.trim().isEmpty ||
          asset.provenance.generationRole.trim().isEmpty) {
        issues.add(
          _issue(
            'audio.missingProvenance',
            'Audio provenance must be complete for ' + asset.id + '.',
          ),
        );
      }
      if (asset.voiceId != asset.provenance.voice ||
          asset.locale != asset.provenance.locale) {
        issues.add(
          _issue(
            'audio.provenanceMismatch',
            'Voice and locale provenance must match the asset metadata.',
          ),
        );
      }
    }
    return List.unmodifiable(issues);
  }

  AudioReferenceValidationIssue _issue(String code, String message) =>
      AudioReferenceValidationIssue(code: code, message: message);

  String _canonicalPath(String value) {
    if (value.startsWith('/') || value.contains('\\')) {
      return '';
    }
    final parts = value.split('/');
    if (parts.any((part) => part.isEmpty || part == '.' || part == '..')) {
      return '';
    }
    return parts.join('/');
  }

  bool _isAllowedExtension(String value) {
    return value.endsWith('.wav') || value.endsWith('.ogg');
  }

  bool _isLanguageCode(String value) => RegExp(r'^[a-z]{2,3}$').hasMatch(value);

  bool _isLocale(String value) =>
      RegExp(r'^[a-z]{2,3}_[A-Z]{2}$').hasMatch(value);

  bool _isStableId(String value) =>
      RegExp(r'^[a-z]{2,3}\.audio\.[a-z0-9_]+\.[a-z0-9_]+$').hasMatch(value);
}

AudioReferencePurpose _purpose(String value) {
  return AudioReferencePurpose.values.firstWhere(
    (item) => item.name == value,
    orElse: () => throw FormatException('Invalid audio purpose: ' + value),
  );
}

AudioReferenceQaStatus _qaStatus(String value) {
  return parseAudioReferenceQaStatus(value);
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('Audio field ' + key + ' must be a non-empty string');
  }
  return value;
}

Map<String, Object?> _requiredMap(Map<String, Object?> json, String key) {
  return _requiredMapValue(json[key], key);
}

Map<String, Object?> _requiredMapValue(Object? value, String key) {
  if (value is! Map) {
    throw FormatException('Audio field ' + key + ' must be an object');
  }
  return Map<String, Object?>.from(value);
}

int? _optionalInt(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! int) {
    throw FormatException('Audio field ' + key + ' must be an integer');
  }
  return value;
}
