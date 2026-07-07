import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/content/topic_content.dart';
import '../../../core/learner/learner_progress.dart';
import '../../exercise_runtime/exercise_runtime_models.dart';
import '../../exercise_runtime/exercise_runtime_widget.dart';
import '../rendering/topic_content_renderer.dart';

class ExerciseTemplateContentCard extends StatelessWidget {
  const ExerciseTemplateContentCard({
    required this.content,
    this.renderContext,
    super.key,
  });

  final ExerciseTemplateContent content;
  final TopicContentRenderContext? renderContext;

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
            onRuntimeEvent: (event) => _emitProgressEvent(event),
          ),
        ],
      ],
    );
  }

  void _emitProgressEvent(ExerciseRuntimeEvent event) {
    final context = renderContext;
    final onProgressEvent = context?.onProgressEvent;

    if (context == null || onProgressEvent == null) {
      return;
    }

    onProgressEvent(
      ProgressEvent.create(
        eventType: switch (event.eventType) {
          ExerciseRuntimeEventType.answerSelected =>
            ProgressEventType.exerciseAnswered,
          ExerciseRuntimeEventType.answerChecked =>
            ProgressEventType.answerChecked,
        },
        topicId: context.topicId,
        sectionId: context.sectionId,
        contentReference: context.contentReference,
        metadataJson: jsonEncode({
          'itemId': event.itemId,
          'templateId': event.templateId,
          'interactionType': event.interactionType,
        }),
      ),
    );
  }
}
