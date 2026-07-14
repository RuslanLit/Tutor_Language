import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class TutorLanguageApp extends ConsumerWidget {
  const TutorLanguageApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: buildLightTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: supportedTutorLanguageLocales,
      localeListResolutionCallback: resolveTutorLanguageLocale,
      routerConfig: router,
    );
  }
}

const _englishLocale = Locale('en');

const supportedTutorLanguageLocales = <Locale>[
  _englishLocale,
  Locale('uk'),
  Locale('ru'),
  Locale('pl'),
  Locale('de'),
];

Locale resolveTutorLanguageLocale(
  List<Locale>? preferredLocales,
  Iterable<Locale> supportedLocales,
) {
  final preferred = preferredLocales ?? const <Locale>[];
  for (final locale in preferred) {
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
  }
  return _englishLocale;
}
