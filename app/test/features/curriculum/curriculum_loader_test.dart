import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart'
    as curriculum;
import 'package:tutor_language/features/curriculum/curriculum_validator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parses LanguagePackManifest from bundled language JSON', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final manifest = await loader.loadManifest();

    expect(manifest.id, 'spanish');
    expect(manifest.code, 'es');
    expect(manifest.englishName, 'Spanish');
    expect(manifest.textDirection, 'ltr');
  });

  test('parses Spanish A0 course, modules, and lessons', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final course = await loader.loadCourse();

    expect(course.id, 'es.a0');
    expect(course.languageId, 'spanish');
    expect(course.title, 'Spanish A0');
    expect(course.level, 'A0');
    expect(course.modules, hasLength(5));
    expect(course.lessons, hasLength(15));
    expect(course.modules.first.title, 'First Contact');
    expect(course.lessons.first.title, 'Hello and Goodbye');
    expect(course.lessons.first.metadata, isNotNull);
    expect(course.lessons.first.objectives, hasLength(1));
    expect(course.lessons.first.sections, hasLength(1));
    expect(course.lessons.first.sections.first.activities, hasLength(4));
    expect(course.lessons.first.summary, isNotNull);
    expect(course.lessons.first.completionCriteria.requiredActivities, [
      'activity.vocabulary.greetings',
      'activity.dialogue.hello_goodbye',
      'activity.reading.greeting_recognition',
      'activity.practice.greetings',
    ]);
  });

  test('parses canonical lesson schema example', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final lesson = await loader.loadLesson(
      path: 'assets/languages/spanish/curriculum/lesson_schema_example.json',
    );

    expect(lesson.id, 'lesson.placeholder.v1');
    expect(lesson.courseId, 'course.placeholder.v1');
    expect(lesson.sections.single.activities, hasLength(2));
    expect(
      lesson.activities.first.references.single.referenceId,
      'vocabulary.placeholder.v1',
    );
    expect(lesson.summary!.referenceIds, ['objective.placeholder.v1']);
    expect(lesson.completionCriteria.requiredActivities, [
      'activity.placeholder.vocabulary.v1',
    ]);
  });

  test('parses all standalone Spanish A0 LessonDefinition files', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);
    final course = await loader.loadCourse();
    final courseLessonsById = {
      for (final lesson in course.lessons) lesson.id: lesson,
    };
    final rawIndex = await rootBundle.loadString(
      'assets/languages/spanish/curriculum/lessons/index.json',
    );
    final index = jsonDecode(rawIndex) as Map<String, dynamic>;
    final paths = (index['lessonDefinitionPaths'] as List).cast<String>();

    expect(paths, hasLength(32));

    final lessonIds = <String>{};

    for (final path in paths) {
      final lesson = await loader.loadLesson(path: path);

      expect(path, endsWith('${lesson.id}.json'));
      expect(lessonIds.add(lesson.id), isTrue, reason: path);
      expect(lesson.courseId, course.id);
      expect(lesson.title, isNotEmpty);
      expect(lesson.primaryObjective?.description, isNotEmpty);
      expect(lesson.activities, isNotEmpty);

      final courseLesson = courseLessonsById[lesson.id];
      if (courseLesson != null) {
        expect(lesson.title, courseLesson.title);
        expect(lesson.moduleId, courseLesson.moduleId);
        expect(
          lesson.primaryObjective?.description,
          courseLesson.primaryObjective?.description,
        );
      }
    }

    expect(lessonIds, hasLength(32));
  });

  test('lesson ids are stable strings', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final course = await loader.loadCourse();

    expect(
      course.lessons.map((lesson) => lesson.id),
      everyElement(startsWith('es.a0.')),
    );
    expect(course.lessons.map((lesson) => lesson.id).toSet(), hasLength(15));
  });

  test('prerequisites reference existing lessons', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final course = await loader.loadCourse();
    final lessonIds = course.lessons.map((lesson) => lesson.id).toSet();

    for (final lesson in course.lessons) {
      for (final prerequisite in lesson.prerequisites) {
        expect(lessonIds, contains(prerequisite.lessonId));
      }
    }
  });

  test('module lesson references resolve', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final course = await loader.loadCourse();
    final lessonIds = course.lessons.map((lesson) => lesson.id).toSet();

    for (final module in course.modules) {
      expect(module.lessonIds, isNotEmpty);

      for (final lessonId in module.lessonIds) {
        expect(lessonIds, contains(lessonId));
      }
    }
  });

  test('course languageId matches manifest id', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final manifest = await loader.loadManifest();
    final course = await loader.loadCourse();

    expect(course.languageId, manifest.id);
  });

  test('validator accepts bundled Spanish A0 curriculum skeleton', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);
    const validator = CurriculumValidator();

    final issues = validator.validate(
      manifest: await loader.loadManifest(),
      course: await loader.loadCourse(),
    );

    expect(issues, isEmpty);
  });

  test('validator reports broken curriculum references', () {
    const validator = CurriculumValidator();
    const manifest = curriculum.LanguagePackManifest(
      manifestVersion: 1,
      id: 'spanish',
      code: 'es',
      nativeName: 'Español',
      englishName: 'Spanish',
      version: '1.0.0',
      writingSystem: 'latin',
      textDirection: 'ltr',
    );
    const course = curriculum.Course(
      id: 'es.a0',
      languageId: 'spanish',
      title: 'Spanish A0',
      level: 'A0',
      version: '1.0.0',
      modules: [
        curriculum.Module(
          id: 'es.a0.m01',
          title: 'First Contact',
          lessonIds: ['missing.lesson'],
        ),
      ],
      lessons: [
        curriculum.Lesson(
          id: 'es.a0.m01.l001',
          moduleId: 'missing.module',
          title: '',
          primaryObjective: curriculum.LessonObjective(
            id: 'objective.empty',
            description: '',
          ),
          activities: [
            curriculum.LessonActivity(
              id: 'activity.empty',
              title: 'Empty',
              type: '',
              contentReferences: [],
            ),
          ],
          prerequisites: [
            curriculum.LessonPrerequisite(lessonId: 'missing.prerequisite'),
          ],
          estimatedDurationMinutes: 10,
          completionCriteria: curriculum.LessonCompletionCriteria(
            type: '',
            minimumCheckedAnswers: 0,
            requiresAllCheckedAnswersCorrect: true,
          ),
        ),
      ],
    );

    final issueMessages = validator
        .validate(manifest: manifest, course: course)
        .map((issue) => issue.message);

    expect(issueMessages, contains(contains('Missing lesson reference')));
    expect(issueMessages, contains(contains('missing module')));
    expect(issueMessages, contains(contains('not referenced by any module')));
    expect(issueMessages, contains(contains('Empty lesson title')));
    expect(issueMessages, contains(contains('Empty primary objective')));
    expect(issueMessages, contains(contains('Missing activity type')));
    expect(issueMessages, contains(contains('Invalid prerequisite')));
    expect(issueMessages, contains(contains('Invalid completion criteria')));
  });

  test('validator reports orphan lessons and duplicate activity ids', () {
    const validator = CurriculumValidator();
    const manifest = curriculum.LanguagePackManifest(
      manifestVersion: 1,
      id: 'spanish',
      code: 'es',
      nativeName: 'Español',
      englishName: 'Spanish',
      version: '1.0.0',
      writingSystem: 'latin',
      textDirection: 'ltr',
    );
    const course = curriculum.Course(
      id: 'es.a0',
      languageId: 'spanish',
      title: 'Spanish A0',
      level: 'A0',
      version: '1.0.0',
      modules: [
        curriculum.Module(
          id: 'es.a0.m01',
          title: 'First Contact',
          lessonIds: [],
        ),
      ],
      lessons: [
        curriculum.Lesson(
          id: 'es.a0.m01.l001',
          moduleId: 'es.a0.m01',
          title: 'Hello and Goodbye',
          primaryObjective: curriculum.LessonObjective(
            id: 'objective.greetings.basic',
            description: 'Recognize and use basic greetings and farewells.',
          ),
          activities: [
            curriculum.LessonActivity(
              id: 'activity.same',
              title: 'Vocabulary',
              type: 'vocabulary',
              contentReferences: [],
            ),
            curriculum.LessonActivity(
              id: 'activity.same',
              title: 'Dialogue',
              type: 'dialogue',
              contentReferences: [],
            ),
          ],
          prerequisites: [],
          estimatedDurationMinutes: 10,
          completionCriteria: curriculum.LessonCompletionCriteria(
            type: 'checked_answers',
            minimumCheckedAnswers: 1,
            requiresAllCheckedAnswersCorrect: true,
          ),
        ),
      ],
    );

    final issueMessages = validator
        .validate(manifest: manifest, course: course)
        .map((issue) => issue.message);

    expect(issueMessages, contains(contains('not listed in its module')));
    expect(issueMessages, contains(contains('not referenced by any module')));
    expect(issueMessages, contains(contains('Duplicate activity id')));
  });

  test('validator reports circular prerequisite chains', () {
    const validator = CurriculumValidator();
    const manifest = curriculum.LanguagePackManifest(
      manifestVersion: 1,
      id: 'spanish',
      code: 'es',
      nativeName: 'Español',
      englishName: 'Spanish',
      version: '1.0.0',
      writingSystem: 'latin',
      textDirection: 'ltr',
    );
    const course = curriculum.Course(
      id: 'es.a0',
      languageId: 'spanish',
      title: 'Spanish A0',
      level: 'A0',
      version: '1.0.0',
      modules: [
        curriculum.Module(
          id: 'es.a0.m01',
          title: 'First Contact',
          lessonIds: ['es.a0.m01.l001', 'es.a0.m01.l002'],
        ),
      ],
      lessons: [
        curriculum.Lesson(
          id: 'es.a0.m01.l001',
          moduleId: 'es.a0.m01',
          title: 'Hello and Goodbye',
          primaryObjective: curriculum.LessonObjective(
            id: 'objective.greetings.basic',
            description: 'Recognize and use basic greetings and farewells.',
          ),
          activities: [
            curriculum.LessonActivity(
              id: 'activity.greetings',
              title: 'Greetings',
              type: 'vocabulary',
              contentReferences: [],
            ),
          ],
          prerequisites: [
            curriculum.LessonPrerequisite(lessonId: 'es.a0.m01.l002'),
          ],
          estimatedDurationMinutes: 10,
          completionCriteria: curriculum.LessonCompletionCriteria(
            type: 'checked_answers',
            minimumCheckedAnswers: 1,
            requiresAllCheckedAnswersCorrect: true,
          ),
        ),
        curriculum.Lesson(
          id: 'es.a0.m01.l002',
          moduleId: 'es.a0.m01',
          title: 'Please, Thank You, Sorry',
          primaryObjective: curriculum.LessonObjective(
            id: 'objective.politeness.basic',
            description: 'Recognize and use basic polite expressions.',
          ),
          activities: [
            curriculum.LessonActivity(
              id: 'activity.politeness',
              title: 'Politeness',
              type: 'vocabulary',
              contentReferences: [],
            ),
          ],
          prerequisites: [
            curriculum.LessonPrerequisite(lessonId: 'es.a0.m01.l001'),
          ],
          estimatedDurationMinutes: 10,
          completionCriteria: curriculum.LessonCompletionCriteria(
            type: 'checked_answers',
            minimumCheckedAnswers: 1,
            requiresAllCheckedAnswersCorrect: true,
          ),
        ),
      ],
    );

    final issueMessages = validator
        .validate(manifest: manifest, course: course)
        .map((issue) => issue.message);

    expect(issueMessages, contains(contains('Circular prerequisite chain')));
  });

  test('validator reports lesson schema violations', () {
    const validator = CurriculumValidator();
    const manifest = curriculum.LanguagePackManifest(
      manifestVersion: 1,
      id: 'spanish',
      code: 'es',
      nativeName: 'Español',
      englishName: 'Spanish',
      version: '1.0.0',
      writingSystem: 'latin',
      textDirection: 'ltr',
    );
    final course = curriculum.Course.fromJson({
      'id': 'es.a0',
      'languageId': 'spanish',
      'title': 'Spanish A0',
      'level': 'A0',
      'version': '1.0.0',
      'modules': [
        {
          'id': 'es.a0.m01',
          'title': 'First Contact',
          'lessonIds': ['es.a0.m01.l001'],
        },
      ],
      'lessons': [
        {
          'metadata': {
            'id': 'es.a0.m01.l001',
            'title': 'Broken Lesson',
            'moduleId': 'es.a0.m01',
            'courseId': 'wrong.course',
            'estimatedDurationMinutes': 0,
            'difficulty': 'A0',
            'tags': [],
            'version': '1.0.0',
            'prerequisites': [],
          },
          'objectives': [
            {'id': 'objective.empty', 'description': 'Broken objective.'},
          ],
          'sections': [
            {
              'id': 'section.same',
              'title': 'One',
              'order': 1,
              'activities': [
                {
                  'id': 'activity.same',
                  'title': 'Activity One',
                  'type': 'vocabulary',
                  'order': 1,
                  'references': [
                    {'type': 'vocabulary', 'assetPath': 'bad/path.json'},
                  ],
                },
              ],
            },
            {
              'id': 'section.same',
              'title': 'Two',
              'order': 1,
              'activities': [
                {
                  'id': 'activity.same',
                  'title': 'Bad Activity',
                  'type': 'dialogue',
                  'order': 0,
                  'references': [],
                },
              ],
            },
          ],
          'summary': {
            'id': 'summary.broken',
            'reviewPrompt': ' ',
            'referenceIds': ['missing.reference'],
          },
          'completionCriteria': {
            'requiredActivities': ['missing.activity'],
            'minimumCompletedActivities': 3,
            'mandatorySections': ['missing.section'],
          },
          'references': [],
        },
      ],
    });

    final issueMessages = validator
        .validate(manifest: manifest, course: course)
        .map((issue) => issue.message);

    expect(issueMessages, contains(contains('courseId does not match')));
    expect(issueMessages, contains(contains('Invalid estimated duration')));
    expect(issueMessages, contains(contains('Duplicate section id')));
    expect(issueMessages, contains(contains('Duplicate section order')));
    expect(issueMessages, contains(contains('Duplicate activity id')));
    expect(issueMessages, contains(contains('Invalid activity reference')));
    expect(issueMessages, contains(contains('Invalid activity')));
    expect(issueMessages, contains(contains('missing activity')));
    expect(issueMessages, contains(contains('missing section')));
    expect(issueMessages, contains(contains('Empty lesson summary')));
    expect(issueMessages, contains(contains('Summary references unknown')));
  });
}
