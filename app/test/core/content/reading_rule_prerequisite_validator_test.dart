import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_models.dart';
import 'package:tutor_language/core/content/reading_rule_prerequisite_validator.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';

void main() {
  const validator = ReadingRulePrerequisiteValidator();

  test('earlier lesson introduction satisfies later requirements', () {
    final result = validator.validateCourse(
      course: _course([
        _lesson(
          'lesson.intro',
          activities: [
            _activity(
              'activity.intro',
              introduced: ['pronunciation.es.rule.ll_y.v1'],
            ),
          ],
        ),
        _lesson(
          'lesson.use',
          activities: [
            _activity(
              'activity.use',
              required: ['pronunciation.es.rule.ll_y.v1'],
            ),
          ],
        ),
      ]),
      pronunciationCatalog: _catalog(),
    );

    expect(result.hasErrors, isFalse);
  });

  test('same lesson introduction satisfies later activity', () {
    final result = validator.validateCourse(
      course: _course([
        _lesson(
          'lesson.same',
          activities: [
            _activity(
              'activity.intro',
              introduced: ['pronunciation.es.rule.ll_y.v1'],
            ),
            _activity(
              'activity.use',
              required: ['pronunciation.es.rule.ll_y.v1'],
            ),
          ],
        ),
      ]),
      pronunciationCatalog: _catalog(),
    );

    expect(result.hasErrors, isFalse);
  });

  test('later lesson cannot satisfy earlier active use', () {
    final result = validator.validateCourse(
      course: _course([
        _lesson(
          'lesson.use',
          activities: [
            _activity(
              'activity.use',
              required: ['pronunciation.es.rule.ll_y.v1'],
            ),
          ],
        ),
        _lesson(
          'lesson.intro',
          activities: [
            _activity(
              'activity.intro',
              introduced: ['pronunciation.es.rule.ll_y.v1'],
            ),
          ],
        ),
      ]),
      pronunciationCatalog: _catalog(),
    );

    expect(
      result.issues.map((issue) => issue.code),
      contains('readingRulePrerequisite.activityOrderViolation'),
    );
  });

  test('unknown and cross-language rule references fail', () {
    final result = validator.validateCourse(
      course: _course([
        _lesson(
          'lesson.bad',
          activities: [
            _activity(
              'activity.bad',
              introduced: [
                'pronunciation.es.rule.missing.v1',
                'pronunciation.de.rule.sch.v1',
              ],
            ),
          ],
        ),
      ]),
      pronunciationCatalog: _catalog(includeGermanRule: true),
    );

    expect(
      result.issues.map((issue) => issue.code),
      containsAll([
        'readingRulePrerequisite.unknownIntroducedRule',
        'readingRulePrerequisite.targetLanguageMismatch',
      ]),
    );
  });

  test('review-only metadata does not count as introduction', () {
    final result = validator.validateCourse(
      course: _course([
        _lesson(
          'lesson.review',
          activities: [
            _activity(
              'activity.review',
              reviewed: ['pronunciation.es.rule.ll_y.v1'],
            ),
            _activity(
              'activity.use',
              required: ['pronunciation.es.rule.ll_y.v1'],
            ),
          ],
        ),
      ]),
      pronunciationCatalog: _catalog(),
    );

    expect(
      result.issues.map((issue) => issue.code),
      contains('readingRulePrerequisite.activityOrderViolation'),
    );
  });
}

Course _course(List<Lesson> lessons) {
  return Course(
    id: 'course.es',
    languageId: 'spanish',
    title: 'Spanish',
    level: 'A0',
    version: 'test',
    modules: [
      Module(
        id: 'module.one',
        title: 'Module',
        lessonIds: lessons.map((lesson) => lesson.id).toList(),
      ),
    ],
    lessons: lessons,
  );
}

Lesson _lesson(String id, {required List<LessonActivity> activities}) {
  return Lesson(
    id: id,
    moduleId: 'module.one',
    title: id,
    primaryObjective: const LessonObjective(id: 'objective', description: ''),
    estimatedDurationMinutes: 1,
    completionCriteria: const LessonCompletionCriteria(),
    activities: activities,
  );
}

LessonActivity _activity(
  String id, {
  List<String> introduced = const [],
  List<String> required = const [],
  List<String> reviewed = const [],
}) {
  return LessonActivity(
    id: id,
    title: id,
    type: 'grammar',
    introducedReadingRuleIds: introduced,
    requiredReadingRuleIds: required,
    reviewedReadingRuleIds: reviewed,
  );
}

PronunciationCatalog _catalog({bool includeGermanRule = false}) {
  return PronunciationCatalog(
    bundle: PronunciationBundle(
      schemaVersion: 1,
      targetLanguage: 'es',
      pronunciationVariety: PronunciationVariety('es-general'),
      rules: [
        ReadingRule(
          id: 'pronunciation.es.rule.ll_y.v1',
          schemaVersion: 1,
          knowledgeDomain: 'language',
          ruleKind: 'reading',
          targetLanguage: 'es',
          orthographicPattern: 'll',
          pronunciationVariety: PronunciationVariety('es-general'),
          ipa: IpaTranscription('/ʝ/'),
          examplePronunciationUnitIds: const [],
        ),
        if (includeGermanRule)
          ReadingRule(
            id: 'pronunciation.de.rule.sch.v1',
            schemaVersion: 1,
            knowledgeDomain: 'language',
            ruleKind: 'reading',
            targetLanguage: 'de',
            orthographicPattern: 'sch',
            pronunciationVariety: PronunciationVariety('de-standard'),
            ipa: IpaTranscription('/ʃ/'),
            examplePronunciationUnitIds: const [],
          ),
      ],
      units: const [],
      localizations: const [],
    ),
  );
}
