import 'package:flipper_dashboard/hr_module_entry.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_catalog.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'TestApp.dart';

void main() {
  testWidgets('the Business section offers HR & Payroll', (tester) async {
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

    final business = catalog.firstWhere((s) => s.label == 'Business');
    final hr = business.apps.where((tile) => tile.page == 'HR');
    expect(hr, hasLength(1));
    expect(hr.single.label, 'HR & Payroll');
  });

  testWidgets('without a Supabase session HR explains and lets you back out', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    var attempts = 0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hrEnsureSupabaseSessionProvider.overrideWithValue(() async {
            attempts++;
            return null;
          }),
        ],
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const HrModuleEntry(),
                  ),
                ),
                child: const Text('More'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();

    expect(
      find.text('HR needs an internet connection. Connect and try again.'),
      findsOneWidget,
    );
    expect(attempts, 1);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(attempts, 2);

    await tester.tap(find.text('Back to Flipper'));
    await tester.pumpAndSettle();
    expect(find.text('More'), findsOneWidget);
  });

  testWidgets('with a session it opens the HR app the host registered', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hrEnsureSupabaseSessionProvider.overrideWithValue(
            () async => 'token',
          ),
          hrAppBuilderProvider.overrideWithValue(
            ({required onExit, required onUpgrade}) => Scaffold(
              body: TextButton(onPressed: onExit, child: const Text('HR')),
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const HrModuleEntry(),
                  ),
                ),
                child: const Text('More'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('HR'), findsOneWidget);

    // HR's own exit closes the route.
    await tester.tap(find.text('HR'));
    await tester.pumpAndSettle();
    expect(find.text('More'), findsOneWidget);
  });
}
