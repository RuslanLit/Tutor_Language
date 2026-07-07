import 'dart:convert';

import 'package:flutter/services.dart';

import 'content_document.dart';
import 'topic_content.dart';

class ContentLoader {
  ContentLoader({AssetBundle? assetBundle, String? languagePackRoot})
    : _assetBundle = assetBundle ?? rootBundle,
      languagePackRoot = languagePackRoot ?? spanishAssetRoot;

  static const spanishAssetRoot = 'assets/languages/spanish';

  static const supportedDirectories = [
    'vocabulary',
    'grammar',
    'dialogues',
    'readings',
    'templates',
  ];

  final AssetBundle _assetBundle;
  final String languagePackRoot;

  Future<EducationalContentBundle> loadSpanishContent() async {
    return loadLanguagePackContent(languagePackRoot: spanishAssetRoot);
  }

  Future<EducationalContentBundle> loadLanguagePackContent({
    String? languagePackRoot,
  }) async {
    final root = languagePackRoot ?? this.languagePackRoot;
    final contents = <EducationalContent>[];

    for (final directory in supportedDirectories) {
      final paths = await _jsonAssetPathsFor(directory, languagePackRoot: root);

      for (final path in paths) {
        contents.add(await loadContent(path));
      }
    }

    return EducationalContentBundle(contents: List.unmodifiable(contents));
  }

  Future<EducationalContent> loadContent(String assetPath) async {
    final category = _categoryFromPath(assetPath);
    final rawJson = await _assetBundle.loadString(assetPath);
    final parsedJson = jsonDecode(rawJson);
    final items = _requiredObjectList(parsedJson, assetPath);

    return switch (category) {
      'vocabulary' => VocabularyContent(
        assetPath: assetPath,
        entries: items.map(VocabularyItem.fromJson).toList(growable: false),
      ),
      'grammar' => GrammarContent(
        assetPath: assetPath,
        topics: items.map(GrammarTopic.fromJson).toList(growable: false),
      ),
      'dialogues' => DialogueContent(
        assetPath: assetPath,
        dialogues: items.map(Dialogue.fromJson).toList(growable: false),
      ),
      'readings' => ReadingContent(
        assetPath: assetPath,
        texts: items.map(ReadingText.fromJson).toList(growable: false),
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

  Future<List<String>> _jsonAssetPathsFor(
    String directory, {
    required String languagePackRoot,
  }) async {
    if (!supportedDirectories.contains(directory)) {
      throw ArgumentError.value(
        directory,
        'directory',
        'Unsupported directory',
      );
    }

    final manifest = await AssetManifest.loadFromAssetBundle(_assetBundle);
    final prefix = '$languagePackRoot/$directory/';

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

    final category = _pathCategory(parts);

    if (category == null) {
      throw ArgumentError.value(path, 'path', 'Unsupported content path');
    }

    return category;
  }

  String? _pathCategory(List<String> parts) {
    if (parts.length >= 4 &&
        parts[0] == 'assets' &&
        parts[1] == 'languages' &&
        parts[2].isNotEmpty &&
        supportedDirectories.contains(parts[3])) {
      return parts[3];
    }

    return null;
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
