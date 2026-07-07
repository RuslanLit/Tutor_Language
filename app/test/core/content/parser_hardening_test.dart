import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';

void main() {
  test('missing required id fails deterministically', () {
    expect(
      () => VocabularyItem.fromJson(const {
        'spanish': 'hola',
        'native_translation': 'hello',
        'cefr': 'A0',
        'example': 'Hola.',
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('vocabulary reverse lesson membership fails deterministically', () {
    expect(
      () => VocabularyItem.fromJson(const {
        'id': 'vocab.test.v1',
        'spanish': 'hola',
        'native_translation': 'hello',
        'cefr': 'A0',
        'example': 'Hola.',
        'lesson_ids': ['lesson.greetings.v1'],
      }),
      throwsA(isA<FormatException>()),
    );

    expect(
      () => VocabularyItem.fromJson(const {
        'id': 'vocab.test.v1',
        'spanish': 'hola',
        'native_translation': 'hello',
        'cefr': 'A0',
        'example': 'Hola.',
        'topic_ids': ['topic.greetings.v1'],
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('missing required title fails deterministically', () {
    expect(
      () => GrammarTopic.fromJson(const {
        'id': 'grammar.test.v1',
        'explanation': 'Explanation.',
        'examples': ['Example.'],
        'prerequisite_ids': [],
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('wrong JSON type for list fields fails deterministically', () {
    expect(
      () => GrammarTopic.fromJson(const {
        'id': 'grammar.test.v1',
        'title': 'llamarse basics',
        'explanation': 'Explanation.',
        'examples': 'Example.',
        'prerequisite_ids': [],
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('unknown content type fails deterministically', () async {
    final loader = ContentLoader(assetBundle: _JsonAssetBundle(const {}));

    await expectLater(
      loader.loadContent('assets/languages/spanish/unknown/example.json'),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('invalid ContentReference shape fails deterministically', () {
    expect(
      () => LessonContentReference.fromJson(const {
        'type': 'vocabulary',
        'assetPath': '',
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('invalid LessonActivity shape fails deterministically', () {
    expect(
      () => LessonActivity.fromJson(const {
        'id': 'activity_001',
        'type': 'vocabulary',
        'contentReferences': 'not a list',
      }),
      throwsA(isA<FormatException>()),
    );
  });

  test('invalid EducationalContent shape fails deterministically', () async {
    final loader = ContentLoader(
      assetBundle: _JsonAssetBundle(const {
        'assets/languages/spanish/vocabulary/broken.json': {'id': 'not a list'},
      }),
    );

    await expectLater(
      loader.loadContent('assets/languages/spanish/vocabulary/broken.json'),
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
