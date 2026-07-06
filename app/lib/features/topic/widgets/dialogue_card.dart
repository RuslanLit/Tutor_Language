import 'package:flutter/material.dart';

import '../../../core/content/topic_content.dart';

class DialogueContentCard extends StatelessWidget {
  const DialogueContentCard({required this.content, super.key});

  final DialogueContent content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final dialogue in content.dialogues) ...[
          Text(dialogue.title, style: Theme.of(context).textTheme.titleSmall),
          for (final line in dialogue.lines) ...[
            Text('${line.speaker}: ${line.spanish}'),
            if (line.nativeTranslation.isNotEmpty) Text(line.nativeTranslation),
          ],
        ],
      ],
    );
  }
}
