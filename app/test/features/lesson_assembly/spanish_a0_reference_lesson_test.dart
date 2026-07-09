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

  test('Spanish A0 Unit 1 content loads, validates, and assembles', () async {
    final curriculumLoader = CurriculumLoader(assetBundle: rootBundle);
    final contentLoader = ContentLoader(assetBundle: rootBundle);
    const validator = EducationalContentValidator();

    final contentBundle = await contentLoader.loadSpanishContent();
    final catalog = EducationalContentCatalog(contentBundle);
    final lesson = await curriculumLoader.loadLesson(
      path: 'assets/languages/spanish/curriculum/lessons/es.a0.u01.l01.json',
    );

    expect(validator.validate(contentBundle), isEmpty);
    expect(
      validator.validateLessonReferences(lesson: lesson, catalog: catalog),
      isEmpty,
    );

    final service = LessonAssemblyService(
      curriculumLoader: curriculumLoader,
      contentLoader: contentLoader,
    );
    final assembled = await service.assembleLesson('es.a0.m01.l001');
    final resolvedContent = assembled.activities
        .expand((activity) => activity.resolvedContent)
        .toList();
    final vocabulary = resolvedContent.whereType<VocabularyItem>().toList();
    final grammar = resolvedContent.whereType<GrammarTopic>().toList();
    final dialogues = resolvedContent.whereType<Dialogue>().toList();
    final readings = resolvedContent.whereType<ReadingText>().toList();
    final templates = resolvedContent.whereType<ExerciseTemplate>().toList();

    expect(assembled.lesson.id, 'es.a0.m01.l001');
    expect(assembled.activities.map((activity) => activity.activity.type), [
      'vocabulary',
      'grammar',
      'dialogue',
      'reading',
      'exercise_template',
    ]);
    expect(vocabulary, hasLength(23));
    expect(
      vocabulary.map((item) => item.id),
      everyElement(contains('.unit1.')),
    );
    expect(
      vocabulary.map((item) => item.spanish),
      containsAll(['hola', 'soy']),
    );
    expect(grammar.map((topic) => topic.id), [
      'grammar.es.a0.unit1.personal_pronouns.v1',
      'grammar.es.a0.unit1.ser_present.v1',
    ]);
    expect(dialogues, hasLength(1));
    expect(
      dialogues.single.vocabularyIds,
      contains('vocab.es.a0.unit1.hola.v1'),
    );
    expect(
      dialogues.single.grammarIds,
      contains('grammar.es.a0.unit1.ser_present.v1'),
    );
    expect(readings, hasLength(1));
    expect(
      readings.single.text.split(' '),
      hasLength(greaterThanOrEqualTo(20)),
    );
    expect(templates.map((template) => template.exerciseType).toSet(), {
      'multiple_choice',
      'fill_gap',
      'matching',
    });
  });
}
