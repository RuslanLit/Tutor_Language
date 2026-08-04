import 'dart:convert';

import 'package:flutter/services.dart';

import 'pronunciation_catalog.dart';
import 'pronunciation_models.dart';
import 'topic_content.dart';

class PronunciationLoader {
  PronunciationLoader({
    AssetBundle? assetBundle,
    this.assetPath = 'assets/languages/spanish/pronunciation/empty.json',
  }) : _assetBundle = assetBundle ?? rootBundle;

  final AssetBundle _assetBundle;
  final String assetPath;

  Future<PronunciationBundle> loadBundle() async {
    final rawJson = await _assetBundle.loadString(assetPath);
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map) {
      throw const FormatException('Pronunciation bundle must be an object');
    }

    return PronunciationBundle.fromJson(Map<String, Object?>.from(decoded));
  }

  Future<PronunciationCatalog> loadCatalog({
    Iterable<VocabularyContent> vocabularyContents = const [],
  }) async {
    final bundle = await loadBundle();
    final catalog = PronunciationCatalog(
      bundle: bundle,
      vocabularyContents: vocabularyContents,
    );
    final issues = catalog.validate();
    final errors = issues.where(
      (issue) => issue.severity == PronunciationIssueSeverity.error,
    );
    if (errors.isNotEmpty) {
      throw FormatException(
        'Invalid pronunciation bundle: ${errors.map((e) => e.code).join(', ')}',
      );
    }

    return catalog;
  }
}
