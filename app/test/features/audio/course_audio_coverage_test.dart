import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/audio/reference_audio.dart';
import 'package:tutor_language/core/content/audio_reference_models.dart';
import 'package:tutor_language/core/content/audio_reference_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  test(
    'current Lessons 1-42 audio-bearing template utterances match audio',
    () {
      final manifest =
          jsonDecode(
                File(
                  'assets/languages/spanish/audio/reference_audio.json',
                ).readAsStringSync(),
              )
              as Map<String, Object?>;
      final transcripts = {
        for (final asset in (manifest['assets']! as List).cast<Map>())
          asset['id'] as String: asset['transcript'] as String,
      };
      var references = 0;
      for (var lesson = 1; lesson <= 42; lesson++) {
        final path =
            'assets/languages/spanish/templates/canonical_lesson_$lesson.json';
        final data = jsonDecode(File(path).readAsStringSync());
        void visit(Object? value, String location) {
          if (value is Map) {
            final audioId = value['audioReferenceId'];
            if (audioId is String) {
              references++;
              final expected = transcripts[audioId];
              expect(expected, isNotNull, reason: '$path$location');
              var visible = value['text'] ?? value['audio_transcript'];
              final builder = value['sentence_builder'];
              if (visible == null && builder is Map) {
                final tokens = {
                  for (final token in (builder['tokens'] as List).cast<Map>())
                    token['id'] as String: token['label'] as String,
                };
                final sequences = (builder['accepted_sequences'] as List)
                    .cast<List>();
                visible = sequences.first.map((id) => tokens[id]).join(' ');
              }
              if (visible is String) {
                expect(
                  _lexical(visible),
                  _lexical(expected!),
                  reason: '$path$location',
                );
              }
            }
            for (final entry in value.entries) {
              visit(entry.value, '$location/${entry.key}');
            }
          } else if (value is List) {
            for (var index = 0; index < value.length; index++) {
              visit(value[index], '$location/$index');
            }
          }
        }

        visit(data, '');
      }
      expect(references, greaterThan(0));
    },
  );

  test(
    'approved reference audio resolves and loads through rootBundle',
    () async {
      final manifest = await AudioReferenceLoader().loadManifest();
      final repository = ReferenceAudioRepository(manifest);
      var loaded = 0;
      for (final asset in manifest.assets) {
        if (asset.qaStatus != AudioReferenceQaStatus.approved) continue;
        final resolved = repository.resolveApproved(asset.id);
        expect(resolved.assetPath, asset.assetPath);
        final bytes = await rootBundle.load(resolved.assetPath);
        expect(bytes.lengthInBytes, greaterThan(0), reason: asset.id);
        loaded++;
      }
      expect(loaded, manifest.assets.length);
    },
  );
}

String _lexical(String value) => value
    .toLowerCase()
    .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), ' ')
    .trim();

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
