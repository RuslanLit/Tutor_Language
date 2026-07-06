import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/course.dart';
import 'package:tutor_language/core/content/topic_content.dart';

void main() {
  test('missing required id fails deterministically', () {
    expect(
      () => VocabularyEntry.fromJson(const {
        'spanish': 'hola',
        'native_translation': 'hello',
        'cefr': 'A0',
        'topic_ids': ['topic_001'],
        'example': 'Hola.',
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('missing required title fails deterministically', () {
    expect(
      () => GrammarRule.fromJson(const {
        'id': 'grammar.test.v1',
        'explanation': 'Explanation.',
        'examples': ['Example.'],
        'prerequisite_ids': [],
        'topic_ids': ['topic_001'],
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('wrong JSON type for list fields fails deterministically', () {
    expect(
      () => VocabularyEntry.fromJson(const {
        'id': 'vocab.test.v1',
        'spanish': 'hola',
        'native_translation': 'hello',
        'cefr': 'A0',
        'topic_ids': 'topic_001',
        'example': 'Hola.',
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('unknown content type fails deterministically', () async {
    final loader = ContentLoader(assetBundle: _JsonAssetBundle(const {}));

    await expectLater(
      loader.loadContent('assets/spanish/unknown/example.json'),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('invalid ContentReference shape fails deterministically', () {
    expect(
      () => ContentReference.fromJson(const {
        'type': 'vocabulary',
        'assetPath': '',
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('invalid TopicSection shape fails deterministically', () {
    expect(
      () => TopicSection.fromJson(const {
        'id': 'section_001',
        'title': 'Broken section',
        'contentReference': 'not an object',
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('invalid TopicContent shape fails deterministically', () async {
    final loader = ContentLoader(
      assetBundle: _JsonAssetBundle(const {
        'assets/spanish/vocabulary/broken.json': {'id': 'not a list'},
      }),
    );

    await expectLater(
      loader.loadContent('assets/spanish/vocabulary/broken.json'),
      throwsA(isA<FormatException>()),
    );
  });
}

class _JsonAssetBundle extends AssetBundle {
  _JsonAssetBundle(this.assets);

  final Map<String, Object?> assets;

  @override
  Future<ByteData> load(String key) async {
    final value = assets[key];

    if (value == null) {
      throw ArgumentError.value(key, 'key', 'Asset not found');
    }

    return ByteData.sublistView(utf8.encode(jsonEncode(value)));
  }

  @override
  Future<T> loadStructuredData<T>(
    String key,
    Future<T> Function(String value) parser,
  ) async {
    return parser(await loadString(key));
  }
}
