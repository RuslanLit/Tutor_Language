import '../../core/learner/learner_progress.dart';
import '../../core/learner/learner_progress_repository.dart';
import '../exercise_runtime/answer_check_models.dart';
import '../exercise_runtime/exercise_runtime_models.dart';
import 'completion_evaluator.dart';
import 'learning_session.dart';

class LearningSessionController {
  LearningSessionController({
    required this.progressRepository,
    this.completionEvaluator = const CompletionEvaluator(),
    this.onProgressRecorded,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final LearnerProgressRepository progressRepository;
  final CompletionEvaluator completionEvaluator;
  final void Function(String topicId)? onProgressRecorded;
  final DateTime Function() _now;

  LearningSession? _session;

  LearningSession? get session => _session;

  Future<LearningSession> startSession(String topicId) async {
    final existingSession = _session;
    if (existingSession != null && existingSession.topicId == topicId) {
      return existingSession;
    }

    final session = LearningSession.start(topicId: topicId, now: _now());
    _session = session;

    await _recordProgressEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.topicViewed,
        topicId: topicId,
        now: _now(),
      ),
    );

    return session;
  }

  Future<void> finishSession() async {
    final session = _session;
    if (session == null || session.finishedAt != null) {
      return;
    }

    final finishedAt = _now();
    final decision = completionEvaluator.evaluate(
      CompletionEvaluation(
        checkedAnswerStatuses: session.checkedAnswerStatuses,
      ),
    );

    if (decision.isCompleted) {
      await _recordProgressEvent(
        ProgressEvent.create(
          eventType: ProgressEventType.topicCompleted,
          topicId: session.topicId,
          now: finishedAt,
        ),
      );
    }

    _session = session.copyWith(finishedAt: finishedAt);
  }

  Future<void> recordInteraction({
    required String sectionId,
    required String contentReference,
    String? metadataJson,
  }) async {
    final session = _requireSession();
    _session = session.copyWith(interactionCount: session.interactionCount + 1);

    await _recordProgressEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.exerciseAnswered,
        topicId: session.topicId,
        sectionId: sectionId,
        contentReference: contentReference,
        metadataJson: metadataJson,
        now: _now(),
      ),
    );
  }

  Future<void> recordAnswerChecked({
    required String sectionId,
    required String contentReference,
    required AnswerCheckStatus answerCheckStatus,
    String? metadataJson,
  }) async {
    final session = _requireSession();
    _session = session.copyWith(
      checkedAnswerCount: session.checkedAnswerCount + 1,
      checkedAnswerStatuses: [
        ...session.checkedAnswerStatuses,
        answerCheckStatus,
      ],
    );

    await _recordProgressEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.answerChecked,
        topicId: session.topicId,
        sectionId: sectionId,
        contentReference: contentReference,
        metadataJson: metadataJson,
        now: _now(),
      ),
    );
  }

  Future<void> recordRuntimeEvent({
    required ExerciseRuntimeEvent event,
    required String sectionId,
    required String contentReference,
    String? metadataJson,
  }) {
    return switch (event.eventType) {
      ExerciseRuntimeEventType.answerSelected => recordInteraction(
        sectionId: sectionId,
        contentReference: contentReference,
        metadataJson: metadataJson,
      ),
      ExerciseRuntimeEventType.answerChecked => recordAnswerChecked(
        sectionId: sectionId,
        contentReference: contentReference,
        answerCheckStatus:
            event.answerCheckStatus ?? AnswerCheckStatus.unsupported,
        metadataJson: metadataJson,
      ),
    };
  }

  LearningSession _requireSession() {
    final session = _session;
    if (session == null) {
      throw StateError('Learning session has not started');
    }

    return session;
  }

  Future<void> _recordProgressEvent(ProgressEvent event) async {
    await progressRepository.recordEvent(event);
    onProgressRecorded?.call(event.topicId);
  }
}
