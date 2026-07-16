import 'dart:convert';
import 'dart:io';

import 'package:tutor_language/core/content/pronunciation_catalog.dart';
import 'package:tutor_language/core/content/pronunciation_models.dart';
import 'package:tutor_language/core/content/topic_content.dart';

const _coursePath =
    'assets/languages/spanish/curriculum/spanish_a0_course.json';
const _pronunciationPath =
    'assets/languages/spanish/pronunciation/reference_slice.json';

const _auditedModules = {'es.a0.m01', 'es.a0.m02'};

const _releaseRequiredVocabularyIds = {
  'vocab.es.a0.unit1.hola.v1',
  'vocab.es.a0.unit1.adios.v1',
  'vocab.es.a0.unit1.hasta_luego.v1',
  'vocab.es.a0.unit1.gracias.v1',
  'vocab.es.a0.unit1.por_favor.v1',
  'vocab.es.a0.unit1.perdon.v1',
  'vocab.es.a0.unit1.senor.v1',
  'vocab.es.a0.unit1.repite.v1',
  'vocab.es.a0.unit1.me_llamo.v1',
  'vocab.es.a0.m02.jose.v1',
  'vocab.es.a0.c2.espana.v1',
};

void main() {
  final root = Directory('assets/languages/spanish');
  if (!root.existsSync()) {
    stderr.writeln('Run from app/.');
    exitCode = 1;
    return;
  }

  final vocabulary = _loadVocabulary(root);
  final vocabularyById = {
    for (final content in vocabulary)
      for (final item in content.entries) item.id: item,
  };
  final catalog = _loadCatalog(root, vocabulary);
  final course = _jsonObject(File(_coursePath));
  final lessonOrder = _canonicalLessonOrder(course);
  final lessonsById = _lessonsById(course);
  final auditedLessonIds = lessonOrder
      .where(
        (lessonId) => _auditedModules.contains(
          _stringAt(lessonsById[lessonId], ['metadata', 'moduleId']),
        ),
      )
      .toList();

  final introducedRules = <String>{};
  final firstIntroductions = <String, String>{};
  final firstRequiredUses = <String, String>{};
  final issues = <_Issue>[];
  final formRows = <_FormRow>[];

  final l017Index = lessonOrder.indexOf('es.a0.m06.l017');
  final l004Index = lessonOrder.indexOf('es.a0.m02.l004');
  if (l017Index < 0 || l004Index < 0 || l017Index > l004Index) {
    issues.add(
      const _Issue(
        severity: _Severity.error,
        code: 'readingSequence.llYAfterMeLlamo',
        message: 'll/y foundation lesson must precede My Name Is.',
      ),
    );
  }

  for (final lessonId in auditedLessonIds) {
    final lesson = lessonsById[lessonId]!;
    final lessonIntroductions = _stringListAt(lesson, [
      'metadata',
      'introducedReadingRuleIds',
    ]);
    for (final ruleId in lessonIntroductions) {
      firstIntroductions.putIfAbsent(ruleId, () => lessonId);
    }

    for (final activity in _orderedActivities(lesson)) {
      final activityId = _stringAt(activity, ['id']) ?? '<unknown>';
      for (final ruleId in _stringListAt(activity, [
        'requiredReadingRuleIds',
      ])) {
        firstRequiredUses.putIfAbsent(ruleId, () => '$lessonId/$activityId');
        if (!introducedRules.contains(ruleId)) {
          issues.add(
            _Issue(
              severity: _Severity.error,
              code: 'readingSequence.activeUseBeforeIntroduction',
              message: '$ruleId required by $lessonId/$activityId',
            ),
          );
        }
      }

      for (final ruleId in _stringListAt(activity, [
        'introducedReadingRuleIds',
      ])) {
        introducedRules.add(ruleId);
        firstIntroductions.putIfAbsent(ruleId, () => '$lessonId/$activityId');
      }

      for (final reference in _references(activity)) {
        final type = _stringAt(reference, ['type']);
        final referenceId = _stringAt(reference, ['referenceId']);
        if (type == null || referenceId == null) {
          continue;
        }
        if (type == 'vocabulary') {
          final item = vocabularyById[referenceId];
          if (item == null) {
            continue;
          }
          final unit = _unitForVocabulary(catalog, item);
          final state = _pronunciationState(item, unit);
          formRows.add(
            _FormRow(
              targetForm: item.spanish,
              lessonId: lessonId,
              activityId: activityId,
              mode: 'passive',
              vocabularyId: item.id,
              pronunciationUnitId: unit?.id.value,
              readingRuleIds: unit?.readingRuleIds ?? const [],
              state: state,
            ),
          );
          _validateVocabularyPronunciation(
            item: item,
            unit: unit,
            issues: issues,
            lessonId: lessonId,
            activityId: activityId,
          );
        }

        if (type == 'exercise_template') {
          final object = _findReferencedObject(reference);
          if (object == null) {
            continue;
          }
          final text = _allStrings(object).join('\n').toLowerCase();
          for (final unit in catalog.units) {
            final target = unit.targetOrthography.toLowerCase();
            if (target.length < 3 || !text.contains(target)) {
              continue;
            }
            formRows.add(
              _FormRow(
                targetForm: unit.targetOrthography,
                lessonId: lessonId,
                activityId: activityId,
                mode: 'active',
                vocabularyId: null,
                pronunciationUnitId: unit.id.value,
                readingRuleIds: unit.readingRuleIds,
                state: 'complete',
              ),
            );
            for (final ruleId in unit.readingRuleIds) {
              firstRequiredUses.putIfAbsent(
                ruleId,
                () => '$lessonId/$activityId',
              );
              if (!introducedRules.contains(ruleId)) {
                issues.add(
                  _Issue(
                    severity: _Severity.error,
                    code: 'readingSequence.activeUseBeforeIntroduction',
                    message:
                        '${unit.targetOrthography} requires $ruleId before $lessonId/$activityId',
                  ),
                );
              }
            }
          }
        }
      }
    }

    for (final ruleId in lessonIntroductions) {
      introducedRules.add(ruleId);
    }
  }

  final uniqueRows = <String, _FormRow>{};
  for (final row in formRows) {
    uniqueRows.putIfAbsent(
      '${row.targetForm}|${row.lessonId}|${row.activityId}|${row.mode}',
      () => row,
    );
  }

  _printReport(
    lessonOrder: lessonOrder,
    auditedLessonIds: auditedLessonIds,
    rows: uniqueRows.values.toList()
      ..sort((a, b) => a.sortKey.compareTo(b.sortKey)),
    firstIntroductions: firstIntroductions,
    firstRequiredUses: firstRequiredUses,
    issues: issues,
  );

  if (issues.any((issue) => issue.severity == _Severity.error)) {
    exitCode = 1;
  }
}

void _validateVocabularyPronunciation({
  required VocabularyItem item,
  required PronunciationUnit? unit,
  required List<_Issue> issues,
  required String lessonId,
  required String activityId,
}) {
  final requiredForRelease = _releaseRequiredVocabularyIds.contains(item.id);
  if (unit == null) {
    issues.add(
      _Issue(
        severity: requiredForRelease ? _Severity.error : _Severity.warning,
        code: requiredForRelease
            ? 'pronunciation.wordIpaMissingForActiveVocabulary'
            : 'pronunciation.deferredVocabularyPronunciation',
        message: '${item.id} has no PronunciationUnit at $lessonId/$activityId',
      ),
    );
    return;
  }
  if (_pronunciationComparable(unit.targetOrthography) !=
      _pronunciationComparable(item.spanish)) {
    issues.add(
      _Issue(
        severity: _Severity.error,
        code: 'pronunciation.targetOrthographyMismatch',
        message:
            '${item.id} uses ${unit.id.value} for ${unit.targetOrthography}',
      ),
    );
  }
  if (unit.id.value.contains('.sound.') ||
      (unit.targetOrthography.length <= 2 && item.spanish.length > 2)) {
    issues.add(
      _Issue(
        severity: _Severity.error,
        code: 'pronunciation.partialIpaUsedAsWordIpa',
        message: '${item.id} resolves to sound fragment ${unit.id.value}',
      ),
    );
  }
  if (requiredForRelease && unit.ipa == null) {
    issues.add(
      _Issue(
        severity: _Severity.error,
        code: 'pronunciation.wordIpaMissingForActiveVocabulary',
        message: '${item.id} has no whole-word IPA',
      ),
    );
  }
  if (requiredForRelease &&
      !unit.localizedLearnerHints.containsKey('ru') &&
      item.pronunciationUnitId != null) {
    issues.add(
      _Issue(
        severity: _Severity.error,
        code: 'pronunciation.activeWordWithoutLearnerHint',
        message: '${item.id} has no Russian learner hint',
      ),
    );
  }
}

String _pronunciationComparable(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[¡!¿?.,;:"“”«»]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String _pronunciationState(VocabularyItem item, PronunciationUnit? unit) {
  if (unit == null) {
    return _releaseRequiredVocabularyIds.contains(item.id)
        ? 'missing-required'
        : 'deferred';
  }
  if (unit.id.value.contains('.sound.')) {
    return 'partial-ipa-misuse';
  }
  if (unit.ipa == null) {
    return 'missing-ipa';
  }
  if (!unit.localizedLearnerHints.containsKey('ru')) {
    return 'missing-ru-hint';
  }
  return 'complete';
}

PronunciationUnit? _unitForVocabulary(
  PronunciationCatalog catalog,
  VocabularyItem item,
) {
  final direct = item.pronunciationUnitId;
  if (direct != null) {
    return catalog.unitById(direct);
  }
  return catalog.unitForContentId(item.id);
}

void _printReport({
  required List<String> lessonOrder,
  required List<String> auditedLessonIds,
  required List<_FormRow> rows,
  required Map<String, String> firstIntroductions,
  required Map<String, String> firstRequiredUses,
  required List<_Issue> issues,
}) {
  stdout.writeln('Spanish A0 reading sequence audit');
  stdout.writeln('auditedModules=${_auditedModules.toList()..sort()}');
  stdout.writeln('auditedLessons=${auditedLessonIds.length}');
  stdout.writeln('courseOrder.module1_2');
  for (final lessonId in auditedLessonIds) {
    stdout.writeln('${lessonOrder.indexOf(lessonId) + 1}\t$lessonId');
  }
  stdout.writeln('firstIntroductions');
  for (final entry in _sortedEntries(firstIntroductions)) {
    stdout.writeln('${entry.key}\t${entry.value}');
  }
  stdout.writeln('firstRequiredUses');
  for (final entry in _sortedEntries(firstRequiredUses)) {
    stdout.writeln('${entry.key}\t${entry.value}');
  }
  stdout.writeln('forms');
  for (final row in rows) {
    stdout.writeln(row.toLine());
  }
  stdout.writeln('issues=${issues.length}');
  stdout.writeln(
    'errors=${issues.where((issue) => issue.severity == _Severity.error).length}',
  );
  stdout.writeln(
    'warnings=${issues.where((issue) => issue.severity == _Severity.warning).length}',
  );
  for (final issue in issues..sort((a, b) => a.line.compareTo(b.line))) {
    stdout.writeln(issue.line);
  }
}

List<MapEntry<String, String>> _sortedEntries(Map<String, String> map) {
  return map.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
}

List<String> _canonicalLessonOrder(Map<String, Object?> course) {
  final modules = (course['modules'] as List?) ?? const [];
  return [
    for (final module in modules)
      if (module is Map)
        for (final lessonId in ((module['lessonIds'] as List?) ?? const []))
          if (lessonId is String) lessonId,
  ];
}

Map<String, Map<String, Object?>> _lessonsById(Map<String, Object?> course) {
  final lessons = (course['lessons'] as List?) ?? const [];
  final lessonsById = <String, Map<String, Object?>>{};

  for (final lesson in lessons) {
    if (lesson is! Map) {
      continue;
    }

    final id = _stringAt(lesson, ['metadata', 'id']);
    if (id != null) {
      lessonsById[id] = Map<String, Object?>.from(lesson);
    }
  }

  return lessonsById;
}

List<Map<String, Object?>> _orderedActivities(Map<String, Object?> lesson) {
  final sections =
      ((lesson['sections'] as List?) ?? const [])
          .whereType<Map>()
          .map((section) => Map<String, Object?>.from(section))
          .toList()
        ..sort((a, b) => _intAt(a, ['order']).compareTo(_intAt(b, ['order'])));

  final activities = <Map<String, Object?>>[];
  for (final section in sections) {
    final sectionActivities =
        ((section['activities'] as List?) ?? const [])
            .whereType<Map>()
            .map((activity) => Map<String, Object?>.from(activity))
            .toList()
          ..sort(
            (a, b) => _intAt(a, ['order']).compareTo(_intAt(b, ['order'])),
          );
    activities.addAll(sectionActivities);
  }
  return activities;
}

List<Map<String, Object?>> _references(Map<String, Object?> activity) {
  return ((activity['references'] as List?) ?? const [])
      .whereType<Map>()
      .map((reference) => Map<String, Object?>.from(reference))
      .toList();
}

Map<String, Object?>? _findReferencedObject(Map<String, Object?> reference) {
  final assetPath = _stringAt(reference, ['assetPath']);
  final referenceId = _stringAt(reference, ['referenceId']);
  if (assetPath == null || referenceId == null) {
    return null;
  }
  final file = File(assetPath);
  if (!file.existsSync()) {
    return null;
  }
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! List) {
    return null;
  }
  for (final item in decoded) {
    if (item is Map && item['id'] == referenceId) {
      return Map<String, Object?>.from(item);
    }
  }
  return null;
}

Iterable<String> _allStrings(Object? value) sync* {
  if (value is String) {
    yield value;
  } else if (value is List) {
    for (final item in value) {
      yield* _allStrings(item);
    }
  } else if (value is Map) {
    for (final item in value.values) {
      yield* _allStrings(item);
    }
  }
}

Map<String, Object?> _jsonObject(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map) {
    throw FormatException('${file.path} must contain a JSON object');
  }
  return Map<String, Object?>.from(decoded);
}

String? _stringAt(Map? object, List<String> path) {
  Object? current = object;
  for (final part in path) {
    if (current is! Map) {
      return null;
    }
    current = current[part];
  }
  return current is String ? current : null;
}

int _intAt(Map<String, Object?> object, List<String> path) {
  Object? current = object;
  for (final part in path) {
    if (current is! Map) {
      return 0;
    }
    current = current[part];
  }
  return current is int ? current : 0;
}

List<String> _stringListAt(Map<String, Object?> object, List<String> path) {
  Object? current = object;
  for (final part in path) {
    if (current is! Map) {
      return const [];
    }
    current = current[part];
  }
  if (current is! List) {
    return const [];
  }
  return [
    for (final value in current)
      if (value is String) value,
  ];
}

PronunciationCatalog _loadCatalog(
  Directory root,
  List<VocabularyContent> vocabulary,
) {
  final decoded = _jsonObject(File(_pronunciationPath));
  final bundle = PronunciationBundle.fromJson(decoded);
  return PronunciationCatalog(bundle: bundle, vocabularyContents: vocabulary);
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

class _FormRow {
  const _FormRow({
    required this.targetForm,
    required this.lessonId,
    required this.activityId,
    required this.mode,
    required this.vocabularyId,
    required this.pronunciationUnitId,
    required this.readingRuleIds,
    required this.state,
  });

  final String targetForm;
  final String lessonId;
  final String activityId;
  final String mode;
  final String? vocabularyId;
  final String? pronunciationUnitId;
  final List<String> readingRuleIds;
  final String state;

  String get sortKey => '$lessonId|$activityId|$targetForm|$mode';

  String toLine() {
    return [
      targetForm,
      lessonId,
      activityId,
      mode,
      vocabularyId ?? '-',
      pronunciationUnitId ?? '-',
      readingRuleIds.join(','),
      state,
    ].join('\t');
  }
}

enum _Severity { error, warning }

class _Issue {
  const _Issue({
    required this.severity,
    required this.code,
    required this.message,
  });

  final _Severity severity;
  final String code;
  final String message;

  String get line => '${severity.name}\t$code\t$message';
}
