import 'dart:convert';

import 'package:flutter/services.dart';

import 'content_document.dart';

class ContentLoader {
  ContentLoader({AssetBundle? assetBundle})
    : _assetBundle = assetBundle ?? rootBundle;

  static const spanishAssetRoot = 'assets/spanish';

  static const supportedDirectories = [
    'curriculum',
    'vocabulary',
    'grammar',
    'dialogues',
    'readings',
    'templates',
  ];

  final AssetBundle _assetBundle;

  Future<EducationalContentBundle> loadSpanishContent() async {
    final documents = <ContentDocument>[];

    for (final directory in supportedDirectories) {
      documents.addAll(await loadDirectory(directory));
    }

    return EducationalContentBundle(documents: List.unmodifiable(documents));
  }

  Future<List<ContentDocument>> loadDirectory(String directory) async {
    if (!supportedDirectories.contains(directory)) {
      throw ArgumentError.value(
        directory,
        'directory',
        'Unsupported directory',
      );
    }

    final paths = await _jsonAssetPathsFor(directory);
    final documents = <ContentDocument>[];

    for (final path in paths) {
      documents.add(await loadJsonAsset(path));
    }

    return List.unmodifiable(documents);
  }

  Future<ContentDocument> loadJsonAsset(String path) async {
    final category = _categoryFromPath(path);
    final rawJson = await _assetBundle.loadString(path);
    final parsedJson = jsonDecode(rawJson);

    return ContentDocument(path: path, category: category, json: parsedJson);
  }

  Future<List<String>> _jsonAssetPathsFor(String directory) async {
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
}
