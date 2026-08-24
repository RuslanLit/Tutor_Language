import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/app/app.dart';
import 'package:tutor_language/core/content/content_localization.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

void main() {
  final supportedLanguageCodes = <String>['en', 'uk', 'ru', 'pl', 'de'];

  test('supported UI locales are declared in product fallback order', () {
    expect(supportedTutorLanguageLocales, const [
      Locale('en'),
      Locale('uk'),
      Locale('ru'),
      Locale('pl'),
      Locale('de'),
    ]);
  });

  test('unsupported locales resolve to English', () {
    final resolved = resolveTutorLanguageLocale(const [
      Locale('fr'),
      Locale('es'),
    ], supportedTutorLanguageLocales);

    expect(resolved, const Locale('en'));
  });

  test('supported locales resolve by language code', () {
    final cases = <Locale, Locale>{
      const Locale('en', 'US'): const Locale('en'),
      const Locale('uk', 'UA'): const Locale('uk'),
      const Locale('ru', 'UA'): const Locale('ru'),
      const Locale('ru', 'RU'): const Locale('ru'),
      const Locale('pl', 'PL'): const Locale('pl'),
      const Locale('de', 'DE'): const Locale('de'),
    };

    for (final entry in cases.entries) {
      final resolved = resolveTutorLanguageLocale([
        entry.key,
      ], supportedTutorLanguageLocales);

      expect(resolved, entry.value);
    }
  });

  test('educational support locales use release-ready localization only', () {
    const resolver = SupportLocaleResolver();
    final cases = <String, SupportLocale>{
      'en': SupportLocale.english,
      'uk': SupportLocale.ukrainian,
      'ru': SupportLocale.russian,
      'pl': SupportLocale.english,
      'de': SupportLocale.english,
      'fr': SupportLocale.english,
    };

    for (final entry in cases.entries) {
      expect(resolver.resolveLanguageCode(entry.key), entry.value);
    }
  });

  test('ARB files contain every source key for supported locales', () {
    final source = _readArb('en');
    final sourceKeys = _messageKeys(source).toSet();

    for (final languageCode in supportedLanguageCodes) {
      final arb = _readArb(languageCode);
      expect(arb['@@locale'], languageCode);
      expect(_messageKeys(arb).toSet(), sourceKeys);
    }
  });

  test('generated untranslated message report has no missing translations', () {
    final file = File('untranslated_messages.json');
    if (!file.existsSync()) {
      fail('untranslated_messages.json was not generated');
    }

    final decoded = jsonDecode(file.readAsStringSync());
    expect(decoded, isA<Map<String, Object?>>());
    expect(decoded, isEmpty);
  });

  testWidgets('localization is available in every supported locale', (
    tester,
  ) async {
    late AppLocalizations l10n;

    final expectations = <Locale, String>{
      const Locale('en'): 'About and Settings',
      const Locale('uk'): 'Про застосунок і налаштування',
      const Locale('ru'): 'О приложении и настройки',
      const Locale('pl'): 'O aplikacji i ustawienia',
      const Locale('de'): 'Info und Einstellungen',
    };

    for (final entry in expectations.entries) {
      await tester.pumpWidget(
        MaterialApp(
          locale: entry.key,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: supportedTutorLanguageLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return Text(l10n.settingsTitle);
            },
          ),
        ),
      );

      expect(l10n.settingsTitle, entry.value);
      expect(find.text(entry.value), findsOneWidget);
    }
  });

  testWidgets('dynamic messages and plurals render in every supported locale', (
    tester,
  ) async {
    late AppLocalizations l10n;

    for (final locale in supportedTutorLanguageLocales) {
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: supportedTutorLanguageLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return Text(l10n.courseProgress(2, 5));
            },
          ),
        ),
      );

      expect(l10n.courseProgress(2, 5), contains('2'));
      expect(l10n.courseProgress(2, 5), contains('5'));
      expect(l10n.versionLabel('1.0.0'), contains('1.0.0'));
      for (final count in <int>[0, 1, 2, 4, 5, 11, 21, 22, 25]) {
        expect(l10n.activitiesCount(count), isNot(contains('count')));
        expect(l10n.requiredObjectTypesCount(count), isNot(contains('count')));
        expect(l10n.supportedGoalsCount(count), isNot(contains('count')));
      }
    }
  });
}

Map<String, Object?> _readArb(String languageCode) {
  final file = File('lib/l10n/app_$languageCode.arb');
  if (!file.existsSync()) {
    fail('Missing ARB file: ${file.path}');
  }

  return (jsonDecode(file.readAsStringSync()) as Map<String, Object?>);
}

Iterable<String> _messageKeys(Map<String, Object?> arb) {
  return arb.keys.where((key) => !key.startsWith('@'));
}
