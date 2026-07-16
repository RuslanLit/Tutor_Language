import 'dart:convert';
import 'dart:io';

const _localizationPath =
    'assets/languages/spanish/localization/support_localizations.json';
const _pronunciationPath =
    'assets/languages/spanish/pronunciation/reference_slice.json';

void main() {
  final issues = <_Issue>[];
  final localization = _readJson(_localizationPath);
  final pronunciation = _readJson(_pronunciationPath);

  _auditEducationalLocalization(localization, issues);
  _auditPronunciation(pronunciation, issues);

  final blockerIssues = issues.where((issue) => issue.isBlocker).toList();
  final byCode = <String, int>{};
  final byModule = <String, int>{};
  for (final issue in blockerIssues) {
    byCode.update(issue.code, (count) => count + 1, ifAbsent: () => 1);
    byModule.update(issue.module, (count) => count + 1, ifAbsent: () => 1);
  }

  stdout.writeln('Ukrainian localization audit');
  stdout.writeln('blockers: ${blockerIssues.length}');
  stdout.writeln('by code:');
  for (final entry
      in byCode.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    stdout.writeln('  ${entry.key}: ${entry.value}');
  }
  stdout.writeln('by module:');
  for (final entry
      in byModule.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    stdout.writeln('  ${entry.key}: ${entry.value}');
  }
  if (blockerIssues.isNotEmpty) {
    stdout.writeln('first blockers:');
    for (final issue in blockerIssues.take(1000)) {
      stdout.writeln(issue.format());
    }
    exitCode = 1;
  }
}

Map<String, Object?> _readJson(String path) {
  return Map<String, Object?>.from(
    jsonDecode(File(path).readAsStringSync()) as Map,
  );
}

void _auditEducationalLocalization(
  Map<String, Object?> localization,
  List<_Issue> issues,
) {
  final entries = (localization['entries'] as List).whereType<Map>();
  for (final rawEntry in entries) {
    final entry = Map<String, Object?>.from(rawEntry);
    final type = entry['type'] as String? ?? '';
    final id = entry['id'] as String? ?? '';
    final fields = Map<String, Object?>.from(entry['fields'] as Map);
    for (final field in fields.entries) {
      final values = Map<String, Object?>.from(field.value as Map);
      final ukrainian = values['uk'];
      final english = values['en'];
      final russian = values['ru'];
      if (ukrainian is! String || ukrainian.trim().isEmpty) {
        issues.add(
          _Issue(
            code: 'uk.missing',
            type: type,
            id: id,
            field: field.key,
            value: '',
          ),
        );
        continue;
      }
      if (type == 'grammar' && field.key.startsWith('examples.')) {
        continue;
      }
      _auditUkrainianText(
        issues,
        type: type,
        id: id,
        field: field.key,
        value: ukrainian,
        english: english is String ? english : null,
        russian: russian is String ? russian : null,
      );
    }
  }
}

void _auditPronunciation(Map<String, Object?> bundle, List<_Issue> issues) {
  for (final rawUnit in (bundle['units'] as List).whereType<Map>()) {
    final unit = Map<String, Object?>.from(rawUnit);
    final id = unit['id'] as String? ?? '';
    final hints = Map<String, Object?>.from(
      unit['localizedLearnerHints'] as Map? ?? const {},
    );
    final ukHint = hints['uk'];
    if (ukHint is! String || ukHint.trim().isEmpty) {
      issues.add(
        _Issue(
          code: 'pronunciation.ukHintMissing',
          type: 'pronunciation_unit',
          id: id,
          field: 'localizedLearnerHints.uk',
          value: '',
        ),
      );
    } else {
      _auditUkrainianText(
        issues,
        type: 'pronunciation_unit',
        id: id,
        field: 'localizedLearnerHints.uk',
        value: ukHint,
      );
      if (_looksMultisyllabicHint(ukHint) && !_hasStressMark(ukHint)) {
        issues.add(
          _Issue(
            code: 'pronunciation.ukStressMissing',
            type: 'pronunciation_unit',
            id: id,
            field: 'localizedLearnerHints.uk',
            value: ukHint,
          ),
        );
      }
    }
    final explanations = Map<String, Object?>.from(
      unit['explanations'] as Map? ?? const {},
    );
    final ukExplanation = explanations['uk'];
    if (ukExplanation is String && ukExplanation.trim().isNotEmpty) {
      _auditUkrainianText(
        issues,
        type: 'pronunciation_unit',
        id: id,
        field: 'explanations.uk',
        value: ukExplanation,
      );
    }
  }

  for (final rawLocalization
      in (bundle['localizations'] as List).whereType<Map>()) {
    final localization = Map<String, Object?>.from(rawLocalization);
    final id = localization['id'] as String? ?? '';
    for (final mapName in [
      'learnerHints',
      'explanations',
      'titles',
      'shortExplanations',
      'detailedExplanations',
      'articulationHints',
      'commonMistakes',
      'contrastNotes',
    ]) {
      final values = Map<String, Object?>.from(
        localization[mapName] as Map? ?? const {},
      );
      final uk = values['uk'];
      if (uk is String && uk.trim().isNotEmpty) {
        _auditUkrainianText(
          issues,
          type: 'pronunciation_localization',
          id: id,
          field: '$mapName.uk',
          value: uk,
        );
      }
    }
    final presentations = Map<String, Object?>.from(
      localization['graphemePresentations'] as Map? ?? const {},
    );
    final ukPresentation = presentations['uk'];
    if (ukPresentation is Map) {
      for (final entry in Map<String, Object?>.from(ukPresentation).entries) {
        final value = entry.value;
        if (value is String) {
          _auditUkrainianText(
            issues,
            type: 'pronunciation_grapheme',
            id: id,
            field: '${entry.key}.uk',
            value: value,
          );
        } else if (value is List) {
          for (var index = 0; index < value.length; index += 1) {
            final item = value[index];
            if (item is String) {
              _auditUkrainianText(
                issues,
                type: 'pronunciation_grapheme',
                id: id,
                field: '${entry.key}.$index.uk',
                value: item,
              );
            }
          }
        }
      }
    }
  }
}

void _auditUkrainianText(
  List<_Issue> issues, {
  required String type,
  required String id,
  required String field,
  required String value,
  String? english,
  String? russian,
}) {
  if (english != null &&
      _normalizeForComparison(value) == _normalizeForComparison(english) &&
      !_isAllowedInvariant(value)) {
    issues.add(
      _Issue(
        code: 'uk.sourceIdentical',
        type: type,
        id: id,
        field: field,
        value: value,
      ),
    );
  }
  if (russian != null &&
      _normalizeForComparison(value) == _normalizeForComparison(russian) &&
      !_isAllowedInvariant(value)) {
    issues.add(
      _Issue(
        code: 'uk.russianIdentical',
        type: type,
        id: id,
        field: field,
        value: value,
      ),
    );
  }
  if (RegExp(r'[ыэёъЫЭЁЪ]').hasMatch(value)) {
    issues.add(
      _Issue(
        code: 'uk.russianCharacter',
        type: type,
        id: id,
        field: field,
        value: value,
      ),
    );
  }
  final russianWords = _forbiddenRussianWords
      .where((word) => _containsCyrillicWord(value, word))
      .toList();
  if (russianWords.isNotEmpty) {
    issues.add(
      _Issue(
        code: 'uk.russianWord',
        type: type,
        id: id,
        field: field,
        value: '${russianWords.join(', ')} | $value',
      ),
    );
  }
  final englishWords = _latinWords(
    value,
  ).where((word) => _forbiddenEnglishWords.contains(word)).toList();
  if (englishWords.isNotEmpty) {
    issues.add(
      _Issue(
        code: 'uk.englishWord',
        type: type,
        id: id,
        field: field,
        value: '${englishWords.join(', ')} | $value',
      ),
    );
  }
}

bool _containsCyrillicWord(String value, String word) {
  return RegExp(
    '(^|[^А-Яа-яІіЇїЄєҐґ])${RegExp.escape(word)}'
    r'([^А-Яа-яІіЇїЄєҐґ]|$)',
    caseSensitive: false,
  ).hasMatch(value);
}

Iterable<String> _latinWords(String value) {
  return RegExp(r"[A-Za-z][A-Za-z'’.-]*[A-Za-z]")
      .allMatches(value)
      .map((match) => match.group(0)!.toLowerCase().replaceAll('’', "'"))
      .where((word) {
        if (word.length < 3) return false;
        if (_allowedLatinWords.contains(word)) return false;
        if (_spanishWords.contains(word)) return false;
        return true;
      });
}

String _normalizeForComparison(String value) {
  return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
}

bool _isAllowedInvariant(String value) {
  final normalized = _normalizeForComparison(value);
  if (_spanishWords.contains(normalized)) return true;
  if (_allowedUkrainianRussianHomographs.contains(normalized)) return true;
  if (_allowedTargetLanguageTitles.contains(normalized)) return true;
  if (RegExp(r'^[¿¡]?[a-záéíóúüñ]+[.!?]?$').hasMatch(normalized)) {
    return true;
  }
  return false;
}

bool _looksMultisyllabicHint(String value) {
  final vowelMatches = RegExp(
    r'[аеєиіїоуюяАЕЄИІЇОУЮЯ]',
  ).allMatches(value).length;
  return vowelMatches >= 2;
}

bool _hasStressMark(String value) {
  return value.contains('\u0301') ||
      RegExp(r'[а́е́є́и́і́ї́о́у́ю́я́]').hasMatch(value);
}

const _allowedLatinWords = {
  'a0',
  'ipa',
  'id',
  'ui',
  'cefr',
  'yeista',
  'yeísta',
};

const _spanishWords = {
  'adios',
  'adiós',
  'agua',
  'ana',
  'aqui',
  'aquí',
  'autobus',
  'autobús',
  'bien',
  'buenas',
  'buenos',
  'carlos',
  'como',
  'cómo',
  'cuanto',
  'cuánto',
  'de',
  'donde',
  'dónde',
  'el',
  'en',
  'eres',
  'es',
  'españa',
  'esta',
  'está',
  'estoy',
  'gracias',
  'hablo',
  'hambre',
  'hasta',
  'hola',
  'hotel',
  'jose',
  'josé',
  'la',
  'lima',
  'llamo',
  'luego',
  'madrid',
  'marta',
  'me',
  'metro',
  'mexico',
  'méxico',
  'mi',
  'mucho',
  'nada',
  'necesito',
  'no',
  'peru',
  'perú',
  'por',
  'que',
  'qué',
  'quiero',
  'repita',
  'sí',
  'si',
  'soy',
  'tengo',
  'tienes',
  'tu',
  'tú',
  'ucrania',
  'un',
  'una',
  'voy',
  'yo',
};

const _allowedUkrainianRussianHomographs = {
  'а ключ?',
  'а твоя мама?',
  'аптека поруч.',
  'аргентина',
  'автобус',
  'аптека',
  'барселона',
  'брат',
  'велосипед',
  'богота',
  'голова',
  'голод',
  'друг карлоса',
  'друг',
  'два',
  'вода',
  'далеко',
  'квартира',
  'ключ',
  'ключ там.',
  'кухня',
  'лексика',
  'мадрид',
  'машина',
  'метро',
  'мексика',
  'нормально.',
  'прямо',
  'подруга',
  'практика',
  'перу',
  'сестра',
  'спальня',
  'сумка',
  'супермаркет',
  'транспорт',
  'туалет',
  'учень / студент',
  'я говорю',
  'я хочу',
  'я не знаю',
  'я ана',
};

const _allowedTargetLanguageTitles = {
  'el, la, un, una',
  'qu, gue, gui',
  'se llama',
  'tener: tengo, tienes, tiene',
  '¿cómo es?',
  '¿dónde está...?',
};

const _forbiddenEnglishWords = {
  'advice',
  'after',
  'answer',
  'before',
  'beginners',
  'body',
  'call',
  'choose',
  'classroom',
  'command',
  'correct',
  'course',
  'during',
  'earlier',
  'english',
  'exercise',
  'family',
  'feminine',
  'first',
  'fragment',
  'general',
  'identify',
  'incorrect',
  'instruction',
  'introduction',
  'is',
  'lesson',
  'material',
  'meaning',
  'method',
  'module',
  'next',
  'pattern',
  'practical',
  'plural',
  'possessive',
  'practice',
  'production',
  'pronouns',
  'question',
  'recombine',
  'request',
  'requesting',
  'review',
  'role-play',
  'show',
  'source',
  'speaker',
  'speaking',
  'somewhere',
  'stress',
  'subway',
  'support',
  'sustain',
  'tags',
  'transport',
  'translation',
  'type',
  'use',
  'usage',
  'word',
  'write',
  'where',
  'unknown',
  'places',
  'combinations',
};

const _forbiddenRussianWords = {
  'безопасная',
  'болит',
  'больна',
  'болен',
  'возьмите',
  'выберите',
  'введите',
  'глагол',
  'говорящий',
  'гостиная',
  'двадцать',
  'езжайте',
  'данный',
  'другой',
  'дружелюбный',
  'дружелюбний',
  'живйошь',
  'единственное',
  'или',
  'использует',
  'используйте',
  'используется',
  'изучите',
  'когда',
  'конструкция',
  'личная',
  'личний',
  'личный',
  'материал',
  'медицинское',
  'место',
  'местоположение',
  'наличие',
  'находится',
  'нехорошо',
  'нужен',
  'нужно',
  'него',
  'множественное',
  'может',
  'навыки',
  'начальный',
  'начальние',
  'некоторие',
  'нужний',
  'ограниченная',
  'ограниченний',
  'определите',
  'опускает',
  'остановка',
  'ответьте',
  'пешком',
  'первий',
  'полиция',
  'порядке',
  'станция',
  'станции',
  'экстренная',
  'повседневний',
  'повседневние',
  'покупатель',
  'показивает',
  'помогая',
  'помочь',
  'понимаете',
  'представление',
  'приложение',
  'простой',
  'простие',
  'просьби',
  'роли',
  'спросить',
  'спрашивает',
  'сйостри',
  'сколько',
  'скажите',
  'случилось',
  'сохраняйте',
  'спросите',
  'срочний',
  'тебя',
  'считается',
  'текущее',
  'учит',
  'уровне',
  'человек',
  'человеке',
  'которих',
  'людинае',
  'розмоваа',
  'язики',
  'что',
  'являются',
  'это',
  'восемнадцать',
  'одиннадцать',
  'двенадцать',
  'четырнадцать',
  'пятнадцать',
  'шестнадцать',
  'семнадцать',
  'девятнадцать',
  'софия',
  'софии',
  'диего',
  'луис',
  'луису',
  'лусия',
  'київа',
  'боготе',
  'разговор',
  'еда',
  'стоит',
};

class _Issue {
  const _Issue({
    required this.code,
    required this.type,
    required this.id,
    required this.field,
    required this.value,
  });

  final String code;
  final String type;
  final String id;
  final String field;
  final String value;

  bool get isBlocker => true;

  String get module {
    final match = RegExp(r'\.m(\d{2})\.').firstMatch(id);
    if (match != null) return 'm${match.group(1)}';
    return 'shared';
  }

  String format() => '$code|$type|$id|$field|$value';
}
