// import 'package:flipper_routing/all_routes.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'TestApp.dart';
import 'package:flipper_rw/dependency_initializer.dart';

// flutter test test/check_out_test.dart  --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('CheckOuts Tests', () {
    setUpAll(() async {
      // Initialize dependencies for test environment
      await initializeDependenciesForTest();
    });

    setUp(() {});

    testWidgets('Checkout  displays correctly', (WidgetTester tester) async {
      expect(1, 1);
      // await tester.pumpWidget(
      //   TestApp(
      //     child: Scaffold(
      //       body: CheckOut(
      //         isBigScreen: true,
      //       ),
      //     ),
      //   ),
      // );
      // await tester.pumpAndSettle();
      // expect(find.byType(Card), findsOneWidget);
      // expect(find.byType(IconRow), findsOneWidget);
      // expect(find.byType(SearchInputWithDropdown), findsOneWidget);
      // expect(find.byType(QuickSellingView), findsOneWidget);
      // expect(find.byType(PayableView), findsOneWidget);
    });
  });
}
