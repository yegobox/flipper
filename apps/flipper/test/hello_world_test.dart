import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'BranchIdWidget.dart';
import 'TestApp.dart';

//flutter test test/hello_world_test.dart  --dart-define=Test=true

void main() {
  setUpAll(() async {
    bool.fromEnvironment('Test', defaultValue: true);
    // Initialize dependencies
    await initializeDependenciesForTest();
  });

  setUp(() async {
    // Reset SharedPreferences before each test
    await ProxyService.box.clear(); // Clear all preferences

    // Optionally, you may need to reset other states here
  });

  testWidgets('BranchIdWidget displays and updates branch ID',
      (WidgetTester tester) async {
    // Build our widget and trigger a frame
    await tester.pumpWidget(TestApp(child: BranchIdWidget()));

    // Verify that the initial state is displayed correctly
    expect(find.text('Current Branch ID: Not set'), findsOneWidget);

    // Tap the button to set the branch ID
    await tester.tap(find.byType(ElevatedButton));
    await tester
        .pumpAndSettle(); // Wait for all animations and async operations to complete

    // Verify that the new state is displayed correctly
    expect(find.text('Current Branch ID: 1'), findsOneWidget);

    // Verify that the value is actually saved in ProxyService
    expect(await ProxyService.box.getBranchId(), equals(1));
  });
}
