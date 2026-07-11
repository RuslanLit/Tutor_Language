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
    this.currentActivityIndex = 0,
    this.completedActivityIds = const {},
    this.activityStates = const {},
  });

  final int currentActivityIndex;
  final Set<String> completedActivityIds;
  final Map<String, ActivityTemplateState> activityStates;

  LessonPlayerSessionState copyWith({
    int? currentActivityIndex,
    Set<String>? completedActivityIds,
    Map<String, ActivityTemplateState>? activityStates,
  }) {
    return LessonPlayerSessionState(
      currentActivityIndex: currentActivityIndex ?? this.currentActivityIndex,
      completedActivityIds: completedActivityIds ?? this.completedActivityIds,
      activityStates: activityStates ?? this.activityStates,
    );
  }
}
