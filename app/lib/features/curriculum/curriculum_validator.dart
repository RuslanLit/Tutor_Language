import 'curriculum_models.dart';

class CurriculumValidationIssue {
  const CurriculumValidationIssue(this.message);

  final String message;

  @override
  String toString() => message;
}

class CurriculumValidator {
  const CurriculumValidator();

  List<CurriculumValidationIssue> validate({
    required LanguagePackManifest manifest,
    required Course course,
  }) {
    final issues = <CurriculumValidationIssue>[];

    if (course.languageId != manifest.id) {
      issues.add(
        CurriculumValidationIssue(
          'Course languageId does not match manifest id: ${course.languageId}',
        ),
      );
    }

    _addDuplicateIssues(
      issues,
      'module',
      course.modules.map((module) => module.id),
    );
    _addDuplicateIssues(
      issues,
      'lesson',
      course.lessons.map((lesson) => lesson.id),
    );

    final moduleIds = course.modules.map((module) => module.id).toSet();
    final lessonIds = course.lessons.map((lesson) => lesson.id).toSet();
    final moduleLessonIds = {
      for (final module in course.modules) module.id: module.lessonIds.toSet(),
    };
    final referencedLessonIds = course.modules
        .expand((module) => module.lessonIds)
        .toSet();

    for (final module in course.modules) {
      if (module.title.isEmpty) {
        issues.add(
          CurriculumValidationIssue('Empty module title: ${module.id}'),
        );
      }

      for (final lessonId in module.lessonIds) {
        if (!lessonIds.contains(lessonId)) {
          issues.add(
            CurriculumValidationIssue(
              'Missing lesson reference in module ${module.id}: $lessonId',
            ),
          );
        }
      }
    }

    for (final lesson in course.lessons) {
      if (!moduleIds.contains(lesson.moduleId)) {
        issues.add(
          CurriculumValidationIssue(
            'Lesson references missing module ${lesson.moduleId}: ${lesson.id}',
          ),
        );
      } else if (!(moduleLessonIds[lesson.moduleId]?.contains(lesson.id) ??
          false)) {
        issues.add(
          CurriculumValidationIssue(
            'Lesson is not listed in its module ${lesson.moduleId}: '
            '${lesson.id}',
          ),
        );
      }

      if (!referencedLessonIds.contains(lesson.id)) {
        issues.add(
          CurriculumValidationIssue(
            'Lesson is not referenced by any module: ${lesson.id}',
          ),
        );
      }

      if (lesson.title.trim().isEmpty) {
        issues.add(
          CurriculumValidationIssue('Empty lesson title: ${lesson.id}'),
        );
      }

      if (lesson.primaryObjective == null ||
          lesson.primaryObjective!.description.trim().isEmpty) {
        issues.add(
          CurriculumValidationIssue('Empty primary objective: ${lesson.id}'),
        );
      }

      if (lesson.courseId != course.id) {
        issues.add(
          CurriculumValidationIssue(
            'Lesson courseId does not match course id: ${lesson.id}',
          ),
        );
      }

      if (lesson.estimatedDurationMinutes < 1) {
        issues.add(
          CurriculumValidationIssue('Invalid estimated duration: ${lesson.id}'),
        );
      }

      if (lesson.objectives.isEmpty) {
        issues.add(
          CurriculumValidationIssue('Missing objectives: ${lesson.id}'),
        );
      }

      _addDuplicateIssues(
        issues,
        'objective id in lesson ${lesson.id}',
        lesson.objectives.map((objective) => objective.id),
      );

      for (final objective in lesson.objectives) {
        if (objective.description.trim().isEmpty) {
          issues.add(
            CurriculumValidationIssue(
              'Empty objective description in lesson ${lesson.id}: '
              '${objective.id}',
            ),
          );
        }
      }

      if (lesson.sections.isEmpty) {
        issues.add(CurriculumValidationIssue('Missing sections: ${lesson.id}'));
      }

      _addDuplicateIssues(
        issues,
        'section id in lesson ${lesson.id}',
        lesson.sections.map((section) => section.id),
      );
      _addDuplicateIssues(
        issues,
        'section order in lesson ${lesson.id}',
        lesson.sections.map((section) => section.order.toString()),
      );

      for (final section in lesson.sections) {
        if (section.title.trim().isEmpty || section.order < 1) {
          issues.add(
            CurriculumValidationIssue(
              'Invalid section in lesson ${lesson.id}: ${section.id}',
            ),
          );
        }
      }

      if (lesson.activities.isEmpty) {
        issues.add(
          CurriculumValidationIssue('Missing activities: ${lesson.id}'),
        );
      }

      _addDuplicateIssues(
        issues,
        'activity id in lesson ${lesson.id}',
        lesson.activities.map((activity) => activity.id),
      );

      for (final activity in lesson.activities) {
        if (activity.type.trim().isEmpty) {
          issues.add(
            CurriculumValidationIssue(
              'Missing activity type in lesson ${lesson.id}: ${activity.id}',
            ),
          );
        }

        if (activity.title.trim().isEmpty || activity.order < 1) {
          issues.add(
            CurriculumValidationIssue(
              'Invalid activity in lesson ${lesson.id}: ${activity.id}',
            ),
          );
        }

        for (final reference in activity.references) {
          if (reference.type.trim().isEmpty ||
              reference.assetPath.trim().isEmpty ||
              !reference.assetPath.startsWith('assets/languages/')) {
            issues.add(
              CurriculumValidationIssue(
                'Invalid activity reference in lesson ${lesson.id}: '
                '${activity.id}',
              ),
            );
          }
        }
      }

      for (final prerequisite in lesson.prerequisites) {
        if (!lessonIds.contains(prerequisite.lessonId)) {
          issues.add(
            CurriculumValidationIssue(
              'Invalid prerequisite in lesson ${lesson.id}: '
              '${prerequisite.lessonId}',
            ),
          );
        }
      }

      final activityIds = lesson.activities
          .map((activity) => activity.id)
          .toSet();
      final sectionIds = lesson.sections.map((section) => section.id).toSet();
      final objectiveIds = lesson.objectives
          .map((objective) => objective.id)
          .toSet();

      if (lesson.completionCriteria.minimumCompletedActivities < 1 ||
          lesson.completionCriteria.minimumCompletedActivities >
              lesson.activities.length) {
        issues.add(
          CurriculumValidationIssue(
            'Invalid completion criteria: ${lesson.id}',
          ),
        );
      }

      for (final activityId in lesson.completionCriteria.requiredActivities) {
        if (!activityIds.contains(activityId)) {
          issues.add(
            CurriculumValidationIssue(
              'Completion references missing activity in lesson ${lesson.id}: '
              '$activityId',
            ),
          );
        }
      }

      for (final sectionId in lesson.completionCriteria.mandatorySections) {
        if (!sectionIds.contains(sectionId)) {
          issues.add(
            CurriculumValidationIssue(
              'Completion references missing section in lesson ${lesson.id}: '
              '$sectionId',
            ),
          );
        }
      }

      if (lesson.summary == null ||
          lesson.summary!.reviewPrompt.trim().isEmpty) {
        issues.add(
          CurriculumValidationIssue('Empty lesson summary: ${lesson.id}'),
        );
      }

      for (final referenceId in lesson.summary?.referenceIds ?? const []) {
        if (!objectiveIds.contains(referenceId) &&
            !activityIds.contains(referenceId) &&
            !sectionIds.contains(referenceId)) {
          issues.add(
            CurriculumValidationIssue(
              'Summary references unknown item in lesson ${lesson.id}: '
              '$referenceId',
            ),
          );
        }
      }
    }

    _addCircularPrerequisiteIssues(issues, course.lessons);

    return List.unmodifiable(issues);
  }

  void _addDuplicateIssues(
    List<CurriculumValidationIssue> issues,
    String label,
    Iterable<String> ids,
  ) {
    final seen = <String>{};

    for (final id in ids) {
      if (!seen.add(id)) {
        issues.add(CurriculumValidationIssue('Duplicate $label id: $id'));
      }
    }
  }

  void _addCircularPrerequisiteIssues(
    List<CurriculumValidationIssue> issues,
    List<Lesson> lessons,
  ) {
    final prerequisitesByLesson = {
      for (final lesson in lessons)
        lesson.id: lesson.prerequisites
            .map((prerequisite) => prerequisite.lessonId)
            .toList(growable: false),
    };
    final visiting = <String>{};
    final visited = <String>{};
    final reported = <String>{};

    bool visit(String lessonId) {
      if (visited.contains(lessonId)) {
        return false;
      }

      if (!visiting.add(lessonId)) {
        return true;
      }

      for (final prerequisiteId
          in prerequisitesByLesson[lessonId] ?? const []) {
        if (!prerequisitesByLesson.containsKey(prerequisiteId)) {
          continue;
        }

        if (visit(prerequisiteId)) {
          if (reported.add(lessonId)) {
            issues.add(
              CurriculumValidationIssue(
                'Circular prerequisite chain includes lesson: $lessonId',
              ),
            );
          }

          visiting.remove(lessonId);
          visited.add(lessonId);
          return true;
        }
      }

      visiting.remove(lessonId);
      visited.add(lessonId);
      return false;
    }

    for (final lesson in lessons) {
      visit(lesson.id);
    }
  }
}
