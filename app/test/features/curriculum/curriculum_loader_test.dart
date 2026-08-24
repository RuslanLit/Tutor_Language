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

  test('parses Spanish A0 to A1 course, modules, and lessons', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);

    final course = await loader.loadCourse();

    expect(course.id, 'es.a0');
    expect(course.languageId, 'spanish');
    expect(course.title, 'Іспанська A0 → A1');
    expect(course.level, 'A0–A1');
    expect(course.modules, hasLength(10));
    expect(course.lessons, hasLength(42));
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
    expect(course.lessons[36].title, 'Підсумкова перевірка A0');
    expect(course.lessons.last.title, 'Перевірка щоденного ритму');
    expect(course.lessons.last.metadata?.difficulty, 'A1');
    expect(course.lessons.last.moduleId, 'es.a1.m10');
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

    expect(paths, hasLength(42));

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

    expect(lessonIds, hasLength(42));
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
      everyElement(anyOf(startsWith('es.a0.'), startsWith('es.a1.'))),
    );
    expect(course.lessons.map((lesson) => lesson.id).toSet(), hasLength(42));

    expect(course.lessons.skip(5).map((lesson) => lesson.id), [
      'es.a0.m01.l006',
      'es.a0.m01.l007',
      'es.a0.m02.l008',
      'es.a0.m03.l009',
      'es.a0.m03.l010',
      'es.a0.m04.l011',
      'es.a0.m04.l012',
      'es.a0.m04.l013',
      'es.a0.m05.l014',
      'es.a0.m05.l015',
      'es.a0.m06.l016',
      'es.a0.m06.l017',
      'es.a0.m06.l018',
      'es.a0.m06.l019',
      'es.a0.m06.l020',
      'es.a0.m07.l021',
      'es.a0.m07.l022',
      'es.a0.m07.l023',
      'es.a0.m07.l024',
      'es.a0.m07.l025',
      'es.a0.m08.l026',
      'es.a0.m08.l027',
      'es.a0.m08.l028',
      'es.a0.m08.l029',
      'es.a0.m08.l030',
      'es.a0.m05.l031',
      'es.a0.m05.l032',
      'es.a0.m09.l033',
      'es.a0.m09.l034',
      'es.a0.m09.l035',
      'es.a0.m09.l036',
      'es.a0.m09.l037',
      'es.a1.m10.l038',
      'es.a1.m10.l039',
      'es.a1.m10.l040',
      'es.a1.m10.l041',
      'es.a1.m10.l042',
    ]);
  });

  test('Lessons 36 and 37 provide integrated transfer and final checkpoint',
      () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);
    final lessons =
        (await loader.loadCourse()).lessons.skip(35).take(2).toList();

    expect(lessons.map((lesson) => lesson.id), [
      'es.a0.m09.l036',
      'es.a0.m09.l037',
    ]);
    expect(lessons.last.prerequisites.single.lessonId, 'es.a0.m09.l036');
    for (final lessonNumber in [36, 37]) {
      final raw = await rootBundle.loadString(
        'assets/languages/spanish/templates/canonical_lesson_$lessonNumber.json',
      );
      final templates = (jsonDecode(raw) as List).cast<Map>();
      expect(templates, hasLength(6));
      expect(
        templates.where((template) => template['reading_text'] is String),
        isNotEmpty,
      );
      expect(
        templates.any((template) => template['audio_reference_id'] is String),
        isTrue,
      );
      expect(
        templates.any(
          (template) => template['exercise_type'] == 'guided_dialogue',
        ),
        isTrue,
      );
    }
  });

  test('Lessons 38 to 42 form the first A1 routine batch', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);
    final lessons = (await loader.loadCourse()).lessons.skip(37).toList();

    expect(lessons.map((lesson) => lesson.id), [
      'es.a1.m10.l038',
      'es.a1.m10.l039',
      'es.a1.m10.l040',
      'es.a1.m10.l041',
      'es.a1.m10.l042',
    ]);
    expect(lessons.map((lesson) => lesson.metadata?.difficulty), everyElement('A1'));
    expect(lessons.first.prerequisites.single.lessonId, 'es.a0.m09.l037');
    expect(lessons.last.prerequisites.single.lessonId, 'es.a1.m10.l041');

    for (var lessonNumber = 38; lessonNumber <= 42; lessonNumber++) {
      final raw = await rootBundle.loadString(
        'assets/languages/spanish/templates/canonical_lesson_$lessonNumber.json',
      );
      final templates = (jsonDecode(raw) as List).cast<Map>();
      expect(templates, hasLength(6));
      expect(templates.where((template) => template['reading_text'] is String), isNotEmpty);
      expect(templates.any((template) => template['audio_reference_id'] is String), isTrue);
      expect(templates.any((template) => template['exercise_type'] == 'guided_dialogue'), isTrue);
    }

    final l40Templates = (jsonDecode(await rootBundle.loadString(
      'assets/languages/spanish/templates/canonical_lesson_40.json',
    )) as List).cast<Map>();
    expect(
      l40Templates
          .where((template) => template['audio_transcript'] is String)
          .map((template) => template['audio_transcript'] as String)
          .any((transcript) => transcript.contains('. ') && transcript.length > 45),
      isTrue,
    );
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

  test('Lessons 31 to 35 close shopping and health objectives', () async {
    final loader = CurriculumLoader(assetBundle: rootBundle);
    final course = await loader.loadCourse();
    final lessons = course.lessons.skip(30).take(5).toList();

    expect(lessons.map((lesson) => lesson.id), [
      'es.a0.m05.l031',
      'es.a0.m05.l032',
      'es.a0.m09.l033',
      'es.a0.m09.l034',
      'es.a0.m09.l035',
    ]);
    expect(lessons.map((lesson) => lesson.title), [
      'Ціна і вартість',
      'Купівля у магазині',
      'Що з тобою?',
      'Температура і біль',
      'Лікар, аптека і допомога',
    ]);

    for (var lesson = 31; lesson <= 35; lesson++) {
      final raw = await rootBundle.loadString(
        'assets/languages/spanish/templates/canonical_lesson_$lesson.json',
      );
      final templates = (jsonDecode(raw) as List).cast<Map>();
      expect(
        templates.where((template) => template['reading_text'] is String),
        isNotEmpty,
        reason: 'Lesson $lesson needs genuine short-reading comprehension',
      );
      expect(
        templates.any(
          (template) => template['exercise_type'] == 'guided_dialogue',
        ),
        isTrue,
        reason: 'Lesson $lesson needs guided interaction',
      );
    }

    final lesson35Templates =
        (jsonDecode(
                  await rootBundle.loadString(
                    'assets/languages/spanish/templates/canonical_lesson_35.json',
                  ),
                )
                as List)
            .cast<Map>();
    final listening = lesson35Templates.firstWhere(
      (template) =>
          template['id'] == 'template.es.a0.m09.l035.listening_pharmacy',
    );
    expect(
      listening['audio_reference_id'],
      'es.audio.question.donde_esta_la_farmacia',
    );
    expect(listening['audio_transcript'], '¿Dónde está la farmacia?');

    final lesson32 = await loader.loadLesson(
      path: 'assets/languages/spanish/curriculum/lessons/es.a0.m05.l032.json',
    );
    final lesson35 = await loader.loadLesson(
      path: 'assets/languages/spanish/curriculum/lessons/es.a0.m09.l035.json',
    );
    expect(lesson32.sections.first.activities.single.type, 'spoken_practice');
    expect(
      lesson32
          .sections
          .first
          .activities
          .single
          .spokenPractice
          ?.audioReferenceId,
      'es.audio.dialogue.necesito_una_llave',
    );
    expect(lesson35.sections.first.activities.single.type, 'spoken_practice');
    expect(
      lesson35
          .sections
          .first
          .activities
          .single
          .spokenPractice
          ?.audioReferenceId,
      'es.audio.phrase.necesito_un_medico',
    );
  });

  test(
    'Lessons 11 to 15 load with production practice and audio references',
    () async {
      final loader = CurriculumLoader(assetBundle: rootBundle);
      final expected = <String, String>{
        'es.a0.m04.l011': 'Люди та ролі',
        'es.a0.m04.l012': 'Яка це людина?',
        'es.a0.m04.l013': 'Питання про іншу людину',
        'es.a0.m05.l014': 'Що це?',
        'es.a0.m05.l015': 'Чи є у вас?',
      };

      for (final entry in expected.entries) {
        final lesson = await loader.loadLesson(
          path: 'assets/languages/spanish/curriculum/lessons/${entry.key}.json',
        );
        expect(lesson.title, entry.value);
        final references = lesson.activities.single.references;
        expect(references, hasLength(5));
        expect(
          references.where(
            (reference) => (reference.referenceId ?? '').contains('recall'),
          ),
          isNotEmpty,
        );
        expect(
          references.where(
            (reference) => (reference.referenceId ?? '').contains('guided'),
          ),
          isNotEmpty,
        );
      }

      final audio =
          jsonDecode(
                await rootBundle.loadString(
                  'assets/languages/spanish/audio/reference_audio.json',
                ),
              )
              as Map<String, Object?>;
      final approvedIds = {
        for (final raw in (audio['assets']! as List).cast<Map>())
          if (raw['qaStatus'] == 'approved') raw['id'] as String,
      };
      for (final path in [11, 12, 13, 14, 15]) {
        final templates =
            jsonDecode(
                  await rootBundle.loadString(
                    'assets/languages/spanish/templates/canonical_lesson_$path.json',
                  ),
                )
                as List;
        for (final raw in templates.cast<Map>()) {
          final builder = raw['sentence_builder'];
          if (builder is Map && builder['audioReferenceId'] != null) {
            expect(approvedIds, contains(builder['audioReferenceId']));
          }
        }
      }
    },
  );

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

  test(
    'Lessons 16 to 20 load with distinct objectives and production stages',
    () async {
      final loader = CurriculumLoader(assetBundle: rootBundle);
      final expected = <String, String>{
        'es.a0.m06.l016': 'Як ти їдеш?',
        'es.a0.m06.l017': 'Де станція?',
        'es.a0.m06.l018': 'Як дістатися до готелю?',
        'es.a0.m06.l019': 'Ліворуч чи праворуч?',
        'es.a0.m06.l020': 'Короткий маршрут',
      };

      for (final entry in expected.entries) {
        final lesson = await loader.loadLesson(
          path: 'assets/languages/spanish/curriculum/lessons/${entry.key}.json',
        );
        expect(lesson.title, entry.value);
        expect(lesson.primaryObjective?.description, isNotEmpty);
        expect(lesson.prerequisites, hasLength(1));
        expect(lesson.activities, isNotEmpty);
        final references = lesson.activities
            .expand((activity) => activity.references)
            .toList();
        expect(
          references.any((ref) => (ref.referenceId ?? '').contains('recall')),
          isTrue,
        );
        expect(
          references.any((ref) => (ref.referenceId ?? '').contains('guided')),
          isTrue,
        );
        expect(
          references.any((ref) => (ref.referenceId ?? '').contains('meaning_')),
          isTrue,
        );
        expect(lesson.sections.first.id, endsWith('.section.spoken'));
        expect(lesson.sections.first.activities.single.type, 'spoken_practice');
        expect(
          lesson.sections[1].activities.single.references.first.referenceId,
          contains('meaning_'),
        );
      }
    },
  );

  test(
    'selected Lessons 17 to 19 use audio-first semantic comprehension',
    () async {
      final audioJson =
          jsonDecode(
                await rootBundle.loadString(
                  'assets/languages/spanish/audio/reference_audio.json',
                ),
              )
              as Map<String, dynamic>;
      final approvedIds = {
        for (final raw in (audioJson['assets'] as List).cast<Map>())
          if (raw['qaStatus'] == 'approved') raw['id'] as String,
      };
      final expected = <int, String>{
        17: 'es.audio.phrase.esta_lejos',
        18: 'es.audio.phrase.sigue_recto',
        19: 'es.audio.phrase.gira_a_la_derecha',
      };

      for (final entry in expected.entries) {
        final rawTemplates =
            jsonDecode(
                  await rootBundle.loadString(
                    'assets/languages/spanish/templates/canonical_lesson_${entry.key}.json',
                  ),
                )
                as List;
        final listening = rawTemplates.cast<Map>().firstWhere(
          (template) => (template['id'] as String).contains('meaning_'),
        );
        expect(listening['audio_reference_id'], entry.value);
        expect(approvedIds, contains(listening['audio_reference_id']));
        expect(listening['prompt_template'], isNot(contains('Está')));
        expect(listening['prompt_template'], isNot(contains('Sigue')));
        expect(listening['prompt_template'], isNot(contains('Gira')));
        for (final option
            in (listening['answer_options'] as List).cast<Map>()) {
          expect(
            option['label'],
            isNot(contains(RegExp(r'[A-Za-zÁÉÍÓÚáéíóú¿¡]'))),
          );
        }
      }
    },
  );

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

  test(
    'Lesson 9 origin dialogue asks for one coherent open-value action',
    () async {
      final raw =
          jsonDecode(
                await rootBundle.loadString(
                  'assets/languages/spanish/templates/canonical_lesson_9.json',
                ),
              )
              as List;
      final guided = raw.cast<Map>().firstWhere(
        (item) => item['id'] == 'template.es.a0.m03.l009.guided_origin',
      );
      expect(
        guided['prompt_template'],
        'Обміняйся інформацією про походження.',
      );
      final learnerTurn = (guided['guided_dialogue'] as Map)['turns']
          .cast<Map>()
          .firstWhere((turn) => turn['learner'] == true);
      expect(learnerTurn['response_mode'], 'prefix_with_value');
      expect(learnerTurn['response_patterns'], ['Soy de {place}.']);
    },
  );

  test('known multi-answer and multi-turn prompts are explicit', () async {
    final l25 =
        jsonDecode(
              await rootBundle.loadString(
                'assets/languages/spanish/templates/canonical_lesson_25.json',
              ),
            )
            as List;
    final builder = l25.cast<Map>().firstWhere(
      (item) => item['id'] == 'template.es.a0.m07.l025.build_request',
    );
    expect(builder['prompt_template'], contains('одну коротку репліку'));
    expect(
      (builder['sentence_builder'] as Map)['accepted_sequences'],
      hasLength(2),
    );

    for (final lesson in [11, 12, 14, 15]) {
      final raw =
          jsonDecode(
                await rootBundle.loadString(
                  'assets/languages/spanish/templates/canonical_lesson_$lesson.json',
                ),
              )
              as List;
      final guided = raw.cast<Map>().firstWhere(
        (item) => item['exercise_type'] == 'guided_dialogue',
      );
      expect(guided['prompt_template'], isNot(contains('своїми словами')));
      expect(guided['prompt_template'], isNot(contains('короткий обмін')));
    }
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
