import 'dart:convert';
import 'dart:io';

const _bundlePath = 'assets/languages/spanish/localization/support_localizations.json';
const _outputPath = 'assets/languages/spanish/localization/ru_identical_classifications.json';

void main() {
  final bundle = Map<String, Object?>.from(jsonDecode(File(_bundlePath).readAsStringSync()) as Map);
  final classifications = <String, Object?>{};
  for (final raw in (bundle['entries'] as List)) {
    final entry = Map<String, Object?>.from(raw as Map);
    final fields = Map<String, Object?>.from(entry['fields'] as Map);
    for (final field in fields.entries) {
      final values = Map<String, Object?>.from(field.value as Map);
      if (values['uk'] != values['ru']) continue;
      final key = '${entry['type']}|${entry['id']}|${field.key}';
      final value = values['ru'] as String;
      final targetOwned = field.key.startsWith('examples.') ||
          RegExp(r'[¿¡áéíóúñü]').hasMatch(value) ||
          value.contains('Hola') || value.contains('Me llamo') ||
          value.contains('Vivo') || value.contains('Hablo') ||
          value.contains('Soy ') || value.contains('Ella') || value.contains('Él');
      classifications[key] = {
        'classification': targetOwned ? 'target-language-owned' : 'same-spelling',
        'value': value,
      };
    }
  }
  File(_outputPath).writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(classifications)}\n');
  stdout.writeln('Classified ${classifications.length} identical RU/UK fields.');
}
