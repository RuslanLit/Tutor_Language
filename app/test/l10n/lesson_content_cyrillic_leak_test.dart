import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/audio/reference_audio_providers.dart';
import 'package:tutor_language/core/audio/temporary_learner_recording.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/content_localization.dart';
import 'package:tutor_language/core/content/content_localization_providers.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/database/database_provider.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_assembly_service.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_content.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_screen.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_step.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

// Interface locales whose educational content resolves to English: no
// Ukrainian (or any Cyrillic) source text may reach a lesson widget.
const _latinUiLocales = ['en', 'de', 'pl'];
const _lessonIds = [
  'es.a0.m01.l001',
  'es.a0.m01.l002',
  'es.a0.m01.l003',
  'es.a0.m01.l004',
  'es.a0.m01.l005',
];
final _cyrillic = RegExp(r'[\u0400-\u04FF]', unicode: true);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final assembled = <String, LessonContent>{};
  late EducationalContentLocalizationResolver resolver;

  setUpAll(() async {
    final service = LessonAssemblyService(
      curriculumLoader: CurriculumLoader(assetBundle: rootBundle),
      contentLoader: ContentLoader(assetBundle: rootBundle),
    );
    for (final lessonId in _lessonIds) {
      assembled[lessonId] = await service.assembleLesson(lessonId);
    }
    resolver = EducationalContentLocalizationResolver(
      await EducationalContentLocalizationRepository().loadBundle(),
      semanticBundle: await SemanticLocalizationRepository().loadBundle(),
    );
  });

  for (final uiLocale in _latinUiLocales) {
    for (final lessonId in _lessonIds) {
      testWidgets('$lessonId renders no Cyrillic text for $uiLocale UI', (
        tester,
      ) async {
        final supportLocale = const SupportLocaleResolver().resolveLanguageCode(
          uiLocale,
        );
        final localized = resolveLocalizedLessonContent(
          lessonContent: assembled[lessonId]!,
          resolver: resolver,
          supportLocale: supportLocale,
        );
        final steps = LessonPlayerStepBuilder().buildSteps(localized);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supportLocaleControllerProvider.overrideWith(
                (ref) => supportLocale,
              ),
              // The app provider also registers `ref.onDispose(service.dispose)`,
              // so tearing down the scope disposes the notifier twice.
              temporaryLearnerRecordingServiceProvider.overrideWith(
                (ref) => TemporaryLearnerRecordingService(
                  recorder: RecordLearnerRecorderBackend(),
                  files: AppTemporaryLearnerRecordingFileStore(),
                  referencePlayback: ref.watch(
                    referenceAudioPlaybackServiceProvider,
                  ),
                ),
              ),
              appDatabaseProvider.overrideWith((ref) {
                final database = AppDatabase(NativeDatabase.memory());
                ref.onDispose(database.close);
                return database;
              }),
            ],
            child: MaterialApp(
              locale: Locale(uiLocale),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localized.lesson.title),
                      Text(localized.lesson.description),
                      for (final step in steps) ...[
                        Text(step.sourceActivity.activity.title),
                        for (final content in step.content) ...[
                          LessonContentObjectView(content: content),
                          LessonContentObjectView(
                            content: content,
                            reviewMode: true,
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        final rendered = tester
            .widgetList<RichText>(find.byType(RichText, skipOffstage: false))
            .map((widget) => widget.text.toPlainText())
            .toList();
        expect(rendered, isNotEmpty);
        expect(
          rendered.where(_cyrillic.hasMatch).toList(),
          isEmpty,
          reason: 'Cyrillic text reached a $uiLocale lesson widget',
        );

        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  }
}
