import 'dart:convert';
import 'dart:io';

import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_models.dart';
import 'package:tutor_language/core/content/topic_content.dart';

import 'spanish_a0_pronunciation_inventory_support.dart';

void main() {
  final root = Directory('assets/languages/spanish');
  if (!root.existsSync()) {
    stderr.writeln('Run from app/.');
    exitCode = 1;
    return;
  }

  final catalog = _loadCatalog(root);
  final result = catalog.validationResult();
  final inventory = buildSpanishA0PronunciationInventory(
    appDirectory: Directory.current,
  );

  stdout.writeln('Pronunciation validation');
  stdout.writeln('issues=${result.issues.length}');
  stdout.writeln('errors=${result.issues.where(_isError).length}');
  stdout.writeln('warnings=${result.issues.where(_isWarning).length}');
  stdout.writeln('productionLessonsAudited=${inventory.lessonsAudited}');
  stdout.writeln('productionLearnerFacingForms=${inventory.totalItems}');
  stdout.writeln('productionPronunciationCovered=${inventory.coveredItems}');
  stdout.writeln('productionPronunciationMissing=${inventory.missingItems}');

  for (final issue in result.issues) {
    stdout.writeln('${issue.severity.name}\t${issue.code}\t${issue.message}');
  }
  for (final item in inventory.items.where((item) => !item.isCovered)) {
    stdout.writeln(
      'error\tpronunciation.productionFormIncomplete\t${item.form} from ${item.sourceId}',
    );
  }

  if (result.hasErrors || !inventory.isComplete) {
    exitCode = 1;
  }
}

bool _isError(PronunciationValidationIssue issue) {
  return issue.severity == PronunciationIssueSeverity.error;
}

bool _isWarning(PronunciationValidationIssue issue) {
  return issue.severity == PronunciationIssueSeverity.warning;
}

PronunciationCatalog _loadCatalog(Directory root) {
  final pronunciationFile = File(
    '${root.path}/pronunciation/reference_slice.json',
  );
  final decoded = jsonDecode(pronunciationFile.readAsStringSync());
  if (decoded is! Map) {
    throw const FormatException('Pronunciation bundle must be an object');
  }

  final bundle = PronunciationBundle.fromJson(
    Map<String, Object?>.from(decoded),
  );
  return PronunciationCatalog(
    bundle: bundle,
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
