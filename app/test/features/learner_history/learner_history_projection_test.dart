import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/database/app_database.dart';
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
