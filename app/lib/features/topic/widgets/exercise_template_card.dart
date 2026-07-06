import 'package:flutter/material.dart';

import '../../../core/content/topic_content.dart';
import '../../exercise_runtime/exercise_runtime_models.dart';
import '../../exercise_runtime/exercise_runtime_widget.dart';

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
          Text('Required object types: ${template.requiredObjectTypes.length}'),
          Text('Supported goals: ${template.supportedGoalTypes.length}'),
          const SizedBox(height: 8),
          ExerciseRuntimeWidget(
            session: ExerciseSession.fromTemplate(template),
          ),
        ],
      ],
    );
  }
}
