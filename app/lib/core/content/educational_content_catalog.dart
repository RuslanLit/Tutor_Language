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
    final content = contentByAssetPath(reference.assetPath);

    if (content == null || content.type != reference.type) {
      return false;
    }

    final referenceId = reference.referenceId;

    if (referenceId == null) {
      return true;
    }

    return _contentContainsReference(content, referenceId);
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

  static bool _contentContainsReference(
    EducationalContent content,
    String referenceId,
  ) {
    return switch (content) {
      VocabularyContent() => content.entries.any(
        (entry) => entry.id == referenceId,
      ),
      GrammarContent() => content.topics.any(
        (topic) => topic.id == referenceId,
      ),
      DialogueContent() => content.dialogues.any(
        (dialogue) => dialogue.id == referenceId,
      ),
      ReadingContent() => content.texts.any((text) => text.id == referenceId),
      ExerciseTemplateContent() => content.templates.any(
        (template) => template.id == referenceId,
      ),
      _ => false,
    };
  }
}
