import 'dart:convert';

import 'package:flutter/services.dart';

import 'audio_reference_models.dart';

class AudioReferenceLoader {
  AudioReferenceLoader({
    AssetBundle? assetBundle,
    this.assetPath = 'assets/languages/spanish/audio/reference_audio.json',
  }) : _assetBundle = assetBundle ?? rootBundle;

  final AssetBundle _assetBundle;
  final String assetPath;

  Future<AudioReferenceManifest> loadManifest() async {
    final raw = await _assetBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException('Audio manifest must be an object');
    }
    return AudioReferenceManifest.fromJson(Map<String, Object?>.from(decoded));
  }
}
