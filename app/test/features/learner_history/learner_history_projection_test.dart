import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/learner/lesson_attempt.dart';
import 'package:tutor_language/core/learner/learner_progress.dart';
import 'package:tutor_language/core/learner/learner_progress_repository.dart';
import 'package:tutor_language/core/learner/learner_state.dart';
import 'package:tutor_language/core/learner/learner_state_repository.dart';
import 'package:tutor_language/features/learner_history/learner_history_projection.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_planning/learner_history_summary.dart';
import 'package:tutor_language/features/lesson_planning/planning_request.dart';
import 'package:tutor_language/features/lesson_planning/rule_based_lesson_planner.dart';

void main() {
  late AppDatabase database;
  late LearnerProgressRepository progressRepository;
  late LearnerStateRepository stateRepository;
  late LearnerHistoryProjection projection;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    progressRepository = LearnerProgressRepository(database);
    stateRepository = LearnerStateRepository(database);
    projection = LearnerHistoryProjection(
      learnerProgressRepository: progressRepository,
      learnerStateRepository: stateRepository,
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('empty persistence projects empty history', () async {
    final summary = await projection.project();

    expect(summary.hasHistory, isFalse);
    expect(summary.completedLessonIds, isEmpty);
    expect(summary.currentLessonId, isNull);
    expect(summary.incompleteLessonIds, isEmpty);
    expect(summary.recentCheckedAnswersCount, 0);
    expect(summary.recentCorrectAnswersCount, 0);
    expect(summary.lastAttemptedLessonId, isNull);
  });

  test('projects completed lessons from persisted progress', () async {
    await progressRepository.recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.lessonCompleted,
        topicId: 'lesson.completed',
        now: DateTime.utc(2026, 7),
      ),
    );

    final summary = await projection.project();

    expect(summary.completedLessonIds, {'lesson.completed'});
    expect(summary.lastAttemptedLessonId, 'lesson.completed');
  });

  test(
    'projects legacy topicCompleted lesson events for compatibility',
    () async {
      await progressRepository.recordEvent(
        ProgressEvent.create(
          eventType: ProgressEventType.topicCompleted,
          topicId: 'lesson.legacy',
          now: DateTime.utc(2026, 7),
        ),
      );

      final summary = await projection.project();

      expect(summary.completedLessonIds, {'lesson.legacy'});
    },
  );

  test('projects current lesson from persisted learner state', () async {
    await stateRepository.saveState(
      LearnerState.initial(
        currentCourseId: 'course.test',
        currentTopicId: 'lesson.current',
        now: DateTime.utc(2026, 7),
      ),
    );

    final summary = await projection.project();

    expect(summary.currentLessonId, 'lesson.current');
  });

  test('projects latest durable lesson outcome when available', () async {
    await stateRepository.saveState(
      LearnerState.initial(
        currentCourseId: 'course.test',
        currentTopicId: 'lesson.current',
        now: DateTime.utc(2026, 7),
      ),
    );
    await progressRepository.recordCompletedLessonAttempt(
      _attemptCommand(
        attemptId: 'attempt.001',
        lessonId: 'lesson.completed',
        courseId: 'course.test',
        completedAt: DateTime.utc(2026, 7),
        outcomeStatus: DurableLessonOutcomeStatus.completedWithReinforcement,
      ),
    );
    await progressRepository.recordCompletedLessonAttempt(
      _attemptCommand(
        attemptId: 'attempt.002',
        lessonId: 'lesson.completed',
        courseId: 'course.test',
        completedAt: DateTime.utc(2026, 7, 2),
        purpose: LessonAttemptPurpose.manualRepeat,
      ),
    );

    final summary = await projection.project();
    final latest = summary.latestLessonAttemptsByLessonId['lesson.completed'];

    expect(summary.completedLessonIds, {'lesson.completed'});
    expect(latest, isNotNull);
    expect(latest!.attemptId, 'attempt.002');
    expect(latest.outcomeStatus, DurableLessonOutcomeStatus.mastered);
    expect(latest.purpose, LessonAttemptPurpose.manualRepeat);
    expect(latest.learningPolicyVersion, 'e20-v1');
    expect(
      summary.lessonAttemptHistoryByLessonId['lesson.completed']?.map(
        (attempt) => attempt.attemptId,
      ),
      ['attempt.001', 'attempt.002'],
    );
  });

  test('legacy completion has no fabricated durable outcome', () async {
    await stateRepository.saveState(
      LearnerState.initial(
        currentCourseId: 'course.test',
        currentTopicId: 'lesson.legacy',
        now: DateTime.utc(2026, 7),
      ),
    );
    await progressRepository.recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.lessonCompleted,
        topicId: 'lesson.legacy',
        now: DateTime.utc(2026, 7),
      ),
    );

    final summary = await projection.project();

    expect(summary.completedLessonIds, {'lesson.legacy'});
    expect(summary.latestLessonAttemptsByLessonId, isEmpty);
  });

  test('malformed durable attempt does not erase valid history', () async {
    await stateRepository.saveState(
      LearnerState.initial(
        currentCourseId: 'course.test',
        currentTopicId: 'lesson.current',
        now: DateTime.utc(2026, 7),
      ),
    );
    await progressRepository.recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.lessonCompleted,
        topicId: 'lesson.legacy',
        now: DateTime.utc(2026, 7),
      ),
    );
    await progressRepository.recordCompletedLessonAttempt(
      _attemptCommand(
        attemptId: 'attempt.valid.a',
        lessonId: 'lesson.valid.a',
        courseId: 'course.test',
        completedAt: DateTime.utc(2026, 7, 1),
      ),
    );
    await database
        .into(database.lessonAttempts)
        .insert(
          LessonAttemptsCompanion(
            attemptId: const Value('attempt.malformed'),
            lessonId: const Value('lesson.malformed'),
            courseId: const Value('course.test'),
            attemptPurpose: const Value('not_a_known_purpose'),
            completedAt: Value(DateTime.utc(2026, 7, 2)),
            outcomeStatus: const Value('mastered'),
            outcomeReasonCode: const Value('all_steps_mastered'),
            assessedStepCount: const Value(1),
            masteredStepCount: const Value(1),
            fragileStepCount: const Value(0),
            notMasteredStepCount: const Value(0),
            unassessedStepCount: const Value(0),
            canonicalCheckableStepCount: const Value(1),
            totalSubmissionCount: const Value(1),
            learningPolicyVersion: const Value('e20-v1'),
          ),
        );
    await database
        .into(database.lessonAttemptStepResults)
        .insert(
          const LessonAttemptStepResultsCompanion(
            attemptId: Value('attempt.malformed'),
            lessonId: Value('lesson.malformed'),
            stepId: Value('step.bad'),
            masteryStatus: Value('unknown_mastery'),
            masteryReasonCode: Value('first_attempt_correct'),
            attemptCount: Value(1),
            successfulSubmissionCount: Value(1),
            latestEvaluationOutcome: Value('correct'),
            remediationWasRequired: Value(false),
            reviewWasRequired: Value(false),
            confirmationSucceeded: Value(false),
          ),
        );
    await progressRepository.recordCompletedLessonAttempt(
      _attemptCommand(
        attemptId: 'attempt.valid.c',
        lessonId: 'lesson.valid.c',
        courseId: 'course.test',
        completedAt: DateTime.utc(2026, 7, 3),
      ),
    );

    final summary = await projection.project();

    expect(summary.completedLessonIds, {
      'lesson.legacy',
      'lesson.valid.a',
      'lesson.valid.c',
    });
    expect(summary.latestLessonAttemptsByLessonId.keys, {
      'lesson.valid.a',
      'lesson.valid.c',
    });
    expect(summary.latestLessonAttemptsByLessonId, isNot(contains('unknown')));
  });

  test('legacy progress survives durable attempt summary failure', () async {
    await stateRepository.saveState(
      LearnerState.initial(
        currentCourseId: 'course.test',
        currentTopicId: 'lesson.current',
        now: DateTime.utc(2026, 7),
      ),
    );
    await progressRepository.recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.lessonCompleted,
        topicId: 'lesson.legacy',
        now: DateTime.utc(2026, 7),
      ),
    );
    final failingProjection = LearnerHistoryProjection(
      learnerProgressRepository: _AttemptSummaryThrowingProgressRepository(
        database,
      ),
      learnerStateRepository: stateRepository,
    );

    final summary = await failingProjection.project();

    expect(summary.completedLessonIds, {'lesson.legacy'});
    expect(summary.latestLessonAttemptsByLessonId, isEmpty);
  });

  test(
    'projects incomplete lessons from attempted uncompleted progress',
    () async {
      await progressRepository.recordEvent(
        ProgressEvent.create(
          eventType: ProgressEventType.topicViewed,
          topicId: 'lesson.incomplete',
          now: DateTime.utc(2026, 7),
        ),
      );

      final summary = await projection.project();

      expect(summary.incompleteLessonIds, {'lesson.incomplete'});
      expect(summary.completedLessonIds, isEmpty);
    },
  );

  test('projects recent accuracy from answer checked metadata', () async {
    await progressRepository.recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.answerChecked,
        topicId: 'lesson.accuracy',
        metadataJson: '{"answerCheckStatus":"correct"}',
        now: DateTime.utc(2026, 7),
      ),
    );
    await progressRepository.recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.answerChecked,
        topicId: 'lesson.accuracy',
        metadataJson: '{"answerCheckStatus":"incorrect"}',
        now: DateTime.utc(2026, 7, 1, 1),
      ),
    );

    final summary = await projection.project();

    expect(summary.recentCheckedAnswersCount, 2);
    expect(summary.recentCorrectAnswersCount, 1);
    expect(summary.recentAccuracy, 0.5);
  });

  test('projection does not mutate persisted progress', () async {
    await progressRepository.recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.topicViewed,
        topicId: 'lesson.viewed',
        now: DateTime.utc(2026, 7),
      ),
    );

    final before = await progressRepository.readEvents();
    await projection.project();
    final after = await progressRepository.readEvents();

    expect(after, before);
  });

  test('projection handles missing persistence data gracefully', () async {
    final failingProjection = LearnerHistoryProjection(
      learnerProgressRepository: _ThrowingProgressRepository(database),
      learnerStateRepository: _ThrowingStateRepository(database),
    );

    final summary = await failingProjection.project();

    expect(summary.hasHistory, isFalse);
  });

  test('planner behavior is unchanged for identical summaries', () async {
    await stateRepository.saveState(
      LearnerState.initial(
        currentCourseId: _course.id,
        currentTopicId: 'lesson.001',
        now: DateTime.utc(2026, 7),
      ),
    );
    await progressRepository.recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.lessonCompleted,
        topicId: 'lesson.001',
        now: DateTime.utc(2026, 7),
      ),
    );

    final projectedSummary = await projection.project();
    const identicalSummary = LearnerHistorySummary(
      completedLessonIds: {'lesson.001'},
      currentLessonId: 'lesson.001',
      lastAttemptedLessonId: 'lesson.001',
    );
    const planner = RuleBasedLessonPlanner();

    final projectedPlan = planner
        .plan(
          PlanningRequest(course: _course, learnerHistory: projectedSummary),
        )
        .plan!;
    final manualPlan = planner
        .plan(
          const PlanningRequest(
            course: _course,
            learnerHistory: identicalSummary,
          ),
        )
        .plan!;

    expect(projectedPlan.selectedLessonId, manualPlan.selectedLessonId);
    expect(projectedPlan.planType, manualPlan.planType);
    expect(projectedPlan.reasonCodes, manualPlan.reasonCodes);
  });
}

class _ThrowingProgressRepository extends LearnerProgressRepository {
  _ThrowingProgressRepository(super.database);

  @override
  Future<List<ProgressEvent>> readEvents() async {
    throw StateError('progress unavailable');
  }
}

class _AttemptSummaryThrowingProgressRepository
    extends LearnerProgressRepository {
  _AttemptSummaryThrowingProgressRepository(super.database);

  @override
  Future<List<LessonAttemptSummary>> getCourseLessonAttemptSummaries(
    String courseId,
  ) async {
    throw StateError('attempt detail unavailable');
  }
}

CompletedLessonAttemptCommand _attemptCommand({
  required String attemptId,
  required String lessonId,
  required String courseId,
  required DateTime completedAt,
  DurableLessonOutcomeStatus outcomeStatus =
      DurableLessonOutcomeStatus.mastered,
  LessonAttemptPurpose purpose = LessonAttemptPurpose.normal,
}) {
  final mastered = outcomeStatus == DurableLessonOutcomeStatus.mastered ? 1 : 0;
  final fragile = outcomeStatus == DurableLessonOutcomeStatus.mastered ? 0 : 1;

  return CompletedLessonAttemptCommand(
    attempt: DurableLessonAttempt(
      attemptId: attemptId,
      lessonId: lessonId,
      courseId: courseId,
      purpose: purpose,
      completedAt: completedAt,
      outcomeStatus: outcomeStatus,
      outcomeReasonCode: outcomeStatus == DurableLessonOutcomeStatus.mastered
          ? DurableLessonOutcomeReasonCode.allStepsMastered
          : DurableLessonOutcomeReasonCode.fragileMasteryPresent,
      assessedStepCount: 1,
      masteredStepCount: mastered,
      fragileStepCount: fragile,
      notMasteredStepCount: 0,
      unassessedStepCount: 0,
      canonicalCheckableStepCount: 1,
      totalSubmissionCount: 1,
      learningPolicyVersion: 'e20-v1',
    ),
    stepResults: [
      DurableStepResult(
        attemptId: attemptId,
        lessonId: lessonId,
        stepId: 'step.practice',
        masteryStatus: outcomeStatus == DurableLessonOutcomeStatus.mastered
            ? DurableStepMasteryStatus.mastered
            : DurableStepMasteryStatus.fragile,
        masteryReasonCode: outcomeStatus == DurableLessonOutcomeStatus.mastered
            ? DurableStepMasteryReasonCode.firstAttemptCorrect
            : DurableStepMasteryReasonCode.acceptedWithCorrection,
        attemptCount: 1,
        successfulSubmissionCount: 1,
        latestEvaluationOutcome: DurableActivityResultStatus.correct,
        remediationWasRequired: false,
        reviewWasRequired: false,
        confirmationSucceeded: false,
      ),
    ],
  );
}

class _ThrowingStateRepository extends LearnerStateRepository {
  _ThrowingStateRepository(super.database);

  @override
  Future<LearnerState?> readState() async {
    throw StateError('state unavailable');
  }
}

const _course = Course(
  id: 'course.test',
  languageId: 'language.test',
  title: 'Test Course',
  level: 'A0',
  version: '1.0.0',
  modules: [
    Module(
      id: 'module.test',
      title: 'Test Module',
      lessonIds: ['lesson.001', 'lesson.002'],
    ),
  ],
  lessons: [
    Lesson(
      metadata: LessonMetadata(
        id: 'lesson.001',
        title: 'Lesson One',
        moduleId: 'module.test',
        courseId: 'course.test',
        estimatedDurationMinutes: 10,
        difficulty: 'A0',
        tags: [],
        version: '1.0.0',
        prerequisites: [],
      ),
      objectives: [
        LessonObjective(id: 'objective.001', description: 'First objective.'),
      ],
      sections: [
        LessonSection(
          id: 'section.001',
          title: 'First Section',
          order: 1,
          activities: [],
        ),
      ],
      summary: LessonSummary(
        id: 'summary.001',
        reviewPrompt: 'Review.',
        referenceIds: ['objective.001'],
      ),
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
      references: [],
    ),
    Lesson(
      metadata: LessonMetadata(
        id: 'lesson.002',
        title: 'Lesson Two',
        moduleId: 'module.test',
        courseId: 'course.test',
        estimatedDurationMinutes: 10,
        difficulty: 'A0',
        tags: [],
        version: '1.0.0',
        prerequisites: [],
      ),
      objectives: [
        LessonObjective(id: 'objective.002', description: 'Second objective.'),
      ],
      sections: [
        LessonSection(
          id: 'section.002',
          title: 'Second Section',
          order: 1,
          activities: [],
        ),
      ],
      summary: LessonSummary(
        id: 'summary.002',
        reviewPrompt: 'Review.',
        referenceIds: ['objective.002'],
      ),
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
      references: [],
    ),
  ],
);
