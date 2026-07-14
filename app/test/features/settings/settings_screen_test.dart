import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/app/app_release_info.dart';
import 'package:tutor_language/features/settings/settings_screen.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('settings screen shows release information without placeholder', (
    tester,
  ) async {
    await tester.pumpWidget(_localizedApp(const SettingsScreen()));

    expect(find.text('Settings placeholder'), findsNothing);
    expect(find.text('About and Settings'), findsOneWidget);
    expect(find.text(AppReleaseInfo.name), findsOneWidget);
    expect(find.text(AppReleaseInfo.scope), findsOneWidget);
    expect(find.text(AppReleaseInfo.status), findsOneWidget);
    expect(find.text('Version ${AppReleaseInfo.version}'), findsOneWidget);
    expect(find.text('Privacy'), findsOneWidget);
    expect(find.text('Works offline.'), findsOneWidget);
    expect(find.text('No account is required.'), findsOneWidget);
    expect(find.text('Feedback'), findsOneWidget);
  });

  testWidgets('settings content scrolls on a small screen', (tester) async {
    tester.view.physicalSize = const Size(360, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_localizedApp(const SettingsScreen()));

    expect(find.byType(ListView), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pump();

    expect(find.text('Licenses and Credits'), findsOneWidget);
  });

  test('displayed app version matches pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final match = RegExp(
      r'^version:\s*(.+)$',
      multiLine: true,
    ).firstMatch(pubspec);

    expect(match, isNotNull);
    expect(AppReleaseInfo.version, match!.group(1));
  });
}

Widget _localizedApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}
