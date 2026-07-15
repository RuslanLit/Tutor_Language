import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_localization.dart';
import 'package:tutor_language/core/content/content_localization_providers.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/features/lesson_player/lesson_player_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Russian support locale renders localized pronunciation hints', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supportLocaleControllerProvider.overrideWith(
            (ref) => SupportLocale.russian,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: VocabularyItemView(
              item: VocabularyItem(
                id: 'vocab.es.a0.u01.l01.hola.v1',
                spanish: 'hola',
                nativeTranslation: 'hello',
                cefr: 'A0',
                example: 'Hola.',
                pronunciation: 'OH-lah',
              ),
            ),
          ),
        ),
      ),
    );

    await _pumpUntilFound(tester, find.text('о́ла'));

    expect(find.text('hola'), findsOneWidget);
    expect(find.text('о́ла'), findsOneWidget);
    expect(find.text('OH-lah'), findsNothing);
  });
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 80; i += 1) {
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }

  expect(finder, findsOneWidget);
}
