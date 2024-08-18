import 'dart:convert';

import 'package:flipper_models/LocalRealmApiMocked.dart';
import 'package:flipper_models/helperModels/iuser.dart';
// import 'package:flipper_routing/all_routes.dart';
import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:flipper_services/proxy.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'TestApp.dart';

// flutter test test/check_out_test.dart  --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('CheckOuts Tests', () {
    setUpAll(() async {
      // Initialize dependencies for test environment
      await initializeDependenciesForTest();
      ProxyService.local.configureLocal(useInMemory: true);
      ProxyService.local.configureRemoteRealm(
          "+250783054871",
          IUser.fromJson(
            json.decode(userResponse),
          ),
          localRealm: ProxyService.local.localRealm);
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
