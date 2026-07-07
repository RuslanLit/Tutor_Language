import 'package:flutter/widgets.dart';

import '../../../core/content/topic_content.dart';
import '../widgets/dialogue_card.dart';
import 'topic_content_renderer.dart';

class DialogueContentRenderer extends TopicContentRenderer<DialogueContent> {
  const DialogueContentRenderer();

  @override
  Widget build(
    BuildContext context,
    DialogueContent content, {
    TopicContentRenderContext? renderContext,
  }) {
    return DialogueContentCard(content: content);
  }
}
