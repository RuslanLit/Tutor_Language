import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('screenshot phrase-selection activities are sentence builders', () {
    final expected = {
      'template.es.a0.m01.l001.identify_morning_greeting',
      'template.es.a0.m01.l001.choose_identity_next_line',
      'template.es.a0.m01.l002.choose_origin_answer',
      'template.es.a0.m01.l006.choose_greeting',
      'template.es.a0.m03.l009.choose_origin',
    };

    for (final template in _allTemplates()) {
      if (expected.contains(template['id'])) {
        expect(
          template['exercise_type'],
          'sentence_builder',
          reason: template['id'] as String,
        );
      }
    }
  });

  test('Lessons 1–10 do not offer complete Spanish phrases as MC answers', () {
    final semanticMultipleChoice = <Map<String, dynamic>>[];
    for (final template in _allTemplates()) {
      if (template['exercise_type'] != 'multiple_choice') continue;
      final options = (template['answer_options'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final hasSupportLanguage = options.any(
        (option) =>
            RegExp(r'[\u0400-\u04ff]').hasMatch(option['label'] as String),
      );
      if (!hasSupportLanguage) {
        fail('Spanish phrase MC remains: ${template['id']}');
      }
      semanticMultipleChoice.add(template);
    }
    expect(semanticMultipleChoice, isNotEmpty);
  });

  test('sentence builders reuse every exact approved manifest recording', () {
    final manifest =
        jsonDecode(
              File(
                'assets/languages/spanish/audio/reference_audio.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
    final assets = (manifest['assets'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .where((asset) => asset['qaStatus'] == 'approved')
        .toList();
    final byTranscript = <String, Map<String, dynamic>>{
      for (final asset in assets)
        _normalize(asset['transcript'] as String): asset,
    };

    for (final template in _allTemplates()) {
      if (template['exercise_type'] != 'sentence_builder') continue;
      final builder = template['sentence_builder'] as Map<String, dynamic>;
      final tokens = {
        for (final token
            in (builder['tokens'] as List<dynamic>)
                .cast<Map<String, dynamic>>())
          token['id'] as String: token['label'] as String,
      };
      final sequence =
          (builder['accepted_sequences'] as List<dynamic>).first
              as List<dynamic>;
      final target = _normalize(
        sequence.map((id) => tokens[id as String]).join(' '),
      );
      final asset = byTranscript[target];
      if (asset != null) {
        expect(
          builder['audioReferenceId'],
          asset['id'],
          reason: template['id'] as String,
        );
      }
    }
  });

  test('sentence builders have no invisible duplicate distractor tokens', () {
    for (final template in _allTemplates()) {
      if (template['exercise_type'] != 'sentence_builder') continue;
      final builder = template['sentence_builder'] as Map<String, dynamic>;
      final tokens = (builder['tokens'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final ids = tokens.map((token) => token['id'] as String).toSet();
      final labels = <String, int>{};
      for (final token in tokens) {
        labels.update(
          token['label'] as String,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
      expect(ids.length, tokens.length, reason: template['id'] as String);
      expect(
        labels.values.every((count) => count == 1),
        isTrue,
        reason: template['id'] as String,
      );
      for (final sequence in (builder['accepted_sequences'] as List<dynamic>)) {
        for (final tokenId in (sequence as List<dynamic>)) {
          expect(ids, contains(tokenId), reason: template['id'] as String);
        }
      }
    }
  });
}

String _normalize(String value) => value.replaceAll(RegExp(r'\s+'), ' ').trim();

Iterable<Map<String, dynamic>> _allTemplates() sync* {
  for (var lesson = 1; lesson <= 10; lesson++) {
    final path =
        'assets/languages/spanish/templates/canonical_lesson_$lesson.json';
    final decoded = jsonDecode(File(path).readAsStringSync()) as List<dynamic>;
    yield* decoded.cast<Map<String, dynamic>>();
  }
}
