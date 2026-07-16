import 'dart:convert';
import 'dart:io';

class SpanishA0PronunciationInventory {
  SpanishA0PronunciationInventory({
    required this.items,
    required this.totalItems,
    required this.coveredItems,
    required this.missingItems,
    required this.uniqueForms,
    required this.coveredUniqueForms,
    required this.missingUniqueForms,
    required this.lessonsAudited,
  });

  final List<SpanishA0PronunciationInventoryItem> items;
  final int totalItems;
  final int coveredItems;
  final int missingItems;
  final int uniqueForms;
  final int coveredUniqueForms;
  final int missingUniqueForms;
  final int lessonsAudited;

  bool get isComplete => missingItems == 0 && missingUniqueForms == 0;

  Map<String, Object?> toJson() {
    return {
      'lessonsAudited': lessonsAudited,
      'totalItems': totalItems,
      'coveredItems': coveredItems,
      'missingItems': missingItems,
      'uniqueForms': uniqueForms,
      'coveredUniqueForms': coveredUniqueForms,
      'missingUniqueForms': missingUniqueForms,
      'items': [for (final item in items) item.toJson()],
    };
  }
}

class SpanishA0PronunciationInventoryItem {
  SpanishA0PronunciationInventoryItem({
    required this.form,
    required this.normalizedForm,
    required this.role,
    required this.activeRecall,
    required this.sourceKind,
    required this.sourceId,
    required this.assetPath,
    required this.lessonIds,
    required this.pronunciationUnitId,
    required this.hasIpa,
    required this.hasRussianHint,
    required this.hasRequiredStress,
    required this.readingRuleIds,
  });

  final String form;
  final String normalizedForm;
  final String role;
  final bool activeRecall;
  final String sourceKind;
  final String sourceId;
  final String assetPath;
  final List<String> lessonIds;
  final String? pronunciationUnitId;
  final bool hasIpa;
  final bool hasRussianHint;
  final bool hasRequiredStress;
  final List<String> readingRuleIds;

  bool get isCovered =>
      pronunciationUnitId != null &&
      hasIpa &&
      hasRussianHint &&
      hasRequiredStress &&
      readingRuleIds.isNotEmpty;

  Map<String, Object?> toJson() {
    return {
      'form': form,
      'normalizedForm': normalizedForm,
      'role': role,
      'activeRecall': activeRecall,
      'sourceKind': sourceKind,
      'sourceId': sourceId,
      'assetPath': assetPath,
      'lessonIds': lessonIds,
      'pronunciationUnitId': pronunciationUnitId,
      'hasIpa': hasIpa,
      'hasRussianHint': hasRussianHint,
      'hasRequiredStress': hasRequiredStress,
      'readingRuleIds': readingRuleIds,
      'covered': isCovered,
    };
  }
}

class PronunciationInventorySource {
  PronunciationInventorySource({
    required this.form,
    required this.role,
    required this.activeRecall,
    required this.sourceKind,
    required this.sourceId,
    required this.assetPath,
    required this.lessonId,
  });

  final String form;
  final String role;
  final bool activeRecall;
  final String sourceKind;
  final String sourceId;
  final String assetPath;
  final String lessonId;
}

SpanishA0PronunciationInventory buildSpanishA0PronunciationInventory({
  Directory? appDirectory,
}) {
  final root = appDirectory ?? Directory.current;
  final spanishRoot = Directory('${root.path}/assets/languages/spanish');
  final course = _jsonObject(
    File('${spanishRoot.path}/curriculum/spanish_a0_course.json'),
  );
  final referencesByLessonId = _lessonReferenceIndex(course);
  final lessonIds = referencesByLessonId.keys.toList()..sort();
  final sources = <PronunciationInventorySource>[];
  for (final entry in referencesByLessonId.entries) {
    final lessonId = entry.key;
    for (final reference in entry.value) {
      sources.addAll(_sourcesForReference(spanishRoot, reference, lessonId));
    }
  }

  final rawBundle = _jsonObject(
    File('${spanishRoot.path}/pronunciation/reference_slice.json'),
  );
  final units = _pronunciationUnits(rawBundle);
  final vocabularyUnitRefs = _vocabularyPronunciationUnitRefs(spanishRoot);
  final unitsByNormalizedForm = <String, List<Map<String, Object?>>>{};
  for (final unit in units) {
    final target = unit['targetOrthography'];
    if (target is! String || target.trim().isEmpty) {
      continue;
    }
    unitsByNormalizedForm
        .putIfAbsent(normalizeSpanishForm(target), () => [])
        .add(unit);
  }

  final groupedSources = <String, List<PronunciationInventorySource>>{};
  for (final source in sources) {
    final normalized = normalizeSpanishForm(source.form);
    if (normalized.isEmpty || !_shouldInventorySource(source)) {
      continue;
    }
    groupedSources.putIfAbsent(normalized, () => []).add(source);
  }

  final items = <SpanishA0PronunciationInventoryItem>[];
  for (final entry in groupedSources.entries) {
    final group = entry.value;
    group.sort(_sourceCompare);
    final first = group.first;
    final directUnitId = vocabularyUnitRefs[first.sourceId];
    final candidates = [
      if (directUnitId != null)
        ...units.where(
          (unit) =>
              unit['id'] == directUnitId &&
              normalizeSpanishForm(
                    unit['targetOrthography'] as String? ?? '',
                  ) ==
                  entry.key,
        ),
      ...?unitsByNormalizedForm[entry.key],
    ];
    final unit = candidates.isEmpty ? null : candidates.first;
    final ruHint = _russianHint(unit);
    final rules = _stringList(unit?['readingRuleIds']);
    final lessonIdsForForm = {
      for (final source in group) source.lessonId,
    }.toList()..sort();

    items.add(
      SpanishA0PronunciationInventoryItem(
        form: first.form.trim(),
        normalizedForm: entry.key,
        role: _strongestRole(group),
        activeRecall: group.any((source) => source.activeRecall),
        sourceKind: first.sourceKind,
        sourceId: first.sourceId,
        assetPath: first.assetPath,
        lessonIds: lessonIdsForForm,
        pronunciationUnitId: unit?['id'] as String?,
        hasIpa: (unit?['ipa'] as String?)?.trim().isNotEmpty ?? false,
        hasRussianHint: ruHint != null && ruHint.trim().isNotEmpty,
        hasRequiredStress: !_requiresStress(first.form) || _hasStress(ruHint),
        readingRuleIds: rules,
      ),
    );
  }

  items.sort((a, b) {
    final role = a.role.compareTo(b.role);
    if (role != 0) return role;
    return a.normalizedForm.compareTo(b.normalizedForm);
  });
  final coveredItems = items.where((item) => item.isCovered).length;
  final uniqueMissing = {
    for (final item in items)
      if (!item.isCovered) item.normalizedForm,
  }.length;

  return SpanishA0PronunciationInventory(
    items: List.unmodifiable(items),
    totalItems: items.length,
    coveredItems: coveredItems,
    missingItems: items.length - coveredItems,
    uniqueForms: items.length,
    coveredUniqueForms: coveredItems,
    missingUniqueForms: uniqueMissing,
    lessonsAudited: lessonIds.length,
  );
}

Map<String, Object?> loadSpanishA0PronunciationBundle({
  Directory? appDirectory,
}) {
  final root = appDirectory ?? Directory.current;
  return _jsonObject(
    File(
      '${root.path}/assets/languages/spanish/pronunciation/reference_slice.json',
    ),
  );
}

List<Map<String, Object?>> loadSpanishA0VocabularyItems({
  Directory? appDirectory,
}) {
  final root = appDirectory ?? Directory.current;
  final directory = Directory(
    '${root.path}/assets/languages/spanish/vocabulary',
  );
  return [
    for (final file in _jsonFiles(directory))
      for (final item in _jsonArray(file))
        if (item is Map)
          {...Map<String, Object?>.from(item), '__assetPath': file.path},
  ];
}

Map<String, Object?> buildPronunciationUnitForForm({
  required String form,
  required Iterable<PronunciationInventorySource> sources,
  String? existingId,
}) {
  final normalized = normalizeSpanishForm(form);
  final category = _unitCategory(form);
  final id = existingId ?? 'pronunciation.es.$category.${_slug(normalized)}.v1';
  final sourceList = sources.toList()..sort(_sourceCompare);
  final relatedContentIds = {
    for (final source in sourceList) source.sourceId,
  }.toList()..sort();
  final relatedVocabularyIds = sourceList
      .where(
        (source) =>
            source.role == 'vocabulary' &&
            source.sourceId.startsWith('vocab.') &&
            normalizeSpanishForm(source.form) == normalized,
      )
      .map((source) => source.sourceId)
      .toSet()
      .toList();
  relatedVocabularyIds.sort();
  final rules = readingRulesForSpanishForm(form);
  return {
    'id': id,
    'schemaVersion': 1,
    'targetLanguage': 'es',
    'targetOrthography': form.trim(),
    'pronunciationVariety': 'es-general',
    'ipa': spanishBroadIpa(form),
    'readingRuleIds': rules,
    'localizedLearnerHints': {'ru': russianLearnerHint(form)},
    'difficulty': 'a0-release',
    'relatedContentIds': relatedContentIds,
    if (relatedVocabularyIds.isNotEmpty)
      'relatedVocabularyIds': relatedVocabularyIds,
    'metadata': {
      'releaseReference': 'true',
      'inventoryGenerated': 'true',
      if (rules.contains('pronunciation.es.rule.ll_y.v1'))
        'llYPolicy': 'yeismo',
      if (_needsExplanation(form)) 'explanationRequired': 'true',
    },
  };
}

Map<String, Object?> buildPronunciationLocalizationForUnit(
  Map<String, Object?> unit,
) {
  final form = unit['targetOrthography'] as String;
  final hints = Map<String, Object?>.from(
    unit['localizedLearnerHints'] as Map? ?? const {},
  );
  final explanations = <String, String>{};
  if (_needsExplanation(form)) {
    explanations['ru'] = _russianExplanation(form);
    explanations['en'] = _englishExplanation(form);
  }
  return {
    'id': unit['id'],
    'learnerHints': {'ru': hints['ru'] ?? russianLearnerHint(form)},
    'explanations': explanations,
  };
}

List<String> readingRulesForSpanishForm(String form) {
  final lower = _lettersOnly(form).toLowerCase();
  final rules = <String>{};
  if (RegExp(r'[aeiouáéíóúü]').hasMatch(lower)) {
    rules.add('pronunciation.es.rule.stable_vowels.v1');
  }
  if (_requiresStress(form)) {
    rules.add('pronunciation.es.rule.primary_stress.v1');
  }
  if (lower.contains('h')) rules.add('pronunciation.es.rule.silent_h.v1');
  if (lower.contains('ñ')) rules.add('pronunciation.es.rule.enye.v1');
  if (lower.contains('j')) rules.add('pronunciation.es.rule.j.v1');
  if (lower.contains('ll') || _hasConsonantalY(lower)) {
    rules.add('pronunciation.es.rule.ll_y.v1');
  }
  if (lower.contains('rr')) rules.add('pronunciation.es.rule.rr.v1');
  if (RegExp(r'(^|\s)(r)|[^r]r[^r]').hasMatch(lower)) {
    rules.add('pronunciation.es.rule.r.v1');
  }
  if (RegExp(r'[bv]').hasMatch(lower)) {
    rules.add('pronunciation.es.rule.b_v.v1');
  }
  if (RegExp(r'[cz]').hasMatch(lower)) {
    rules.add('pronunciation.es.rule.c_z.v1');
  }
  if (RegExp(r'g[eiíé]').hasMatch(lower)) {
    rules.add('pronunciation.es.rule.g_e_i.v1');
  }
  if (lower.contains('ue')) {
    rules.add('pronunciation.es.rule.diphthong_ue.v1');
  }
  return rules.toList()..sort();
}

String normalizeSpanishForm(String value) {
  return value
      .replaceAll(RegExp(r'[“”"«»]'), '')
      .replaceAll(RegExp(r'[¡!¿?.,;:]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .toLowerCase();
}

String spanishBroadIpa(String form) {
  final words = _words(form);
  final rendered = <String>[];
  for (final word in words) {
    rendered.add(_ipaWord(word));
  }
  return '/${rendered.join(' ')}/';
}

String russianLearnerHint(String form) {
  final words = _words(form);
  return words.map(_russianHintWord).join(' ');
}

String inventoryMarkdown(SpanishA0PronunciationInventory inventory) {
  final buffer = StringBuffer()
    ..writeln('# Spanish A0 Pronunciation Inventory')
    ..writeln()
    ..writeln('Status: ${inventory.isComplete ? 'Complete' : 'Incomplete'}')
    ..writeln()
    ..writeln('| Metric | Value |')
    ..writeln('| --- | ---: |')
    ..writeln('| Lessons audited | ${inventory.lessonsAudited} |')
    ..writeln('| Learner-facing Spanish forms | ${inventory.totalItems} |')
    ..writeln('| Covered forms | ${inventory.coveredItems} |')
    ..writeln('| Missing or incomplete forms | ${inventory.missingItems} |')
    ..writeln()
    ..writeln('## Missing Or Incomplete')
    ..writeln()
    ..writeln('| Form | Role | Source | Lessons | Issue |')
    ..writeln('| --- | --- | --- | --- | --- |');

  final missing = inventory.items.where((item) => !item.isCovered).toList();
  if (missing.isEmpty) {
    buffer.writeln('| None | - | - | - | - |');
  } else {
    for (final item in missing) {
      final issue = [
        if (item.pronunciationUnitId == null) 'missing unit',
        if (!item.hasIpa) 'missing IPA',
        if (!item.hasRussianHint) 'missing ru hint',
        if (!item.hasRequiredStress) 'missing stress',
        if (item.readingRuleIds.isEmpty) 'missing reading rules',
      ].join(', ');
      buffer.writeln(
        '| ${_escapeMd(item.form)} | ${item.role} | ${item.sourceId} | ${item.lessonIds.join(', ')} | $issue |',
      );
    }
  }

  buffer
    ..writeln()
    ..writeln('## Covered Forms')
    ..writeln()
    ..writeln('| Form | Role | Unit | Lessons |')
    ..writeln('| --- | --- | --- | --- |');
  for (final item in inventory.items.where((item) => item.isCovered)) {
    buffer.writeln(
      '| ${_escapeMd(item.form)} | ${item.role} | ${item.pronunciationUnitId} | ${item.lessonIds.join(', ')} |',
    );
  }
  return buffer.toString();
}

Map<String, List<PronunciationInventorySource>>
collectSpanishA0PronunciationSources({Directory? appDirectory}) {
  final root = appDirectory ?? Directory.current;
  final spanishRoot = Directory('${root.path}/assets/languages/spanish');
  final course = _jsonObject(
    File('${spanishRoot.path}/curriculum/spanish_a0_course.json'),
  );
  final referencesByLessonId = _lessonReferenceIndex(course);
  final grouped = <String, List<PronunciationInventorySource>>{};
  for (final entry in referencesByLessonId.entries) {
    for (final reference in entry.value) {
      for (final source in _sourcesForReference(
        spanishRoot,
        reference,
        entry.key,
      )) {
        if (!_shouldInventorySource(source)) continue;
        grouped
            .putIfAbsent(normalizeSpanishForm(source.form), () => [])
            .add(source);
      }
    }
  }
  return grouped;
}

Map<String, List<Map<String, Object?>>> _lessonReferenceIndex(
  Map<String, Object?> course,
) {
  final lessons = (course['lessons'] as List? ?? const [])
      .whereType<Map>()
      .map((json) => Map<String, Object?>.from(json))
      .toList();
  final index = <String, List<Map<String, Object?>>>{};
  for (final lesson in lessons) {
    final metadata = Map<String, Object?>.from(lesson['metadata'] as Map);
    final lessonId = metadata['id'] as String;
    final refs = <Map<String, Object?>>[];
    for (final section in (lesson['sections'] as List? ?? const [])) {
      if (section is! Map) continue;
      for (final activity in (section['activities'] as List? ?? const [])) {
        if (activity is! Map) continue;
        for (final ref in (activity['references'] as List? ?? const [])) {
          if (ref is Map) refs.add(Map<String, Object?>.from(ref));
        }
      }
    }
    index[lessonId] = refs;
  }
  return index;
}

List<PronunciationInventorySource> _sourcesForReference(
  Directory spanishRoot,
  Map<String, Object?> reference,
  String lessonId,
) {
  final type = reference['type'] as String?;
  final assetPath = reference['assetPath'] as String?;
  final referenceId = reference['referenceId'] as String?;
  if (type == null || assetPath == null || referenceId == null) {
    return const [];
  }
  final file = File(
    assetPath.replaceFirst('assets/languages/spanish', spanishRoot.path),
  );
  if (!file.existsSync()) return const [];
  final decoded = jsonDecode(file.readAsStringSync());
  final asset = file.path;
  if (decoded is! List) return const [];
  final objects = decoded.whereType<Map>().map(
    (json) => Map<String, Object?>.from(json),
  );
  for (final object in objects) {
    if (object['id'] != referenceId) continue;
    return _sourcesFromObject(type, object, asset, lessonId);
  }
  return const [];
}

List<PronunciationInventorySource> _sourcesFromObject(
  String type,
  Map<String, Object?> object,
  String assetPath,
  String lessonId,
) {
  final id = object['id'] as String? ?? 'unknown';
  final sources = <PronunciationInventorySource>[];
  void add(String? form, String role, bool active) {
    if (form == null || form.trim().isEmpty) return;
    for (final part in _splitSpanishForms(form)) {
      if (part.trim().isEmpty) continue;
      sources.add(
        PronunciationInventorySource(
          form: part.trim(),
          role: role,
          activeRecall: active,
          sourceKind: type,
          sourceId: id,
          assetPath: assetPath,
          lessonId: lessonId,
        ),
      );
    }
  }

  switch (type) {
    case 'vocabulary':
      add(object['spanish'] as String?, 'vocabulary', false);
      add(object['example'] as String?, 'example', false);
    case 'grammar':
      for (final example in _stringList(object['examples'])) {
        add(_spanishSide(example), 'grammar_example', false);
      }
    case 'dialogue':
      for (final line in (object['lines'] as List? ?? const [])) {
        if (line is Map) {
          add(line['spanish'] as String?, 'dialogue_line', false);
        }
      }
    case 'reading':
      add(object['text'] as String?, 'reading_sentence', false);
    case 'exercise_template':
      add(object['expected_answer'] as String?, 'expected_answer', true);
      for (final answer in _stringList(object['accepted_answers'])) {
        add(answer, 'accepted_answer', true);
      }
      for (final answer
          in (object['accepted_with_feedback_answers'] as List? ?? const [])) {
        if (answer is Map) {
          add(
            answer['answer'] as String?,
            'accepted_with_feedback_answer',
            true,
          );
          add(answer['canonical_answer'] as String?, 'canonical_answer', true);
        }
      }
      for (final misconception
          in (object['authored_misconceptions'] as List? ?? const [])) {
        if (misconception is Map) {
          add(
            misconception['canonical_answer'] as String?,
            'misconception_canonical',
            true,
          );
          for (final answer in _stringList(misconception['matching_answers'])) {
            add(answer, 'misconception_answer', true);
          }
        }
      }
      for (final option in (object['answer_options'] as List? ?? const [])) {
        if (option is Map) {
          add(option['label'] as String?, 'answer_option', false);
        }
      }
      for (final quoted in _quotedSpanish(
        object['prompt_template'] as String?,
      )) {
        add(quoted, 'prompt_spanish', false);
      }
  }
  return sources;
}

List<String> _splitSpanishForms(String form) {
  final normalized = form.replaceAll('\n', ' ').trim();
  if (normalized.isEmpty) return const [];
  final sentenceParts = normalized
      .split(RegExp(r'(?<=[.!?])\s+'))
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList();
  return sentenceParts.isEmpty ? [normalized] : sentenceParts;
}

List<String> _quotedSpanish(String? value) {
  if (value == null) return const [];
  final matches = RegExp(r'["“]([^"”]+)["”]').allMatches(value);
  return [
    for (final match in matches)
      if (_isLearnerFacingSpanish(match.group(1) ?? '')) match.group(1)!,
  ];
}

String? _spanishSide(String example) {
  final split = example.split(RegExp(r'\s+[—–-]\s+'));
  return split.isEmpty ? example : split.first;
}

bool _isLearnerFacingSpanish(String value) {
  final lower = value.toLowerCase();
  if (!RegExp(r'[a-záéíóúüñ¿¡]', caseSensitive: false).hasMatch(value)) {
    return false;
  }
  if (value.contains('=')) return false;
  if (RegExp(r'[А-Яа-яЇїІіЄєҐґ]').hasMatch(value)) return false;
  if (RegExp(
    r'\b(the|english|spanish|word|phrase|question|answer|choose|type|write|complete|translate|from|with|for|your|name|book|bus|train|help|home|family|health|we|do|not|have|key|hello|thank|you|understand|repeat|message|first|line|fine|hungry|bottle|female|doctor|stomach|throat|hurts|fever)\b',
  ).hasMatch(lower)) {
    return false;
  }
  if (RegExp(r'[¿¡áéíóúüñ]').hasMatch(lower)) return true;
  final spanishWords = {
    'hola',
    'adiós',
    'adios',
    'hasta',
    'luego',
    'por',
    'favor',
    'gracias',
    'de',
    'nada',
    'me',
    'llamo',
    'soy',
    'eres',
    'es',
    'estoy',
    'estás',
    'estas',
    'está',
    'esta',
    'un',
    'una',
    'el',
    'la',
    'los',
    'las',
    'mi',
    'tu',
    'su',
    'tengo',
    'tienes',
    'tiene',
    'hay',
    'vivo',
    'hablo',
    'hablas',
    'qué',
    'que',
    'cómo',
    'como',
    'dónde',
    'donde',
    'quién',
    'quien',
    'y',
    'no',
    'sí',
    'si',
    'bien',
    'mal',
    'regular',
    'libro',
    'casa',
    'mesa',
    'cocina',
    'baño',
    'bano',
    'salón',
    'salon',
    'dormitorio',
    'madre',
    'padre',
    'hermana',
    'hermano',
    'abuela',
    'amigo',
    'amiga',
    'ayuda',
    'calle',
    'derecha',
    'izquierda',
    'aquí',
    'aqui',
    'allí',
    'alli',
    'bus',
    'tren',
    'metro',
    'taxi',
    'tienda',
    'cuánto',
    'cuanto',
    'quiero',
    'necesito',
    'dolor',
    'cabeza',
    'agua',
    'hospital',
  };
  final tokens = lower
      .replaceAll(RegExp(r'[^a-záéíóúüñ\s]'), ' ')
      .split(RegExp(r'\s+'))
      .where((token) => token.isNotEmpty);
  return tokens.any(spanishWords.contains);
}

bool _shouldInventorySource(PronunciationInventorySource source) {
  if (source.sourceKind == 'vocabulary' && source.role == 'vocabulary') {
    return true;
  }
  return _isLearnerFacingSpanish(source.form);
}

List<Map<String, Object?>> _pronunciationUnits(Map<String, Object?> bundle) {
  return (bundle['units'] as List? ?? const [])
      .whereType<Map>()
      .map((json) => Map<String, Object?>.from(json))
      .toList();
}

Map<String, String> _vocabularyPronunciationUnitRefs(Directory spanishRoot) {
  final refs = <String, String>{};
  for (final file in _jsonFiles(Directory('${spanishRoot.path}/vocabulary'))) {
    for (final item in _jsonArray(file)) {
      if (item is! Map) continue;
      final id = item['id'];
      final unitId =
          item['pronunciationUnitId'] ?? item['pronunciation_unit_id'];
      if (id is String && unitId is String && unitId.trim().isNotEmpty) {
        refs[id] = unitId;
      }
    }
  }
  return refs;
}

String? _russianHint(Map<String, Object?>? unit) {
  if (unit == null) return null;
  final hints = unit['localizedLearnerHints'];
  if (hints is Map && hints['ru'] is String) return hints['ru'] as String;
  return null;
}

List<String> _stringList(Object? value) {
  if (value is List) return value.whereType<String>().toList();
  return const [];
}

Map<String, Object?> _jsonObject(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map) {
    throw FormatException('${file.path} must contain a JSON object');
  }
  return Map<String, Object?>.from(decoded);
}

List<Object?> _jsonArray(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! List) return const [];
  return decoded;
}

Iterable<File> _jsonFiles(Directory directory) sync* {
  if (!directory.existsSync()) return;
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

int _sourceCompare(
  PronunciationInventorySource a,
  PronunciationInventorySource b,
) {
  final lesson = a.lessonId.compareTo(b.lessonId);
  if (lesson != 0) return lesson;
  final kind = a.sourceKind.compareTo(b.sourceKind);
  if (kind != 0) return kind;
  return a.sourceId.compareTo(b.sourceId);
}

String _strongestRole(List<PronunciationInventorySource> group) {
  if (group.any((source) => source.activeRecall)) return 'active_recall';
  final roles = group.map((source) => source.role).toSet().toList()..sort();
  return roles.join('+');
}

bool _requiresStress(String form) {
  return _words(form).any((word) => _vowelGroups(word) >= 2);
}

bool _hasStress(String? value) {
  return value != null && value.contains('\u0301');
}

int _vowelGroups(String word) {
  return RegExp(
    r'[aeiouáéíóúü]+',
    caseSensitive: false,
  ).allMatches(word).length;
}

String _unitCategory(String form) {
  final wordCount = _words(form).length;
  if (wordCount <= 1) return 'word';
  if (wordCount <= 5 && !RegExp(r'[.!?¿¡]').hasMatch(form)) return 'phrase';
  return 'sentence';
}

String _slug(String normalized) {
  final ascii = normalized
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ü', 'u')
      .replaceAll('ñ', 'n');
  final slug = ascii
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
  if (slug.length <= 64) return slug;
  return '${slug.substring(0, 56)}_${normalized.hashCode.abs()}';
}

String _lettersOnly(String form) {
  return form.replaceAll(RegExp(r'[^A-Za-zÁÉÍÓÚÜÑáéíóúüñ\s]'), ' ');
}

List<String> _words(String form) {
  return _lettersOnly(form)
      .split(RegExp(r'\s+'))
      .map((word) => word.trim())
      .where((word) => word.isNotEmpty)
      .toList();
}

bool _hasConsonantalY(String lower) {
  return RegExp(
    r'(^|\s)y[aeiouáéíóú]|[aeiouáéíóú]y[aeiouáéíóú]',
  ).hasMatch(lower);
}

String _ipaWord(String word) {
  final lower = word.toLowerCase();
  final stressedGroup = _stressedVowelGroupIndex(lower);
  var groupIndex = -1;
  final buffer = StringBuffer();
  var i = 0;
  while (i < lower.length) {
    final char = lower[i];
    final next = i + 1 < lower.length ? lower[i + 1] : '';
    final pair = '$char$next';
    if (_isVowel(char)) {
      groupIndex += 1;
      if (_vowelGroups(lower) >= 2 && groupIndex == stressedGroup) {
        buffer.write('ˈ');
      }
      while (i < lower.length && _isVowel(lower[i])) {
        buffer.write(_ipaVowel(lower[i]));
        i += 1;
      }
      continue;
    }
    if (pair == 'ch') {
      buffer.write('tʃ');
      i += 2;
    } else if (pair == 'll') {
      buffer.write('ʝ');
      i += 2;
    } else if (pair == 'rr') {
      buffer.write('r');
      i += 2;
    } else if ((pair == 'qu' || pair == 'gu') &&
        i + 2 < lower.length &&
        RegExp(r'[eiíé]').hasMatch(lower[i + 2])) {
      buffer.write(pair == 'qu' ? 'k' : 'g');
      i += 2;
    } else {
      buffer.write(_ipaConsonant(char, next: next, wordStart: i == 0));
      i += 1;
    }
  }
  return buffer.toString();
}

int _stressedVowelGroupIndex(String word) {
  final groups = RegExp(r'[aeiouáéíóúü]+').allMatches(word).toList();
  for (var i = 0; i < groups.length; i += 1) {
    if (RegExp(r'[áéíóú]').hasMatch(groups[i].group(0)!)) return i;
  }
  if (groups.length <= 1) return 0;
  return RegExp(r'[aeiounsáéíóú]$').hasMatch(word)
      ? groups.length - 2
      : groups.length - 1;
}

bool _isVowel(String char) => 'aeiouáéíóúü'.contains(char);

String _ipaVowel(String char) {
  switch (char) {
    case 'a':
    case 'á':
      return 'a';
    case 'e':
    case 'é':
      return 'e';
    case 'i':
    case 'í':
      return 'i';
    case 'o':
    case 'ó':
      return 'o';
    case 'u':
    case 'ú':
    case 'ü':
      return 'u';
  }
  return char;
}

String _ipaConsonant(
  String char, {
  required String next,
  required bool wordStart,
}) {
  switch (char) {
    case 'h':
      return '';
    case 'ñ':
      return 'ɲ';
    case 'j':
      return 'x';
    case 'y':
      return _isVowel(next) ? 'ʝ' : 'i';
    case 'c':
      return RegExp(r'[eiíé]').hasMatch(next) ? 's' : 'k';
    case 'z':
      return 's';
    case 'g':
      return RegExp(r'[eiíé]').hasMatch(next) ? 'x' : 'g';
    case 'v':
    case 'b':
      return 'b';
    case 'r':
      return wordStart ? 'r' : 'ɾ';
    case 'x':
      return 'ks';
  }
  return char;
}

String _russianHintWord(String word) {
  final lower = word.toLowerCase();
  const manualHints = {'adiós': 'адьо́с', 'gracias': 'гра́сьяс'};
  final manualHint = manualHints[lower];
  if (manualHint != null) return manualHint;
  final stressedGroup = _stressedVowelGroupIndex(lower);
  var groupIndex = -1;
  final buffer = StringBuffer();
  var i = 0;
  while (i < lower.length) {
    final char = lower[i];
    final next = i + 1 < lower.length ? lower[i + 1] : '';
    final pair = '$char$next';
    if (_isVowel(char)) {
      groupIndex += 1;
      final stressed = _vowelGroups(lower) >= 2 && groupIndex == stressedGroup;
      buffer.write(_ruVowel(char, stressed));
      i += 1;
      continue;
    }
    if (pair == 'ch') {
      buffer.write('ч');
      i += 2;
    } else if (pair == 'll') {
      buffer.write(_ruLl(next: i + 2 < lower.length ? lower[i + 2] : ''));
      i += 2;
    } else if (pair == 'rr') {
      buffer.write('рр');
      i += 2;
    } else if ((pair == 'qu' || pair == 'gu') &&
        i + 2 < lower.length &&
        RegExp(r'[eiíé]').hasMatch(lower[i + 2])) {
      buffer.write(pair == 'qu' ? 'к' : 'г');
      i += 2;
    } else {
      buffer.write(_ruConsonant(char, next: next, wordStart: i == 0));
      i += 1;
    }
  }
  return buffer.toString();
}

String _ruVowel(String char, bool stressed) {
  final base = switch (char) {
    'a' || 'á' => 'а',
    'e' || 'é' => 'э',
    'i' || 'í' => 'и',
    'o' || 'ó' => 'о',
    'u' || 'ú' || 'ü' => 'у',
    _ => char,
  };
  return stressed ? '$base\u0301' : base;
}

String _ruLl({required String next}) {
  return switch (next) {
    'a' || 'á' => 'я',
    'e' || 'é' => 'е',
    'i' || 'í' => 'й',
    'o' || 'ó' => 'йо',
    'u' || 'ú' => 'йу',
    _ => 'й',
  };
}

String _ruConsonant(
  String char, {
  required String next,
  required bool wordStart,
}) {
  switch (char) {
    case 'h':
      return '';
    case 'ñ':
      return 'нь';
    case 'j':
      return 'х';
    case 'y':
      return _isVowel(next) ? 'й' : 'й';
    case 'c':
      return RegExp(r'[eiíé]').hasMatch(next) ? 'с' : 'к';
    case 'z':
      return 'с';
    case 'g':
      return RegExp(r'[eiíé]').hasMatch(next) ? 'х' : 'г';
    case 'v':
      return 'в';
    case 'b':
      return 'б';
    case 'r':
      return 'р';
    case 'x':
      return 'кс';
    case 'q':
      return 'к';
    case 'k':
      return 'к';
    case 'd':
      return 'д';
    case 't':
      return 'т';
    case 'p':
      return 'п';
    case 'm':
      return 'м';
    case 'n':
      return 'н';
    case 'f':
      return 'ф';
    case 'l':
      return 'л';
    case 's':
      return 'с';
  }
  return char;
}

bool _needsExplanation(String form) {
  final lower = form.toLowerCase();
  return lower.contains('h') ||
      lower.contains('ll') ||
      _hasConsonantalY(lower) ||
      lower.contains('ñ') ||
      lower.contains('j') ||
      RegExp(r'g[eiíé]').hasMatch(lower) ||
      RegExp(r'[cz]').hasMatch(lower);
}

String _russianExplanation(String form) {
  final rules = <String>[];
  final lower = form.toLowerCase();
  if (lower.contains('h')) {
    rules.add('Буква h в этих испанских формах не произносится.');
  }
  if (lower.contains('ll') || _hasConsonantalY(lower)) {
    rules.add(
      'В норме курса ll и согласная y относятся к общей yeísta-категории /ʝ/; русская подсказка приблизительная.',
    );
  }
  if (lower.contains('ñ')) {
    rules.add('Буква ñ передаёт отдельный испанский звук, близкий к «нь».');
  }
  if (lower.contains('j') || RegExp(r'g[eiíé]').hasMatch(lower)) {
    rules.add(
      'Испанские j, ge и gi здесь читаются как звук /x/, приблизительно русский «х».',
    );
  }
  if (RegExp(r'[cz]').hasMatch(lower)) {
    rules.add(
      'В этом курсе c перед e/i и z читаются как /s/ в общей учебной норме.',
    );
  }
  return rules.join(' ');
}

String _englishExplanation(String form) {
  final rules = <String>[];
  final lower = form.toLowerCase();
  if (lower.contains('h')) rules.add('Spanish h is silent in these forms.');
  if (lower.contains('ll') || _hasConsonantalY(lower)) {
    rules.add(
      'This course uses broad yeismo: ll and consonantal y belong to the /ʝ/ category.',
    );
  }
  if (lower.contains('ñ')) {
    rules.add('Spanish ñ is a separate palatal nasal sound.');
  }
  if (lower.contains('j') || RegExp(r'g[eiíé]').hasMatch(lower)) {
    rules.add('Spanish j, ge and gi are pronounced with /x/ here.');
  }
  if (RegExp(r'[cz]').hasMatch(lower)) {
    rules.add(
      'This course uses /s/ for c before e/i and z in the general learning norm.',
    );
  }
  return rules.join(' ');
}

String _escapeMd(String value) => value.replaceAll('|', '\\|');
