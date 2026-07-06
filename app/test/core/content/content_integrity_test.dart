import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/curriculum_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'every curriculum content reference resolves to matching content',
    () async {
      final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
      final contentLoader = ContentLoader(assetBundle: rootBundle);

      final course = await curriculumLoader.loadCourse();

      for (final unit in course.units) {
        for (final topic in unit.topics) {
          for (final section in topic.sections) {
            final reference = section.contentReference;

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
