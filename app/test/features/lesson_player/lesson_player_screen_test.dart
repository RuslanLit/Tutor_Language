import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_language/app/router/app_router.dart';
import 'package:tutor_language/core/content/content_localization.dart';
import 'package:tutor_language/core/content/content_localization_providers.dart';
import 'package:tutor_language/core/content/content_providers.dart';
import 'package:tutor_language/core/content/content_repository.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/database/database_provider.dart';
import 'package:tutor_language/core/learner/lesson_attempt.dart';
import 'package:tutor_language/core/learner/learner_progress.dart';
import 'package:tutor_language/core/learner/learner_progress_providers.dart';
import 'package:tutor_language/core/learner/learner_progress_repository.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/course_navigation/course_navigation_models.dart';
import 'package:tutor_language/features/course_navigation/course_navigation_providers.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_assembly_service.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_content.dart';
import 'package:tutor_language/features/lesson_launch/lesson_launch_intent.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_providers.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_screen.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

final _emptyLocalizationOverride = educationalContentLocalizationBundleProvider
    .overrideWith((ref) async => _emptyLocalizationBundle);

const _emptyLocalizationBundle = EducationalContentLocalizationBundle(
  schemaVersion: 1,
  targetLanguage: 'es',
  sourceSupportLocale: 'en',
  supportLocales: ['en'],
  entries: [],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('loads and renders the reference assembled lesson', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const LessonPlayerScreen(lessonId: _lessonId)),
    );
    await _pumpUntilFound(tester, find.text('Hello and Goodbye'));

    expect(find.text('Hello and Goodbye'), findsOneWidget);
    expect(find.text('Module 1'), findsOneWidget);
    expect(find.text('A0'), findsOneWidget);
    expect(find.text('es.a0.m01.l001'), findsNothing);
    expect(find.text('es.a0.m01'), findsNothing);
    expect(find.text('es.a0'), findsNothing);
    expect(find.text('vocabulary'), findsWidgets);
    expect(find.text('hola'), findsWidgets);
    expect(find.text('grammar'), findsNothing);
    expect(find.text('Greeting Exchange'), findsNothing);
  });

  testWidgets('displays canonical course position for moved legacy lesson id', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'es.a0.m06.l016'),
        service: _FakeLessonAssemblyService(_legacyMovedLessonContent),
        orderedLessons: [_legacyMovedOrderedLesson],
      ),
    );
    await _pumpUntilFound(
      tester,
      find.text('Spanish Vowels, h, and First Sounds'),
    );
    await _pumpUntilFound(tester, find.text('Lesson 1'));

    expect(find.text('Spanish Vowels, h, and First Sounds'), findsOneWidget);
    expect(find.text('Module 1'), findsOneWidget);
    expect(find.text('Lesson 1'), findsOneWidget);
    expect(find.text('Lesson 16'), findsNothing);
  });

  testWidgets(
    'renders assembled lesson data without hardcoded lesson strings',
    (tester) async {
      await tester.pumpWidget(
        _app(
          const LessonPlayerScreen(lessonId: 'lesson.dynamic'),
          service: _FakeLessonAssemblyService(_dynamicLessonContent),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dynamic Lesson Title'), findsOneWidget);
      expect(find.text('lexema-dinamico'), findsOneWidget);
      expect(find.text('Step 1 / 5'), findsOneWidget);

      await tester.ensureVisible(find.text('Next →'));
      await tester.tap(find.text('Next →'));
      await tester.pump();

      expect(find.text('Dynamic grammar explanation.'), findsOneWidget);
      expect(find.text('lexema-dinamico'), findsNothing);

      await tester.ensureVisible(find.text('Next →'));
      await tester.tap(find.text('Next →'));
      await tester.pump();

      expect(find.text('Dynamic speaker'), findsOneWidget);

      await tester.ensureVisible(find.text('Next →'));
      await tester.tap(find.text('Next →'));
      await tester.pump();

      expect(find.text('Dynamic reading text.'), findsOneWidget);

      await tester.ensureVisible(find.text('Next →'));
      await tester.tap(find.text('Next →'));
      await tester.pump();

      expect(find.text('Dynamic prompt?'), findsOneWidget);
      expect(find.text('Hello and Goodbye'), findsNothing);
    },
  );

  testWidgets('shows error state for an invalid lesson id', (tester) async {
    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'missing.lesson'),
        service: _FailingLessonAssemblyService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Unable to load course content.'),
      findsOneWidget,
    );
    expect(find.textContaining('missing.lesson'), findsOneWidget);
  });

  testWidgets('wrong practice answer shows incorrect feedback', (tester) async {
    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'lesson.interactive'),
        service: _FakeLessonAssemblyService(_interactiveLessonContent),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Finish Lesson'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
    await tester.tap(find.text('wrong option'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('correct practice answer shows correct feedback', (tester) async {
    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'lesson.interactive'),
        service: _FakeLessonAssemblyService(_interactiveLessonContent),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('right option'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
    expect(find.text('Mastered'), findsOneWidget);
  });

  testWidgets('practice controls remain reachable in landscape viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2260, 1080);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'lesson.interactive'),
        service: _FakeLessonAssemblyService(_interactiveLessonContent),
      ),
    );
    await tester.pumpAndSettle();

    final checkRect = tester.getRect(
      find.widgetWithText(OutlinedButton, 'Check'),
    );
    expect(checkRect.bottom, lessThanOrEqualTo(1080));

    await tester.tap(find.text('right option'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
  });

  testWidgets('accepted-with-correction answer can advance', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'lesson.accepted_feedback'),
        service: _FakeLessonAssemblyService(_acceptedFeedbackLessonContent),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'que');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Accepted with correction'), findsOneWidget);
    expect(find.text('Recommended answer: qué'), findsOneWidget);
    expect(
      find.text('Good work. This needs a little more practice.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next →'))
          .onPressed,
      isNotNull,
    );

    final nextButton = find.widgetWithText(FilledButton, 'Next →');
    await tester.ensureVisible(nextButton);
    await tester.tap(nextButton);
    await tester.pump();

    expect(find.text('Step 2 / 2'), findsOneWidget);
    expect(find.text('Accepted Vocabulary'), findsOneWidget);

    await tester.ensureVisible(find.text('Finish Lesson'));
    await tester.tap(find.text('Finish Lesson'));
    await _pumpUntilFound(
      tester,
      find.text('Some topics will need reinforcement.'),
    );

    expect(find.text('Some topics will need reinforcement.'), findsOneWidget);
  });

  testWidgets('repeated incorrect answer renders authored remediation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'lesson.remediation'),
        service: _FakeLessonAssemblyService(_remediationLessonContent),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Soy Ana');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Not correct yet'), findsNothing);
    expect(find.text('Recommended answer: Me llamo Ana'), findsNothing);
    expect(
      find.text('- For this introduction pattern, use "me llamo".'),
      findsNothing,
    );
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next →'))
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Not correct yet'), findsOneWidget);
    expect(find.text('Recommended answer: Me llamo Ana'), findsOneWidget);
    expect(
      find.text('- For this introduction pattern, use "me llamo".'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next →'))
          .onPressed,
      isNull,
    );

    await tester.enterText(find.byType(TextField), 'Me llamo Ana');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
    expect(find.text('Not correct yet'), findsNothing);
    expect(
      find.text('Good work. This needs a little more practice.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next →'))
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Mastered'), findsOneWidget);

    await tester.ensureVisible(find.text('Next →'));
    await tester.tap(find.text('Next →'));
    await tester.pumpAndSettle();

    expect(find.text('Step 2 / 2'), findsOneWidget);
    expect(find.text('Remediation Vocabulary'), findsOneWidget);
  });

  testWidgets('third incorrect answer inserts authored review step', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'lesson.review_insertion'),
        service: _FakeLessonAssemblyService(_reviewInsertionLessonContent),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Soy Ana');
    await tester.tap(find.text('Check'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Quick Review'), findsOneWidget);
    expect(find.text('Review Insertion Practice'), findsOneWidget);
    expect(
      find.text('Choose the best translation of "Me llamo Ana".'),
      findsOneWidget,
    );
    expect(find.text('Step 2 / 5'), findsOneWidget);
    expect(
      find.text('Type the Spanish introduction: "My name is Ana."'),
      findsNothing,
    );

    await tester.tap(find.text('My name is Ana'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);

    await tester.ensureVisible(find.text('Next →'));
    await tester.tap(find.text('Next →'));
    await tester.pump();

    expect(find.text('Step 3 / 5'), findsOneWidget);
    expect(
      find.text('Type the Spanish introduction: "My name is Ana."'),
      findsOneWidget,
    );
    expect(find.text('Soy Ana'), findsOneWidget);
    expect(find.text('Not correct yet'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Me llamo Ana');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
    expect(
      find.text('Good work. This needs a little more practice.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Next →'));
    await tester.pump();

    expect(find.text('Step 4 / 5'), findsOneWidget);
    expect(
      find.text('Choose the best translation of "Me llamo Ana".'),
      findsOneWidget,
    );
  });

  testWidgets('navigates previous and next without losing answers', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: _navigationLessonId),
        service: _FakeLessonAssemblyService(_navigationLessonContent),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Step 1 / 3'), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, '← Previous'),
          )
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next →'))
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('Next →'));
    await tester.pump();

    expect(find.text('Step 2 / 3'), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, '← Previous'),
          )
          .onPressed,
      isNotNull,
    );
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next →'))
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('wrong option'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Try again'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next →'))
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('← Previous'));
    await tester.pump();

    expect(find.text('Step 1 / 3'), findsOneWidget);
    expect(find.text('Navigation Vocabulary'), findsOneWidget);

    await tester.tap(find.text('Next →'));
    await tester.pump();

    expect(find.text('Step 2 / 3'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'wrong option'))
          .selected,
      isTrue,
    );
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next →'))
          .onPressed,
      isNull,
    );

    await tester.tap(find.text('right option'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next →'))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('resume restores position, answers, and feedback', (
    tester,
  ) async {
    var showLesson = true;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          _emptyLocalizationOverride,
          appDatabaseProvider.overrideWith((ref) {
            final database = AppDatabase(NativeDatabase.memory());
            ref.onDispose(database.close);
            return database;
          }),
          lessonAssemblyServiceProvider.overrideWith(
            (ref) => _FakeLessonAssemblyService(_navigationLessonContent),
          ),
        ],
        child: StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(useMaterial3: false),
              home: Scaffold(
                body: showLesson
                    ? const LessonPlayerScreen(lessonId: _navigationLessonId)
                    : const Text('Outside lesson'),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      showLesson = !showLesson;
                    });
                  },
                  child: const Text('Swap'),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next →'));
    await tester.pump();
    await tester.tap(find.text('wrong option'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Step 2 / 3'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);

    await tester.tap(find.text('Swap'));
    await tester.pump();

    expect(find.text('Outside lesson'), findsOneWidget);

    await tester.tap(find.text('Swap'));
    await tester.pumpAndSettle();

    expect(find.text('Step 2 / 3'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'wrong option'))
          .selected,
      isTrue,
    );
  });

  testWidgets('splits multiple templates into separate preserved steps', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'lesson.multi_template'),
        service: _FakeLessonAssemblyService(_multiTemplateLessonContent),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Step 1 / 2'), findsOneWidget);
    expect(find.text('Type the Spanish word for "hello".'), findsOneWidget);
    expect(find.text('Type the Spanish word for "goodbye".'), findsNothing);

    await tester.enterText(find.byType(TextField), 'hola');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next →'))
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('Next →'));
    await tester.pump();

    expect(find.text('Step 2 / 2'), findsOneWidget);
    expect(find.text('Type the Spanish word for "goodbye".'), findsOneWidget);
    expect(find.text('Type the Spanish word for "hello".'), findsNothing);

    await tester.enterText(find.byType(TextField), 'adiós');
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);

    await tester.tap(find.text('← Previous'));
    await tester.pump();

    expect(find.text('Step 1 / 2'), findsOneWidget);
    expect(find.text('hola'), findsOneWidget);
    expect(find.text('Correct'), findsOneWidget);

    await tester.tap(find.text('Next →'));
    await tester.pump();

    expect(find.text('Step 2 / 2'), findsOneWidget);
    expect(find.text('adiós'), findsOneWidget);
    expect(find.text('Correct'), findsOneWidget);
  });

  testWidgets(
    'finish lesson is available only after final activity completion',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);

      await tester.pumpWidget(
        _app(
          const LessonPlayerScreen(lessonId: _navigationLessonId),
          service: _FakeLessonAssemblyService(_navigationLessonContent),
          database: database,
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Next →'));
      await tester.tap(find.text('Next →'));
      await tester.pump();
      await tester.tap(find.text('right option'));
      await tester.pump();
      await tester.tap(find.text('Check'));
      await tester.pump();
      await tester.ensureVisible(find.text('Next →'));
      await tester.tap(find.text('Next →'));
      await tester.pump();

      expect(find.text('Step 3 / 3'), findsOneWidget);
      expect(find.text('Finish Lesson'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Finish Lesson'),
            )
            .onPressed,
        isNull,
      );

      await tester.enterText(find.byType(TextField), 'hola');
      await tester.tap(find.text('Check'));
      await tester.pump();

      expect(find.text('Correct'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Finish Lesson'),
            )
            .onPressed,
        isNotNull,
      );

      await tester.tap(find.text('Finish Lesson'));
      await tester.tap(find.text('Finish Lesson'), warnIfMissed: false);
      await _pumpUntilFound(tester, find.text('Lesson mastered'));

      expect(find.text('Finish Lesson'), findsNothing);
      expect(find.text('Lesson mastered'), findsOneWidget);

      final repository = LearnerProgressRepository(database);
      final attempts = await repository.getLessonAttempts(_navigationLessonId);
      final latest = await repository.getLatestLessonAttempt(
        _navigationLessonId,
      );
      final steps = await repository.getAttemptStepResults(latest!.attemptId);

      expect(attempts, hasLength(1));
      expect(latest.outcomeStatus, DurableLessonOutcomeStatus.mastered);
      expect(latest.courseId, 'es.a0');
      expect(latest.purpose, LessonAttemptPurpose.normal);
      expect(steps, hasLength(2));
    },
  );

  testWidgets('manual repeat launch persists manual purpose', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(
          lessonId: _navigationLessonId,
          attemptPurpose: LessonAttemptPurpose.manualRepeat,
        ),
        service: _FakeLessonAssemblyService(_navigationLessonContent),
        database: database,
      ),
    );
    await tester.pumpAndSettle();

    await _completeNavigationLesson(tester);
    await _pumpUntilFound(tester, find.text('Lesson mastered'));

    final repository = LearnerProgressRepository(database);
    final latest = await repository.getLatestLessonAttempt(_navigationLessonId);

    expect(latest?.purpose, LessonAttemptPurpose.manualRepeat);
  });

  testWidgets(
    'completed lesson screen offers repeat and continue without resetting progress',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = LearnerProgressRepository(database);
      await repository.recordEvent(
        ProgressEvent.create(
          eventType: ProgressEventType.lessonCompleted,
          topicId: _navigationLessonId,
          now: DateTime.utc(2026),
        ),
      );

      await tester.pumpWidget(
        _routerApp(
          initialLocation: '/lesson/$_navigationLessonId',
          service: _FakeLessonAssemblyService(_navigationLessonContent),
          database: database,
          completedProgress: true,
          nextOrderedLesson: _nextOrderedLesson,
        ),
      );
      await _pumpUntilFound(tester, find.text('Lesson completed'));
      await _pumpUntilFound(tester, find.text('Repeat lesson'));

      expect(find.text('Repeat lesson'), findsOneWidget);
      expect(find.text('Continue to next lesson'), findsOneWidget);

      await tester.ensureVisible(find.text('Repeat lesson'));
      await tester.tap(find.text('Repeat lesson'));
      await _pumpUntilFound(tester, find.text('Step 1 / 3'));

      expect(find.text('Navigation Vocabulary'), findsOneWidget);
      expect(find.text('Correct'), findsNothing);
      final progress = await repository.readTopicProgress(_navigationLessonId);
      expect(progress.hasBeenCompleted, isTrue);
    },
  );

  testWidgets('repeat completion creates a separate attempt history', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LearnerProgressRepository(database);

    await tester.pumpWidget(
      _routerApp(
        initialLocation: '/lesson/$_navigationLessonId',
        service: _FakeLessonAssemblyService(_navigationLessonContent),
        database: database,
        completedProgress: false,
        nextOrderedLesson: _nextOrderedLesson,
      ),
    );
    await tester.pumpAndSettle();

    await _completeNavigationLesson(tester);
    await _pumpUntilFound(tester, find.text('Lesson mastered'));

    final originalAttempts = await repository.getLessonAttempts(
      _navigationLessonId,
    );
    final originalAttemptId = originalAttempts.single.attemptId;
    final originalSteps = await repository.getAttemptStepResults(
      originalAttemptId,
    );

    await _pumpUntilFound(tester, find.text('Repeat lesson'));
    await tester.ensureVisible(find.text('Repeat lesson'));
    await tester.tap(find.text('Repeat lesson'));
    await _pumpUntilFound(tester, find.text('Step 1 / 3'));

    expect(find.text('Correct'), findsNothing);
    expect(find.text('right option'), findsNothing);

    await _completeNavigationLesson(tester);
    await _pumpUntilFound(tester, find.text('Lesson mastered'));

    final attempts = await repository.getLessonAttempts(_navigationLessonId);
    final completionEvents = await repository.readEventsForTopic(
      _navigationLessonId,
    );

    expect(attempts, hasLength(2));
    expect(attempts.map((attempt) => attempt.attemptId).toSet(), hasLength(2));
    expect(attempts.first.attemptId, originalAttemptId);
    expect(attempts.first.purpose, LessonAttemptPurpose.normal);
    expect(attempts.last.purpose, LessonAttemptPurpose.manualRepeat);
    expect(
      completionEvents
          .where(
            (event) => event.eventType == ProgressEventType.lessonCompleted,
          )
          .length,
      1,
    );
    expect(
      await repository.getAttemptStepResults(originalAttemptId),
      hasLength(originalSteps.length),
    );
  });

  testWidgets(
    'completed final lesson screen offers repeat and back to course',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _routerApp(
          initialLocation: '/lesson/es.a0.m05.l015',
          service: _FakeLessonAssemblyService(_finalCheckpointLessonContent),
        ),
      );
      await _pumpUntilFound(tester, find.text('Course complete'));

      expect(find.text('Repeat lesson'), findsOneWidget);
      expect(find.text('Back to course'), findsOneWidget);
    },
  );

  testWidgets('explicit reinforcement launch persists reinforcement purpose', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(
          lessonId: _navigationLessonId,
          attemptPurpose: LessonAttemptPurpose.reinforcementRepeat,
        ),
        service: _FakeLessonAssemblyService(_navigationLessonContent),
        database: database,
      ),
    );
    await tester.pumpAndSettle();

    await _completeNavigationLesson(tester);
    await _pumpUntilFound(tester, find.text('Lesson mastered'));

    final repository = LearnerProgressRepository(database);
    final latest = await repository.getLatestLessonAttempt(_navigationLessonId);

    expect(latest?.purpose, LessonAttemptPurpose.reinforcementRepeat);
  });

  testWidgets('does not crash when a lesson has no practice activities', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'lesson.no_practice'),
        service: _FakeLessonAssemblyService(_noPracticeLessonContent),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No Practice Lesson'), findsOneWidget);
    expect(find.text('Only Vocabulary'), findsOneWidget);
    expect(find.text('Check'), findsNothing);
  });

  testWidgets('final course completion exposes working actions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      _routerApp(
        initialLocation: '/lesson/es.a0.m05.l015',
        service: _FakeLessonAssemblyService(_finalCheckpointLessonContent),
      ),
    );
    await _pumpUntilFound(tester, find.text('Course complete'));

    expect(find.text('Course complete'), findsOneWidget);
    expect(find.text('Back to course'), findsOneWidget);
    expect(find.text('Review completed lessons'), findsOneWidget);
    expect(find.text('Repeat lesson'), findsOneWidget);

    await tester.ensureVisible(
      find.widgetWithText(OutlinedButton, 'Repeat lesson'),
    );
    await tester.tap(find.widgetWithText(OutlinedButton, 'Repeat lesson'));
    await _pumpUntilFound(tester, find.text('Final Vocabulary'));

    expect(find.text('Final Vocabulary'), findsOneWidget);
    expect(find.text('Course complete'), findsNothing);
  });

  testWidgets('visible back control returns completed lesson to course', (
    tester,
  ) async {
    await tester.pumpWidget(
      _routerApp(
        initialLocation: '/lesson/lesson.interactive',
        service: _FakeLessonAssemblyService(_interactiveLessonContent),
      ),
    );
    await _pumpUntilFound(tester, find.text('Interactive Practice'));

    expect(find.byTooltip('Back to course'), findsOneWidget);

    await tester.tap(find.byTooltip('Back to course'));
    await _pumpUntilFound(tester, find.text('Course route reached'));

    expect(find.text('Course route reached'), findsOneWidget);
  });

  testWidgets('back control confirms before leaving incomplete lesson', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      _routerApp(
        initialLocation: '/lesson/lesson.interactive',
        service: _FakeLessonAssemblyService(_interactiveLessonContent),
        database: database,
        completedProgress: false,
      ),
    );
    await _pumpUntilFound(tester, find.text('Interactive Practice'));

    await tester.tap(find.byTooltip('Back to course'));
    await tester.pumpAndSettle();

    expect(find.text('Leave lesson?'), findsOneWidget);
    expect(
      find.text('This unfinished lesson will restart when you open it again.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Stay'));
    await tester.pumpAndSettle();

    expect(find.text('Interactive Practice'), findsOneWidget);
    expect(find.text('Course route reached'), findsNothing);

    await tester.tap(find.byTooltip('Back to course'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave lesson'));
    await tester.pumpAndSettle();

    expect(find.text('Course route reached'), findsOneWidget);
    expect(await database.select(database.lessonAttempts).get(), isEmpty);
  });

  testWidgets('leaving incomplete lesson restarts ordinary session safely', (
    tester,
  ) async {
    await tester.pumpWidget(
      _routerApp(
        initialLocation: '/lesson/es.a0.m01.l001',
        service: _FakeLessonAssemblyService(_navigationLessonContent),
        completedProgress: false,
      ),
    );
    await _pumpUntilFound(tester, find.text('Step 1 / 3'));

    await tester.ensureVisible(find.text('Next →'));
    await tester.tap(find.text('Next →'));
    await tester.pump();

    expect(find.text('Step 2 / 3'), findsOneWidget);

    await tester.tap(find.byTooltip('Back to course'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave lesson'));
    await tester.pumpAndSettle();

    expect(find.text('Course route reached'), findsOneWidget);

    await tester.tap(find.text('Open test lesson'));
    await _pumpUntilFound(tester, find.text('Navigation Lesson'));

    expect(find.text('Step 1 / 3'), findsOneWidget);
  });
}

Widget _app(
  Widget child, {
  LessonAssemblyService? service,
  AppDatabase? database,
  SupportLocale? supportLocale,
  List<OrderedLesson>? orderedLessons,
}) {
  return ProviderScope(
    overrides: [
      if (supportLocale == null) _emptyLocalizationOverride,
      if (supportLocale != null)
        supportLocaleControllerProvider.overrideWith((ref) => supportLocale),
      appDatabaseProvider.overrideWith((ref) {
        final providedDatabase = database;
        if (providedDatabase != null) {
          return providedDatabase;
        }

        final createdDatabase = AppDatabase(NativeDatabase.memory());
        ref.onDispose(createdDatabase.close);
        return createdDatabase;
      }),
      if (service != null)
        lessonAssemblyServiceProvider.overrideWith((ref) => service),
      if (orderedLessons != null)
        orderedCourseLessonsProvider.overrideWith(
          (ref) async => orderedLessons,
        ),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(useMaterial3: false),
      home: child,
    ),
  );
}

Widget _routerApp({
  required String initialLocation,
  LessonAssemblyService? service,
  AppDatabase? database,
  bool completedProgress = true,
  OrderedLesson? nextOrderedLesson,
}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: CourseRoute.path,
        name: CourseRoute.name,
        builder: (context, state) => Scaffold(
          body: Column(
            children: [
              const Text('Course route reached'),
              FilledButton(
                onPressed: () {
                  context.goNamed(
                    LessonRoute.name,
                    pathParameters: {'lessonId': _navigationLessonId},
                  );
                },
                child: const Text('Open test lesson'),
              ),
            ],
          ),
        ),
      ),
      GoRoute(
        path: LessonRoute.path,
        name: LessonRoute.name,
        builder: (context, state) {
          final extra = state.extra;
          final intent = extra is LessonLaunchIntent ? extra : null;
          return LessonPlayerScreen(
            lessonId:
                intent?.lessonId ?? state.pathParameters['lessonId'] ?? '',
            attemptPurpose:
                intent?.attemptPurpose ?? LessonAttemptPurpose.normal,
          );
        },
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      _emptyLocalizationOverride,
      appDatabaseProvider.overrideWith((ref) {
        final providedDatabase = database;
        if (providedDatabase != null) {
          return providedDatabase;
        }

        final ownedDatabase = AppDatabase(NativeDatabase.memory());
        ref.onDispose(ownedDatabase.close);
        return ownedDatabase;
      }),
      contentRepositoryProvider.overrideWith(
        (ref) => _FinalCourseContentRepository(),
      ),
      topicProgressProvider.overrideWith(
        (ref, topicId) async => TopicProgress(
          topicId: topicId,
          completedAt: completedProgress ? DateTime.utc(2026) : null,
        ),
      ),
      nextOrderedLessonProvider.overrideWith(
        (ref, lessonId) async => nextOrderedLesson,
      ),
      if (service != null)
        lessonAssemblyServiceProvider.overrideWith((ref) => service),
    ],
    child: MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(useMaterial3: false),
      routerConfig: router,
    ),
  );
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 80; i += 1) {
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }

  expect(finder, findsOneWidget);
}

Future<void> _completeNavigationLesson(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Next →'));
  await tester.tap(find.text('Next →'));
  await tester.pump();
  await tester.tap(find.text('right option'));
  await tester.pump();
  await tester.tap(find.text('Check'));
  await tester.pump();
  await tester.ensureVisible(find.text('Next →'));
  await tester.tap(find.text('Next →'));
  await tester.pump();
  await tester.enterText(find.byType(TextField), 'hola');
  await tester.tap(find.text('Check'));
  await tester.pump();
  await tester.ensureVisible(find.text('Finish Lesson'));
  await tester.tap(find.text('Finish Lesson'));
}

class _FakeLessonAssemblyService extends LessonAssemblyService {
  _FakeLessonAssemblyService(this.lessonContent);

  final LessonContent lessonContent;

  @override
  Future<LessonContent> assembleLesson(String lessonId) async {
    return lessonContent;
  }
}

class _FailingLessonAssemblyService extends LessonAssemblyService {
  @override
  Future<LessonContent> assembleLesson(String lessonId) async {
    throw LessonAssemblyException('Lesson not found: $lessonId');
  }
}

class _FinalCourseContentRepository extends ContentRepository {
  @override
  Future<Course> loadCourse() async {
    return Course(
      id: 'course.final',
      languageId: 'spanish',
      title: 'Final Course',
      level: 'A0',
      version: '1.0.0',
      modules: const [
        Module(
          id: 'module.final',
          title: 'Final Module',
          lessonIds: ['es.a0.m05.l015'],
        ),
      ],
      lessons: [_finalCheckpointLessonContent.lesson],
    );
  }
}

const _lessonId = 'es.a0.m01.l001';

const _dynamicLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'lesson.dynamic',
      title: 'Dynamic Lesson Title',
      description: 'Dynamic lesson description.',
      moduleId: 'module.dynamic',
      courseId: 'course.dynamic',
      estimatedDurationMinutes: 12,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.dynamic',
        description: 'Render dynamic content.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.dynamic',
        title: 'Dynamic Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.dynamic.vocabulary',
            title: 'Dynamic Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.dynamic.grammar',
            title: 'Dynamic Grammar',
            type: 'grammar',
            order: 2,
          ),
          LessonActivity(
            id: 'activity.dynamic.dialogue',
            title: 'Dynamic Dialogue',
            type: 'dialogue',
            order: 3,
          ),
          LessonActivity(
            id: 'activity.dynamic.reading',
            title: 'Dynamic Reading',
            type: 'reading',
            order: 4,
          ),
          LessonActivity(
            id: 'activity.dynamic.practice',
            title: 'Dynamic Practice',
            type: 'exercise_template',
            order: 5,
          ),
        ],
      ),
    ],
    completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
    references: [],
  ),
  sections: [
    LessonContentSection(
      section: LessonSection(
        id: 'section.dynamic',
        title: 'Dynamic Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.dynamic.vocabulary',
            title: 'Dynamic Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.dynamic.grammar',
            title: 'Dynamic Grammar',
            type: 'grammar',
            order: 2,
          ),
          LessonActivity(
            id: 'activity.dynamic.dialogue',
            title: 'Dynamic Dialogue',
            type: 'dialogue',
            order: 3,
          ),
          LessonActivity(
            id: 'activity.dynamic.reading',
            title: 'Dynamic Reading',
            type: 'reading',
            order: 4,
          ),
          LessonActivity(
            id: 'activity.dynamic.practice',
            title: 'Dynamic Practice',
            type: 'exercise_template',
            order: 5,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.dynamic.vocabulary',
            title: 'Dynamic Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          resolvedContent: [
            VocabularyItem(
              id: 'vocab.dynamic',
              spanish: 'lexema-dinamico',
              nativeTranslation: 'dynamic word',
              cefr: 'A0',
              example: 'Dynamic example.',
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.dynamic.grammar',
            title: 'Dynamic Grammar',
            type: 'grammar',
            order: 2,
          ),
          resolvedContent: [
            GrammarTopic(
              id: 'grammar.dynamic',
              title: 'Dynamic Grammar Topic',
              explanation: 'Dynamic grammar explanation.',
              examples: ['Dynamic grammar example.'],
              prerequisiteIds: [],
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.dynamic.dialogue',
            title: 'Dynamic Dialogue',
            type: 'dialogue',
            order: 3,
          ),
          resolvedContent: [
            Dialogue(
              id: 'dialogue.dynamic',
              title: 'Dynamic Dialogue Title',
              vocabularyIds: [],
              grammarIds: [],
              lines: [
                DialogueLine(
                  speaker: 'Dynamic speaker',
                  spanish: 'Dynamic line.',
                  nativeTranslation: 'Dynamic translation.',
                ),
              ],
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.dynamic.reading',
            title: 'Dynamic Reading',
            type: 'reading',
            order: 4,
          ),
          resolvedContent: [
            ReadingText(
              id: 'reading.dynamic',
              title: 'Dynamic Reading Title',
              vocabularyIds: [],
              grammarIds: [],
              text: 'Dynamic reading text.',
              nativeTranslation: 'Dynamic reading translation.',
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.dynamic.practice',
            title: 'Dynamic Practice',
            type: 'exercise_template',
            order: 5,
          ),
          resolvedContent: [
            ExerciseTemplate(
              id: 'template.dynamic',
              exerciseType: 'multiple_choice',
              supportedGoalTypes: ['dynamic_goal'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Dynamic prompt?',
              answerOptions: [
                ExerciseTemplateOption(id: 'option.dynamic', label: 'Dynamic'),
              ],
              correctOptionId: 'option.dynamic',
            ),
          ],
        ),
      ],
    ),
  ],
);

const _interactiveLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'lesson.interactive',
      title: 'Interactive Lesson',
      description: 'Interactive lesson description.',
      moduleId: 'module.interactive',
      courseId: 'course.interactive',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.interactive',
        description: 'Check local practice feedback.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.interactive',
        title: 'Interactive Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.interactive.practice',
            title: 'Interactive Practice',
            type: 'exercise_template',
            order: 1,
          ),
        ],
      ),
    ],
    completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
    references: [],
  ),
  sections: [
    LessonContentSection(
      section: LessonSection(
        id: 'section.interactive',
        title: 'Interactive Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.interactive.practice',
            title: 'Interactive Practice',
            type: 'exercise_template',
            order: 1,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.interactive.practice',
            title: 'Interactive Practice',
            type: 'exercise_template',
            order: 1,
          ),
          resolvedContent: [
            ExerciseTemplate(
              id: 'template.interactive.choice',
              exerciseType: 'multiple_choice',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Choose the right option.',
              answerOptions: [
                ExerciseTemplateOption(
                  id: 'option.wrong',
                  label: 'wrong option',
                ),
                ExerciseTemplateOption(
                  id: 'option.right',
                  label: 'right option',
                ),
              ],
              correctOptionId: 'option.right',
            ),
          ],
        ),
      ],
    ),
  ],
);

const _acceptedFeedbackLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'lesson.accepted_feedback',
      title: 'Accepted Feedback Lesson',
      description: 'Accepted feedback lesson description.',
      moduleId: 'module.accepted_feedback',
      courseId: 'course.accepted_feedback',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.accepted_feedback',
        description: 'Check accepted-with-correction progression.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.accepted_feedback',
        title: 'Accepted Feedback Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.accepted_feedback.text',
            title: 'Accepted Text',
            type: 'exercise_template',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.accepted_feedback.vocabulary',
            title: 'Accepted Vocabulary',
            type: 'vocabulary',
            order: 2,
          ),
        ],
      ),
    ],
    completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
    references: [],
  ),
  sections: [
    LessonContentSection(
      section: LessonSection(
        id: 'section.accepted_feedback',
        title: 'Accepted Feedback Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.accepted_feedback.text',
            title: 'Accepted Text',
            type: 'exercise_template',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.accepted_feedback.vocabulary',
            title: 'Accepted Vocabulary',
            type: 'vocabulary',
            order: 2,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.accepted_feedback.text',
            title: 'Accepted Text',
            type: 'exercise_template',
            order: 1,
          ),
          resolvedContent: [
            ExerciseTemplate(
              id: 'template.accepted_feedback.text',
              exerciseType: 'text_entry',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Type the Spanish question word for "what".',
              expectedAnswer: 'qué',
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.accepted_feedback.vocabulary',
            title: 'Accepted Vocabulary',
            type: 'vocabulary',
            order: 2,
          ),
          resolvedContent: [
            VocabularyItem(
              id: 'vocab.accepted_feedback',
              spanish: 'qué',
              nativeTranslation: 'what',
              cefr: 'A0',
              example: '¿Qué tal?',
            ),
          ],
        ),
      ],
    ),
  ],
);

const _remediationLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'lesson.remediation',
      title: 'Remediation Lesson',
      description: 'Remediation lesson description.',
      moduleId: 'module.remediation',
      courseId: 'course.remediation',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.remediation',
        description: 'Check authored remediation after repeated mistakes.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.remediation',
        title: 'Remediation Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.remediation.text',
            title: 'Remediation Recall',
            type: 'exercise_template',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.remediation.vocabulary',
            title: 'Remediation Vocabulary',
            type: 'vocabulary',
            order: 2,
          ),
        ],
      ),
    ],
    completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
    references: [],
  ),
  sections: [
    LessonContentSection(
      section: LessonSection(
        id: 'section.remediation',
        title: 'Remediation Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.remediation.text',
            title: 'Remediation Recall',
            type: 'exercise_template',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.remediation.vocabulary',
            title: 'Remediation Vocabulary',
            type: 'vocabulary',
            order: 2,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.remediation.text',
            title: 'Remediation Recall',
            type: 'exercise_template',
            order: 1,
          ),
          resolvedContent: [
            ExerciseTemplate(
              id: 'template.remediation.name',
              exerciseType: 'text_entry',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Type the Spanish pattern for "My name is Ana."',
              expectedAnswer: 'Me llamo Ana',
              authoredMisconceptions: [
                AuthoredMisconception(
                  id: 'misconception.remediation.soy_ana.v1',
                  matchingAnswers: ['Soy Ana'],
                  feedbackKey: 'spanish.name_pattern.use_me_llamo',
                  canonicalAnswer: 'Me llamo Ana',
                  explanationReferenceId: 'grammar.name_pattern',
                ),
              ],
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.remediation.vocabulary',
            title: 'Remediation Vocabulary',
            type: 'vocabulary',
            order: 2,
          ),
          resolvedContent: [
            VocabularyItem(
              id: 'vocab.remediation',
              spanish: 'Me llamo Ana.',
              nativeTranslation: 'My name is Ana.',
              cefr: 'A0',
              example: 'Me llamo Ana.',
            ),
          ],
        ),
      ],
    ),
  ],
);

const _reviewInsertionLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'lesson.review_insertion',
      title: 'Review Insertion Lesson',
      description: 'Review insertion lesson description.',
      moduleId: 'module.review_insertion',
      courseId: 'course.review_insertion',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.review_insertion',
        description: 'Check authored review insertion.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.review_insertion',
        title: 'Review Insertion Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.review_insertion.practice',
            title: 'Review Insertion Practice',
            type: 'exercise_template',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.review_insertion.vocabulary',
            title: 'Review Insertion Vocabulary',
            type: 'vocabulary',
            order: 2,
          ),
        ],
      ),
    ],
    completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
    references: [],
  ),
  sections: [
    LessonContentSection(
      section: LessonSection(
        id: 'section.review_insertion',
        title: 'Review Insertion Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.review_insertion.practice',
            title: 'Review Insertion Practice',
            type: 'exercise_template',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.review_insertion.vocabulary',
            title: 'Review Insertion Vocabulary',
            type: 'vocabulary',
            order: 2,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.review_insertion.practice',
            title: 'Review Insertion Practice',
            type: 'exercise_template',
            order: 1,
          ),
          resolvedContent: [
            ExerciseTemplate(
              id: 'template.review_insertion.name',
              exerciseType: 'text_entry',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate:
                  'Type the Spanish introduction: "My name is Ana."',
              expectedAnswer: 'Me llamo Ana',
              authoredMisconceptions: [
                AuthoredMisconception(
                  id: 'misconception.review_insertion.soy_ana.v1',
                  matchingAnswers: ['Soy Ana'],
                  feedbackKey: 'spanish.name_pattern.use_me_llamo',
                  canonicalAnswer: 'Me llamo Ana',
                  explanationReferenceId: 'grammar.name_pattern',
                ),
              ],
              reviewTemplateIds: ['template.review_insertion.name_choice'],
            ),
            ExerciseTemplate(
              id: 'template.review_insertion.name_choice',
              exerciseType: 'multiple_choice',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Choose the best translation of "Me llamo Ana".',
              answerOptions: [
                ExerciseTemplateOption(
                  id: 'option.name',
                  label: 'My name is Ana',
                ),
                ExerciseTemplateOption(
                  id: 'option.from',
                  label: 'I am from Ana',
                ),
              ],
              correctOptionId: 'option.name',
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.review_insertion.vocabulary',
            title: 'Review Insertion Vocabulary',
            type: 'vocabulary',
            order: 2,
          ),
          resolvedContent: [
            VocabularyItem(
              id: 'vocab.review_insertion',
              spanish: 'Me llamo Ana.',
              nativeTranslation: 'My name is Ana.',
              cefr: 'A0',
              example: 'Me llamo Ana.',
            ),
          ],
        ),
      ],
    ),
  ],
);

const _navigationLessonId = 'es.a0.m01.l001';

const _legacyMovedLesson = Lesson(
  metadata: LessonMetadata(
    id: 'es.a0.m06.l016',
    title: 'Spanish Vowels, h, and First Sounds',
    description: 'Reading foundation.',
    moduleId: 'es.a0.m01',
    courseId: 'es.a0',
    estimatedDurationMinutes: 5,
    difficulty: 'A0',
    tags: [],
    version: '1.0.0',
    prerequisites: [],
  ),
  objectives: [
    LessonObjective(
      id: 'objective.legacy.position',
      description: 'Show canonical position.',
    ),
  ],
  sections: [],
  completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 0),
  references: [],
);

const _legacyMovedLessonContent = LessonContent(
  lesson: _legacyMovedLesson,
  sections: [],
);

const _legacyMovedOrderedLesson = OrderedLesson(
  lesson: _legacyMovedLesson,
  unit: Module(
    id: 'es.a0.m01',
    title: 'Navigation Module',
    lessonIds: ['es.a0.m06.l016'],
  ),
  position: LessonPosition(
    indexInCourse: 1,
    totalLessons: 70,
    indexInModule: 1,
    totalInModule: 7,
  ),
);

const _nextOrderedLesson = OrderedLesson(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'es.a0.m01.l002',
      title: 'Next Navigation Lesson',
      description: 'Next lesson description.',
      moduleId: 'es.a0.m01',
      courseId: 'es.a0',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.next.navigation',
        description: 'Continue after a completed lesson.',
      ),
    ],
    sections: [],
    completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
    references: [],
  ),
  unit: Module(
    id: 'es.a0.m01',
    title: 'Navigation Module',
    lessonIds: [_navigationLessonId, 'es.a0.m01.l002'],
  ),
  position: LessonPosition(
    indexInCourse: 2,
    totalLessons: 2,
    indexInModule: 2,
    totalInModule: 2,
  ),
);

const _navigationLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: _navigationLessonId,
      title: 'Navigation Lesson',
      description: 'Navigation lesson description.',
      moduleId: 'es.a0.m01',
      courseId: 'es.a0',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.navigation',
        description: 'Exercise deterministic lesson navigation.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.navigation',
        title: 'Navigation Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.navigation.vocabulary',
            title: 'Navigation Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.navigation.choice',
            title: 'Navigation Choice',
            type: 'exercise_template',
            order: 2,
          ),
          LessonActivity(
            id: 'activity.navigation.text',
            title: 'Navigation Text',
            type: 'exercise_template',
            order: 3,
          ),
        ],
      ),
    ],
    completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
    references: [],
  ),
  sections: [
    LessonContentSection(
      section: LessonSection(
        id: 'section.navigation',
        title: 'Navigation Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.navigation.vocabulary',
            title: 'Navigation Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.navigation.choice',
            title: 'Navigation Choice',
            type: 'exercise_template',
            order: 2,
          ),
          LessonActivity(
            id: 'activity.navigation.text',
            title: 'Navigation Text',
            type: 'exercise_template',
            order: 3,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.navigation.vocabulary',
            title: 'Navigation Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          resolvedContent: [
            VocabularyItem(
              id: 'vocab.navigation',
              spanish: 'hola',
              nativeTranslation: 'hello',
              cefr: 'A0',
              example: 'Hola.',
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.navigation.choice',
            title: 'Navigation Choice',
            type: 'exercise_template',
            order: 2,
          ),
          resolvedContent: [
            ExerciseTemplate(
              id: 'template.navigation.choice',
              exerciseType: 'multiple_choice',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Choose the right option.',
              answerOptions: [
                ExerciseTemplateOption(
                  id: 'option.wrong',
                  label: 'wrong option',
                ),
                ExerciseTemplateOption(
                  id: 'option.right',
                  label: 'right option',
                ),
              ],
              correctOptionId: 'option.right',
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.navigation.text',
            title: 'Navigation Text',
            type: 'exercise_template',
            order: 3,
          ),
          resolvedContent: [
            ExerciseTemplate(
              id: 'template.navigation.text',
              exerciseType: 'text_entry',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Type the greeting.',
              expectedAnswer: 'hola',
            ),
          ],
        ),
      ],
    ),
  ],
);

const _multiTemplateLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'lesson.multi_template',
      title: 'Multi-template Lesson',
      description: 'Multi-template lesson description.',
      moduleId: 'module.multi_template',
      courseId: 'course.multi_template',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.multi_template',
        description: 'Exercise template-level navigation.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.multi_template',
        title: 'Multi-template Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.multi_template.practice',
            title: 'Multi-template Practice',
            type: 'exercise_template',
            order: 1,
          ),
        ],
      ),
    ],
    completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
    references: [],
  ),
  sections: [
    LessonContentSection(
      section: LessonSection(
        id: 'section.multi_template',
        title: 'Multi-template Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.multi_template.practice',
            title: 'Multi-template Practice',
            type: 'exercise_template',
            order: 1,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.multi_template.practice',
            title: 'Multi-template Practice',
            type: 'exercise_template',
            order: 1,
          ),
          resolvedContent: [
            ExerciseTemplate(
              id: 'template.multi_template.hello',
              exerciseType: 'text_entry',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Type the Spanish word for "hello".',
              expectedAnswer: 'hola',
            ),
            ExerciseTemplate(
              id: 'template.multi_template.goodbye',
              exerciseType: 'text_entry',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Type the Spanish word for "goodbye".',
              expectedAnswer: 'adiós',
            ),
          ],
        ),
      ],
    ),
  ],
);

const _finalCheckpointLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'es.a0.m05.l015',
      title: 'Final Checkpoint',
      description: 'Final checkpoint description.',
      moduleId: 'es.a0.m05',
      courseId: 'es.a0',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.final_checkpoint',
        description: 'Exercise final course completion actions.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.final_checkpoint',
        title: 'Final Checkpoint Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.final_checkpoint.vocabulary',
            title: 'Final Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.final_checkpoint.text',
            title: 'Final Recall',
            type: 'exercise_template',
            order: 2,
          ),
        ],
      ),
    ],
    completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
    references: [],
  ),
  sections: [
    LessonContentSection(
      section: LessonSection(
        id: 'section.final_checkpoint',
        title: 'Final Checkpoint Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.final_checkpoint.vocabulary',
            title: 'Final Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.final_checkpoint.text',
            title: 'Final Recall',
            type: 'exercise_template',
            order: 2,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.final_checkpoint.vocabulary',
            title: 'Final Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          resolvedContent: [
            VocabularyItem(
              id: 'vocab.final_checkpoint',
              spanish: 'hola',
              nativeTranslation: 'hello',
              cefr: 'A0',
              example: 'Hola.',
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.final_checkpoint.text',
            title: 'Final Recall',
            type: 'exercise_template',
            order: 2,
          ),
          resolvedContent: [
            ExerciseTemplate(
              id: 'template.final_checkpoint.text',
              exerciseType: 'text_entry',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Type the Spanish word for "hello".',
              expectedAnswer: 'hola',
            ),
          ],
        ),
      ],
    ),
  ],
);

const _noPracticeLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'lesson.no_practice',
      title: 'No Practice Lesson',
      description: 'No practice lesson description.',
      moduleId: 'module.no_practice',
      courseId: 'course.no_practice',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.no_practice',
        description: 'Render without practice.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.no_practice',
        title: 'No Practice Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.no_practice.vocabulary',
            title: 'Only Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
        ],
      ),
    ],
    completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
    references: [],
  ),
  sections: [
    LessonContentSection(
      section: LessonSection(
        id: 'section.no_practice',
        title: 'No Practice Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.no_practice.vocabulary',
            title: 'Only Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.no_practice.vocabulary',
            title: 'Only Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          resolvedContent: [
            VocabularyItem(
              id: 'vocab.no_practice',
              spanish: 'sin-practica',
              nativeTranslation: 'without practice',
              cefr: 'A0',
              example: 'Sin práctica.',
            ),
          ],
        ),
      ],
    ),
  ],
);
