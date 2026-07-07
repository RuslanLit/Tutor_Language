import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_document.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/educational_content_validator.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';

void main() {
  test('catalog resolves educational content by stable identifier', () {
    final catalog = EducationalContentCatalog(_validBundle);

    expect(catalog.lookupAs<VocabularyItem>('vocab.hola.v1')!.spanish, 'hola');
    expect(catalog.lookupAs<GrammarTopic>('grammar.basic.v1')!.title, 'Basic');
    expect(catalog.lookup('missing.id'), isNull);
  });

  test('catalog resolves LessonDefinition content references', () {
    final catalog = EducationalContentCatalog(_validBundle);

    expect(
      catalog.canResolve(
        const LessonActivityReference(
          type: 'vocabulary',
          assetPath: 'assets/languages/spanish/vocabulary/test.json',
          referenceId: 'vocab.hola.v1',
        ),
      ),
      isTrue,
    );
    expect(
      catalog.canResolve(
        const LessonActivityReference(
          type: 'vocabulary',
          assetPath: 'assets/languages/spanish/vocabulary/test.json',
          referenceId: 'vocab.missing.v1',
        ),
      ),
      isFalse,
    );
    expect(
      catalog.canResolve(
        const LessonActivityReference(
          type: 'grammar',
          assetPath: 'assets/languages/spanish/vocabulary/test.json',
          referenceId: 'vocab.hola.v1',
        ),
      ),
      isFalse,
    );
    expect(
      catalog.canResolve(
        const LessonActivityReference(
          type: 'grammar',
          assetPath: 'assets/languages/spanish/grammar/test.json',
          referenceId: 'vocab.hola.v1',
        ),
      ),
      isFalse,
    );
  });

  test('validator accepts valid educational content', () {
    const validator = EducationalContentValidator();

    expect(validator.validate(_validBundle), isEmpty);
  });

  test('validator reports duplicates and invalid references', () {
    const validator = EducationalContentValidator();
    final issues = validator
        .validate(_invalidBundle)
        .map((issue) => issue.message);

    expect(issues, contains(contains('Duplicate vocabulary id')));
    expect(issues, contains(contains('Invalid vocabulary reference')));
    expect(issues, contains(contains('Invalid grammar reference')));
    expect(issues, contains(contains('Empty lines field')));
    expect(issues, contains(contains('Unsupported exercise type')));
  });

  test('educational content exists without lesson reverse references', () {
    final item = VocabularyItem.fromJson(const {
      'id': 'vocab.hola.v1',
      'spanish': 'hola',
      'native_translation': 'hello',
      'cefr': 'A0',
      'example': 'Hola.',
    });

    expect(item.toJson(), isNot(contains('lesson_ids')));
    expect(item.toJson(), isNot(contains('topic_ids')));
  });

  test('validator reports broken LessonDefinition content references', () {
    const validator = EducationalContentValidator();
    final catalog = EducationalContentCatalog(_validBundle);

    final issues = validator
        .validateLessonReferences(
          lesson: _lessonWithBrokenReferences,
          catalog: catalog,
        )
        .map((issue) => issue.message);

    expect(issues, contains(contains('Unresolved content reference')));
    expect(issues, contains(contains('Duplicate content reference')));
    expect(issues, contains(contains('Invalid content reference')));
  });
}

const _validBundle = EducationalContentBundle(
  contents: [
    VocabularyContent(
      assetPath: 'assets/languages/spanish/vocabulary/test.json',
      entries: [
        VocabularyItem(
          id: 'vocab.hola.v1',
          spanish: 'hola',
          nativeTranslation: 'hello',
          cefr: 'A0',
          example: 'Hola.',
        ),
      ],
    ),
    GrammarContent(
      assetPath: 'assets/languages/spanish/grammar/test.json',
      topics: [
        GrammarTopic(
          id: 'grammar.basic.v1',
          title: 'Basic',
          explanation: 'A basic grammar topic.',
          examples: ['Me llamo Ana.'],
          prerequisiteIds: [],
        ),
      ],
    ),
    DialogueContent(
      assetPath: 'assets/languages/spanish/dialogues/test.json',
      dialogues: [
        Dialogue(
          id: 'dialogue.greeting.v1',
          title: 'Greeting',
          vocabularyIds: ['vocab.hola.v1'],
          grammarIds: ['grammar.basic.v1'],
          lines: [
            DialogueLine(
              speaker: 'Ana',
              spanish: 'Hola.',
              nativeTranslation: 'Hello.',
            ),
          ],
        ),
      ],
    ),
    ReadingContent(
      assetPath: 'assets/languages/spanish/readings/test.json',
      texts: [
        ReadingText(
          id: 'reading.greeting.v1',
          title: 'Greeting',
          vocabularyIds: ['vocab.hola.v1'],
          grammarIds: ['grammar.basic.v1'],
          text: 'Hola.',
          nativeTranslation: 'Hello.',
        ),
      ],
    ),
    ExerciseTemplateContent(
      assetPath: 'assets/languages/spanish/templates/test.json',
      templates: [
        ExerciseTemplate(
          id: 'template.choice.v1',
          exerciseType: 'multiple_choice',
          supportedGoalTypes: ['introduce_vocabulary'],
          requiredObjectTypes: ['vocabulary'],
          promptTemplate: 'Choose.',
        ),
      ],
    ),
  ],
);

const _invalidBundle = EducationalContentBundle(
  contents: [
    VocabularyContent(
      assetPath: 'assets/languages/spanish/vocabulary/test.json',
      entries: [
        VocabularyItem(
          id: 'vocab.hola.v1',
          spanish: 'hola',
          nativeTranslation: 'hello',
          cefr: 'A0',
          example: 'Hola.',
        ),
        VocabularyItem(
          id: 'vocab.hola.v1',
          spanish: 'hola',
          nativeTranslation: 'hello',
          cefr: 'A0',
          example: 'Hola.',
        ),
      ],
    ),
    DialogueContent(
      assetPath: 'assets/languages/spanish/dialogues/test.json',
      dialogues: [
        Dialogue(
          id: 'dialogue.invalid.v1',
          title: 'Invalid',
          vocabularyIds: ['vocab.missing.v1'],
          grammarIds: ['grammar.missing.v1'],
          lines: [],
        ),
      ],
    ),
    ExerciseTemplateContent(
      assetPath: 'assets/languages/spanish/templates/test.json',
      templates: [
        ExerciseTemplate(
          id: 'template.unsupported.v1',
          exerciseType: 'speaking',
          supportedGoalTypes: ['introduce_vocabulary'],
          requiredObjectTypes: ['vocabulary'],
          promptTemplate: 'Speak.',
        ),
      ],
    ),
  ],
);

const _lessonWithBrokenReferences = Lesson(
  id: 'lesson.broken.v1',
  moduleId: 'module.test.v1',
  title: 'Broken references',
  primaryObjective: LessonObjective(
    id: 'objective.broken.v1',
    description: 'Exercise broken references.',
  ),
  activities: [
    LessonActivity(
      id: 'activity.broken.v1',
      title: 'Broken',
      type: 'vocabulary',
      contentReferences: [
        LessonContentReference(
          type: 'vocabulary',
          assetPath: 'assets/languages/spanish/vocabulary/missing.json',
          referenceId: 'vocab.hola.v1',
        ),
        LessonContentReference(
          type: 'vocabulary',
          assetPath: 'assets/languages/spanish/vocabulary/test.json',
          referenceId: 'vocab.missing.v1',
        ),
        LessonContentReference(
          type: 'vocabulary',
          assetPath: 'assets/languages/spanish/vocabulary/test.json',
          referenceId: 'vocab.missing.v1',
        ),
        LessonContentReference(
          type: '',
          assetPath: 'assets/languages/spanish/vocabulary/test.json',
        ),
      ],
    ),
  ],
  prerequisites: [],
  estimatedDurationMinutes: 10,
  completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
);
