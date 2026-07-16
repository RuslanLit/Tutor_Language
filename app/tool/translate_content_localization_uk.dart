// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';

const _localizationPath =
    'assets/languages/spanish/localization/support_localizations.json';
const _pronunciationPath =
    'assets/languages/spanish/pronunciation/reference_slice.json';

Never main() {
  throw UnsupportedError(
    'This tool is archived by R2E5R and must not generate production '
    'Ukrainian educational localization. Use '
    'create_semantic_localization_scaffold.dart and authored '
    'SemanticLocalizationUnit data instead.',
  );
}

_LocalizationStats _localizeEducationalContent(
  Map<String, Object?> localization,
) {
  var written = 0;
  var invariant = 0;
  final entries = localization['entries'] as List;
  for (var entryIndex = 0; entryIndex < entries.length; entryIndex += 1) {
    final entry = Map<String, Object?>.from(entries[entryIndex] as Map);
    final type = entry['type'] as String;
    final id = entry['id'] as String;
    final fields = Map<String, Object?>.from(entry['fields'] as Map);
    for (final field in fields.entries) {
      final values = Map<String, Object?>.from(field.value as Map);
      final english = values['en'];
      if (english is! String || english.trim().isEmpty) {
        continue;
      }
      final russian = values['ru'];
      final ukrainian = translateUkrainian(
        english,
        russian: russian is String ? russian : null,
        type: type,
        id: id,
        fieldName: field.key,
      );
      values['uk'] = ukrainian;
      if (_normalizeComparable(ukrainian) == _normalizeComparable(english)) {
        invariant += 1;
      }
      fields[field.key] = values;
      written += 1;
    }
    entry['fields'] = fields;
    entries[entryIndex] = entry;
  }
  return _LocalizationStats(written: written, invariant: invariant);
}

_PronunciationStats _localizePronunciation(Map<String, Object?> bundle) {
  var hints = 0;
  var explanations = 0;
  var readingRuleFields = 0;

  for (final unit in (bundle['units'] as List).whereType<Map>()) {
    final hintsMap = Map<String, Object?>.from(
      unit['localizedLearnerHints'] as Map? ?? const {},
    );
    final unitId = unit['id'] as String? ?? '';
    final ru = hintsMap['ru'];
    final hintOverride = _pronunciationHintUkById[unitId];
    if (hintOverride != null) {
      hintsMap['uk'] = hintOverride;
      unit['localizedLearnerHints'] = hintsMap;
      hints += 1;
    } else if (ru is String && ru.trim().isNotEmpty) {
      hintsMap['uk'] = _ukrainianPronunciationHint(ru);
      unit['localizedLearnerHints'] = hintsMap;
      hints += 1;
    }
  }

  for (final localization
      in (bundle['localizations'] as List).whereType<Map>()) {
    final id = localization['id'] as String? ?? '';
    final isReadingRule = id.startsWith('pronunciation.es.rule.');
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
      final ru = values['ru'];
      final en = values['en'];
      final pronunciationOverride = _pronunciationUk['$id|$mapName'];
      if (pronunciationOverride != null) {
        values['uk'] = pronunciationOverride;
        localization[mapName] = values;
        if (mapName == 'explanations') {
          explanations += 1;
        }
        if (isReadingRule) {
          readingRuleFields += 1;
        }
        continue;
      }
      if (mapName == 'learnerHints') {
        if (ru is String && ru.trim().isNotEmpty) {
          values['uk'] = _ukrainianPronunciationHint(ru);
          localization[mapName] = values;
          hints += 1;
        }
        continue;
      }
      if (ru is String && ru.trim().isNotEmpty) {
        values['uk'] = _ukrainianFromRussian(ru);
      } else if (en is String && en.trim().isNotEmpty) {
        values['uk'] = translateUkrainian(en, type: 'pronunciation', id: id);
      } else {
        continue;
      }
      localization[mapName] = values;
      if (mapName == 'explanations') {
        explanations += 1;
      }
      if (isReadingRule) {
        readingRuleFields += 1;
      }
    }

    final graphemePresentations = Map<String, Object?>.from(
      localization['graphemePresentations'] as Map? ?? const {},
    );
    final ruPresentation = graphemePresentations['ru'];
    final presentationOverride = _graphemePresentationUk[id];
    if (presentationOverride != null) {
      graphemePresentations['uk'] = presentationOverride;
      localization['graphemePresentations'] = graphemePresentations;
      if (isReadingRule) {
        readingRuleFields += 1;
      }
    } else if (ruPresentation is Map) {
      graphemePresentations['uk'] = _translateGraphemePresentation(
        Map<String, Object?>.from(ruPresentation),
      );
      localization['graphemePresentations'] = graphemePresentations;
      if (isReadingRule) {
        readingRuleFields += 1;
      }
    }
  }

  return _PronunciationStats(
    hints: hints,
    explanations: explanations,
    readingRuleFields: readingRuleFields,
  );
}

String translateUkrainian(
  String source, {
  String? russian,
  String type = '',
  String id = '',
  String fieldName = '',
}) {
  final text = source.trim();
  final fieldOverride = _fieldUk['$id|$fieldName'];
  if (fieldOverride != null) return fieldOverride;
  final exact = _exactUk[text];
  if (exact != null) return exact;

  if (type == 'vocabulary' && fieldName == 'native_translation') {
    return _translateVocabularyMeaning(text);
  }

  if (type == 'exercise_template' && fieldName == 'prompt_template') {
    return _translatePrompt(text, russian: russian);
  }

  if (type == 'exercise_template' && fieldName.startsWith('answer_options.')) {
    return _translateSupportOption(text, russian: russian);
  }

  if (type == 'grammar' && fieldName.startsWith('examples.')) {
    return _translateMixedEducationalText(text, russian: russian);
  }

  if (type == 'dialogue' && fieldName.startsWith('lines.')) {
    return _translateSentences(text, russian: russian);
  }

  if (type == 'reading' && fieldName == 'native_translation') {
    return _translateSentences(text, russian: russian);
  }

  if (fieldName == 'title' || type == 'module' || type == 'lesson_section') {
    return _titleCase(_translateTitle(text, russian: russian));
  }

  if (_looksLikeTargetOrName(text)) {
    return text;
  }

  return _translateMixedEducationalText(text, russian: russian);
}

String _translatePrompt(String source, {String? russian}) {
  final exact = _exactUk[source];
  if (exact != null) return exact;

  var output = source;
  output = output.replaceAllMapped(
    RegExp(r'^Type the Spanish word for "([^"]+)"(.*)\.?$'),
    (match) =>
        'Введіть іспанське слово зі значенням «${_translateEmbedded(match.group(1)!)}»${_promptTail(match.group(2)!.trim())}.',
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(
      r'^Type the Spanish word/name that begins with ([^:]+): "([^"]+)"\.?$',
    ),
    (match) =>
        'Введіть іспанське слово або імʼя, що починається з ${match.group(1)}: «${match.group(2)}».',
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(r'^Choose the word that contains ([^\.]+)\.?$'),
    (match) => 'Виберіть слово, яке містить ${match.group(1)}.',
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(r'^Choose the word that begins with ([^\.]+)\.?$'),
    (match) => 'Виберіть слово, яке починається з ${match.group(1)}.',
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(r'^Choose the sentence that means "([^"]+)"\.?$'),
    (match) =>
        'Виберіть речення зі значенням «${_translateEmbedded(match.group(1)!)}».',
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(r'^Choose the meaning of "([^"]+)"\.?$'),
    (match) => 'Виберіть значення фрази «${match.group(1)}».',
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(r'^What does "([^"]+)" mean\?$', caseSensitive: false),
    (match) => 'Що означає «${match.group(1)}»?',
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(r'^Complete with the Spanish word for "([^"]+)": "([^"]+)"\.?$'),
    (match) =>
        'Доповніть іспанським словом зі значенням «${_translateEmbedded(match.group(1)!)}»: «${match.group(2)}».',
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(
      r'^Complete with the Spanish question word for "([^"]+)": "([^"]+)"\.?$',
    ),
    (match) =>
        'Доповніть іспанським питальним словом зі значенням «${_translateEmbedded(match.group(1)!)}»: «${match.group(2)}».',
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(r'^Complete with the "([^"]+)" form of ([^:]+): "([^"]+)"\.?$'),
    (match) =>
        'Доповніть формою «${_translateEmbedded(match.group(1)!)}» дієслова ${match.group(2)}: «${match.group(3)}».',
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(r'^Complete with the (.+?) form of ([^:]+): "([^"]+)"\.?$'),
    (match) =>
        'Доповніть формою ${_translateEmbedded(match.group(1)!)} дієслова ${match.group(2)}: «${match.group(3)}».',
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(
      r'^Type the Spanish (sentence|question|answer|request|command|word|phrase|introduction)(.*?): "([^"]+)"\.?$',
    ),
    (match) {
      final kind = _ukKind(match.group(1)!);
      final tail = _promptTail(match.group(2)!.trim());
      return 'Введіть іспанськ$kind$tail: «${_translateEmbedded(match.group(3)!)}».';
    },
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(
      r'^Write the Spanish (sentence|question|answer|request|command|word|phrase|location statement|sentence lines)(.*?): (.+)$',
    ),
    (match) {
      final kind = _ukWriteKind(match.group(1)!);
      final tail = _promptTail(match.group(2)!.trim());
      return 'Напишіть іспанськ$kind$tail: ${_translateEmbedded(match.group(3)!)}';
    },
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(r'^Select the (.+?) meaning "([^"]+)"\.?$'),
    (match) =>
        'Виберіть ${_translateEmbedded(match.group(1)!)} зі значенням «${_translateEmbedded(match.group(2)!)}».',
  );
  if (output != source) return output;

  output = output.replaceAllMapped(
    RegExp(r'^Type the Spanish phrase for the spoken number: "([^"]+)"\.?$'),
    (match) =>
        'Введіть іспанську фразу для названого числа: «${_translateEmbedded(match.group(1)!)}».',
  );
  if (output != source) return output;

  if (russian != null && russian.trim().isNotEmpty) {
    return _ukrainianFromRussian(russian);
  }
  return _translateMixedEducationalText(source);
}

String _translateVocabularyMeaning(String source) {
  final exact = _vocabularyUk[source.toLowerCase()];
  if (exact != null) return exact;
  return _translateEmbedded(source);
}

String _translateSupportOption(String source, {String? russian}) {
  final exact = _optionUk[source.toLowerCase()];
  if (exact != null) return exact;
  if (russian != null && russian.trim().isNotEmpty) {
    return _ukrainianFromRussian(russian);
  }
  return _translateEmbedded(source);
}

String _translateTitle(String source, {String? russian}) {
  final exact = _titleUk[source];
  if (exact != null) return exact;
  if (russian != null && russian.trim().isNotEmpty) {
    return _ukrainianFromRussian(russian);
  }
  return _translateEmbedded(source);
}

String _translateSentences(String source, {String? russian}) {
  final exact = _exactUk[source];
  if (exact != null) return exact;
  final patterned = _translateSentencePattern(source);
  if (patterned != null) return patterned;
  if (russian != null && russian.trim().isNotEmpty) {
    return _ukrainianFromRussian(russian);
  }
  return _translateEmbedded(source);
}

String _translateMixedEducationalText(String source, {String? russian}) {
  final exact = _exactUk[source];
  if (exact != null) return exact;
  if (russian != null && russian.trim().isNotEmpty) {
    return _ukrainianFromRussian(russian);
  }
  return _translateEmbedded(source);
}

String? _translateSentencePattern(String source) {
  final patterns = <({RegExp pattern, String Function(Match) build})>[
    (
      pattern: RegExp(r'^Hello\. My name is ([A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)\.$'),
      build: (match) => 'Привіт. Мене звати ${match.group(1)}.',
    ),
    (
      pattern: RegExp(
        r'^Hello, ([A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)\. My name is ([A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)\.$',
      ),
      build: (match) =>
          'Привіт, ${match.group(1)}. Мене звати ${match.group(2)}.',
    ),
    (
      pattern: RegExp(r'^Hello\. What is your name\?$', caseSensitive: false),
      build: (_) => 'Привіт. Як тебе звати?',
    ),
    (
      pattern: RegExp(r'^Hello\.$', caseSensitive: false),
      build: (_) => 'Привіт.',
    ),
    (
      pattern: RegExp(r'^Thank you\.$', caseSensitive: false),
      build: (_) => 'Дякую.',
    ),
    (
      pattern: RegExp(r'^Goodbye\.$', caseSensitive: false),
      build: (_) => 'До побачення.',
    ),
  ];
  for (final entry in patterns) {
    final match = entry.pattern.firstMatch(source);
    if (match != null) return entry.build(match);
  }
  return null;
}

String _ukrainianFromRussian(String value) {
  var output = value.trim();
  for (final entry in _ruPhraseToUk.entries) {
    output = output.replaceAll(entry.key, entry.value);
  }
  for (final entry in _ruWordToUk.entries) {
    output = output.replaceAllMapped(
      RegExp(
        '(?<![А-Яа-яЁёІіЇїЄєҐґ])${RegExp.escape(entry.key)}(?![А-Яа-яЁёІіЇїЄєҐґ])',
        caseSensitive: false,
      ),
      (match) => _matchCase(match.group(0)!, entry.value),
    );
  }
  output = output
      .replaceAll('ё', 'йо')
      .replaceAll('Ё', 'Йо')
      .replaceAll('э', 'е')
      .replaceAll('Э', 'Е')
      .replaceAll('ы', 'и')
      .replaceAll('Ы', 'И')
      .replaceAll('ъ', '')
      .replaceAll('Ъ', '');
  return _cleanup(output);
}

String _translateEmbedded(String value) {
  var output = value.trim();
  final sentence = _translateEmbeddedSentencePattern(output);
  if (sentence != null) return sentence;
  final exact = _embeddedUk[output.toLowerCase()];
  if (exact != null) return exact;
  final sortedKeys = _embeddedUk.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  for (final key in sortedKeys) {
    output = output.replaceAllMapped(
      RegExp(
        '(?<![A-Za-z])${RegExp.escape(key)}(?![A-Za-z])',
        caseSensitive: false,
      ),
      (match) => _matchCase(match.group(0)!, _embeddedUk[key]!),
    );
  }
  return _cleanup(output);
}

String? _translateEmbeddedSentencePattern(String value) {
  String tr(String fragment) => _translateEmbedded(fragment);
  if (value.contains('. ')) {
    final sentenceMatches = RegExp(r'[^.?!]+[.?!]').allMatches(value).toList();
    final coveredLength = sentenceMatches
        .map((match) => match.group(0)!.length)
        .fold<int>(0, (sum, length) => sum + length);
    if (sentenceMatches.isNotEmpty && coveredLength >= value.length - 1) {
      final translated = <String>[];
      var changed = false;
      for (final match in sentenceMatches) {
        final sentence = match.group(0)!.trim();
        final mapped = _translateEmbeddedSentencePattern(sentence);
        translated.add(mapped ?? sentence);
        changed = changed || mapped != null;
      }
      if (changed) return translated.join(' ');
    }
  }
  final patterns = <({RegExp pattern, String Function(Match) build})>[
    (
      pattern: RegExp(r'^My name is ([A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)\.$'),
      build: (match) => 'Мене звати ${match.group(1)}.',
    ),
    (
      pattern: RegExp(r'^I am from ([A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)\.$'),
      build: (match) => 'Я з ${match.group(1)}.',
    ),
    (
      pattern: RegExp(r'^I live in ([A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)\.$'),
      build: (match) => 'Я живу в ${match.group(1)}.',
    ),
    (
      pattern: RegExp(r'^I speak a little (.+)\.$'),
      build: (match) => 'Я трохи говорю ${tr(match.group(1)!)}.',
    ),
    (
      pattern: RegExp(r'^I speak (.+)\.$'),
      build: (match) => 'Я говорю ${tr(match.group(1)!)}.',
    ),
    (
      pattern: RegExp(r'^I have (.+)\.$'),
      build: (match) => 'У мене є ${tr(match.group(1)!)}.',
    ),
    (
      pattern: RegExp(r'^I want (.+), please\.$'),
      build: (match) => 'Я хочу ${tr(match.group(1)!)}, будь ласка.',
    ),
    (
      pattern: RegExp(r'^I need (.+)\.$'),
      build: (match) => 'Мені потрібен/потрібна ${tr(match.group(1)!)}.',
    ),
    (
      pattern: RegExp(r'^I do not have (.+)\.$'),
      build: (match) => 'У мене немає ${tr(match.group(1)!)}.',
    ),
    (
      pattern: RegExp(r'^Do you have (.+)\?$'),
      build: (match) => 'У тебе є ${tr(match.group(1)!)}?',
    ),
    (
      pattern: RegExp(r'^Where is the (.+)\?$'),
      build: (match) => 'Де ${tr(match.group(1)!)}?',
    ),
    (
      pattern: RegExp(r'^Where is your (.+)\?$'),
      build: (match) => 'Де твій/твоя ${tr(match.group(1)!)}?',
    ),
    (
      pattern: RegExp(r'^What does (.+) mean\?$'),
      build: (match) => 'Що означає ${match.group(1)}?',
    ),
    (
      pattern: RegExp(r'^Which languages do you speak\?$'),
      build: (_) => 'Якими мовами ти говориш?',
    ),
    (
      pattern: RegExp(r'^She is from ([A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)\.$'),
      build: (match) => 'Вона з ${match.group(1)}.',
    ),
    (
      pattern: RegExp(r'^She lives in ([A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)\.$'),
      build: (match) => 'Вона живе в ${match.group(1)}.',
    ),
    (
      pattern: RegExp(r'^She speaks (.+)\.$'),
      build: (match) => 'Вона говорить ${tr(match.group(1)!)}.',
    ),
    (
      pattern: RegExp(r'^He speaks (.+)\.$'),
      build: (match) => 'Він говорить ${tr(match.group(1)!)}.',
    ),
    (
      pattern: RegExp(r'^Does she speak (.+)\?$'),
      build: (match) => 'Вона говорить ${tr(match.group(1)!)}?',
    ),
    (pattern: RegExp(r'^Who is she\?$'), build: (_) => 'Хто вона?'),
    (pattern: RegExp(r'^Who is he\?$'), build: (_) => 'Хто він?'),
    (pattern: RegExp(r'^Who is she/he\?$'), build: (_) => 'Хто це?'),
    (
      pattern: RegExp(r'^Where does she live\?$'),
      build: (_) => 'Де вона живе?',
    ),
    (pattern: RegExp(r'^Is he your friend\?$'), build: (_) => 'Він твій друг?'),
    (
      pattern: RegExp(r'^She is my friend\.$'),
      build: (_) => 'Вона моя подруга.',
    ),
    (
      pattern: RegExp(r'^She is my teacher\.$'),
      build: (_) => 'Вона моя вчителька.',
    ),
    (
      pattern: RegExp(r'^Her name is ([A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)\.$'),
      build: (match) => 'Її звати ${match.group(1)}.',
    ),
    (
      pattern: RegExp(r'^She is ([A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)\.$'),
      build: (match) => 'Це ${match.group(1)}.',
    ),
    (pattern: RegExp(r'^She is nice\.$'), build: (_) => 'Вона приємна.'),
    (
      pattern: RegExp(r'^The (.+) is expensive\.$'),
      build: (match) => '${_titleCase(tr(match.group(1)!))} дорогий/дорога.',
    ),
    (
      pattern: RegExp(r'^The (.+) is cheap\.$'),
      build: (match) => '${_titleCase(tr(match.group(1)!))} дешевий/дешева.',
    ),
    (
      pattern: RegExp(r'^The (.+) is near\.$'),
      build: (match) => '${_titleCase(tr(match.group(1)!))} близько.',
    ),
    (
      pattern: RegExp(r'^Take the (.+)\.$'),
      build: (match) => 'Сядь на ${tr(match.group(1)!)}.',
    ),
    (pattern: RegExp(r'^Excuse me\.$'), build: (_) => 'Вибачте.'),
    (
      pattern: RegExp(r'^Can you help me\?$'),
      build: (_) => 'Можете мені допомогти?',
    ),
    (
      pattern: RegExp(r'^Nothing else, thank you\.$'),
      build: (_) => 'Більше нічого, дякую.',
    ),
    (
      pattern: RegExp(r'^This is the (.+)\.$'),
      build: (match) => 'Це ${tr(match.group(1)!)}.',
    ),
    (
      pattern: RegExp(r'^There is a (.+) in the (.+)\.$'),
      build: (match) => 'У ${tr(match.group(2)!)} є ${tr(match.group(1)!)}.',
    ),
    (
      pattern: RegExp(r'^He is in the (.+)\.$'),
      build: (match) => 'Він у ${tr(match.group(1)!)}.',
    ),
    (
      pattern: RegExp(r'^My (.+) is in the (.+)\.$'),
      build: (match) =>
          'Мій/моя ${tr(match.group(1)!)} у ${tr(match.group(2)!)}.',
    ),
    (
      pattern: RegExp(r'^Her (.+) is named ([A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)\.$'),
      build: (match) => 'Її ${tr(match.group(1)!)} звати ${match.group(2)}.',
    ),
    (
      pattern: RegExp(r'^The (.+) is in the (.+)\.$'),
      build: (match) =>
          '${_titleCase(tr(match.group(1)!))} у ${tr(match.group(2)!)}.',
    ),
    (pattern: RegExp(r'^Are you well\?$'), build: (_) => 'Тобі добре?'),
    (
      pattern: RegExp(r'^What is wrong with you\?$'),
      build: (_) => 'Що з тобою?',
    ),
    (
      pattern: RegExp(r'^My (.+) is sick and needs (.+)\.$'),
      build: (match) =>
          'Мій/моя ${tr(match.group(1)!)} хворіє і потребує ${tr(match.group(2)!)}.',
    ),
    (
      pattern: RegExp(r'^No, we do not have (.+)\.$'),
      build: (match) => 'Ні, у нас немає ${tr(match.group(1)!)}.',
    ),
    (
      pattern: RegExp(r'^Yes, we have (.+)\.$'),
      build: (match) => 'Так, у нас є ${tr(match.group(1)!)}.',
    ),
  ];
  for (final entry in patterns) {
    final match = entry.pattern.firstMatch(value);
    if (match != null) return entry.build(match);
  }
  return null;
}

String _ukrainianPronunciationHint(String ruHint) {
  return ruHint
      .replaceAll('луис', 'луи́с')
      .replaceAll('Луис', 'Луи́с')
      .replaceAll('э', 'е')
      .replaceAll('Э', 'Е')
      .replaceAll('ы', 'и')
      .replaceAll('Ы', 'И')
      .replaceAll('ё', 'йо')
      .replaceAll('Ё', 'Йо');
}

Map<String, Object?> _translateGraphemePresentation(
  Map<String, Object?> ruPresentation,
) {
  final translated = <String, Object?>{};
  for (final entry in ruPresentation.entries) {
    final value = entry.value;
    if (value is String) {
      translated[entry.key] = _ukrainianFromRussian(value);
    } else if (value is List) {
      translated[entry.key] = value
          .map((item) => item is String ? _ukrainianFromRussian(item) : item)
          .toList();
    } else {
      translated[entry.key] = value;
    }
  }
  return translated;
}

String _promptTail(String text) {
  if (text.isEmpty) return '';
  return ' ${_translateEmbedded(text)}';
}

String _ukKind(String kind) {
  return switch (kind) {
    'question' => 'е запитання',
    'answer' => 'у відповідь',
    'request' => 'е прохання',
    'command' => 'у команду',
    'word' => 'е слово',
    'phrase' => 'у фразу',
    'introduction' => 'е представлення',
    _ => 'е речення',
  };
}

String _ukWriteKind(String kind) {
  return switch (kind) {
    'question' => 'е запитання',
    'answer' => 'у відповідь',
    'request' => 'е прохання',
    'command' => 'у команду',
    'word' => 'е слово',
    'phrase' => 'у фразу',
    'location statement' => 'е речення про місце',
    'sentence lines' => 'і рядки',
    _ => 'е речення',
  };
}

bool _looksLikeTargetOrName(String value) {
  if (value.startsWith('¿') || value.startsWith('¡')) return true;
  if (!value.contains(' ') && RegExp(r'[áéíóúñüÁÉÍÓÚÑÜ]').hasMatch(value)) {
    return true;
  }
  if (!value.contains(' ') &&
      RegExp(r'^[A-ZÁÉÍÓÚÑ][A-Za-zÁÉÍÓÚÜÑáéíóúüñ-]+$').hasMatch(value)) {
    return true;
  }
  return false;
}

String _titleCase(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1);
}

String _matchCase(String original, String replacement) {
  if (replacement.isEmpty) {
    return replacement;
  }
  if (original.toUpperCase() == original) {
    return replacement.toUpperCase();
  }
  if (original[0].toUpperCase() == original[0]) {
    return replacement[0].toUpperCase() + replacement.substring(1);
  }
  return replacement;
}

String _cleanup(String value) {
  return value
      .replaceAll(' с ', ' з ')
      .replaceAll(' со ', ' зі ')
      .replaceAll(' и ', ' і ')
      .replaceAll(' з з ', ' з ')
      .replaceAll(' .', '.')
      .replaceAll(' ,', ',')
      .replaceAll(' ?', '?')
      .replaceAll(' !', '!')
      .replaceAll('..', '.')
      .replaceAll('«', '«')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String _normalizeComparable(String value) {
  return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
}

void _writePrettyJson(File file, Map<String, Object?> value) {
  file.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(value)}\n',
  );
}

class _LocalizationStats {
  const _LocalizationStats({required this.written, required this.invariant});
  final int written;
  final int invariant;
}

class _PronunciationStats {
  const _PronunciationStats({
    required this.hints,
    required this.explanations,
    required this.readingRuleFields,
  });
  final int hints;
  final int explanations;
  final int readingRuleFields;
}

const _fieldUk = {
  'vocab.es.a0.c2.el_article.v1|native_translation':
      'означений артикль чоловічого роду',
  'vocab.es.a0.c2.la_article.v1|native_translation':
      'означений артикль жіночого роду',
  'grammar.es.a0.m02.origin_seed.v1|title': 'Основа походження у представленні',
  'reading.basic_greeting.v1|title': 'Ана вітається',
  'reading.es.a0.c2.numbers_eleven_twenty.v1|title':
      'Числа від одинадцяти до двадцяти',
  'reading.es.a0.c2.numbers_zero_ten.v1|title': 'Числа від нуля до десяти',
  'reading.es.a0.foundations.tener_basic.v1|title': 'Читання про tener',
  'reading.es.a0.m02.review_directory.v1|title': 'Список знайомств',
  'reading.es.a0.m03.residence_cards.v1|title': 'Картки місця проживання',
  'reading.es.a0.m03.two_people.v1|title': 'Дві людини',
  'reading.es.a0.m04.class_intro.v1|title': 'Представлення в класі',
  'reading.es.a0.m04.short_message.v1|title': 'Коротке повідомлення про друга',
  'reading.es.a0.m04.two_people.v1|title': 'Дві людини',
  'reading.es.a0.m05.checkpoint_list.v1|native_translation':
      'Вода: два євро. Олівець: один євро. Сумка: три євро.',
  'reading.es.a0.m05.price_list.v1|title': 'Короткий список цін',
  'reading.es.a0.m05.purchase_note.v1|title': 'Нотатка про покупку',
  'reading.es.a0.m05.shop_availability.v1|title': 'У магазині',
  'reading.es.a0.m06.transport_note.v1|title': 'Нотатка про транспорт',
  'reading.es.a0.m07.communication_note.v1|title': 'Виправлення в спілкуванні',
  'reading.es.a0.m07.emergency_note.v1|title': 'Термінова допомога',
  'reading.es.a0.m09.health_note_luis.v1|title': 'Луїсу недобре',
  'reading.es.a0.unit1.first_contact.v1|title': 'Перше знайомство',
  'reading.es.a0.unit1.language_question.v1|title': 'Запитання про мову',
  'reading.es.a0.unit1.more_courtesy.v1|title': 'Більше ввічливості',
  'reading.es.a0.unit1.names.v1|title': 'Імена',
  'reading.es.a0.unit1.origin.v1|title': 'Походження',
  'dialogue.es.a0.m08.no_siblings.v1|lines.0.native_translation':
      'У тебе є брати або сестри?',
  'dialogue.es.a0.m08.no_siblings.v1|lines.1.native_translation':
      'Ні, у мене немає братів і сестер.',
  'dialogue.es.a0.m08.no_siblings.v1|title':
      'Заперечна відповідь про братів і сестер',
  'dialogue.es.a0.m08.siblings_question.v1|lines.0.native_translation':
      'У тебе є брати або сестри?',
  'dialogue.es.a0.m08.siblings_question.v1|title':
      'Запитання про братів і сестер',
  'dialogue.es.a0.m08.person_location.v1|lines.1.native_translation':
      'Він у вітальні.',
  'dialogue.es.a0.m09.basic_condition.v1|lines.0.native_translation':
      'Ти добре почуваєшся?',
  'dialogue.es.a0.m09.basic_condition.v1|lines.1.native_translation':
      'Ні, мені недобре.',
  'vocab.es.a0.m06.metro.v1|native_translation': 'метро',
  'vocab.es.a0.m06.bicicleta.v1|notes': 'Слово про транспорт: велосипед.',
  'vocab.es.a0.m06.coche.v1|notes': 'Слово про транспорт: машина.',
  'vocab.es.a0.m06.farmacia.v1|notes': 'Місце: аптека.',
  'vocab.es.a0.m06.supermercado.v1|notes': 'Місце: супермаркет.',
  'vocab.es.a0.m06.parada.v1|notes': 'Автобусна або транспортна зупинка.',
  'dialogue.es.a0.m06.route_exchange.v1|lines.2.native_translation':
      'Де зупинка?',
  'dialogue.es.a0.m09.integrated_a0.v1|lines.1.native_translation':
      'Приємно познайомитися. Ти добре почуваєшся?',
  'dialogue.es.a0.m09.integrated_help.v1|lines.2.native_translation':
      'Мені недобре. У мене болить голова.',
  'template.es.a0.m08.competency.family_home_exchange.v1|prompt_template':
      'Діагностика: доповніть діалог про сімʼю і дім двома іспанськими реченнями: вона моя сестра; вона у вітальні.',
  'template.es.a0.m08.l057.profile_choice.v1|prompt_template':
      'Виберіть іспанське речення, яке говорить, що стілець у вітальні.',
  'template.es.a0.m08.l057.type_mi_madre_salon.v1|prompt_template':
      'Введіть іспанське речення про місце: «моя мама у вітальні».',
  'template.es.a0.m09.review.condition_choice.v1|answer_options.notwell.label':
      'мені недобре',
  'reading.es.a0.m06.checkpoint_route.v1|native_translation':
      'Станція близько. Їдьте автобусом. Зупинка там.',
  'reading.es.a0.m06.station_location.v1|native_translation':
      'Станція близько. Зупинка тут. Готель далеко.',
  'reading.es.a0.m08.family_home_note.v1|native_translation':
      'Моя мама у вітальні. Мій батько на кухні. Моя сестра у спальні.',
  'reading.es.a0.m08.home_rooms.v1|native_translation':
      'Це дім Ани. Кухня тут. Вітальня там. Спальня праворуч.',
  'reading.es.a0.m09.health_note_luis.v1|native_translation':
      'Луїсу недобре. У нього болить голова. Луїсу потрібна аптека. Аптека поруч.',
  'reading.es.a0.m09.help_scenario.v1|native_translation':
      'Елена на станції. Їй недобре. Вона каже: мені потрібен лікар. Пабло каже: лікарня там.',
  'dialogue.es.a0.m06.where_station.v1|lines.0.native_translation':
      'Вибачте, де станція?',
  'dialogue.es.a0.m06.where_station.v1|title': 'Запитання про станцію',
  'dialogue.es.a0.m07.emergency_help.v1|lines.2.native_translation':
      'Мені потрібен лікар.',
  'dialogue.es.a0.m09.integrated_a0.v1|lines.2.native_translation':
      'Мені погано. Мені потрібен лікар.',
  'dialogue.es.a0.m09.symptom.v1|lines.1.native_translation':
      'У мене болить голова.',
  'template.es.a0.m06.competency.ask_where_station.v1|prompt_template':
      'Запитайте, де станція. Введіть іспанське запитання.',
  'template.es.a0.m06.l037.where_question_choice.v1|prompt_template':
      'Виберіть іспанське запитання для «де станція?».',
  'template.es.a0.m06.review.type_donde_estacion.v1|prompt_template':
      'Повторення: введіть іспанське запитання: «де станція?»',
  'template.es.a0.m07.checkpoint.type_need_doctor.v1|prompt_template':
      'Контрольна перевірка: введіть іспанське речення: «Мені потрібен лікар».',
  'template.es.a0.m07.competency.complete_help_exchange.v1|prompt_template':
      'Доповніть діалог про допомогу. Спочатку приверніть увагу. Потім скажіть: «Мені потрібен лікар».',
  'template.es.a0.m07.l048.emergency_choice.v1|prompt_template':
      'Виберіть іспанське речення для «Мені потрібен лікар».',
  'template.es.a0.m07.review.reading_choice.v1|answer_options.doctor.label':
      'мені потрібен лікар',
  'template.es.a0.m07.review.reading_choice.v1|answer_options.help.label':
      'мені потрібна допомога',
  'template.es.a0.m09.l066.type_symptom_and_need.v1|prompt_template':
      'Введіть два іспанські речення: «у мене болить живіт; мені потрібна допомога».',
  'template.es.a0.m09.review.condition_choice.v1|answer_options.need.label':
      'мені потрібна вода',
  'es.a0.m02.l007|communicativeOutcome':
      'Поставити запитання про імʼя і відповісти на нього.',
  'reading.es.a0.m06.station_location.v1|title': 'Де станція',
  'reading.es.a0.m07.emergency_note.v1|native_translation':
      'Мені потрібен лікар. Це екстрена ситуація. Мені потрібна поліція.',
  'reading.es.a0.m09.final_profile.v1|native_translation':
      'Марта живе в Лімі. Її сестру звати Ана. Ана хвора. У неї болить живіт. Марті потрібна допомога і вода.',
  'reading.es.a0.m09.short_transcript.v1|native_translation':
      'Лікар: у тебе температура? Луїс: так, у мене температура. Лікар: у тебе болить голова? Луїс: ні.',
  'vocab.es.a0.m06.estacion.v1|notes':
      'Станція потяга, метро або автобуса в цьому модулі.',
  'es.a0.m06.l016.activity.grammar|title': 'Правило читання',
  'es.a0.m06.l017.activity.grammar|title': 'Правило читання',
  'es.a0.m08.l054.summary|reviewPrompt':
      'Запитайте й дайте відповідь, чи має хтось братів або сестер.',
  'es.a0.m09.l065.summary|reviewPrompt':
      'Попросіть повторити або говорити повільніше під час діалогу про здоровʼя.',
  'template.es.a0.c2.l023_fill_tengo_age.v1|prompt_template':
      'Доповніть формою tener для віку: «____ veinte años.».',
  'template.es.a0.m08.l058.type_ask_and_answer_location.v1|prompt_template':
      'Введіть іспанське запитання і відповідь: «Де твій батько? Він у вітальні.».',
  'template.es.a0.m09.checkpoint.type_integrated_final.v1|prompt_template':
      'Напишіть іспанські репліки в такому порядку: приверніть увагу, скажіть, що вам недобре, попросіть лікаря і попросіть повторити.',
  'template.es.a0.m09.competency.health_exchange.v1|prompt_template':
      'Напишіть іспанські репліки в такому порядку: скажіть, що вам недобре, скажіть, що болить голова, і запитайте про аптеку.',
  'template.es.a0.m09.competency.integrated_a0_exchange.v1|prompt_template':
      'Напишіть іспанські репліки в такому порядку: представтеся як Marta, скажіть, що вам потрібна допомога, і запитайте, де аптека.',
  'template.es.a0.m09.l066.type_basic_health_exchange.v1|prompt_template':
      'Напишіть іспанські репліки в такому порядку: приверніть увагу, скажіть, що вам недобре, і запитайте про аптеку.',
  'template.es.a0.m09.l067.type_lost_unwell.v1|prompt_template':
      'Напишіть іспанські репліки в такому порядку: попросіть допомоги, скажіть, що вам недобре, і запитайте, де аптека.',
  'template.es.a0.m09.l068.type_integrated_a0_identity_help.v1|prompt_template':
      'Напишіть іспанські репліки в такому порядку: представтеся як Ana, скажіть, що ви з Peru, і скажіть, що вам потрібна допомога.',
  'template.es.a0.m09.review.type_integrated_help.v1|prompt_template':
      'Напишіть іспанські репліки в такому порядку: скажіть, що болить голова, і запитайте, де аптека.',
  'grammar.es.a0.c2.qu_gue_gui.v1|explanation':
      'Перед e або i сполучення qu передає звук k у словах на кшталт queso. У gue та gui літера u допомагає зберегти твердий звук g у словах на кшталт Miguel.',
  'grammar.es.a0.c2.reading_basics.v1|explanation':
      'Іспанське написання часто регулярніше за англійське. Голосні стабільні, h не вимовляється, ñ є окремою літерою, а письмові наголоси можуть позначати наголос або значення.',
  'grammar.es.a0.m04.who_is_person.v1|title': '¿Quién es? та Es',
  'grammar.es.a0.m06.how_to_get_questions.v1|title':
      '¿Cómo llego...? та ¿Cómo voy...?',
  'grammar.es.a0.m07.puede_ayudarme.v1|explanation':
      '¿Puede ayudarme? — це ввічливе стале запитання зі значенням «Можете мені допомогти?». Використовуйте його, коли вам потрібна допомога іншої людини. Це запитання, тому воно зберігає іспанські знаки питання.',
  'grammar.es.a0.m08.home_rooms.v1|explanation':
      'Використовуйте este/esta з назвами кімнат у простих реченнях-ідентифікаціях. Мета уроку — розпізнавати й називати кімнати, а не вивчати рід іменників глибоко.',
  'es.a0.m06.l016|communicativeOutcome':
      'Читайте перші іспанські слова з опорою на базову вимову.',
  'es.a0.m06.l016|description':
      'Читайте перші іспанські слова зі стабільними голосними, німою h, наголосом і частотними сполученнями, потрібними для ранніх привітань.',
  'reading.es.a0.c2.reading_qu_g.v1|native_translation':
      'Queso починається з qu. У Miguel є gue. Gui зберігає твердий звук g.',
  'vocab.es.a0.foundations.hola.v1|notes':
      'Просте привітання, яке можна використовувати будь-коли протягом дня.',
  'vocab.es.a0.c2.hola.v1|notes':
      'Просте привітання, яке можна використовувати будь-коли протягом дня.',
  'vocab.es.a0.foundations.hambre.v1|native_translation': 'голод',
  'vocab.es.a0.c2.hambre.v1|native_translation': 'голод',
  'vocab.es.a0.foundations.hambre.v1|notes':
      'Іспанською “I am hungry” передається як tengo hambre.',
  'grammar.es.a0.m01.silent_h.v1|explanation':
      'В іспанській літера h зазвичай пишеться, але не вимовляється. Читайте hola як ola, а hambre як ambre. На письмі h усе одно зберігається.',
  'grammar.es.a0.foundations.tener_basic.v1|explanation':
      'Tener означає “мати”. На рівні A0 використовуйте tengo для “у мене є”, tienes для “у тебе є” і розпізнавайте tiene для “у нього / неї є”. Використовуйте tener для речей, як у Tengo un libro. Іспанська також використовує tener у сталих виразах, наприклад Tengo hambre. Типова помилка початківців — перекладати “I am hungry” через soy або estoy; у цьому виразі використовуйте tengo hambre.',
  'grammar.es.a0.m01.morning_evening.v1|explanation':
      'Використовуйте buenos días вранці, buenas tardes удень, а buenas noches увечері або вночі. Hola працює будь-коли.',
  'vocab.es.a0.unit1.si.v1|notes': 'Наголос / знак відрізняє sí від si.',
  'es.a0.m06.l016|title': 'Німа літера h («аче») і сталі голосні',
  'es.a0.m02.l009|communicativeOutcome':
      'Вибирайте й складайте відповіді під час першого знайомства.',
  'es.a0.m02.l009|description':
      'Поєднайте привітання, імена, ввічливість і просту фразу про походження.',
  'es.a0.m03.l013|title': 'Я з...',
  'es.a0.m03.l013|communicativeOutcome': 'Скажіть, звідки ви.',
  'es.a0.m03.l013|description':
      'Скажіть походження за допомогою soy de і невеликого набору країн.',
  'es.a0.m03.l014|communicativeOutcome': 'Запитайте, звідки інша людина.',
  'es.a0.m03.l014|description':
      'Поставте базове запитання про походження і дайте відповідь.',
  'es.a0.m03.l015|title': 'Де ти живеш?',
  'es.a0.m03.l015|communicativeOutcome': 'Скажіть і запитайте, де хтось живе.',
  'es.a0.m03.l015|description':
      'Скажіть і запитайте, де хтось живе, з vivo en.',
  'es.a0.m03.l016|title': 'Мови, якими я говорю',
  'es.a0.m03.l016|communicativeOutcome': 'Скажіть, якими мовами ви говорите.',
  'es.a0.m03.l017|title': 'Запитання і відповіді про себе',
  'es.a0.m03.l017|communicativeOutcome':
      'Поставте базові запитання про себе і дайте відповіді.',
  'es.a0.m03.l017|description':
      'Обміняйтеся інформацією про походження, місце проживання і мову.',
  'es.a0.m03.l018|title': 'Повторення особистої інформації',
  'es.a0.m03.l018|communicativeOutcome':
      'Повторіть базову особисту інформацію.',
  'es.a0.m03.l018|description':
      'Повторіть імена, походження, місце проживання і мови в нових комбінаціях.',
  'es.a0.m03.l019|communicativeOutcome':
      'Виконайте контрольну перевірку основ модуля 3.',
  'es.a0.m03.l019|description':
      'Перевірте привітання, імена, походження, місце проживання, мови й ранні запитання.',
  'es.a0.m04.l010|communicativeOutcome':
      'Пригадайте привітання, ввічливість і фрази уточнення.',
  'es.a0.m04.l010|description':
      'Повторіть привітання, ввічливість, уточнення і ранні правила читання.',
  'es.a0.m04.l020|title': 'Хто ця людина?',
  'es.a0.m04.l020|communicativeOutcome':
      'Запитайте, хто ця людина, і назвіть її імʼя.',
  'es.a0.m04.l020|description':
      'Запитайте, хто ця людина, і визначте її за імʼям.',
  'es.a0.m04.l021|title': 'Люди і ролі',
  'es.a0.m04.l021|communicativeOutcome':
      'Визначте базовий звʼязок або роль людини.',
  'es.a0.m04.l021|description':
      'Скажіть, чи є людина другом, учителем, учнем або однокласником.',
  'es.a0.m04.l022|description':
      'Запитайте, якою є людина, і дайте один базовий опис.',
  'template.es.a0.m01.l001.type_hola_with_h.v1|prompt_template':
      'Введіть іспанське слово зі значенням «привіт» з німою h.',
  'template.es.a0.m04.l023.person_form_choice.v1|prompt_template':
      'Виберіть іспанське речення зі значенням «Вона живе в Лімі».',
  'template.es.a0.m04.l023.type_es_de_espana.v1|prompt_template':
      'Введіть іспанське речення: «Вона з Іспанії».',
  'template.es.a0.c2.l023_age_choice.v1|prompt_template':
      'Виберіть іспанську конструкцію для віку.',
  'template.es.a0.foundations.word_order_me_llamo.v1|prompt_template':
      'Введіть сталу іспанську конструкцію: «Мене звати Ана».',
  'template.es.a0.m03.l016.fill_un_poco_de.v1|prompt_template':
      'Доповніть іспанським словом, яке завершує фразу про обмежене вміння: «Hablo un poco ____ español.»',
  'template.es.a0.m07.competency.request_emergency_help.v1|prompt_template':
      'Попросіть термінову допомогу. Введіть іспанське речення: «Мені потрібна поліція».',
  'template.es.a0.m08.checkpoint.fill_hermanos.v1|prompt_template':
      'Доповніть іспанським словом для «брати або сестри»: «¿Tienes ____?»',
  'template.es.a0.m08.checkpoint.type_family_question.v1|prompt_template':
      'Напишіть іспанське запитання про те, чи має інша людина братів або сестер.',
  'template.es.a0.m08.competency.ask_about_family.v1|prompt_template':
      'Діагностика: запитайте, чи має інша людина братів або сестер.',
  'template.es.a0.m08.competency.identify_room_object.v1|prompt_template':
      'Діагностика: назвіть кімнату й предмет іспанською: кухня і стіл.',
  'template.es.a0.m09.l064.service_choice.v1|prompt_template':
      'Виберіть іспанське прохання для ситуації, коли потрібна аптека.',
  'template.es.a0.m09.review.fill_duele.v1|prompt_template':
      'Доповніть іспанську конструкцію для болю: «Me ____ la garganta.»',
  'template.es.a0.unit1.match_greetings.v1|prompt_template':
      'Зіставте кожне іспанське привітання або прощання з потрібним англійським значенням.',
  'template.es.a0.u01.l01.recognize_buenos_dias.v1|answer_options.option.good_morning.label':
      'доброго ранку',
  'template.es.a0.u01.l01.recognize_hola.v1|answer_options.option.good_morning.label':
      'доброго ранку',
  'template.es.a0.c2.l021_number_choice.v1|answer_options.option.1.label':
      'вісім',
  'template.es.a0.c2.l021_number_choice.v1|answer_options.option.3.label':
      'одинадцять',
  'template.es.a0.c2.l022_number_choice.v1|answer_options.option.1.label':
      'шістнадцять',
  'template.es.a0.c2.l022_number_choice.v1|answer_options.option.2.label':
      'шість',
  'template.es.a0.c2.l022_number_choice.v1|answer_options.option.3.label':
      'сімнадцять',
  'template.es.a0.m06.competency.understand_direction.v1|answer_options.left.label':
      'поверніть ліворуч',
  'template.es.a0.m06.competency.understand_direction.v1|answer_options.right.label':
      'поверніть праворуч',
  'template.es.a0.m06.competency.understand_direction.v1|answer_options.straight.label':
      'іти прямо',
  'template.es.a0.m09.competency.understand_instruction.v1|answer_options.family.label':
      'назвіть сестру',
  'grammar.es.a0.m03.simple_word_order.v1|title': 'Простий порядок слів',
  'grammar.es.a0.m03.simple_word_order.v1|explanation':
      'Безпечна початкова конструкція: підмет + дієслово + додаток. Іспанська часто пропускає yo, коли форма дієслова вже показує «я».',
  'grammar.es.a0.c2.simple_word_order.v1|title': 'Простий порядок слів',
  'grammar.es.a0.c2.simple_word_order.v1|explanation':
      'Безпечна початкова конструкція: підмет + дієслово + додаток. Іспанська часто пропускає yo, коли форма дієслова вже показує «я».',
  'grammar.es.a0.foundations.basic_word_order.v1|title': 'Базовий порядок слів',
  'grammar.es.a0.foundations.basic_word_order.v1|explanation':
      'Короткі іспанські речення часто мають підмет, дієслово й решту думки. На A0 зберігайте знайомі сталі конструкції без змін: Me llamo Ana, Soy de Madrid, Tengo un libro, Ana tiene un libro. Не переставляйте слова випадково.',
  'grammar.es.a0.m03.personal_pronouns.v1|title': 'Особові займенники: yo і tú',
  'grammar.es.a0.m03.personal_pronouns.v1|explanation':
      'Іспанська використовує особові займенники, щоб показати, хто говорить або до кого звертаються. У фразах першого контакту yo означає «я», а tú означає «ти». Іспанська часто пропускає займенники, бо форма дієслова вже показує особу, але початківці можуть використовувати yo і tú, щоб значення було ясним. Tú — неформальне «ти» в однині.',
  'grammar.es.a0.unit1.personal_pronouns.v1|title':
      'Особові займенники: yo і tú',
  'grammar.es.a0.unit1.personal_pronouns.v1|explanation':
      'Іспанська використовує особові займенники, щоб показати, хто говорить або до кого звертаються. У фразах першого контакту yo означає «я», а tú означає «ти». Іспанська часто пропускає займенники, бо форма дієслова вже показує особу, але початківці можуть використовувати yo і tú, щоб значення було ясним. Tú — неформальне «ти» в однині.',
  'grammar.es.a0.m06.transport_methods.v1|title': 'Способи пересування',
  'grammar.es.a0.m06.transport_methods.v1|explanation':
      'Використовуйте Voy en... для автобуса, потяга, метро, таксі, машини й велосипеда. Використовуйте Voy a pie для руху пішки. Для поради використовуйте сталі фрази A0: Toma el metro або Ve en autobús.',
  'grammar.es.a0.m06.transport_method.v1|title': 'Способи пересування',
  'grammar.es.a0.m06.transport_method.v1|explanation':
      'Використовуйте Voy en... для автобуса, потяга, метро, таксі, машини й велосипеда. Використовуйте Voy a pie для руху пішки. Для поради використовуйте сталі фрази A0: Toma el metro або Ve en autobús.',
  'grammar.es.a0.m03.languages_un_poco.v1|explanation':
      'Використовуйте hablo un poco de плюс назву мови для обмеженого вміння. Зберігайте de перед мовою.',
  'grammar.es.a0.m03.residence_vivo_en.v1|title': 'Місце проживання з vivo en',
  'grammar.es.a0.m04.basic_gender_agreement.v1|explanation':
      'Деякі слова ролей і опису змінюють кінцеве -o на -a для жіночої форми. Цей модуль навчає тільки частотних пар, які використовуються в уроках.',
  'grammar.es.a0.m04.person_conversation.v1|explanation':
      'Коротка повсякденна розмова може назвати людину, дати роль і додати один факт про походження, місце проживання або мову.',
  'grammar.es.a0.m04.third_person_identity.v1|title':
      'Факти про людину в третій особі',
  'grammar.es.a0.m04.yes_no_person_questions.v1|title':
      'Запитання так/ні про людину',
  'grammar.es.a0.m05.polite_availability.v1|explanation':
      'У рольовій вправі в магазині використовуйте ввічливе стале запитання ¿Tiene...? щоб запитати, чи є в продавця предмет. Продавець може відповісти Sí, tenemos або No, no tenemos. Цей модуль не навчає повного порівняння tú/usted.',
  'grammar.es.a0.m05.un_una_objects.v1|explanation':
      'Використовуйте un з відпрацьованими словами чоловічого роду, як-от libro і cuaderno. Використовуйте una з відпрацьованими словами жіночого роду, як-от botella, bolsa і llave. Цей модуль навчає тільки цих знайомих прикладів.',
  'grammar.es.a0.m07.emergency_requests.v1|explanation':
      'Для термінової допомоги зберігайте речення коротким і прямим. Використовуйте necesito з médico або policía, або скажіть es una emergencia. Застосунок поки не навчає широкої розмови про екстрені ситуації.',
  'grammar.es.a0.m08.family_identification.v1|explanation':
      'Використовуйте este з іменниками чоловічого роду й esta з іменниками жіночого роду в обмежених реченнях про сімʼю. Тут не вивчається повна система вказівних слів; складайте тільки корисні речення на кшталт Este es mi padre і Esta es mi madre.',
  'grammar.es.a0.m08.location_with_estar_home.v1|title': 'Місце вдома з estar',
  'grammar.es.a0.m08.tener_family.v1|explanation':
      'Використовуйте tengo, щоб говорити про себе, tienes, щоб запитати іншу людину, і tiene, щоб говорити про іншу людину. Обмежуйте конструкцію сімейними фактами.',
  'grammar.es.a0.m09.estar_condition.v1|explanation':
      'Використовуйте estoy, щоб сказати, як ви почуваєтесь, estás, щоб запитати одну людину, і está, щоб говорити про іншу людину. Тут це обмежено простими фразами про здоровʼя або стан.',
  'grammar.es.a0.m09.integrated_health_exchange.v1|title':
      'Обмежений діалог про здоровʼя і допомогу',
  'grammar.es.a0.m09.me_duele.v1|explanation':
      'Використовуйте me duele плюс одне обмежене слово про частину тіла, щоб сказати, де болить. На рівні A0 сприймайте це як сталу корисну конструкцію.',
  'grammar.es.a0.m09.tener_fever.v1|explanation':
      'Використовуйте tengo fiebre для «у мене температура». Використовуйте tienes fiebre, щоб запитати одну людину. Це стала початкова конструкція про здоровʼя, а не повне медичне пояснення.',
  'grammar.es.a0.m09.service_requests.v1|title':
      'Прохання про медичну допомогу',
  'grammar.es.a0.m09.service_requests.v1|explanation':
      'Використовуйте necesito з одним чітким словом про медичну послугу або допомогу. Застосунок навчає мови для прохання про допомогу, а не медичних порад.',
  'es.a0.m01.l002|communicativeOutcome':
      'Використовуйте базові слова ввічливості.',
  'es.a0.m01.l002|description':
      'Використовуйте прості ввічливі слова в коротких навчальних діалогах.',
  'es.a0.m05.l035.objective.es.a0.m05.l035.primary|description':
      'Покажіть навички визначення предмета, наявності, ціни та прохання про покупку.',
  'es.a0.m06.l016.objective.es.a0.m06.l016.primary|description':
      'Читайте перші іспанські слова зі стабільними голосними, німою h і видимим наголосом.',
  'es.a0.m06.l041.objective.es.a0.m06.l041.primary|description':
      'Запитайте, яким транспортом їхати, і дайте просту пораду щодо транспорту.',
  'es.a0.m06.l036.objective.es.a0.m06.l036.primary|description':
      'Визначайте частотні види транспорту й називайте базовий спосіб пересування.',
  'es.a0.m06.l040.objective.es.a0.m06.l040.primary|description':
      'Запитайте з ¿Cómo llego...? або ¿Cómo voy...? і збережіть порядок маршруту.',
  'es.a0.m03.l017.objective.es.a0.m03.l017.primary|description':
      'Поєднуйте запитання про особисту інформацію з короткими особистими відповідями.',
  'es.a0.m03.l018.objective.es.a0.m03.l018.primary|description':
      'Поєднуйте матеріал модулів 1-3 у короткий особистий профіль.',
  'es.a0.m04.l020.objective.es.a0.m04.l020.primary|description':
      'Запитайте, хто ця людина, і назвіть її імʼя.',
  'es.a0.m04.l022.objective.es.a0.m04.l022.primary|description':
      'Запитайте, якою є людина, і дайте один базовий опис.',
  'es.a0.m04.l025.objective.es.a0.m04.l025.primary|description':
      'Запитуйте й відповідайте на базові запитання про іншу людину.',
  'es.a0.m05.l028.objective.es.a0.m05.l028.primary|description':
      'Запитайте, що це за предмет, і назвіть знайомий повсякденний предмет.',
  'es.a0.m05.l029.objective.es.a0.m05.l029.primary|description':
      'Ввічливо запитайте, чи є в магазині знайомий предмет.',
  'es.a0.m05.l030.objective.es.a0.m05.l030.primary|description':
      'Запитайте й зрозумійте просту ціну в євро.',
  'es.a0.m08.l054.objective.es.a0.m08.l054.primary|description':
      'Запитуйте й відповідайте, чи є в когось брати або сестри.',
  'es.a0.m09.l061.objective.es.a0.m09.l061.primary|description':
      'Запитуйте й відповідайте на базові запитання про стан.',
  'es.a0.m09.l063.objective.es.a0.m09.l063.primary|description':
      'Запитуйте й відповідайте на прості запитання про здоровʼя.',
  'es.a0.m09.l065.objective.es.a0.m09.l065.primary|description':
      'Попросіть повторити або говорити повільніше під час розмови про здоровʼя.',
  'es.a0.m02.l009|title': 'Практика діалогу знайомства',
  'es.a0.m03.l016|description':
      'Скажіть, якими мовами ви говорите, і позначте обмежене вміння.',
  'es.a0.m04.l022|communicativeOutcome':
      'Опишіть людину одним обмеженим прикметником.',
  'es.a0.m04.l023|title': 'Інформація про іншу людину',
  'es.a0.m04.l023|communicativeOutcome':
      'Використовуйте es, vive і habla для іншої людини.',
  'es.a0.m04.l023|description':
      'Назвіть походження, місце проживання і мову іншої людини.',
  'es.a0.m04.l024|title': 'Повсякденні запитання і відповіді',
  'es.a0.m04.l024|communicativeOutcome':
      'Запитуйте й відповідайте на базові запитання про іншу людину.',
  'es.a0.m04.l024|description':
      'Запитуйте й відповідайте на прості запитання так/ні про іншу людину.',
  'es.a0.m04.l025|title': 'Коротка повсякденна розмова',
  'es.a0.m04.l025|communicativeOutcome':
      'Підтримуйте коротку передбачувану розмову про іншу людину.',
  'es.a0.m04.l025|description':
      'Поєднайте привітання, визначення людини, роль, опис і мовні факти.',
  'es.a0.m04.l026|title': 'Повторення людей і розмови',
  'es.a0.m04.l026|communicativeOutcome':
      'Поєднайте матеріал модуля 4 з раніше вивченими фактами про особу.',
  'es.a0.m04.l026|description':
      'Повторіть людей, ролі, описи й факти у третій особі.',
  'es.a0.m04.l026.objective.es.a0.m04.l026.primary|description':
      'Поєднайте матеріал модуля 4 з раніше вивченими фактами про особу.',
  'es.a0.m04.l025.summary|reviewPrompt':
      'Підтримайте коротку передбачувану розмову про іншу людину.',
  'es.a0.m04.l026.summary|reviewPrompt':
      'Поєднайте матеріал модуля 4 з раніше вивченими фактами про особу.',
  'vocab.es.a0.m08.mesa.v1|notes':
      'Предмет удома, повторно використаний з попередньої роботи з предметами.',
  'es.a0.m04.l027|communicativeOutcome':
      'Завершіть контрольну перевірку модуля 4 про людей і повсякденну розмову.',
  'es.a0.m04.l027|description':
      'Перевірте людей, ролі, описи, факти у третій особі й короткі розмовні запитання.',
  'dialogue.es.a0.m03.identity_exchange.v1|lines.2.native_translation':
      'Де ти живеш?',
  'dialogue.es.a0.m04.languages.v1|title': 'Мови, якими говорить інша людина',
  'template.es.a0.m03.l015.origin_residence_contrast.v1|prompt_template':
      'Завдання питає «Де ти живеш?». Яка відповідь підходить?',
  'template.es.a0.m03.l018.type_review_questions.v1|prompt_template':
      'Введіть два іспанські запитання: «Де ти живеш? Якими мовами ти говориш?»',
  'grammar.es.a0.m04.roles_mi_tu.v1|title': 'Mi і tu з ролями',
  'grammar.es.a0.m04.roles_mi_tu.v1|explanation':
      'Використовуйте mi для «мій/моя» і tu для «твій/твоя». У цьому модулі зберігайте ролі короткими: mi amigo, mi amiga, tu profesor.',
  'es.a0.m05.l028|description':
      'Запитайте, що це за предмет, і назвіть знайомі повсякденні предмети.',
  'es.a0.m05.l035|communicativeOutcome':
      'Завершіть обмежену контрольну перевірку модуля 5 про покупки.',
  'es.a0.m06.l041|description':
      'Запитайте, яким транспортом їхати, і дайте просту відповідь про спосіб пересування.',
  'es.a0.m07.l048|title': 'Прості термінові потреби',
  'es.a0.m07.l048|description':
      'Попросіть лікаря, поліцію або термінову допомогу.',
  'es.a0.m07.l049|description':
      'Поєднайте привернення уваги, прохання про допомогу, запитання про службу й термінову потребу.',
  'es.a0.m08.l054|title': 'Брати, сестри і прості запитання',
  'es.a0.m08.l054|communicativeOutcome':
      'Запитуйте й відповідайте, чи має хтось братів або сестер.',
  'es.a0.m08.l054|description':
      'Запитуйте й відповідайте на обмежені запитання про братів і сестер.',
  'es.a0.m08.l058|description':
      'Запитуйте й відповідайте на обмежені запитання про сімʼю і дім.',
  'es.a0.m08.l060|communicativeOutcome':
      'Покажіть обмежене спілкування з тем модуля 8: сімʼя і дім.',
  'es.a0.m09.l062|communicativeOutcome':
      'Назвіть обмежений симптом або місце болю.',
  'es.a0.m09.l063|title': 'Прості запитання про здоровʼя',
  'es.a0.m09.l063|communicativeOutcome':
      'Запитуйте й відповідайте на обмежені запитання про здоровʼя.',
  'es.a0.m09.l064|communicativeOutcome':
      'Попросіть медичну службу й запитайте потрібне місце.',
  'es.a0.m09.l065|communicativeOutcome':
      'Попросіть повторити або говорити повільніше під час діалогу про здоровʼя.',
  'es.a0.m09.l067|communicativeOutcome':
      'Використовуйте потребу щодо здоровʼя в обмежених повсякденних ситуаціях.',
  'es.a0.m09.l068|title': 'Комплексне спілкування A0',
  'es.a0.m09.l068|description':
      'Завершіть обмежені сценарії A0, використовуючи навички з усього курсу.',
  'es.a0.m09.l070|description':
      'Перевірте здоровʼя й обмежене комплексне спілкування в модулі 9.',
  'dialogue.es.a0.c2.age_simple.v1|lines.0.native_translation':
      'Скільки тобі років?',
  'dialogue.es.a0.c2.age_simple.v1|lines.1.native_translation':
      'Мені двадцять років.',
  'dialogue.es.a0.c2.age_simple.v1|lines.3.native_translation':
      'Мені вісімнадцять років.',
  'dialogue.es.a0.c2.family_city.v1|lines.1.native_translation':
      'Моя сімʼя в Боготі.',
  'dialogue.es.a0.c2.family_city.v1|lines.2.native_translation':
      'Софія — моя подруга.',
  'dialogue.es.a0.c2.food_polite.v1|lines.2.native_translation':
      'Дякую. У тебе є хліб?',
  'dialogue.es.a0.c2.food_polite.v1|title': 'Їжа і вода',
  'dialogue.es.a0.c2.integrated_checkpoint.v1|lines.0.native_translation':
      'Привіт. Мене звати Лусія.',
  'dialogue.es.a0.c2.integrated_checkpoint.v1|lines.1.native_translation':
      'Привіт, Лусіє. Я з Києва.',
  'dialogue.es.a0.c2.integrated_checkpoint.v1|lines.2.native_translation':
      'У тебе є вода?',
  'dialogue.es.a0.c2.integrated_checkpoint.v1|title': 'Коротка перша розмова',
  'reading.es.a0.c2.age_message.v1|title': 'Повідомлення про вік',
  'reading.es.a0.c2.age_message.v1|native_translation':
      'Софії вісімнадцять років. Дієго двадцять років. Мені двадцять років.',
  'reading.es.a0.c2.numbers_eleven_twenty.v1|native_translation':
      'Одинадцять, дванадцять, тринадцять, чотирнадцять, пʼятнадцять. Шістнадцять, сімнадцять, вісімнадцять, девʼятнадцять, двадцять.',
  'reading.es.a0.m03.two_people.v1|native_translation':
      'Мене звати Дієго. Я з Колумбії. Я живу в Лімі. Мене звати Софія. Я з Іспанії. Я живу у Валенсії.',
  'reading.es.a0.m08.family_home_profile.v1|native_translation':
      'Мене звати Карлос. Я живу у квартирі. Моя сімʼя живе тут. У мене є сестра. Її звати Софія. У моєму домі є стіл і стілець.',
  'template.es.a0.c2.l022_fill_veinte.v1|prompt_template':
      'Доповніть іспанським словом зі значенням «двадцять»: «Tengo ____ años.».',
  'template.es.a0.c2.l022_type_dieciocho.v1|prompt_template':
      'Введіть іспанське слово зі значенням «вісімнадцять».',
  'template.es.a0.c2.l022_type_veinte.v1|prompt_template':
      'Введіть іспанське слово зі значенням «двадцять».',
  'template.es.a0.c2.l023_type_tengo_veinte.v1|prompt_template':
      'Введіть іспанське речення: «Мені двадцять років».',
  'template.es.a0.c2.l023_type_cuantos_anos.v1|prompt_template':
      'Введіть іспанське запитання: «Скільки тобі років?».',
  'template.es.a0.c2.l023_type_tengo_dieciocho.v1|prompt_template':
      'Введіть іспанське речення: «Мені вісімнадцять років».',
  'template.es.a0.m05.checkpoint.price_question.v1|prompt_template':
      'Контрольна перевірка: введіть іспанське запитання: «Скільки це коштує?».',
  'template.es.a0.m05.competency.shopping_exchange.v1|prompt_template':
      'Введіть дві іспанські репліки покупця: «Скільки це коштує?» і «Більше нічого, дякую».',
  'template.es.a0.m05.l029.polite_availability_choice.v1|prompt_template':
      'Виберіть ввічливе іспанське запитання для «У вас є вода?» у магазині.',
  'template.es.a0.m05.l029.type_tiene_agua.v1|prompt_template':
      'Введіть ввічливе іспанське запитання: «У вас є вода?»',
  'template.es.a0.m05.l028.type_que_es_esto.v1|prompt_template':
      'Введіть іспанське запитання: «Що це?».',
  'template.es.a0.m05.l029.availability_question_choice.v1|prompt_template':
      'Виберіть ввічливе іспанське запитання для «У вас є вода?» у магазині.',
  'template.es.a0.m05.l029.fill_tenemos.v1|prompt_template':
      'Доповніть іспанську відповідь: «Sí, ____ agua.».',
  'template.es.a0.m05.l029.type_no_tenemos_llave.v1|prompt_template':
      'Введіть іспанську відповідь: «Ні, у нас немає ключа».',
  'template.es.a0.m05.l030.fill_diez_euros.v1|prompt_template':
      'Доповніть іспанське речення за табличкою Libro: diez euros. «Cuesta ____ euros.»',
  'template.es.a0.m05.l030.price_comprehension_choice.v1|prompt_template':
      'На табличці написано «Botella: dos euros». Виберіть ціну.',
  'template.es.a0.m05.l030.price_question_choice.v1|prompt_template':
      'Виберіть іспанське запитання для «Скільки це коштує?».',
  'template.es.a0.m05.l030.type_cuanto_cuesta.v1|prompt_template':
      'Введіть іспанське запитання: «Скільки це коштує?».',
  'template.es.a0.m06.l041.type_que_transporte_tomo.v1|prompt_template':
      'Введіть іспанське запитання: «Яким транспортом мені їхати?».',
  'dialogue.es.a0.m09.integrated_help.v1|title':
      'Комплексний діалог про здоровʼя і допомогу',
  'dialogue.es.a0.m09.repair_health.v1|lines.0.native_translation':
      'У тебе температура?',
  'dialogue.es.a0.m09.repair_health.v1|lines.2.native_translation':
      'У тебе температура?',
  'dialogue.es.a0.m09.repair_health.v1|title':
      'Уточнення в запитанні про здоровʼя',
  'dialogue.es.a0.m09.symptom.v1|lines.2.native_translation':
      'У тебе температура?',
  'dialogue.es.a0.m09.symptom.v1|lines.3.native_translation':
      'Ні, у мене немає температури.',
  'reading.es.a0.m09.help_scenario.v1|title': 'Ситуація допомоги',
  'reading.es.a0.m09.pharmacy_location.v1|title': 'Де аптека',
  'reading.es.a0.m09.pharmacy_location.v1|native_translation':
      'Аптека праворуч. Лікарня поруч. Марті потрібна допомога.',
  'reading.es.a0.m09.short_transcript.v1|title': 'Короткий діалог про здоровʼя',
  'vocab.es.a0.m06.como_voy.v1|notes':
      'Використовуйте cómo voy, щоб запитати, як кудись їхати.',
};

const _pronunciationHintUkById = {
  'pronunciation.es.sound.h.v1': 'не вимовляється',
  'pronunciation.es.sound.g_e_i.v1':
      'перед e або i звучить як твердий звук, близький до «х»',
  'pronunciation.es.sound.j.v1': 'твердий звук, близький до «х»',
  'pronunciation.es.sound.ll.v1': 'звук, близький до «й»',
  'pronunciation.es.sound.y.v1': 'звук, близький до «й»',
};

const _pronunciationUk = {
  'pronunciation.es.phrase.mucho_gusto.v1|explanations':
      'У цій сталій фразі обидва слова мають власний наголос.',
  'pronunciation.es.sound.ll.v1|learnerHints': 'звук, близький до «й»',
  'pronunciation.es.sound.ll.v1|explanations':
      'll — це дві малі літери l: l + l. Не плутайте їх із двома великими літерами I. У нормі курсу це загальний звук yeísta /ʝ/.',
  'pronunciation.es.sound.y.v1|learnerHints': 'звук, близький до «й»',
  'pronunciation.es.sound.y.v1|explanations':
      'Приголосна y належить до тієї самої широкої категорії yeísta /ʝ/, що й ll у цьому курсі.',
  'pronunciation.es.word.igualmente.v1|explanations':
      'Головний наголос падає на склад «мен»: игуальме́нте.',
  'pronunciation.es.word.simpatica.v1|explanations':
      'Письмовий акцент показує наголос: симпа́тика.',
  'pronunciation.es.word.simpatico.v1|explanations':
      'Письмовий акцент показує наголос: симпа́тико.',
  'pronunciation.es.rule.b_v.v1|titles': 'b і v',
  'pronunciation.es.rule.b_v.v1|shortExplanations':
      'У цьому курсі b і v мають спільну широку категорію звука.',
  'pronunciation.es.rule.b_v.v1|detailedExplanations':
      'На рівні A0 не вимовляйте іспанську v як англійську або українську «в». У навчальній нормі курсу b і v належать до однієї широкої категорії.',
  'pronunciation.es.rule.b_v.v1|learnerHints': 'b/v — спільна категорія',
  'pronunciation.es.rule.b_v.v1|explanations':
      'У цьому курсі b і v пояснюються як спільна категорія іспанського звука.',
  'pronunciation.es.rule.c_z.v1|titles': 'c і z',
  'pronunciation.es.rule.c_z.v1|shortExplanations':
      'У цьому курсі c перед e/i та z читаються як /s/ у загальній навчальній нормі.',
  'pronunciation.es.rule.c_z.v1|detailedExplanations':
      'Перед e або i літера c у цьому курсі читається як /s/. Літера z також належить до цієї навчальної категорії.',
  'pronunciation.es.rule.c_z.v1|learnerHints': 'c/z як /s/',
  'pronunciation.es.rule.c_z.v1|explanations':
      'Курс використовує /s/ для c перед e/i та z.',
  'pronunciation.es.rule.g_e_i.v1|titles': 'g перед e та i',
  'pronunciation.es.rule.g_e_i.v1|shortExplanations':
      'Перед e та i літера g має твердий звук, близький до українського «х».',
  'pronunciation.es.rule.g_e_i.v1|detailedExplanations':
      'У словах на кшталт gente або gimnasio g перед e/i не звучить як українське «ґ». У цьому курсі пояснюємо його як твердий звук, близький до «х».',
  'pronunciation.es.rule.g_e_i.v1|learnerHints':
      'твердий звук, близький до «х»',
  'pronunciation.es.rule.g_e_i.v1|explanations':
      'Перед e/i літера g у цьому курсі звучить близько до українського «х».',
  'pronunciation.es.rule.j.v1|titles': 'j',
  'pronunciation.es.rule.j.v1|shortExplanations':
      'Іспанська j не читається як англійська j.',
  'pronunciation.es.rule.j.v1|detailedExplanations':
      'У цьому курсі іспанська j пояснюється як твердий звук, близький до українського «х».',
  'pronunciation.es.rule.j.v1|learnerHints': 'звук, близький до «х»',
  'pronunciation.es.rule.j.v1|explanations':
      'Іспанська j не читається як англійська j; у цьому курсі вона звучить близько до українського «х».',
  'pronunciation.es.rule.ll_y.v1|titles': 'll і y',
  'pronunciation.es.rule.ll_y.v1|shortExplanations':
      'll — це дві малі латинські літери «ель». У цьому курсі перед голосною вони дають звук, близький до українського «й».',
  'pronunciation.es.rule.ll_y.v1|detailedExplanations':
      'll — це дві малі літери l: l + l. Не плутайте їх із двома великими літерами I. У нормі курсу ll і приголосна y належать до широкої категорії yeísta /ʝ/. Українська підказка передає вимову приблизно.',
  'pronunciation.es.rule.ll_y.v1|learnerHints': 'близько до «й»',
  'pronunciation.es.rule.ll_y.v1|explanations':
      'У цьому курсі ll перед голосною звучить приблизно як український «й».',
  'pronunciation.es.rule.primary_stress.v1|titles': 'Письмовий наголос',
  'pronunciation.es.rule.primary_stress.v1|shortExplanations':
      'Знак наголосу показує, який склад вимовляється сильніше.',
  'pronunciation.es.rule.primary_stress.v1|detailedExplanations':
      'У підказках наголос також позначено, щоб початківець не вгадував його за написанням.',
  'pronunciation.es.rule.primary_stress.v1|learnerHints': 'наголос позначено',
  'pronunciation.es.rule.primary_stress.v1|explanations':
      'У підказках явно позначено наголошений склад.',
  'pronunciation.es.rule.diphthong_ue.v1|titles': 'Сполучення ue',
  'pronunciation.es.rule.diphthong_ue.v1|shortExplanations':
      'Літери ue читаються разом, як один плавний перехід.',
  'pronunciation.es.rule.diphthong_ue.v1|detailedExplanations':
      'У початковому читанні зʼєднуйте u та e, а не вимовляйте їх як два різко розділені склади.',
  'pronunciation.es.rule.r.v1|titles': 'Одинарна r',
  'pronunciation.es.rule.r.v1|shortExplanations':
      'Одинарна r у початкових прикладах звучить коротко, як швидкий дотик язика.',
  'pronunciation.es.rule.r.v1|detailedExplanations':
      'Вона коротша за rr і не має перетворюватися на довгий англійський r-подібний звук.',
  'pronunciation.es.rule.r.v1|articulationHints':
      'Коротко торкніться язиком ділянки за верхніми зубами.',
  'pronunciation.es.rule.rr.v1|titles': 'Подвійна rr',
  'pronunciation.es.rule.rr.v1|shortExplanations':
      'Подвійна rr сильніша й довша за одинарну r.',
  'pronunciation.es.rule.rr.v1|detailedExplanations':
      'На A0 спершу навчіться помічати: rr — не те саме, що одинарна r.',
  'pronunciation.es.rule.rr.v1|contrastNotes':
      'Порівнюйте r /ɾ/ і rr /r/ як різні правила читання.',
  'pronunciation.es.rule.silent_h.v1|titles': 'Німа літера h («аче»)',
  'pronunciation.es.rule.silent_h.v1|shortExplanations':
      'Іспанська літера h називається hache («аче»), але в словах зазвичай не вимовляється.',
  'pronunciation.es.rule.silent_h.v1|detailedExplanations':
      'Читайте слово так, ніби h немає: hola починається одразу з голосного звука. Назва літери — hache («аче»), але сама літера в таких словах мовчить.',
  'pronunciation.es.rule.silent_h.v1|learnerHints': 'h не вимовляється',
  'pronunciation.es.rule.silent_h.v1|explanations':
      'В іспанській h зазвичай пишеться, але не вимовляється.',
  'pronunciation.es.rule.stable_vowels.v1|titles': 'Стабільні голосні',
  'pronunciation.es.rule.stable_vowels.v1|shortExplanations':
      'Іспанські голосні a, e, i, o та u зазвичай звучать стабільно в різних словах.',
  'pronunciation.es.rule.stable_vowels.v1|detailedExplanations':
      'Не змінюйте іспанські голосні так сильно, як це часто підказує англійське написання.',
  'pronunciation.es.rule.stable_vowels.v1|learnerHints': 'стабільні голосні',
  'pronunciation.es.rule.stable_vowels.v1|explanations':
      'Іспанські літери голосних читаються порівняно стабільно.',
};

const _graphemePresentationUk = {
  'pronunciation.es.rule.ll_y.v1': {
    'canonicalDescription': 'Вивчаємо: ll. Це дві малі латинські літери «ель».',
    'componentLetterNames': ['ель', 'ель'],
    'confusableDescription':
        'Не плутайте з II: це дві великі латинські літери I.',
    'confusableComponentLetterNames': ['і', 'і'],
    'accessibilityDescription':
        'Дві малі латинські літери ель: ель плюс ель утворюють ll. Не плутайте з двома великими латинськими літерами I: I плюс I утворюють II.',
  },
};

const _exactUk = {
  'Spanish A0': 'Іспанська A0',
  'Hello and Goodbye': 'Привітання і прощання',
  'First Words and Reading': 'Перші слова і читання',
  'Names and Introductions': 'Імена та представлення',
  'Names': 'Імена',
  'Origin and Languages': 'Походження та мови',
  'People and Everyday Conversation': 'Люди й повсякденна розмова',
  'Shopping and Everyday Objects': 'Покупки й повсякденні предмети',
  'Transport and Directions': 'Транспорт і напрямки',
  'Asking for Help': 'Як попросити допомоги',
  'Home and Family': 'Дім і сімʼя',
  'Health and Integrated Communication': 'Здоровʼя та інтегрована комунікація',
  'Vocabulary': 'Лексика',
  'Grammar': 'Граматика',
  'Practice': 'Практика',
  'Pattern': 'Конструкція',
  'Usage': 'Уживання',
  'Transport': 'Транспорт',
  'Reading': 'Читання',
  'Dialogue': 'Діалог',
  'Review': 'Повторення',
  'Checkpoint': 'Контрольна перевірка',
  'Correct': 'Правильно',
  'Incorrect': 'Поки що неправильно',
  'Recommended answer': 'Рекомендована відповідь',
  'Accepted with correction': 'Прийнято з виправленням',
  'Mastered': 'Засвоєно',
  'Age': 'Вік',
  'Age Message': 'Повідомлення про вік',
  'How old are you?': 'Скільки тобі років?',
  'I am twenty years old.': 'Мені двадцять років.',
  'I am eighteen years old.': 'Мені вісімнадцять років.',
  'Food and Water': 'Їжа і вода',
  'A Short First Conversation': 'Коротка перша розмова',
  'Family and City': 'Сімʼя і місто',
  'My family is in Bogota.': 'Моя сімʼя в Боготі.',
  'Sofia is my friend.': 'Софія — моя подруга.',
  'Thank you. Do you have bread?': 'Дякую. У тебе є хліб?',
  'Hello. My name is Lucia.': 'Привіт. Мене звати Лусія.',
  'Hello, Lucia. I am from Kyiv.': 'Привіт, Лусіє. Я з Києва.',
  'Do you have water?': 'У тебе є вода?',
  'How much does it cost?': 'Скільки це коштує?',
  'hello': 'привіт',
  'goodbye': 'до побачення',
  'please': 'будь ласка',
  'thank you': 'дякую',
  'yes': 'так',
  'no': 'ні',
  'I do not understand': 'я не розумію',
  "I don't understand": 'я не розумію',
  'Repeat, please.': 'Повторіть, будь ласка.',
  'Nice to meet you.': 'Приємно познайомитися.',
};

const _titleUk = {
  'Afternoon Origin': 'Походження у денній розмові',
  'Age': 'Вік',
  'Clarification in Class': 'Уточнення на уроці',
  'Profile Cards': 'Картки профілів',
  'Silent h and Stable Vowels': 'Німа h і сталі голосні',
  'Silent h': 'Німа h',
  'Stable Vowels': 'Сталі голосні',
  'Written Stress': 'Письмовий наголос',
  'Single r': 'Одинарна r',
  'c and z': 'c і z',
  'b and v': 'b і v',
  'The ue Combination': 'Сполучення ue',
  'g before e and i': 'g перед e та i',
  'ñ, j and ll in names': 'ñ, j і ll в іменах',
  'Ñ, j и ll в именах': 'Ñ, j і ll в іменах',
  'Morning and Evening Greetings': 'Ранкові та вечірні привітання',
  'Morning and Evening': 'Ранок і вечір',
  'Review First Words': 'Повторення перших слів',
  'First Words Review': 'Повторення перших слів',
  'Name Sounds': 'Звуки в іменах',
  'Names sounds': 'Звуки в іменах',
};

const _vocabularyUk = {
  'hello': 'привіт',
  'goodbye': 'до побачення',
  'see you later': 'до зустрічі',
  'good morning': 'доброго ранку',
  'good afternoon': 'добрий день',
  'good evening': 'добрий вечір',
  'good night': 'добраніч',
  'thank you': 'дякую',
  'thanks': 'дякую',
  'please': 'будь ласка',
  'sorry': 'вибачте',
  'yes': 'так',
  'no': 'ні',
  'spanish': 'іспанська / іспанський',
  'english': 'англійська / англійський',
  'hunger': 'голод',
  'buenos aires': 'Буенос-Айрес',
  'how many': 'скільки',
  'i am': 'я є / я перебуваю',
  'i want': 'я хочу',
  'reason; right': 'причина; рація',
  'a; one': 'один / одна; неозначений артикль',
  'i am hungry': 'я голодний / голодна',
  'i need': 'мені потрібно',
  'means': 'означає',
  'he/she has': 'у нього / неї є',
  'your': 'твій / твоя',
  'to have': 'мати',
  'he/she has; you have': 'у нього / неї є; у вас є',
  'you are right': 'ти маєш рацію',
  'nice to meet you': 'приємно познайомитися',
  'you speak': 'ти говориш',
  'you live': 'ти живеш',
  'here you are': 'ось, будь ласка',
  'they are / it is (price total)': 'вони є / це становить (загальна ціна)',
  'we have': 'у нас є',
  'do you have / has (polite fixed shopping form)':
      'у вас є / має (стала ввічлива форма для покупок)',
  'i need help': 'мені потрібна допомога',
  'can you / can he or she': 'можете ви / може він або вона',
  'there is / there are': 'є / знаходиться',
  'you are': 'ти є',
  'do you speak spanish?': 'ти говориш іспанською?',
  'how are things?': 'як справи?',
  'you': 'ти',
  'name': 'імʼя',
  'my name is': 'мене звати',
  'what is your name?': 'як тебе звати?',
  'where are you from?': 'звідки ти?',
  'i am from': 'я з',
  'i live in': 'я живу в',
  'i speak': 'я говорю',
  'a little': 'трохи',
  'friend': 'друг',
  'teacher': 'вчитель',
  'student': 'студент',
  'tall (feminine)': 'висока',
  'tall (masculine)': 'високий',
  'female friend': 'подруга',
  'male friend': 'друг',
  'girl / young woman': 'дівчина',
  'boy / young man': 'хлопець / юнак',
  'female classmate / colleague': 'однокласниця / колега-жінка',
  'male classmate / colleague': 'однокласник / колега-чоловік',
  'is / he is / she is': 'є / він є / вона є',
  'is not': 'не є',
  'male teacher': 'вчитель',
  'female teacher': 'вчителька',
  'serious (feminine)': 'серйозна',
  'serious (masculine)': 'серйозний',
  'nice / friendly (feminine)': 'приємна / дружня',
  'nice / friendly (masculine)': 'приємний / дружній',
  'book': 'книжка',
  'bag': 'сумка',
  'bottle': 'пляшка',
  'table': 'стіл',
  'chair': 'стілець',
  'key': 'ключ',
  'anything else': 'ще щось',
  'cheap (feminine)': 'дешева',
  'cheap (masculine)': 'дешевий',
  'expensive (feminine)': 'дорога',
  'expensive (masculine)': 'дорогий',
  'it costs': 'це коштує',
  'this (feminine)': 'ця',
  'this (masculine)': 'цей',
  'this / this thing': 'це / ця річ',
  'nothing else': 'більше нічого',
  'one / a (feminine)': 'одна / неозначений артикль жіночого роду',
  'water': 'вода',
  'bread': 'хліб',
  'coffee': 'кава',
  'bus': 'автобус',
  'bicycle': 'велосипед',
  'car': 'машина',
  'transport': 'транспорт',
  'stop': 'зупинка',
  'bus or transport stop': 'автобусна або транспортна зупинка',
  'continue / go straight': 'продовжуйте / ідіть прямо',
  'supermarket': 'супермаркет',
  'take (command)': 'сідай / сідайте на транспорт',
  'go (command)': 'іди / їдь',
  'i go / i am going': 'я йду / я їду',
  'train': 'потяг',
  'metro': 'метро',
  'metro / subway': 'метро',
  'taxi': 'таксі',
  'left': 'ліворуч',
  'right': 'праворуч',
  'straight': 'прямо',
  'near': 'близько',
  'far': 'далеко',
  'on foot': 'пішки',
  'center / downtown': 'центр / центр міста',
  'how do i get': 'як мені дістатися',
  'how do i go': 'як мені їхати',
  'help': 'допомога',
  'help me': 'допоможіть мені',
  'bathroom / toilet': 'туалет',
  'of course / sure': 'звісно',
  'excuse me / pardon me': 'вибачте',
  'emergency': 'екстрена ситуація',
  'wait / please wait': 'зачекайте / будь ласка, зачекайте',
  'speak more slowly': 'говоріть повільніше',
  'call': 'покличте / зателефонуйте',
  'i don\'t know': 'я не знаю',
  'excuse me / listen': 'вибачте / послухайте',
  'police': 'поліція',
  'service': 'служба / послуга',
  'an emergency': 'екстрена ситуація',
  'doctor': 'лікар',
  'hospital': 'лікарня',
  'pharmacy': 'аптека',
  'home': 'дім',
  'family': 'сімʼя',
  'mother': 'мати',
  'grandmother': 'бабуся',
  'grandfather': 'дідусь',
  'next to': 'поруч із',
  'father': 'батько',
  'brother': 'брат',
  'sister': 'сестра',
  'room': 'кімната',
  'house / home': 'дім / оселя',
  'kitchen': 'кухня',
  'bedroom': 'спальня',
  'living room': 'вітальня',
  'brothers or siblings': 'брати або брати й сестри',
  'daughter': 'донька',
  'son': 'син',
  'apartment / flat': 'квартира',
  'door': 'двері',
  'window': 'вікно',
  'bathroom': 'ванна кімната',
  'is located / is': 'розташований / є',
  'my, plural': 'мої',
  'head': 'голова',
  'rest': 'відпочинок',
  'pain': 'біль',
  'sick, feminine': 'хвора',
  'sick, masculine': 'хворий',
  'stomach': 'живіт',
  'i feel bad / i am unwell': 'мені недобре',
  'so-so': 'так собі',
  'you\'re welcome': 'будь ласка / нема за що',
  'more slowly': 'повільніше',
  'okay; not great': 'нормально; не дуже добре',
  'mr.; sir': 'пан; сеньйор',
  'mrs.; ma\'am': 'пані; сеньйора',
};

const _optionUk = {
  'hello': 'привіт',
  'goodbye': 'до побачення',
  'please': 'будь ласка',
  'thank you': 'дякую',
  'thanks': 'дякую',
  'yes': 'так',
  'no': 'ні',
  'i do not understand': 'я не розумію',
  "i don't understand": 'я не розумію',
  'repeat': 'повторіть',
  'question': 'запитання',
  'answer': 'відповідь',
  'statement': 'твердження',
  'near': 'близько',
  'far': 'далеко',
  'left': 'ліворуч',
  'right': 'праворуч',
};

const _embeddedUk = {
  'hello': 'привіт',
  'goodbye': 'до побачення',
  'good morning': 'доброго ранку',
  'good afternoon': 'добрий день',
  'good evening': 'добрий вечір',
  'good night': 'добраніч',
  'thank you': 'дякую',
  'thanks': 'дякую',
  'please': 'будь ласка',
  'sorry': 'вибачте',
  'repeat': 'повторіть',
  'slower': 'повільніше',
  'i do not understand': 'я не розумію',
  "i don't understand": 'я не розумію',
  'what is your name?': 'як тебе звати?',
  'where are you from?': 'звідки ти?',
  'where do you live?': 'де ти живеш?',
  'how are you?': 'як ти?',
  'how do I get to the hotel?': 'як дістатися до готелю?',
  'how old are you?': 'скільки тобі років?',
  'what does hola mean?': 'що означає hola?',
  'where is the book?': 'де книжка?',
  'i have two books.': 'у мене є дві книжки.',
  'i have a key.': 'у мене є ключ.',
  'i have a phone.': 'у мене є телефон.',
  'i have bread and cheese.': 'у мене є хліб і сир.',
  'i am from kyiv.': 'я з Києва.',
  'my name is lucía.': 'мене звати Lucía.',
  'sofia has coffee.': 'у Софії є кава.',
  'sofía has coffee.': 'у Софії є кава.',
  'sofía is my friend.': 'Sofía — моя подруга.',
  'do you have a book?': 'у тебе є книжка?',
  'years': 'роки',
  'years / years old': 'роки',
  'spain': 'Іспанія',
  'cheese': 'сир',
  'two': 'два',
  'the silent h': 'німого h',
  'its silent h': 'німим h',
  'what': 'що',
  'five': 'пʼять',
  'zero': 'нуль',
  'twenty': 'двадцять',
  'eighteen': 'вісімнадцять',
  'eleven': 'одинадцять',
  'twelve': 'дванадцять',
  'thirteen': 'тринадцять',
  'fourteen': 'чотирнадцять',
  'fifteen': 'пʼятнадцять',
  'sixteen': 'шістнадцять',
  'seventeen': 'сімнадцять',
  'nineteen': 'девʼятнадцять',
  'two zero five eight': 'два нуль пʼять вісім',
  'argentina': 'Аргентина',
  'barcelona': 'Барселона',
  'bogota': 'Богота',
  'chile': 'Чилі',
  'colombia': 'Колумбія',
  'kyiv': 'Київ',
  'lima': 'Ліма',
  'lucia': 'Лусія',
  'luis': 'Луїс',
  'madrid': 'Мадрид',
  'mexican': 'мексиканець / мексиканка',
  'mexico': 'Мексика',
  'peru': 'Перу',
  'sofia': 'Софія',
  'ukraine': 'Україна',
  'valencia': 'Валенсія',
  'the city name "bogota"': 'назви міста «Богота»',
  'the "i have"': '«я маю»',
  '"i have"': '«я маю»',
  'for age': 'для віку',
  'for the spoken number': 'для названого числа',
  'i have': 'я маю',
  'he/she/name': 'він/вона/імʼя',
  'you have': 'ти маєш',
  'where': 'де',
  'from': 'з',
  'live': 'жити',
  'lives': 'живе',
  'speak': 'говорити',
  'speaks': 'говорить',
  'english': 'англійською',
  'ukrainian': 'українською',
  'russian': 'російською',
  'which': 'якими',
  'who': 'хто',
  'does': '',
  'mean': 'означає',
  'city': 'місто',
  'the city': 'міста',
  'for': 'для',
  'the': '',
  'that': 'яка',
  'identifies': 'визначає',
  'person': 'особу',
  'profile': 'профілю',
  'this profile': 'цього профілю',
  'unknown': 'незнайомий',
  'somewhere': 'кудись',
  'places': 'місця',
  'combinations': 'комбінації',
  'practical': 'практичні',
  'customer line': 'репліки покупця',
  'closing response': 'завершальної відповіді',
  'opening': 'початкову репліку',
  'sequence': 'послідовність речень',
  'sentence sequence': 'послідовність речень',
  'sentence lines': 'рядки речень',
  'lines': 'рядки',
  'in this order': 'у такому порядку',
  'the short conversation': 'короткої розмови',
  'short conversation': 'короткої розмови',
  'request': 'прохання',
  'to': 'до',
  'checkpoint': 'контрольної перевірки',
  'about': 'про',
  'fictional': 'вигаданого',
  'grandmother': 'бабуся',
  'bed': 'ліжко',
  'bedroom': 'спальня',
  'kitchen': 'кухня',
  'living room': 'вітальня',
  'siblings': 'брати або сестри',
  'female doctor': 'лікарка',
  'police': 'поліція',
  'not well': 'недобре',
  'get attention': 'приверніть увагу',
  'say': 'скажіть',
  'ask': 'запитайте',
  'as': 'як',
  'then': 'потім',
  'speech': 'мовлення',
  'slower speech': 'повільніше мовлення',
  'how to get to the hospital': 'як дістатися до лікарні',
  'well': 'добре',
  'wrong': 'не так',
  'sick': 'хворіє',
  'needs': 'потребує',
  'i am from ukraine': 'я з України',
  'i am from peru': 'я з Перу',
  'my name is': 'мене звати',
  'book': 'книжка',
  'bag': 'сумка',
  'bottle': 'пляшка',
  'table': 'стіл',
  'chair': 'стілець',
  'key': 'ключ',
  'water': 'вода',
  'bread': 'хліб',
  'coffee': 'кава',
  'bus': 'автобус',
  'train': 'потяг',
  'metro': 'метро',
  'taxi': 'таксі',
  'help': 'допомога',
  'doctor': 'лікар',
  'hospital': 'лікарня',
  'pharmacy': 'аптека',
  'home': 'дім',
  'family': 'сімʼя',
  'mother': 'мати',
  'father': 'батько',
  'brother': 'брат',
  'sister': 'сестра',
  'question': 'запитання',
  'answer': 'відповідь',
  'statement': 'твердження',
  'sentence': 'речення',
  'word': 'слово',
  'phrase': 'фразу',
  'meaning': 'значення',
  'translation': 'переклад',
  'name': 'імʼя',
  'origin': 'походження',
  'language': 'мову',
  'location': 'місце',
  'with one sentence': 'одним реченням',
  'from memory': 'з памʼяті',
  'in Spanish': 'іспанською',
  'Spanish': 'іспанську',
  'the Spanish': 'іспанську',
  'the question': 'запитання',
  'the answer': 'відповідь',
  'the sentence': 'речення',
  'and': 'і',
  'with': 'з',
  'its accent': 'з наголосом',
};

const _ruPhraseToUk = {
  'Испанский A0': 'Іспанська A0',
  'испанский A0': 'іспанська A0',
  'Первые слова и чтение': 'Перші слова і читання',
  'Приветствие и прощание': 'Привітання і прощання',
  'Привет. Меня зовут': 'Привіт. Мене звати',
  'Привет, Ана': 'Привіт, Ана',
  'Привет, Луис': 'Привіт, Луис',
  'Привет, Лусия': 'Привіт, Лусія',
  'Привет, Марта': 'Привіт, Марта',
  'Привет, Карлос': 'Привіт, Карлос',
  'Да.': 'Так.',
  'Да': 'Так',
  'Да, конечно.': 'Так, звісно.',
  'Нормально.': 'Нормально.',
  'Так себе.': 'Так собі.',
  'Два ноль пять восемь.': 'Два нуль пʼять вісім.',
  'Сколько тебе лет?': 'Скільки тобі років?',
  'Сколько это стоит?': 'Скільки це коштує?',
  'Мне двадцать лет.': 'Мені двадцять років.',
  'Мне восемнадцать лет.': 'Мені вісімнадцять років.',
  'восемнадцать': 'вісімнадцять',
  'двадцать': 'двадцять',
  'одиннадцать': 'одинадцять',
  'двенадцать': 'дванадцять',
  'тринадцать': 'тринадцять',
  'четырнадцать': 'чотирнадцять',
  'пятнадцать': 'пʼятнадцять',
  'шестнадцать': 'шістнадцять',
  'семнадцать': 'сімнадцять',
  'девятнадцать': 'девʼятнадцять',
  'София': 'Софія',
  'Софии': 'Софії',
  'Лусия': 'Лусія',
  'Луис': 'Луїс',
  'Луису': 'Луїсу',
  'Диего': 'Дієго',
  'Колумбия': 'Колумбія',
  'Валенсия': 'Валенсія',
  'Боготе': 'Боготі',
  'Киева': 'Києва',
  'Київа': 'Києва',
  'Еда': 'Їжа',
  'Разговор': 'Розмова',
  'покупатель': 'покупця',
  'unknown': 'незнайомий',
  'somewhere': 'кудись',
  'places': 'місця',
  'practical': 'практичні',
  'combinations': 'комбінації',
  'integration': 'інтеграція',
  'ordered': 'упорядкований',
  'follow': 'дотримуйтеся',
  'Правило чтения': 'Правило читання',
  'правило чтения': 'правило читання',
  'Телефон число': 'Номер телефону',
  'Обмен личной информацией': 'Обмін особистою інформацією',
  'Походження, место проживания і язики': 'Походження, місце проживання і мови',
  'Короткий повседневний обмен репликами': 'Короткий повсякденний діалог',
  'Язики другой человек говорит': 'Мови, якими говорить інша людина',
  'Запитання о человек': 'Запитання про людину',
  'Короткий короткий покупка': 'Коротка покупка',
  'Садитесь на автобус.': 'Сідайте на автобус.',
  'Я еду на метро.': 'Я їду на метро.',
  'Да. Медленнее.': 'Так. Повільніше.',
  'Ви можете мені помочь?': 'Ви можете мені допомогти?',
  'У тобі є братья і сйостри?': 'У тебе є брати або сестри?',
  'У тобі є брати і сйостри?': 'У тебе є брати або сестри?',
  'Немає, I не иметь братья і сйостри.': 'Ні, у мене немає братів і сестер.',
  'Немає, I не иметь брати і сйостри.': 'Ні, у мене немає братів і сестер.',
  'А твоя мама?': 'А твоя мама?',
  'Человек дома': 'Людина вдома',
  'Запитання о братья і сйостри': 'Запитання про братів і сестер',
  'Запитання о брати і сйостри': 'Запитання про братів і сестер',
  'Комплексная ситуация A0': 'Комплексна ситуація A0',
  'Да. Що случилось?': 'Так. Що сталося?',
  'Що случилось?': 'Що сталося?',
  'У тебя температура?': 'У тебе температура?',
  'Аптека рядом.': 'Аптека поруч.',
  'Нужна служба': 'Потрібна служба',
  'Меня зовут': 'Мене звати',
  'У меня есть': 'У мене є',
  'У тебя есть': 'У тебе є',
  'Как дела': 'Як справи',
  'как дела': 'як справи',
  'Буква ñ передаёт отдельный испанский звук, близкий к «нь».':
      'Літера ñ передає окремий іспанський звук, близький до «нь».',
  'Буква h в этих испанских формах не произносится.':
      'Літера h у цих іспанських формах не вимовляється.',
  'В этом курсе c перед e/i и z читаются как /s/ в общей учебной норме.':
      'У цьому курсі c перед e/i та z читаються як /s/ у загальній навчальній нормі.',
  'В норме курса ll и согласная y относятся к общей yeísta-категории /ʝ/; русская подсказка приблизительная.':
      'У нормі курсу ll і приголосна y належать до загальної категорії yeísta /ʝ/; українська підказка приблизна.',
  'Согласная y относится к той же общей yeísta-категории /ʝ/, что и ll в этом курсе.':
      'Приголосна y належить до тієї самої загальної категорії yeísta /ʝ/, що й ll у цьому курсі.',
  'До встречи': 'До зустрічі',
  'до встречи': 'до зустрічі',
  'большое спасибо': 'дуже дякую',
  'Большое спасибо': 'Дуже дякую',
  'Больше ничего': 'Більше нічого',
  'больше ничего': 'більше нічого',
  'добраться к отель': 'дістатися до готелю',
  'добраться к отелю': 'дістатися до готелю',
  'Пожалуйста': 'Будь ласка',
  'пожалуйста': 'будь ласка',
  'Добрый день': 'Добрий день',
  'Доброе утро': 'Доброго ранку',
  'Добрый вечер': 'Добрий вечір',
  'до свидания': 'до побачення',
  'До свидания': 'До побачення',
  'приятно познакомиться': 'приємно познайомитися',
  'Приятно познакомиться': 'Приємно познайомитися',
  'Извините': 'Вибачте',
  'извините': 'вибачте',
  'Спасибо': 'Дякую',
  'спасибо': 'дякую',
  'Простое приветствие': 'Просте привітання',
  'простое приветствие': 'просте привітання',
  'Простое описание': 'Простий опис',
  'простое описание': 'простий опис',
  'можно использовать': 'можна використовувати',
  'в любое время дня': 'будь-коли протягом дня',
  'в любое время': 'будь-коли',
  'начинаем': 'починаємо',
  'В написании': 'На письмі',
  'в написании': 'на письмі',
  'всё равно': 'усе одно',
  'всйо равно': 'усе одно',
  'сохраняется': 'зберігається',
  'Привет': 'Привіт',
  'привет': 'привіт',
  'я не понимаю': 'я не розумію',
  'Я не понимаю': 'Я не розумію',
  'на уроке': 'на уроці',
  'в этом курсе': 'у цьому курсі',
  'В этом курсе': 'У цьому курсі',
  'общей учебной норме': 'загальній навчальній нормі',
  'русская подсказка': 'українська підказка',
  'Русская подсказка': 'Українська підказка',
  'русский': 'український',
  'русского': 'українського',
  'русскому': 'українському',
  'русским': 'українським',
  'русскую': 'українську',
  'русской': 'українській',
  'английский': 'англійський',
  'английского': 'англійського',
  'английскому': 'англійському',
  'как в английском': 'як в англійському',
  'для новичка': 'для початківця',
  'для новичков': 'для початківців',
  'согласная y': 'приголосна y',
  'строчные буквы': 'малі літери',
  'заглавными буквами': 'великими літерами',
  'знак ударения': 'знак наголосу',
  'письменный акцент': 'письмовий наголос',
  'главное ударение': 'головний наголос',
  'немая h': 'німа h',
  'Немая h': 'Німа h',
  'немой h': 'німого h',
  'Утренние и вечерние приветствия': 'Ранкові та вечірні привітання',
  'утренние и вечерние приветствия': 'ранкові та вечірні привітання',
  'Повторение первых слов': 'Повторення перших слів',
  'повторение первых слов': 'повторення перших слів',
  'Звуки в именах': 'Звуки в іменах',
  'звуки в именах': 'звуки в іменах',
  'ñ, j и ll в именах': 'ñ, j і ll в іменах',
  'Распознавайте ñ, j и ll': 'Розпізнавайте ñ, j і ll',
  'Начальная h': 'Початкова h',
  'начальная h': 'початкова h',
  'не произносится': 'не вимовляється',
  'обычно пишется': 'зазвичай пишеться',
  'обично пишется': 'зазвичай пишеться',
  'как будто': 'ніби',
  'сочетание ue': 'сполучення ue',
  'гласного звука': 'голосного звука',
  'гласные': 'голосні',
  'устойчивые гласные': 'стабільні голосні',
  'Устойчивые гласные': 'Стабільні голосні',
  'читаем примерно': 'читаємо приблизно',
  'читается как': 'читається як',
  'читаются как': 'читаються як',
  'перед e/i': 'перед e/i',
  'мягкий носовой звук': 'мʼякий носовий звук',
  'х-подобный звук': 'звук, близький до українського «х»',
  'твёрдый х-подобный звук': 'твердий звук, близький до українського «х»',
  'примерно передаётся': 'приблизно передається',
  'приблизительная': 'приблизна',
  'приблизительный': 'приблизний',
  'короткая': 'коротка',
  'короткий': 'короткий',
  'Спросите': 'Запитайте',
  'спросите': 'запитайте',
  'Скажите': 'Скажіть',
  'скажите': 'скажіть',
  'Садитесь': 'Сідайте',
  'возьми / сядь на': 'сядь на',
  'возьмите / сядьте на': 'сядьте на',
  'пешком': 'пішки',
  'или': 'або',
  'место проживания': 'місце проживання',
  'место': 'місце',
  'язики': 'мови',
  'язике': 'мові',
  'языки': 'мови',
  'другой человек': 'інша людина',
  'другой': 'інший',
  'человек': 'людина',
  'повседневный': 'повсякденний',
  'Повседневный': 'Повсякденний',
  'повседневний': 'повсякденний',
  'разговор': 'розмова',
  'обмен репликами': 'діалог',
  'обмен': 'обмін',
  'репликами': 'репліками',
  'простой': 'простий',
  'простые': 'прості',
  'Простые': 'Прості',
  'срочные': 'термінові',
  'срочный': 'терміновий',
  'Простой': 'Простий',
  'направления': 'напрямки',
  'до готель': 'до готелю',
  'братья і сйостри': 'брати або сестри',
  'сйостри': 'сестри',
  'братья': 'брати',
  'помочь': 'допомогти',
  'случилось': 'сталося',
  'рядом': 'поруч',
  'Нужна': 'Потрібна',
  'нужна': 'потрібна',
  'конструкция': 'конструкція',
  'конструкции': 'конструкції',
  'третьего лица': 'третьої особи',
  'отрицательний': 'заперечній',
  'глагол': 'дієслово',
  'нужним знаком ударения': 'потрібним знаком наголосу',
  'нужний': 'потрібний',
  'нужный': 'потрібний',
  'нужное': 'потрібне',
  'местоположение': 'місце',
  'Местоположение': 'Місце',
  'буквой': 'літерою',
  'ограниченний': 'обмежений',
  'ограниченный': 'обмежений',
  'Ограниченный': 'Обмежений',
  'ограниченная': 'обмежена',
  'Ограниченная': 'Обмежена',
  'составляйте': 'складайте',
  'Составляйте': 'Складайте',
  'известный': 'відомий',
  'известные': 'відомі',
  'проверьте': 'перевірте',
  'Проверьте': 'Перевірте',
  'комплексное общение': 'комплексне спілкування',
  'здоровье': 'здоровʼя',
  'используя': 'використовуючи',
  'навыки': 'навички',
  'весь курс': 'усього курсу',
  'умение': 'уміння',
  'есть ли': 'чи є',
  'є ли': 'чи',
  'диагностический': 'діагностика',
  'Диагностический': 'Діагностика',
  'определите': 'визначте',
  'Определите': 'Визначте',
  'когда': 'коли',
  'цена': 'ціна',
  'ученик': 'учень',
  'учительница': 'вчителька',
  'поверните налево': 'поверніть ліворуч',
  'поверните направо': 'поверніть праворуч',
  'идти прямо': 'іти прямо',
  'Задания контрольной проверки': 'Завдання контрольної перевірки',
  'Карандаш': 'Олівець',
  'евро': 'євро',
  'цен': 'цін',
  'заметка': 'нотатка',
  'Заметка': 'Нотатка',
  'Улица': 'Вулиця',
  'улица': 'вулиця',
  'Направление': 'Напрямок',
  'направление': 'напрямок',
  'мужского рода': 'чоловічого роду',
  'женского рода': 'жіночого роду',
  'Множественное число': 'Множина',
  'множественное число': 'множина',
  'множественное': 'множина',
  'единственное': 'однина',
  'только': 'тільки',
  'по роду': 'за родом',
  'медленнее речь': 'повільніше мовлення',
  'while помогая': 'під час допомоги',
  'кто-то': 'хтось',
  'дайте': 'дати',
  'Productive': 'Продуктивний',
  'body': 'частина тіла',
  'личная информация': 'особиста інформація',
  'личной информацией': 'особистою інформацією',
  'личний': 'особовий',
  'личный': 'особовий',
  'вопроси': 'запитання',
  'вопросы': 'запитання',
  'ответи': 'відповіді',
  'ответы': 'відповіді',
  'сохраняйте': 'зберігайте',
  'Сохраняйте': 'Зберігайте',
  'понимаете': 'розумійте',
  'Понимаете': 'Розумійте',
  'использует': 'використовує',
  'Использует': 'Використовує',
  'используется': 'використовується',
  'Используется': 'Використовується',
  'опускает': 'пропускає',
  'говорит': 'говорить',
  'говорить': 'говорити',
  'говорить о': 'говорити про',
  'стоит': 'коштує',
  'сколько': 'скільки',
  'Сколько': 'Скільки',
  'имеет': 'має',
  'имеют': 'мають',
  'тебя': 'тебе',
  'тобі': 'тебе',
  'у тебя': 'у тебе',
  'У тебя': 'У тебе',
  'у тобі': 'у тебе',
  'У тобі': 'У тебе',
  'живёт': 'живе',
  'живйот': 'живе',
  'Лиме': 'Лімі',
  'Лима': 'Ліма',
  'Киев': 'Київ',
  'личний профиль': 'особистий профіль',
  'профиль': 'профіль',
  'материал': 'матеріал',
  'модуль': 'модуль',
  'Recombine': 'Поєднайте',
  'свідомо': 'свідомо',
};

const _ruWordToUk = {
  'первый': 'перший',
  'первого': 'першого',
  'первую': 'першу',
  'первой': 'першій',
  'информация': 'інформація',
  'другом': 'іншому',
  'человеке': 'людині',
  'человека': 'людини',
  'лучший': 'найкращий',
  'лучшая': 'найкраща',
  'реплика': 'репліка',
  'реплику': 'репліку',
  'следует': 'слід',
  'после': 'після',
  'если': 'якщо',
  'почему': 'чому',
  'спросить': 'запитати',
  'спрашивает': 'запитує',
  'сказать': 'сказати',
  'являются': 'є',
  'является': 'є',
  'текущее': 'поточне',
  'дружелюбный': 'дружній',
  'дружелюбний': 'дружній',
  'представление': 'представлення',
  'уровне': 'рівні',
  'изучите': 'вивчіть',
  'эти': 'ці',
  'ети': 'ці',
  'контакта': 'контакту',
  'наличие': 'наявність',
  'просьбы': 'прохання',
  'просьби': 'прохання',
  'вспомните': 'пригадайте',
  'полезный': 'корисне',
  'полезний': 'корисне',
  'некоторые': 'деякі',
  'некоторие': 'деякі',
  'выражения': 'вирази',
  'отработанные': 'відпрацьовані',
  'отработанние': 'відпрацьовані',
  'итог': 'підсумок',
  'также': 'також',
  'поездка': 'їхати',
  'поездку': 'поїздку',
  'нужно': 'потрібно',
  'нужен': 'потрібен',
  'нужна': 'потрібна',
  'нужны': 'потрібні',
  'полиция': 'поліція',
  'ситуация': 'ситуація',
  'экстренная': 'екстрена',
  'общение': 'спілкування',
  'исправление': 'виправлення',
  'соедините': 'поєднайте',
  'прав': 'правий',
  'живот': 'живіт',
  'выберите': 'виберіть',
  'выбери': 'вибери',
  'введите': 'введіть',
  'напишите': 'напишіть',
  'дополните': 'доповніть',
  'ответьте': 'дайте відповідь',
  'повторите': 'повторіть',
  'значение': 'значення',
  'фразы': 'фрази',
  'фраза': 'фраза',
  'слова': 'слова',
  'слово': 'слово',
  'предложение': 'речення',
  'предложения': 'речення',
  'вопрос': 'запитання',
  'вопроса': 'запитання',
  'ответ': 'відповідь',
  'ответа': 'відповіді',
  'фразой': 'фразою',
  'фразе': 'фразі',
  'утверждение': 'твердження',
  'имя': 'імʼя',
  'имени': 'імені',
  'меня': 'мене',
  'зовут': 'звати',
  'есть': 'є',
  'у': 'у',
  'происхождение': 'походження',
  'возраст': 'вік',
  'лет': 'років',
  'мне': 'мені',
  'тебе': 'тобі',
  'ты': 'ти',
  'вы': 'ви',
  'я': 'я',
  'он': 'він',
  'она': 'вона',
  'мы': 'ми',
  'они': 'вони',
  'мой': 'мій',
  'моя': 'моя',
  'моё': 'моє',
  'твой': 'твій',
  'твоя': 'твоя',
  'где': 'де',
  'откуда': 'звідки',
  'как': 'як',
  'что': 'що',
  'кто': 'хто',
  'какой': 'який',
  'какая': 'яка',
  'какое': 'яке',
  'близко': 'близько',
  'далеко': 'далеко',
  'слева': 'ліворуч',
  'справа': 'праворуч',
  'прямо': 'прямо',
  'дом': 'дім',
  'семья': 'сімʼя',
  'мама': 'мама',
  'мать': 'мати',
  'отец': 'батько',
  'брат': 'брат',
  'сестра': 'сестра',
  'комната': 'кімната',
  'кухня': 'кухня',
  'ванная': 'ванна',
  'помощь': 'допомога',
  'врач': 'лікар',
  'больница': 'лікарня',
  'аптека': 'аптека',
  'книга': 'книжка',
  'сумка': 'сумка',
  'бутылка': 'пляшка',
  'стол': 'стіл',
  'стул': 'стілець',
  'ключ': 'ключ',
  'вода': 'вода',
  'хлеб': 'хліб',
  'кофе': 'кава',
  'автобус': 'автобус',
  'поезд': 'потяг',
  'метро': 'метро',
  'такси': 'таксі',
  'хорошо': 'добре',
  'добре': 'добре',
  'плохо': 'погано',
  'голоден': 'голодний',
  'голодна': 'голодна',
  'ничего': 'нічого',
  'больше': 'більше',
  'встречи': 'зустрічі',
  'встреча': 'зустріч',
  'дела': 'справи',
  'добраться': 'дістатися',
  'отель': 'готель',
  'отеля': 'готелю',
  'отелю': 'готелю',
  'к': 'до',
  'из': 'з',
  'немного': 'трохи',
  'очень': 'дуже',
  'здесь': 'тут',
  'там': 'там',
  'сейчас': 'зараз',
  'урок': 'урок',
  'урока': 'уроку',
  'модуль': 'модуль',
  'повторение': 'повторення',
  'проверка': 'перевірка',
  'контрольная': 'контрольна',
  'навыка': 'навички',
  'навык': 'навичка',
  'лексика': 'лексика',
  'грамматика': 'граматика',
  'диалог': 'діалог',
  'чтение': 'читання',
  'практика': 'практика',
  'пример': 'приклад',
  'примеры': 'приклади',
  'обратите': 'зверніть',
  'внимание': 'увагу',
  'используйте': 'використовуйте',
  'форма': 'форма',
  'форму': 'форму',
  'формой': 'формою',
  'формы': 'форми',
  'означает': 'означає',
  'означают': 'означають',
  'запомните': 'запамʼятайте',
  'начинается': 'починається',
  'начинаются': 'починаються',
  'слог': 'склад',
  'слоге': 'складі',
  'буква': 'літера',
  'буквы': 'літери',
  'звук': 'звук',
  'звука': 'звука',
  'звуком': 'звуком',
  'язык': 'мова',
  'языка': 'мови',
  'испанский': 'іспанський',
  'испанского': 'іспанського',
  'испанском': 'іспанській',
  'испанскую': 'іспанську',
  'испанская': 'іспанська',
  'испанское': 'іспанське',
  'испанским': 'іспанським',
  'испанские': 'іспанські',
  'испанских': 'іспанських',
  'обычно': 'зазвичай',
  'обично': 'зазвичай',
  'пишется': 'пишеться',
  'но': 'але',
  'будто': 'ніби',
  'нет': 'немає',
  'сразу': 'одразу',
  'гласного': 'голосного',
  'гласной': 'голосною',
  'гласные': 'голосні',
  'гласние': 'голосні',
  'устойчивые': 'стабільні',
  'устойчивие': 'стабільні',
  'устойчиви': 'стабільні',
  'звучат': 'звучать',
  'кратко': 'коротко',
  'примерно': 'приблизно',
  'передаёт': 'передає',
  'передает': 'передає',
  'отдельный': 'окремий',
  'отдельная': 'окрема',
  'отдельное': 'окреме',
  'близкий': 'близький',
  'близкая': 'близька',
  'близкое': 'близьке',
  'норме': 'нормі',
  'курса': 'курсу',
  'относятся': 'належать',
  'произношение': 'вимову',
  'объясняется': 'пояснюється',
  'твёрдый': 'твердий',
  'сильнее': 'сильніше',
  'дольше': 'довше',
  'короче': 'коротша',
  'чем': 'ніж',
  'начальных': 'початкових',
  'быстрый': 'швидкий',
  'языком': 'язиком',
  'области': 'ділянки',
  'верхними': 'верхніми',
  'зубами': 'зубами',
  'подсказках': 'підказках',
  'отмечается': 'позначається',
  'отмечено': 'позначено',
  'явно': 'явно',
  'чтобы': 'щоб',
  'новичку': 'початківцю',
  'приходилось': 'доводилося',
  'угадывать': 'вгадувати',
  'механически': 'механічно',
  'буквам': 'літерах',
  'сравнительно': 'порівняно',
  'одинаково': 'однаково',
  'разных': 'різних',
  'меняйте': 'змінюйте',
  'происходит': 'відбувається',
  'английском': 'англійському',
  'чтении': 'читанні',
  'немую': 'німу',
  'сочетание': 'сполучення',
  'сочетания': 'сполучення',
  'читается': 'читається',
  'читаются': 'читаються',
  'произносится': 'вимовляється',
  'которое': 'яке',
  'которая': 'яка',
  'который': 'який',
  'немой': 'німого',
  'написанное': 'написане',
  'вопросительное': 'питальне',
  'правильно': 'правильно',
  'страна': 'країна',
  'испания': 'Іспанія',
  'номер': 'номер',
  'число': 'число',
  'с': 'з',
  'и': 'і',
  'для': 'для',
  'это': 'це',
  'ето': 'це',
  'завершает': 'завершує',
  'прощание': 'прощання',
  'вежливый': 'ввічливе',
  'вежливую': 'ввічливе',
  'просьба': 'прохання',
  'просьбу': 'прохання',
  'соотнесите': 'зіставте',
  'простое': 'просте',
  'описание': 'опис',
  'приветствие': 'привітання',
  'можно': 'можна',
  'использовать': 'використовувати',
  'любое': 'будь-який',
  'время': 'час',
  'дня': 'дня',
  'каждое': 'кожне',
  'первое': 'перше',
  'его': 'його',
  'значением': 'значенням',
  'распознавайте': 'розпізнавайте',
  'важны': 'важливі',
  'именах': 'іменах',
  'имена': 'імена',
  'первых': 'перших',
  'первих': 'перших',
  'словах': 'словах',
  'слов': 'слів',
  'утренние': 'ранкові',
  'вечерние': 'вечірні',
  'приветствия': 'привітання',
  'звуки': 'звуки',
  'знакомых': 'знайомих',
  'представления': 'представлення',
  'важни': 'важливі',
  'относится': 'належить',
  'той': 'тієї',
  'же': 'самої',
  'общей': 'загальної',
  'категории': 'категорії',
  'произношения': 'вимови',
  'две': 'дві',
  'путайте': 'плутайте',
  'их': 'їх',
  'двумя': 'двома',
  'женщина': 'жінка',
  'может': 'може',
  'город': 'місто',
  'города': 'міста',
  'устойчивый': 'сталий',
  'устойчивую': 'сталу',
  'устойчивой': 'сталій',
  'учебный': 'навчальний',
  'учебная': 'навчальна',
  'учебное': 'навчальне',
  'женский': 'жіночий',
  'мужской': 'чоловічий',
  'род': 'рід',
  'состояние': 'стан',
  'боль': 'біль',
  'speaker': 'мовець',
  'role-play': 'рольовій вправі',
  'classroom': 'навчальне',
  'general': 'загальне',
  'production': 'відтворення',
  'possessive': 'присвійна форма',
  'семьи': 'сімʼї',
  'конструкции': 'конструкції',
};
