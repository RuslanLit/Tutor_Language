import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/router/app_router.dart';
import '../core/content/content_localization_providers.dart';
import '../core/content/semantic_localization.dart';
import '../core/content/semantic_pilot_scope.dart';
import '../features/lesson_player/lesson_player_screen.dart';
import '../shared/widgets/course_browser_error.dart';
import 'semantic_pilot_qa.dart';

class SemanticPilotQaScreen extends ConsumerWidget {
  const SemanticPilotQaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!semanticPilotQaPolicy.isEnabled) {
      return const _QaUnavailableScreen();
    }

    final course = ref.watch(localizedCurrentCourseProvider);
    final semanticBundle = ref.watch(semanticLocalizationBundleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QA ONLY: Semantic Pilot'),
        leading: IconButton(
          tooltip: 'Back to settings',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(SettingsRoute.name),
        ),
      ),
      body: SafeArea(
        child: course.when(
          data: (course) {
            final lessonsById = {
              for (final lesson in course.lessons) lesson.id: lesson,
            };
            return semanticBundle.when(
              data: (bundle) => ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const _QaWarning(),
                  const SizedBox(height: 16),
                  for (final lessonId in semanticPilotLessonIds)
                    _PilotLessonTile(
                      lessonId: lessonId,
                      title: lessonsById[lessonId]?.title ?? lessonId,
                      diagnostics: _diagnosticsForLesson(bundle, lessonId),
                    ),
                ],
              ),
              error: (error, stackTrace) =>
                  CourseBrowserError(message: '$error'),
              loading: () => const Center(child: CircularProgressIndicator()),
            );
          },
          error: (error, stackTrace) => CourseBrowserError(message: '$error'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class SemanticPilotQaLessonScreen extends StatelessWidget {
  const SemanticPilotQaLessonScreen({required this.lessonId, super.key});

  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final launch = semanticPilotQaPolicy.launchForLessonId(lessonId);
    if (launch == null) {
      return const _QaUnavailableScreen();
    }

    return LessonPlayerScreen(
      lessonId: launch.lessonId,
      persistCompletion: launch.persistCompletion,
      qaBannerLabel: 'QA ONLY - semantic pilot, progress is not saved',
    );
  }
}

class _QaUnavailableScreen extends StatelessWidget {
  const _QaUnavailableScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Semantic pilot QA is unavailable in this build.'),
        ),
      ),
    );
  }
}

class _QaWarning extends StatelessWidget {
  const _QaWarning();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        color: Colors.yellow.shade100,
      ),
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'DEBUG QA ONLY. Opens exactly five semantic pilot lessons. '
          'Completion is disabled for persistence; learner progress and '
          'course availability are not changed.',
        ),
      ),
    );
  }
}

class _PilotLessonTile extends StatelessWidget {
  const _PilotLessonTile({
    required this.lessonId,
    required this.title,
    required this.diagnostics,
  });

  final String lessonId;
  final String title;
  final _LessonSemanticDiagnostics diagnostics;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(title),
        subtitle: Text(
          '$lessonId\n'
          'semantic: ${diagnostics.semanticCount}, '
          'legacy fallback: ${diagnostics.legacyFallbackCount}',
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () {
                context.goNamed(
                  DebugSemanticPilotLessonRoute.name,
                  pathParameters: {'lessonId': lessonId},
                );
              },
              child: const Text('Open QA lesson'),
            ),
          ),
          const SizedBox(height: 8),
          for (final field in diagnostics.fields.take(80))
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${field.contentObjectId} | ${field.fieldPath} | '
                '${field.semanticType} | ${field.locale} | '
                '${field.reviewStatus} | ${field.resolutionSource} | '
                '${field.protectedSpanResult}',
              ),
            ),
          if (diagnostics.fields.length > 80)
            Align(
              alignment: Alignment.centerLeft,
              child: Text('+${diagnostics.fields.length - 80} more fields'),
            ),
        ],
      ),
    );
  }
}

_LessonSemanticDiagnostics _diagnosticsForLesson(
  SemanticLocalizationBundle bundle,
  String lessonId,
) {
  final fields = <_SemanticFieldDiagnostic>[];
  for (final unit in bundle.units.where(
    (unit) =>
        unit.context.lessonId == lessonId ||
        unit.context.contentObjectId == lessonId,
  )) {
    final ukStatus = unit.review['uk'];
    final hasApprovedValue =
        unit.values['uk'] != null && ukStatus == SemanticReviewStatus.approved;
    fields.add(
      _SemanticFieldDiagnostic(
        lessonId: lessonId,
        semanticUnitId: unit.id,
        semanticType: unit.semanticType.name,
        locale: 'uk',
        reviewStatus: ukStatus?.name ?? 'missing',
        resolutionSource: hasApprovedValue ? 'semantic' : 'missing',
        protectedSpanResult: _protectedSpanResult(unit, 'uk'),
        contentObjectId: unit.context.contentObjectId,
        fieldPath: unit.context.fieldPath,
      ),
    );
  }
  fields.sort((a, b) {
    final byObject = a.contentObjectId.compareTo(b.contentObjectId);
    if (byObject != 0) {
      return byObject;
    }
    return a.fieldPath.compareTo(b.fieldPath);
  });
  return _LessonSemanticDiagnostics(
    fields: fields,
    legacyFallbackCount: fields
        .where((field) => field.resolutionSource != 'semantic')
        .length,
  );
}

String _protectedSpanResult(SemanticLocalizationUnit unit, String locale) {
  final value = unit.values[locale];
  if (value == null) {
    return 'missing';
  }
  for (final span in unit.protectedSpans) {
    if (!value.contains(span.text)) {
      return 'changed';
    }
  }
  return 'preserved';
}

class _LessonSemanticDiagnostics {
  const _LessonSemanticDiagnostics({
    required this.fields,
    required this.legacyFallbackCount,
  });

  final List<_SemanticFieldDiagnostic> fields;
  final int legacyFallbackCount;

  int get semanticCount =>
      fields.where((field) => field.resolutionSource == 'semantic').length;
}

class _SemanticFieldDiagnostic {
  const _SemanticFieldDiagnostic({
    required this.lessonId,
    required this.semanticUnitId,
    required this.semanticType,
    required this.locale,
    required this.reviewStatus,
    required this.resolutionSource,
    required this.protectedSpanResult,
    required this.contentObjectId,
    required this.fieldPath,
  });

  final String lessonId;
  final String semanticUnitId;
  final String semanticType;
  final String locale;
  final String reviewStatus;
  final String resolutionSource;
  final String protectedSpanResult;
  final String contentObjectId;
  final String fieldPath;
}
