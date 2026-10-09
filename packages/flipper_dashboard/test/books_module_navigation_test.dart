import 'package:flipper_dashboard/books_module_entry.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_catalog.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/modules/accounting/accounting_module.dart';
import 'package:flipper_web/modules/accounting/data/accounting_backend_config.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/shell/mobile/accounting_mobile_shell.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_web/modules/accounting/shell/mobile/accounting_mobile_header.dart';
import 'package:flipper_web/modules/accounting/views/mobile/mobile_views.dart';
import 'package:flipper_web/modules/accounting/routing/accounting_route.dart';
import 'package:flipper_web/modules/accounting/widgets/books_brand_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'TestApp.dart';

final _testBusiness = Business(
  id: 'biz-test',
  name: 'Demo Shop',
  country: 'RW',
  currency: 'RWF',
  latitude: '0',
  longitude: '0',
  active: true,
  userId: 'user-test',
  phoneNumber: '+250700000000',
  lastSeen: 0,
  backUpEnabled: false,
  fullName: 'Demo Shop',
  tinNumber: 0,
  taxEnabled: false,
  businessTypeId: 1,
  serverId: 1,
  isDefault: true,
  lastSubscriptionPaymentSucceeded: true,
);

final _testBranch = Branch(
  id: 'branch-test',
  description: 'Main',
  name: 'Main',
  longitude: '0',
  latitude: '0',
  businessId: 'biz-test',
  serverId: 1,
);

void main() {
  testWidgets('dashboardAllAppsCatalog includes Finance Books tile', (
    tester,
  ) async {
    late List<DashboardAllAppSection> catalog;

    await tester.pumpWidget(
      TestApp(
        child: Builder(
          builder: (context) {
            catalog = dashboardAllAppsCatalog(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(catalog.first.label, 'Finance');
    expect(
      catalog.first.apps.any(
        (tile) => tile.page == 'Accounting' && tile.label == 'Books',
      ),
      isTrue,
    );
  });

  testWidgets('dashboardAllAppsCatalog has no duplicate destinations', (
    tester,
  ) async {
    late List<DashboardAllAppSection> catalog;

    await tester.pumpWidget(
      TestApp(
        child: Builder(
          builder: (context) {
            catalog = dashboardAllAppsCatalog(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final pages = [
      for (final section in catalog)
        for (final tile in section.apps) tile.page,
    ];
    expect(pages.toSet().length, pages.length);
    // The bottom nav's New Sale / Inventory buttons already open checkout.
    expect(pages, isNot(contains('POS')));
    expect(pages, isNot(contains('Inventory')));
  });

  testWidgets('BooksModuleEntry hosts AccountingModuleScreen', (tester) async {
    await _pumpBooks(tester, const Size(600, 900));

    expect(find.byType(AccountingModuleScreen), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(AccountingMobileShell), findsOneWidget);
  });

  testWidgets('on a phone Books wears Flipper\'s CustomAppBar, once', (
    tester,
  ) async {
    await _pumpBooks(tester, const Size(400, 860));

    expect(find.byKey(const Key('books-app-bar')), findsOneWidget);
    expect(find.byType(CustomAppBar), findsOneWidget);
    // The host names the module, so Books' own brand row stands down.
    expect(find.byType(BooksBrandRow), findsNothing);
  });

  testWidgets('a desktop window keeps Books\' own chrome', (tester) async {
    await _pumpBooks(tester, const Size(1400, 900));

    expect(find.byType(CustomAppBar), findsNothing);
    expect(find.byType(AccountingMobileShell), findsNothing);
  });

  testWidgets('a report on a phone: one header, and back steps out of it', (
    tester,
  ) async {
    await _pumpBooks(tester, const Size(400, 860));

    // Inside the Flipper app the business card shows, without a switch.
    expect(find.byIcon(Icons.expand_more), findsNothing);

    await tester.tap(find.text('Reports').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Income statement'));
    await tester.pumpAndSettle();

    String title() => tester
        .widget<CustomAppBar>(find.byKey(const Key('books-app-bar')))
        .title!;
    expect(title(), 'Income statement');
    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.byType(AccountingMobileHeader), findsNothing);

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('books-app-bar')),
        matching: find.byType(AppBarRoundIconButton),
      ),
    );
    await tester.pumpAndSettle();
    expect(title(), 'Books');
    expect(find.text('Income statement'), findsOneWidget); // the list again
  });

  testWidgets('without a host, a report wears its own CustomAppBar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 860);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    var closed = false;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountingAccountsProvider.overrideWithValue(const []),
          accountingVatProvider.overrideWithValue(null),
        ],
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            body: AccountingStatementDetail(
              report: MobileReportKey.bs,
              onBack: () => closed = true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final bar = tester.widget<CustomAppBar>(
      find.byKey(const Key('books-report-app-bar')),
    );
    expect(bar.title, 'Balance sheet');
    await tester.tap(find.byType(AppBarRoundIconButton));
    expect(closed, isTrue);
  });
}

Future<void> _pumpBooks(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountingBackendStrategyProvider.overrideWithValue(
          AccountingBackendStrategy.supabase,
        ),
        selectedBusinessProvider.overrideWithValue(_testBusiness),
        selectedBranchProvider.overrideWithValue(_testBranch),
        dittoReadyProvider.overrideWith((ref) => true),
        selectedBusinessRestoreProvider.overrideWith((ref) async {}),
        accountingPostSyncBootstrapProvider.overrideWith((ref) async {}),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(body: BooksModuleEntry()),
      ),
    ),
  );
  await tester.pump();
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
}
