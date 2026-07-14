import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/app/app.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

void main() {
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
    final resolved = resolveTutorLanguageLocale(const [
      Locale('ru', 'RU'),
    ], supportedTutorLanguageLocales);

    expect(resolved, const Locale('ru'));
  });

  testWidgets('English localization is available in widgets', (tester) async {
    late AppLocalizations l10n;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: supportedTutorLanguageLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return Text(l10n.appTitle);
          },
        ),
      ),
    );

    expect(l10n.appTitle, 'Tutor Language');
    expect(find.text('Tutor Language'), findsOneWidget);
  });
}
