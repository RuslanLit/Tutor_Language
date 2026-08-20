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
    expect(course.title, 'Іспанська A0');
    expect(course.level, 'A0');
    expect(course.modules, hasLength(3));
    expect(course.lessons, hasLength(10));
    expect(course.modules.first.title, 'Модуль 1');
    expect(course.modules.first.lessonIds, [
      'es.a0.m01.l001',
      'es.a0.m01.l002',
      'es.a0.m01.l003',
      'es.a0.m01.l004',
      'es.a0.m01.l005',
      'es.a0.m01.l006',
      'es.a0.m01.l007',
    ]);
    expect(course.lessons.first.title, 'Урок 1');
    expect(course.lessons.last.title, 'Де ти живеш?');
    expect(course.lessons.first.metadata, isNotNull);
    expect(course.lessons.first.objectives, hasLength(1));
    expect(course.lessons.first.sections, hasLength(1));
    expect(course.lessons.first.sections.first.activities, hasLength(4));
    expect(course.lessons.first.summary, isNotNull);
    expect(course.lessons.first.completionCriteria.requiredActivities, [
      'es.a0.m01.l001.activity.first_contact_exchange',
    ]);
  });

  test(
    'legacy course.json mirror stays synchronized with runtime course',
    () async {
      final runtimeCourse = jsonDecode(
        await rootBundle.loadString(
          'assets/languages/spanish/curriculum/spanish_a0_course.json',
        ),
      );
      final mirrorCourse = jsonDecode(
        await rootBundle.loadString(
          'assets/languages/spanish/curriculum/course.json',
        ),
      );

      expect(mirrorCourse, runtimeCourse);
    },
  );

  test('parses standalone canonical lessons 3 to 5', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);
    final expected = <String, ({String prerequisite, int references})>{
      'es.a0.m01.l003': (prerequisite: 'es.a0.m01.l002', references: 20),
      'es.a0.m01.l004': (prerequisite: 'es.a0.m01.l003', references: 21),
      'es.a0.m01.l005': (prerequisite: 'es.a0.m01.l004', references: 21),
    };

    for (final entry in expected.entries) {
      final lesson = await loader.loadLesson(
        path: 'assets/languages/spanish/curriculum/lessons/${entry.key}.json',
      );

      expect(lesson.id, entry.key);
      expect(lesson.courseId, 'es.a0');
      expect(lesson.prerequisites.single.lessonId, entry.value.prerequisite);
      expect(lesson.sections.single.activities, hasLength(1));
      expect(
        lesson.activities.first.references,
        hasLength(entry.value.references),
      );
      expect(lesson.activities.first.references.last.type, 'exercise_template');
      expect(lesson.summary!.referenceIds.single, startsWith('objective.'));
    }
  });

  test('parses standalone canonical lesson 2', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final lesson = await loader.loadLesson(
      path: 'assets/languages/spanish/curriculum/lessons/es.a0.m01.l002.json',
    );

    expect(lesson.id, 'es.a0.m01.l002');
    expect(lesson.courseId, 'es.a0');
    expect(lesson.prerequisites.single.lessonId, 'es.a0.m01.l001');
    expect(lesson.sections.single.activities, hasLength(1));
    expect(lesson.activities.first.references, hasLength(21));
    expect(
      lesson.activities.first.references.first.referenceId,
      'template.es.a0.m01.l001.independent_full_contact',
    );
    expect(
      lesson.activities.first.references.last.referenceId,
      'template.es.a0.m01.l002.independent_complete_intro_dialogue',
    );
    expect(lesson.summary!.referenceIds, [
      'objective.es.a0.m01.l002.complete_about_myself_intro',
    ]);
    expect(lesson.completionCriteria.requiredActivities, [
      'es.a0.m01.l002.activity.about_myself_exchange',
    ]);
  });

  test('parses standalone canonical lesson', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final lesson = await loader.loadLesson(
      path: 'assets/languages/spanish/curriculum/lessons/es.a0.m01.l001.json',
    );

    expect(lesson.id, 'es.a0.m01.l001');
    expect(lesson.courseId, 'es.a0');
    expect(lesson.sections.single.activities, hasLength(4));
    expect(lesson.activities.first.references, hasLength(13));
    expect(
      lesson.activities.first.references.first.referenceId,
      'grammar.es.a0.m01.l001.first_meeting_goal',
    );
    expect(
      lesson.activities.first.references.last.referenceId,
      'template.es.a0.m01.l001.independent_full_contact',
    );
    expect(lesson.summary!.referenceIds, [
      'objective.es.a0.m01.l001.complete_first_contact',
    ]);
    expect(lesson.completionCriteria.requiredActivities, [
      'es.a0.m01.l001.activity.first_contact_exchange',
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
    final paths = (jsonDecode(rawIndex) as List).cast<String>();

    expect(paths, hasLength(10));

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

    expect(lessonIds, hasLength(10));
  });

  test(
    'canonical lessons 3 to 5 avoid free Ukrainian translation tasks',
    () async {
      for (final path in _canonicalTemplatePaths.skip(2)) {
        final raw = await rootBundle.loadString(path);
        final templates = (jsonDecode(raw) as List)
            .cast<Map<String, Object?>>();

        for (final template in templates) {
          expect(template['exercise_type'], isNot('translation'), reason: path);
          final prompt = template['prompt_template'] as String;
          expect(
            prompt.toLowerCase(),
            isNot(contains('переклади українською')),
            reason: '${template['id']}',
          );

          final expectedAnswer = template['expected_answer'] as String?;
          if (expectedAnswer != null && expectedAnswer.contains('\n')) {
            expect(
              prompt,
              contains('Напиши кожну відповідь з нового рядка.'),
              reason:
                  'Multiline task must explain line separation: ${template['id']}',
            );
          }
        }
      }
    },
  );

  test(
    'canonical Ukrainian learner-facing content has no forbidden Russian letters',
    () async {
      final forbiddenRussianLetters = RegExp('[эёыъ]');

      for (final path in _canonicalUkrainianAuditPaths) {
        final raw = await rootBundle.loadString(path);

        expect(forbiddenRussianLetters.hasMatch(raw), isFalse, reason: path);
      }
    },
  );

  test('lesson ids are stable strings', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final course = await loader.loadCourse();

    expect(
      course.lessons.map((lesson) => lesson.id),
      everyElement(startsWith('es.a0.')),
    );
    expect(course.lessons.map((lesson) => lesson.id).toSet(), hasLength(10));

    expect(course.lessons.skip(5).map((lesson) => lesson.id), [
      'es.a0.m01.l006',
      'es.a0.m01.l007',
      'es.a0.m02.l008',
      'es.a0.m03.l009',
      'es.a0.m03.l010',
    ]);
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
          title: 'Hola and Goodbye',
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
          title: 'Hola and Goodbye',
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

const _canonicalTemplatePaths = [
  'assets/languages/spanish/templates/canonical_lesson_1.json',
  'assets/languages/spanish/templates/canonical_lesson_2.json',
  'assets/languages/spanish/templates/canonical_lesson_3.json',
  'assets/languages/spanish/templates/canonical_lesson_4.json',
  'assets/languages/spanish/templates/canonical_lesson_5.json',
];

const _canonicalUkrainianAuditPaths = [
  'assets/languages/spanish/curriculum/course.json',
  'assets/languages/spanish/curriculum/lessons/es.a0.m01.l003.json',
  'assets/languages/spanish/curriculum/lessons/es.a0.m01.l004.json',
  'assets/languages/spanish/curriculum/lessons/es.a0.m01.l005.json',
  'assets/languages/spanish/dialogues/canonical_lesson_3.json',
  'assets/languages/spanish/dialogues/canonical_lesson_4.json',
  'assets/languages/spanish/dialogues/canonical_lesson_5.json',
  'assets/languages/spanish/grammar/canonical_lesson_3.json',
  'assets/languages/spanish/grammar/canonical_lesson_4.json',
  'assets/languages/spanish/grammar/canonical_lesson_5.json',
  'assets/languages/spanish/templates/canonical_lesson_3.json',
  'assets/languages/spanish/templates/canonical_lesson_4.json',
  'assets/languages/spanish/templates/canonical_lesson_5.json',
  'assets/languages/spanish/vocabulary/canonical_lesson_3.json',
  'assets/languages/spanish/vocabulary/canonical_lesson_4.json',
  'assets/languages/spanish/vocabulary/canonical_lesson_5.json',
];
