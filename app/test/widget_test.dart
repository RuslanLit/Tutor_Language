import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/main.dart' as app;

void main() {
  testWidgets('shows the application shell', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text('Tutor Language'), findsOneWidget);
    expect(find.text('Beginner Spanish'), findsOneWidget);
  });
}
