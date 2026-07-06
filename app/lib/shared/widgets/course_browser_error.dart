import 'package:flutter/material.dart';

class CourseBrowserError extends StatelessWidget {
  const CourseBrowserError({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Unable to load course content.\n$message',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
