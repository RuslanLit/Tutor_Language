import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/curriculum_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads bundled course description', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final course = await loader.loadCourse();

    expect(course.id, 'course.spanish_beginner.v1');
    expect(course.language, 'spanish');
    expect(course.modules, hasLength(1));
    expect(
      course.modules.single.lessons.single.id,
      'lesson.greetings_intro.v1',
    );
  });

  test('loads supported Spanish content JSON files', () async {
    final loader = ContentLoader(assetBundle: rootBundle);

    final content = await loader.loadSpanishContent();

    expect(content.byCategory('curriculum'), isNotEmpty);
    expect(content.byCategory('vocabulary'), isNotEmpty);
    expect(content.byCategory('grammar'), isNotEmpty);
    expect(content.byCategory('templates'), isNotEmpty);
  });
}
