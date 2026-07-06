import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/content/content_providers.dart';
import '../../core/content/course.dart';
import '../../shared/widgets/course_browser_error.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(currentLanguageProvider);
    final course = ref.watch(currentCourseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutor Language'),
        actions: [
          IconButton(
            tooltip: 'Settings',
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

  final Language language;
  final Course course;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(language.name, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(course.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        for (final unit in course.units) UnitTile(unit: unit),
      ],
    );
  }
}

class UnitTile extends StatelessWidget {
  const UnitTile({required this.unit, super.key});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(unit.title),
      children: [
        for (final topic in unit.topics)
          ListTile(
            title: Text(topic.title),
            subtitle: Text('${topic.sections.length} sections'),
            onTap: () => context.goNamed(
              TopicRoute.name,
              pathParameters: {'topicId': topic.id},
            ),
          ),
      ],
    );
  }
}
