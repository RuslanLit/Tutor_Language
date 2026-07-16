import 'dart:convert';
import 'dart:io';

import 'spanish_a0_pronunciation_inventory_support.dart';

void main() {
  final appDirectory = Directory.current;
  final spanishRoot = Directory(
    '${appDirectory.path}/assets/languages/spanish',
  );
  if (!spanishRoot.existsSync()) {
    stderr.writeln('Run from app/.');
    exitCode = 1;
    return;
  }

  final sourcesByForm = collectSpanishA0PronunciationSources(
    appDirectory: appDirectory,
  );
  final bundleFile = File(
    '${spanishRoot.path}/pronunciation/reference_slice.json',
  );
  final bundle = loadSpanishA0PronunciationBundle(appDirectory: appDirectory);
  final units = (bundle['units'] as List? ?? const [])
      .whereType<Map>()
      .map((json) => Map<String, Object?>.from(json))
      .toList();
  final localizations = (bundle['localizations'] as List? ?? const [])
      .whereType<Map>()
      .map((json) => Map<String, Object?>.from(json))
      .toList();
  final generatedUnitIds = {
    for (final unit in units)
      if ((unit['metadata'] as Map?)?['inventoryGenerated'] == 'true')
        unit['id'] as String,
  };
  units.removeWhere((unit) => generatedUnitIds.contains(unit['id']));
  localizations.removeWhere(
    (localization) => generatedUnitIds.contains(localization['id']),
  );
  final unitsByNormalizedForm = <String, Map<String, Object?>>{};
  for (final unit in units) {
    final target = unit['targetOrthography'];
    if (target is String) {
      unitsByNormalizedForm[normalizeSpanishForm(target)] = unit;
    }
  }
  final localizationsById = {
    for (final localization in localizations)
      if (localization['id'] is String)
        localization['id'] as String: localization,
  };
  final unitIds = {
    for (final unit in units)
      if (unit['id'] is String) unit['id'] as String,
  };

  var createdUnits = 0;
  var completedUnits = 0;
  var createdLocalizations = 0;
  for (final entry in sourcesByForm.entries) {
    final sources = entry.value
      ..sort((a, b) => a.sourceId.compareTo(b.sourceId));
    if (sources.isEmpty) continue;
    final form = sources.first.form.trim();
    final existing = unitsByNormalizedForm[entry.key];
    if (existing == null) {
      final unit = buildPronunciationUnitForForm(form: form, sources: sources);
      unit['id'] = _uniqueUnitId(unit['id'] as String, unitIds, entry.key);
      unitIds.add(unit['id'] as String);
      units.add(unit);
      unitsByNormalizedForm[entry.key] = unit;
      final localization = buildPronunciationLocalizationForUnit(unit);
      localizations.add(localization);
      localizationsById[unit['id'] as String] = localization;
      createdUnits += 1;
      createdLocalizations += 1;
      continue;
    }

    var changed = false;
    existing['schemaVersion'] ??= 1;
    existing['targetLanguage'] ??= 'es';
    existing['pronunciationVariety'] ??= 'es-general';
    final existingMetadata = Map<String, Object?>.from(
      existing['metadata'] as Map? ?? const {},
    );
    final generated = existingMetadata['inventoryGenerated'] == 'true';
    if (generated || existing['ipa'] == null) {
      existing['ipa'] = spanishBroadIpa(form);
      changed = true;
    }
    if ((existing['readingRuleIds'] as List? ?? const []).isEmpty) {
      existing['readingRuleIds'] = readingRulesForSpanishForm(form);
      changed = true;
    }
    final hints = Map<String, Object?>.from(
      existing['localizedLearnerHints'] as Map? ?? const {},
    );
    if (generated || ((hints['ru'] as String?)?.trim().isEmpty ?? true)) {
      hints['ru'] = russianLearnerHint(form);
      existing['localizedLearnerHints'] = hints;
      changed = true;
    }
    final related = {
      ...((existing['relatedContentIds'] as List? ?? const [])
          .whereType<String>()),
      for (final source in sources) source.sourceId,
    }.toList()..sort();
    if (jsonEncode(existing['relatedContentIds']) != jsonEncode(related)) {
      existing['relatedContentIds'] = related;
      changed = true;
    }
    final relatedVocabulary = sources
        .where(
          (source) =>
              source.role == 'vocabulary' &&
              source.sourceId.startsWith('vocab.') &&
              normalizeSpanishForm(source.form) == entry.key,
        )
        .map((source) => source.sourceId)
        .toSet()
        .toList();
    relatedVocabulary.sort();
    if (relatedVocabulary.isNotEmpty &&
        jsonEncode(existing['relatedVocabularyIds']) !=
            jsonEncode(relatedVocabulary)) {
      existing['relatedVocabularyIds'] = relatedVocabulary;
      changed = true;
    } else if (relatedVocabulary.isEmpty &&
        existing.containsKey('relatedVocabularyIds')) {
      existing.remove('relatedVocabularyIds');
      changed = true;
    }
    final metadata = existingMetadata;
    if (metadata['releaseReference'] != 'true') {
      metadata['releaseReference'] = 'true';
      existing['metadata'] = metadata;
      changed = true;
    }
    if (changed) completedUnits += 1;

    final id = existing['id'] as String;
    final localization = localizationsById[id];
    if (localization == null) {
      localizations.add(buildPronunciationLocalizationForUnit(existing));
      localizationsById[id] = localizations.last;
      createdLocalizations += 1;
    } else {
      final unitHints = Map<String, Object?>.from(
        existing['localizedLearnerHints'] as Map? ?? const {},
      );
      final unitRussianHint = unitHints['ru'];
      if (unitRussianHint is String && unitRussianHint.trim().isNotEmpty) {
        final learnerHints = Map<String, Object?>.from(
          localization['learnerHints'] as Map? ?? const {},
        );
        if (learnerHints['ru'] != unitRussianHint) {
          learnerHints['ru'] = unitRussianHint;
          localization['learnerHints'] = learnerHints;
        }
      }
    }
  }

  units.sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));
  localizations.sort(
    (a, b) => (a['id'] as String).compareTo(b['id'] as String),
  );
  bundle['units'] = units;
  bundle['localizations'] = localizations;
  bundleFile.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(bundle)}\n',
  );

  final unitByVocabularyId = <String, String>{};
  for (final unit in units) {
    final unitId = unit['id'];
    if (unitId is! String) continue;
    for (final vocabId in (unit['relatedVocabularyIds'] as List? ?? const [])) {
      if (vocabId is String) unitByVocabularyId[vocabId] = unitId;
    }
  }
  var vocabularyRefsUpdated = 0;
  for (final file in _jsonFiles(Directory('${spanishRoot.path}/vocabulary'))) {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! List) continue;
    var changed = false;
    for (final item in decoded.whereType<Map>()) {
      final id = item['id'];
      if (id is! String) continue;
      final unitId = unitByVocabularyId[id];
      if (unitId == null) continue;
      if (item['pronunciationUnitId'] != unitId) {
        item['pronunciationUnitId'] = unitId;
        changed = true;
        vocabularyRefsUpdated += 1;
      }
    }
    if (changed) {
      file.writeAsStringSync(
        '${const JsonEncoder.withIndent('  ').convert(decoded)}\n',
      );
    }
  }

  stdout.writeln('Spanish A0 pronunciation migration');
  stdout.writeln('createdUnits=$createdUnits');
  stdout.writeln('completedUnits=$completedUnits');
  stdout.writeln('createdLocalizations=$createdLocalizations');
  stdout.writeln('vocabularyRefsUpdated=$vocabularyRefsUpdated');
}

String _uniqueUnitId(String preferred, Set<String> existingIds, String key) {
  if (!existingIds.contains(preferred)) {
    return preferred;
  }
  final suffix = key.hashCode.abs().toString();
  final replacement = preferred.replaceFirst(RegExp(r'\.v1$'), '_$suffix.v1');
  var candidate = replacement;
  var index = 2;
  while (existingIds.contains(candidate)) {
    candidate = replacement.replaceFirst(RegExp(r'\.v1$'), '_$index.v1');
    index += 1;
  }
  return candidate;
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
