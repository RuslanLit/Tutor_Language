import 'topic_content.dart';

class EducationalContentBundle {
  const EducationalContentBundle({required this.contents});

  final List<TopicContent> contents;

  List<T> byType<T extends TopicContent>() {
    return contents.whereType<T>().toList(growable: false);
  }

  TopicContent? byAssetPath(String assetPath) {
    for (final content in contents) {
      if (content.assetPath == assetPath) {
        return content;
      }
    }

    return null;
  }
}
