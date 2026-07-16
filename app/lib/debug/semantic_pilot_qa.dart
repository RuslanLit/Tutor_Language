import 'package:flutter/foundation.dart';

import '../core/content/semantic_pilot_scope.dart';

const semanticPilotQaDefineEnabled = bool.fromEnvironment('SEMANTIC_QA');

const semanticPilotQaRuntimeConfig = SemanticPilotQaConfig(
  isDebugMode: kDebugMode,
  enabledByDefine: semanticPilotQaDefineEnabled,
);

class SemanticPilotQaConfig {
  const SemanticPilotQaConfig({
    required this.isDebugMode,
    required this.enabledByDefine,
  });

  final bool isDebugMode;
  final bool enabledByDefine;

  bool get isEnabled => isDebugMode && enabledByDefine;
}

class SemanticPilotQaPolicy {
  const SemanticPilotQaPolicy(this.config);

  final SemanticPilotQaConfig config;

  List<String> get lessonIds => semanticPilotLessonIds;

  bool get isEnabled => config.isEnabled;

  bool canLaunchLessonId(String lessonId) {
    return isEnabled && isSemanticPilotLessonId(lessonId);
  }

  SemanticPilotQaLaunch? launchForLessonId(String lessonId) {
    if (!canLaunchLessonId(lessonId)) {
      return null;
    }
    return SemanticPilotQaLaunch(lessonId: lessonId);
  }
}

const semanticPilotQaPolicy = SemanticPilotQaPolicy(
  semanticPilotQaRuntimeConfig,
);

class SemanticPilotQaLaunch {
  const SemanticPilotQaLaunch({required this.lessonId});

  final String lessonId;
  bool get persistCompletion => false;
}
