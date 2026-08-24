import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/content/content_localization_providers.dart';
import '../l10n/generated/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class TutorLanguageApp extends ConsumerWidget {
  const TutorLanguageApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: buildLightTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: supportedTutorLanguageLocales,
      localeListResolutionCallback: resolveTutorLanguageLocale,
      routerConfig: router,
      builder: (context, child) => _SupportLocaleBinding(child: child),
    );
  }
}

class _SupportLocaleBinding extends ConsumerWidget {
  const _SupportLocaleBinding({required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiLocale = Localizations.localeOf(context);
    final supportLocale = ref
        .watch(supportLocaleResolverProvider)
        .resolveLocale(uiLocale);
    final currentSupportLocale = ref.watch(supportLocaleProvider);

    if (currentSupportLocale != supportLocale) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(supportLocaleControllerProvider.notifier).state =
            supportLocale;
      });
    }

    return child ?? const SizedBox.shrink();
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
