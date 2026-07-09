import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/learner/learner_state.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_planning/learner_history_summary.dart';
import 'package:tutor_language/features/lesson_planning/lesson_plan.dart';
import 'package:tutor_language/features/lesson_planning/planning_request.dart';
import 'package:tutor_language/features/lesson_planning/rule_based_lesson_planner.dart';

void main() {
  const planner = RuleBasedLessonPlanner();

  test('no history selects first lesson', () {
    final result = planner.plan(const PlanningRequest(course: _course));

    expect(result.isSuccess, isTrue);
    expect(result.plan!.selectedLessonId, 'lesson.001');
    expect(result.plan!.planType, LessonPlanType.newLesson);
    expect(result.plan!.reasonCodes, [
      LessonPlanReasonCode.noHistorySelectFirstLesson,
    ]);
  });

  test('current incomplete lesson is selected before moving forward', () {
    final result = planner.plan(
      const PlanningRequest(
        course: _course,
        learnerHistory: LearnerHistorySummary(
          completedLessonIds: {'lesson.001'},
          currentLessonId: 'lesson.002',
          incompleteLessonIds: {'lesson.002'},
        ),
      ),
    );

    expect(result.plan!.selectedLessonId, 'lesson.002');
    expect(result.plan!.planType, LessonPlanType.continueLesson);
    expect(result.plan!.reasonCodes, [
      LessonPlanReasonCode.currentLessonIncomplete,
    ]);
  });

  test('completed current lesson selects next lesson', () {
    final result = planner.plan(
      const PlanningRequest(
        course: _course,
        learnerHistory: LearnerHistorySummary(
          completedLessonIds: {'lesson.001'},
          currentLessonId: 'lesson.001',
        ),
      ),
    );

    expect(result.plan!.selectedLessonId, 'lesson.002');
    expect(result.plan!.planType, LessonPlanType.newLesson);
    expect(result.plan!.reasonCodes, [
      LessonPlanReasonCode.completedLessonSelectNext,
    ]);
  });

  test('low recent accuracy produces repeat plan', () {
    final result = planner.plan(
      const PlanningRequest(
        course: _course,
        learnerHistory: LearnerHistorySummary(
          completedLessonIds: {'lesson.002'},
          currentLessonId: 'lesson.002',
          recentCheckedAnswersCount: 4,
          recentCorrectAnswersCount: 1,
        ),
      ),
    );

    expect(result.plan!.selectedLessonId, 'lesson.002');
    expect(result.plan!.planType, LessonPlanType.repeatLesson);
    expect(result.plan!.reasonCodes, [
      LessonPlanReasonCode.lowAccuracyRepeatCurrent,
    ]);
  });

  test('no next lesson produces review plan', () {
    final result = planner.plan(
      const PlanningRequest(
        course: _course,
        learnerHistory: LearnerHistorySummary(
          completedLessonIds: {'lesson.001', 'lesson.002', 'lesson.003'},
          currentLessonId: 'lesson.003',
        ),
      ),
    );

    expect(result.plan!.selectedLessonId, 'lesson.003');
    expect(result.plan!.planType, LessonPlanType.reviewLesson);
    expect(result.plan!.reasonCodes, [
      LessonPlanReasonCode.noNextLessonAvailable,
    ]);
  });

  test('empty course returns clear failure', () {
    final result = planner.plan(const PlanningRequest(course: _emptyCourse));

    expect(result.isSuccess, isFalse);
    expect(result.failure!.reasonCode, LessonPlanReasonCode.emptyCourse);
    expect(result.failure!.message, contains('no usable lessons'));
  });

  test('invalid current lesson falls back deterministically', () {
    final result = planner.plan(
      PlanningRequest(
        course: _course,
        learnerState: LearnerState.initial(
          currentCourseId: _course.id,
          currentTopicId: 'lesson.missing',
          now: DateTime.utc(2026),
        ),
        learnerHistory: const LearnerHistorySummary(
          completedLessonIds: {'lesson.001'},
        ),
      ),
    );

    expect(result.plan!.selectedLessonId, 'lesson.002');
    expect(
      result.plan!.reasonCodes,
      contains(LessonPlanReasonCode.invalidCurrentLessonFallback),
    );
  });

  test('planner is deterministic for the same input', () {
    const request = PlanningRequest(
      course: _course,
      learnerHistory: LearnerHistorySummary(
        completedLessonIds: {'lesson.001'},
        currentLessonId: 'lesson.001',
      ),
    );

    final first = planner.plan(request).plan!;
    final second = planner.plan(request).plan!;

    expect(second.selectedLessonId, first.selectedLessonId);
    expect(second.planType, first.planType);
    expect(second.reasonCodes, first.reasonCodes);
    expect(second.diagnosticExplanation, first.diagnosticExplanation);
  });

  test('planner does not mutate input course, learner state, or history', () {
    final learnerState = LearnerState.initial(
      currentCourseId: _course.id,
      currentTopicId: 'lesson.001',
      now: DateTime.utc(2026),
    );
    const history = LearnerHistorySummary(
      completedLessonIds: {'lesson.001'},
      currentLessonId: 'lesson.001',
    );
    final originalLessonIds = _course.lessons
        .map((lesson) => lesson.id)
        .toList();
    final originalModuleLessonIds = _course.modules
        .expand((module) => module.lessonIds)
        .toList();

    planner.plan(
      PlanningRequest(
        course: _course,
        learnerState: learnerState,
        learnerHistory: history,
      ),
    );

    expect(_course.lessons.map((lesson) => lesson.id), originalLessonIds);
    expect(
      _course.modules.expand((module) => module.lessonIds),
      originalModuleLessonIds,
    );
    expect(learnerState.currentTopicId, 'lesson.001');
    expect(history.completedLessonIds, {'lesson.001'});
  });

  test(
    'planner does not require UI, database, JSON schemas, or LessonPlayer',
    () {
      final plannerSource = File(
        'lib/features/lesson_planning/rule_based_lesson_planner.dart',
      ).readAsStringSync();
      final modelSources = [
        'lib/features/lesson_planning/lesson_plan.dart',
        'lib/features/lesson_planning/planning_request.dart',
        'lib/features/lesson_planning/planning_policy.dart',
        'lib/features/lesson_planning/learner_history_summary.dart',
      ].map((path) => File(path).readAsStringSync()).join('\n');
      final source = '$plannerSource\n$modelSources';

      expect(source, isNot(contains('package:flutter/material.dart')));
      expect(source, isNot(contains('package:flutter_riverpod')));
      expect(source, isNot(contains('app_database')));
      expect(source, isNot(contains('LessonPlayer')));
      expect(source, isNot(contains('ContentLoader')));
      expect(source, isNot(contains('json_parsing')));
    },
  );
}

const _course = Course(
  id: 'course.test',
  languageId: 'language.test',
  title: 'Test Course',
  level: 'A0',
  version: '1.0.0',
  modules: [
    Module(
      id: 'module.first',
      title: 'First Module',
      lessonIds: ['lesson.001', 'lesson.002', 'lesson.003'],
    ),
  ],
  lessons: [_lesson002, _lesson001, _lesson003],
);

const _emptyCourse = Course(
  id: 'course.empty',
  languageId: 'language.test',
  title: 'Empty Course',
  level: 'A0',
  version: '1.0.0',
  modules: [],
  lessons: [],
);

const _lesson001 = Lesson(
  metadata: LessonMetadata(
    id: 'lesson.001',
    title: 'Lesson One',
    moduleId: 'module.first',
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
      title: 'Section One',
      order: 1,
      activities: [
        LessonActivity(
          id: 'activity.001',
          title: 'Activity One',
          type: 'vocabulary',
          order: 1,
          references: [
            LessonActivityReference(
              type: 'vocabulary',
              assetPath: 'assets/test/vocabulary.json',
              referenceId: 'vocab.001',
            ),
          ],
        ),
      ],
    ),
  ],
  summary: LessonSummary(
    id: 'summary.001',
    reviewPrompt: 'Review one.',
    referenceIds: ['objective.001'],
  ),
  completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
);

const _lesson002 = Lesson(
  metadata: LessonMetadata(
    id: 'lesson.002',
    title: 'Lesson Two',
    moduleId: 'module.first',
    courseId: 'course.test',
    estimatedDurationMinutes: 10,
    difficulty: 'A0',
    tags: [],
    version: '1.0.0',
    prerequisites: [LessonPrerequisite(lessonId: 'lesson.001')],
  ),
  objectives: [
    LessonObjective(id: 'objective.002', description: 'Second objective.'),
  ],
  sections: [
    LessonSection(
      id: 'section.002',
      title: 'Section Two',
      order: 1,
      activities: [
        LessonActivity(
          id: 'activity.002',
          title: 'Activity Two',
          type: 'grammar',
          order: 1,
        ),
      ],
    ),
  ],
  summary: LessonSummary(
    id: 'summary.002',
    reviewPrompt: 'Review two.',
    referenceIds: ['objective.002'],
  ),
  completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
);

const _lesson003 = Lesson(
  metadata: LessonMetadata(
    id: 'lesson.003',
    title: 'Lesson Three',
    moduleId: 'module.first',
    courseId: 'course.test',
    estimatedDurationMinutes: 10,
    difficulty: 'A0',
    tags: [],
    version: '1.0.0',
    prerequisites: [LessonPrerequisite(lessonId: 'lesson.002')],
  ),
  objectives: [
    LessonObjective(id: 'objective.003', description: 'Third objective.'),
  ],
  sections: [
    LessonSection(
      id: 'section.003',
      title: 'Section Three',
      order: 1,
      activities: [
        LessonActivity(
          id: 'activity.003',
          title: 'Activity Three',
          type: 'reading',
          order: 1,
        ),
      ],
    ),
  ],
  summary: LessonSummary(
    id: 'summary.003',
    reviewPrompt: 'Review three.',
    referenceIds: ['objective.003'],
  ),
  completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
);
