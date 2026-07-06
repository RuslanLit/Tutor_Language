import 'package:flutter/widgets.dart';

import '../../../core/content/topic_content.dart';
import '../widgets/exercise_template_card.dart';
import 'topic_content_renderer.dart';

class ExerciseTemplateContentRenderer
    extends TopicContentRenderer<ExerciseTemplateContent> {
  const ExerciseTemplateContentRenderer();

  @override
  Widget build(BuildContext context, ExerciseTemplateContent content) {
    return ExerciseTemplateContentCard(content: content);
  }
}
