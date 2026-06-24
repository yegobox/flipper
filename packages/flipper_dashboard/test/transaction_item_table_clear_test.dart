// Verifies the instant cart clear on sale completion: when a sale finishes,
// the visible cart must empty immediately (without waiting for the async
// stream/pending providers to reconcile) so the operator can ring up the next
// sale. See [TransactionItemTable.clearCartLinesOptimistically] and its caller
// [_QuickSellingViewState._onQuickSellComplete] in QuickSellingView.dart.
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/transaction_item_table_clear_test.dart --dart-define=FLUTTER_TEST_ENV=true

import 'package:flipper_dashboard/TransactionItemTable.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

class _MockSettingsService extends Mock implements SettingsService {}

/// Controllable stand-in for the merged cart so the test can simulate the
/// stream lagging behind (lines still present right after completion).
final _cartSourceProvider =
    StateProvider<List<TransactionItem>>((ref) => const []);

TransactionItem _line(String id) => TransactionItem(
      id: id,
      name: 'Item $id',
      qty: 1,
      price: 100,
      discount: 0,
      prc: 100,
      ttCatCd: 'B',
      active: true,
    );

class _CartHarness extends ConsumerStatefulWidget {
  const _CartHarness({super.key});

  @override
  ConsumerState<_CartHarness> createState() => CartHarnessState();
}

class CartHarnessState extends ConsumerState<_CartHarness>
    with TransactionItemTable<_CartHarness> {
  @override
  Widget build(BuildContext context) {
    // Subscribe so provider changes rebuild the harness; the mixin reads the
    // same provider synchronously via its [_cartLines] getter.
    ref.watch(posCartDisplayItemsProvider);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text('count:${debugVisibleCartLines.length}'),
    );
  }
}

void main() {
  // The mixin eagerly resolves SettingsService from the locator at construction.
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!locator.isRegistered<SettingsService>()) {
      locator.registerLazySingleton<SettingsService>(_MockSettingsService.new);
    }
  });

  tearDownAll(() {
    if (locator.isRegistered<SettingsService>()) {
      locator.unregister<SettingsService>();
    }
  });

  testWidgets(
    'clearCartLinesOptimistically empties the cart immediately, even while the '
    'provider still reports the completed sale lines',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          posCartDisplayItemsProvider
              .overrideWith((ref) => ref.watch(_cartSourceProvider)),
        ],
      );
      addTearDown(container.dispose);

      final harnessKey = GlobalKey<CartHarnessState>();

      // Sale in progress: two lines in the cart.
      container.read(_cartSourceProvider.notifier).state = [
        _line('a'),
        _line('b'),
      ];

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _CartHarness(key: harnessKey),
        ),
      );
      expect(find.text('count:2'), findsOneWidget);

      // Payment succeeds. The merged provider still returns the old lines (the
      // Ditto stream hasn't reconciled yet) — the cart must still clear now.
      harnessKey.currentState!.clearCartLinesOptimistically();
      await tester.pump();

      expect(
        find.text('count:0'),
        findsOneWidget,
        reason: 'cart should be empty the instant the sale completes',
      );

      // Next sale: a fresh line with a new id must appear (not suppressed by the
      // previous sale's optimistic-delete ids).
      container.read(_cartSourceProvider.notifier).state = [_line('c')];
      await tester.pump();

      expect(
        find.text('count:1'),
        findsOneWidget,
        reason: 'the next sale must show its lines normally',
      );
    },
  );

  testWidgets('clearCartLinesOptimistically is a no-op on an empty cart',
      (tester) async {
    final container = ProviderContainer(
      overrides: [
        posCartDisplayItemsProvider
            .overrideWith((ref) => ref.watch(_cartSourceProvider)),
      ],
    );
    addTearDown(container.dispose);

    final harnessKey = GlobalKey<CartHarnessState>();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: _CartHarness(key: harnessKey),
      ),
    );
    expect(find.text('count:0'), findsOneWidget);

    harnessKey.currentState!.clearCartLinesOptimistically();
    await tester.pump();

    expect(find.text('count:0'), findsOneWidget);
  });
}
