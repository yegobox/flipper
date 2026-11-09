import 'dart:async';

import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
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

const _stockId = 'stock-grid-1';

/// Each source of a card's stock shows a different number, so the card's text
/// says which one it read.
const _catalogStock = 7; // the variant's own stock, from the catalog read
const _batchStock = 41; // the grid's one batched observer
const _rowObserverStock = 93; // a per-card observer (what froze the till)

Stock _stock(num qty) =>
    Stock(id: _stockId, branchId: '1', currentStock: qty.toDouble());

Variant _variant() => Variant(
  id: 'var-grid-1',
  name: 'Grid SKU',
  retailPrice: 500,
  branchId: '1',
  stockId: _stockId,
  stock: _stock(_catalogStock),
);

/// A grid that builds its card the way the POS grid does, through
/// [Datamixer.buildVariantRow].
class _Grid extends ConsumerStatefulWidget {
  const _Grid({
    required this.model,
    required this.stocksById,
    this.isOrdering = false,
  });

  final ProductViewModel model;
  final Map<String, Stock?>? stocksById;
  final bool isOrdering;

  @override
  ConsumerState<_Grid> createState() => _GridState();
}

class _GridState extends ConsumerState<_Grid> with Datamixer {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 280,
        child: buildVariantRow(
          context: context,
          model: widget.model,
          variant: _variant(),
          isOrdering: widget.isOrdering,
          forceRemoteUrl: false,
          usePosCatalogTile: true,
          stocksById: widget.stocksById,
        ),
      ),
    );
  }
}

/// The desktop POS grid hands each card the stock of one batched observer.
/// A card that opened its own observer instead made a synchronous Ditto call
/// on the UI thread, once per card on every search keystroke, and the till
/// froze for as long as Ditto was busy (46 s to 4 min, 2026-11-09).
///
/// Run from `flipper/packages/flipper_dashboard`:
/// `flutter test test/widgets/pos_grid_batched_stock_test.dart --dart-define=FLUTTER_TEST_ENV=true`
void main() {
  late TestEnvironment env;
  late _MockProductViewModel model;
  late int rowObservers;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupPathProviderMock();
    env = TestEnvironment();
    await env.init();
    model = _MockProductViewModel();
  });

  tearDownAll(() => env.dispose());

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
    rowObservers = 0;
  });

  tearDown(() => env.restore());

  Future<void> pumpGrid(WidgetTester tester, Widget grid) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

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
          // Creating this provider is what registers a per-card observer.
          stockByVariantProvider(_stockId).overrideWith((ref) {
            rowObservers++;
            return Stream<Stock?>.value(_stock(_rowObserverStock));
          }),
        ],
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(body: grid),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  Finder shows(int qty) => find.textContaining(RegExp('(^|\\D)$qty(\\D|\$)'));

  group('a batched POS grid card', () {
    testWidgets('opens no observer of its own while the batch reloads', (
      tester,
    ) async {
      // A search just changed the results: the batch has nothing yet.
      await pumpGrid(
        tester,
        _Grid(model: model, stocksById: const <String, Stock?>{}),
      );

      expect(rowObservers, 0);
      expect(
        tester.widget<RowItem>(find.byType(RowItem)).stockFromBatch,
        isTrue,
      );
      expect(shows(_catalogStock), findsWidgets);
      expect(shows(_rowObserverStock), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows the batched stock once it arrives', (tester) async {
      await pumpGrid(
        tester,
        _Grid(model: model, stocksById: {_stockId: _stock(_batchStock)}),
      );

      expect(rowObservers, 0);
      expect(shows(_batchStock), findsWidgets);
      expect(shows(_catalogStock), findsNothing);
    });

    testWidgets('an ordering card reads the variant stock, not its zero', (
      tester,
    ) async {
      await pumpGrid(
        tester,
        _Grid(
          model: model,
          stocksById: const <String, Stock?>{},
          isOrdering: true,
        ),
      );

      expect(rowObservers, 0);
      expect(shows(_catalogStock), findsWidgets);
    });
  });

  testWidgets('a grid without a batch still watches each card itself', (
    tester,
  ) async {
    // The ordering grid passes no stock map; it keeps its per-card watch.
    await pumpGrid(tester, _Grid(model: model, stocksById: null));

    expect(rowObservers, 1);
    expect(
      tester.widget<RowItem>(find.byType(RowItem)).stockFromBatch,
      isFalse,
    );
    expect(shows(_rowObserverStock), findsWidgets);
  });
}
