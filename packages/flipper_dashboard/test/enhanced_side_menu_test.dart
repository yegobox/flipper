// The left rail now hosts the report entries that used to be top-bar tabs.
// This pins the rail's structure: Overview/Chat, a Reports group with
// Transactions + Analytics (same keys the ribbon used), End shift at the
// bottom, and one tooltip per entry.
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/enhanced_side_menu_test.dart --dart-define=FLUTTER_TEST_ENV=true

import 'package:flipper_dashboard/EnhancedSideMenu.dart';
import 'package:flipper_dashboard/providers/navigation_providers.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    show connectivityStreamProvider;
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

class _MockDialogService extends Mock implements DialogService {}

const _allVisible = SideMenuVisibility(
  kds: true,
  items: true,
  dailyReportFiles: true,
  stockRecount: true,
  incomingOrders: true,
  production: true,
  shiftHistory: true,
  delegations: true,
  leads: true,
  agentCommission: true,
);

const _noneVisible = SideMenuVisibility(
  kds: false,
  items: false,
  dailyReportFiles: false,
  stockRecount: false,
  incomingOrders: false,
  production: false,
  shiftHistory: false,
  delegations: false,
  leads: false,
  agentCommission: false,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    final mockBox = MockBox();
    getIt.registerSingleton<LocalStorage>(mockBox);
    when(() => mockBox.getUserId()).thenReturn('user-a');
    when(() => mockBox.getBranchId()).thenReturn('branch-1');
    when(() => mockBox.getBusinessId()).thenReturn('biz-1');
    when(() => mockBox.readString(key: any(named: 'key'))).thenReturn(null);
    if (locator.isRegistered<DialogService>()) {
      locator.unregister<DialogService>();
    }
    locator.registerSingleton<DialogService>(_MockDialogService());
  });

  tearDown(() async {
    if (locator.isRegistered<DialogService>()) {
      locator.unregister<DialogService>();
    }
    await getIt.reset();
  });

  Future<void> pumpRail(WidgetTester tester, SideMenuVisibility menu) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final branch = Branch(id: 'branch-1', name: 'Demo Shop', businessId: 'b');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sideMenuVisibilityProvider.overrideWithValue(menu),
          activeBranchProvider.overrideWith((ref) => Stream.value(branch)),
          connectivityStreamProvider.overrideWith((ref) => Stream.value(true)),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates:
              FlipperAppLocalizations.localizationsDelegates,
          supportedLocales: FlipperAppLocalizations.supportedLocales,
          home: const Scaffold(
            body: Row(
              children: [
                SizedBox(width: 56, child: EnhancedSideMenu()),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('Reports group carries Transactions and Analytics', (
    tester,
  ) async {
    await pumpRail(tester, _allVisible);

    expect(find.byKey(const Key('transactions_desktop')), findsOneWidget);
    expect(find.byKey(const Key('analytics_desktop')), findsOneWidget);
    expect(find.byKey(const Key('eod_desktop')), findsOneWidget);

    // Every rail entry is labelled for hover / screen readers.
    final tooltips = tester
        .widgetList<Tooltip>(find.byType(Tooltip))
        .map((t) => t.message)
        .toSet();
    expect(
      tooltips,
      containsAll(<String>[
        'Overview',
        'Chat',
        'Transactions',
        'Analytics',
        'Daily Reports',
        'End shift',
        'Choose default app',
      ]),
    );
  });

  testWidgets('report entries stay when every gated item is hidden', (
    tester,
  ) async {
    await pumpRail(tester, _noneVisible);

    expect(find.byKey(const Key('transactions_desktop')), findsOneWidget);
    expect(find.byKey(const Key('analytics_desktop')), findsOneWidget);
    expect(find.text('Daily Reports'), findsNothing);
  });
}
