import 'package:flipper_models/HttpClientMock.dart';
import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'BranchIdWidget.dart';
import 'TestApp.dart';

//flutter test test/hello_world_test.dart  --dart-define=FLUTTER_TEST_ENV=true

void main() {
  group('BranchIdWidget Tests', () {
    late MockHttpClientInterface mockHttpClientInterface;
    late MockProxyService mockProxyService;
    setUp(() async {
      bool.fromEnvironment('Test', defaultValue: true);
      mockHttpClientInterface = MockHttpClientInterface();
      mockProxyService = MockProxyService();
      // Initialize dependencies
    });

    setUpAll(() async {
      // Initialize dependencies for test environment
      await initializeDependenciesForTest();

      // Set up mocks for HttpClientInterface
      // when(mockHttpClientInterface.get(any))
      //     .thenReturn(Future.value(http.Response('', 200)));
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
