import 'dart:convert';
import 'dart:io';

void main() {
  final root = Directory('assets/languages/spanish');
  if (!root.existsSync()) {
    stderr.writeln('Run from app/.');
    exitCode = 1;
    return;
  }

  final vocabularyDir = Directory('${root.path}/vocabulary');
  final pronunciationValues = <String, List<String>>{};
  final targetForms = <String>{};
  var legacyFields = 0;
  var englishOrientedHints = 0;

  for (final file in _jsonFiles(vocabularyDir)) {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is! List) {
      continue;
    }
    for (final item in decoded) {
      if (item is! Map) {
        continue;
      }
      final pronunciation = item['pronunciation'];
      if (pronunciation is! String || pronunciation.isEmpty) {
        continue;
      }
      final id = '${item['id']}';
      legacyFields += 1;
      targetForms.add('${item['spanish']}');
      pronunciationValues.putIfAbsent(pronunciation, () => []).add(id);
      if (_looksEnglishOriented(pronunciation)) {
        englishOrientedHints += 1;
      }
    }
  }

  final duplicatePronunciationStrings = pronunciationValues.values
      .where((ids) => ids.length > 1)
      .length;

  final pronunciationBundle = File(
    '${root.path}/pronunciation/reference_slice.json',
  );
  var pronunciationUnits = 0;
  var readingRules = 0;
  var russianHints = 0;
  var englishHints = 0;
  var ipaValues = 0;

  if (pronunciationBundle.existsSync()) {
    final decoded = jsonDecode(pronunciationBundle.readAsStringSync());
    if (decoded is Map) {
      final rules = decoded['rules'];
      final units = decoded['units'];
      if (rules is List) {
        readingRules = rules.length;
      }
      if (units is List) {
        pronunciationUnits = units.length;
        for (final unit in units.whereType<Map>()) {
          if (unit['ipa'] is String) {
            ipaValues += 1;
          }
          final hints = unit['localizedLearnerHints'];
          if (hints is Map) {
            if (hints['en'] is String) {
              englishHints += 1;
            }
            if (hints['ru'] is String) {
              russianHints += 1;
            }
          }
        }
      }
    }
  }

  stdout.writeln('Pronunciation inventory');
  stdout.writeln('legacyPronunciationFields=$legacyFields');
  stdout.writeln('uniqueTargetForms=${targetForms.length}');
  stdout.writeln(
    'duplicatePronunciationStrings=$duplicatePronunciationStrings',
  );
  stdout.writeln('englishOrientedHints=$englishOrientedHints');
  stdout.writeln('pronunciationUnits=$pronunciationUnits');
  stdout.writeln('readingRules=$readingRules');
  stdout.writeln('unitsWithIpa=$ipaValues');
  stdout.writeln('unitsWithEnglishHints=$englishHints');
  stdout.writeln('unitsWithRussianHints=$russianHints');
  stdout.writeln(
    'unmigratedLegacyEntries=${legacyFields - pronunciationUnits}',
  );
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

bool _looksEnglishOriented(String value) {
  return value.contains(RegExp(r'[A-Z]{2,}')) || value.contains('-');
}
