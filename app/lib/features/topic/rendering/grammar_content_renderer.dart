import 'package:flutter/widgets.dart';

import '../../../core/content/topic_content.dart';
import '../widgets/grammar_card.dart';
import 'topic_content_renderer.dart';

class GrammarContentRenderer extends TopicContentRenderer<GrammarContent> {
  const GrammarContentRenderer();

  @override
  Widget build(BuildContext context, GrammarContent content) {
    return GrammarContentCard(content: content);
  }
}
