import 'dart:convert';

import 'package:flutter/services.dart';

import 'curriculum_models.dart';

class CurriculumLoader {
  CurriculumLoader({
    AssetBundle? assetBundle,
    this.manifestPath = defaultManifestPath,
    this.coursePath = defaultCoursePath,
  }) : _assetBundle = assetBundle ?? rootBundle;

  static const defaultManifestPath = 'assets/languages/spanish/language.json';
  static const defaultCoursePath =
      'assets/languages/spanish/curriculum/spanish_a0_course.json';

  final AssetBundle _assetBundle;
  final String manifestPath;
  final String coursePath;

  Future<LanguagePackManifest> loadManifest({String? path}) async {
    path ??= manifestPath;
    return LanguagePackManifest.fromJson(await _loadObject(path));
  }

  Future<Course> loadCourse({String? path}) async {
    path ??= coursePath;
    return Course.fromJson(await _loadObject(path));
  }

  Future<Lesson> loadLesson({required String path}) async {
    return Lesson.fromJson(await _loadObject(path));
  }

  Future<Map<String, Object?>> _loadObject(String path) async {
    final rawJson = await _assetBundle.loadString(path);
    final parsedJson = jsonDecode(rawJson);

    if (parsedJson is Map<String, Object?>) {
      return parsedJson;
    }

    if (parsedJson is Map) {
      return Map<String, Object?>.from(parsedJson);
    }

    throw FormatException('Curriculum JSON must be an object: $path');
  }
}
