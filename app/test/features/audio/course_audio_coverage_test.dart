import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, Map<String, Object?>> assetsByTranscript;
  late Map<String, String> idByTranscript;
  late Set<String> assetIds;

  setUpAll(() {
    final manifest =
        jsonDecode(
              File(
                'assets/languages/spanish/audio/reference_audio.json',
              ).readAsStringSync(),
            )
            as Map<String, Object?>;
    final assets = (manifest['assets']! as List).cast<Map>();
    assetsByTranscript = {
      for (final asset in assets)
        asset['transcript'] as String: Map<String, Object?>.from(asset),
    };
    idByTranscript = {
      for (final asset in assets)
        asset['transcript'] as String: asset['id'] as String,
    };
    assetIds = {for (final asset in assets) asset['id'] as String};
  });

  test('learner-facing dialogue and vocabulary speech has valid audio IDs', () {
    final seenByTranscript = <String, String>{};
    for (final path in _courseContentFiles('dialogues')) {
      final data = jsonDecode(File(path).readAsStringSync()) as List;
      for (final dialogue in data.cast<Map>()) {
        for (final line in (dialogue['lines'] as List).cast<Map>()) {
          _checkUtterance(
            line,
            path,
            seenByTranscript,
            assetIds,
            idByTranscript,
          );
        }
      }
    }
    for (final path in _courseContentFiles('vocabulary')) {
      final data = jsonDecode(File(path).readAsStringSync()) as List;
      for (final item in data.cast<Map>()) {
        _checkUtterance(item, path, seenByTranscript, assetIds, idByTranscript);
      }
    }
  });

  test('ordinary duplicate utterances reuse one canonical audio ID', () {
    expect(idByTranscript['Hola.'], 'es.audio.phrase.hola');
    expect(idByTranscript['Me llamo Ana.'], 'es.audio.phrase.me_llamo');
    expect(
      idByTranscript['¿Cómo te llamas?'],
      'es.audio.question.como_te_llamas',
    );
    expect(
      assetsByTranscript['Me llamo Marta.']!['id'],
      'es.audio.dialogue.me_llamo_marta',
    );
  });

  test('course JSON uses stable IDs, never canonical audio paths', () {
    for (final kind in ['dialogues', 'vocabulary']) {
      for (final path in _courseContentFiles(kind)) {
        final source = File(path).readAsStringSync();
        expect(source, isNot(contains('audio/reference/')));
      }
    }
  });
}

void _checkUtterance(
  Map item,
  String path,
  Map<String, String> seenByTranscript,
  Set<String> assetIds,
  Map<String, String> idByTranscript,
) {
  final transcript = item['spanish'];
  if (transcript is! String || transcript.trim().isEmpty) return;
  final audioId = item['audioReferenceId'];
  expect(audioId, isA<String>(), reason: '$path: $transcript');
  expect(assetIds, contains(audioId), reason: '$path: $transcript');
  expect(idByTranscript[transcript], audioId);
  final previous = seenByTranscript[transcript];
  if (previous != null) expect(audioId, previous);
  seenByTranscript[transcript] = audioId as String;
}

List<String> _courseContentFiles(String kind) {
  return [
    for (var lesson = 1; lesson <= 5; lesson++)
      'assets/languages/spanish/$kind/canonical_lesson_$lesson.json',
  ];
}
