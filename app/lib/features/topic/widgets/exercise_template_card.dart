import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/content/topic_content.dart';
import '../../../l10n/l10n.dart';
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
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final template in content.templates) ...[
          Text(template.id),
          Text(l10n.templateType(template.exerciseType)),
          Text(l10n.templatePrompt(template.promptTemplate)),
          Text(
            l10n.requiredObjectTypesCount(template.requiredObjectTypes.length),
          ),
          Text(l10n.supportedGoalsCount(template.supportedGoalTypes.length)),
          const SizedBox(height: 8),
          ExerciseRuntimeWidget(
            session: ExerciseSession.fromTemplate(template),
            onRuntimeEvent: (event) => _emitRuntimeEvent(event),
          ),
        ],
      ],
    );
  }

  void _emitRuntimeEvent(ExerciseRuntimeEvent event) {
    final context = renderContext;
    final onRuntimeEvent = context?.onRuntimeEvent;

    if (context == null || onRuntimeEvent == null) {
      return;
    }

    onRuntimeEvent(
      event.withContext(
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
