import 'dart:convert';
import 'dart:io';

import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_models.dart';
import 'package:tutor_language/core/content/reading_rule_prerequisite_validator.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';

void main() {
  final root = Directory('assets/languages/spanish');
  if (!root.existsSync()) {
    stderr.writeln('Run from app/.');
    exitCode = 1;
    return;
  }

  final course = _loadCourse(root);
  final catalog = _loadPronunciationCatalog(root);
  const validator = ReadingRulePrerequisiteValidator();
  final result = validator.validateCourse(
    course: course,
    pronunciationCatalog: catalog,
  );
  final coverage = validator.coverage(
    course: course,
    pronunciationCatalog: catalog,
    result: result,
  );

  stdout.writeln('ReadingRule prerequisite audit');
  stdout.writeln('course=${course.id}');
  stdout.writeln('lessons=${course.lessons.length}');
  stdout.writeln('issues=${result.issues.length}');
  stdout.writeln(
    'errors=${result.issues.where((issue) => issue.severity == ReadingRulePrerequisiteSeverity.error).length}',
  );
  stdout.writeln('firstIntroductions');
  for (final entry in _firstIntroductions(result).entries) {
    stdout.writeln('${entry.key}\t${entry.value}');
  }
  stdout.writeln('firstRequirements');
  for (final entry in _firstRequirements(result).entries) {
    stdout.writeln('${entry.key}\t${entry.value}');
  }
  stdout.writeln('coverage');
  stdout.writeln(
    'readingRulesWithExplicitFirstIntroduction=${coverage.readingRulesWithExplicitFirstIntroduction}',
  );
  stdout.writeln(
    'readingRulesActivelyUsedBeforeIntroduction=${coverage.readingRulesActivelyUsedBeforeIntroduction}',
  );
  stdout.writeln(
    'lessonsWithDeclaredPrerequisites=${coverage.lessonsWithDeclaredPrerequisites}',
  );
  stdout.writeln(
    'activitiesWithDeclaredPrerequisites=${coverage.activitiesWithDeclaredPrerequisites}',
  );
  stdout.writeln(
    'unclassifiedActiveFirstUses=${coverage.unclassifiedActiveFirstUses}',
  );
  stdout.writeln(
    'unknownReadingRuleReferences=${coverage.unknownReadingRuleReferences}',
  );
  stdout.writeln(
    'crossLanguagePrerequisiteReferences=${coverage.crossLanguagePrerequisiteReferences}',
  );
  stdout.writeln(
    'rulesIntroducedAndAppliedInSameLesson=${coverage.rulesIntroducedAndAppliedInSameLesson}',
  );
  stdout.writeln(
    'rulesIntroducedOnlyAfterFirstUse=${coverage.rulesIntroducedOnlyAfterFirstUse}',
  );
  stdout.writeln(
    'visuallyConfusableGraphemesWithPresentation=${coverage.visuallyConfusableGraphemesWithPresentation}',
  );
  stdout.writeln(
    'confusableGraphemesMissingAccessibility=${coverage.confusableGraphemesMissingAccessibility}',
  );

  if (result.issues.isNotEmpty) {
    stdout.writeln('issuesDetail');
    for (final issue in result.issues) {
      stdout.writeln(issue);
    }
  }

  if (result.hasErrors) {
    exitCode = 1;
  }
}

Map<String, String> _firstIntroductions(
  ReadingRulePrerequisiteValidationResult result,
) {
  final entries = <String, String>{};
  for (final report in result.lessonReports) {
    for (final ruleId in report.rulesIntroducedInLesson) {
      entries.putIfAbsent(ruleId, () => report.lessonId);
    }
  }
  return Map.fromEntries(
    entries.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
}

Map<String, String> _firstRequirements(
  ReadingRulePrerequisiteValidationResult result,
) {
  final entries = <String, String>{};
  for (final report in result.lessonReports) {
    for (final ruleId in report.rulesRequiredByLesson) {
      entries.putIfAbsent(ruleId, () => report.lessonId);
    }
  }
  return Map.fromEntries(
    entries.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
}

Course _loadCourse(Directory root) {
  final courseFile = File('${root.path}/curriculum/spanish_a0_course.json');
  final decoded = jsonDecode(courseFile.readAsStringSync());
  if (decoded is! Map) {
    throw const FormatException('Course must be a JSON object');
  }
  return Course.fromJson(Map<String, Object?>.from(decoded));
}

PronunciationCatalog _loadPronunciationCatalog(Directory root) {
  final pronunciationFile = File(
    '${root.path}/pronunciation/reference_slice.json',
  );
  final decoded = jsonDecode(pronunciationFile.readAsStringSync());
  if (decoded is! Map) {
    throw const FormatException('Pronunciation bundle must be a JSON object');
  }
  return PronunciationCatalog(
    bundle: PronunciationBundle.fromJson(Map<String, Object?>.from(decoded)),
    vocabularyContents: _loadVocabulary(root),
  );
}

List<VocabularyContent> _loadVocabulary(Directory root) {
  final vocabularyDir = Directory('${root.path}/vocabulary');
  return [
    for (final file in _jsonFiles(vocabularyDir))
      VocabularyContent(
        assetPath: file.path,
        entries: _loadVocabularyItems(file),
      ),
  ];
}

List<VocabularyItem> _loadVocabularyItems(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! List) {
    return const [];
  }

  return [
    for (final item in decoded)
      if (item is Map) VocabularyItem.fromJson(Map<String, Object?>.from(item)),
  ];
}

Iterable<File> _jsonFiles(Directory directory) sync* {
  final files =
      directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.json'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    yield file;
  }
}
