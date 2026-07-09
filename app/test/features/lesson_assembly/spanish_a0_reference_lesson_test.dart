import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/educational_content_validator.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_assembly_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Spanish A0 Unit 1 Lesson 1 is a focused reference lesson', () async {
    final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    const validator = EducationalContentValidator();

    final lesson = await curriculumLoader.loadLesson(
      path: 'assets/languages/spanish/curriculum/lessons/es.a0.u01.l01.json',
    );
    final contentBundle = await contentLoader.loadSpanishContent();
    final catalog = EducationalContentCatalog(contentBundle);

    expect(validator.validate(contentBundle), isEmpty);
    expect(
      validator.validateLessonReferences(lesson: lesson, catalog: catalog),
      isEmpty,
    );

    final assembled = LessonAssemblyService().assembleLessonDefinition(
      lesson: lesson,
      catalog: catalog,
    );
    final resolvedContent = assembled.activities
        .expand((activity) => activity.resolvedContent)
        .toList();
    final vocabulary = resolvedContent.whereType<VocabularyItem>().toList();
    final dialogues = resolvedContent.whereType<Dialogue>().toList();
    final readings = resolvedContent.whereType<ReadingText>().toList();
    final templates = resolvedContent.whereType<ExerciseTemplate>().toList();

    expect(lesson.id, 'es.a0.u01.l01');
    expect(lesson.activities.map((activity) => activity.type), [
      'vocabulary',
      'reading',
      'dialogue',
      'exercise_template',
    ]);
    expect(vocabulary.map((item) => item.spanish), [
      'hola',
      'buenos días',
      'buenas tardes',
      'buenas noches',
      'adiós',
    ]);
    expect(
      vocabulary.map((item) => item.id),
      everyElement(startsWith('vocab.es.a0.u01.l01.')),
    );
    expect(
      vocabulary.map((item) => item.spanish).join(' '),
      isNot(contains('soy')),
    );
    expect(
      vocabulary.map((item) => item.spanish).join(' '),
      isNot(contains('llamo')),
    );
    expect(dialogues, hasLength(1));
    expect(dialogues.single.grammarIds, isEmpty);
    expect(dialogues.single.lines.map((line) => line.spanish), [
      'Hola.',
      'Hola.',
      'Adiós.',
      'Adiós.',
    ]);
    expect(readings, hasLength(1));
    expect(readings.single.grammarIds, isEmpty);
    expect(templates, hasLength(3));
  });
}
