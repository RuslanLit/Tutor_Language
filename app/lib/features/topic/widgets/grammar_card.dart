import 'package:flutter/material.dart';

import '../../../core/content/topic_content.dart';

class GrammarContentCard extends StatelessWidget {
  const GrammarContentCard({required this.content, super.key});

  final GrammarContent content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final rule in content.rules) ...[
          Text(rule.title, style: Theme.of(context).textTheme.titleSmall),
          Text(rule.explanation),
          for (final example in rule.examples) Text(example),
        ],
      ],
    );
  }
}
