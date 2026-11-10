import 'dart:async';

import 'package:flipper_dashboard/items_dialog.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/visible_stocks_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

import '../test_helpers/mocks.dart';
import '../test_helpers/setup.dart';

/// Serves a fixed list instead of paging the catalog.
class _FixedVariants extends OuterVariants {
  _FixedVariants(this.variants);

  final List<Variant> variants;

  @override
  FutureOr<List<Variant>> build(
    String branchId, {
    PosStockFilter stockFilter = PosStockFilter.all,
  }) => variants;
}

Variant _variant(int i) => Variant(
  id: 'var-$i',
  name: 'Item $i',
  retailPrice: 500,
  branchId: '1',
  stockId: 'stock-$i',
  stock: Stock(id: 'stock-$i', branchId: '1', currentStock: 7),
);

/// The Items dialog gave each row its own stock observer, a synchronous Ditto
/// call on the UI thread, again on every search keystroke. It now reads every
/// row from one batched observer keyed on all rows.
///
/// Run from `flipper/packages/flipper_dashboard`:
/// `flutter test test/widgets/items_dialog_batched_stock_test.dart --dart-define=FLUTTER_TEST_ENV=true`
void main() {
  late TestEnvironment env;
  late int rowObservers;
  late List<String> batches;
  final variants = [for (var i = 0; i < 4; i++) _variant(i)];

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

  Future<void> pumpDialog(
    WidgetTester tester,
    Stream<Map<String, Stock?>> Function() batch,
  ) async {
    tester.view.physicalSize = const Size(1000, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          outerVariantsProvider(
            '1',
          ).overrideWith(() => _FixedVariants(variants)),
          stocksByIdsProvider.overrideWith((ref, key) {
            batches.add(key);
            return batch();
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
            body: ItemsDialog(request: DialogRequest(), completer: (_) {}),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('one observer for every row, kept while searching', (
    tester,
  ) async {
    await pumpDialog(
      tester,
      () => Stream.value({
        for (final v in variants)
          v.stockId!: Stock(id: v.stockId, branchId: '1', currentStock: 41),
      }),
    );

    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Stock: 41.0'), findsNWidgets(variants.length));
    expect(rowObservers, 0);

    await tester.enterText(find.byType(TextField), 'Item 2');
    await tester.pump();
    await tester.pump();

    expect(find.text('Item 0'), findsNothing);
    expect(find.text('Stock: 41.0'), findsOneWidget);
    expect(batches.toSet(), {stockIdsKey(variants)});
    expect(rowObservers, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('before the batch has a value, rows show their own stock', (
    tester,
  ) async {
    await pumpDialog(tester, () => const Stream<Map<String, Stock?>>.empty());

    expect(find.text('Stock: 7.0'), findsNWidgets(variants.length));
    expect(find.textContaining('loading'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
