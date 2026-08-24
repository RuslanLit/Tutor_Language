import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_language/app/router/app_router.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/database/database_provider.dart';
import 'package:tutor_language/core/learner/learner_progress.dart';
import 'package:tutor_language/core/learner/learner_progress_repository.dart';
import 'package:tutor_language/features/course_navigation/course_navigation_models.dart';
import 'package:tutor_language/features/course_navigation/course_navigation_service.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';
import 'package:tutor_language/features/pronunciation_primer/pronunciation_primer.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';
import 'package:tutor_language/l10n/generated/app_localizations_de.dart';
import 'package:tutor_language/l10n/generated/app_localizations_en.dart';
import 'package:tutor_language/l10n/generated/app_localizations_pl.dart';
import 'package:tutor_language/l10n/generated/app_localizations_ru.dart';
import 'package:tutor_language/l10n/generated/app_localizations_uk.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Spanish A0 keeps canonical lessons separate from the primer',
    () async {
      final course = await CurriculumLoader().loadCourse();
      expect(course.lessons, hasLength(42));
      expect(
        pronunciationPrimerTopicId,
        isNot(isIn(course.lessons.map((lesson) => lesson.id))),
      );
      final state = const CourseNavigationService().buildNavigationState(
        course: course,
        completedLessonIds: {pronunciationPrimerTopicId},
      );
      expect(state.totalLessonCount, 42);
      expect(state.completedLessonCount, 0);
      expect(
        state.units
            .singleWhere((unit) => unit.unitId == 'es.a0.m01')
            .lessons
            .first
            .status,
        LessonNavigationStatus.available,
      );
    },
  );

  test('alphabet has exactly the modern 27 letters and separate digraphs', () {
    expect(pronunciationPrimerAlphabet, hasLength(27));
    expect(
      pronunciationPrimerAlphabet,
      orderedEquals([
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'Ñ',
        'O',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'W',
        'X',
        'Y',
        'Z',
      ]),
    );
    expect(pronunciationPrimerDigraphs, orderedEquals(['CH', 'LL']));
  });

  test(
    'Ukrainian alphabet and digraph rows meet the learner-facing contract',
    () {
      final uk = AppLocalizationsUk();
      final letters = uk.primerAlphabetRows.split('\n');
      final digraphs = uk.primerDigraphRows.split('\n');
      expect(letters, hasLength(27));
      expect(letters.first, startsWith('A (а)'));
      expect(letters[7], 'H (аче) — не читається');
      expect(letters[25], startsWith('Y (і грієга)'));
      expect(digraphs, ['CH (че) — приблизно ч', 'LL (ельє) — приблизно й']);
      expect(letters, everyElement(isNot(contains('CH'))));
      expect(letters, everyElement(isNot(contains('LL'))));
    },
  );

  test('all supported locales have independent complete alphabet content', () {
    final locales = [
      AppLocalizationsEn(),
      AppLocalizationsUk(),
      AppLocalizationsRu(),
      AppLocalizationsPl(),
      AppLocalizationsDe(),
    ];
    for (final l10n in locales) {
      expect(l10n.primerAlphabetRows.split('\n'), hasLength(27));
      expect(l10n.primerDigraphRows.split('\n'), hasLength(2));
      final text =
          '${l10n.primerIntro} ${l10n.primerAlphabetRows} ${l10n.primerDigraphRows}';
      expect(text, isNot(matches(RegExp(r'/[^/]+/|\[[^]]+\]'))));
    }
    expect(
      AppLocalizationsUk().primerAlphabetRows,
      isNot(AppLocalizationsEn().primerAlphabetRows),
    );
    expect(
      AppLocalizationsRu().primerAlphabetRows,
      isNot(AppLocalizationsEn().primerAlphabetRows),
    );
    expect(
      AppLocalizationsPl().primerAlphabetRows,
      isNot(AppLocalizationsEn().primerAlphabetRows),
    );
    expect(
      AppLocalizationsDe().primerAlphabetRows,
      isNot(AppLocalizationsEn().primerAlphabetRows),
    );
  });

  test('primer remains skippable and its state is durable', () async {
    final skipped = ProgressEvent.create(
      eventType: ProgressEventType.topicViewed,
      topicId: pronunciationPrimerTopicId,
      metadataJson: '{"state":"skipped"}',
      now: DateTime.utc(2026, 1),
    );
    expect(
      pronunciationPrimerStateFromEvents([skipped]).status,
      PronunciationPrimerStatus.skipped,
    );
    final completed = ProgressEvent.create(
      eventType: ProgressEventType.topicCompleted,
      topicId: pronunciationPrimerTopicId,
      metadataJson: '{"state":"completed"}',
      now: DateTime.utc(2026, 2),
    );
    final directory = await Directory.systemTemp.createTemp('primer-test-');
    final file = File('${directory.path}/progress.sqlite');
    var database = AppDatabase(NativeDatabase(file));
    await LearnerProgressRepository(database).recordEvent(completed);
    await database.close();
    database = AppDatabase(NativeDatabase(file));
    addTearDown(() async {
      await database.close();
      await directory.delete(recursive: true);
    });
    final events = await LearnerProgressRepository(database).readEvents();
    expect(
      pronunciationPrimerStateFromEvents(events).status,
      PronunciationPrimerStatus.completed,
    );
  });

  testWidgets(
    'screen contains one compact alphabet reference and one continue action',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(database)],
          child: MaterialApp(
            locale: const Locale('uk'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const PronunciationPrimerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.byType(ChoiceChip), findsNothing);
      expect(find.text('Hola'), findsNothing);
      await tester.scrollUntilVisible(
        find.text('CH (че) — приблизно ч'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('CH (че) — приблизно ч'), findsOneWidget);
      expect(find.text('LL (ельє) — приблизно й'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(SafeArea), findsAtLeast(1));
      expect(
        tester.getRect(find.byType(FilledButton)).bottom,
        lessThanOrEqualTo(600),
      );
    },
  );

  test('Primer does not add a global orientation lock', () {
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    expect(manifest, isNot(contains('android:screenOrientation="portrait"')));
  });

  testWidgets('skip persists state and navigates to the course', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final router = _testRouter(database);
    await tester.pumpWidget(_testApp(router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Пропустити зараз'));
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, '/course');
    expect(find.text('COURSE'), findsOneWidget);
    final events = await LearnerProgressRepository(
      database,
    ).readEventsForTopic(pronunciationPrimerTopicId);
    expect(
      pronunciationPrimerStateFromEvents(events).status,
      PronunciationPrimerStatus.skipped,
    );
  });

  testWidgets('continue completes primer and navigates to canonical Lesson 1', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final router = _testRouter(database);
    await tester.pumpWidget(_testApp(router));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Перейти до уроку 1'));
    await tester.pumpAndSettle();

    expect(
      router.routeInformationProvider.value.uri.path,
      '/lesson/es.a0.m01.l001',
    );
    expect(find.text('LESSON es.a0.m01.l001'), findsOneWidget);
    final events = await LearnerProgressRepository(
      database,
    ).readEventsForTopic(pronunciationPrimerTopicId);
    expect(
      events.where(
        (event) => event.eventType == ProgressEventType.topicCompleted,
      ),
      hasLength(1),
    );
    expect(
      pronunciationPrimerStateFromEvents(events).status,
      PronunciationPrimerStatus.completed,
    );
  });
}

GoRouter _testRouter(AppDatabase database) => GoRouter(
  initialLocation: '/primer',
  routes: [
    GoRoute(
      path: '/primer',
      name: PronunciationPrimerRoute.name,
      builder: (context, state) => ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const PronunciationPrimerScreen(),
      ),
    ),
    GoRoute(
      path: '/course',
      name: CourseRoute.name,
      builder: (context, state) => const Text('COURSE'),
    ),
    GoRoute(
      path: '/lesson/:lessonId',
      name: LessonRoute.name,
      builder: (context, state) =>
          Text('LESSON ${state.pathParameters['lessonId']}'),
    ),
  ],
);

Widget _testApp(GoRouter router) => MaterialApp.router(
  routerConfig: router,
  locale: const Locale('uk'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
);
