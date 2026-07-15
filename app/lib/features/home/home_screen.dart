import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/content/content_localization_providers.dart';
import '../../core/content/content_providers.dart';
import '../../core/learner/learner_progress.dart';
import '../../core/learner/learner_progress_providers.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/course_browser_error.dart';
import '../curriculum/curriculum_models.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final language = ref.watch(currentLanguageProvider);
    final course = ref.watch(localizedCurrentCourseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsTooltip,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.goNamed(SettingsRoute.name),
          ),
        ],
      ),
      body: language.when(
        data: (language) {
          return course.when(
            data: (course) =>
                CourseOverview(language: language, course: course),
            error: (error, stackTrace) => CourseBrowserError(message: '$error'),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
        error: (error, stackTrace) => CourseBrowserError(message: '$error'),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class CourseOverview extends StatelessWidget {
  const CourseOverview({
    required this.language,
    required this.course,
    super.key,
  });

  final LanguagePackDisplay language;
  final Course course;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(language.name, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(course.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => context.goNamed(CourseRoute.name),
          child: Text(l10n.openCourse),
        ),
      ],
    );
  }
}

class ModuleTile extends StatelessWidget {
  const ModuleTile({required this.module, super.key});

  final Module module;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(module.title),
      children: [
        for (final lessonId in module.lessonIds) LessonTile(lessonId: lessonId),
      ],
    );
  }
}

class LessonTile extends ConsumerWidget {
  const LessonTile({required this.lessonId, super.key});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final course = ref.watch(localizedCurrentCourseProvider).asData?.value;
    final progress = ref.watch(topicProgressProvider(lessonId));
    final lesson = _lessonById(course, lessonId);

    return ListTile(
      title: Text(lesson?.title ?? lessonId),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.activitiesCount(lesson?.activities.length ?? 0)),
          progress.when(
            data: (progress) => Text(_topicStatusLabel(progress, l10n)),
            error: (error, stackTrace) => Text(l10n.notViewed),
            loading: () => Text(l10n.notViewed),
          ),
        ],
      ),
      onTap: () => context.goNamed(
        TopicRoute.name,
        pathParameters: {'topicId': lessonId},
      ),
    );
  }

  String _topicStatusLabel(TopicProgress progress, AppLocalizations l10n) {
    if (progress.hasBeenCompleted) {
      return l10n.lessonStatusCompleted;
    }

    return progress.hasBeenViewed ? l10n.viewed : l10n.notViewed;
  }

  Lesson? _lessonById(Course? course, String lessonId) {
    if (course == null) {
      return null;
    }

    for (final lesson in course.lessons) {
      if (lesson.id == lessonId) {
        return lesson;
      }
    }

    return null;
  }
}
