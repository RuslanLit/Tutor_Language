import 'dart:convert';

import 'package:flutter/services.dart';

import 'course.dart';

class CurriculumLoader {
  CurriculumLoader({AssetBundle? assetBundle})
    : _assetBundle = assetBundle ?? rootBundle;

  static const defaultCoursePath = 'assets/spanish/curriculum/course.json';

  final AssetBundle _assetBundle;

  Future<Course> loadCourse({String path = defaultCoursePath}) async {
    final rawJson = await _assetBundle.loadString(path);
    final parsedJson = jsonDecode(rawJson);

    if (parsedJson is Map<String, Object?>) {
      return Course.fromJson(parsedJson);
    }

    if (parsedJson is Map) {
      return Course.fromJson(Map<String, Object?>.from(parsedJson));
    }

    throw const FormatException('Course JSON must be an object');
  }
}
