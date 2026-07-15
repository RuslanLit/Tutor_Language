import 'dart:convert';
import 'dart:io';

const _assetRoot = 'assets/languages/spanish';
const _coursePath = '$_assetRoot/curriculum/spanish_a0_course.json';
const _localizationPath = '$_assetRoot/localization/support_localizations.json';

void main() {
  final root = Directory.current;
  final course = _readObject(root, _coursePath);
  final localization = _readObject(root, _localizationPath);

  final requiredFields = <_SourceField>[];
  _collectCourse(requiredFields, course);
  _collectContent(requiredFields, root);
  final requiredFieldKeys = {
    for (final field in requiredFields) '${field.entryKey}|${field.name}',
  };

  final entriesByKey = <String, Map<String, Object?>>{};
  for (final entry in (localization['entries'] as List)) {
    final map = Map<String, Object?>.from(entry as Map);
    entriesByKey['${map['type']}|${map['id']}'] = map;
  }

  for (final field in requiredFields) {
    final entry = entriesByKey.putIfAbsent(field.entryKey, () {
      return <String, Object?>{
        'type': field.type,
        'id': field.id,
        'fields': <String, Object?>{},
      };
    });
    final fields = Map<String, Object?>.from(entry['fields'] as Map);
    final localeValues = Map<String, Object?>.from(
      (fields[field.name] as Map?) ?? const <String, Object?>{},
    );
    localeValues['en'] = field.sourceText;
    fields[field.name] = localeValues;
    entry['fields'] = fields;
  }

  final sortedEntries =
      entriesByKey.values
          .map((entry) => _pruneEntry(entry, requiredFieldKeys))
          .whereType<Map<String, Object?>>()
          .toList()
        ..sort((a, b) {
          final typeCompare = '${a['type']}'.compareTo('${b['type']}');
          if (typeCompare != 0) {
            return typeCompare;
          }
          return '${a['id']}'.compareTo('${b['id']}');
        });

  localization['entries'] = sortedEntries.map(_sortEntry).toList();
  _writePrettyJson(root, _localizationPath, localization);

  final categories = <String, int>{};
  for (final field in requiredFields) {
    categories[field.category] = (categories[field.category] ?? 0) + 1;
  }

  stdout.writeln('R2E1 English source fields: ${requiredFields.length}');
  for (final entry in categories.entries) {
    stdout.writeln('${entry.key}: ${entry.value}');
  }
}

void _collectCourse(List<_SourceField> fields, Map<String, Object?> course) {
  void add(
    String category,
    String type,
    String id,
    String name,
    Object? value,
  ) {
    if (value is String && value.trim().isNotEmpty) {
      fields.add(_SourceField(category, type, id, name, value));
    }
  }

  add(
    'course metadata',
    'course',
    course['id'] as String,
    'title',
    course['title'],
  );

  for (final module in course['modules'] as List) {
    final map = Map<String, Object?>.from(module as Map);
    add(
      'module metadata',
      'module',
      map['id'] as String,
      'title',
      map['title'],
    );
  }

  for (final lesson in course['lessons'] as List) {
    final map = Map<String, Object?>.from(lesson as Map);
    final metadata = Map<String, Object?>.from(map['metadata'] as Map);
    final lessonId = metadata['id'] as String;
    add('lesson metadata', 'lesson', lessonId, 'title', metadata['title']);
    add(
      'lesson metadata',
      'lesson',
      lessonId,
      'description',
      metadata['description'],
    );
    add(
      'lesson metadata',
      'lesson',
      lessonId,
      'communicativeOutcome',
      map['communicativeOutcome'],
    );

    for (final objective in map['objectives'] as List) {
      final objectiveMap = Map<String, Object?>.from(objective as Map);
      add(
        'lesson objectives',
        'lesson_objective',
        '$lessonId.${objectiveMap['id']}',
        'description',
        objectiveMap['description'],
      );
    }

    for (final section in map['sections'] as List) {
      final sectionMap = Map<String, Object?>.from(section as Map);
      add(
        'lesson sections',
        'lesson_section',
        sectionMap['id'] as String,
        'title',
        sectionMap['title'],
      );
      for (final activity in sectionMap['activities'] as List) {
        final activityMap = Map<String, Object?>.from(activity as Map);
        add(
          'lesson activities',
          'lesson_activity',
          activityMap['id'] as String,
          'title',
          activityMap['title'],
        );
      }
    }

    final summary = Map<String, Object?>.from(map['summary'] as Map);
    add(
      'lesson summaries',
      'lesson_summary',
      summary['id'] as String,
      'reviewPrompt',
      summary['reviewPrompt'],
    );
  }
}

void _collectContent(List<_SourceField> fields, Directory root) {
  final contentDirs = <String, void Function(List<_SourceField>, Object?)>{
    'vocabulary': _collectVocabulary,
    'grammar': _collectGrammar,
    'dialogues': _collectDialogues,
    'readings': _collectReadings,
    'templates': _collectTemplates,
  };

  for (final entry in contentDirs.entries) {
    final dir = Directory('${root.path}/$_assetRoot/${entry.key}');
    final files =
        dir
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.json'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final file in files) {
      entry.value(fields, jsonDecode(file.readAsStringSync()));
    }
  }
}

void _collectVocabulary(List<_SourceField> fields, Object? json) {
  for (final item in json as List) {
    final map = Map<String, Object?>.from(item as Map);
    _add(
      fields,
      'vocabulary',
      'vocabulary',
      map['id'],
      'native_translation',
      map['native_translation'],
    );
    _add(fields, 'vocabulary', 'vocabulary', map['id'], 'notes', map['notes']);
  }
}

void _collectGrammar(List<_SourceField> fields, Object? json) {
  for (final item in json as List) {
    final map = Map<String, Object?>.from(item as Map);
    _add(fields, 'grammar', 'grammar', map['id'], 'title', map['title']);
    _add(
      fields,
      'grammar',
      'grammar',
      map['id'],
      'explanation',
      map['explanation'],
    );
    final examples = (map['examples'] as List?) ?? const [];
    for (var index = 0; index < examples.length; index += 1) {
      _add(
        fields,
        'grammar',
        'grammar',
        map['id'],
        'examples.$index',
        examples[index],
      );
    }
  }
}

void _collectDialogues(List<_SourceField> fields, Object? json) {
  for (final item in json as List) {
    final map = Map<String, Object?>.from(item as Map);
    _add(fields, 'dialogues', 'dialogue', map['id'], 'title', map['title']);
    final lines = (map['lines'] as List?) ?? const [];
    for (var index = 0; index < lines.length; index += 1) {
      final line = Map<String, Object?>.from(lines[index] as Map);
      _add(
        fields,
        'dialogues',
        'dialogue',
        map['id'],
        'lines.$index.native_translation',
        line['native_translation'],
      );
    }
  }
}

void _collectReadings(List<_SourceField> fields, Object? json) {
  for (final item in json as List) {
    final map = Map<String, Object?>.from(item as Map);
    _add(fields, 'readings', 'reading', map['id'], 'title', map['title']);
    _add(
      fields,
      'readings',
      'reading',
      map['id'],
      'native_translation',
      map['native_translation'],
    );
  }
}

void _collectTemplates(List<_SourceField> fields, Object? json) {
  for (final item in json as List) {
    final map = Map<String, Object?>.from(item as Map);
    _add(
      fields,
      'exercise prompts',
      'exercise_template',
      map['id'],
      'prompt_template',
      map['prompt_template'],
    );
    final options = (map['answer_options'] as List?) ?? const [];
    for (final option in options) {
      final optionMap = Map<String, Object?>.from(option as Map);
      final promptTemplate = map['prompt_template'];
      final label = optionMap['label'];
      if (promptTemplate is String &&
          label is String &&
          shouldLocalizeSupportAnswerOption(
            promptTemplate: promptTemplate,
            optionLabel: label,
          )) {
        _add(
          fields,
          'support-language answer options',
          'exercise_template',
          map['id'],
          'answer_options.${optionMap['id']}.label',
          label,
        );
      }
    }
  }
}

bool shouldLocalizeSupportAnswerOption({
  required String promptTemplate,
  required String optionLabel,
}) {
  final label = optionLabel.trim();
  if (label.isEmpty || _looksLikeTargetSpanish(label)) {
    return false;
  }

  final lowerPrompt = promptTemplate.toLowerCase();
  if (lowerPrompt.contains('meaning') ||
      lowerPrompt.contains('translation') ||
      lowerPrompt.contains('what does') ||
      lowerPrompt.contains('which letter') ||
      lowerPrompt.contains('what is') ||
      lowerPrompt.contains('who is') ||
      lowerPrompt.contains('where ') ||
      lowerPrompt.contains('what transport') ||
      lowerPrompt.contains('which answer fits')) {
    return true;
  }

  return _looksLikeSupportEnglish(label);
}

bool _looksLikeTargetSpanish(String value) {
  final lower = value.toLowerCase();
  if (RegExp(r'[¿¡áéíóúñü]').hasMatch(lower)) {
    return true;
  }

  final tokens = RegExp(r"[a-z]+").allMatches(lower).map((match) {
    return match.group(0)!;
  }).toSet();
  const spanishMarkers = {
    'adios',
    'agua',
    'ahora',
    'al',
    'amigo',
    'amiga',
    'anos',
    'autobus',
    'ayuda',
    'bano',
    'bien',
    'buenas',
    'buenos',
    'cafe',
    'casa',
    'cerca',
    'como',
    'de',
    'derecha',
    'donde',
    'el',
    'ella',
    'en',
    'eres',
    'es',
    'espana',
    'espanol',
    'esta',
    'estoy',
    'favor',
    'gira',
    'gracias',
    'hablo',
    'hola',
    'hospital',
    'izquierda',
    'la',
    'llego',
    'llamo',
    'luego',
    'mal',
    'me',
    'medico',
    'mucho',
    'necesito',
    'no',
    'pan',
    'pero',
    'policia',
    'por',
    'que',
    'recto',
    'repite',
    'se',
    'si',
    'sigue',
    'soy',
    'tal',
    'te',
    'tengo',
    'tiene',
    'tienes',
    'toma',
    'un',
    'una',
    'vivo',
    'voy',
  };

  return tokens.any(spanishMarkers.contains);
}

bool _looksLikeSupportEnglish(String value) {
  final lower = value.toLowerCase();
  final tokens = RegExp(r"[a-z]+").allMatches(lower).map((match) {
    return match.group(0)!;
  }).toSet();
  const englishMarkers = {
    'a',
    'about',
    'afternoon',
    'am',
    'and',
    'answer',
    'are',
    'bad',
    'book',
    'bus',
    'do',
    'doctor',
    'does',
    'eight',
    'evening',
    'far',
    'fine',
    'for',
    'four',
    'friend',
    'from',
    'go',
    'good',
    'goodbye',
    'hello',
    'help',
    'how',
    'hungry',
    'i',
    'is',
    'key',
    'language',
    'left',
    'like',
    'little',
    'lives',
    'meaning',
    'morning',
    'mother',
    'my',
    'name',
    'near',
    'not',
    'of',
    'person',
    'please',
    'question',
    'right',
    'sixteen',
    'speak',
    'speaks',
    'straight',
    'student',
    'teacher',
    'thank',
    'thanks',
    'the',
    'to',
    'train',
    'turn',
    'very',
    'welcome',
    'what',
    'where',
    'which',
    'who',
    'you',
    'your',
  };

  return tokens.any(englishMarkers.contains);
}

void _add(
  List<_SourceField> fields,
  String category,
  String type,
  Object? id,
  String name,
  Object? value,
) {
  if (id is String && value is String && value.trim().isNotEmpty) {
    fields.add(_SourceField(category, type, id, name, value));
  }
}

Map<String, Object?> _sortEntry(Map<String, Object?> entry) {
  final fields = Map<String, Object?>.from(entry['fields'] as Map);
  final sortedFields = <String, Object?>{};
  for (final key in fields.keys.toList()..sort()) {
    final values = Map<String, Object?>.from(fields[key] as Map);
    final sortedValues = <String, Object?>{};
    for (final locale in ['en', 'ru', 'uk', 'pl', 'de']) {
      if (values.containsKey(locale)) {
        sortedValues[locale] = values[locale];
      }
    }
    sortedFields[key] = sortedValues;
  }
  return {'type': entry['type'], 'id': entry['id'], 'fields': sortedFields};
}

Map<String, Object?>? _pruneEntry(
  Map<String, Object?> entry,
  Set<String> requiredFieldKeys,
) {
  final type = entry['type'];
  final id = entry['id'];
  final fields = Map<String, Object?>.from(entry['fields'] as Map);
  final prunedFields = <String, Object?>{};
  for (final field in fields.entries) {
    if (requiredFieldKeys.contains('$type|$id|${field.key}')) {
      prunedFields[field.key] = field.value;
    }
  }
  if (prunedFields.isEmpty) {
    return null;
  }
  return {'type': type, 'id': id, 'fields': prunedFields};
}

Map<String, Object?> _readObject(Directory root, String path) {
  return Map<String, Object?>.from(
    jsonDecode(File('${root.path}/$path').readAsStringSync()) as Map,
  );
}

void _writePrettyJson(Directory root, String path, Map<String, Object?> value) {
  const encoder = JsonEncoder.withIndent('  ');
  File('${root.path}/$path').writeAsStringSync('${encoder.convert(value)}\n');
}

class _SourceField {
  const _SourceField(
    this.category,
    this.type,
    this.id,
    this.name,
    this.sourceText,
  );

  final String category;
  final String type;
  final String id;
  final String name;
  final String sourceText;

  String get entryKey => '$type|$id';
}
