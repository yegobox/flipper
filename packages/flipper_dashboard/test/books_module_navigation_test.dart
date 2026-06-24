import 'package:flipper_dashboard/books_module_entry.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_catalog.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/modules/accounting/accounting_module.dart';
import 'package:flipper_web/modules/accounting/data/accounting_backend_config.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/shell/mobile/accounting_mobile_shell.dart';
import 'package:flipper_web/services/ditto_service.dart';
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
  testWidgets('dashboardAllAppsCatalog includes Finance Books tile', (tester) async {
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
      catalog.first.apps.any((tile) => tile.page == 'Accounting' && tile.label == 'Books'),
      isTrue,
    );
  });

  testWidgets('BooksModuleEntry hosts AccountingModuleScreen', (tester) async {
    tester.view.physicalSize = const Size(600, 900);
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
          home: Scaffold(body: BooksModuleEntry()),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.byType(AccountingModuleScreen), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(AccountingMobileShell), findsOneWidget);
  });
}
