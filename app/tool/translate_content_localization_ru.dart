import 'dart:convert';
import 'dart:io';

const _localizationPath =
    'assets/languages/spanish/localization/support_localizations.json';

void main() {
  final root = Directory.current;
  final file = File('${root.path}/$_localizationPath');
  final bundle = Map<String, Object?>.from(
    jsonDecode(file.readAsStringSync()) as Map,
  );

  var translated = 0;
  var invariant = 0;
  final suspicious = <String>[];

  for (final entry in bundle['entries'] as List) {
    final entryMap = Map<String, Object?>.from(entry as Map);
    final type = entryMap['type'] as String;
    final id = entryMap['id'] as String;
    final fields = Map<String, Object?>.from(entryMap['fields'] as Map);
    for (final field in fields.entries) {
      final values = Map<String, Object?>.from(field.value as Map);
      final english = values['en'];
      if (english is! String) {
        continue;
      }

      final russian = translateRussian(
        english,
        type: type,
        id: id,
        fieldName: field.key,
      );
      values['ru'] = _finalizeRussian(russian);
      fields[field.key] = values;
      translated += 1;
      if (russian.trim() == english.trim()) {
        invariant += 1;
        if (!_isAllowedInvariant(english)) {
          suspicious.add('$type|$id|${field.key}|$english');
        }
      }
    }
    entryMap['fields'] = fields;
    final index = (bundle['entries'] as List).indexOf(entry);
    (bundle['entries'] as List)[index] = entryMap;
  }

  _writePrettyJson(file, bundle);

  stdout.writeln('R2E2 Russian fields written: $translated');
  stdout.writeln('Intentional identical/invariant fields: $invariant');
  stdout.writeln('Suspicious identical fields: ${suspicious.length}');
  for (final item in suspicious.take(40)) {
    stdout.writeln(item);
  }
}

String translateRussian(
  String source, {
  required String type,
  required String id,
  required String fieldName,
}) {
  final text = source.trim();
  final exact = _exact[text];
  if (exact != null) {
    return exact;
  }
  if (_looksLikeNameOrPlace(text)) {
    return _nameOrPlace(text);
  }

  if (type == 'vocabulary' && fieldName == 'native_translation') {
    return _translateVocabularyMeaning(text);
  }
  if (type == 'vocabulary' && fieldName == 'notes') {
    return _translateNote(text);
  }
  if (type == 'grammar') {
    if (fieldName == 'title') {
      return _translateTitle(text);
    }
    if (fieldName == 'explanation') {
      return _translateExplanation(text);
    }
    if (fieldName.startsWith('examples.')) {
      return _translateExample(text);
    }
  }
  if (type == 'dialogue') {
    if (fieldName == 'title') {
      return _translateTitle(text);
    }
    return _translateSentences(text);
  }
  if (type == 'reading') {
    if (fieldName == 'title') {
      return _translateTitle(text);
    }
    return _translateSentences(text);
  }
  if (type == 'exercise_template') {
    if (fieldName == 'prompt_template') {
      return _translatePrompt(text);
    }
    return _translateOption(text);
  }

  return switch (type) {
    'course' => _translateTitle(text),
    'module' => _translateTitle(text),
    'lesson' => _translateLessonField(text, fieldName),
    'lesson_objective' => _translateSentences(text),
    'lesson_section' => _translateTitle(text),
    'lesson_activity' => _translateTitle(text),
    'lesson_summary' => _translateSentences(text),
    _ => _translateSentences(text),
  };
}

String _translateLessonField(String text, String fieldName) {
  if (fieldName == 'title') {
    return _translateTitle(text);
  }
  return _translateSentences(text);
}

String _translatePrompt(String text) {
  var output = text;
  final exact = _exactPrompt[text];
  if (exact != null) {
    return exact;
  }

  final checkpointPrefix = output.startsWith('Checkpoint: ');
  final reviewPrefix = output.startsWith('Review: ');
  final competencyPrefix = output.startsWith('Competency check: ');
  if (checkpointPrefix || reviewPrefix || competencyPrefix) {
    final prefix = checkpointPrefix
        ? 'Контрольная проверка: '
        : reviewPrefix
        ? 'Повторение: '
        : 'Проверка навыка: ';
    final rest = output.substring(output.indexOf(': ') + 2);
    return '$prefix${_lowerFirst(_translatePrompt(rest))}';
  }

  output = output.replaceAllMapped(
    RegExp(r'^Type the Spanish word for "([^"]+)"(.*)\.?$'),
    (match) {
      final meaning = _translateEmbeddedEnglish(match.group(1)!);
      final tail = _translatePromptTail(match.group(2)!.trim());
      return 'Введите испанское слово со значением «$meaning»${tail.isEmpty ? '' : ' $tail'}.';
    },
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(
      r'^Type the Spanish word that starts with silent h and means "([^"]+)"\.?$',
    ),
    (match) =>
        'Введите испанское слово, которое начинается с немой h и означает «${_translateEmbeddedEnglish(match.group(1)!)}».',
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(r'^Type the Spanish word/name that begins with j: "([^"]+)"\.?$'),
    (match) =>
        'Введите испанское слово или имя, которое начинается с j: «${match.group(1)}».',
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(r'^Type the Spanish word/name "([^"]+)" with its accent\.?$'),
    (match) =>
        'Введите испанское слово или имя «${match.group(1)}» с нужным знаком ударения.',
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(r'^Choose the Spanish reading rule shown by "([^"]+)"\.?$'),
    (match) =>
        'Выберите испанское правило чтения, показанное словом «${match.group(1)}».',
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(r'^Choose the sentence that means "([^"]+)"\.?$'),
    (match) =>
        'Выберите предложение со значением «${_translateEmbeddedEnglish(match.group(1)!)}».',
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(r'^Complete with the Spanish word for "([^"]+)": "([^"]+)"\.?$'),
    (match) =>
        'Дополните испанским словом со значением «${_translateEmbeddedEnglish(match.group(1)!)}»: «${match.group(2)}».',
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(r'^Complete with the he/she/name form of tener: "([^"]+)"\.?$'),
    (match) => 'Дополните формой tener для он/она/имя: «${match.group(1)}».',
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(r'^Complete with the "I have" form of tener for age: "([^"]+)"\.?$'),
    (match) =>
        'Дополните формой tener «у меня есть» для возраста: «${match.group(1)}».',
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(
      r'^Type the Spanish (sentence|question|answer|request|command|word|phrase|introduction)(.*?): "([^"]+)"\.?$',
    ),
    (match) {
      final kind = _ruKind(match.group(1)!);
      final rest = match.group(2)!.trim();
      final phrase = _translateEmbeddedEnglish(match.group(3)!);
      final restRu = rest.isEmpty ? '' : ' ${_translatePromptTail(rest)}';
      return 'Введите испанск$kind$restRu: «$phrase».';
    },
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(
      r'^Write the Spanish (sentence|question|answer|request|command|word|phrase|location statement|sentence lines)(.*?): (.+)$',
    ),
    (match) {
      final kind = match.group(1)! == 'sentence lines'
          ? 'строки'
          : _ruNounKind(match.group(1)!);
      return 'Напишите испанские $kind${_translatePromptTail(match.group(2)!.trim())}: ${_translateEmbeddedEnglish(match.group(3)!)}';
    },
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(
      r'^Choose the Spanish (word|phrase|sentence|question|answer|form|pattern|direction|greeting|line|request|route question) for "([^"]+)"\.?$',
    ),
    (match) {
      final kind = _ruChoiceKind(match.group(1)!);
      return 'Выберите испанск$kind для «${_translateEmbeddedEnglish(match.group(2)!)}».';
    },
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(
      r'^Choose the (meaning|best translation|English meaning) of "([^"]+)"\.?$',
    ),
    (match) {
      final kind = match.group(1) == 'best translation'
          ? 'лучший перевод'
          : 'значение';
      return 'Выберите $kind фразы «${match.group(2)}».';
    },
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(r'^What does "([^"]+)" mean\?$'),
    (match) => 'Что означает «${match.group(1)}»?',
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(r'^Complete with the Spanish (.+?): "([^"]+)"\.?$'),
    (match) =>
        'Дополните испанским ${_translatePromptTail(match.group(1)!)}: «${match.group(2)}».',
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(r'^Complete the Spanish (.+?): "([^"]+)"\.?$'),
    (match) =>
        'Дополните испанск${_ruKind(match.group(1)!)}: «${match.group(2)}».',
  );
  if (output != text) {
    return output;
  }

  output = output.replaceAllMapped(
    RegExp(
      r'^Answer the question "([^"]+)" with the Spanish sentence: "([^"]+)"\.?$',
    ),
    (match) =>
        'Ответьте на вопрос «${match.group(1)}» испанским предложением: «${_translateEmbeddedEnglish(match.group(2)!)}».',
  );
  if (output != text) {
    return output;
  }

  return _translateSentences(text);
}

String _ruKind(String value) {
  if (value.contains('question')) return 'ий вопрос';
  if (value.contains('answer')) return 'ий ответ';
  if (value.contains('command')) return 'ую команду';
  if (value.contains('request')) return 'ую просьбу';
  if (value.contains('word')) return 'ое слово';
  if (value.contains('phrase')) return 'ую фразу';
  if (value.contains('introduction')) return 'ое представление';
  return 'ое предложение';
}

String _ruNounKind(String value) {
  if (value.contains('question')) return 'вопрос';
  if (value.contains('answer')) return 'ответ';
  if (value.contains('request')) return 'просьбу';
  if (value.contains('command')) return 'команду';
  if (value.contains('word')) return 'слово';
  if (value.contains('phrase')) return 'фразу';
  if (value.contains('location')) return 'фразу о местоположении';
  return 'предложение';
}

String _ruChoiceKind(String value) {
  if (value.contains('question')) return 'ий вопрос';
  if (value.contains('answer')) return 'ий ответ';
  if (value.contains('form')) return 'ую форму';
  if (value.contains('pattern')) return 'ую конструкцию';
  if (value.contains('direction')) return 'ое указание направления';
  if (value.contains('greeting')) return 'ое приветствие';
  if (value.contains('line')) return 'ую реплику';
  if (value.contains('request')) return 'ую просьбу';
  if (value.contains('word')) return 'ое слово';
  if (value.contains('phrase')) return 'ую фразу';
  return 'ое предложение';
}

String _translatePromptTail(String text) {
  var out = text.trim();
  out = out.replaceFirst(RegExp(r'\.$'), '');
  if (out.isEmpty) return '';
  var match = RegExp(r'^word for "([^"]+)"$').firstMatch(out);
  if (match != null) {
    return 'словом со значением «${_translateEmbeddedEnglish(match.group(1)!)}»';
  }
  match = RegExp(r'^phrase for "([^"]+)"$').firstMatch(out);
  if (match != null) {
    return 'фразой со значением «${_translateEmbeddedEnglish(match.group(1)!)}»';
  }
  match = RegExp(r'^question word for "([^"]+)"$').firstMatch(out);
  if (match != null) {
    return 'вопросительным словом со значением «${_translateEmbeddedEnglish(match.group(1)!)}»';
  }
  match = RegExp(r'^spelling group in "([^"]+)"$').firstMatch(out);
  if (match != null) return 'буквосочетанием из слова «${match.group(1)}»';
  if (out == 'origin pattern word') {
    return 'словом из конструкции происхождения';
  }
  if (out == 'introduction pattern') {
    return 'конструкцией представления';
  }
  if (out == 'the "I have" form of tener for age') {
    return 'формой tener для возраста «у меня есть»';
  }
  if (out == 'he/she/name form of tener') {
    return 'формой tener для он/она/имя';
  }
  if (out == 'spoken number') {
    return 'произнесённого номера';
  }
  out = out
      .replaceAll('for age', 'для возраста')
      .replaceAll('for "take"', 'для «возьми/сядь на»')
      .replaceAll('for "straight"', 'для «прямо»')
      .replaceAll('for "repeat"', 'для «повтори»')
      .replaceAll('for "please"', 'для «пожалуйста»')
      .replaceAll('for "from"', 'для «из/от»')
      .replaceAll('for "where"', 'для «где/куда»')
      .replaceAll('for "what"', 'для «что»')
      .replaceAll('for asking who someone is', 'для вопроса о том, кто это')
      .replaceAll('in this exact order', 'именно в этом порядке')
      .replaceAll('from the sign', 'с таблички')
      .replaceAll('with "we have"', 'формой «у нас есть»');
  return out;
}

String _translateTitle(String text) {
  final exact = _exactTitle[text] ?? _exact[text];
  if (exact != null) return exact;
  final sentence = _translateSentences(text);
  if (sentence != text && !RegExp(r'[A-Za-z]').hasMatch(sentence)) {
    return _titleCaseRu(sentence);
  }
  return _translateTitleWords(text);
}

String _translateExplanation(String text) {
  final exact = _exact[text];
  if (exact != null) return exact;
  return _translateSentences(text);
}

String _translateExample(String text) {
  if (text.contains(' = ')) {
    final parts = text.split(' = ');
    return '${parts.first} = ${_translateEmbeddedEnglish(parts.sublist(1).join(' = '))}';
  }
  if (text.startsWith('Common mistake: ')) {
    return text.replaceFirst('Common mistake: ', 'Типичная ошибка: ');
  }
  return _looksLikeSpanish(text) ? text : _translateSentences(text);
}

String _translateNote(String text) {
  final exact = _exact[text];
  if (exact != null) return exact;
  return _translateSentences(text);
}

String _translateOption(String text) {
  return _translateEmbeddedEnglish(text);
}

String _translateVocabularyMeaning(String text) {
  final exact = _vocabulary[text] ?? _exact[text];
  if (exact != null) return exact;
  return _translateEmbeddedEnglish(text);
}

String _translateEmbeddedEnglish(String text) {
  var out = text.trim();
  final exact = _embedded[out] ?? _vocabulary[out] ?? _exact[out];
  if (exact != null) return exact;
  final simple = _translateSimpleLine(out);
  if (simple != null) return simple;
  if (_looksLikeNameOrPlace(out)) return _nameOrPlace(out);
  if (_looksLikeSpanish(out)) return out;

  out = out
      .replaceAll('I am ', 'я ')
      .replaceAll('I have ', 'у меня есть ')
      .replaceAll('I need ', 'мне нужен ')
      .replaceAll('I want ', 'я хочу ')
      .replaceAll('My name is ', 'меня зовут ')
      .replaceAll('Where are you from?', 'Откуда ты?')
      .replaceAll('Where do you live?', 'Где ты живёшь?')
      .replaceAll(
        'Which languages do you speak?',
        'На каких языках ты говоришь?',
      )
      .replaceAll('What is your name?', 'Как тебя зовут?')
      .replaceAll('How are you?', 'Как дела?')
      .replaceAll('How old are you?', 'Сколько тебе лет?')
      .replaceAll('Can you help me?', 'Вы можете мне помочь?')
      .replaceAll('Please repeat.', 'Повторите, пожалуйста.')
      .replaceAll('Excuse me.', 'Извините.')
      .replaceAll('Good morning.', 'Доброе утро.')
      .replaceAll('Good afternoon.', 'Добрый день.')
      .replaceAll('Good evening.', 'Добрый вечер.')
      .replaceAll('See you later.', 'До встречи.')
      .replaceAll('thank you', 'спасибо')
      .replaceAll('please', 'пожалуйста')
      .replaceAll('goodbye', 'до свидания')
      .replaceAll('hello', 'привет')
      .replaceAll('book', 'книга')
      .replaceAll('water', 'вода')
      .replaceAll('bread', 'хлеб')
      .replaceAll('cheese', 'сыр')
      .replaceAll('phone', 'телефон')
      .replaceAll('bag', 'сумка')
      .replaceAll('bottle', 'бутылка')
      .replaceAll('doctor', 'врач')
      .replaceAll('pharmacy', 'аптека')
      .replaceAll('hospital', 'больница')
      .replaceAll('bathroom', 'туалет')
      .replaceAll('station', 'станция')
      .replaceAll('hotel', 'отель')
      .replaceAll('center', 'центр')
      .replaceAll('train', 'поезд')
      .replaceAll('bus', 'автобус')
      .replaceAll('metro', 'метро')
      .replaceAll('turn left', 'повернуть налево')
      .replaceAll('turn right', 'повернуть направо')
      .replaceAll('go straight', 'идти прямо')
      .replaceAll('near', 'близко')
      .replaceAll('far', 'далеко');
  out = _replaceWholeWords(out, _wordReplacements);
  out = _replaceWholeWords(out, _names);
  return out;
}

String _translateSentences(String text) {
  final exact = _exact[text] ?? _embedded[text];
  if (exact != null) return exact;
  final simple = _translateSimpleLine(text);
  if (simple != null) return simple;
  if (_looksLikeSpanish(text) || _looksLikeNameOrPlace(text)) return text;

  var out = text;
  out = _translateQuotedSegments(out);
  out = _replaceWholeWords(out, _wordReplacements);
  out = _replaceWholeWords(out, _names);
  out = out
      .replaceAll(' plus ', ' плюс ')
      .replaceAll(' with ', ' с ')
      .replaceAll(' without ', ' без ')
      .replaceAll(' and ', ' и ')
      .replaceAll(' or ', ' или ')
      .replaceAll(' / ', ' / ')
      .replaceAll('...', '...');
  out = out.replaceAll(RegExp(r'\s+'), ' ').trim();
  return _cleanupRussian(out);
}

String _finalizeRussian(String text) {
  var out = _replaceWholeWords(text, _wordReplacements);
  out = _replaceWholeWords(out, _names);
  out = out
      .replaceAll(' /name', ' или имя')
      .replaceAll('/name', ' или имя')
      .replaceAll(' a ', ' ')
      .replaceAll('с its', 'с нужным')
      .replaceAll('of tener', 'tener')
      .replaceAll('  ', ' ')
      .replaceAll(' .', '.')
      .replaceAll('..', '.')
      .replaceAll('«"', '«')
      .replaceAll('"»', '»')
      .replaceAll('«I ', '«Я ')
      .replaceAll(' is ', ' — ')
      .replaceAll(' is:', ' —')
      .replaceAll(' as ', ' как ')
      .replaceAll(' at ', ' в ')
      .replaceAll(' of ', ' ')
      .replaceAll(' so ', ' поэтому ')
      .trim();
  return out;
}

String? _translateSimpleLine(String text) {
  final direct = _lineTranslations[text];
  if (direct != null) return direct;

  var match = RegExp(
    r'^Good morning\. My name is ([A-Za-zíó]+)\.$',
  ).firstMatch(text);
  if (match != null) {
    return 'Доброе утро. Меня зовут ${_nameOrPlace(match.group(1)!)}.';
  }

  match = RegExp(r'^Good afternoon\. I am ([A-Za-zíó]+)\.$').firstMatch(text);
  if (match != null) {
    return 'Добрый день. Я — ${_nameOrPlace(match.group(1)!)}.';
  }

  match = RegExp(r'^Hello\. My name is ([A-Za-zíó]+)\.$').firstMatch(text);
  if (match != null) {
    return 'Привет. Меня зовут ${_nameOrPlace(match.group(1)!)}.';
  }

  match = RegExp(
    r'^Hello, ([A-Za-zíó]+)\. My name is ([A-Za-zíó]+)\.$',
  ).firstMatch(text);
  if (match != null) {
    return 'Привет, ${_nameOrPlace(match.group(1)!)}. Меня зовут ${_nameOrPlace(match.group(2)!)}.';
  }

  match = RegExp(
    r'^Hello, ([A-Za-zíó]+)\. I am from ([A-Za-z ]+)\.$',
  ).firstMatch(text);
  if (match != null) {
    return 'Привет, ${_nameOrPlace(match.group(1)!)}. Я из ${_placeGenitive(match.group(2)!)}.';
  }

  match = RegExp(r'^I am from ([A-Za-z ]+)\. And you\?$').firstMatch(text);
  if (match != null) return 'Я из ${_placeGenitive(match.group(1)!)}. А ты?';

  match = RegExp(r'^I am from ([A-Za-z ]+)\.$').firstMatch(text);
  if (match != null) return 'Я из ${_placeGenitive(match.group(1)!)}.';

  match = RegExp(
    r'^I am from ([A-Za-z ]+)\. I live in ([A-Za-z ]+)\.$',
  ).firstMatch(text);
  if (match != null) {
    return 'Я из ${_placeGenitive(match.group(1)!)}. Я живу в ${_placePrepositional(match.group(2)!)}.';
  }

  match = RegExp(r'^My family is in ([A-Za-z ]+)\.$').firstMatch(text);
  if (match != null) {
    return 'Моя семья в ${_placePrepositional(match.group(1)!)}.';
  }

  match = RegExp(r'^([A-Za-zíó]+) is my friend\.$').firstMatch(text);
  if (match != null) return '${_nameOrPlace(match.group(1)!)} — мой друг.';

  match = RegExp(
    r'^Hello, ([A-Za-zíó]+)\. Where are you from\?$',
  ).firstMatch(text);
  if (match != null) {
    return 'Привет, ${_nameOrPlace(match.group(1)!)}. Откуда ты?';
  }

  match = RegExp(r'^Where is ([A-Za-zíó]+) from\?$').firstMatch(text);
  if (match != null) return 'Откуда ${_nameOrPlace(match.group(1)!)}?';

  match = RegExp(
    r'^Which languages does ([A-Za-zíó]+) speak\?$',
  ).firstMatch(text);
  if (match != null) {
    return 'На каких языках говорит ${_nameOrPlace(match.group(1)!)}?';
  }

  match = RegExp(r'^Does she speak ([A-Za-z]+)\?$').firstMatch(text);
  if (match != null) {
    return 'Она говорит по-${_translateEmbeddedEnglish(match.group(1)!).toLowerCase()}?';
  }

  match = RegExp(r'^No, she does not speak ([A-Za-z]+)\.$').firstMatch(text);
  if (match != null) {
    return 'Нет, она не говорит по-${_translateEmbeddedEnglish(match.group(1)!).toLowerCase()}.';
  }

  match = RegExp(r'^She speaks ([A-Za-z]+)\?$').firstMatch(text);
  if (match != null) {
    return 'Она говорит по-${_translateEmbeddedEnglish(match.group(1)!).toLowerCase()}?';
  }

  match = RegExp(r'^Do you speak ([A-Za-z]+)\?$').firstMatch(text);
  if (match != null) {
    return 'Ты говоришь по-${_translateEmbeddedEnglish(match.group(1)!).toLowerCase()}?';
  }

  match = RegExp(r'^Do you need help\?$').firstMatch(text);
  if (match != null) return 'Тебе нужна помощь?';

  match = RegExp(r'^He is from ([A-Za-z ]+)\.$').firstMatch(text);
  if (match != null) return 'Он из ${_placeGenitive(match.group(1)!)}.';

  match = RegExp(r'^She is from ([A-Za-z ]+)\.$').firstMatch(text);
  if (match != null) return 'Она из ${_placeGenitive(match.group(1)!)}.';

  if (text == 'She is my friend.') return 'Она моя подруга.';

  match = RegExp(r'^He lives in ([A-Za-z ]+)\.$').firstMatch(text);
  if (match != null) {
    return 'Он живёт в ${_placePrepositional(match.group(1)!)}.';
  }

  match = RegExp(r'^She lives in ([A-Za-z ]+)\.$').firstMatch(text);
  if (match != null) {
    return 'Она живёт в ${_placePrepositional(match.group(1)!)}.';
  }

  match = RegExp(r'^I have (.+)\.$').firstMatch(text);
  if (match != null) {
    return 'У меня есть ${_translateEmbeddedEnglish(match.group(1)!)}.';
  }

  match = RegExp(r'^Do you have (.+)\?$').firstMatch(text);
  if (match != null) {
    return 'У тебя есть ${_translateEmbeddedEnglish(match.group(1)!)}?';
  }

  match = RegExp(r'^Yes, I have (.+)\.$').firstMatch(text);
  if (match != null) {
    return 'Да, у меня есть ${_translateEmbeddedEnglish(match.group(1)!)}.';
  }

  match = RegExp(r'^The ([a-z]+) is here\.$').firstMatch(text);
  if (match != null) {
    return '${_capitalize(_translateEmbeddedEnglish(match.group(1)!))} здесь.';
  }

  match = RegExp(r'^The ([a-z]+) is there\.$').firstMatch(text);
  if (match != null) {
    return '${_capitalize(_translateEmbeddedEnglish(match.group(1)!))} там.';
  }

  match = RegExp(r'^The ([a-z]+) is on the ([a-z]+)\.$').firstMatch(text);
  if (match != null) {
    return '${_capitalize(_translateEmbeddedEnglish(match.group(1)!))} на ${_translateEmbeddedEnglish(match.group(2)!)}е.';
  }

  match = RegExp(r'^And the ([a-z]+)\?$').firstMatch(text);
  if (match != null) return 'А ${_translateEmbeddedEnglish(match.group(1)!)}?';

  match = RegExp(r'^(.+) means (.+)\.$').firstMatch(text);
  if (match != null) {
    return '${match.group(1)} означает «${_translateEmbeddedEnglish(match.group(2)!)}».';
  }

  return null;
}

String _translateTitleWords(String text) {
  final words = text.split(' ');
  final translated = <String>[];
  var changed = false;
  for (final word in words) {
    final punctuation =
        RegExp(r'[^A-Za-z0-9]+$').firstMatch(word)?.group(0) ?? '';
    final clean = punctuation.isEmpty
        ? word
        : word.substring(0, word.length - punctuation.length);
    final mapped = _titleWords[clean];
    if (mapped != null) {
      translated.add('$mapped$punctuation');
      changed = true;
    } else {
      translated.add(word);
    }
  }
  if (!changed) return _cleanupRussian(text);
  return _titleCaseRu(translated.join(' '));
}

String _capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

String _placeGenitive(String value) {
  return _placeGenitives[value] ?? _nameOrPlace(value);
}

String _placePrepositional(String value) {
  return _placePrepositionals[value] ?? _nameOrPlace(value);
}

String _translateQuotedSegments(String text) {
  return text.replaceAllMapped(RegExp(r'"([^"]+)"'), (match) {
    final inner = match.group(1)!;
    return '«${_translateEmbeddedEnglish(inner)}»';
  });
}

String _replaceWholeWords(String text, Map<String, String> replacements) {
  var out = text;
  final keys = replacements.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  for (final key in keys) {
    out = out.replaceAll(
      RegExp(
        r'(?<![A-Za-z])' + RegExp.escape(key) + r'(?![A-Za-z])',
        caseSensitive: false,
      ),
      replacements[key]!,
    );
  }
  return out;
}

String _cleanupRussian(String text) {
  var out = text
      .replaceAll('Spanish', 'испанский')
      .replaceAll('English', 'английский')
      .replaceAll('Russian', 'русский')
      .replaceAll('Ukrainian', 'украинский')
      .replaceAll('Pattern', 'Конструкция')
      .replaceAll('Reading', 'Чтение')
      .replaceAll('Vocabulary', 'Лексика')
      .replaceAll('Grammar', 'Грамматика')
      .replaceAll('Dialogue', 'Диалог')
      .replaceAll('Practice', 'Практика')
      .replaceAll('Review', 'Повторение')
      .replaceAll('Checkpoint', 'Контрольная проверка');
  out = out.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (out.isEmpty) return out;
  return out[0].toUpperCase() + out.substring(1);
}

String _lowerFirst(String text) {
  if (text.isEmpty) return text;
  return text[0].toLowerCase() + text.substring(1);
}

String _titleCaseRu(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

String _nameOrPlace(String text) => _names[text] ?? text;

bool _looksLikeNameOrPlace(String text) => _names.containsKey(text);

bool _looksLikeSpanish(String text) {
  final lower = text.toLowerCase();
  if (RegExp(r'[¿¡áéíóúñü]').hasMatch(lower)) return true;
  if (RegExp(r'^(gira|voy|hola,|cuesta|son)\b').hasMatch(lower)) return true;
  final tokens = RegExp(r"[a-z]+").allMatches(lower).map((m) {
    return m.group(0)!;
  }).toSet();
  if (tokens.any(_englishMarkers.contains)) return false;
  return tokens.isNotEmpty && tokens.any(_spanishMarkers.contains);
}

bool _isAllowedInvariant(String text) {
  return _looksLikeSpanish(text) ||
      _looksLikeNameOrPlace(text) ||
      RegExp(r'^(A0|AI|CEFR|Tutor Language)$').hasMatch(text);
}

const _spanishMarkers = {
  'adios',
  'agua',
  'algo',
  'amigo',
  'anos',
  'ayuda',
  'bien',
  'buenas',
  'buenos',
  'cafe',
  'como',
  'cuanto',
  'cuesta',
  'de',
  'derecha',
  'donde',
  'el',
  'ella',
  'en',
  'eres',
  'es',
  'esta',
  'estoy',
  'encantado',
  'encantada',
  'favor',
  'gira',
  'gracias',
  'hablo',
  'hola',
  'igualmente',
  'h',
  'la',
  'l',
  'llamo',
  'luego',
  'll',
  'me',
  'mesa',
  'mi',
  'mucho',
  'necesito',
  'no',
  'o',
  'por',
  'qu',
  'r',
  'que',
  'recto',
  'repite',
  'rr',
  'se',
  'si',
  'silla',
  'soy',
  'son',
  'tal',
  'te',
  'tengo',
  'tienes',
  'tren',
  'un',
  'una',
  'vivo',
  'voy',
  'y',
  'gue',
  'gui',
  'j',
};

const _englishMarkers = {
  'a',
  'about',
  'afternoon',
  'am',
  'and',
  'answer',
  'are',
  'book',
  'bread',
  'can',
  'do',
  'does',
  'eight',
  'evening',
  'fine',
  'from',
  'good',
  'have',
  'hello',
  'here',
  'how',
  'i',
  'is',
  'key',
  'later',
  'mean',
  'means',
  'morning',
  'my',
  'name',
  'nice',
  'number',
  'old',
  'on',
  'phone',
  'please',
  'repeat',
  'see',
  'table',
  'thank',
  'the',
  'there',
  'to',
  'water',
  'where',
  'years',
  'you',
  'your',
};

const _names = {
  'Ana': 'Ана',
  'Carlos': 'Карлос',
  'Carmen': 'Кармен',
  'Diego': 'Диего',
  'Elena': 'Элена',
  'Javier': 'Хавьер',
  'Jose': 'Хосе',
  'José': 'Хосе',
  'Laura': 'Лаура',
  'Lucia': 'Лусия',
  'Luis': 'Луис',
  'Maria': 'Мария',
  'Marta': 'Марта',
  'Miguel': 'Мигель',
  'Pablo': 'Пабло',
  'Pedro': 'Педро',
  'Sofia': 'София',
  'Sofía': 'София',
  'Argentina': 'Аргентина',
  'Barcelona': 'Барселона',
  'Bogota': 'Богота',
  'Bogotá': 'Богота',
  'Buenos Aires': 'Буэнос-Айрес',
  'Chile': 'Чили',
  'Colombia': 'Колумбия',
  'Kyiv': 'Киев',
  'Lima': 'Лима',
  'Madrid': 'Мадрид',
  'Mexico': 'Мексика',
  'México': 'Мексика',
  'Peru': 'Перу',
  'Santiago': 'Сантьяго',
  'Seville': 'Севилья',
  'Valencia': 'Валенсия',
  'Ukraine': 'Украина',
  'Spain': 'Испания',
};

const _placeGenitives = {
  'Argentina': 'Аргентины',
  'Barcelona': 'Барселоны',
  'Bogota': 'Боготы',
  'Bogotá': 'Боготы',
  'Buenos Aires': 'Буэнос-Айреса',
  'Chile': 'Чили',
  'Colombia': 'Колумбии',
  'Kyiv': 'Киева',
  'Lima': 'Лимы',
  'Madrid': 'Мадрида',
  'Mexico': 'Мексики',
  'México': 'Мексики',
  'Peru': 'Перу',
  'Santiago': 'Сантьяго',
  'Seville': 'Севильи',
  'Spain': 'Испании',
  'Ukraine': 'Украины',
  'Valencia': 'Валенсии',
};

const _placePrepositionals = {
  'Argentina': 'Аргентине',
  'Barcelona': 'Барселоне',
  'Bogota': 'Боготе',
  'Bogotá': 'Боготе',
  'Buenos Aires': 'Буэнос-Айресе',
  'Chile': 'Чили',
  'Colombia': 'Колумбии',
  'Kyiv': 'Киеве',
  'Lima': 'Лиме',
  'Madrid': 'Мадриде',
  'Mexico': 'Мексике',
  'México': 'Мексике',
  'Peru': 'Перу',
  'Santiago': 'Сантьяго',
  'Seville': 'Севилье',
  'Spain': 'Испании',
  'Ukraine': 'Украине',
  'Valencia': 'Валенсии',
};

const _lineTranslations = {
  'And you?': 'А ты?',
  "I don't understand.": 'Я не понимаю.',
  'Thank you.': 'Спасибо.',
  'Please.': 'Пожалуйста.',
  "You're welcome.": 'Пожалуйста / не за что.',
  'Likewise.': 'И мне тоже приятно.',
  'How old are you?': 'Сколько тебе лет?',
  'I am twenty years old.': 'Мне двадцать лет.',
  'I am eighteen years old.': 'Мне восемнадцать лет.',
  'Sorry, I do not understand.': 'Извините, я не понимаю.',
  'Repeat, please.': 'Повторите, пожалуйста.',
  'What does gracias mean?': 'Что означает gracias?',
  'Gracias means thank you.': 'Gracias означает «спасибо».',
  'Nice to meet you.': 'Приятно познакомиться.',
  'I want water, please.': 'Я хочу воды, пожалуйста.',
  'Thank you. Do you have bread?': 'Спасибо. У тебя есть хлеб?',
  'Yes, I have bread and cheese.': 'Да, у меня есть хлеб и сыр.',
  'Do you have water?': 'У тебя есть вода?',
  'Thank you. See you later.': 'Спасибо. До встречи.',
  'Where are you from?': 'Откуда ты?',
  'Where is the book?': 'Где книга?',
  'The book is here.': 'Книга здесь.',
  'The book is on the table.': 'Книга на столе.',
  'The phone is here.': 'Телефон здесь.',
  'And the key?': 'А ключ?',
  'The key is there.': 'Ключ там.',
  'Your number?': 'Твой номер?',
  'Two zero five eight.': 'Два ноль пять восемь.',
  'How are you?': 'Как дела?',
  'Fine, thank you. I have a book.': 'Хорошо, спасибо. У меня есть книга.',
  'See you later.': 'До встречи.',
  'I am from Madrid. Where are you from?': 'Я из Мадрида. Откуда ты?',
  'I am from Mexico. Nice to meet you.': 'Я из Мексики. Приятно познакомиться.',
  'Hello, Luis. How are you?': 'Привет, Луис. Как дела?',
  'Fine, thank you. I am hungry.': 'Хорошо, спасибо. Я голоден / голодна.',
  'I am hungry.': 'Я голоден / голодна.',
  'Hello, Luis.': 'Привет, Луис.',
  'Hello, Ana. I have a book.': 'Привет, Ана. У меня есть книга.',
  'Yes, you are right.': 'Да, ты прав / права.',
  'Hello.': 'Привет.',
  'Good morning.': 'Доброе утро.',
  'Excuse me.': 'Извините.',
  'Good afternoon.': 'Добрый день.',
  'Good evening.': 'Добрый вечер.',
  'Where is the bathroom?': 'Где туалет?',
  'Where is the pharmacy?': 'Где аптека?',
  'Good morning. What is this?': 'Доброе утро. Что это?',
  'What is this?': 'Что это?',
  'It is a book.': 'Это книга.',
  'It is a notebook.': 'Это тетрадь.',
  'How much does it cost?': 'Сколько это стоит?',
  'It costs ten euros.': 'Это стоит десять евро.',
  'It costs five euros.': 'Это стоит пять евро.',
  'I want this book, please.': 'Я хочу эту книгу, пожалуйста.',
  'Hello. I want a bottle, please.':
      'Здравствуйте. Я хочу бутылку, пожалуйста.',
  'Yes. It is two euros.': 'Да. Это стоит два евро.',
  'Anything else?': 'Что-нибудь ещё?',
  'Here you are.': 'Вот, пожалуйста.',
  'Where is the stop?': 'Где остановка?',
  'Thank you very much.': 'Большое спасибо.',
  'How do you go to the center?': 'Как ты едешь в центр?',
  'I go by metro.': 'Я еду на метро.',
  'Very good.': 'Очень хорошо.',
  'Sorry.': 'Извините.',
  'Yes. More slowly.': 'Да. Медленнее.',
  'What do you need?': 'Что вам нужно?',
  'Please wait here.': 'Пожалуйста, подождите здесь.',
  'Yes, of course.': 'Да, конечно.',
  'Yes.': 'Да.',
  'The pharmacy is near.': 'Аптека близко.',
  'Who is she?': 'Кто она?',
  'Who is he?': 'Кто он?',
  'She is my sister.': 'Она моя сестра.',
  'Where is Luis?': 'Где Луис?',
  'He is in the kitchen. There is a table there.':
      'Он на кухне. Там есть стол.',
  'You are welcome.': 'Пожалуйста / не за что.',
  'Where is your father?': 'Где твой отец?',
  'And your mother?': 'А твоя мама?',
  'She is in the kitchen.': 'Она на кухне.',
  'Where is the kitchen?': 'Где кухня?',
  'It is there.': 'Она там.',
  'Are you well?': 'Ты в порядке?',
  'No, I am not well.': 'Нет, мне нехорошо.',
  'Yes, thank you.': 'Да, спасибо.',
  'Good morning. Who is she?': 'Доброе утро. Кто она?',
  'What is she like?': 'Какая она?',
  'She is nice. She lives in Lima.': 'Она милая. Она живёт в Лиме.',
  'Hello. Who is she?': 'Привет. Кто она?',
  'Where does he live?': 'Где он живёт?',
  'Hello. Do you have water?': 'Здравствуйте. У вас есть вода?',
  'Yes, we have water.': 'Да, у нас есть вода.',
  'It is near.': 'Это близко.',
  'It is far.': 'Это далеко.',
  'I need help.': 'Мне нужна помощь.',
  'I need a doctor.': 'Мне нужен врач.',
  'I need the police.': 'Мне нужна полиция.',
  'It is an emergency.': 'Это экстренная ситуация.',
  'Can you help me?': 'Вы можете мне помочь?',
  'I do not understand.': 'Я не понимаю.',
  'Please repeat.': 'Повторите, пожалуйста.',
  'Please speak more slowly.': 'Говорите медленнее, пожалуйста.',
  'I am not well.': 'Мне нехорошо.',
  'I have a fever.': 'У меня температура.',
  'My head hurts.': 'У меня болит голова.',
  'My stomach hurts.': 'У меня болит живот.',
  'My throat hurts.': 'У меня болит горло.',
  'Do you have a fever?': 'У тебя температура?',
  'No, my head does not hurt.': 'Нет, голова не болит.',
  'Yes, I have a fever.': 'Да, у меня температура.',
  'Nice to meet you. Are you well?': 'Приятно познакомиться. Ты в порядке?',
  'I feel bad. I need a doctor.': 'Мне плохо. Мне нужен врач.',
  'The hospital is nearby. Go straight.': 'Больница рядом. Идите прямо.',
  'More slowly, please.': 'Медленнее, пожалуйста.',
  'Yes. What is wrong?': 'Да. Что случилось?',
  'I am not well. My head hurts.': 'Мне нехорошо. У меня болит голова.',
  'The pharmacy is nearby.': 'Аптека рядом.',
  'What is wrong?': 'Что случилось?',
  'Goodbye.': 'До свидания.',
  'Hello. I am Luis.': 'Привет. Я — Луис.',
  'I am Ana. Nice to meet you.': 'Я Ана. Приятно познакомиться.',
  'Yes, a little.': 'Да, немного.',
  'Very well, thank you.': 'Очень хорошо, спасибо.',
  'Hello. Where are you from?': 'Привет. Откуда ты?',
  'Yes, a little. Nice to meet you.': 'Да, немного. Приятно познакомиться.',
  'Fine, thank you. How are things?': 'Хорошо, спасибо. Как дела?',
  'Very well.': 'Очень хорошо.',
  'Okay.': 'Нормально.',
  'How are things?': 'Как дела?',
  'So-so.': 'Так себе.',
  'Hello, Ana.': 'Привет, Ана.',
  'Choose an appropriate greeting by time of day.':
      'Выберите подходящее приветствие по времени дня.',
  'Hola, me llamo Luis. = Hello, my name is Luis.':
      'Hola, me llamo Luis. = Привет, меня зовут Луис.',
  'Sofia is eighteen years old. Diego is twenty years old. I am twenty years old.':
      'Софии восемнадцать лет. Диего двадцать лет. Мне двадцать лет.',
  'Eleven, twelve, thirteen, fourteen, fifteen. Sixteen, seventeen, eighteen, nineteen, twenty.':
      'Одиннадцать, двенадцать, тринадцать, четырнадцать, пятнадцать. Шестнадцать, семнадцать, восемнадцать, девятнадцать, двадцать.',
  'Zero, one, two, three, four, five. Six, seven, eight, nine, ten.':
      'Ноль, один, два, три, четыре, пять. Шесть, семь, восемь, девять, десять.',
  'What does hola mean? How are you? Where is the book? Who is Luis?':
      'Что означает hola? Как дела? Где книга? Кто Луис?',
  "Hello. Good morning. Thank you. You're welcome. I don't understand. Repeat, please. See you later.":
      'Привет. Доброе утро. Спасибо. Пожалуйста / не за что. Я не понимаю. Повторите, пожалуйста. До встречи.',
  'Good morning. Hello. Good afternoon. Hello. Good evening.':
      'Доброе утро. Привет. Добрый день. Привет. Добрый вечер.',
  'Nice to meet you. Likewise. Nice to meet you. Nice to meet you.':
      'Приятно познакомиться. И мне тоже приятно. Приятно познакомиться. Приятно познакомиться.',
  'Marta: I am from Ukraine. Luis: I am from Chile. Elena: I am from Colombia.':
      'Марта: я из Украины. Луис: я из Чили. Элена: я из Колумбии.',
  'The book is expensive. The bag is cheap. The pencil is cheap. The bottle is expensive.':
      'Книга дорогая. Сумка дешёвая. Карандаш дешёвый. Бутылка дорогая.',
  'Water: two euros. Pencil: one euro. Bag: three euros.':
      'Вода: два евро. Карандаш: один евро. Сумка: три евро.',
  'A book. A bottle. A bag.': 'Книга. Бутылка. Сумка.',
  'Book: ten euros. Pencil: one euro. Bottle: two euros. Notebook: five euros.':
      'Книга: десять евро. Карандаш: один евро. Бутылка: два евро. Тетрадь: пять евро.',
  'I want a bottle. I want a notebook. Nothing else, thank you.':
      'Я хочу бутылку. Я хочу тетрадь. Больше ничего, спасибо.',
  'A book: ten euros. A bottle: two euros.':
      'Книга: десять евро. Бутылка: два евро.',
  'The station is near. Go by bus. The stop is there.':
      'Станция близко. Езжайте на автобусе. Остановка там.',
  'Hotel: go straight. Turn left. The pharmacy is there.':
      'Отель: идите прямо. Поверните налево. Аптека там.',
  'The pharmacy is near. The hospital is far. The street is here.':
      'Аптека близко. Больница далеко. Улица здесь.',
  'For the center: take the metro. Go straight. Turn right.':
      'Чтобы добраться до центра: садитесь на метро. Идите прямо. Поверните направо.',
  'The station is near. The stop is here. The hotel is far.':
      'Станция близко. Остановка здесь. Отель далеко.',
  'I am going to the center. I go by metro. The taxi is here. The bus is there.':
      'Я еду в центр. Я еду на метро. Такси здесь. Автобус там.',
  "I don't understand. Please repeat. Please speak more slowly.":
      'Я не понимаю. Повторите, пожалуйста. Говорите медленнее, пожалуйста.',
  'I need a doctor. It is an emergency. I need the police.':
      'Мне нужен врач. Это экстренная ситуация. Мне нужна полиция.',
  'Where is the bathroom? The bathroom is here. Where is the pharmacy? The pharmacy is near.':
      'Где туалет? Туалет здесь. Где аптека? Аптека близко.',
  'There is a table in the kitchen. The chair is next to the table. The bed is in the bedroom.':
      'На кухне есть стол. Стул рядом со столом. Кровать в спальне.',
  'Pablo has a brother. His brother is named Diego. Elena does not have siblings.':
      'У Пабло есть брат. Его брата зовут Диего. У Элены нет братьев и сестёр.',
  'Luis is not well. His head hurts. Luis needs a pharmacy. The pharmacy is nearby.':
      'Луису нехорошо. У него болит голова. Луису нужна аптека. Аптека рядом.',
  'Elena is at the station. She is not well. She says: I need a doctor. Pablo says: The hospital is there.':
      'Элена на станции. Ей нехорошо. Она говорит: мне нужен врач. Пабло говорит: больница там.',
  'Doctor: Do you have a fever? Luis: Yes, I have a fever. Doctor: Does your head hurt? Luis: No.':
      'Врач: у тебя температура? Луис: да, у меня температура. Врач: у тебя болит голова? Луис: нет.',
  'Ana goes by metro to the center. She feels bad. She asks: Where is the pharmacy? The pharmacy is near the hotel.':
      'Ана едет на метро в центр. Ей плохо. Она спрашивает: где аптека? Аптека рядом с отелем.',
  'Hello. Good morning. Good afternoon. Good evening. Goodbye.':
      'Привет. Доброе утро. Добрый день. Добрый вечер. До свидания.',
  "I don't understand. Repeat, please. More slowly, please. Yes. No. I don't understand.":
      'Я не понимаю. Повторите, пожалуйста. Медленнее, пожалуйста. Да. Нет. Я не понимаю.',
  "Hello. I am Ana. Good morning. You are Luis. Nice to meet you. Likewise. Thank you. You're welcome. Please, repeat. More slowly, please. Yes, I am Ana. No, you are Luis. Sorry, I don't understand. Good afternoon, ma'am. Good evening. See you later. Goodbye.":
      'Привет. Я Ана. Доброе утро. Ты Луис. Приятно познакомиться. И мне тоже приятно. Спасибо. Пожалуйста / не за что. Пожалуйста, повторите. Медленнее, пожалуйста. Да, я Ана. Нет, ты Луис. Извините, я не понимаю. Добрый день, сеньора. Добрый вечер. До встречи. До свидания.',
  'Hello. Good morning. Hello. Good afternoon. See you later. Good evening. Goodbye.':
      'Привет. Доброе утро. Привет. Добрый день. До встречи. Добрый вечер. До свидания.',
  "Please, repeat. Thank you. Thank you very much. You're welcome.":
      'Пожалуйста, повторите. Спасибо. Большое спасибо. Пожалуйста / не за что.',
  'Hello. I am from Madrid. Where are you from? I am from Mexico. I am from Spain.':
      'Привет. Я из Мадрида. Откуда ты? Я из Мексики. Я из Испании.',
  "Excuse me. Yes. Please. Thank you. You're welcome. Thank you. You're welcome.":
      'Извините. Да. Пожалуйста. Спасибо. Пожалуйста / не за что. Спасибо. Пожалуйста / не за что.',
  'How are you? Fine, thank you. Very well. Okay. Not well. So-so.':
      'Как дела? Хорошо, спасибо. Очень хорошо. Нормально. Плохо. Так себе.',
  'Hello. How are you? Hello. How are things?':
      'Привет. Как дела? Привет. Как дела?',
};

const _titleWords = {
  'A': 'Короткий',
  'A0': 'A0',
  'About': 'О',
  'Afternoon': 'Дневное',
  'Age': 'Возраст',
  'and': 'и',
  'And': 'И',
  'Asking': 'Вопрос',
  'Attention': 'Внимание',
  'Available': 'Доступен',
  'Availability': 'Наличие',
  'Basic': 'Базовый',
  'Book': 'Книга',
  'Class': 'Класс',
  'Clarification': 'Уточнение',
  'Communication': 'Общение',
  'Conversation': 'Разговор',
  'Directions': 'Направления',
  'Emergency': 'Экстренная ситуация',
  'Everyday': 'Повседневный',
  'Exchange': 'Обмен репликами',
  'Family': 'Семья',
  'First': 'Первый',
  'Food': 'Еда',
  'Friend': 'Друг',
  'Greeting': 'Приветствие',
  'Health': 'Здоровье',
  'Help': 'Помощь',
  'Home': 'Дом',
  'Identity': 'Личная информация',
  'Important': 'Важные',
  'In': 'В',
  'Integrated': 'Комплексный',
  'Is': 'Есть',
  'Item': 'Предмет',
  'Language': 'Язык',
  'Meeting': 'Встреча',
  'Morning': 'Утренняя',
  'Name': 'Имя',
  'Names': 'Имена',
  'Neighbour': 'Сосед',
  'New': 'Новый',
  'Number': 'Номер',
  'Objects': 'Предметы',
  'On': 'На',
  'Origin': 'Происхождение',
  'People': 'Люди',
  'Person': 'Человек',
  'Phone': 'Телефон',
  'Polite': 'Вежливый',
  'Price': 'Цена',
  'Question': 'Вопрос',
  'Questions': 'Вопросы',
  'Reading': 'Чтение',
  'Residence': 'Место проживания',
  'Review': 'Повторение',
  'Route': 'Маршрут',
  'School': 'Школа',
  'Services': 'Службы',
  'Shopping': 'Покупки',
  'Short': 'Короткий',
  'Simple': 'Простой',
  'Symptoms': 'Симптомы',
  'Table': 'Стол',
  'Thanks': 'Благодарность',
  'The': '',
  'There': 'Там',
  'This': 'Это',
  'Transport': 'Транспорт',
  'Two-Person': 'Для двух людей',
  'Water': 'Вода',
  'Where': 'Где',
  'With': 'С',
  'in': 'в',
  'on': 'на',
  'to': 'к',
  'the': '',
  'for': 'для',
};

const _exactTitle = {
  'Spanish A0': 'Испанский A0',
  'First Words and Reading': 'Первые слова и чтение',
  'Names and Introductions': 'Имена и представления',
  'Origin, Languages and Personal Identity':
      'Происхождение, языки и личная информация',
  'People and Everyday Conversation': 'Люди и повседневный разговор',
  'Shopping and Everyday Objects': 'Покупки и повседневные предметы',
  'Transport and Directions': 'Транспорт и направления',
  'Asking for Help': 'Как попросить о помощи',
  'Home and Family': 'Дом и семья',
  'Health and Integrated Communication': 'Здоровье и комплексное общение',
  'Main Activities': 'Основные задания',
  'Review Activities': 'Задания на повторение',
  'Checkpoint Activities': 'Задания контрольной проверки',
  'Vocabulary': 'Лексика',
  'Vocabulary Review': 'Повторение лексики',
  'Dialogue': 'Диалог',
  'Dialogue Review': 'Повторение диалога',
  'Reading': 'Чтение',
  'Reading Review': 'Повторение чтения',
  'Practice': 'Практика',
  'Practice Review': 'Повторение практики',
  'Pattern': 'Конструкция',
  'Grammar': 'Грамматика',
  'Usage': 'Употребление',
  'Reading Rule': 'Правило чтения',
  'Hello and Goodbye': 'Приветствие и прощание',
  'Please, Thank You, Sorry': 'Пожалуйста, спасибо, извините',
  'I Do Not Understand': 'Я не понимаю',
  'Morning and Evening Greetings': 'Утренние и вечерние приветствия',
  'My Name Is': 'Меня зовут',
  'What Is Your Name?': 'Как тебя зовут?',
  'First Words Review': 'Повторение первых слов',
  'Names and Introductions Review': 'Повторение имён и представлений',
  'I Am From': 'Я из...',
  'Where Are You From?': 'Откуда ты?',
  'Where Do You Live?': 'Где ты живёшь?',
  'Languages I Speak': 'Языки, на которых я говорю',
  'Identity Questions and Answers': 'Вопросы и ответы о себе',
  'Personal Identity Review': 'Повторение личной информации',
  'Module 3 Foundations Checkpoint': 'Контрольная проверка основ модуля 3',
  'Who Is This Person?': 'Кто этот человек?',
  'People and Roles': 'Люди и роли',
  'Basic Description': 'Простое описание',
  'Information About Another Person': 'Информация о другом человеке',
  'Everyday Questions and Answers': 'Повседневные вопросы и ответы',
  'Short Everyday Conversation': 'Короткий повседневный разговор',
  'People and Conversation Review': 'Повторение людей и разговора',
  'Module 4 People Checkpoint': 'Контрольная проверка модуля 4: люди',
  'What Is This?': 'Что это?',
  'Objects and Availability': 'Предметы и наличие',
  'Asking the Price': 'Как спросить цену',
  'Cheap or Expensive': 'Дёшево или дорого',
  'Asking for an Item': 'Как попросить предмет',
  'Basic Shopping Exchange': 'Простой разговор при покупке',
  'Shopping Review': 'Повторение покупок',
  'Shopping Checkpoint': 'Контрольная проверка покупок',
  'Transport': 'Транспорт',
  'Where Is It?': 'Где это?',
  'Left, Right and Straight': 'Налево, направо и прямо',
  'Near and Far': 'Близко и далеко',
  'How Do I Get There?': 'Как туда добраться?',
  'Transport and Route Exchange': 'Разговор о транспорте и маршруте',
  'Transport and Directions Review': 'Повторение транспорта и направлений',
  'Transport and Directions Checkpoint':
      'Контрольная проверка транспорта и направлений',
  'Getting Attention': 'Как привлечь внимание',
  'Communication Problems': 'Проблемы в общении',
  'Finding Important Services': 'Как найти важные службы',
  'Simple Emergency Needs': 'Простые срочные потребности',
  'Integrated Help Dialogue': 'Комплексный диалог о помощи',
  'Asking for Help Review': 'Повторение просьб о помощи',
  'Asking for Help Checkpoint': 'Контрольная проверка просьб о помощи',
  'Silent h and Stable Vowels': 'Немая h и устойчивые гласные',
  'ñ, j and ll in Names': 'ñ, j и ll в именах',
  'Nice to Meet You': 'Приятно познакомиться',
  'Introduction Dialogue Practice': 'Практика диалога знакомства',
  'My Family': 'Моя семья',
  'Names and Family Information': 'Имена и информация о семье',
  'Brothers, Sisters and Simple Questions': 'Братья, сёстры и простые вопросы',
  'Rooms in the Home': 'Комнаты в доме',
  'Objects and Location': 'Предметы и местоположение',
  'Describing a Home and Family': 'Описание дома и семьи',
  'Integrated Family and Home Conversation':
      'Комплексный разговор о семье и доме',
  'Home and Family Review': 'Повторение дома и семьи',
  'Home and Family Checkpoint': 'Контрольная проверка дома и семьи',
  'How Do You Feel?': 'Как ты себя чувствуешь?',
  'Basic Symptoms': 'Основные симптомы',
  'Basic Health Questions': 'Простые вопросы о здоровье',
  'Doctor and Pharmacy Requests': 'Просьбы о враче и аптеке',
  'Understanding Simple Help': 'Понимание простой помощи',
  'Basic Health Exchange': 'Простой разговор о здоровье',
  'Integrated Everyday Help': 'Комплексная повседневная помощь',
  'Integrated A0 Communication': 'Комплексное общение A0',
  'Health and Integrated Communication Review':
      'Повторение здоровья и комплексного общения',
  'Health and Integrated Communication Checkpoint':
      'Контрольная проверка здоровья и комплексного общения',
  'Finding the pharmacy': 'Как найти аптеку',
  'Need for a service': 'Нужна служба',
  'Please Repeat': 'Пожалуйста, повторите',
  'More Courtesy': 'Ещё вежливые фразы',
  'How Are You?': 'Как дела?',
  'Greetings by Time of Day': 'Приветствия по времени дня',
  'Greetings by time of day': 'Приветствия по времени дня',
  'Silent h': 'Немая h',
  'Tener for fever': 'Tener для температуры',
  'Ana says hello': 'Ана здоровается',
  'Numbers Eleven to Twenty': 'Числа от одиннадцати до двадцати',
  'Numbers Zero to Ten': 'Числа от нуля до десяти',
  'Profile Cards': 'Карточки профилей',
  'Introduction Directory': 'Список знакомств',
  'Marta profile': 'Профиль Марты',
  'Small price list': 'Короткий список цен',
  'Direction note': 'Записка с направлением',
  'Station location': 'Где находится станция',
  'Sibling note': 'Заметка о братьях и сёстрах',
  'Final A0 profile': 'Итоговый профиль A0',
  'Luis is not well': 'Луису нехорошо',
  'Recognizing Greetings': 'Распознавание приветствий',
  'More Slowly, Please': 'Медленнее, пожалуйста',
  'Clarification in Class': 'Уточнение на уроке',
  'Morning Meeting': 'Утренняя встреча',
  'Objects on the Table': 'Предметы на столе',
  'New Neighbour': 'Новый сосед',
  'Introductions Review': 'Повторение представлений',
  'Meeting at School': 'Встреча в школе',
  'Two-Person Identity Exchange': 'Обмен личной информацией',
  'Greeting, Name and Origin': 'Приветствие, имя и происхождение',
  'Introducing Another Person': 'Как представить другого человека',
  'Choosing Transport to the Center': 'Выбор транспорта до центра',
  'Question Where the Station Is': 'Вопрос о том, где станция',
  'Requesting urgent help': 'Срочная просьба о помощи',
  'Getting help politely': 'Вежливая просьба о помощи',
  'Identifying family': 'Как назвать членов семьи',
  'Negative sibling answer': 'Отрицательный ответ о братьях и сёстрах',
  'Home and rooms': 'Дом и комнаты',
  'Integrated A0 situation': 'Комплексная ситуация A0',
  'Integrated health help exchange': 'Комплексный разговор о здоровье и помощи',
  'Greeting Exchange': 'Обмен приветствиями',
  'You speak Spanish?': 'Ты говоришь по-испански?',
  'Unit 1 Review': 'Повторение модуля 1',
  'Introducing another person': 'Как представить другого человека',
  'Me llamo + name': 'Me llamo + имя',
  'Introduction origin seed': 'Основа происхождения в представлении',
  'Third-person identity facts': 'Факты о человеке в третьем лице',
  'Location with estar at home': 'Местоположение дома с estar',
  'Saying your name: me llamo': 'Как назвать своё имя: me llamo',
  'Needing help': 'Нужна помощь',
  "Marta's family profile": 'Профиль семьи Марты',
  'Yes/no questions about a person': 'Вопросы да/нет о человеке',
  'A0 Checkpoint': 'Контрольная проверка A0',
  'Question if an item is available': 'Вопрос о наличии предмета',
  'Person at home': 'Человек дома',
  'Do You Speak Spanish?': 'Ты говоришь по-испански?',
  'A simple greeting': 'Простое приветствие',
};

const _vocabulary = {
  'hello': 'привет',
  'goodbye': 'до свидания',
  'good morning': 'доброе утро',
  'good afternoon': 'добрый день',
  'good evening': 'добрый вечер',
  'good evening; good night': 'добрый вечер; спокойной ночи',
  'thank you': 'спасибо',
  'thank you very much': 'большое спасибо',
  "you're welcome": 'пожалуйста / не за что',
  'please': 'пожалуйста',
  'sorry': 'извините',
  'excuse me / pardon me': 'извините / простите',
  "I don't understand": 'я не понимаю',
  "I don't know": 'я не знаю',
  'repeat': 'повторите',
  'a little': 'немного',
  'yes': 'да',
  'no': 'нет',
  'fine': 'хорошо',
  'very well': 'очень хорошо',
  'bad; not well': 'плохо; нездоровится',
  'I am well': 'я в порядке',
  'I am not well': 'мне нехорошо',
  'I feel bad / I am unwell': 'мне плохо / я плохо себя чувствую',
  'I am hungry': 'я голоден / голодна',
  'hunger': 'голод',
  'I': 'я',
  'I am': 'я есть / я являюсь',
  'I have': 'у меня есть',
  'you have': 'у тебя есть',
  'he/she has': 'у него/неё есть',
  'he/she has; you have': 'у него/неё есть; у вас есть',
  'I need': 'мне нужен / нужна',
  'I want': 'я хочу',
  'I speak': 'я говорю',
  'speaks': 'говорит',
  'I live': 'я живу',
  'I go / I am going': 'я еду / иду',
  'from; of': 'из; от',
  'from where': 'откуда',
  'where': 'где',
  'the': 'определённый артикль',
  'is': 'есть / находится',
  'in': 'в',
  'and': 'и',
  'but': 'но',
  'also': 'тоже',
  'book': 'книга',
  'phone': 'телефон',
  'key': 'ключ',
  'table': 'стол',
  'chair': 'стул',
  'water': 'вода',
  'bread': 'хлеб',
  'cheese': 'сыр',
  'coffee': 'кофе',
  'food': 'еда',
  'bag': 'сумка',
  'bottle': 'бутылка',
  'number': 'номер / число',
  'zero': 'ноль',
  'one': 'один',
  'two': 'два',
  'three': 'три',
  'four': 'четыре',
  'five': 'пять',
  'six': 'шесть',
  'seven': 'семь',
  'eight': 'восемь',
  'ten': 'десять',
  'eleven': 'одиннадцать',
  'twelve': 'двенадцать',
  'fourteen': 'четырнадцать',
  'fifteen': 'пятнадцать',
  'sixteen': 'шестнадцать',
  'seventeen': 'семнадцать',
  'eighteen': 'восемнадцать',
  'nineteen': 'девятнадцать',
  'twenty': 'двадцать',
  'years': 'лет / годы',
  'family': 'семья',
  'mother': 'мама / мать',
  'father': 'папа / отец',
  'brother': 'брат',
  'sister': 'сестра',
  'brothers or siblings': 'братья или братья и сёстры',
  'grandmother': 'бабушка',
  'grandfather': 'дедушка',
  'daughter': 'дочь',
  'son': 'сын',
  'friend': 'друг / подруга',
  'female friend': 'подруга',
  'male friend': 'друг',
  'female teacher': 'учительница / преподавательница',
  'teacher': 'учитель / преподаватель',
  'student': 'ученик / студент',
  'female classmate / colleague': 'одноклассница / коллега',
  'house / home': 'дом',
  'house; home': 'дом',
  'apartment / flat': 'квартира',
  'kitchen': 'кухня',
  'bedroom': 'спальня',
  'bathroom': 'ванная / туалет',
  'bathroom / toilet': 'туалет',
  'bed': 'кровать',
  'door': 'дверь',
  'here': 'здесь',
  'there': 'там',
  'near': 'близко',
  'far': 'далеко',
  'left': 'налево / левый',
  'right': 'направо / правый',
  'straight': 'прямо',
  'continue / go straight': 'продолжайте / идите прямо',
  'go (command)': 'идите / езжайте',
  'turn left': 'поверните налево',
  'turn right': 'поверните направо',
  'bus': 'автобус',
  'metro': 'метро',
  'taxi': 'такси',
  'train': 'поезд',
  'car': 'машина',
  'bicycle': 'велосипед',
  'station': 'станция',
  'stop': 'остановка',
  'street': 'улица',
  'hotel': 'отель',
  'center / downtown': 'центр',
  'hospital': 'больница',
  'pharmacy': 'аптека',
  'doctor': 'врач',
  'female doctor / doctor': 'врач',
  'police': 'полиция',
  'help': 'помощь',
  'help me': 'помогите мне',
  'emergency': 'экстренная ситуация',
  'an emergency': 'экстренная ситуация',
  'fever': 'температура / жар',
  'head': 'голова',
  'stomach': 'живот',
  'throat': 'горло',
  'pain': 'боль',
  '... hurts me': 'у меня болит...',
  'Does ... hurt?': '... болит?',
  'What is wrong with you?': 'Что с тобой?',
  'What is happening? / What is wrong?': 'Что случилось? / Что не так?',
  'cheap (masculine)': 'дешёвый',
  'cheap (feminine)': 'дешёвая',
  'expensive (masculine)': 'дорогой',
  'expensive (feminine)': 'дорогая',
  'euro': 'евро',
  'euros': 'евро',
  'anything else': 'что-нибудь ещё',
  'here you are': 'вот, пожалуйста',
  'Mr.; sir': 'сеньор; господин',
  "Mrs.; ma'am": 'сеньора; госпожа',
  'Spanish': 'испанский',
  'English': 'английский',
  'Russian': 'русский',
  'Ukrainian': 'украинский',
  'Mexican': 'мексиканец / мексиканка',
  'how': 'как',
  'how are you?': 'как дела?',
  'how are things?': 'как дела?',
  'how do I get': 'как мне добраться',
  'how do I go': 'как мне ехать / идти',
  'how many': 'сколько',
  'how much does it cost': 'сколько это стоит',
  'call': 'звать / звонить',
  'his/her name is': 'его/её зовут',
  'do you speak Spanish?': 'ты говоришь по-испански?',
  'do you have / has (polite fixed shopping form)':
      'у вас есть / есть (вежливая торговая форма)',
  'Can you help me?': 'Вы можете мне помочь?',
  'Do you have a fever?': 'У тебя температура?',
};

const _embedded = {
  'I am from Ukraine.': 'Я из Украины.',
  'I am from Ukraine': 'Я из Украины',
  'I am from Mexico.': 'Я из Мексики.',
  'I am from Colombia.': 'Я из Колумбии.',
  'I am from Chile. I live in Bogotá.': 'Я из Чили. Я живу в Боготе.',
  'I am from Madrid.': 'Я из Мадрида.',
  'I am from Valencia.': 'Я из Валенсии.',
  'I live in Kyiv.': 'Я живу в Киеве.',
  'I live in Valencia.': 'Я живу в Валенсии.',
  'I speak Spanish.': 'Я говорю по-испански.',
  'I speak Ukrainian and Russian.': 'Я говорю по-украински и по-русски.',
  'I speak a little Spanish.': 'Я немного говорю по-испански.',
  'I speak a little English.': 'Я немного говорю по-английски.',
  'My name is Ana.': 'Меня зовут Ана.',
  'My name is Carlos.': 'Меня зовут Карлос.',
  'My name is Elena.': 'Меня зовут Элена.',
  'My name is Javier.': 'Меня зовут Хавьер.',
  'My name is Marta.': 'Меня зовут Марта.',
  'My name is Miguel.': 'Меня зовут Мигель.',
  'My name is Lucia.': 'Меня зовут Лусия.',
  'What is your name?': 'Как тебя зовут?',
  'Where are you from?': 'Откуда ты?',
  'Where do you live?': 'Где ты живёшь?',
  'Which languages do you speak?': 'На каких языках ты говоришь?',
  'I am well': 'мне хорошо',
  'I am well.': 'Мне хорошо.',
  'I have a fever': 'у меня температура',
  'h is silent': 'h не произносится',
  'h sounds like English h': 'h звучит как английская h',
  'Hello, my name is Luis.': 'Привет, меня зовут Луис.',
  'seventeen': 'семнадцать',
  'my family': 'моя семья',
  'my table': 'мой стол',
  'My name is': 'меня зовут',
  'See you later': 'до встречи',
  'I do not understand': 'я не понимаю',
  'you are hungry': 'ты голоден / голодна',
  'you are right': 'ты прав / права',
  'Hello, Valencia.': 'Привет, Валенсия.',
  'which language the person speaks': 'на каком языке говорит человек',
  'where the person is from': 'откуда человек',
  'where the person lives': 'где человек живёт',
  'a language Marta speaks': 'язык, на котором говорит Марта',
  'where Marta is from': 'откуда Марта',
  'where Marta lives': 'где живёт Марта',
  'Carlos’s friend': 'друг Карлоса',
  'Carlos’s teacher': 'учительница Карлоса',
  'a student': 'ученик / студент',
  'a price': 'цена',
  'Name a sister': 'Назовите сестру',
  'Repeat the message': 'Повторите сообщение',
  'Where is it?': 'Где это?',
  'bad': 'плохо',
  'are': 'являются',
  'written': 'пишутся',
  'accents': 'ударения',
  'normally': 'обычно',
  'begin': 'начинаются',
  'end': 'заканчиваются',
  'change': 'меняйте',
  'changes': 'меняется',
  'when': 'когда',
  'Before': 'Перед',
  'before': 'перед',
  'represents': 'передаёт',
  'hard': 'твёрдый',
  'such': 'такие',
  'often': 'часто',
  'more': 'более',
  'regular': 'регулярное',
  'than': 'чем',
  'stable': 'устойчивые',
  'own': 'собственная',
  'mark': 'обозначать',
  'stress': 'ударение',
  'safe': 'безопасная',
  'beginner': 'начальный',
  'subject': 'подлежащее',
  'complement': 'дополнение',
  'omits': 'опускает',
  'already': 'уже',
  'shows': 'показывает',
  'fit': 'соответствуют',
  'time': 'время',
  'day': 'дня',
  'boundaries': 'границы',
  'flexible': 'гибкие',
  'choices': 'варианты',
  'rather': 'скорее',
  'clock': 'часы',
  'intact': 'без изменений',
  'rearrange': 'переставляйте',
  'randomly': 'случайно',
  'vary': 'меняться',
  'memorized': 'запоминать',
  'chunks': 'фрагменты',
  'Pronunciation': 'Произношение',
  'pronunciation': 'произношение',
  'possessions': 'обладание',
  'uses': 'использует',
  'expressions': 'выражения',
  'expression': 'выражение',
  'mistake': 'ошибка',
  'translating': 'перевод',
  'usually': 'обычно',
  'pronounced': 'произносится',
  'still': 'всё ещё',
  'stays': 'остаётся',
  'clear': 'ясный',
  'night': 'ночью',
  'works': 'работает',
  'any': 'любое',
  'Notice': 'Обратите внимание на',
  'notice': 'обратите внимание на',
  'meeting': 'знакомство',
  'current': 'текущее',
  'tiny': 'короткий',
  'personal': 'личный',
  'little': 'немного',
  'swap': 'меняйте местами',
  'specific': 'конкретное',
  'part': 'часть',
  'different': 'разные',
  'are you from Spain?': 'ты из Испании?',
  'is your name Spanish?': 'тебя зовут Spanish?',
  'what is your name?': 'как тебя зовут?',
  'where are you from?': 'откуда ты?',
  'Goodbye, Ana': 'До свидания, Ана',
  'nice to meet you': 'приятно познакомиться',
  'Good morning, Madrid': 'Доброе утро, Мадрид',
  'How are you, Ana? I speak Spanish.': 'Как дела, Ана? Я говорю по-испански.',
  'You are Ana': 'Ты Ана',
  'my': 'мой / моя',
  'nine': 'девять',
  'what': 'что',
  'who': 'кто',
  'reason; right': 'причина; правота',
  'thirst': 'жажда',
  'means': 'означает',
  'thirteen': 'тринадцать',
  'your': 'твой / твоя',
  'a; one': 'неопределённый артикль; один',
  'vowel': 'гласный звук',
  'to have': 'иметь',
  'you speak': 'ты говоришь',
  'language': 'язык',
  'languages': 'языки',
  'person': 'человек',
  'you live': 'ты живёшь',
  'tall (feminine)': 'высокая',
  'tall (masculine)': 'высокий',
  'girl / young woman': 'девушка',
  'boy / young man': 'парень / молодой человек',
  'what is he/she like': 'какой он / какая она',
  'male classmate / colleague': 'одноклассник / коллега',
  'he': 'он',
  'she': 'она',
  'is / he is / she is': 'есть / он — / она —',
  'man': 'мужчина',
  'young': 'молодой',
  'woman': 'женщина',
  'very': 'очень',
  'is not': 'не является / не есть',
  'male teacher': 'учитель / преподаватель',
  'serious (feminine)': 'серьёзная',
  'serious (masculine)': 'серьёзный',
  'nice / friendly (feminine)': 'милая / дружелюбная',
  'nice / friendly (masculine)': 'милый / дружелюбный',
  'lives': 'живёт',
  'pen': 'ручка',
  'to buy': 'покупать',
  'it costs': 'это стоит',
  'this (feminine)': 'эта',
  'this (masculine)': 'этот',
  'this / this thing': 'это',
  'pencil': 'карандаш',
  'nothing else': 'больше ничего',
  'price': 'цена',
  'they are / it is (price total)': 'они есть / это стоит (итоговая цена)',
  'we have': 'у нас есть',
  'one / a (feminine)': 'одна / неопределённый артикль женского рода',
  'on foot': 'пешком',
  'where is': 'где находится',
  'turn': 'поверни / поворачивает',
  'supermarket': 'супермаркет',
  'take (command)': 'возьми / сядь на',
  'transport': 'транспорт',
  'of course / sure': 'конечно',
  'speak': 'говорить',
  'speak more slowly': 'говорите медленнее',
  'can you / can he or she': 'можете вы / может он или она',
  'service': 'служба / услуга',
  'next to': 'рядом с',
  'is located / is': 'находится / есть',
  'room': 'комната',
  'there is / there are': 'есть / имеется',
  'my, plural': 'мои',
  'living room': 'гостиная',
  'window': 'окно',
  'rest': 'отдых',
  'sick, feminine': 'больная',
  'sick, masculine': 'больной',
  'so-so': 'так себе',
  'well; fine': 'хорошо; нормально',
  'you are': 'ты есть / ты являешься',
  'see you later': 'до встречи',
  'likewise': 'и мне тоже приятно',
  'more slowly': 'медленнее',
  'my name is': 'меня зовут',
  'okay; not great': 'нормально; не очень хорошо',
  'you': 'ты / вы',
  'A bicycle.': 'Велосипед.',
  'A street.': 'Улица.',
  'A car.': 'Машина.',
  'A pharmacy.': 'Аптека.',
  'A hospital.': 'Больница.',
  'A hotel.': 'Отель.',
  'A supermarket.': 'Супермаркет.',
  'Controlled informal direction.':
      'Ограниченная неформальная команда направления.',
  'Controlled informal instruction.': 'Ограниченная неформальная инструкция.',
  'Polite way to attract attention.': 'Вежливый способ привлечь внимание.',
  'Polite fixed request when speech is too fast.':
      'Вежливая устойчивая просьба, когда речь слишком быстрая.',
  'Polite fixed form used in emergency requests.':
      'Вежливая устойчивая форма для срочных просьб.',
  'Feminine sibling term.': 'Слово женского рода для сестры.',
  'Masculine sibling term.': 'Слово мужского рода для брата.',
  'Feminine child term.': 'Слово женского рода для дочери.',
  'Masculine child term.': 'Слово мужского рода для сына.',
  'Controlled possessive used before one noun.':
      'Ограниченное притяжательное слово перед одним существительным.',
  'Controlled gender pair.': 'Ограниченная пара по роду.',
  'Question chunk only.': 'Только фрагмент вопроса.',
  'Used in the morning.': 'Используется утром.',
  'A friendly farewell.': 'Дружеское прощание.',
  'Informal singular you.': 'Неформальное «ты» в единственном числе.',
  'I have a fever.': 'У меня температура.',
  'I have a book.': 'У меня есть книга.',
  'I have water': 'у меня есть вода',
  'I have water.': 'У меня есть вода.',
  'I have a phone.': 'У меня есть телефон.',
  'I have a key.': 'У меня есть ключ.',
  'I have two books.': 'У меня есть две книги.',
  'I have bread and cheese.': 'У меня есть хлеб и сыр.',
  'I want water, please.': 'Я хочу воды, пожалуйста.',
  'I want one bottle.': 'Я хочу одну бутылку.',
  'I want this bag, please.': 'Я хочу эту сумку, пожалуйста.',
  'I need help.': 'Мне нужна помощь.',
  'I need a doctor.': 'Мне нужен врач.',
  'I need the police.': 'Мне нужна полиция.',
  'I need a pharmacy.': 'Мне нужна аптека.',
  'It is near.': 'Это близко.',
  'It is far.': 'Это далеко.',
  'It is an emergency.': 'Это экстренная ситуация.',
  'It is a bag.': 'Это сумка.',
  'It costs three euros.': 'Это стоит три евро.',
  'Take the bus.': 'Садитесь на автобус.',
  'Take the metro.': 'Садитесь на метро.',
  'Turn left.': 'Поверните налево.',
  'Turn right.': 'Поверните направо.',
  'Go straight.': 'Идите прямо.',
  'Go straight. Turn right.': 'Идите прямо. Поверните направо.',
  'Go straight. Turn left.': 'Идите прямо. Поверните налево.',
  'Please speak more slowly.': 'Говорите медленнее, пожалуйста.',
  'Please repeat.': 'Повторите, пожалуйста.',
  'Excuse me. I need the police.': 'Извините. Мне нужна полиция.',
  'Excuse me. I need help.': 'Извините. Мне нужна помощь.',
  'Nothing else, thank you.': 'Больше ничего, спасибо.',
};

const _exactPrompt = {
  'Choose the correct meaning.': 'Выберите правильное значение.',
  'Choose the correctly written direct question word.':
      'Выберите правильно написанное вопросительное слово.',
  'Choose the name or word that contains ñ.':
      'Выберите имя или слово с буквой ñ.',
  'Choose the word that contains ñ.': 'Выберите слово с буквой ñ.',
  'Choose the word that begins with qu.':
      'Выберите слово, которое начинается с qu.',
  'Choose the word where h is silent.':
      'Выберите слово, где h не произносится.',
  'Match each short answer with its English meaning.':
      'Соотнесите каждый короткий ответ с его русским значением.',
  'Match each Spanish first word to its meaning.':
      'Соотнесите каждое первое испанское слово с его значением.',
  'Match each Spanish introduction phrase to its meaning.':
      'Соотнесите каждую испанскую фразу знакомства с её значением.',
  'Match Unit 1 first-contact phrases with their English meanings.':
      'Соотнесите фразы первого контакта из модуля 1 с их русскими значениями.',
};

const _exact = {
  'Greet and say goodbye.': 'Поздоровайтесь и попрощайтесь.',
  'Greet someone and say goodbye with short Spanish phrases.':
      'Поздоровайтесь и попрощайтесь короткими испанскими фразами.',
  'Greet and say goodbye with hola, adiós, and hasta luego.':
      'Поздоровайтесь и попрощайтесь с hola, adiós и hasta luego.',
  'A simple greeting used at any time of day.':
      'Простое приветствие, которое можно использовать в любое время дня.',
  'A common way to say goodbye.': 'Частотный способ попрощаться.',
  'Used in the evening, at night, or when saying good night.':
      'Используется вечером, ночью или когда желают спокойной ночи.',
  'Used in the afternoon or early evening.':
      'Используется днём или ранним вечером.',
  'Use basic courtesy words.': 'Используйте базовые слова вежливости.',
  'Ask for repetition or slower speech.':
      'Попросите повторить или говорить медленнее.',
  'Choose an appropriate greeting by context.':
      'Выберите подходящее приветствие по ситуации.',
  'Say a name with me llamo.': 'Назовите имя с помощью me llamo.',
  'Ask and answer a name question.':
      'Задайте вопрос об имени и ответьте на него.',
  'Say where you are from.': 'Скажите, откуда вы.',
  'Ask where someone is from.': 'Спросите, откуда человек.',
  'Say and ask where someone lives.': 'Скажите и спросите, где человек живёт.',
  'Say which languages you speak.': 'Скажите, на каких языках вы говорите.',
  'Ask and answer basic identity questions.':
      'Задайте и ответьте на базовые вопросы о себе.',
  'Review basic personal identity.': 'Повторите базовую личную информацию.',
  'Complete the Module 3 foundations checkpoint.':
      'Выполните контрольную проверку основ модуля 3.',
  'Correct in this context.': 'Верно в этом контексте.',
  'Not correct yet.': 'Пока неверно.',
  'Accepted with correction.': 'Принято с исправлением.',
};

const _wordReplacements = {
  'Very short Spanish sentences often use subject plus verb plus the rest of the idea.':
      'Очень короткие испанские предложения часто используют подлежащее, глагол и остальную часть мысли.',
  'are': 'являются',
  'written': 'пишутся',
  'accents': 'ударения',
  'normally': 'обычно',
  'begin': 'начинаются',
  'end': 'заканчиваются',
  'change': 'меняйте',
  'changes': 'меняется',
  'when': 'когда',
  'Before': 'Перед',
  'before': 'перед',
  'represents': 'передаёт',
  'hard': 'твёрдый',
  'such': 'такие',
  'often': 'часто',
  'more': 'более',
  'regular': 'регулярное',
  'than': 'чем',
  'stable': 'устойчивые',
  'own': 'собственная',
  'mark': 'обозначать',
  'stress': 'ударение',
  'safe': 'безопасная',
  'beginner': 'начальный',
  'subject': 'подлежащее',
  'complement': 'дополнение',
  'omits': 'опускает',
  'already': 'уже',
  'shows': 'показывает',
  'fit': 'соответствуют',
  'time': 'время',
  'day': 'дня',
  'boundaries': 'границы',
  'flexible': 'гибкие',
  'choices': 'варианты',
  'rather': 'скорее',
  'clock': 'часы',
  'intact': 'без изменений',
  'rearrange': 'переставляйте',
  'randomly': 'случайно',
  'vary': 'меняться',
  'memorized': 'запоминать',
  'chunks': 'фрагменты',
  'Pronunciation': 'Произношение',
  'pronunciation': 'произношение',
  'possessions': 'обладание',
  'uses': 'использует',
  'expressions': 'выражения',
  'expression': 'выражение',
  'mistake': 'ошибка',
  'translating': 'перевод',
  'usually': 'обычно',
  'pronounced': 'произносится',
  'still': 'всё ещё',
  'stays': 'остаётся',
  'clear': 'ясный',
  'night': 'ночью',
  'works': 'работает',
  'any': 'любое',
  'Notice': 'Обратите внимание на',
  'notice': 'обратите внимание на',
  'meeting': 'знакомство',
  'current': 'текущее',
  'tiny': 'короткий',
  'personal': 'личный',
  'little': 'немного',
  'swap': 'меняйте местами',
  'specific': 'конкретное',
  'part': 'часть',
  'different': 'разные',
  'Contrast': 'Сравните',
  'contrast': 'различие',
  'contrasts': 'сравнивает',
  'practiced': 'отработанные',
  'together': 'вместе',
  'an': '',
  'be': 'быть',
  'total': 'итог',
  'prices': 'цены',
  'teach': 'учит',
  'full': 'полный',
  'produce': 'составляйте',
  'system': 'система',
  'focus': 'цель',
  'recognizing': 'распознавание',
  'naming': 'называние',
  'rooms': 'комнаты',
  'medical': 'медицинское',
  'explanation': 'объяснение',
  'requests': 'просьбы',
  'action': 'действие',
  'direct': 'прямой',
  'broad': 'широкая',
  'lesson': 'урок',
  'using': 'используя',
  'course': 'курс',
  'group': 'группировать',
  'identification': 'определение',
  'app': 'приложение',
  'naturally': 'естественно',
  'Assess': 'Проверьте',
  'assess': 'проверьте',
  'early': 'ранние',
  'descriptions': 'описания',
  'facts': 'факты',
  'introductions': 'представления',
  'varied': 'разные',
  'relying': 'опоры',
  'integrated': 'комплексное',
  'Actively': 'Активно',
  'actively': 'активно',
  'whole': 'весь',
  'covering': 'охватывающая',
  'mixed': 'смешанная',
  'Cards': 'карточки',
  'cards': 'карточки',
  'bad': 'плохо',
  'Basics': 'основы',
  'identity': 'личная информация',
  'greetings': 'приветствия',
  'Some': 'Некоторые',
  'some': 'некоторые',
  'final': 'конечный',
  'teaches': 'учит',
  'pairs': 'пары',
  'lessons': 'уроки',
  'adjective': 'прилагательное',
  'agreement': 'согласование',
  'description': 'описание',
  'add': 'добавьте',
  'fact': 'факт',
  'roles': 'роли',
  'My name is': 'меня зовут',
  'my name is': 'меня зовут',
  'What is your name': 'как тебя зовут',
  'what is your name': 'как тебя зовут',
  'Where are you from': 'откуда ты',
  'where are you from': 'откуда ты',
  'Where do you live': 'где ты живёшь',
  'where do you live': 'где ты живёшь',
  'Which languages do you speak': 'на каких языках ты говоришь',
  'which languages do you speak': 'на каких языках ты говоришь',
  'How are you': 'как дела',
  'how are you': 'как дела',
  'How do I get': 'как мне добраться',
  'how do I get': 'как мне добраться',
  'How much does it cost': 'сколько это стоит',
  'how much does it cost': 'сколько это стоит',
  'Can you help me': 'вы можете мне помочь',
  'can you help me': 'вы можете мне помочь',
  'Do you have': 'у тебя есть',
  'do you have': 'у тебя есть',
  'I do not understand': 'я не понимаю',
  "I don't understand": 'я не понимаю',
  'I am from': 'я из',
  'I live in': 'я живу в',
  'I speak': 'я говорю',
  'I have': 'у меня есть',
  'I need': 'мне нужно',
  'I want': 'я хочу',
  'I am': 'я',
  'You are': 'ты',
  'you are': 'ты',
  'You have': 'у тебя есть',
  'you have': 'у тебя есть',
  'He is': 'он',
  'he is': 'он',
  'She is': 'она',
  'she is': 'она',
  'She': 'она',
  'she': 'она',
  'He': 'он',
  'he': 'он',
  'You': 'ты',
  'you': 'ты',
  'He lives': 'он живёт',
  'he lives': 'он живёт',
  'She lives': 'она живёт',
  'she lives': 'она живёт',
  'He speaks': 'он говорит',
  'he speaks': 'он говорит',
  'She speaks': 'она говорит',
  'she speaks': 'она говорит',
  'His name is': 'его зовут',
  'his name is': 'его зовут',
  'Her name is': 'её зовут',
  'her name is': 'её зовут',
  'Good morning': 'доброе утро',
  'Good afternoon': 'добрый день',
  'Good evening': 'добрый вечер',
  'See you later': 'до встречи',
  'Thank you very much': 'большое спасибо',
  'Thank you': 'спасибо',
  "You're welcome": 'пожалуйста / не за что',
  'Nice to meet you': 'приятно познакомиться',
  'Repeat, please': 'повторите, пожалуйста',
  'More slowly, please': 'медленнее, пожалуйста',
  'Please repeat': 'повторите, пожалуйста',
  'Please wait': 'подождите, пожалуйста',
  'Excuse me': 'извините',
  'What is wrong': 'что случилось',
  'of course': 'конечно',
  'a little': 'немного',
  'first-contact': 'первого контакта',
  'first contact': 'первый контакт',
  'everyday': 'повседневный',
  'farewell': 'прощание',
  'customer': 'покупатель',
  'opening': 'начало',
  'sequence': 'последовательность',
  'spoken': 'произнесённый',
  'Choosing': 'выберите',
  'choosing': 'выбор',
  'which': 'какой',
  'Which': 'какой',
  'transport choice': 'выбор транспорта',
  'greet': 'поздоровайтесь',
  'introduce': 'представьте',
  'introduction': 'представление',
  'yourself': 'себя',
  'says': 'говорит',
  'limited': 'ограниченный',
  'ability': 'умение',
  'both': 'оба',
  'identifies': 'определяет',
  'third-person': 'третьего лица',
  'third': 'третьего лица',
  'like': 'какой',
  'verb': 'глагол',
  'negative': 'отрицательный',
  'female': 'женский род',
  'politely': 'вежливо',
  'whether': 'есть ли',
  'much': 'много',
  'costs': 'стоит',
  'nothing': 'ничего',
  'else': 'ещё',
  'Anything': 'что-нибудь',
  'anything': 'что-нибудь',
  'seller': 'продавец',
  'article': 'артикль',
  'sign': 'табличка',
  'Sign': 'табличка',
  'closing': 'заключительный',
  'response': 'ответ',
  'command': 'команда',
  'commands': 'команды',
  'exact': 'точный',
  'Give': 'Введите',
  'give': 'дайте',
  'get': 'добраться',
  'foot': 'пешком',
  'way': 'способ',
  'attract': 'привлечь',
  'understand': 'понимаете',
  'describe': 'опишите',
  'house': 'дом',
  'fictional': 'учебный',
  'statement': 'утверждение',
  'feel': 'чувствую себя',
  'Buy': 'Купить',
  'buy': 'купить',
  'needing': 'когда нужна',
  'speech': 'речь',
  'Match': 'Соотнесите',
  'match': 'соотнесите',
  'each': 'каждый',
  'expressed': 'выражается',
  'nouns': 'существительные',
  'try': 'старайтесь',
  'memorize': 'запоминать',
  'all': 'все',
  'rules': 'правила',
  'yet': 'пока',
  'locates': 'указывает местоположение',
  'grandmother': 'бабушка',
  'Diagnostic': 'Диагностический',
  'diagnostic': 'диагностический',
  'used': 'используется',
  'these': 'эти',
  'lines': 'реплики',
  'note': 'заметка',
  'read': 'прочитайте',
  'rule': 'правило',
  'by': '',
  'its': 'нужный',
  'if': 'если',
  'Module': 'модуль',
  'module': 'модуль',
  'and': 'и',
  'or': 'или',
  'in': 'в',
  'on': 'на',
  'to': 'к',
  'the': '',
  'hello': 'привет',
  'goodbye': 'до свидания',
  'thanks': 'спасибо',
  'thank': 'спасибо',
  'please': 'пожалуйста',
  'yes': 'да',
  'no': 'нет',
  'fine': 'хорошо',
  'well': 'хорошо',
  'hungry': 'голоден / голодна',
  'right': 'прав / права',
  'later': 'позже',
  'morning': 'утро',
  'afternoon': 'день',
  'evening': 'вечер',
  'book': 'книга',
  'books': 'книги',
  'water': 'вода',
  'food': 'еда',
  'bread': 'хлеб',
  'cheese': 'сыр',
  'coffee': 'кофе',
  'key': 'ключ',
  'phone': 'телефон',
  'table': 'стол',
  'chair': 'стул',
  'bag': 'сумка',
  'bottle': 'бутылка',
  'notebook': 'тетрадь',
  'pencil': 'карандаш',
  'pen': 'ручка',
  'price': 'цена',
  'purchase': 'покупка',
  'shop': 'магазин',
  'board': 'табличка',
  'receipt': 'чек',
  'available': 'доступен',
  'availability': 'наличие',
  'cheap': 'дешёвый',
  'expensive': 'дорогой',
  'euro': 'евро',
  'euros': 'евро',
  'number': 'число',
  'numbers': 'числа',
  'zero': 'ноль',
  'one': 'один',
  'two': 'два',
  'three': 'три',
  'four': 'четыре',
  'five': 'пять',
  'six': 'шесть',
  'seven': 'семь',
  'eight': 'восемь',
  'nine': 'девять',
  'ten': 'десять',
  'eleven': 'одиннадцать',
  'twelve': 'двенадцать',
  'thirteen': 'тринадцать',
  'fourteen': 'четырнадцать',
  'fifteen': 'пятнадцать',
  'sixteen': 'шестнадцать',
  'seventeen': 'семнадцать',
  'eighteen': 'восемнадцать',
  'nineteen': 'девятнадцать',
  'twenty': 'двадцать',
  'years': 'лет',
  'age': 'возраст',
  'class': 'класс',
  'school': 'школа',
  'mother': 'мама',
  'father': 'отец',
  'sister': 'сестра',
  'brother': 'брат',
  'siblings': 'братья и сёстры',
  'bedroom': 'спальня',
  'kitchen': 'кухня',
  'apartment': 'квартира',
  'window': 'окно',
  'bed': 'кровать',
  'living': 'гостиная',
  'bathroom': 'туалет',
  'pharmacy': 'аптека',
  'hospital': 'больница',
  'doctor': 'врач',
  'police': 'полиция',
  'emergency': 'экстренная ситуация',
  'urgent': 'срочный',
  'fever': 'температура',
  'head': 'голова',
  'stomach': 'живот',
  'throat': 'горло',
  'hurts': 'болит',
  'sick': 'болен / больна',
  'pain': 'боль',
  'symptom': 'симптом',
  'condition': 'состояние',
  'travel': 'поездка',
  'route': 'маршрут',
  'station': 'станция',
  'stop': 'остановка',
  'street': 'улица',
  'hotel': 'отель',
  'center': 'центр',
  'metro': 'метро',
  'bus': 'автобус',
  'train': 'поезд',
  'taxi': 'такси',
  'bicycle': 'велосипед',
  'car': 'машина',
  'left': 'налево',
  'straight': 'прямо',
  'near': 'близко',
  'far': 'далеко',
  'location': 'местоположение',
  'direction': 'направление',
  'again': 'снова',
  'slower': 'медленнее',
  'slowly': 'медленно',
  'repeat': 'повторите',
  'repetition': 'повторение',
  'repair': 'исправление',
  'attention': 'внимание',
  'important': 'важный',
  'close': 'близкий',
  'common': 'частотный',
  'generic': 'общий',
  'neutral': 'нейтральный',
  'useful': 'полезный',
  'fixed': 'устойчивый',
  'form': 'форма',
  'forms': 'формы',
  'chunk': 'фрагмент',
  'sound': 'звук',
  'sounds': 'звуки',
  'spelling': 'написание',
  'silent': 'немая',
  'letter': 'буква',
  'letters': 'буквы',
  'accent': 'ударение / знак',
  'vowel': 'гласная',
  'vowels': 'гласные',
  'gender': 'род',
  'masculine': 'мужской род',
  'feminine': 'женский род',
  'plural': 'множественное число',
  'singular': 'единственное число',
  'informal': 'неформальный',
  'formal': 'формальный',
  'role': 'роль',
  'relationship': 'отношение',
  'young': 'молодой',
  'tall': 'высокий',
  'nice': 'приятный',
  'friendly': 'дружелюбный',
  'serious': 'серьёзный',
  'but': 'но',
  'not': 'не',
  'only': 'только',
  'also': 'также',
  'here': 'здесь',
  'there': 'там',
  'nearby': 'рядом',
  'then': 'затем',
  'now': 'сейчас',
  'this': 'это',
  'that': 'что',
  'they': 'они',
  'other': 'другой',
  'their': 'их',
  'them': 'их',
  'him': 'его',
  'her': 'её',
  'his': 'его',
  'your': 'твой / твоя',
  'my': 'мой / моя',
  'our': 'наш',
  'we': 'мы',
  'does': '',
  'do': '',
  'has': 'имеет',
  'have': 'иметь',
  'lives': 'живёт',
  'live': 'живу / живёт',
  'speaks': 'говорит',
  'speak': 'говорить',
  'needs': 'нужно',
  'need': 'нужно',
  'wants': 'хочет',
  'want': 'хочу',
  'goes': 'идёт / едет',
  'go': 'идите / ехать',
  'going': 'идти / ехать',
  'take': 'возьмите / сядьте на',
  'turn': 'поверните',
  'wait': 'подождите',
  'helping': 'помогая',
  'cannot': 'не может',
  'can': 'может',
  'may': 'может',
  'would': 'бы',
  'should': 'следует',
  'must': 'должен',
  'starts': 'начинается',
  'begins': 'начинается',
  'finishes': 'завершает',
  'contains': 'содержит',
  'keeps': 'сохраняет',
  'distinguishes': 'отличает',
  'shown': 'показанный',
  'means': 'означает',
  'tell': 'сообщает',
  'tells': 'сообщает',
  'fits': 'подходит',
  'mean': 'означает',
  'named': 'зовут',
  'having': 'наличие',
  'At A0': 'На уровне A0',
  'Use': 'Используйте',
  'use': 'используйте',
  'learn': 'изучите',
  'Spanish': 'испанский',
  'English': 'английский',
  'Russian': 'русский',
  'Ukrainian': 'украинский',
  'direct questions': 'прямые вопросы',
  'direct question': 'прямой вопрос',
  'question': 'вопрос',
  'questions': 'вопросы',
  'answer': 'ответ',
  'answers': 'ответы',
  'sentence': 'предложение',
  'sentences': 'предложения',
  'word': 'слово',
  'words': 'слова',
  'phrase': 'фраза',
  'phrases': 'фразы',
  'pattern': 'конструкция',
  'patterns': 'конструкции',
  'meaning': 'значение',
  'meanings': 'значения',
  'name': 'имя',
  'names': 'имена',
  'place': 'место',
  'city': 'город',
  'country': 'страна',
  'origin': 'происхождение',
  'residence': 'место проживания',
  'language': 'язык',
  'languages': 'языки',
  'person': 'человек',
  'people': 'люди',
  'friend': 'друг',
  'teacher': 'учитель',
  'student': 'ученик',
  'classmate': 'одноклассник',
  'family': 'семья',
  'home': 'дом',
  'room': 'комната',
  'object': 'предмет',
  'objects': 'предметы',
  'transport': 'транспорт',
  'directions': 'направления',
  'health': 'здоровье',
  'help': 'помощь',
  'shopping': 'покупки',
  'communication': 'общение',
  'conversation': 'разговор',
  'checkpoint': 'контрольная проверка',
  'practice': 'практика',
  'reading': 'чтение',
  'dialogue': 'диалог',
  'vocabulary': 'лексика',
  'grammar': 'грамматика',
  'basic': 'базовый',
  'simple': 'простой',
  'short': 'короткий',
  'familiar': 'знакомый',
  'polite': 'вежливый',
  'controlled': 'ограниченный',
  'bounded': 'ограниченный',
  'predictable': 'предсказуемый',
  'new': 'новый',
  'known': 'известный',
  'another': 'другой',
  'someone': 'кто-то',
  'something': 'что-то',
  'item': 'предмет',
  'items': 'предметы',
  'reply': 'ответ',
  'replies': 'ответы',
  'message': 'сообщение',
  'messages': 'сообщения',
  'profile': 'профиль',
  'profiles': 'профили',
  'exchange': 'обмен репликами',
  'service': 'служба',
  'services': 'службы',
  'support': 'опора',
  'instruction': 'инструкция',
  'instructions': 'инструкции',
  'context': 'контекст',
  'situation': 'ситуация',
  'situations': 'ситуации',
  'material': 'материал',
  'skill': 'навык',
  'skills': 'навыки',
  'task': 'задание',
  'tasks': 'задания',
  'where': 'где',
  'what': 'что',
  'who': 'кто',
  'how': 'как',
  'why': 'почему',
  'to say': 'чтобы сказать',
  'to ask': 'чтобы спросить',
  'to identify': 'чтобы определить',
  'to introduce yourself': 'чтобы представиться',
  'ask': 'спросите',
  'asks': 'спрашивает',
  'asking': 'вопрос',
  'say': 'скажите',
  'saying': 'фраза',
  'state': 'скажите',
  'identify': 'определите',
  'recognize': 'узнайте',
  'recall': 'вспомните',
  'combine': 'соедините',
  'demonstrate': 'покажите',
  'review': 'повторите',
  'Choose': 'Выберите',
  'choose': 'выберите',
  'Type': 'Введите',
  'type': 'введите',
  'Write': 'Напишите',
  'write': 'напишите',
  'Complete': 'Дополните',
  'complete': 'дополните',
  'Select': 'Выберите',
  'select': 'выберите',
  'Fill': 'Заполните',
  'fill': 'заполните',
  'correct': 'правильный',
  'best': 'лучший',
  'first': 'первый',
  'line': 'реплика',
  'prompt': 'задание',
  'source': 'исходный',
  'request': 'просьба',
  'greeting': 'приветствие',
  'hunger': 'голод',
  'finish': 'завершают',
  'after': 'после',
  'woman': 'женщина',
  'meet': 'познакомиться',
  'order': 'порядок',
  'It': 'это',
  'it': 'это',
  'copy': 'скопируйте',
  'copied': 'скопированный',
  'visible': 'видимый',
  'from': 'из',
  'for': 'для',
  'with': 'с',
  'about': 'о',
  'into': 'на',
  'without new teaching': 'без нового материала',
  'without relying on one memorized example':
      'не полагаясь на один заученный пример',
  'Do not': 'Не',
  'do not': 'не',
  'Keep': 'Сохраняйте',
  'keep': 'сохраняйте',
  'plus': 'плюс',
};

void _writePrettyJson(File file, Map<String, Object?> value) {
  const encoder = JsonEncoder.withIndent('  ');
  file.writeAsStringSync('${encoder.convert(value)}\n');
}
