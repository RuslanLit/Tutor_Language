import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/learner/lesson_attempt.dart';
import 'package:tutor_language/core/learner/learner_state.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_planning/learner_history_summary.dart';
import 'package:tutor_language/features/lesson_planning/lesson_plan.dart';
import 'package:tutor_language/features/lesson_planning/planning_policy.dart';
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

  test('legacy completed current lesson selects next lesson', () {
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
      LessonPlanReasonCode.legacyCompletionWithoutDurableOutcome,
      LessonPlanReasonCode.completedLessonSelectNext,
    ]);
  });

  test(
    'low recent accuracy remains fallback without completed outcome evidence',
    () {
      final result = planner.plan(
        const PlanningRequest(
          course: _course,
          learnerHistory: LearnerHistorySummary(
            currentLessonId: 'lesson.002',
            recentCheckedAnswersCount: 4,
            recentCorrectAnswersCount: 1,
          ),
          policy: PlanningPolicy(preferIncompleteLesson: false),
        ),
      );

      expect(result.plan!.selectedLessonId, 'lesson.002');
      expect(result.plan!.planType, LessonPlanType.repeatLesson);
      expect(result.plan!.reasonCodes, [
        LessonPlanReasonCode.lowAccuracyRepeatCurrent,
      ]);
    },
  );

  test('legacy final completion produces course complete plan', () {
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
    expect(result.plan!.planType, LessonPlanType.courseComplete);
    expect(result.plan!.reasonCodes, [
      LessonPlanReasonCode.legacyCompletionWithoutDurableOutcome,
      LessonPlanReasonCode.legacyFinalCompletionCourseComplete,
    ]);
  });

  test('mastered normal attempt selects next lesson', () {
    final result = planner.plan(
      PlanningRequest(
        course: _course,
        learnerHistory: _historyWithAttempt(
          _attempt(
            attemptId: 'attempt.mastered',
            lessonId: 'lesson.001',
            outcomeStatus: DurableLessonOutcomeStatus.mastered,
          ),
          currentLessonId: 'lesson.001',
        ),
      ),
    );

    expect(result.plan!.selectedLessonId, 'lesson.002');
    expect(result.plan!.planType, LessonPlanType.newLesson);
    expect(result.plan!.attemptPurpose, LessonAttemptPurpose.normal);
    expect(result.plan!.reasonCodes, [
      LessonPlanReasonCode.latestOutcomeMastered,
      LessonPlanReasonCode.nextLessonAfterMastery,
    ]);
    expect(result.plan!.sourceLessonId, 'lesson.001');
    expect(
      result.plan!.sourceOutcomeStatus,
      DurableLessonOutcomeStatus.mastered,
    );
    expect(result.plan!.sourceAttemptPurpose, LessonAttemptPurpose.normal);
  });

  test('fragile normal attempt selects one reinforcement repeat', () {
    final result = planner.plan(
      PlanningRequest(
        course: _course,
        learnerHistory: _historyWithAttempt(
          _attempt(
            attemptId: 'attempt.fragile',
            lessonId: 'lesson.001',
            outcomeStatus:
                DurableLessonOutcomeStatus.completedWithReinforcement,
          ),
          currentLessonId: 'lesson.001',
        ),
      ),
    );

    expect(result.plan!.selectedLessonId, 'lesson.001');
    expect(result.plan!.planType, LessonPlanType.reinforcementRepeat);
    expect(
      result.plan!.attemptPurpose,
      LessonAttemptPurpose.reinforcementRepeat,
    );
    expect(result.plan!.reasonCodes, [
      LessonPlanReasonCode.latestOutcomeNeedsReinforcement,
      LessonPlanReasonCode.immediateReinforcementRepeatSelected,
    ]);
  });

  test('fragile manual attempt starts a new reinforcement chain', () {
    final result = planner.plan(
      PlanningRequest(
        course: _course,
        learnerHistory: _historyWithAttempt(
          _attempt(
            attemptId: 'attempt.manual.fragile',
            lessonId: 'lesson.001',
            purpose: LessonAttemptPurpose.manualRepeat,
            outcomeStatus:
                DurableLessonOutcomeStatus.completedWithReinforcement,
          ),
          currentLessonId: 'lesson.001',
        ),
      ),
    );

    expect(result.plan!.selectedLessonId, 'lesson.001');
    expect(result.plan!.planType, LessonPlanType.reinforcementRepeat);
    expect(result.plan!.reasonCodes, [
      LessonPlanReasonCode.manualRepeatNeedsReinforcement,
      LessonPlanReasonCode.immediateReinforcementRepeatSelected,
    ]);
  });

  test('mastered reinforcement repeat selects next lesson', () {
    final result = planner.plan(
      PlanningRequest(
        course: _course,
        learnerHistory: _historyWithAttempt(
          _attempt(
            attemptId: 'attempt.reinforced.mastered',
            lessonId: 'lesson.001',
            purpose: LessonAttemptPurpose.reinforcementRepeat,
            outcomeStatus: DurableLessonOutcomeStatus.mastered,
          ),
          currentLessonId: 'lesson.001',
        ),
      ),
    );

    expect(result.plan!.selectedLessonId, 'lesson.002');
    expect(result.plan!.planType, LessonPlanType.newLesson);
    expect(result.plan!.reinforcementRecommended, isFalse);
    expect(result.plan!.reinforcementConsumed, isTrue);
    expect(result.plan!.reasonCodes, [
      LessonPlanReasonCode.reinforcementRepeatConsumedMastered,
      LessonPlanReasonCode.nextLessonAfterBoundedReinforcement,
    ]);
  });

  test('fragile reinforcement repeat advances without infinite loop', () {
    final history = _historyWithAttempt(
      _attempt(
        attemptId: 'attempt.reinforced.fragile',
        lessonId: 'lesson.001',
        purpose: LessonAttemptPurpose.reinforcementRepeat,
        outcomeStatus: DurableLessonOutcomeStatus.completedWithReinforcement,
      ),
      currentLessonId: 'lesson.001',
    );
    final request = PlanningRequest(course: _course, learnerHistory: history);

    final first = planner.plan(request).plan!;
    final second = planner.plan(request).plan!;

    for (final plan in [first, second]) {
      expect(plan.selectedLessonId, 'lesson.002');
      expect(plan.planType, LessonPlanType.newLesson);
      expect(plan.attemptPurpose, LessonAttemptPurpose.normal);
      expect(plan.reinforcementRecommended, isTrue);
      expect(plan.reinforcementConsumed, isTrue);
      expect(plan.reasonCodes, [
        LessonPlanReasonCode.reinforcementRepeatConsumedStillFragile,
        LessonPlanReasonCode.nextLessonAfterBoundedReinforcement,
      ]);
    }
  });

  test(
    'current incomplete lesson wins over earlier fragile durable history',
    () {
      final result = planner.plan(
        PlanningRequest(
          course: _course,
          learnerHistory: LearnerHistorySummary(
            completedLessonIds: const {'lesson.001'},
            currentLessonId: 'lesson.002',
            incompleteLessonIds: const {'lesson.002'},
            latestLessonAttemptsByLessonId: {
              'lesson.001': _attempt(
                attemptId: 'attempt.fragile.older',
                lessonId: 'lesson.001',
                outcomeStatus:
                    DurableLessonOutcomeStatus.completedWithReinforcement,
              ),
            },
          ),
        ),
      );

      expect(result.plan!.selectedLessonId, 'lesson.002');
      expect(result.plan!.planType, LessonPlanType.continueLesson);
    },
  );

  test('final fragile normal attempt receives one reinforcement repeat', () {
    final result = planner.plan(
      PlanningRequest(
        course: _course,
        learnerHistory: _historyWithAttempt(
          _attempt(
            attemptId: 'attempt.final.fragile',
            lessonId: 'lesson.003',
            outcomeStatus:
                DurableLessonOutcomeStatus.completedWithReinforcement,
          ),
          completedLessonIds: const {'lesson.001', 'lesson.002'},
          currentLessonId: 'lesson.003',
        ),
      ),
    );

    expect(result.plan!.selectedLessonId, 'lesson.003');
    expect(result.plan!.planType, LessonPlanType.reinforcementRepeat);
  });

  test(
    'final fragile reinforcement repeat completes course with recommendation',
    () {
      final result = planner.plan(
        PlanningRequest(
          course: _course,
          learnerHistory: _historyWithAttempt(
            _attempt(
              attemptId: 'attempt.final.reinforcement.fragile',
              lessonId: 'lesson.003',
              purpose: LessonAttemptPurpose.reinforcementRepeat,
              outcomeStatus:
                  DurableLessonOutcomeStatus.completedWithReinforcement,
            ),
            completedLessonIds: const {'lesson.001', 'lesson.002'},
            currentLessonId: 'lesson.003',
          ),
        ),
      );

      expect(result.plan!.selectedLessonId, 'lesson.003');
      expect(result.plan!.planType, LessonPlanType.courseComplete);
      expect(result.plan!.reinforcementRecommended, isTrue);
      expect(result.plan!.reasonCodes, [
        LessonPlanReasonCode.reinforcementRepeatConsumedStillFragile,
        LessonPlanReasonCode.finalReinforcementConsumedCourseComplete,
      ]);
    },
  );

  test('equal attempt timestamps use attempt id as stable tie-breaker', () {
    final completedAt = DateTime.utc(2026, 7);
    final result = planner.plan(
      PlanningRequest(
        course: _course,
        learnerHistory: LearnerHistorySummary(
          completedLessonIds: const {'lesson.001'},
          currentLessonId: 'lesson.001',
          lessonAttemptHistoryByLessonId: {
            'lesson.001': [
              _attempt(
                attemptId: 'attempt.a',
                lessonId: 'lesson.001',
                completedAt: completedAt,
                outcomeStatus: DurableLessonOutcomeStatus.mastered,
              ),
              _attempt(
                attemptId: 'attempt.z',
                lessonId: 'lesson.001',
                completedAt: completedAt,
                outcomeStatus:
                    DurableLessonOutcomeStatus.completedWithReinforcement,
              ),
            ],
          },
        ),
      ),
    );

    expect(result.plan!.selectedLessonId, 'lesson.001');
    expect(result.plan!.planType, LessonPlanType.reinforcementRepeat);
    expect(
      result.plan!.sourceOutcomeStatus,
      DurableLessonOutcomeStatus.completedWithReinforcement,
    );
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

LearnerHistorySummary _historyWithAttempt(
  LessonAttemptSummary attempt, {
  Set<String> completedLessonIds = const {},
  String? currentLessonId,
}) {
  final completed = <String>{...completedLessonIds, attempt.lessonId};
  return LearnerHistorySummary(
    completedLessonIds: Set.unmodifiable(completed),
    currentLessonId: currentLessonId,
    lessonAttemptHistoryByLessonId: {
      attempt.lessonId: [attempt],
    },
    latestLessonAttemptsByLessonId: {attempt.lessonId: attempt},
  );
}

LessonAttemptSummary _attempt({
  required String attemptId,
  required String lessonId,
  DurableLessonOutcomeStatus outcomeStatus =
      DurableLessonOutcomeStatus.mastered,
  LessonAttemptPurpose purpose = LessonAttemptPurpose.normal,
  DateTime? completedAt,
}) {
  return LessonAttemptSummary(
    attemptId: attemptId,
    lessonId: lessonId,
    courseId: _course.id,
    purpose: purpose,
    completedAt: completedAt ?? DateTime.utc(2026, 7),
    outcomeStatus: outcomeStatus,
    masteredStepCount: outcomeStatus == DurableLessonOutcomeStatus.mastered
        ? 1
        : 0,
    fragileStepCount:
        outcomeStatus == DurableLessonOutcomeStatus.completedWithReinforcement
        ? 1
        : 0,
    canonicalCheckableStepCount: 1,
    learningPolicyVersion: 'e20-v1',
  );
}

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
