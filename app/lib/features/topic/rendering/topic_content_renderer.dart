import 'package:flutter/widgets.dart';

import '../../../core/content/topic_content.dart';
import '../../exercise_runtime/exercise_runtime_models.dart';

class TopicContentRenderContext {
  const TopicContentRenderContext({
    required this.topicId,
    required this.sectionId,
    required this.contentReference,
    this.onRuntimeEvent,
  });

  final String topicId;
  final String sectionId;
  final String contentReference;
  final ValueChanged<ExerciseRuntimeEvent>? onRuntimeEvent;
}

abstract class TopicContentRenderer<T extends TopicContent> {
  const TopicContentRenderer();

  bool canRender(TopicContent content) => content is T;

  Widget build(
    BuildContext context,
    T content, {
    TopicContentRenderContext? renderContext,
  });

  Widget buildContent(BuildContext context, TopicContent content) {
    return build(context, content as T);
  }

  Widget buildContentWithContext(
    BuildContext context,
    TopicContent content, {
    TopicContentRenderContext? renderContext,
  }) {
    return build(context, content as T, renderContext: renderContext);
  }
}
