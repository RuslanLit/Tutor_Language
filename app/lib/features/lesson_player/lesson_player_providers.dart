import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/learner/lesson_attempt.dart';
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

enum LessonCompletionPersistenceStatus {
  notRequested,
  persisting,
  failed,
  persisted,
}

class LessonPlayerSessionState {
  const LessonPlayerSessionState({
    this.sessionState = const LessonSessionState(lessonId: ''),
    this.stepStates = const {},
    this.attemptPurpose = LessonAttemptPurpose.normal,
    this.attemptId,
    this.attemptStartedAt,
    this.lessonOutcome,
    this.completionAttemptId,
    this.completionCompletedAt,
    this.completionPersistenceStatus =
        LessonCompletionPersistenceStatus.notRequested,
    this.completionError,
  });

  final LessonSessionState sessionState;
  final Map<String, ActivityTemplateState> stepStates;
  final LessonAttemptPurpose attemptPurpose;
  final String? attemptId;
  final DateTime? attemptStartedAt;
  final LessonOutcome? lessonOutcome;
  final String? completionAttemptId;
  final DateTime? completionCompletedAt;
  final LessonCompletionPersistenceStatus completionPersistenceStatus;
  final String? completionError;

  LessonPlayerSessionState copyWith({
    LessonSessionState? sessionState,
    Map<String, ActivityTemplateState>? stepStates,
    LessonAttemptPurpose? attemptPurpose,
    Object? attemptId = _unset,
    Object? attemptStartedAt = _unset,
    Object? lessonOutcome = _unset,
    Object? completionAttemptId = _unset,
    Object? completionCompletedAt = _unset,
    LessonCompletionPersistenceStatus? completionPersistenceStatus,
    Object? completionError = _unset,
  }) {
    return LessonPlayerSessionState(
      sessionState: sessionState ?? this.sessionState,
      stepStates: stepStates ?? this.stepStates,
      attemptPurpose: attemptPurpose ?? this.attemptPurpose,
      attemptId: attemptId == _unset ? this.attemptId : attemptId as String?,
      attemptStartedAt: attemptStartedAt == _unset
          ? this.attemptStartedAt
          : attemptStartedAt as DateTime?,
      lessonOutcome: lessonOutcome == _unset
          ? this.lessonOutcome
          : lessonOutcome as LessonOutcome?,
      completionAttemptId: completionAttemptId == _unset
          ? this.completionAttemptId
          : completionAttemptId as String?,
      completionCompletedAt: completionCompletedAt == _unset
          ? this.completionCompletedAt
          : completionCompletedAt as DateTime?,
      completionPersistenceStatus:
          completionPersistenceStatus ?? this.completionPersistenceStatus,
      completionError: completionError == _unset
          ? this.completionError
          : completionError as String?,
    );
  }

  LessonPlayerSessionState ensureStarted({
    required String lessonId,
    required List<LessonPlayerStep> steps,
    LessonAttemptPurpose attemptPurpose = LessonAttemptPurpose.normal,
    LessonSessionEngine engine = const LessonSessionEngine(),
  }) {
    final stepIds = steps.map((step) => step.id).toList(growable: false);
    final isSameSession =
        sessionState.lessonId == lessonId &&
        this.attemptPurpose == attemptPurpose &&
        _listEquals(sessionState.canonicalStepIds, stepIds) &&
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
              reviewStepIds: step.reviewStepIds,
            ),
          )
          .toList(growable: false),
    );

    final startedAt = DateTime.now().toUtc();

    return LessonPlayerSessionState(
      sessionState: decision.updatedState,
      attemptPurpose: attemptPurpose,
      attemptId:
          '${startedAt.microsecondsSinceEpoch}.$lessonId.${attemptPurpose.code}.attempt',
      attemptStartedAt: startedAt,
    );
  }
}

const Object _unset = Object();

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
