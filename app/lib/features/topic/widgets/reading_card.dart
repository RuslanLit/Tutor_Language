import 'package:flutter/material.dart';

import '../../../core/content/topic_content.dart';

class ReadingContentCard extends StatelessWidget {
  const ReadingContentCard({required this.content, super.key});

  final ReadingContent content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final reading in content.readings) ...[
          Text(reading.title, style: Theme.of(context).textTheme.titleSmall),
          for (final paragraph in reading.text.split('\n')) Text(paragraph),
          if (reading.nativeTranslation.isNotEmpty)
            Text(reading.nativeTranslation),
        ],
      ],
    );
  }
}
