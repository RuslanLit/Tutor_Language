import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/app/app.dart';
import 'package:tutor_language/app/router/app_router.dart';
import 'package:tutor_language/core/content/content_providers.dart';
import 'package:tutor_language/core/content/content_repository.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/database/database_provider.dart';
import 'package:tutor_language/core/learner/lesson_attempt.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/curriculum/curriculum_repository.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_assembly_service.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_content.dart';
import 'package:tutor_language/features/lesson_launch/lesson_launch_providers.dart';
import 'package:tutor_language/features/lesson_launch/lesson_launch_intent.dart';
import 'package:tutor_language/features/lesson_launch/lesson_launch_screen.dart';
import 'package:tutor_language/features/lesson_launch/lesson_launch_service.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_providers.dart';
import 'package:tutor_language/features/lesson_planning/learner_history_summary.dart';
import 'package:tutor_language/features/lesson_planning/lesson_plan.dart';
import 'package:tutor_language/features/lesson_planning/planning_request.dart';
import 'package:tutor_language/features/lesson_planning/rule_based_lesson_planner.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('LessonLaunchService invokes planner during lesson launch', () async {
    final planner = _RecordingPlanner(
      const LessonPlan(
        selectedLessonId: 'lesson.planned',
        planType: LessonPlanType.newLesson,
        reasonCodes: [LessonPlanReasonCode.noHistorySelectFirstLesson],
        diagnosticExplanation: 'Selected by test planner.',
      ),
    );
    final service = LessonLaunchService(
      curriculumRepository: _FakeCurriculumRepository(_course),
      planner: planner,
      learnerHistorySummary: () async =>
          const LearnerHistorySummary(completedLessonIds: {'lesson.previous'}),
    );

    final plan = await service.planNextLesson();

    expect(planner.wasInvoked, isTrue);
    expect(planner.requestedCourseId, _course.id);
    expect(planner.requestedCompletedLessonIds, {'lesson.previous'});
    expect(plan.selectedLessonId, 'lesson.planned');
  });

  test('LessonLaunchIntent executes explicit plan attempt purpose', () {
    const normalPlan = LessonPlan(
      selectedLessonId: 'lesson.normal',
      planType: LessonPlanType.newLesson,
      reasonCodes: [LessonPlanReasonCode.noHistorySelectFirstLesson],
      diagnosticExplanation: 'Normal launch.',
    );
    const reinforcementPlan = LessonPlan(
      selectedLessonId: 'lesson.repeat',
      planType: LessonPlanType.reinforcementRepeat,
      reasonCodes: [LessonPlanReasonCode.lowAccuracyRepeatCurrent],
      diagnosticExplanation: 'Reinforcement launch.',
      attemptPurpose: LessonAttemptPurpose.reinforcementRepeat,
    );

    expect(
      LessonLaunchIntent.fromPlan(normalPlan).attemptPurpose,
      LessonAttemptPurpose.normal,
    );
    expect(
      LessonLaunchIntent.fromPlan(reinforcementPlan).attemptPurpose,
      LessonAttemptPurpose.reinforcementRepeat,
    );
  });

  testWidgets('course complete plan renders completion action', (tester) async {
    await tester.pumpWidget(
      _app(
        launchService: _FakeLessonLaunchService(
          const LessonPlan(
            selectedLessonId: 'lesson.final',
            planType: LessonPlanType.courseComplete,
            reasonCodes: [
              LessonPlanReasonCode.finalLessonMasteredCourseComplete,
            ],
            diagnosticExplanation: 'Course complete.',
          ),
        ),
        assemblyService: _RecordingLessonAssemblyService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Course complete'), findsOneWidget);
    expect(find.text('Back to course'), findsOneWidget);
  });

  testWidgets(
    'LessonPlan selectedLessonId reaches LessonAssemblyService and renders',
    (tester) async {
      final assemblyService = _RecordingLessonAssemblyService();

      await tester.pumpWidget(
        _app(
          launchService: _FakeLessonLaunchService(
            const LessonPlan(
              selectedLessonId: 'lesson.selected.by.plan',
              planType: LessonPlanType.newLesson,
              reasonCodes: [LessonPlanReasonCode.noHistorySelectFirstLesson],
              diagnosticExplanation: 'Selected for launch.',
            ),
          ),
          assemblyService: assemblyService,
        ),
      );
      await tester.pumpAndSettle();

      expect(assemblyService.requestedLessonIds, ['lesson.selected.by.plan']);
      expect(find.text('Planner Selected Lesson'), findsOneWidget);
      expect(find.text('No activities available.'), findsOneWidget);
    },
  );

  testWidgets('Home course button opens course navigation', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentRepositoryProvider.overrideWith(
            (ref) => _FakeContentRepository(),
          ),
          appDatabaseProvider.overrideWith((ref) {
            final database = AppDatabase(NativeDatabase.memory());
            ref.onDispose(database.close);
            return database;
          }),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            final router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: supportedTutorLanguageLocales,
              localeListResolutionCallback: resolveTutorLanguageLocale,
              theme: ThemeData(useMaterial3: false),
              routerConfig: router,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open course'));
    await tester.pumpAndSettle();

    expect(find.text('Test Module'), findsOneWidget);
    expect(find.text('Test Lesson'), findsOneWidget);
  });

  testWidgets('planner failure produces graceful launch error', (tester) async {
    await tester.pumpWidget(
      _app(
        launchService: _FailingLessonLaunchService(
          const LessonLaunchException('Course has no usable lessons.'),
        ),
        assemblyService: _RecordingLessonAssemblyService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Unable to launch lesson.'), findsOneWidget);
    expect(
      find.textContaining('Course has no usable lessons.'),
      findsOneWidget,
    );
    expect(find.textContaining('Exception'), findsNothing);
  });

  test('LessonPlayer remains planner-independent', () {
    final source = [
      File(
        'lib/features/lesson_player/lesson_player_screen.dart',
      ).readAsStringSync(),
      File(
        'lib/features/lesson_player/lesson_player_providers.dart',
      ).readAsStringSync(),
    ].join('\n');

    expect(source, isNot(contains('RuleBasedLessonPlanner')));
    expect(source, isNot(contains('PlanningRequest')));
    expect(source, isNot(contains('lesson_planning')));
  });

  test('LessonAssemblyService remains planner-independent', () {
    final source = File(
      'lib/features/lesson_assembly/lesson_assembly_service.dart',
    ).readAsStringSync();

    expect(source, isNot(contains('RuleBasedLessonPlanner')));
    expect(source, isNot(contains('PlanningRequest')));
    expect(source, isNot(contains('LessonPlan')));
    expect(source, isNot(contains('lesson_planning')));
  });

  test('new launch path does not contain the previous hardcoded lesson id', () {
    final source = [
      File('lib/features/home/home_screen.dart').readAsStringSync(),
      File(
        'lib/features/lesson_launch/lesson_launch_screen.dart',
      ).readAsStringSync(),
      File(
        'lib/features/lesson_launch/lesson_launch_service.dart',
      ).readAsStringSync(),
      File(
        'lib/features/lesson_launch/lesson_launch_providers.dart',
      ).readAsStringSync(),
    ].join('\n');

    expect(source, isNot(contains('es.a0.m01.l001')));
  });
}

Widget _app({
  required LessonLaunchService launchService,
  required LessonAssemblyService assemblyService,
}) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWith((ref) {
        final database = AppDatabase(NativeDatabase.memory());
        ref.onDispose(database.close);
        return database;
      }),
      lessonLaunchServiceProvider.overrideWith((ref) => launchService),
      lessonAssemblyServiceProvider.overrideWith((ref) => assemblyService),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: supportedTutorLanguageLocales,
      localeListResolutionCallback: resolveTutorLanguageLocale,
      theme: ThemeData(useMaterial3: false),
      home: const LessonLaunchScreen(),
    ),
  );
}

class _RecordingPlanner extends RuleBasedLessonPlanner {
  _RecordingPlanner(this.selectedPlan);

  final LessonPlan selectedPlan;
  bool wasInvoked = false;
  String? requestedCourseId;
  Set<String>? requestedCompletedLessonIds;

  @override
  LessonPlanningResult plan(PlanningRequest request) {
    wasInvoked = true;
    requestedCourseId = request.course.id;
    requestedCompletedLessonIds = request.learnerHistory.completedLessonIds;
    return LessonPlanningResult.success(selectedPlan);
  }
}

class _FakeLessonLaunchService extends LessonLaunchService {
  _FakeLessonLaunchService(this.plan)
    : super(
        curriculumRepository: _FailingCurriculumRepository(),
        planner: const RuleBasedLessonPlanner(),
        learnerHistorySummary: () async => const LearnerHistorySummary(),
      );

  final LessonPlan plan;

  @override
  Future<LessonPlan> planNextLesson() async {
    return plan;
  }
}

class _FailingLessonLaunchService extends LessonLaunchService {
  _FailingLessonLaunchService(this.error)
    : super(
        curriculumRepository: _FailingCurriculumRepository(),
        planner: const RuleBasedLessonPlanner(),
        learnerHistorySummary: () async => const LearnerHistorySummary(),
      );

  final Object error;

  @override
  Future<LessonPlan> planNextLesson() async {
    throw error;
  }
}

class _FakeContentRepository extends ContentRepository {
  @override
  Future<LanguagePackDisplay> loadCurrentLanguage() async {
    return const LanguagePackDisplay(id: 'language.test', name: 'Test');
  }

  @override
  Future<Course> loadCourse() async {
    return _course;
  }
}

class _FakeCurriculumRepository extends CurriculumRepository {
  _FakeCurriculumRepository(this.course);

  final Course course;

  @override
  Future<Course> loadCourse() async {
    return course;
  }
}

class _FailingCurriculumRepository extends CurriculumRepository {
  @override
  Future<Course> loadCourse() async {
    throw StateError('Unexpected curriculum load');
  }
}

class _RecordingLessonAssemblyService extends LessonAssemblyService {
  final requestedLessonIds = <String>[];

  @override
  Future<LessonContent> assembleLesson(String lessonId) async {
    requestedLessonIds.add(lessonId);
    return _selectedLessonContent(lessonId);
  }
}

LessonContent _selectedLessonContent(String lessonId) {
  final section = LessonSection(
    id: '$lessonId.section',
    title: 'Planner Selected Section',
    order: 1,
    activities: const [],
  );

  return LessonContent(
    lesson: Lesson(
      metadata: LessonMetadata(
        id: lessonId,
        title: 'Planner Selected Lesson',
        moduleId: 'module.test',
        courseId: _course.id,
        estimatedDurationMinutes: 10,
        difficulty: 'A0',
        tags: const [],
        version: '1.0.0',
        prerequisites: const [],
      ),
      objectives: const [
        LessonObjective(
          id: 'objective.test',
          description: 'Render the planner-selected lesson.',
        ),
      ],
      sections: [section],
      summary: const LessonSummary(
        id: 'summary.test',
        reviewPrompt: 'Review.',
        referenceIds: ['objective.test'],
      ),
      completionCriteria: const LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
      references: const [],
    ),
    sections: [LessonContentSection(section: section, activities: const [])],
  );
}

const _course = Course(
  id: 'course.test',
  languageId: 'language.test',
  title: 'Test Course',
  level: 'A0',
  version: '1.0.0',
  modules: [
    Module(id: 'module.test', title: 'Test Module', lessonIds: ['lesson.test']),
  ],
  lessons: [
    Lesson(
      metadata: LessonMetadata(
        id: 'lesson.test',
        title: 'Test Lesson',
        moduleId: 'module.test',
        courseId: 'course.test',
        estimatedDurationMinutes: 10,
        difficulty: 'A0',
        tags: [],
        version: '1.0.0',
        prerequisites: [],
      ),
      objectives: [
        LessonObjective(id: 'objective.test', description: 'Select a lesson.'),
      ],
      sections: [
        LessonSection(
          id: 'section.test',
          title: 'Test Section',
          order: 1,
          activities: [],
        ),
      ],
      summary: LessonSummary(
        id: 'summary.test',
        reviewPrompt: 'Review.',
        referenceIds: ['objective.test'],
      ),
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
      references: [],
    ),
  ],
);
