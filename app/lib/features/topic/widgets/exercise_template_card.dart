import 'package:flutter/material.dart';

import '../../../core/content/topic_content.dart';

class ExerciseTemplateContentCard extends StatelessWidget {
  const ExerciseTemplateContentCard({required this.content, super.key});

  final ExerciseTemplateContent content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final template in content.templates) ...[
          Text(template.id),
          Text('Type: ${template.exerciseType}'),
          Text('Prompt: ${template.promptTemplate}'),
          Text('Question count: ${template.requiredObjectTypes.length}'),
          Text('Option count: ${template.supportedGoalTypes.length}'),
        ],
      ],
    );
  }
}
