// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

const _coursePath = 'assets/languages/spanish/curriculum/course.json';
const _bundlePath = 'assets/languages/spanish/localization/support_localizations.json';
const _manifestPath = 'assets/languages/spanish/localization/semantic/manifests/educational_locales.json';
const _classificationPath = 'assets/languages/spanish/localization/ru_identical_classifications.json';

void main() {
  final course = Map<String, Object?>.from(jsonDecode(File(_coursePath).readAsStringSync()) as Map);
  final bundle = Map<String, Object?>.from(jsonDecode(File(_bundlePath).readAsStringSync()) as Map);
  final manifest = Map<String, Object?>.from(jsonDecode(File(_manifestPath).readAsStringSync()) as Map);
  final classifications = Map<String, Object?>.from(jsonDecode(File(_classificationPath).readAsStringSync()) as Map);
  final missing = <String>[];
  final suspicious = <String>[];
  var identical = 0;
  final unexplainedIdentical = <String>[];
  final entries = <String, Map<String, Object?>>{
    for (final raw in (bundle['entries'] as List).whereType<Map>())
      '${raw['type']}|${raw['id']}': Map<String, Object?>.from(raw),
  };
  final lessonIds = (course['lessons'] as List).map((raw) => (raw as Map)['metadata']['id'] as String).toList();
  for (final id in lessonIds) {
    if (!entries.keys.any((key) => key.endsWith('|$id'))) missing.add('lesson $id');
  }
  for (final entry in entries.entries) {
    final fields = Map<String, Object?>.from(entry.value['fields'] as Map);
    for (final field in fields.entries) {
      final values = Map<String, Object?>.from(field.value as Map);
      if ((values['uk'] as String?)?.trim().isEmpty ?? true) missing.add('${entry.key}|${field.key}:uk');
      if ((values['ru'] as String?)?.trim().isEmpty ?? true) missing.add('${entry.key}|${field.key}:ru');
      final uk = values['uk'] as String? ?? '';
      final ru = values['ru'] as String? ?? '';
      if (uk == ru) {
        identical++;
        final identity = '${entry.key}|${field.key}';
        if (!classifications.containsKey(identity)) unexplainedIdentical.add(identity);
      }
      if (RegExp(r'[іїєґІЇЄҐ]').hasMatch(ru)) suspicious.add('${entry.key}|${field.key}:ukrainian-letter');
      for (final fragment in const ['розязык', 'спив', 'коникт', 'короткии', 'Запитай', 'запитай']) {
        if (ru.toLowerCase().contains(fragment.toLowerCase())) suspicious.add('${entry.key}|${field.key}:$fragment');
      }
    }
  }
  final ruReady = (manifest['locales'] as List).cast<Map>().any((locale) => locale['locale'] == 'ru' && locale['releaseEligible'] == true);
  stdout.writeln('Russian localization completeness');
  stdout.writeln('lessons: ${lessonIds.length}');
  stdout.writeln('entries: ${entries.length}');
  stdout.writeln('missing units: ${missing.length}');
  stdout.writeln('RU==UK identical fields: $identical');
  stdout.writeln('unexplained RU==UK fields: ${unexplainedIdentical.length}');
  stdout.writeln('suspicious fields: ${suspicious.length}');
  stdout.writeln('readiness manifest ru releaseEligible: $ruReady');
  for (final issue in suspicious.take(100)) stdout.writeln('suspicious: $issue');
  if (missing.isNotEmpty || !ruReady || suspicious.isNotEmpty || unexplainedIdentical.isNotEmpty) {
    for (final issue in missing.take(100)) stdout.writeln('missing: $issue');
    exitCode = 1;
  }
}
