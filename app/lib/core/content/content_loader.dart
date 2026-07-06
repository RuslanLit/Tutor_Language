import 'dart:convert';

import 'package:flutter/services.dart';

import 'content_document.dart';
import 'topic_content.dart';

class ContentLoader {
  ContentLoader({AssetBundle? assetBundle})
    : _assetBundle = assetBundle ?? rootBundle;

  static const spanishAssetRoot = 'assets/spanish';

  static const supportedDirectories = [
    'vocabulary',
    'grammar',
    'dialogues',
    'readings',
    'templates',
  ];

  final AssetBundle _assetBundle;

  Future<EducationalContentBundle> loadSpanishContent() async {
    final contents = <TopicContent>[];

    for (final directory in supportedDirectories) {
      final paths = await _jsonAssetPathsFor(directory);

      for (final path in paths) {
        contents.add(await loadContent(path));
      }
    }

    return EducationalContentBundle(contents: List.unmodifiable(contents));
  }

  Future<TopicContent> loadContent(String assetPath) async {
    final rawJson = await _assetBundle.loadString(assetPath);
    final parsedJson = jsonDecode(rawJson);
    final items = _requiredObjectList(parsedJson, assetPath);

    return switch (_categoryFromPath(assetPath)) {
      'vocabulary' => VocabularyContent(
        assetPath: assetPath,
        entries: items.map(VocabularyEntry.fromJson).toList(growable: false),
      ),
      'grammar' => GrammarContent(
        assetPath: assetPath,
        rules: items.map(GrammarRule.fromJson).toList(growable: false),
      ),
      'dialogues' => DialogueContent(
        assetPath: assetPath,
        dialogues: items.map(Dialogue.fromJson).toList(growable: false),
      ),
      'readings' => ReadingContent(
        assetPath: assetPath,
        readings: items.map(Reading.fromJson).toList(growable: false),
      ),
      'templates' => ExerciseTemplateContent(
        assetPath: assetPath,
        templates: items.map(ExerciseTemplate.fromJson).toList(growable: false),
      ),
      final category => throw ArgumentError.value(
        category,
        'category',
        'Unsupported content category',
      ),
    };
  }

  Future<List<String>> _jsonAssetPathsFor(String directory) async {
    if (!supportedDirectories.contains(directory)) {
      throw ArgumentError.value(
        directory,
        'directory',
        'Unsupported directory',
      );
    }

    final manifest = await AssetManifest.loadFromAssetBundle(_assetBundle);
    final prefix = '$spanishAssetRoot/$directory/';

    final paths =
        manifest
            .listAssets()
            .where((path) => path.startsWith(prefix) && path.endsWith('.json'))
            .toList()
          ..sort();

    return paths;
  }

  String _categoryFromPath(String path) {
    final parts = path.split('/');

    if (parts.length < 3 ||
        parts[0] != 'assets' ||
        parts[1] != 'spanish' ||
        !supportedDirectories.contains(parts[2])) {
      throw ArgumentError.value(path, 'path', 'Unsupported content path');
    }

    return parts[2];
  }

  List<Map<String, Object?>> _requiredObjectList(
    Object? parsedJson,
    String assetPath,
  ) {
    if (parsedJson is! List) {
      throw FormatException('Content JSON must be a list: $assetPath');
    }

    return parsedJson
        .map((item) {
          if (item is Map<String, Object?>) {
            return item;
          }

          if (item is Map) {
            return Map<String, Object?>.from(item);
          }

          throw FormatException('Content item must be an object: $assetPath');
        })
        .toList(growable: false);
  }
}
