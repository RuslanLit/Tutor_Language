import 'dart:convert';
import 'dart:io';

void main() {
  final issues = <_Issue>[];
  final course = _readJsonObject(
    'assets/languages/spanish/curriculum/spanish_a0_course.json',
  );
  final pronunciation = _readJsonObject(
    'assets/languages/spanish/pronunciation/reference_slice.json',
  );
  final localization = _readJsonObject(
    'assets/languages/spanish/localization/support_localizations.json',
  );

  final positions = _lessonPositions(course);
  _expectPosition(issues, positions, 'es.a0.m06.l016', 1);
  _expectPosition(issues, positions, 'es.a0.m01.l001', 2);
  _expectPosition(issues, positions, 'es.a0.m06.l017', 3);

  final seenPositions = positions.values.toSet();
  if (seenPositions.length != positions.length) {
    issues.add(
      const _Issue(
        'lessonPosition.duplicate',
        'Canonical lesson positions contain duplicates.',
      ),
    );
  }
  for (var index = 1; index <= positions.length; index++) {
    if (!seenPositions.contains(index)) {
      issues.add(
        _Issue(
          'lessonPosition.gap',
          'Canonical lesson position $index is missing.',
        ),
      );
    }
  }

  _auditL016VocabularyReferences(course, issues);
  _auditReadingRulePatterns(pronunciation, issues);
  _auditRussianFields(localization, pronunciation, issues);

  stdout.writeln('Foundational Russian presentation audit');
  stdout.writeln('canonicalLessonCount=${positions.length}');
  stdout.writeln('lessonPositions');
  for (final entry in positions.entries.take(12)) {
    stdout.writeln('${entry.key}\t${entry.value}');
  }
  stdout.writeln('issues=${issues.length}');
  stdout.writeln('errors=${issues.length}');
  for (final issue in issues) {
    stdout.writeln('error\t${issue.code}\t${issue.message}');
  }

  if (issues.isNotEmpty) {
    exitCode = 1;
  }
}

Map<String, Object?> _readJsonObject(String path) {
  final decoded = jsonDecode(File(path).readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    throw StateError('$path did not contain a JSON object.');
  }
  return decoded;
}

Map<String, int> _lessonPositions(Map<String, Object?> course) {
  final modules = course['modules'];
  if (modules is! List) {
    throw StateError('course.modules must be a list.');
  }

  final positions = <String, int>{};
  for (final module in modules.cast<Map<String, Object?>>()) {
    final lessonIds = module['lessonIds'];
    if (lessonIds is! List) {
      continue;
    }
    for (final lessonId in lessonIds.cast<String>()) {
      positions[lessonId] = positions.length + 1;
    }
  }
  return positions;
}

void _expectPosition(
  List<_Issue> issues,
  Map<String, int> positions,
  String lessonId,
  int expectedPosition,
) {
  final actual = positions[lessonId];
  if (actual != expectedPosition) {
    issues.add(
      _Issue(
        'lessonPosition.mismatch',
        '$lessonId expected position $expectedPosition but was $actual.',
      ),
    );
  }
}

void _auditL016VocabularyReferences(
  Map<String, Object?> course,
  List<_Issue> issues,
) {
  final l016 = _lessonById(course, 'es.a0.m06.l016');
  final references = _activityReferences(
    l016,
    'es.a0.m06.l016.activity.vocabulary',
  );
  const helperVocabularyIds = {
    'vocab.es.a0.c2.hache.v1',
    'vocab.es.a0.c2.vocal.v1',
  };

  for (final reference in references) {
    final referenceId = reference['referenceId'];
    if (helperVocabularyIds.contains(referenceId)) {
      issues.add(
        _Issue(
          'vocabulary.helperRendered',
          '$referenceId is rendered as ordinary l016 vocabulary.',
        ),
      );
    }
  }
}

Map<String, Object?> _lessonById(Map<String, Object?> course, String lessonId) {
  final lessons = course['lessons'];
  if (lessons is! List) {
    throw StateError('course.lessons must be a list.');
  }
  return lessons.cast<Map<String, Object?>>().singleWhere((lesson) {
    final metadata = lesson['metadata'];
    return metadata is Map && metadata['id'] == lessonId;
  }, orElse: () => throw StateError('Missing lesson $lessonId.'));
}

List<Map<String, Object?>> _activityReferences(
  Map<String, Object?> lesson,
  String activityId,
) {
  final sections = lesson['sections'];
  if (sections is! List) {
    return const [];
  }
  for (final section in sections.cast<Map<String, Object?>>()) {
    final activities = section['activities'];
    if (activities is! List) {
      continue;
    }
    for (final activity in activities.cast<Map<String, Object?>>()) {
      if (activity['id'] == activityId) {
        final references = activity['references'];
        if (references is List) {
          return references.cast<Map<String, Object?>>();
        }
      }
    }
  }
  return const [];
}

void _auditReadingRulePatterns(
  Map<String, Object?> pronunciation,
  List<_Issue> issues,
) {
  final rules = pronunciation['rules'];
  if (rules is! List) {
    throw StateError('pronunciation.readingRules must be a list.');
  }
  const prohibitedPatterns = {'g before e/i', 'written stress'};

  for (final rule in rules.cast<Map<String, Object?>>()) {
    final id = rule['id'];
    final symbol = rule['symbol'];
    final pattern = rule['orthographicPattern'];
    if (prohibitedPatterns.contains(symbol) ||
        prohibitedPatterns.contains(pattern)) {
      issues.add(
        _Issue(
          'readingRule.englishPattern',
          '$id exposes English instructional pattern "$symbol" / "$pattern".',
        ),
      );
    }
  }
}

void _auditRussianFields(
  Map<String, Object?> localization,
  Map<String, Object?> pronunciation,
  List<_Issue> issues,
) {
  const auditedIds = {
    'es.a0.m06.l016',
    'es.a0.m06.l017',
    'es.a0.m01.l002',
    'vocab.es.a0.unit1.perdon.v1',
    'pronunciation.es.rule.silent_h.v1',
    'pronunciation.es.rule.enye.v1',
    'pronunciation.es.rule.j.v1',
    'pronunciation.es.rule.ll_y.v1',
    'pronunciation.es.rule.c_z.v1',
    'pronunciation.es.rule.g_e_i.v1',
    'pronunciation.es.rule.stable_vowels.v1',
    'pronunciation.es.rule.primary_stress.v1',
  };
  const prohibitedFragments = {
    'written stress',
    'g before e/i',
    'classroom exchanges',
    'sorry',
    'vocal',
    'В испанский',
    'какой буква',
    'пишутся но не произносится',
    'испанский гласные',
    'простой слова',
    'В норме этого курса',
    'относительно стабильно',
    'Курс показывает начальный принцип',
  };

  for (final object in [
    ..._objectsWithIds(localization),
    ..._objectsWithIds(pronunciation),
  ]) {
    final id = object['id'];
    if (id is! String || !auditedIds.contains(id)) {
      continue;
    }
    for (final value in _russianStrings(object)) {
      for (final fragment in prohibitedFragments) {
        if (value.contains(fragment)) {
          issues.add(
            _Issue(
              'russian.prohibitedFragment',
              '$id contains "$fragment" in "$value".',
            ),
          );
        }
      }
    }
  }
}

Iterable<Map<String, Object?>> _objectsWithIds(Object? value) sync* {
  if (value is Map<String, Object?>) {
    if (value['id'] is String) {
      yield value;
    }
    for (final child in value.values) {
      yield* _objectsWithIds(child);
    }
  } else if (value is List) {
    for (final child in value) {
      yield* _objectsWithIds(child);
    }
  }
}

Iterable<String> _russianStrings(Object? value) sync* {
  if (value is Map) {
    final ru = value['ru'];
    if (ru is String) {
      yield ru;
    }
    for (final child in value.values) {
      yield* _russianStrings(child);
    }
  } else if (value is List) {
    for (final child in value) {
      yield* _russianStrings(child);
    }
  }
}

class _Issue {
  const _Issue(this.code, this.message);

  final String code;
  final String message;
}
