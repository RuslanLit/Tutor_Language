import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/features/course_navigation/course_navigation_models.dart';
import 'package:tutor_language/features/course_navigation/course_navigation_service.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = CourseNavigationService();

  test('empty course returns stable navigation state', () {
    final state = service.buildNavigationState(
      course: const Course(
        id: 'course.empty',
        languageId: 'spanish',
        title: 'Empty Course',
        level: 'A0',
        version: '1.0.0',
        modules: [],
        lessons: [],
      ),
      completedLessonIds: {},
    );

    expect(state.units, isEmpty);
    expect(state.nextLessonId, isNull);
    expect(state.isCourseCompleted, isFalse);
    expect(state.completedLessonCount, 0);
    expect(state.totalLessonCount, 0);
  });

  test('first lesson is available with no progress', () {
    final state = service.buildNavigationState(
      course: _course,
      completedLessonIds: {},
    );

    expect(state.nextLessonId, 'lesson.alpha');
    expect(_statuses(state), [
      LessonNavigationStatus.available,
      LessonNavigationStatus.locked,
      LessonNavigationStatus.locked,
    ]);
  });

  test(
    'completed lessons remain accessible and unlock first incomplete lesson',
    () {
      final state = service.buildNavigationState(
        course: _course,
        completedLessonIds: {'lesson.alpha'},
      );

      expect(state.nextLessonId, 'lesson.beta');
      expect(_statuses(state), [
        LessonNavigationStatus.completed,
        LessonNavigationStatus.available,
        LessonNavigationStatus.locked,
      ]);
      expect(state.units.first.lessons.first.isTappable, isTrue);
      expect(state.units.last.lessons.single.isTappable, isFalse);
    },
  );

  test('progression crosses unit boundaries', () {
    final state = service.buildNavigationState(
      course: _course,
      completedLessonIds: {'lesson.alpha', 'lesson.beta'},
    );

    expect(state.nextLessonId, 'lesson.gamma');
    expect(state.units.first.isCompleted, isTrue);
    expect(
      state.units.last.lessons.single.status,
      LessonNavigationStatus.available,
    );
  });

  test('final lesson completion marks course completed', () {
    final state = service.buildNavigationState(
      course: _course,
      completedLessonIds: {'lesson.alpha', 'lesson.beta', 'lesson.gamma'},
    );

    expect(state.nextLessonId, isNull);
    expect(state.isCourseCompleted, isTrue);
    expect(state.completedLessonCount, 3);
  });

  test('unknown completed lesson ids are ignored', () {
    final state = service.buildNavigationState(
      course: _course,
      completedLessonIds: {'lesson.unknown'},
    );

    expect(state.completedLessonCount, 0);
    expect(state.nextLessonId, 'lesson.alpha');
  });

  test('bundled Spanish A0 course exposes ordered beginner lessons', () async {
    final course = await CurriculumLoader(assetBundle: rootBundle).loadCourse();
    final state = service.buildNavigationState(
      course: course,
      completedLessonIds: {},
    );
    final module1 = state.units.singleWhere(
      (unit) => unit.unitId == 'es.a0.m01',
    );

    expect(course.title, 'Іспанська A0');
    expect(module1.title, 'Модуль 1');
    expect(module1.lessons.map((lesson) => lesson.lessonId), [
      'es.a0.m01.l001',
      'es.a0.m01.l002',
      'es.a0.m01.l003',
      'es.a0.m01.l004',
      'es.a0.m01.l005',
      'es.a0.m01.l006',
      'es.a0.m01.l007',
    ]);
    expect(module1.lessons.first.title, 'Урок 1');
    expect(module1.lessons[1].title, 'Урок 2');
    expect(module1.lessons[2].title, 'Ввічлива розмова');
    expect(module1.lessons[3].title, 'Люди навколо нас');
    expect(module1.lessons[4].title, 'Проста розмова про людину');
    expect(module1.lessons[5].title, 'Привітання в розмові');
    expect(module1.lessons[6].title, 'Як підтримати розмову');
    expect(module1.lessons.first.position.indexInCourse, 1);
    expect(module1.lessons.last.position.indexInCourse, 7);
    expect(module1.lessons.first.position.totalLessons, 10);
    expect(module1.lessons.last.position.totalLessons, 10);
    expect(state.nextLessonId, 'es.a0.m01.l001');
    expect(module1.lessons.first.status, LessonNavigationStatus.available);
    expect(module1.lessons.skip(1).map((lesson) => lesson.status), [
      LessonNavigationStatus.locked,
      LessonNavigationStatus.locked,
      LessonNavigationStatus.locked,
      LessonNavigationStatus.locked,
      LessonNavigationStatus.locked,
      LessonNavigationStatus.locked,
    ]);

    final completedState = service.buildNavigationState(
      course: course,
      completedLessonIds: module1.lessons
          .map((lesson) => lesson.lessonId)
          .toSet(),
    );
    expect(completedState.nextLessonId, 'es.a0.m02.l008');
    expect(completedState.isCourseCompleted, isFalse);
  });

  test(
    'non-contiguous completion does not unlock past first incomplete lesson',
    () {
      final state = service.buildNavigationState(
        course: _fourLessonCourse,
        completedLessonIds: {'lesson.one', 'lesson.three'},
      );

      expect(state.nextLessonId, 'lesson.two');
      expect(_statuses(state), [
        LessonNavigationStatus.completed,
        LessonNavigationStatus.available,
        LessonNavigationStatus.completed,
        LessonNavigationStatus.locked,
      ]);
    },
  );

  test('empty unit between populated units does not break progression', () {
    final state = service.buildNavigationState(
      course: _courseWithEmptyUnit,
      completedLessonIds: {'lesson.before.empty'},
    );

    expect(state.nextLessonId, 'lesson.after.empty');
    expect(state.units[1].lessons, isEmpty);
    expect(
      state.units[2].lessons.single.status,
      LessonNavigationStatus.available,
    );
  });

  test('curriculum order is preserved and not derived from ids', () {
    final ordered = service.orderedCourseLessons(_unorderedIdCourse);

    expect(ordered.map((entry) => entry.lesson.id), ['lesson.z', 'lesson.a']);
    expect(ordered.map((entry) => entry.position.indexInCourse), [1, 2]);

    final state = service.buildNavigationState(
      course: _unorderedIdCourse,
      completedLessonIds: {'lesson.z'},
    );

    expect(state.nextLessonId, 'lesson.a');
  });
}

List<LessonNavigationStatus> _statuses(CourseNavigationState state) {
  return [
    for (final unit in state.units)
      for (final lesson in unit.lessons) lesson.status,
  ];
}

const _course = Course(
  id: 'course.test',
  languageId: 'spanish',
  title: 'Spanish A0',
  level: 'A0',
  version: '1.0.0',
  modules: [
    Module(
      id: 'unit.1',
      title: 'Unit 1',
      lessonIds: ['lesson.alpha', 'lesson.beta'],
    ),
    Module(id: 'unit.2', title: 'Unit 2', lessonIds: ['lesson.gamma']),
  ],
  lessons: [
    Lesson(
      id: 'lesson.alpha',
      moduleId: 'unit.1',
      title: 'Alpha',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
    Lesson(
      id: 'lesson.beta',
      moduleId: 'unit.1',
      title: 'Beta',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
    Lesson(
      id: 'lesson.gamma',
      moduleId: 'unit.2',
      title: 'Gamma',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
  ],
);

const _unorderedIdCourse = Course(
  id: 'course.unordered',
  languageId: 'spanish',
  title: 'Spanish A0',
  level: 'A0',
  version: '1.0.0',
  modules: [
    Module(id: 'unit.1', title: 'Unit 1', lessonIds: ['lesson.z', 'lesson.a']),
  ],
  lessons: [
    Lesson(
      id: 'lesson.a',
      moduleId: 'unit.1',
      title: 'A',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
    Lesson(
      id: 'lesson.z',
      moduleId: 'unit.1',
      title: 'Z',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
  ],
);

const _fourLessonCourse = Course(
  id: 'course.four',
  languageId: 'spanish',
  title: 'Spanish A0',
  level: 'A0',
  version: '1.0.0',
  modules: [
    Module(
      id: 'unit.1',
      title: 'Unit 1',
      lessonIds: ['lesson.one', 'lesson.two', 'lesson.three', 'lesson.four'],
    ),
  ],
  lessons: [
    Lesson(
      id: 'lesson.one',
      moduleId: 'unit.1',
      title: 'One',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
    Lesson(
      id: 'lesson.two',
      moduleId: 'unit.1',
      title: 'Two',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
    Lesson(
      id: 'lesson.three',
      moduleId: 'unit.1',
      title: 'Three',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
    Lesson(
      id: 'lesson.four',
      moduleId: 'unit.1',
      title: 'Four',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
  ],
);

const _courseWithEmptyUnit = Course(
  id: 'course.empty.unit',
  languageId: 'spanish',
  title: 'Spanish A0',
  level: 'A0',
  version: '1.0.0',
  modules: [
    Module(id: 'unit.1', title: 'Unit 1', lessonIds: ['lesson.before.empty']),
    Module(id: 'unit.empty', title: 'Empty Unit', lessonIds: []),
    Module(id: 'unit.2', title: 'Unit 2', lessonIds: ['lesson.after.empty']),
  ],
  lessons: [
    Lesson(
      id: 'lesson.before.empty',
      moduleId: 'unit.1',
      title: 'Before',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
    Lesson(
      id: 'lesson.after.empty',
      moduleId: 'unit.2',
      title: 'After',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
  ],
);
