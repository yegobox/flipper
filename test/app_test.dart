import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_routing/app.locator.dart' as loc;
import 'package:flipper_routing/all_routes.dart';
import 'package:flipper_routing/app.bottomsheets.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_dashboard/startup_view.dart'; // Import the relevant file
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  // Mock the HTTP client at the ViewModel level
  MockHttpClient mockHttpClient = MockHttpClient();

  // Move the setup logic outside of the test
  setUp(() async {
    await initDependencies();
    loc.setupLocator(
      stackedRouter: stackedRouter,
    );
    setupDialogUi();
    setupBottomSheetUi();

    // Provide the mock HTTP client to the ViewModel
    loc.locator.registerLazySingleton(() => mockHttpClient);
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StartUpView());

    // Verify that our counter starts at 0.
    expect(find.text('A revolutionary business software ...'), findsOneWidget);

    // Test additional functionality...
  });
}
