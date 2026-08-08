import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../content/audio_reference_loader.dart';
import 'reference_audio.dart';

final audioReferenceRepositoryProvider =
    FutureProvider<ReferenceAudioRepository>((ref) async {
      final manifest = await AudioReferenceLoader().loadManifest();
      return ReferenceAudioRepository(manifest);
    });

final referenceAudioPlaybackServiceProvider =
    Provider.autoDispose<ReferenceAudioPlaybackService>((ref) {
      final service = ReferenceAudioPlaybackService(
        repository: ref.read(audioReferenceRepositoryProvider.future),
        backend: JustAudioReferenceBackend(),
      );
      // The provider is auto-disposed with the owning lesson scope. Consumers
      // must watch it while the audio control is mounted; a read-only lookup
      // would allow disposal immediately after a tap.
      if (kDebugMode) {
        debugPrint('[reference_audio] service-created');
      }
      ref.onDispose(service.dispose);
      return service;
    });
