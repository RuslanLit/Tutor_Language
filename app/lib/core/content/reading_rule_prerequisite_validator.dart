import '../../features/curriculum/curriculum_models.dart';
import 'pronunciation_catalog.dart';

enum ReadingRulePrerequisiteSeverity { error, warning, deferred }

class ReadingRulePrerequisiteIssue {
  const ReadingRulePrerequisiteIssue({
    required this.code,
    required this.severity,
    required this.lessonId,
    required this.readingRuleId,
    required this.message,
    this.activityId,
  });

  final String code;
  final ReadingRulePrerequisiteSeverity severity;
  final String lessonId;
  final String? activityId;
  final String readingRuleId;
  final String message;

  @override
  String toString() {
    final activity = activityId == null ? '' : '\tactivity=$activityId';
    return '${severity.name}\t$code\tlesson=$lessonId$activity\t'
        'rule=$readingRuleId\t$message';
  }
}

class ReadingRulePrerequisiteLessonReport {
  const ReadingRulePrerequisiteLessonReport({
    required this.lessonId,
    required this.rulesIntroducedBeforeLesson,
    required this.rulesIntroducedInLesson,
    required this.rulesRequiredByLesson,
    required this.rulesReviewedByLesson,
    required this.violations,
  });

  final String lessonId;
  final Set<String> rulesIntroducedBeforeLesson;
  final Set<String> rulesIntroducedInLesson;
  final Set<String> rulesRequiredByLesson;
  final Set<String> rulesReviewedByLesson;
  final List<ReadingRulePrerequisiteIssue> violations;
}

class ReadingRulePrerequisiteValidationResult {
  const ReadingRulePrerequisiteValidationResult({
    required this.lessonReports,
    required this.issues,
  });

  final List<ReadingRulePrerequisiteLessonReport> lessonReports;
  final List<ReadingRulePrerequisiteIssue> issues;

  bool get hasErrors => issues.any(
    (issue) => issue.severity == ReadingRulePrerequisiteSeverity.error,
  );
}

class ReadingRulePrerequisiteCoverage {
  const ReadingRulePrerequisiteCoverage({
    required this.readingRulesWithExplicitFirstIntroduction,
    required this.readingRulesActivelyUsedBeforeIntroduction,
    required this.lessonsWithDeclaredPrerequisites,
    required this.activitiesWithDeclaredPrerequisites,
    required this.unclassifiedActiveFirstUses,
    required this.unknownReadingRuleReferences,
    required this.crossLanguagePrerequisiteReferences,
    required this.rulesIntroducedAndAppliedInSameLesson,
    required this.rulesIntroducedOnlyAfterFirstUse,
    required this.visuallyConfusableGraphemesWithPresentation,
    required this.confusableGraphemesMissingAccessibility,
  });

  final int readingRulesWithExplicitFirstIntroduction;
  final int readingRulesActivelyUsedBeforeIntroduction;
  final int lessonsWithDeclaredPrerequisites;
  final int activitiesWithDeclaredPrerequisites;
  final int unclassifiedActiveFirstUses;
  final int unknownReadingRuleReferences;
  final int crossLanguagePrerequisiteReferences;
  final int rulesIntroducedAndAppliedInSameLesson;
  final int rulesIntroducedOnlyAfterFirstUse;
  final int visuallyConfusableGraphemesWithPresentation;
  final int confusableGraphemesMissingAccessibility;
}

class ReadingRulePrerequisiteValidator {
  const ReadingRulePrerequisiteValidator();

  ReadingRulePrerequisiteValidationResult validateCourse({
    required Course course,
    required PronunciationCatalog pronunciationCatalog,
  }) {
    final issues = <ReadingRulePrerequisiteIssue>[];
    final lessonReports = <ReadingRulePrerequisiteLessonReport>[];
    final introducedRules = <String>{};

    for (final lesson in _orderedLessons(course)) {
      final beforeLesson = Set<String>.unmodifiable(introducedRules);
      final introducedInLesson = <String>{};
      final requiredInLesson = <String>{...lesson.requiredReadingRuleIds};
      final reviewedInLesson = <String>{...lesson.reviewedReadingRuleIds};
      final lessonIssues = <ReadingRulePrerequisiteIssue>[];

      for (final ruleId in lesson.introducedReadingRuleIds) {
        _addReferenceIssues(
          issues: issues,
          lessonIssues: lessonIssues,
          lessonId: lesson.id,
          ruleId: ruleId,
          pronunciationCatalog: pronunciationCatalog,
          course: course,
          unknownCode: 'readingRulePrerequisite.unknownIntroducedRule',
        );
      }

      for (final ruleId in lesson.requiredReadingRuleIds) {
        _addReferenceIssues(
          issues: issues,
          lessonIssues: lessonIssues,
          lessonId: lesson.id,
          ruleId: ruleId,
          pronunciationCatalog: pronunciationCatalog,
          course: course,
          unknownCode: 'readingRulePrerequisite.unknownRequiredRule',
        );
        if (!introducedRules.contains(ruleId)) {
          _addIssue(
            issues,
            lessonIssues,
            code: 'readingRulePrerequisite.lessonOrderViolation',
            severity: ReadingRulePrerequisiteSeverity.error,
            lessonId: lesson.id,
            readingRuleId: ruleId,
            message: 'Lesson requires a reading rule before it is introduced.',
          );
        }
      }

      final activityIntroducedRules = <String>{};
      final availableInLesson = <String>{...introducedRules};
      for (final activity in _orderedActivities(lesson)) {
        for (final ruleId in activity.requiredReadingRuleIds) {
          requiredInLesson.add(ruleId);
          _addReferenceIssues(
            issues: issues,
            lessonIssues: lessonIssues,
            lessonId: lesson.id,
            activityId: activity.id,
            ruleId: ruleId,
            pronunciationCatalog: pronunciationCatalog,
            course: course,
            unknownCode: 'readingRulePrerequisite.unknownRequiredRule',
          );
          if (!availableInLesson.contains(ruleId)) {
            _addIssue(
              issues,
              lessonIssues,
              code: 'readingRulePrerequisite.activityOrderViolation',
              severity: ReadingRulePrerequisiteSeverity.error,
              lessonId: lesson.id,
              activityId: activity.id,
              readingRuleId: ruleId,
              message:
                  'Activity requires a reading rule before an earlier activity introduces it.',
            );
          }
        }

        for (final ruleId in activity.reviewedReadingRuleIds) {
          reviewedInLesson.add(ruleId);
          _addReferenceIssues(
            issues: issues,
            lessonIssues: lessonIssues,
            lessonId: lesson.id,
            activityId: activity.id,
            ruleId: ruleId,
            pronunciationCatalog: pronunciationCatalog,
            course: course,
            unknownCode: 'readingRulePrerequisite.unknownReviewedRule',
          );
          if (!availableInLesson.contains(ruleId)) {
            _addIssue(
              issues,
              lessonIssues,
              code: 'readingRulePrerequisite.reviewBeforeIntroduction',
              severity: ReadingRulePrerequisiteSeverity.warning,
              lessonId: lesson.id,
              activityId: activity.id,
              readingRuleId: ruleId,
              message: 'Activity reviews a reading rule before introduction.',
            );
          }
        }

        for (final ruleId in activity.introducedReadingRuleIds) {
          _addReferenceIssues(
            issues: issues,
            lessonIssues: lessonIssues,
            lessonId: lesson.id,
            activityId: activity.id,
            ruleId: ruleId,
            pronunciationCatalog: pronunciationCatalog,
            course: course,
            unknownCode: 'readingRulePrerequisite.unknownIntroducedRule',
          );
          if (availableInLesson.contains(ruleId) ||
              activityIntroducedRules.contains(ruleId)) {
            _addIssue(
              issues,
              lessonIssues,
              code: 'readingRulePrerequisite.duplicateIntroduction',
              severity: ReadingRulePrerequisiteSeverity.warning,
              lessonId: lesson.id,
              activityId: activity.id,
              readingRuleId: ruleId,
              message: 'Reading rule is introduced more than once.',
            );
          }
          introducedInLesson.add(ruleId);
          activityIntroducedRules.add(ruleId);
          availableInLesson.add(ruleId);
        }
      }

      introducedRules.addAll(lesson.introducedReadingRuleIds);
      introducedRules.addAll(introducedInLesson);

      lessonReports.add(
        ReadingRulePrerequisiteLessonReport(
          lessonId: lesson.id,
          rulesIntroducedBeforeLesson: beforeLesson,
          rulesIntroducedInLesson: Set.unmodifiable({
            ...lesson.introducedReadingRuleIds,
            ...introducedInLesson,
          }),
          rulesRequiredByLesson: Set.unmodifiable(requiredInLesson),
          rulesReviewedByLesson: Set.unmodifiable(reviewedInLesson),
          violations: List.unmodifiable(lessonIssues),
        ),
      );
    }

    return ReadingRulePrerequisiteValidationResult(
      lessonReports: List.unmodifiable(lessonReports),
      issues: List.unmodifiable(issues),
    );
  }

  ReadingRulePrerequisiteCoverage coverage({
    required Course course,
    required PronunciationCatalog pronunciationCatalog,
    required ReadingRulePrerequisiteValidationResult result,
  }) {
    final reports = result.lessonReports;
    final introducedRules = reports
        .expand((report) => report.rulesIntroducedInLesson)
        .toSet();
    final activeBeforeIntroduction = result.issues
        .where(
          (issue) =>
              issue.code == 'readingRulePrerequisite.activityOrderViolation' ||
              issue.code == 'readingRulePrerequisite.lessonOrderViolation',
        )
        .length;
    final lessonsWithPrerequisites = _orderedLessons(course)
        .where(
          (lesson) =>
              lesson.introducedReadingRuleIds.isNotEmpty ||
              lesson.requiredReadingRuleIds.isNotEmpty ||
              lesson.reviewedReadingRuleIds.isNotEmpty,
        )
        .length;
    final activitiesWithPrerequisites = _orderedLessons(course)
        .expand(_orderedActivities)
        .where(
          (activity) =>
              activity.introducedReadingRuleIds.isNotEmpty ||
              activity.requiredReadingRuleIds.isNotEmpty ||
              activity.reviewedReadingRuleIds.isNotEmpty,
        )
        .length;
    final sameLesson = reports.where((report) {
      return report.rulesIntroducedInLesson.any(
        report.rulesRequiredByLesson.contains,
      );
    }).length;

    return ReadingRulePrerequisiteCoverage(
      readingRulesWithExplicitFirstIntroduction: introducedRules.length,
      readingRulesActivelyUsedBeforeIntroduction: activeBeforeIntroduction,
      lessonsWithDeclaredPrerequisites: lessonsWithPrerequisites,
      activitiesWithDeclaredPrerequisites: activitiesWithPrerequisites,
      unclassifiedActiveFirstUses: 0,
      unknownReadingRuleReferences: result.issues
          .where((issue) => issue.code.contains('unknown'))
          .length,
      crossLanguagePrerequisiteReferences: result.issues
          .where(
            (issue) =>
                issue.code == 'readingRulePrerequisite.targetLanguageMismatch',
          )
          .length,
      rulesIntroducedAndAppliedInSameLesson: sameLesson,
      rulesIntroducedOnlyAfterFirstUse: activeBeforeIntroduction,
      visuallyConfusableGraphemesWithPresentation: pronunciationCatalog.rules
          .where(
            (rule) =>
                rule.confusableGraphemes.isNotEmpty &&
                result.issues.every(
                  (issue) =>
                      issue.readingRuleId != rule.id ||
                      issue.code !=
                          'readingRulePrerequisite.missingGraphemePresentation',
                ),
          )
          .length,
      confusableGraphemesMissingAccessibility: pronunciationCatalog
          .validationResult()
          .issues
          .where(
            (issue) =>
                issue.code ==
                'readingRule.missingAccessibleGraphemePresentation',
          )
          .length,
    );
  }

  void _addReferenceIssues({
    required List<ReadingRulePrerequisiteIssue> issues,
    required List<ReadingRulePrerequisiteIssue> lessonIssues,
    required String lessonId,
    required String ruleId,
    required PronunciationCatalog pronunciationCatalog,
    required Course course,
    required String unknownCode,
    String? activityId,
  }) {
    final rule = pronunciationCatalog.readingRuleById(ruleId);
    if (rule == null) {
      _addIssue(
        issues,
        lessonIssues,
        code: unknownCode,
        severity: ReadingRulePrerequisiteSeverity.error,
        lessonId: lessonId,
        activityId: activityId,
        readingRuleId: ruleId,
        message: 'Unknown ReadingRule ID.',
      );
      return;
    }
    final expectedLanguage = _targetLanguageCode(course.languageId);
    if (rule.targetLanguage != expectedLanguage) {
      _addIssue(
        issues,
        lessonIssues,
        code: 'readingRulePrerequisite.targetLanguageMismatch',
        severity: ReadingRulePrerequisiteSeverity.error,
        lessonId: lessonId,
        activityId: activityId,
        readingRuleId: ruleId,
        message:
            'Rule language ${rule.targetLanguage} does not match course ${course.languageId}.',
      );
    }
  }

  void _addIssue(
    List<ReadingRulePrerequisiteIssue> issues,
    List<ReadingRulePrerequisiteIssue> lessonIssues, {
    required String code,
    required ReadingRulePrerequisiteSeverity severity,
    required String lessonId,
    required String readingRuleId,
    required String message,
    String? activityId,
  }) {
    final issue = ReadingRulePrerequisiteIssue(
      code: code,
      severity: severity,
      lessonId: lessonId,
      activityId: activityId,
      readingRuleId: readingRuleId,
      message: message,
    );
    issues.add(issue);
    lessonIssues.add(issue);
  }

  List<Lesson> _orderedLessons(Course course) {
    final lessonsById = {
      for (final lesson in course.lessons) lesson.id: lesson,
    };
    return [
      for (final module in course.modules)
        for (final lessonId in module.lessonIds)
          if (lessonsById[lessonId] != null) lessonsById[lessonId]!,
    ];
  }

  List<LessonActivity> _orderedActivities(Lesson lesson) {
    if (lesson.sections.isEmpty) {
      return [...lesson.activities]..sort((a, b) => a.order.compareTo(b.order));
    }

    return [
      for (final section in [
        ...lesson.sections,
      ]..sort((a, b) => a.order.compareTo(b.order)))
        for (final activity in [
          ...section.activities,
        ]..sort((a, b) => a.order.compareTo(b.order)))
          activity,
    ];
  }

  String _targetLanguageCode(String languageId) {
    return switch (languageId) {
      'spanish' => 'es',
      'german' => 'de',
      'polish' => 'pl',
      'ukrainian' => 'uk',
      'english' => 'en',
      'french' => 'fr',
      'italian' => 'it',
      _ => languageId,
    };
  }
}
