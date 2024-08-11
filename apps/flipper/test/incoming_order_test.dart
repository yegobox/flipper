import 'dart:convert';

import 'package:flipper_dashboard/IncomingOrders.dart';
import 'package:flipper_models/LocalRealmApiMocked.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'helpers/bootstrapTestData.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('IncomingOrdersWidget Integration Tests', () {
    setUpAll(() async {
      await initializeDependenciesForTest();

      // init db
      ProxyService.local.configureLocal(useInMemory: true);
      ProxyService.local.configureRemoteRealm(
          "+250783054871",
          IUser.fromJson(
            json.decode(userResponse),
          ),
          localRealm: ProxyService.local.localRealm);
      createAndSaveMockStockRequests(realm: ProxyService.realm.realm!);
    });
    tearDownAll(() async {
      ProxyService.realm.realm!.write(() {
        ProxyService.realm.realm!.deleteAll<Product>();
        ProxyService.realm.realm!.deleteAll<SKU>();
        ProxyService.realm.realm!.deleteAll<Variant>();
        ProxyService.realm.realm!.deleteAll<Stock>();
      });
      ProxyService.realm.close();
    });

    testWidgets('Widget displays stock requests correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: MaterialApp(
            home: Scaffold(
              body: IncomingOrdersWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNWidgets(2));

      expect(
          find.text(
              'Request #${ProxyService.realm.requests(branchId: 1).first.id}'),
          findsNWidgets(1));
      expect(find.text('Branch ID: 1-2'), findsNWidgets(2));

      expect(
        tester
            .widget<ElevatedButton>(
              find.widgetWithText(ElevatedButton, 'Approve Request').last,
            )
            .enabled,
        isTrue,
      );
    });

    testWidgets('Approve button calls approveRequest when pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: MaterialApp(
            home: Scaffold(
              body: IncomingOrdersWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester
          .tap(find.widgetWithText(ElevatedButton, 'Approve Request').first);
      await tester.pumpAndSettle();

      /// if we remain with 1 card that means we can not approve the request that we
      /// did not intend to approve.
      expect(find.byType(Card), findsOneWidget);
      // expect(find.byType(Card), findsNWidgets(2));
    });
  });
}
