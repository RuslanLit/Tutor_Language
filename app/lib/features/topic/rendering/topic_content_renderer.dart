import 'package:flutter/widgets.dart';

import '../../../core/content/topic_content.dart';

abstract class TopicContentRenderer<T extends TopicContent> {
  const TopicContentRenderer();

  bool canRender(TopicContent content) => content is T;

  Widget build(BuildContext context, T content);

  Widget buildContent(BuildContext context, TopicContent content) {
    return build(context, content as T);
  }
}
