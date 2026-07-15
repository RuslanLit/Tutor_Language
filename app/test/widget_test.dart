import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/main.dart' as app;

void main() {
  testWidgets('shows the application shell', (tester) async {
    app.main();
    await _pumpUntilFound(tester, find.text('Tutor Language'));
    await _pumpUntilFound(tester, find.textContaining('A0'));

    expect(find.text('Tutor Language'), findsOneWidget);
    expect(find.textContaining('A0'), findsWidgets);
  });
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 20; i += 1) {
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
}
