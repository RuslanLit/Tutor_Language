import 'dart:io';
import 'dart:convert';

import 'package:tutor_language/core/content/content_document.dart';
import 'package:tutor_language/core/content/educational_content_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_models.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/features/lesson_assembly/lesson_content.dart';
import 'package:tutor_language/features/lesson_assembly/pedagogical_contract_validator.dart';

const _coursePath =
    'assets/languages/spanish/curriculum/spanish_a0_course.json';
const _pronunciationPath =
    'assets/languages/spanish/pronunciation/reference_slice.json';
const _contentDirectories = [
  'vocabulary',
  'grammar',
  'dialogues',
  'readings',
  'templates',
];

void main(List<String> args) async {
  final moduleId = _argValue(args, '--module') ?? 'es.a0.m01';
  final supportLocale = _argValue(args, '--support-locale') ?? 'uk';

  final course = Course.fromJson(_readJsonObject(_coursePath));
  final module = course.modules.firstWhere(
    (module) => module.id == moduleId,
    orElse: () => throw StateError('Module not found: $moduleId'),
  );
  final contentBundle = _readContentBundle();
  final catalog = EducationalContentCatalog(contentBundle);
  final pronunciationCatalog = PronunciationCatalog(
    bundle: PronunciationBundle.fromJson(_readJsonObject(_pronunciationPath)),
  );
  const validator = PedagogicalContractValidator();

  final issues = <PedagogicalContractIssue>[];
  final pronunciationUnitIds = <String>{};
  for (final lessonId in module.lessonIds) {
    final lesson = course.lessons.firstWhere(
      (lesson) => lesson.id == lessonId,
      orElse: () => throw StateError('Lesson not found: $lessonId'),
    );
    final lessonContent = _assembleLessonDefinition(lesson, catalog);
    issues.addAll(
      validator.validateLessonContent(
        lessonContent: lessonContent,
        pronunciationCatalog: pronunciationCatalog,
        supportLocale: supportLocale,
      ),
    );
    for (final activity in lessonContent.activities) {
      for (final content in activity.resolvedContent) {
        if (content is VocabularyItem && content.pronunciationUnitId != null) {
          pronunciationUnitIds.add(content.pronunciationUnitId!);
        }
      }
    }
  }

  issues.addAll(
    validator.validatePronunciationCompleteness(
      pronunciationCatalog: pronunciationCatalog,
      pronunciationUnitIds: pronunciationUnitIds,
      supportLocale: supportLocale,
    ),
  );

  stdout.writeln('Pedagogical contract audit');
  stdout.writeln('module: $moduleId');
  stdout.writeln('support locale: $supportLocale');
  stdout.writeln('lessons: ${module.lessonIds.length}');
  stdout.writeln('pronunciation units: ${pronunciationUnitIds.length}');
  stdout.writeln('issues: ${issues.length}');
  final byCode = <String, int>{};
  for (final issue in issues) {
    byCode.update(issue.code, (count) => count + 1, ifAbsent: () => 1);
  }
  for (final entry
      in byCode.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    stdout.writeln('  ${entry.key}: ${entry.value}');
  }
  for (final issue in issues.take(200)) {
    stdout.writeln(issue);
  }

  if (issues.any(
    (issue) =>
        issue.severity == PedagogicalIssueSeverity.blocker ||
        issue.severity == PedagogicalIssueSeverity.error,
  )) {
    exitCode = 1;
  }
}

String? _argValue(List<String> args, String name) {
  for (var index = 0; index < args.length; index += 1) {
    if (args[index] == name && index + 1 < args.length) {
      return args[index + 1];
    }
    if (args[index].startsWith('$name=')) {
      return args[index].substring(name.length + 1);
    }
  }
  return null;
}

EducationalContentBundle _readContentBundle() {
  final contents = <EducationalContent>[];
  for (final directory in _contentDirectories) {
    final dir = Directory('assets/languages/spanish/$directory');
    for (final file in dir.listSync().whereType<File>()) {
      if (!file.path.endsWith('.json')) {
        continue;
      }
      final assetPath = file.path;
      final items = _readJsonList(assetPath);
      contents.add(switch (directory) {
        'vocabulary' => VocabularyContent(
          assetPath: assetPath,
          entries: items.map(VocabularyItem.fromJson).toList(growable: false),
        ),
        'grammar' => GrammarContent(
          assetPath: assetPath,
          topics: items.map(GrammarTopic.fromJson).toList(growable: false),
        ),
        'dialogues' => DialogueContent(
          assetPath: assetPath,
          dialogues: items.map(Dialogue.fromJson).toList(growable: false),
        ),
        'readings' => ReadingContent(
          assetPath: assetPath,
          texts: items.map(ReadingText.fromJson).toList(growable: false),
        ),
        'templates' => ExerciseTemplateContent(
          assetPath: assetPath,
          templates: items
              .map(ExerciseTemplate.fromJson)
              .toList(growable: false),
        ),
        _ => throw StateError('Unsupported content directory: $directory'),
      });
    }
  }
  return EducationalContentBundle(contents: List.unmodifiable(contents));
}

Map<String, Object?> _readJsonObject(String path) {
  final raw = jsonDecode(_resolveFile(path).readAsStringSync());
  if (raw is Map<String, Object?>) {
    return raw;
  }
  if (raw is Map) {
    return Map<String, Object?>.from(raw);
  }
  throw FormatException('Expected JSON object at $path');
}

List<Map<String, Object?>> _readJsonList(String path) {
  final raw = jsonDecode(_resolveFile(path).readAsStringSync());
  if (raw is! List) {
    throw FormatException('Expected JSON list at $path');
  }
  return [
    for (final item in raw)
      if (item is Map<String, Object?>)
        item
      else if (item is Map)
        Map<String, Object?>.from(item)
      else
        throw FormatException('Expected JSON object list item at $path'),
  ];
}

File _resolveFile(String appRelativePath) {
  final candidates = [File(appRelativePath), File('app/$appRelativePath')];
  for (final candidate in candidates) {
    if (candidate.existsSync()) {
      return candidate;
    }
  }
  throw StateError('File not found: $appRelativePath');
}

LessonContent _assembleLessonDefinition(
  LessonDefinition lesson,
  EducationalContentCatalog catalog,
) {
  return LessonContent(
    lesson: lesson,
    sections: List.unmodifiable(
      lesson.sections.map((section) {
        return LessonContentSection(
          section: section,
          activities: List.unmodifiable(
            section.activities.map((activity) {
              return LessonContentActivity(
                activity: activity,
                resolvedContent: List.unmodifiable([
                  for (final ruleId in activity.introducedReadingRuleIds)
                    ReadingRulePresentationReference(ruleId),
                  for (final ruleId in activity.reviewedReadingRuleIds)
                    ReadingRulePresentationReference(ruleId),
                  for (final reference in activity.contentReferences)
                    ..._resolveReference(reference, catalog),
                ]),
              );
            }),
          ),
        );
      }),
    ),
  );
}

List<Object> _resolveReference(
  LessonContentReference reference,
  EducationalContentCatalog catalog,
) {
  final content = catalog.contentByAssetPath(reference.assetPath);
  if (content == null || content.type != reference.type) {
    throw StateError('Cannot resolve content reference ${reference.assetPath}');
  }
  final referenceId = reference.referenceId;
  if (referenceId == null) {
    return switch (content) {
      VocabularyContent() => content.entries,
      GrammarContent() => content.topics,
      DialogueContent() => content.dialogues,
      ReadingContent() => content.texts,
      ExerciseTemplateContent() => content.templates,
      _ => const [],
    };
  }
  final object = switch (content) {
    VocabularyContent() => _firstWhereOrNull<VocabularyItem>(
      content.entries,
      (entry) => entry.id == referenceId,
    ),
    GrammarContent() => _firstWhereOrNull<GrammarTopic>(
      content.topics,
      (topic) => topic.id == referenceId,
    ),
    DialogueContent() => _firstWhereOrNull<Dialogue>(
      content.dialogues,
      (dialogue) => dialogue.id == referenceId,
    ),
    ReadingContent() => _firstWhereOrNull<ReadingText>(
      content.texts,
      (text) => text.id == referenceId,
    ),
    ExerciseTemplateContent() => _firstWhereOrNull<ExerciseTemplate>(
      content.templates,
      (template) => template.id == referenceId,
    ),
    _ => null,
  };
  if (object == null) {
    throw StateError('Missing content reference $referenceId');
  }
  return [object];
}

T? _firstWhereOrNull<T>(Iterable<T> values, bool Function(T value) test) {
  for (final value in values) {
    if (test(value)) {
      return value;
    }
  }
  return null;
}
