// Import the test package and Counter class
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flipper_rw/main.dart' as app;

void main() {
  // Use IntegrationTestWidgetsFlutterBinding to ensure that tests are run on
  // a real device or emulator
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Define a test using testWidgets
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Run the app
    app.main();
    await tester.pumpAndSettle();

    // Verify that the counter starts at 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Find and tap the increment button
    // await tester.tap(find.byKey(const Key('increment')));
    await tester.pumpAndSettle();

    // Verify that the counter has incremented
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
