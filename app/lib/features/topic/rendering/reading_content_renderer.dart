import 'package:flutter/widgets.dart';

import '../../../core/content/topic_content.dart';
import '../widgets/reading_card.dart';
import 'topic_content_renderer.dart';

class ReadingContentRenderer extends TopicContentRenderer<ReadingContent> {
  const ReadingContentRenderer();

  @override
  Widget build(BuildContext context, ReadingContent content) {
    return ReadingContentCard(content: content);
  }
}
