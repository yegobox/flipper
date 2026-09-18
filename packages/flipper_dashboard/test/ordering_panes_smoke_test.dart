import 'package:flipper_dashboard/ordering/ordering_cart_panel.dart';
import 'package:flipper_dashboard/ordering/ordering_supplier_picker.dart';
import 'package:flipper_dashboard/ordering/ordering_top_bar.dart';
import 'package:flipper_dashboard/ordering/ordering_catalog_rail.dart';
import 'package:flipper_dashboard/ordering/ordering_catalog_table.dart';
import 'package:flipper_dashboard/ordering/ordering_state.dart';
import 'package:flipper_dashboard/ordering/ordering_tokens.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/states/productListProvider.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

// Deliberately does not import `test_helpers/mocks.dart`: that pulls in
// `flipper_services/local_notification_service.dart`, which currently fails to
// compile against the resolved `flutter_local_notifications`.
class _MockBox extends Mock implements LocalStorage {
  @override
  String defaultCurrency() => 'RWF';

  @override
  String? getBranchId() => 'b1';

  @override
  bool? isOrdering() => true;
}

Variant _variant(String id, String name, String category, double stock) =>
    Variant(
      id: id,
      name: name,
      productId: 'p$id',
      branchId: 'b1',
      categoryName: category,
      sku: 'SKU-$id',
      unit: 'pcs',
      supplyPrice: 11000,
      retailPrice: 14500,
      stock: Stock(id: 's$id', branchId: 'b1', currentStock: stock),
    );


TransactionItem _line(String id, String name, num qty, num price) =>
    TransactionItem(
      id: id,
      name: name,
      transactionId: 't1',
      variantId: id,
      branchId: 'b1',
      qty: qty,
      price: price,
      discount: 0,
      prc: price.toDouble(),
      ttCatCd: 'B',
      active: true,
      taxAmt: (price * qty) * 0.18,
    );


/// Lays the pane out at real desktop logical pixels.
///
/// The view, not `setSurfaceSize`: with the devicePixelRatio pinned,
/// `setSurfaceSize` leaves `view.physicalSize` untouched and every pane is
/// measured at the default 800x600 — which is not the layout being checked.
void _useDesktopSurface(WidgetTester tester, Size logicalSize) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = logicalSize;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<LocalStorage>(_MockBox());
  });

  Future<void> pump(
    WidgetTester tester,
    List<Variant> products, {
    Size size = const Size(900, 700),
  }) async {
    _useDesktopSurface(tester, size);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productFromSupplierWrapper.overrideWith((ref) async => products),
          posCartQtyByVariantIdProvider.overrideWithValue(
            products.isEmpty ? {} : {products.first.id: 3},
          ),
          orderingShowMarginProvider.overrideWith((ref) => true),
        ],
        child: MaterialApp(
          home: Scaffold(
            backgroundColor: OrderingTokens.bg,
            body: OrderingCatalogTable(
              searchController: TextEditingController(),
              searchFocusNode: FocusNode(),
              onSubmitted: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('catalogue table renders rows, headers and the stepper',
      (tester) async {
    await pump(tester, [
      _variant('1', 'EQUERRE NTO', 'Tools', 600),
      _variant('2', 'COUDE ADAPTER', 'Plumbing', 12),
      _variant('3', 'ATTACH 25', 'Plumbing', 0),
    ]);

    expect(tester.takeException(), isNull);
    expect(find.text('PRODUCT'), findsOneWidget);
    expect(find.text('THEIR STOCK'), findsOneWidget);
    expect(find.text('RETAIL · MARGIN'), findsOneWidget);
    expect(find.text('ORDER QTY'), findsOneWidget);
    expect(find.text('3 of 3 products'), findsOneWidget);
    // Category sections.
    expect(find.text('TOOLS'), findsOneWidget);
    expect(find.text('PLUMBING'), findsOneWidget);
    // The row with cart qty shows a stepper; the others an Add button.
    expect(find.text('Add'), findsNWidgets(2));
    // Known-zero stock reads "none", not "0".
    expect(find.text('none'), findsOneWidget);
  });

  testWidgets('a narrow catalogue pane drops the margin column rather than '
      'overflowing', (tester) async {
    // 1000px window - 186 rail - 300 cart is the tightest pane the workspace
    // ever hands the table.
    await pump(
      tester,
      [
        _variant('1', 'EQUERRE NTO', 'Tools', 600),
        _variant('2', 'COUDE ADAPTER', 'Plumbing', 12),
      ],
      size: const Size(514, 700),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('RETAIL · MARGIN'), findsNothing);
    // The columns that decide the order are still there.
    expect(find.text('THEIR STOCK'), findsOneWidget);
    expect(find.text('UNIT COST'), findsOneWidget);
    expect(find.text('ORDER QTY'), findsOneWidget);
  });

  testWidgets('empty catalogue shows the nothing-to-order state',
      (tester) async {
    await pump(tester, const []);

    expect(tester.takeException(), isNull);
    expect(
      find.text('This supplier has no products to order'),
      findsOneWidget,
    );
  });

  group('order pane', () {
    FinanceProvider finance(String id, String name) => FinanceProvider(
      id: id,
      name: name,
      interestRate: 0,
      suppliersThatAcceptThisFinanceFacility: '',
    );

    var placeTaps = 0;

    Future<void> pumpCartWithFinance(
      WidgetTester tester,
      List<FinanceProvider> providers, {
      List<TransactionItem> lines = const [],
    }) async {
      _useDesktopSurface(tester, const Size(430, 900));
      placeTaps = 0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            posCartDisplayItemsProvider.overrideWithValue(lines),
            productFromSupplierWrapper.overrideWith((ref) async => const []),
            orderingFinanceOptionsProvider.overrideWith(
              (ref) async => providers,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: OrderingCartPanel(
                supplierName: 'Quincaillerie Rubavu',
                noteController: TextEditingController(),
                isPlacing: false,
                onPlaceOrder: () => placeTaps++,
                onStartAnother: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('with no payment option configured the order still goes',
        (tester) async {
      await pumpCartWithFinance(
        tester,
        const [],
        lines: [_line('1', 'EQUERRE NTO', 1, 11000)],
      );

      expect(tester.takeException(), isNull);
      // The dead end: financing is optional downstream, so nothing to set up
      // must not read as something missing.
      expect(
        find.textContaining('the order will be sent without one'),
        findsOneWidget,
      );
      expect(find.textContaining('Place order · RWF'), findsOneWidget);

      await tester.tap(find.textContaining('Place order · RWF'));
      await tester.pump();
      expect(placeTaps, 1);
    });

    testWidgets('a lone payment option is taken without a click',
        (tester) async {
      await pumpCartWithFinance(
        tester,
        [finance('f1', 'Supplier credit')],
        lines: [_line('1', 'EQUERRE NTO', 1, 11000)],
      );

      expect(find.text('Supplier credit'), findsOneWidget);
      // One option is not a choice; blocking on it would be busywork.
      expect(find.textContaining('Place order · RWF'), findsOneWidget);
      await tester.tap(find.textContaining('Place order · RWF'));
      await tester.pump();
      expect(placeTaps, 1);
    });

    testWidgets('several options do block until one is picked',
        (tester) async {
      await pumpCartWithFinance(
        tester,
        [finance('f1', 'Supplier credit'), finance('f2', 'MoMo')],
        lines: [_line('1', 'EQUERRE NTO', 1, 11000)],
      );

      expect(find.text('Choose how you are paying'), findsOneWidget);
      await tester.tap(find.text('Choose how you are paying'));
      await tester.pump();
      expect(placeTaps, 0, reason: 'the button is disabled, not silently inert');

      await tester.tap(find.text('MoMo'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Place order · RWF'), findsOneWidget);
      await tester.tap(find.textContaining('Place order · RWF'));
      await tester.pump();
      expect(placeTaps, 1);
    });

    Future<void> pumpCart(
      WidgetTester tester, {
      required List<TransactionItem> lines,
    }) async {
      _useDesktopSurface(tester, const Size(430, 760));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            posCartDisplayItemsProvider.overrideWithValue(lines),
            productFromSupplierWrapper.overrideWith(
              (ref) async => [_variant('1', 'EQUERRE NTO', 'Tools', 600)],
            ),
            orderingFinanceOptionsProvider.overrideWith(
              (ref) async => [
                FinanceProvider(
                  id: 'f1',
                  name: 'Supplier credit',
                  interestRate: 0,
                  suppliersThatAcceptThisFinanceFacility: '',
                ),
              ],
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: OrderingCartPanel(
                supplierName: 'Quincaillerie Rubavu',
                noteController: TextEditingController(),
                isPlacing: false,
                onPlaceOrder: () {},
                onStartAnother: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('empty order prompts for the first line', (tester) async {
      await pumpCart(tester, lines: const []);

      expect(tester.takeException(), isNull);
      expect(find.text('This order'), findsOneWidget);
      expect(find.text('empty'), findsOneWidget);
      expect(find.text('No lines yet'), findsOneWidget);
      // Nothing to send yet.
      expect(find.text('Add a product to continue'), findsOneWidget);
      expect(find.text('Clear all'), findsNothing);
    });

    testWidgets('lines total up and the submit names the amount',
        (tester) async {
      await pumpCart(
        tester,
        lines: [_line('1', 'EQUERRE NTO', 3, 11000)],
      );

      expect(tester.takeException(), isNull);
      expect(find.text('1 line · 3 units'), findsOneWidget);
      expect(find.text('Clear all'), findsOneWidget);
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('VAT 18%'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Supplier credit'), findsOneWidget);
      expect(
        find.textContaining('Place order · RWF 38,940'),
        findsOneWidget,
      );
    });

    testWidgets('a line fits the narrowest panel with both warnings',
        (tester) async {
      _useDesktopSurface(
        tester,
        const Size(OrderingTokens.cartMinWidth, 760),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            posCartDisplayItemsProvider.overrideWithValue([
              _line(
                '1',
                'SILCONE RTV 100% BLACK CARTRIDGE EXTRA LONG NAME',
                40,
                13500,
              ),
            ]),
            productFromSupplierWrapper.overrideWith(
              (ref) async => [
                // Ordering 40 against 12 on hand, at a cost above the last
                // one: both badges render on the same line.
                _variant('1', 'SILCONE RTV', 'Adhesives', 12),
              ],
            ),
            orderingFinanceOptionsProvider.overrideWith(
              (ref) async => const [],
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: OrderingCartPanel(
                supplierName: 'Quincaillerie Rubavu',
                noteController: TextEditingController(),
                isPlacing: false,
                onPlaceOrder: () {},
                onStartAnother: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('only 12 available'), findsOneWidget);
      expect(find.textContaining('vs last'), findsOneWidget);
    });

    testWidgets('the confirmation replaces the cart once sent',
        (tester) async {
      _useDesktopSurface(tester, const Size(430, 760));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            posCartDisplayItemsProvider.overrideWithValue(const []),
            productFromSupplierWrapper.overrideWith((ref) async => const []),
            orderingFinanceOptionsProvider.overrideWith(
              (ref) async => const [],
            ),
            orderingPlacedProvider.overrideWith(
              (ref) => const PlacedOrder(
                supplierName: 'Quincaillerie Rubavu',
                lineCount: 2,
                unitCount: 7,
                total: 129800,
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: OrderingCartPanel(
                supplierName: 'Quincaillerie Rubavu',
                noteController: TextEditingController(),
                isPlacing: false,
                onPlaceOrder: () {},
                onStartAnother: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        find.text('Order sent to Quincaillerie Rubavu'),
        findsOneWidget,
      );
      expect(
        find.textContaining('2 lines · 7 units · RWF 129,800'),
        findsOneWidget,
      );
      expect(find.text('Start another order'), findsOneWidget);
      // The cart chrome is gone.
      expect(find.text('This order'), findsNothing);
    });
  });

  group('catalogue rail', () {
    testWidgets('lists categories with counts and the filters',
        (tester) async {
      _useDesktopSurface(tester, const Size(OrderingTokens.railWidth, 700));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productFromSupplierWrapper.overrideWith(
              (ref) async => [
                _variant('1', 'EQUERRE NTO', 'Tools', 600),
                _variant('2', 'COUDE ADAPTER', 'Plumbing', 12),
                _variant('3', 'ATTACH 25', 'Plumbing', 0),
              ],
            ),
            orderingLastOrderProvider('b2').overrideWith(
              (ref) => Stream.value(
                LastOrder(
                  total: 486500,
                  lineCount: 11,
                  placedAt: DateTime(2026, 9, 4),
                  status: 'fulfilled',
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: OrderingCatalogRail(supplierId: 'b2')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('CATEGORIES'), findsOneWidget);
      expect(find.text('All products'), findsOneWidget);
      expect(find.text('Plumbing'), findsOneWidget);
      expect(find.text('In stock only'), findsOneWidget);
      // Counts are over the whole catalogue.
      expect(find.text('3'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      // Last-order card.
      expect(find.text('LAST ORDER'), findsOneWidget);
      expect(find.text('RWF 486,500'), findsOneWidget);
      expect(find.text('11 lines · 4 Sep 2026 · fulfilled'), findsOneWidget);
      // Wide catalogue pane: the margin toggle is on offer.
      expect(find.text('Show retail margin'), findsOneWidget);
    });

    testWidgets('withholds the margin toggle when the pane cannot show it',
        (tester) async {
      _useDesktopSurface(
        tester,
        const Size(OrderingTokens.railWidth, 700),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            productFromSupplierWrapper.overrideWith(
              (ref) async => [_variant('1', 'EQUERRE NTO', 'Tools', 600)],
            ),
            orderingLastOrderProvider('b2').overrideWith(
              (ref) => Stream.value(null),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: OrderingCatalogRail(
                supplierId: 'b2',
                marginColumnFits: false,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('In stock only'), findsOneWidget);
      expect(find.text('Show retail margin'), findsNothing);
      expect(
        find.text('No previous order with this supplier.'),
        findsOneWidget,
      );
    });
  });

  group('supplier picker', () {
    var addTaps = 0;

    Future<void> pumpPicker(
      WidgetTester tester, {
      List<Branch> frequent = const [],
      List<Branch> others = const [],
      Size size = const Size(1000, 760),
    }) async {
      _useDesktopSurface(tester, size);
      addTaps = 0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            orderingSupplierOptionsProvider.overrideWith(
              (ref) async =>
                  SupplierOptions(frequent: frequent, others: others),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: OrderingSupplierPicker(
                onPicked: (_) {},
                onAddSupplier: () => addTaps++,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Branch branch(String id, String name, {String? place, String? line}) =>
        Branch(
          id: id,
          name: name,
          businessId: 'biz',
          location: place,
          description: line,
        );

    testWidgets('ranks ordered-from suppliers above the rest of the roster',
        (tester) async {
      await pumpPicker(
        tester,
        frequent: [
          branch(
            'b2',
            'Quincaillerie Rubavu',
            place: 'Rubavu',
            line: '126 shared items',
          ),
        ],
        others: [branch('b3', 'Muhima Hardware'), branch('b4', 'duhire')],
      );

      expect(tester.takeException(), isNull);
      expect(
        find.text('Which supplier are you ordering from?'),
        findsOneWidget,
      );
      expect(find.text('SUPPLIERS YOU ORDER FROM MOST'), findsOneWidget);
      expect(find.text('Quincaillerie Rubavu'), findsOneWidget);
      expect(find.text('126 shared items'), findsOneWidget);
      expect(find.text('Rubavu'), findsOneWidget);

      // The regression: branches never ordered from are still reachable, so a
      // business with a large roster and little order history is not shown two
      // rows and a dead end. The count is what tells a big roster to search.
      expect(
        find.text('OTHER BRANCHES YOU CAN ORDER FROM · 2'),
        findsOneWidget,
      );
      expect(find.text('Muhima Hardware'), findsOneWidget);
      expect(find.text('duhire'), findsOneWidget);
    });

    testWidgets('with no order history, the roster carries the whole list',
        (tester) async {
      await pumpPicker(
        tester,
        others: [branch('b3', 'Muhima Hardware')],
      );

      expect(tester.takeException(), isNull);
      expect(find.text('SUPPLIERS YOU ORDER FROM MOST'), findsNothing);
      expect(find.text('BRANCHES YOU CAN ORDER FROM · 1'), findsOneWidget);
      expect(find.text('Muhima Hardware'), findsOneWidget);
    });

    testWidgets('a long roster builds lazily instead of all at once',
        (tester) async {
      final roster = [
        for (var i = 0; i < 300; i++)
          branch('b$i', 'Branch ${i.toString().padLeft(3, '0')}'),
      ];

      await pumpPicker(tester, others: roster, size: const Size(900, 760));

      expect(tester.takeException(), isNull);
      expect(find.text('BRANCHES YOU CAN ORDER FROM · 300'), findsOneWidget);
      expect(find.text('Branch 000'), findsOneWidget);
      // The point: row 299 is not in the tree until it is scrolled to. A
      // Column would have built all 300 cards before painting the first.
      expect(find.text('Branch 299'), findsNothing);

      await tester.scrollUntilVisible(
        find.text('Branch 299'),
        600,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Branch 299'), findsOneWidget);
    });

    testWidgets('typing filters the roster on the keystroke', (tester) async {
      await pumpPicker(
        tester,
        frequent: [branch('b2', 'Quincaillerie Rubavu', place: 'Rubavu')],
        others: [branch('b3', 'Muhima Hardware'), branch('b4', 'duhire')],
      );

      await tester.enterText(find.byType(TextField), 'muh');
      // One frame only — no debounce wait. The local roster must answer
      // immediately; only the remote name search is debounced.
      await tester.pump();

      expect(find.text('ON THIS DEVICE · 1'), findsOneWidget);
      expect(find.text('Muhima Hardware'), findsOneWidget);
      expect(find.text('duhire'), findsNothing);
      expect(find.text('Quincaillerie Rubavu'), findsNothing);
      // The unsearched headings give way to the result sections.
      expect(find.text('SUPPLIERS YOU ORDER FROM MOST'), findsNothing);
    });

    testWidgets('search matches a place, not just a name', (tester) async {
      await pumpPicker(
        tester,
        others: [
          branch('b3', 'Muhima Hardware', place: 'Muhima'),
          branch('b5', 'Quincaillerie', place: 'Rubavu'),
        ],
      );

      await tester.enterText(find.byType(TextField), 'rubavu');
      await tester.pump();

      expect(find.text('Quincaillerie'), findsOneWidget);
      expect(find.text('Muhima Hardware'), findsNothing);
    });

    testWidgets('a query matching nothing local says so', (tester) async {
      await pumpPicker(tester, others: [branch('b3', 'Muhima Hardware')]);

      await tester.enterText(find.byType(TextField), 'zzzz');
      await tester.pump();

      expect(find.textContaining('No supplier matches'), findsOneWidget);
    });

    testWidgets('says so when there is nothing to order from', (tester) async {
      await pumpPicker(tester);

      expect(tester.takeException(), isNull);
      expect(find.text('No other branch to order from'), findsOneWidget);
    });

    testWidgets('Add a new supplier is wired up', (tester) async {
      await pumpPicker(tester, others: [branch('b3', 'Muhima Hardware')]);

      expect(find.text('Add a new supplier'), findsOneWidget);
      await tester.tap(find.text('Add a new supplier'));
      await tester.pump();

      // It was inert: the picker took an optional callback the screen never
      // passed, so the link rendered enabled and did nothing.
      expect(addTaps, 1);
    });

    testWidgets('a long supplier row still fits a narrow window',
        (tester) async {
      await pumpPicker(
        tester,
        size: const Size(620, 700),
        frequent: [
          branch(
            'b3',
            'Quincaillerie et Materiaux de Construction Rubavu Nord',
            place: 'Rubavu · Gisenyi sector depot number four',
            line:
                'A description long enough to force the row to elide '
                'rather than overflow its card',
          ),
        ],
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('top bar', () {
    Future<void> pumpTopBar(
      WidgetTester tester, {
      Branch? supplier,
      Size size = const Size(1280, 200),
    }) async {
      _useDesktopSurface(tester, size);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeBranchProvider.overrideWith(
              (ref) => Stream.value(
                Branch(id: 'b1', name: 'Kigali · Main', businessId: 'biz'),
              ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: OrderingTopBar(
                transaction: ITransaction(
                  id: 'ab12cd34-0000-0000-0000-000000000000',
                  transactionNumber: '2026-0418',
                  status: 'pending',
                  transactionType: 'purchase',
                  subTotal: 0,
                  paymentType: 'Cash',
                  cashReceived: 0,
                  customerChangeDue: 0,
                  createdAt: DateTime(2026, 9, 18),
                  receiptType: 'NS',
                  updatedAt: DateTime(2026, 9, 18),
                  isIncome: false,
                  isExpense: true,
                  branchId: 'b1',
                  agentId: null,
                ),
                supplier: supplier,
                onBack: () {},
                onClearSupplier: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('names the order and the branch it is placed from',
        (tester) async {
      await pumpTopBar(tester);

      expect(tester.takeException(), isNull);
      expect(find.text('New purchase order'), findsOneWidget);
      expect(find.text('PO-2026-0418 · Kigali · Main'), findsOneWidget);
      // Shortcut hints only where there is room for them.
      expect(find.text('search'), findsOneWidget);
      expect(find.text('add top match'), findsOneWidget);
    });

    testWidgets('a long supplier chip elides instead of overflowing',
        (tester) async {
      await pumpTopBar(
        tester,
        size: const Size(760, 200),
        supplier: Branch(
          id: 'b2',
          name: 'Quincaillerie et Materiaux de Construction Rubavu Nord',
          businessId: 'biz',
          location: 'Rubavu · Gisenyi sector depot number four',
        ),
      );

      expect(tester.takeException(), isNull);
      // Too narrow for the hints; the supplier still shows.
      expect(find.text('search'), findsNothing);
      expect(
        find.text('Quincaillerie et Materiaux de Construction Rubavu Nord'),
        findsOneWidget,
      );
    });
  });
}
