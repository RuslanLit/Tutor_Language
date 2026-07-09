import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_assembly_service.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_content.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_providers.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('loads and renders the reference assembled lesson', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const LessonPlayerScreen(lessonId: _lessonId)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hello and Goodbye'), findsOneWidget);
    expect(find.text('vocabulary'), findsWidgets);
    expect(find.text('grammar'), findsWidgets);
    expect(find.text('dialogue'), findsWidgets);
    expect(find.text('reading'), findsWidgets);
    expect(find.text('practice'), findsWidgets);
    expect(find.text('hola'), findsWidgets);
    expect(find.text('Personal pronouns: yo and tú'), findsOneWidget);
    expect(find.text('First Contact'), findsOneWidget);
    expect(find.text('Hola, Soy Ana'), findsOneWidget);
  });

  testWidgets(
    'renders assembled lesson data without hardcoded lesson strings',
    (tester) async {
      await tester.pumpWidget(
        _app(
          const LessonPlayerScreen(lessonId: 'lesson.dynamic'),
          service: _FakeLessonAssemblyService(_dynamicLessonContent),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dynamic Lesson Title'), findsOneWidget);
      expect(find.text('lexema-dinamico'), findsOneWidget);
      expect(find.text('Dynamic grammar explanation.'), findsOneWidget);
      expect(find.text('Dynamic speaker'), findsOneWidget);
      expect(find.text('Dynamic reading text.'), findsOneWidget);
      expect(find.text('Dynamic prompt?'), findsOneWidget);
      expect(find.text('Hello and Goodbye'), findsNothing);
    },
  );

  testWidgets('shows error state for an invalid lesson id', (tester) async {
    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'missing.lesson'),
        service: _FailingLessonAssemblyService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Unable to load course content.'),
      findsOneWidget,
    );
    expect(find.textContaining('missing.lesson'), findsOneWidget);
  });

  testWidgets('wrong practice answer shows incorrect feedback', (tester) async {
    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'lesson.interactive'),
        service: _FakeLessonAssemblyService(_interactiveLessonContent),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('wrong option'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('correct practice answer shows correct feedback', (tester) async {
    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'lesson.interactive'),
        service: _FakeLessonAssemblyService(_interactiveLessonContent),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('right option'));
    await tester.pump();
    await tester.tap(find.text('Check'));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
  });

  testWidgets('does not crash when a lesson has no practice activities', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const LessonPlayerScreen(lessonId: 'lesson.no_practice'),
        service: _FakeLessonAssemblyService(_noPracticeLessonContent),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No Practice Lesson'), findsOneWidget);
    expect(find.text('Only Vocabulary'), findsOneWidget);
    expect(find.text('Check'), findsNothing);
  });
}

Widget _app(Widget child, {LessonAssemblyService? service}) {
  return ProviderScope(
    overrides: [
      if (service != null)
        lessonAssemblyServiceProvider.overrideWith((ref) => service),
    ],
    child: MaterialApp(home: child),
  );
}

class _FakeLessonAssemblyService extends LessonAssemblyService {
  _FakeLessonAssemblyService(this.lessonContent);

  final LessonContent lessonContent;

  @override
  Future<LessonContent> assembleLesson(String lessonId) async {
    return lessonContent;
  }
}

class _FailingLessonAssemblyService extends LessonAssemblyService {
  @override
  Future<LessonContent> assembleLesson(String lessonId) async {
    throw LessonAssemblyException('Lesson not found: $lessonId');
  }
}

const _lessonId = 'es.a0.m01.l001';

const _dynamicLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'lesson.dynamic',
      title: 'Dynamic Lesson Title',
      description: 'Dynamic lesson description.',
      moduleId: 'module.dynamic',
      courseId: 'course.dynamic',
      estimatedDurationMinutes: 12,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.dynamic',
        description: 'Render dynamic content.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.dynamic',
        title: 'Dynamic Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.dynamic.vocabulary',
            title: 'Dynamic Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.dynamic.grammar',
            title: 'Dynamic Grammar',
            type: 'grammar',
            order: 2,
          ),
          LessonActivity(
            id: 'activity.dynamic.dialogue',
            title: 'Dynamic Dialogue',
            type: 'dialogue',
            order: 3,
          ),
          LessonActivity(
            id: 'activity.dynamic.reading',
            title: 'Dynamic Reading',
            type: 'reading',
            order: 4,
          ),
          LessonActivity(
            id: 'activity.dynamic.practice',
            title: 'Dynamic Practice',
            type: 'exercise_template',
            order: 5,
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
        id: 'section.dynamic',
        title: 'Dynamic Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.dynamic.vocabulary',
            title: 'Dynamic Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          LessonActivity(
            id: 'activity.dynamic.grammar',
            title: 'Dynamic Grammar',
            type: 'grammar',
            order: 2,
          ),
          LessonActivity(
            id: 'activity.dynamic.dialogue',
            title: 'Dynamic Dialogue',
            type: 'dialogue',
            order: 3,
          ),
          LessonActivity(
            id: 'activity.dynamic.reading',
            title: 'Dynamic Reading',
            type: 'reading',
            order: 4,
          ),
          LessonActivity(
            id: 'activity.dynamic.practice',
            title: 'Dynamic Practice',
            type: 'exercise_template',
            order: 5,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.dynamic.vocabulary',
            title: 'Dynamic Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          resolvedContent: [
            VocabularyItem(
              id: 'vocab.dynamic',
              spanish: 'lexema-dinamico',
              nativeTranslation: 'dynamic word',
              cefr: 'A0',
              example: 'Dynamic example.',
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.dynamic.grammar',
            title: 'Dynamic Grammar',
            type: 'grammar',
            order: 2,
          ),
          resolvedContent: [
            GrammarTopic(
              id: 'grammar.dynamic',
              title: 'Dynamic Grammar Topic',
              explanation: 'Dynamic grammar explanation.',
              examples: ['Dynamic grammar example.'],
              prerequisiteIds: [],
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.dynamic.dialogue',
            title: 'Dynamic Dialogue',
            type: 'dialogue',
            order: 3,
          ),
          resolvedContent: [
            Dialogue(
              id: 'dialogue.dynamic',
              title: 'Dynamic Dialogue Title',
              vocabularyIds: [],
              grammarIds: [],
              lines: [
                DialogueLine(
                  speaker: 'Dynamic speaker',
                  spanish: 'Dynamic line.',
                  nativeTranslation: 'Dynamic translation.',
                ),
              ],
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.dynamic.reading',
            title: 'Dynamic Reading',
            type: 'reading',
            order: 4,
          ),
          resolvedContent: [
            ReadingText(
              id: 'reading.dynamic',
              title: 'Dynamic Reading Title',
              vocabularyIds: [],
              grammarIds: [],
              text: 'Dynamic reading text.',
              nativeTranslation: 'Dynamic reading translation.',
            ),
          ],
        ),
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.dynamic.practice',
            title: 'Dynamic Practice',
            type: 'exercise_template',
            order: 5,
          ),
          resolvedContent: [
            ExerciseTemplate(
              id: 'template.dynamic',
              exerciseType: 'multiple_choice',
              supportedGoalTypes: ['dynamic_goal'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Dynamic prompt?',
              answerOptions: [
                ExerciseTemplateOption(id: 'option.dynamic', label: 'Dynamic'),
              ],
              correctOptionId: 'option.dynamic',
            ),
          ],
        ),
      ],
    ),
  ],
);

const _interactiveLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'lesson.interactive',
      title: 'Interactive Lesson',
      description: 'Interactive lesson description.',
      moduleId: 'module.interactive',
      courseId: 'course.interactive',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.interactive',
        description: 'Check local practice feedback.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.interactive',
        title: 'Interactive Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.interactive.practice',
            title: 'Interactive Practice',
            type: 'exercise_template',
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
        id: 'section.interactive',
        title: 'Interactive Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.interactive.practice',
            title: 'Interactive Practice',
            type: 'exercise_template',
            order: 1,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.interactive.practice',
            title: 'Interactive Practice',
            type: 'exercise_template',
            order: 1,
          ),
          resolvedContent: [
            ExerciseTemplate(
              id: 'template.interactive.choice',
              exerciseType: 'multiple_choice',
              supportedGoalTypes: ['review_vocabulary'],
              requiredObjectTypes: ['vocabulary'],
              promptTemplate: 'Choose the right option.',
              answerOptions: [
                ExerciseTemplateOption(
                  id: 'option.wrong',
                  label: 'wrong option',
                ),
                ExerciseTemplateOption(
                  id: 'option.right',
                  label: 'right option',
                ),
              ],
              correctOptionId: 'option.right',
            ),
          ],
        ),
      ],
    ),
  ],
);

const _noPracticeLessonContent = LessonContent(
  lesson: Lesson(
    metadata: LessonMetadata(
      id: 'lesson.no_practice',
      title: 'No Practice Lesson',
      description: 'No practice lesson description.',
      moduleId: 'module.no_practice',
      courseId: 'course.no_practice',
      estimatedDurationMinutes: 5,
      difficulty: 'A0',
      tags: [],
      version: '1.0.0',
      prerequisites: [],
    ),
    objectives: [
      LessonObjective(
        id: 'objective.no_practice',
        description: 'Render without practice.',
      ),
    ],
    sections: [
      LessonSection(
        id: 'section.no_practice',
        title: 'No Practice Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.no_practice.vocabulary',
            title: 'Only Vocabulary',
            type: 'vocabulary',
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
        id: 'section.no_practice',
        title: 'No Practice Section',
        order: 1,
        activities: [
          LessonActivity(
            id: 'activity.no_practice.vocabulary',
            title: 'Only Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
        ],
      ),
      activities: [
        LessonContentActivity(
          activity: LessonActivity(
            id: 'activity.no_practice.vocabulary',
            title: 'Only Vocabulary',
            type: 'vocabulary',
            order: 1,
          ),
          resolvedContent: [
            VocabularyItem(
              id: 'vocab.no_practice',
              spanish: 'sin-practica',
              nativeTranslation: 'without practice',
              cefr: 'A0',
              example: 'Sin práctica.',
            ),
          ],
        ),
      ],
    ),
  ],
);
