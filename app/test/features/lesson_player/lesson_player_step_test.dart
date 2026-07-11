import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_content.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_step.dart';

void main() {
  test('flattens each exercise template into its own stable step', () {
    const lessonContent = _granularLessonContent;
    const builder = LessonPlayerStepBuilder();

    final firstBuild = builder.buildSteps(lessonContent);
    final secondBuild = builder.buildSteps(lessonContent);

    expect(
      firstBuild.map((step) => step.id),
      secondBuild.map((step) => step.id),
    );
    expect(firstBuild, hasLength(4));
    expect(firstBuild[0].content, hasLength(2));
    expect(firstBuild[0].stepType, LessonPlayerStepType.mixed);
    expect(firstBuild[1].content.single, isA<ExerciseTemplate>());
    expect(firstBuild[2].content.single, isA<ExerciseTemplate>());
    expect(firstBuild[3].content.single, isA<ExerciseTemplate>());
    expect(firstBuild.skip(1).every((step) => step.isCheckable), isTrue);
    expect(firstBuild.map((step) => step.id), [
      'lesson.granular::activity.granular.intro::info.1',
      'lesson.granular::activity.granular.practice::template.granular.choice.1',
      'lesson.granular::activity.granular.practice::template.granular.text.2',
      'lesson.granular::activity.granular.practice::template.granular.fill.3',
    ]);
  });

  test('keeps informational content grouped around exercise steps', () {
    const builder = LessonPlayerStepBuilder();

    final steps = builder.buildSteps(_interleavedLessonContent);

    expect(steps, hasLength(3));
    expect(steps[0].content.single, isA<VocabularyItem>());
    expect(steps[1].content.single, isA<ExerciseTemplate>());
    expect(steps[2].content.single, isA<ReadingText>());
    expect(steps.map((step) => step.id), [
      'lesson.interleaved::activity.interleaved::info.1',
      'lesson.interleaved::activity.interleaved::template.interleaved.text.1',
      'lesson.interleaved::activity.interleaved::info.2',
    ]);
  });
}

const _granularLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'lesson.granular',
      title: 'Granular Lesson',
      description: 'Exercise step flattening.',
      moduleId: 'module.granular',
      courseId: 'course.granular',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.granular',
        description: 'Verify step granularity.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.granular',
        title: 'Granular Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.granular.intro',
            title: 'Intro',
            type: 'vocabulary',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.granular.practice',
            title: 'Practice',
            type: 'exercise_template',
            order: 2,
          ),
        ],
      ),
    ],
    completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
    references: [],
  ),
  sections: [
    LessonContentSection(
      section: LessonSection(
        id: 'section.granular',
        title: 'Granular Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.granular.intro',
            title: 'Intro',
            type: 'vocabulary',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.granular.practice',
            title: 'Practice',
            type: 'exercise_template',
            order: 2,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.granular.intro',
            title: 'Intro',
            type: 'vocabulary',
            order: 1,
          ),
          resolvedContent: [
            VocabularyItem(
              id: 'vocab.granular',
              spanish: 'hola',
              nativeTranslation: 'hello',
              cefr: 'A0',
              example: 'Hola.',
            ),
            GrammarTopic(
              id: 'grammar.granular',
              title: 'Greeting',
              explanation: 'Use hola to greet someone.',
              examples: ['Hola.'],
              prerequisiteIds: [],
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.granular.practice',
            title: 'Practice',
            type: 'exercise_template',
            order: 2,
          ),
          resolvedContent: [
            ExerciseTemplate(
              id: 'template.granular.choice',
              exerciseType: 'multiple_choice',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Choose hello.',
              answerOptions: [
                ExerciseTemplateOption(id: 'option.hola', label: 'hola'),
              ],
              correctOptionId: 'option.hola',
            ),
            ExerciseTemplate(
              id: 'template.granular.text',
              exerciseType: 'text_entry',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Type the Spanish word for "hello".',
              expectedAnswer: 'hola',
            ),
            ExerciseTemplate(
              id: 'template.granular.fill',
              exerciseType: 'fill_gap',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate:
                  'Complete with the Spanish word for "hello": ____.',
              expectedAnswer: 'hola',
            ),
          ],
        ),
      ],
    ),
  ],
);

const _interleavedLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'lesson.interleaved',
      title: 'Interleaved Lesson',
      description: 'Exercise content interleaving.',
      moduleId: 'module.interleaved',
      courseId: 'course.interleaved',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.interleaved',
        description: 'Verify interleaved content steps.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.interleaved',
        title: 'Interleaved Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.interleaved',
            title: 'Interleaved',
            type: 'mixed',
            order: 1,
          ),
        ],
      ),
    ],
    completionCriteria: LessonCompletionCriteria(minimumCompletedActivities: 1),
    references: [],
  ),
  sections: [
    LessonContentSection(
      section: LessonSection(
        id: 'section.interleaved',
        title: 'Interleaved Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.interleaved',
            title: 'Interleaved',
            type: 'mixed',
            order: 1,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.interleaved',
            title: 'Interleaved',
            type: 'mixed',
            order: 1,
          ),
          resolvedContent: [
            VocabularyItem(
              id: 'vocab.interleaved',
              spanish: 'adiós',
              nativeTranslation: 'goodbye',
              cefr: 'A0',
              example: 'Adiós.',
            ),
            ExerciseTemplate(
              id: 'template.interleaved.text',
              exerciseType: 'text_entry',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Type the Spanish word for "goodbye".',
              expectedAnswer: 'adiós',
            ),
            ReadingText(
              id: 'reading.interleaved',
              title: 'Goodbye',
              vocabularyIds: ['vocab.interleaved'],
              grammarIds: [],
              text: 'Adiós.',
              nativeTranslation: 'Goodbye.',
            ),
          ],
        ),
      ],
    ),
  ],
);
