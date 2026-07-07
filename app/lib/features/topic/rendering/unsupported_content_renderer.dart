import 'package:flutter/material.dart';

import '../../../core/content/topic_content.dart';
import 'topic_content_renderer.dart';

class UnsupportedContentRenderer extends TopicContentRenderer<TopicContent> {
  const UnsupportedContentRenderer();

  @override
  bool canRender(TopicContent content) => true;

  @override
  Widget build(
    BuildContext context,
    TopicContent content, {
    TopicContentRenderContext? renderContext,
  }) {
    return Text(
      'This content type is not supported yet: ${content.type}',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
