import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'BranchIdWidget.dart';
import 'TestApp.dart';

//flutter test test/hello_world_test.dart  --dart-define=FLUTTER_TEST_ENV=true
/// this is a fake test just to simulate we are able to bootstrap close to the dependencies we are using inside our app
/// since I have mocking plus other complication that comes with mocking, integration testing should be close to the 
/// real app we are testing hence why I never use mocking
void main() {
  group('BranchIdWidget Tests', () {
    setUpAll(() async {
      // Initialize dependencies for test environment
      await initializeDependenciesForTest();

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
  });
}
