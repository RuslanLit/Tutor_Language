import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/educational_content_validator.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'every curriculum content reference resolves to matching content',
    () async {
      final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
      final contentLoader = ContentLoader(assetBundle: rootBundle);
      const validator = EducationalContentValidator();

      final course = await curriculumLoader.loadCourse();
      final contentBundle = await contentLoader.loadSpanishContent();
      final catalog = EducationalContentCatalog(contentBundle);

      expect(validator.validate(contentBundle), isEmpty);

      for (final lesson in course.lessons) {
        expect(
          validator.validateLessonReferences(lesson: lesson, catalog: catalog),
          isEmpty,
        );

        for (final activity in lesson.activities) {
          for (final reference in activity.contentReferences) {
            expect(reference.assetPath, isNotEmpty);
            expect(catalog.canResolve(reference), isTrue);

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

  test('first lesson references concrete educational content ids', () async {
    final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    final catalog = EducationalContentCatalog(
      await contentLoader.loadSpanishContent(),
    );

    final course = await curriculumLoader.loadCourse();
    final lesson = course.lessons.firstWhere(
      (lesson) => lesson.id == 'es.a0.m01.l001',
    );

    final references = lesson.activities.expand(
      (activity) => activity.contentReferences,
    );
    final referenceIds = references
        .map((reference) => reference.referenceId)
        .whereType<String>()
        .toSet();

    expect(referenceIds, contains('vocab.es.a0.unit1.hola.v1'));
    expect(referenceIds, contains('grammar.es.a0.unit1.personal_pronouns.v1'));
    expect(referenceIds, contains('grammar.es.a0.unit1.ser_present.v1'));
    expect(referenceIds, contains('dialogue.es.a0.unit1.first_contact.v1'));
    expect(referenceIds, contains('reading.es.a0.unit1.first_contact.v1'));
    expect(referenceIds, contains('template.es.a0.unit1.greeting_choice.v1'));
    expect(references.every(catalog.canResolve), isTrue);
  });
}
