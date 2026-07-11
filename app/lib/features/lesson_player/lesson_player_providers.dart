import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../activity_engine/activity_template_state.dart';
import '../lesson_assembly/lesson_assembly_service.dart';
import '../lesson_assembly/lesson_content.dart';

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
    this.currentStepIndex = 0,
    this.completedStepIds = const {},
    this.stepStates = const {},
  });

  final int currentStepIndex;
  final Set<String> completedStepIds;
  final Map<String, ActivityTemplateState> stepStates;

  LessonPlayerSessionState copyWith({
    int? currentStepIndex,
    Set<String>? completedStepIds,
    Map<String, ActivityTemplateState>? stepStates,
  }) {
    return LessonPlayerSessionState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      completedStepIds: completedStepIds ?? this.completedStepIds,
      stepStates: stepStates ?? this.stepStates,
    );
  }
}
