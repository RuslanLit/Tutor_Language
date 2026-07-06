import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/content/topic_content.dart';
import 'dialogue_content_renderer.dart';
import 'exercise_template_content_renderer.dart';
import 'grammar_content_renderer.dart';
import 'reading_content_renderer.dart';
import 'topic_content_renderer.dart';
import 'unsupported_content_renderer.dart';
import 'vocabulary_content_renderer.dart';

final topicContentRendererRegistryProvider =
    Provider<TopicContentRendererRegistry>((ref) {
      return TopicContentRendererRegistry.defaultRegistry();
    });

class TopicContentRendererRegistry {
  const TopicContentRendererRegistry({
    required this.renderers,
    this.unsupportedRenderer = const UnsupportedContentRenderer(),
  });

  factory TopicContentRendererRegistry.defaultRegistry() {
    return const TopicContentRendererRegistry(
      renderers: [
        VocabularyContentRenderer(),
        GrammarContentRenderer(),
        DialogueContentRenderer(),
        ReadingContentRenderer(),
        ExerciseTemplateContentRenderer(),
      ],
    );
  }

  final List<TopicContentRenderer<TopicContent>> renderers;
  final UnsupportedContentRenderer unsupportedRenderer;

  TopicContentRenderer<TopicContent> rendererFor(TopicContent content) {
    for (final renderer in renderers) {
      if (renderer.canRender(content)) {
        return renderer;
      }
    }

    return unsupportedRenderer;
  }

  Widget build(BuildContext context, TopicContent content) {
    return rendererFor(content).buildContent(context, content);
  }
}
