import 'dart:convert';
import 'dart:io';

const _coursePath =
    'assets/languages/spanish/curriculum/spanish_a0_course.json';
const _legacyPath =
    'assets/languages/spanish/localization/support_localizations.json';
const _allowedLocales = {'uk', 'ru'};

void main(List<String> args) {
  final locale = _argValue(args, '--locale');
  final moduleId = _argValue(args, '--module');
  final output = _argValue(args, '--output');
  final force = args.contains('--force');
  if (locale == null || moduleId == null || output == null) {
    stderr.writeln(
      'Usage: dart run tool/create_semantic_localization_scaffold.dart '
      '--locale <uk|ru> --module <moduleId> --output <path> [--force]',
    );
    exitCode = 64;
    return;
  }
  if (!_allowedLocales.contains(locale)) {
    throw StateError('Unsupported scaffold locale: $locale');
  }

  final outputFile = File(output);
  if (outputFile.existsSync() &&
      outputFile.readAsStringSync().trim().isNotEmpty &&
      !force) {
    throw StateError('Refusing to overwrite non-empty scaffold: $output');
  }

  final course = _readJsonObject(_coursePath);
  final legacy = _readJsonObject(_legacyPath);
  final lessonIds = _lessonIdsForModule(course, moduleId);
  final units = _buildUnits(
    locale: locale,
    moduleId: moduleId,
    lessonIds: lessonIds,
    legacy: legacy,
  );

  final bundle = {
    'schemaVersion': 1,
    'targetLanguage': 'es',
    'sourceSupportLocale': 'en',
    'supportLocales': [locale],
    'scaffold': {
      'moduleId': moduleId,
      'lessonIds': lessonIds,
      'status': 'draft',
      'localizedValuesAreIntentionallyEmpty': true,
    },
    'units': units,
  };

  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(bundle)}\n',
  );
  stdout.writeln('semantic scaffold units: ${units.length}');
  stdout.writeln('module: $moduleId');
  stdout.writeln('lesson IDs: ${lessonIds.join(', ')}');
  stdout.writeln('output: $output');
}

List<Map<String, Object?>> _buildUnits({
  required String locale,
  required String moduleId,
  required List<String> lessonIds,
  required Map<String, Object?> legacy,
}) {
  final lessonIdSet = lessonIds.toSet();
  final units = <Map<String, Object?>>[];
  var index = 0;

  for (final rawEntry in (legacy['entries'] as List? ?? const [])) {
    final entry = Map<String, Object?>.from(rawEntry as Map);
    final type = entry['type'] as String? ?? '';
    final id = entry['id'] as String? ?? '';
    if (!_inModuleScope(
      type: type,
      id: id,
      moduleId: moduleId,
      lessonIds: lessonIdSet,
    )) {
      continue;
    }
    final fields = Map<String, Object?>.from(entry['fields'] as Map? ?? {});
    for (final field in fields.entries) {
      final values = Map<String, Object?>.from(field.value as Map? ?? {});
      final source = values['en'];
      if (source is! String || source.trim().isEmpty) {
        continue;
      }
      index += 1;
      units.add({
        'id':
            'semantic.scaffold.$locale.${moduleId.replaceAll('.', '_')}.${index.toString().padLeft(4, '0')}',
        'semanticType': _semanticType(type, field.key),
        'ownership': _ownership(type, field.key),
        'sourceText': source,
        'values': {locale: ''},
        'review': {locale: 'generated'},
        'protectedSpans': _protectedSpans(source),
        'context': {
          'courseId': 'es.a0',
          'moduleId': moduleId,
          if (_lessonIdFor(id, lessonIdSet) != null)
            'lessonId': _lessonIdFor(id, lessonIdSet),
          'contentObjectId': id,
          'fieldPath': field.key,
          'contentKind': type,
          'pedagogicalRole': _pedagogicalRole(type, field.key),
          'targetLanguage': 'es',
          'supportLocale': locale,
          'expectedAnswerContext':
              'draft scaffold; author localized value manually',
        },
        'notes':
            'R2E5R scaffold only. Localized value intentionally empty; do not approve without review.',
      });
    }
  }

  units.sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));
  return units;
}

bool _inModuleScope({
  required String type,
  required String id,
  required String moduleId,
  required Set<String> lessonIds,
}) {
  if (type == 'course' && id == 'es.a0') {
    return true;
  }
  if (type == 'module' && id == moduleId) {
    return true;
  }
  if (lessonIds.contains(id)) {
    return true;
  }
  if (lessonIds.any((lessonId) => id.startsWith('$lessonId.'))) {
    return true;
  }
  final normalizedModule = moduleId.replaceFirst('es.a0.', '');
  return id.contains(normalizedModule);
}

String? _lessonIdFor(String id, Set<String> lessonIds) {
  for (final lessonId in lessonIds) {
    if (id == lessonId || id.startsWith('$lessonId.')) {
      return lessonId;
    }
  }
  return null;
}

String _semanticType(String type, String fieldPath) {
  if (type == 'course' && fieldPath == 'title') {
    return 'courseTitle';
  }
  if (type == 'module' && fieldPath == 'title') {
    return 'moduleTitle';
  }
  if (type == 'lesson' && fieldPath == 'title') {
    return 'lessonTitle';
  }
  if (type == 'lesson' && fieldPath == 'description') {
    return 'lessonDescription';
  }
  if (type == 'lesson_objective') {
    return 'lessonObjective';
  }
  if (fieldPath == 'communicativeOutcome') {
    return 'communicativeOutcome';
  }
  if (type == 'vocabulary' && fieldPath == 'native_translation') {
    return 'vocabularyMeaning';
  }
  if (type == 'vocabulary' && fieldPath == 'notes') {
    return 'vocabularyUsageNote';
  }
  if (type == 'grammar' && fieldPath == 'title') {
    return 'grammarTitle';
  }
  if (type == 'grammar') {
    return 'grammarExplanation';
  }
  if (type == 'dialogue' && fieldPath == 'title') {
    return 'dialogueTitle';
  }
  if (type == 'dialogue') {
    return 'dialogueTranslation';
  }
  if (type == 'reading' && fieldPath == 'title') {
    return 'readingTitle';
  }
  if (type == 'reading') {
    return 'readingTranslation';
  }
  if (type == 'exercise_template' && fieldPath == 'prompt_template') {
    return 'exercisePrompt';
  }
  if (type == 'exercise_template' && fieldPath.contains('answer_options')) {
    return 'answerOptionLabel';
  }
  if (type == 'lesson_section' || type == 'lesson_activity') {
    return 'metadataLabel';
  }
  return 'learnerInstruction';
}

String _ownership(String type, String fieldPath) {
  if (fieldPath.contains('spanish') || fieldPath == 'text') {
    return 'targetLanguageOwned';
  }
  if (fieldPath.contains('answer_options')) {
    return 'mixedStructured';
  }
  return 'supportLanguageOwned';
}

String _pedagogicalRole(String type, String fieldPath) {
  if (type == 'exercise_template') {
    return 'exercise';
  }
  if (type == 'vocabulary') {
    return 'lexical support';
  }
  if (type == 'grammar') {
    return 'grammar support';
  }
  if (type == 'dialogue') {
    return 'dialogue support';
  }
  if (type == 'reading') {
    return 'reading support';
  }
  return fieldPath;
}

List<Map<String, String>> _protectedSpans(String source) {
  final spans = <Map<String, String>>[];
  var index = 0;
  for (final match in RegExp(
    r'\{[^}]+\}|[¿¡]?[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+(?:\s+de\s+[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)?',
  ).allMatches(source)) {
    final text = match.group(0)!;
    if (!_looksSpanishOrPlaceholder(text)) {
      continue;
    }
    index += 1;
    spans.add({
      'id': 'span_$index',
      'type': text.startsWith('{') ? 'placeholder' : 'targetText',
      'text': text,
    });
  }
  return spans;
}

bool _looksSpanishOrPlaceholder(String text) {
  if (text.startsWith('{')) {
    return true;
  }
  return RegExp(r'[¿¡ÁÉÍÓÚÜÑáéíóúüñ]').hasMatch(text) ||
      const {
        'Hola',
        'Adios',
        'Adiós',
        'Gracias',
        'Por favor',
        'Me llamo',
        'Soy',
        'de',
        'll',
        'y',
      }.contains(text);
}

List<String> _lessonIdsForModule(Map<String, Object?> course, String moduleId) {
  for (final rawModule in course['modules'] as List? ?? const []) {
    final module = Map<String, Object?>.from(rawModule as Map);
    if (module['id'] == moduleId) {
      return List.unmodifiable([
        for (final lessonId in module['lessonIds'] as List? ?? const [])
          '$lessonId',
      ]);
    }
  }
  throw StateError('Unknown module ID: $moduleId');
}

Map<String, Object?> _readJsonObject(String path) {
  final raw = jsonDecode(_resolveFile(path).readAsStringSync());
  if (raw is! Map) {
    throw FormatException('Expected JSON object at $path');
  }
  return Map<String, Object?>.from(raw);
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
