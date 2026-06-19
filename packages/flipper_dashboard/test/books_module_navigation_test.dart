import 'package:flipper_dashboard/books_module_entry.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_catalog.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flipper_web/modules/accounting/accounting_module.dart';
import 'package:flipper_web/modules/accounting/shell/mobile/accounting_mobile_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'TestApp.dart';

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
          selectedBusinessRestoreProvider.overrideWith((ref) async {}),
        ],
        child: const TestApp(
          child: BooksModuleEntry(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(AccountingModuleScreen), findsOneWidget);
    expect(find.byType(AccountingMobileShell), findsOneWidget);
  });
}
