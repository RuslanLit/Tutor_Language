import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_loader.dart';
import 'package:tutor_language/core/content/content_localization.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'support locale follows supported UI language with English fallback',
    () {
      const resolver = SupportLocaleResolver();

      expect(resolver.resolveLanguageCode('en'), SupportLocale.english);
      expect(resolver.resolveLanguageCode('uk'), SupportLocale.ukrainian);
      expect(resolver.resolveLanguageCode('ru'), SupportLocale.russian);
      expect(resolver.resolveLanguageCode('pl'), SupportLocale.polish);
      expect(resolver.resolveLanguageCode('de'), SupportLocale.german);
      expect(resolver.resolveLanguageCode('fr'), SupportLocale.english);
      expect(
        resolver.resolveLocale(const Locale('ru', 'UA')),
        SupportLocale.russian,
      );
      expect(
        resolver.resolveLocale(const Locale('uk', 'UA')),
        SupportLocale.ukrainian,
      );
      expect(
        resolver.resolveLocale(const Locale('de', 'DE')),
        SupportLocale.german,
      );
      expect(
        resolver.resolveLocale(const Locale('pl', 'PL')),
        SupportLocale.polish,
      );
    },
  );

  test(
    'localized reference slice preserves stable ids and Spanish target text',
    () async {
      final localization = await _loadLocalization();
      final course = await CurriculumLoader().loadCourse();
      final content = await ContentLoader().loadLanguagePackContent();
      final resolver = EducationalContentLocalizationResolver(localization);

      final russianCourse = resolver.resolveCourse(
        course,
        SupportLocale.russian,
      );
      expect(russianCourse.id, course.id);
      expect(russianCourse.title, 'Испанский A0');
      expect(russianCourse.modules.first.id, course.modules.first.id);
      expect(russianCourse.modules.first.title, 'Первые слова и чтение');
      expect(russianCourse.lessons.first.id, course.lessons.first.id);
      expect(russianCourse.lessons.first.title, 'Приветствие и прощание');
      expect(
        russianCourse.lessons.first.description,
        'Поздоровайтесь и попрощайтесь короткими испанскими фразами.',
      );

      final vocab = content.contents
          .whereType<VocabularyContent>()
          .expand((content) => content.entries)
          .firstWhere((item) => item.id == 'vocab.es.a0.unit1.hola.v1');
      final localizedVocab = resolver.resolveVocabularyItem(
        vocab,
        SupportLocale.russian,
      );

      expect(localizedVocab.id, vocab.id);
      expect(localizedVocab.spanish, 'hola');
      expect(localizedVocab.nativeTranslation, 'привет');
      expect(localizedVocab.example, 'Hola, Ana.');

      final template = content.contents
          .whereType<ExerciseTemplateContent>()
          .expand((content) => content.templates)
          .firstWhere(
            (template) =>
                template.id == 'template.es.a0.unit1.greeting_choice.v1',
          );
      final localizedTemplate = resolver.resolveExerciseTemplate(
        template,
        SupportLocale.russian,
      );

      expect(localizedTemplate.id, template.id);
      expect(
        localizedTemplate.promptTemplate,
        'Выберите значение фразы «hola».',
      );
      expect(localizedTemplate.correctOptionId, template.correctOptionId);
      expect(localizedTemplate.answerOptions.first.id, 'option.hello');
      expect(localizedTemplate.answerOptions.first.label, 'привет');
    },
  );

  test(
    'Russian support localization covers representative course and content text',
    () async {
      final localization = await _loadLocalization();
      final course = await CurriculumLoader().loadCourse();
      final content = await ContentLoader().loadLanguagePackContent();
      final resolver = EducationalContentLocalizationResolver(localization);

      final russianCourse = resolver.resolveCourse(
        course,
        SupportLocale.russian,
      );

      expect(russianCourse.modules.first.title, 'Первые слова и чтение');
      expect(
        russianCourse.modules.first.title,
        isNot('First Words and Reading'),
      );

      final profileReading = content.contents
          .whereType<ReadingContent>()
          .expand((content) => content.readings)
          .firstWhere(
            (reading) => reading.id == 'reading.es.a0.m02.profile_cards.v1',
          );
      final localizedReading = resolver.resolveReading(
        profileReading,
        SupportLocale.russian,
      );

      expect(localizedReading.title, 'Карточки профилей');
      expect(localizedReading.title, isNot('Profile Cards'));
      expect(localizedReading.text, profileReading.text);

      final originTemplate = content.contents
          .whereType<ExerciseTemplateContent>()
          .expand((content) => content.templates)
          .firstWhere(
            (template) =>
                template.id == 'template.es.a0.m03.l014.type_de_donde_eres.v1',
          );
      final localizedOriginTemplate = resolver.resolveExerciseTemplate(
        originTemplate,
        SupportLocale.russian,
      );

      expect(
        localizedOriginTemplate.promptTemplate,
        'Введите испанский вопрос: «Откуда ты?».',
      );
      expect(
        localizedOriginTemplate.promptTemplate,
        isNot('Type the Spanish question: "Where are you from?".'),
      );
      expect(
        localizedOriginTemplate.correctOptionId,
        originTemplate.correctOptionId,
      );
    },
  );

  test(
    'missing requested localization falls back to English at runtime',
    () async {
      final localization = await _loadLocalization();
      final course = await CurriculumLoader().loadCourse();
      final resolver = EducationalContentLocalizationResolver(localization);

      final germanCourse = resolver.resolveCourse(course, SupportLocale.german);

      expect(germanCourse.id, course.id);
      expect(germanCourse.title, 'Spanish A0');
      expect(germanCourse.lessons.first.title, 'Hello and Goodbye');
    },
  );

  test(
    'localization validation detects unknown ids, duplicates, source gaps',
    () async {
      final course = await CurriculumLoader().loadCourse();
      final content = await ContentLoader().loadLanguagePackContent();
      final invalid = EducationalContentLocalizationBundle(
        schemaVersion: 1,
        targetLanguage: 'es',
        sourceSupportLocale: 'en',
        supportLocales: const ['en', 'zz'],
        entries: const [
          LocalizedEducationalEntry(
            type: 'vocabulary',
            id: 'vocab.es.a0.unit1.hola.v1',
            fields: {
              'native_translation': {'ru': 'привет'},
            },
          ),
          LocalizedEducationalEntry(
            type: 'vocabulary',
            id: 'vocab.es.a0.unit1.hola.v1',
            fields: {
              'native_translation': {'en': 'hello'},
            },
          ),
          LocalizedEducationalEntry(
            type: 'vocabulary',
            id: 'missing.vocab',
            fields: {
              'native_translation': {'en': 'missing'},
            },
          ),
        ],
      );

      final issues = const EducationalContentLocalizationValidator().validate(
        localization: invalid,
        course: course,
        contentBundle: content,
      );

      expect(
        issues.map((issue) => issue.code),
        containsAll([
          'unsupported_locale',
          'missing_source_support_text',
          'duplicate_localization_entry',
          'unknown_localized_id',
          'unknown_localized_field',
        ]),
      );
    },
  );

  test(
    'English source inventory covers every localizable educational field',
    () async {
      final localization = await _loadLocalization();
      final course = await CurriculumLoader().loadCourse();
      final content = await ContentLoader().loadLanguagePackContent();
      final inventory = const EducationalContentLocalizationInventory().build(
        course: course,
        contentBundle: content,
      );
      final issues = const EducationalContentLocalizationValidator().validate(
        localization: localization,
        course: course,
        contentBundle: content,
      );
      final summaries = const EducationalContentLocalizationInventory()
          .summarize(inventory: inventory, localization: localization);

      expect(inventory.length, 2742);
      expect(
        summaries.map(
          (summary) => (
            summary.category,
            summary.totalLocalizableFields,
            summary.englishSourceFields,
            summary.missingEnglishSourceFields,
            summary.invalidFields,
          ),
        ),
        containsAll([
          ('course metadata', 1, 1, 0, 0),
          ('module metadata', 9, 9, 0, 0),
          ('lesson metadata', 210, 210, 0, 0),
          ('lesson objectives', 70, 70, 0, 0),
          ('lesson sections', 70, 70, 0, 0),
          ('lesson activities', 312, 312, 0, 0),
          ('lesson summaries', 70, 70, 0, 0),
          ('vocabulary', 515, 515, 0, 0),
          ('grammar', 374, 374, 0, 0),
          ('dialogues', 353, 353, 0, 0),
          ('readings', 152, 152, 0, 0),
          ('exercise prompts', 495, 495, 0, 0),
          ('support-language answer options', 111, 111, 0, 0),
        ]),
      );
      expect(issues, isEmpty);
    },
  );

  test(
    'inventory localizes support answer options without translating Spanish choices',
    () async {
      final course = await CurriculumLoader().loadCourse();
      final content = await ContentLoader().loadLanguagePackContent();
      final inventory = const EducationalContentLocalizationInventory().build(
        course: course,
        contentBundle: content,
      );
      final fieldKeys = inventory.map((field) => field.fieldKey).toSet();

      expect(
        fieldKeys,
        contains(
          'exercise_template|template.es.a0.unit1.greeting_choice.v1|'
          'answer_options.option.hello.label',
        ),
      );
      expect(
        fieldKeys,
        isNot(
          contains(
            'exercise_template|template.es.a0.m09.l061.condition_choice.v1|'
            'answer_options.bien.label',
          ),
        ),
      );
    },
  );

  test(
    'coverage report distinguishes source fields from fallback fields',
    () async {
      final localization = await _loadLocalization();
      final coverage = const EducationalContentLocalizationCoverageReporter()
          .report(localization);
      final english = coverage.firstWhere(
        (entry) => entry.locale == SupportLocale.english,
      );
      final russian = coverage.firstWhere(
        (entry) => entry.locale == SupportLocale.russian,
      );
      final ukrainian = coverage.firstWhere(
        (entry) => entry.locale == SupportLocale.ukrainian,
      );

      expect(english.totalFields, 2742);
      expect(english.translatedFields, english.totalFields);
      expect(english.fallbackFields, 0);
      expect(russian.totalFields, english.totalFields);
      expect(russian.translatedFields, russian.totalFields);
      expect(russian.fallbackFields, 0);
      expect(ukrainian.totalFields, english.totalFields);
      expect(ukrainian.translatedFields, 0);
      expect(ukrainian.fallbackFields, ukrainian.totalFields);
    },
  );

  test(
    'Russian support localization has no English instructional fragments',
    () async {
      final localization = await _loadLocalization();
      final findings = _findRussianEnglishFragments(localization);

      expect(
        findings,
        isEmpty,
        reason:
            'Russian learner-support text must not contain English '
            'instructional fragments. First findings:\n'
            '${findings.take(40).join('\n')}',
      );
    },
  );
}

Future<EducationalContentLocalizationBundle> _loadLocalization() {
  return EducationalContentLocalizationRepository(
    assetBundle: rootBundle,
  ).loadBundle();
}

List<String> _findRussianEnglishFragments(
  EducationalContentLocalizationBundle bundle,
) {
  final findings = <String>[];
  for (final entry in bundle.entries) {
    for (final field in entry.fields.entries) {
      final russian = field.value['ru'];
      if (russian == null) {
        continue;
      }
      if (entry.type == 'grammar' && field.key.startsWith('examples.')) {
        continue;
      }
      final tokens = RegExp(
        r"[A-Za-zÀ-ÖØ-öø-ÿ][A-Za-zÀ-ÖØ-öø-ÿ'’.-]*[A-Za-zÀ-ÖØ-öø-ÿ]",
      ).allMatches(russian).map((match) => match.group(0)!);
      final badTokens = tokens.where((token) {
        final normalized = token.toLowerCase().replaceAll('’', "'");
        if (normalized.length < 3) {
          return false;
        }
        if (_allowedRussianLatinTokens.contains(normalized)) {
          return false;
        }
        if (_knownSpanishOrInvariantTokens.contains(normalized)) {
          return false;
        }
        return _forbiddenEnglishTokens.contains(normalized);
      }).toSet();
      if (badTokens.isNotEmpty) {
        findings.add(
          '${entry.type}|${entry.id}|${field.key}|'
          '${badTokens.join(', ')}|$russian',
        );
      }
    }
  }
  return findings;
}

const _forbiddenEnglishTokens = {
  'about',
  'active',
  'activities',
  'activity',
  'action',
  'and',
  'answer',
  'answers',
  'are',
  'ask',
  'asks',
  'asking',
  'assess',
  'basic',
  'best',
  'broad',
  'cards',
  'checkpoint',
  'choose',
  'class',
  'complete',
  'conversation',
  'copy',
  'contrast',
  'contrasts',
  'covering',
  'dialogue',
  'does',
  'direct',
  'english',
  'exchange',
  'for',
  'full',
  'from',
  'greeting',
  'has',
  'have',
  'identity',
  'in',
  'integrated',
  'introduction',
  'introductions',
  'is',
  'language',
  'lesson',
  'lessons',
  'live',
  'lives',
  'material',
  'mean',
  'meaning',
  'means',
  'meeting',
  'module',
  'name',
  'names',
  'naturally',
  'need',
  'needs',
  'new',
  'note',
  'practiced',
  'object',
  'on',
  'phrase',
  'phrases',
  'question',
  'questions',
  'read',
  'reading',
  'recall',
  'recognize',
  'request',
  'requests',
  'review',
  'sentence',
  'sentences',
  'speak',
  'speaks',
  'spanish',
  'statement',
  'teach',
  'support',
  'task',
  'the',
  'to',
  'translation',
  'type',
  'unit',
  'use',
  'used',
  'using',
  'what',
  'where',
  'which',
  'who',
  'with',
  'word',
  'words',
  'write',
  'you',
  'your',
};

const _allowedRussianLatinTokens = {'a0', 'ai', 'cefr', 'id', 'tutor'};

const _knownSpanishOrInvariantTokens = {
  'adios',
  'adiós',
  'agua',
  'algo',
  'al',
  'amigo',
  'ana',
  'años',
  'ayuda',
  'ayudarme',
  'barato',
  'barata',
  'bien',
  'bogotá',
  'bolsa',
  'buenas',
  'buenos',
  'botella',
  'café',
  'carlos',
  'carmen',
  'chile',
  'cinco',
  'centro',
  'cocina',
  'cómo',
  'colombia',
  'cuánto',
  'cuesta',
  'cuántos',
  'cabeza',
  'cerca',
  'de',
  'derecha',
  'días',
  'diego',
  'diez',
  'dieciocho',
  'dieciséis',
  'dónde',
  'dos',
  'duele',
  'el',
  'él',
  'elena',
  'ella',
  'encantada',
  'encantado',
  'entiendo',
  'eres',
  'es',
  'español',
  'españa',
  'está',
  'esto',
  'estación',
  'estás',
  'este',
  'esta',
  'estoy',
  'familia',
  'farmacia',
  'favor',
  'gracias',
  'gusto',
  'gira',
  'garganta',
  'habla',
  'hablas',
  'hablo',
  'hambre',
  'hasta',
  'hermana',
  'hola',
  'igualmente',
  'izquierda',
  'javier',
  'josé',
  'la',
  'lima',
  'libro',
  'libros',
  'llave',
  'lápiz',
  'llama',
  'llamas',
  'llamo',
  'luego',
  'luis',
  'lucía',
  'llego',
  'madrid',
  'maría',
  'marta',
  'me',
  'mesa',
  'médico',
  'mi',
  'miguel',
  'muchas',
  'mucho',
  'más',
  'méxico',
  'necesito',
  'necesita',
  'fiebre',
  'no',
  'noche',
  'noches',
  'ocho',
  'pablo',
  'padre',
  'parada',
  'pedro',
  'perdón',
  'poco',
  'por',
  'puede',
  'queso',
  'quiero',
  'qué',
  'razón',
  'recto',
  'repita',
  'repite',
  'se',
  'sara',
  'sevilla',
  'si',
  'sí',
  'silla',
  'sigue',
  'sofía',
  'soy',
  'tal',
  'tardes',
  'te',
  'teléfono',
  'tener',
  'tengo',
  'tiene',
  'tienes',
  'toma',
  'tomo',
  'tren',
  'transporte',
  'tres',
  'ucrania',
  'un',
  'una',
  'valencia',
  'vas',
  'veinte',
  'vivo',
  'vive',
  'voy',
  'h',
  'j',
  'll',
  'ñ',
  'qu',
  'gue',
  'gui',
  'rr',
};
