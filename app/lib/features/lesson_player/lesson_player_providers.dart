import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../activity_engine/activity_template_state.dart';
import '../lesson_assembly/lesson_assembly_service.dart';
import '../lesson_assembly/lesson_content.dart';
import '../lesson_session/lesson_session_engine.dart';
import 'lesson_player_step.dart';

final lessonAssemblyServiceProvider = Provider<LessonAssemblyService>((ref) {
  return LessonAssemblyService();
});

final assembledLessonProvider = FutureProvider.family<LessonContent, String>((
  ref,
  lessonId,
) {
  return ref.watch(lessonAssemblyServiceProvider).assembleLesson(lessonId);
});

final lessonPlayerSessionProvider =
    StateProvider.family<LessonPlayerSessionState, String>((ref, lessonId) {
      return const LessonPlayerSessionState();
    });

class LessonPlayerSessionState {
  const LessonPlayerSessionState({
    this.sessionState = const LessonSessionState(lessonId: ''),
    this.stepStates = const {},
  });

  final LessonSessionState sessionState;
  final Map<String, ActivityTemplateState> stepStates;

  LessonPlayerSessionState copyWith({
    LessonSessionState? sessionState,
    Map<String, ActivityTemplateState>? stepStates,
  }) {
    return LessonPlayerSessionState(
      sessionState: sessionState ?? this.sessionState,
      stepStates: stepStates ?? this.stepStates,
    );
  }

  LessonPlayerSessionState ensureStarted({
    required String lessonId,
    required List<LessonPlayerStep> steps,
    LessonSessionEngine engine = const LessonSessionEngine(),
  }) {
    final stepIds = steps.map((step) => step.id).toList(growable: false);
    final isSameSession =
        sessionState.lessonId == lessonId &&
        _listEquals(sessionState.orderedStepIds, stepIds) &&
        (sessionState.status != LessonSessionStatus.notStarted ||
            steps.isEmpty);

    if (isSameSession) {
      return this;
    }

    final decision = engine.startSession(
      lessonId: lessonId,
      steps: steps
          .map(
            (step) => LessonSessionStep(
              id: step.id,
              isCheckable: step.isCheckable,
              hasRemediation: step.hasRemediation,
            ),
          )
          .toList(growable: false),
    );

    return copyWith(sessionState: decision.updatedState);
  }
}

bool _listEquals(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }

  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }

  return true;
}
