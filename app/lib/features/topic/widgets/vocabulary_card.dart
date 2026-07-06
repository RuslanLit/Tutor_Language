import 'package:flutter/material.dart';

import '../../../core/content/topic_content.dart';

class VocabularyContentCard extends StatelessWidget {
  const VocabularyContentCard({required this.content, super.key});

  final VocabularyContent content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in content.entries) ...[
          Text('${entry.spanish} - ${entry.nativeTranslation}'),
          if (entry.example.isNotEmpty) Text(entry.example),
          if (entry.notes != null && entry.notes!.isNotEmpty)
            Text(entry.notes!),
        ],
      ],
    );
  }
}
