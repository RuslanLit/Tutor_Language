import '../../features/curriculum/curriculum_models.dart';
import 'content_document.dart';
import 'topic_content.dart';

class EducationalContentCatalog {
  EducationalContentCatalog(EducationalContentBundle bundle)
    : _contentsByAssetPath = Map.unmodifiable({
        for (final content in bundle.contents) content.assetPath: content,
      }),
      _itemsById = Map.unmodifiable(_indexItems(bundle.contents));

  final Map<String, EducationalContent> _contentsByAssetPath;
  final Map<String, Object> _itemsById;

  Iterable<String> get ids => _itemsById.keys;

  EducationalContent? contentByAssetPath(String assetPath) {
    return _contentsByAssetPath[assetPath];
  }

  Object? lookup(String id) {
    return _itemsById[id];
  }

  T? lookupAs<T extends Object>(String id) {
    final item = lookup(id);

    return item is T ? item : null;
  }

  bool contains(String id) {
    return _itemsById.containsKey(id);
  }

  bool canResolve(LessonActivityReference reference) {
    final referenceId = reference.referenceId;

    if (referenceId != null && !contains(referenceId)) {
      return false;
    }

    return contentByAssetPath(reference.assetPath) != null;
  }

  static Map<String, Object> _indexItems(
    Iterable<EducationalContent> contents,
  ) {
    final items = <String, Object>{};

    for (final content in contents) {
      switch (content) {
        case VocabularyContent():
          for (final entry in content.entries) {
            items[entry.id] = entry;
          }
        case GrammarContent():
          for (final topic in content.topics) {
            items[topic.id] = topic;
          }
        case DialogueContent():
          for (final dialogue in content.dialogues) {
            items[dialogue.id] = dialogue;
          }
        case ReadingContent():
          for (final text in content.texts) {
            items[text.id] = text;
          }
        case ExerciseTemplateContent():
          for (final template in content.templates) {
            items[template.id] = template;
          }
        default:
          break;
      }
    }

    return items;
  }
}
