import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'every curriculum content reference resolves to matching content',
    () async {
      final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
      final contentLoader = ContentLoader(assetBundle: rootBundle);

      final course = await curriculumLoader.loadCourse();

      for (final lesson in course.lessons) {
        for (final activity in lesson.activities) {
          for (final reference in activity.contentReferences) {
            expect(reference.assetPath, isNotEmpty);

            final content = await contentLoader.loadContent(
              reference.assetPath,
            );

            expect(content.assetPath, reference.assetPath);
            expect(content.type, reference.type);
          }
        }
      }
    },
  );
}
