import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/content/content_localization.dart';
import '../../core/content/content_localization_providers.dart';
import '../../core/learner/lesson_attempt.dart';
import '../../core/learner/learner_progress.dart';
import '../../core/learner/learner_progress_providers.dart';
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
) async {
  final supportLocale = ref.watch(supportLocaleProvider);
  final lessonContent = await ref
      .watch(lessonAssemblyServiceProvider)
      .assembleLesson(lessonId);
  final localization = await ref.watch(
    educationalContentLocalizationBundleProvider.future,
  );
  final semanticLocalization = await ref.watch(
    semanticLocalizationBundleProvider.future,
  );
  final resolver = EducationalContentLocalizationResolver(
    localization,
    semanticBundle: semanticLocalization,
  );

  return resolveLocalizedLessonContent(
    lessonContent: lessonContent,
    resolver: resolver,
    supportLocale: supportLocale,
  );
});

final lessonPlayerSessionProvider =
    StateProvider.family<LessonPlayerSessionState, String>((ref, lessonId) {
      return const LessonPlayerSessionState();
    });

class LessonResumeCursorRequest {
  const LessonResumeCursorRequest({
    required this.lessonId,
    required this.attemptPurpose,
  });

  final String lessonId;
  final LessonAttemptPurpose attemptPurpose;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonResumeCursorRequest &&
          other.lessonId == lessonId &&
          other.attemptPurpose == attemptPurpose;

  @override
  int get hashCode => Object.hash(lessonId, attemptPurpose);
}

final lessonResumeCursorProvider =
    FutureProvider.family<LessonResumeCursor?, LessonResumeCursorRequest>((
      ref,
      request,
    ) {
      return ref
          .watch(learnerProgressRepositoryProvider)
          .getLessonResumeCursor(request.lessonId, request.attemptPurpose);
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
    LessonResumeCursor? resumeCursor,
    String? initialStepId,
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

    var startedSessionState = decision.updatedState;
    String? restoredAttemptId;
    DateTime? restoredStartedAt;
    if (resumeCursor != null &&
        resumeCursor.lessonId == lessonId &&
        resumeCursor.attemptPurpose == attemptPurpose) {
      final restoredIndex = startedSessionState.orderedStepIds.indexOf(
        resumeCursor.stepId,
      );
      if (restoredIndex >= 0) {
        startedSessionState = startedSessionState.copyWith(
          currentStepId: resumeCursor.stepId,
          currentStepIndex: restoredIndex,
        );
        restoredAttemptId = resumeCursor.attemptId;
        restoredStartedAt = resumeCursor.startedAt;
      }
    }

    if (restoredAttemptId == null && initialStepId != null) {
      final initialIndex = startedSessionState.orderedStepIds.indexOf(
        initialStepId,
      );
      if (initialIndex >= 0) {
        startedSessionState = startedSessionState.copyWith(
          currentStepId: initialStepId,
          currentStepIndex: initialIndex,
        );
      }
    }

    return LessonPlayerSessionState(
      sessionState: startedSessionState,
      attemptPurpose: attemptPurpose,
      attemptId:
          restoredAttemptId ??
          '${startedAt.microsecondsSinceEpoch}.$lessonId.${attemptPurpose.code}.attempt',
      attemptStartedAt: restoredStartedAt ?? startedAt,
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
