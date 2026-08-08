import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/router/app_router.dart';
import '../core/audio/temporary_learner_recording_control.dart';

class RecordingQaScreen extends StatelessWidget {
  const RecordingQaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QA ONLY: Learner recording'),
        leading: IconButton(
          tooltip: 'Back to settings',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(SettingsRoute.name),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: TemporaryLearnerRecordingControl(),
        ),
      ),
    );
  }
}
