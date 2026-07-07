import 'package:flutter/widgets.dart';

import '../../../core/content/topic_content.dart';
import '../widgets/vocabulary_card.dart';
import 'topic_content_renderer.dart';

class VocabularyContentRenderer
    extends TopicContentRenderer<VocabularyContent> {
  const VocabularyContentRenderer();

  @override
  Widget build(
    BuildContext context,
    VocabularyContent content, {
    TopicContentRenderContext? renderContext,
  }) {
    return VocabularyContentCard(content: content);
  }
}
