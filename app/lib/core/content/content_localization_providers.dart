import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../features/lesson_assembly/lesson_content.dart';
import '../content/content_document.dart';
import 'content_loader.dart';
import 'content_localization.dart';
import 'content_providers.dart';

final supportLocaleControllerProvider = StateProvider<SupportLocale>((ref) {
  return SupportLocale.english;
});

final supportLocaleProvider = Provider<SupportLocale>((ref) {
  return ref.watch(supportLocaleControllerProvider);
});

final supportLocaleResolverProvider = Provider<SupportLocaleResolver>((ref) {
  return const SupportLocaleResolver();
});

final educationalContentLocalizationRepositoryProvider =
    Provider<EducationalContentLocalizationRepository>((ref) {
      return EducationalContentLocalizationRepository();
    });

final educationalContentLocalizationBundleProvider =
    FutureProvider<EducationalContentLocalizationBundle>((ref) {
      return ref
          .watch(educationalContentLocalizationRepositoryProvider)
          .loadBundle();
    });

final educationalContentBundleProvider =
    FutureProvider<EducationalContentBundle>((ref) {
      return ContentLoader().loadLanguagePackContent();
    });

final localizedCurrentCourseProvider = FutureProvider((ref) async {
  final course = await ref.watch(currentCourseProvider.future);
  final localization = await ref.watch(
    educationalContentLocalizationBundleProvider.future,
  );
  final supportLocale = ref.watch(supportLocaleProvider);

  return EducationalContentLocalizationResolver(
    localization,
  ).resolveCourse(course, supportLocale);
});

final localizedLessonContentProvider =
    FutureProvider.family<LessonContent, LessonContent>((
      ref,
      lessonContent,
    ) async {
      final localization = await ref.watch(
        educationalContentLocalizationBundleProvider.future,
      );
      final supportLocale = ref.watch(supportLocaleProvider);
      final resolver = EducationalContentLocalizationResolver(localization);

      return resolveLocalizedLessonContent(
        lessonContent: lessonContent,
        resolver: resolver,
        supportLocale: supportLocale,
      );
    });

LessonContent resolveLocalizedLessonContent({
  required LessonContent lessonContent,
  required EducationalContentLocalizationResolver resolver,
  required SupportLocale supportLocale,
}) {
  final localizedLesson = resolver.resolveLesson(
    lessonContent.lesson,
    supportLocale,
  );
  final localizedSectionsById = {
    for (final section in localizedLesson.sections) section.id: section,
  };
  final localizedActivitiesById = {
    for (final activity in localizedLesson.activities) activity.id: activity,
  };

  return LessonContent(
    lesson: localizedLesson,
    sections: List.unmodifiable(
      lessonContent.sections.map((section) {
        return LessonContentSection(
          section: localizedSectionsById[section.section.id] ?? section.section,
          activities: List.unmodifiable(
            section.activities.map((activity) {
              return LessonContentActivity(
                activity:
                    localizedActivitiesById[activity.activity.id] ??
                    activity.activity,
                resolvedContent: List.unmodifiable(
                  activity.resolvedContent.map(
                    (content) =>
                        resolver.resolveContentObject(content, supportLocale),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    ),
  );
}
