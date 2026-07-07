import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/curriculum/lesson_order_service.dart';

void main() {
  const service = LessonOrderService();

  test('lesson order is preserved across modules', () {
    expect(service.orderedLessons(_course).map((lesson) => lesson.id), [
      'lesson.one',
      'lesson.two',
      'lesson.three',
    ]);
  });

  test('previous lesson works', () {
    expect(service.previousLesson(_course, 'lesson.three')!.id, 'lesson.two');
  });

  test('next lesson works', () {
    expect(service.nextLesson(_course, 'lesson.one')!.id, 'lesson.two');
  });

  test('first lesson has no previous', () {
    expect(service.previousLesson(_course, 'lesson.one'), isNull);
    expect(service.isFirstLesson(_course, 'lesson.one'), isTrue);
  });

  test('last lesson has no next', () {
    expect(service.nextLesson(_course, 'lesson.three'), isNull);
    expect(service.isLastLesson(_course, 'lesson.three'), isTrue);
  });
}

const _activity = LessonActivity(
  id: 'activity.vocabulary',
  title: 'Vocabulary',
  type: 'vocabulary',
  contentReferences: [
    LessonContentReference(
      type: 'vocabulary',
      assetPath: 'assets/languages/spanish/vocabulary/greetings.json',
    ),
  ],
);

const _completionCriteria = LessonCompletionCriteria(
  type: 'checked_answers',
  minimumCheckedAnswers: 1,
  requiresAllCheckedAnswersCorrect: true,
);

const _course = Course(
  id: 'course.one',
  languageId: 'spanish',
  title: 'Course One',
  level: 'A0',
  version: '1.0.0',
  modules: [
    Module(
      id: 'module.one',
      title: 'Module One',
      lessonIds: ['lesson.one', 'lesson.two'],
    ),
    Module(id: 'module.two', title: 'Module Two', lessonIds: ['lesson.three']),
  ],
  lessons: [
    Lesson(
      id: 'lesson.one',
      moduleId: 'module.one',
      title: 'One',
      primaryObjective: LessonObjective(
        id: 'objective.one',
        description: 'One',
      ),
      activities: [_activity],
      prerequisites: [],
      estimatedDurationMinutes: 10,
      completionCriteria: _completionCriteria,
    ),
    Lesson(
      id: 'lesson.two',
      moduleId: 'module.one',
      title: 'Two',
      primaryObjective: LessonObjective(
        id: 'objective.two',
        description: 'Two',
      ),
      activities: [_activity],
      prerequisites: [],
      estimatedDurationMinutes: 10,
      completionCriteria: _completionCriteria,
    ),
    Lesson(
      id: 'lesson.three',
      moduleId: 'module.two',
      title: 'Three',
      primaryObjective: LessonObjective(
        id: 'objective.three',
        description: 'Three',
      ),
      activities: [_activity],
      prerequisites: [],
      estimatedDurationMinutes: 10,
      completionCriteria: _completionCriteria,
    ),
  ],
);
