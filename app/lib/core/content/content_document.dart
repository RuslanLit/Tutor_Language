import 'topic_content.dart';

class EducationalContentBundle {
  const EducationalContentBundle({required this.contents});

  final List<EducationalContent> contents;

  List<T> byType<T extends EducationalContent>() {
    return contents.whereType<T>().toList(growable: false);
  }

  EducationalContent? byAssetPath(String assetPath) {
    for (final content in contents) {
      if (content.assetPath == assetPath) {
        return content;
      }
    }

    return null;
  }
}
