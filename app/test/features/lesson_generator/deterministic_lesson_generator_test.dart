import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_generator/deterministic_lesson_generator.dart';
import 'package:tutor_language/features/lesson_generator/lesson_generation_models.dart';

void main() {
  const generator = DeterministicLessonGenerator();
  const goal = LessonGoal(
    id: 'goal.greetings',
    description: 'Practice greetings.',
    primaryObjectiveId: 'objective.greetings',
  );

  test('generates the same lesson session for the same input', () {
    const input = LessonGenerationInput(
      lessonDefinition: _lessonDefinition,
      goal: goal,
      constraints: LessonConstraints(),
    );

    final first = generator.generate(input);
    final second = generator.generate(input);

    expect(first.id, second.id);
    expect(first.lessonDefinitionId, 'lesson.greetings');
    expect(first.activities.map((activity) => activity.lessonActivityId), [
      'activity.vocabulary',
      'activity.exercise',
    ]);
  });

  test('orders generated activities by section order and activity order', () {
    final session = generator.generate(
      const LessonGenerationInput(
        lessonDefinition: _outOfOrderLessonDefinition,
        goal: goal,
        constraints: LessonConstraints(),
      ),
    );

    expect(session.activities.map((activity) => activity.lessonActivityId), [
      'activity.first',
      'activity.second',
      'activity.third',
    ]);
  });

  test('creates generated exercise placeholders from exercise templates', () {
    final session = generator.generate(
      const LessonGenerationInput(
        lessonDefinition: _lessonDefinition,
        goal: goal,
        constraints: LessonConstraints(),
      ),
    );

    expect(session.generatedExercises, hasLength(1));
    expect(
      session.generatedExercises.single.templateReference.assetPath,
      'assets/languages/spanish/templates/greetings.json',
    );
  });

  test('does not mutate lesson definitions', () {
    final before = _lessonDefinition.activities.length;

    generator.generate(
      const LessonGenerationInput(
        lessonDefinition: _lessonDefinition,
        goal: goal,
        constraints: LessonConstraints(),
      ),
    );

    expect(_lessonDefinition.activities, hasLength(before));
  });

  test('rejects constraints the lesson definition cannot satisfy', () {
    expect(
      () => generator.generate(
        const LessonGenerationInput(
          lessonDefinition: _lessonDefinition,
          goal: goal,
          constraints: LessonConstraints(requiredActivityTypes: ['dialogue']),
        ),
      ),
      throwsA(isA<LessonGenerationException>()),
    );
  });

  test('rejects sessions exceeding max activity count', () {
    expect(
      () => generator.generate(
        const LessonGenerationInput(
          lessonDefinition: _lessonDefinition,
          goal: goal,
          constraints: LessonConstraints(maxActivityCount: 1),
        ),
      ),
      throwsA(isA<LessonGenerationException>()),
    );
  });
}

const _lessonDefinition = Lesson(
  metadata: LessonMetadata(
    id: 'lesson.greetings',
    title: 'Greetings',
    moduleId: 'module.first',
    courseId: 'course.spanish',
    estimatedDurationMinutes: 10,
    difficulty: 'A0',
    tags: [],
    version: '1.0.0',
    prerequisites: [],
  ),
  objectives: [
    LessonObjective(
      id: 'objective.greetings',
      description: 'Recognize greetings.',
    ),
  ],
  sections: [
    LessonSection(
      id: 'section.main',
      title: 'Main',
      order: 1,
      activities: [
        LessonActivity(
          id: 'activity.vocabulary',
          title: 'Vocabulary',
          type: 'vocabulary',
          order: 1,
          references: [
            LessonActivityReference(
              type: 'vocabulary',
              assetPath: 'assets/languages/spanish/vocabulary/greetings.json',
            ),
          ],
        ),
        LessonActivity(
          id: 'activity.exercise',
          title: 'Exercise',
          type: 'exercise',
          order: 2,
          references: [
            LessonActivityReference(
              type: 'exercise_template',
              assetPath: 'assets/languages/spanish/templates/greetings.json',
            ),
          ],
        ),
      ],
    ),
  ],
  summary: LessonSummary(
    id: 'summary.greetings',
    reviewPrompt: 'Review greetings.',
    referenceIds: ['objective.greetings'],
  ),
  completionCriteria: LessonCompletionCriteria(
    requiredActivities: ['activity.vocabulary'],
    minimumCompletedActivities: 1,
    mandatorySections: ['section.main'],
  ),
);

const _outOfOrderLessonDefinition = Lesson(
  metadata: LessonMetadata(
    id: 'lesson.ordering',
    title: 'Ordering',
    moduleId: 'module.first',
    courseId: 'course.spanish',
    estimatedDurationMinutes: 10,
    difficulty: 'A0',
    tags: [],
    version: '1.0.0',
    prerequisites: [],
  ),
  objectives: [
    LessonObjective(
      id: 'objective.ordering',
      description: 'Keep deterministic order.',
    ),
  ],
  sections: [
    LessonSection(
      id: 'section.two',
      title: 'Second',
      order: 2,
      activities: [
        LessonActivity(
          id: 'activity.third',
          title: 'Third',
          type: 'reading',
          order: 1,
        ),
      ],
    ),
    LessonSection(
      id: 'section.one',
      title: 'First',
      order: 1,
      activities: [
        LessonActivity(
          id: 'activity.second',
          title: 'Second',
          type: 'grammar',
          order: 2,
        ),
        LessonActivity(
          id: 'activity.first',
          title: 'First',
          type: 'vocabulary',
          order: 1,
        ),
      ],
    ),
  ],
  summary: LessonSummary(
    id: 'summary.ordering',
    reviewPrompt: 'Review deterministic ordering.',
    referenceIds: ['objective.ordering'],
  ),
  completionCriteria: LessonCompletionCriteria(
    requiredActivities: ['activity.first'],
    minimumCompletedActivities: 1,
    mandatorySections: ['section.one'],
  ),
);
