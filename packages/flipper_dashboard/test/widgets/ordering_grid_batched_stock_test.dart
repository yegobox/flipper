import 'dart:async';

import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_dashboard/ordering/product_grid_view.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/providers/visible_stocks_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

import '../test_helpers/mocks.dart';
import '../test_helpers/setup.dart';

class _MockProductViewModel extends Mock implements ProductViewModel {}

Variant _variant(int i) => Variant(
  id: 'var-$i',
  name: 'Supplier SKU $i',
  retailPrice: 500,
  branchId: 'supplier',
  stockId: 'stock-$i',
  stock: Stock(id: 'stock-$i', branchId: 'supplier', currentStock: 7),
);

/// The ordering grid gave each supplier card its own stock observer, a
/// synchronous Ditto call on the UI thread, again on every supplier search
/// keystroke. It now reads every card from one batched observer.
///
/// Run from `flipper/packages/flipper_dashboard`:
/// `flutter test test/widgets/ordering_grid_batched_stock_test.dart --dart-define=FLUTTER_TEST_ENV=true`
void main() {
  late TestEnvironment env;
  late int rowObservers;
  late List<String> batches;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupPathProviderMock();
    env = TestEnvironment();
    await env.init();
  });

  tearDownAll(() => env.dispose());

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
    rowObservers = 0;
    batches = <String>[];
  });

  tearDown(() => env.restore());

  testWidgets('one observer for the whole grid, none per card', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final variants = [for (var i = 0; i < 6; i++) _variant(i)];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          canSellProvider.overrideWithValue(true),
          pendingTransactionStreamProvider(isExpense: false).overrideWith((
            ref,
          ) {
            final controller = StreamController<ITransaction>();
            ref.onDispose(controller.close);
            return controller.stream;
          }),
          stocksByIdsProvider.overrideWith((ref, key) {
            batches.add(key);
            return Stream.value({
              for (final id in key.split(','))
                id: Stock(id: id, branchId: 'supplier', currentStock: 41),
            });
          }),
          for (final v in variants)
            stockByVariantProvider(v.stockId!).overrideWith((ref) {
              rowObservers++;
              return const Stream<Stock?>.empty();
            }),
        ],
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            body: ProductGridView(
              variants: variants,
              model: _MockProductViewModel(),
              isOrdering: true,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(rowObservers, 0);
    expect(batches.toSet(), {stockIdsKey(variants)});
    final cards = tester.widgetList<RowItem>(find.byType(RowItem)).toList();
    expect(cards, isNotEmpty);
    expect(cards.every((c) => c.stockFromBatch), isTrue);
    expect(cards.first.liveStock?.currentStock, 41);
    expect(tester.takeException(), isNull);
  });
}
