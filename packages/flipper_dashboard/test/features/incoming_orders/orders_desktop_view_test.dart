import 'package:flipper_dashboard/features/incoming_orders/desktop/orders_desktop_view.dart';
import 'package:flipper_dashboard/features/incoming_orders/desktop/orders_request_detail.dart';
import 'package:flipper_dashboard/features/incoming_orders/desktop/orders_request_table.dart';
import 'package:flipper_dashboard/features/incoming_orders/screens/incoming_orders_screen.dart';
import 'package:flipper_dashboard/features/incoming_orders/widgets/request_card.dart';
import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart';
import 'package:flipper_dashboard/providers/navigation_providers.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/branch_by_id_provider.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/providers/selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<InventoryRequest> _incoming = const [];

class _Incoming extends StockRequests {
  @override
  Stream<List<InventoryRequest>> build({
    required String status,
    String? search,
  }) => Stream.value(_incoming);
}

class _Outgoing extends OutgoingStockRequests {
  @override
  Stream<List<InventoryRequest>> build({
    required String status,
    String? search,
  }) => Stream.value(const []);
}

TransactionItem _item(String id, String name, int requested) => TransactionItem(
  id: id,
  ttCatCd: 'B',
  name: name,
  qty: requested.toDouble(),
  price: 100,
  discount: 0,
  prc: 100,
  quantityRequested: requested,
  quantityApproved: 0,
  branchId: 'br1',
  transactionId: 't-$id',
);

InventoryRequest _request(
  String id,
  String from,
  List<TransactionItem> items,
) => InventoryRequest(
  id: id,
  branchId: 'br1',
  status: 'pending',
  branch: Branch(id: 'sub-$id', name: from, businessId: 'b1'),
  subBranchId: 'sub-$id',
  mainBranchId: 'br1',
  itemCounts: items.length,
  transactionItems: items,
  createdAt: DateTime(2026, 11, 21, 14, 2),
);

/// Real desktop logical pixels (see ordering_panes_smoke_test: the view,
/// not `setSurfaceSize`).
void _surface(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Future<void> _pump(
  WidgetTester tester, {
  Size size = const Size(1440, 900),
}) async {
  _surface(tester, size);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        stockRequestsProvider.overrideWith(_Incoming.new),
        outgoingStockRequestsProvider.overrideWith(_Outgoing.new),
        activeBranchProvider.overrideWith(
          (ref) => Stream.value(
            Branch(id: 'br1', name: 'Demo Shop', businessId: 'b1'),
          ),
        ),
        branchByIdProvider.overrideWith((ref, branchId) => Stream.value(null)),
        sideMenuShowIncomingOrdersProvider.overrideWithValue(true),
        onlineShopAvailableProvider.overrideWithValue(false),
        newOnlineOrdersCountProvider.overrideWithValue(0),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        home: const Scaffold(body: IncomingOrdersScreen()),
      ),
    ),
  );
  // pumpAndSettle times out on this screen, so pump a fixed time.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  setUp(() {
    _incoming = [
      _request('aaaaa-1', 'Kigali Main', [
        _item('i1', 'Rice 25kg', 4),
        _item('i2', 'Sugar 1kg', 10),
      ]),
      _request('bbbbb-2', 'Musanze', [_item('i3', 'Cooking Oil 5L', 6)]),
    ];
  });

  testWidgets('desktop shows a request table and the first request in detail', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.byType(OrdersDesktopView), findsOneWidget);
    expect(find.byType(RequestCard), findsNothing);
    // No hero title or stat card: the toolbar and table carry the page.
    expect(find.text('Orders Management'), findsNothing);
    expect(find.text('Pending Requests'), findsNothing);

    expect(find.text('Received Orders'), findsOneWidget);
    expect(find.text('2 requests'), findsOneWidget);
    expect(find.text('Kigali Main'), findsOneWidget);
    expect(find.text('Musanze'), findsOneWidget);
    expect(find.text('BRANCH'), findsOneWidget);

    final detail = find.byType(OrdersRequestDetail);
    expect(detail, findsOneWidget);
    expect(
      find.descendant(of: detail, matching: find.text('Rice 25kg')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detail, matching: find.text('Approve')),
      findsOneWidget,
    );
  });

  testWidgets('clicking a row opens it; arrow keys move through the list', (
    tester,
  ) async {
    await _pump(tester);

    await tester.tap(find.text('Musanze'));
    await tester.pump();
    final detail = find.byType(OrdersRequestDetail);
    expect(
      find.descendant(of: detail, matching: find.text('Cooking Oil 5L')),
      findsOneWidget,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(
      find.descendant(of: detail, matching: find.text('Rice 25kg')),
      findsOneWidget,
    );
  });

  testWidgets('header checkbox selects every request for bulk actions', (
    tester,
  ) async {
    await _pump(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(OrdersDesktopView)),
    );

    // The header's only tap target is its select-all checkbox.
    final selectAll = find.descendant(
      of: find.byType(OrdersTableHeader),
      matching: find.byType(GestureDetector),
    );
    await tester.tap(selectAll);
    await tester.pump();
    expect(container.read(selectionProvider), {'aaaaa-1', 'bbbbb-2'});
    expect(find.text('2 selected'), findsOneWidget);

    // Tapping again clears it.
    await tester.tap(selectAll);
    await tester.pump();
    expect(container.read(selectionProvider), isEmpty);
  });

  testWidgets('no requests: compact empty state and no detail pane', (
    tester,
  ) async {
    _incoming = const [];
    await _pump(tester);

    expect(find.text('No pending requests'), findsOneWidget);
    expect(find.text('0 requests'), findsOneWidget);
    expect(find.byType(OrdersRequestDetail), findsNothing);
  });

  testWidgets('wide desktops show every column', (tester) async {
    await _pump(tester);

    for (final label in ['ITEMS', 'QTY', 'DELIVERY', 'STATUS']) {
      expect(_header(label), findsOneWidget, reason: label);
    }
    // The card's 1px border sits around the detail.
    expect(
      tester.getSize(find.byType(OrdersRequestDetail)).width,
      moreOrLessEquals(OrdersDesktopView.detailWidth, epsilon: 2),
    );
  });

  /// Header labels are single-line with an ellipsis: a clipped column shows
  /// as a paragraph that exceeded its line.
  void expectUnclipped(WidgetTester tester, String label) {
    final paragraph = tester.renderObject<RenderParagraph>(_header(label));
    expect(paragraph.didExceedMaxLines, isFalse, reason: '$label is clipped');
  }

  testWidgets('a 1024px till keeps counts readable', (tester) async {
    await _pump(tester, size: const Size(1024, 768));

    expect(find.byType(OrdersDesktopView), findsOneWidget);
    for (final label in ['ITEMS', 'QTY', 'STATUS']) {
      expectUnclipped(tester, label);
    }
    // Delivery is in the detail pane; the table drops it first.
    expect(_header('DELIVERY'), findsNothing);
    // The narrower detail pane leaves the table its room.
    expect(
      tester.getSize(find.byType(OrdersRequestDetail)).width,
      lessThan(OrdersDesktopView.detailWidth),
    );
    final qtyHeader = tester.getSize(_header('QTY'));
    expect(qtyHeader.width, greaterThan(40));
  });

  testWidgets('the narrowest desktop drops Items before squeezing Qty', (
    tester,
  ) async {
    await _pump(tester, size: const Size(880, 700));

    expect(find.byType(OrdersDesktopView), findsOneWidget);
    expect(_header('ITEMS'), findsNothing);
    expect(_header('DELIVERY'), findsNothing);
    expectUnclipped(tester, 'QTY');
    expectUnclipped(tester, 'STATUS');
    expect(
      tester.getSize(find.byType(OrdersRequestDetail)).width,
      inInclusiveRange(
        OrdersDesktopView.minDetailWidth - 2,
        OrdersDesktopView.detailWidth * 0.8,
      ),
    );
  });

  test('the detail pane is 40% of the row, within its bounds', () {
    expect(
      OrdersDesktopView.detailWidthFor(600),
      OrdersDesktopView.minDetailWidth,
    );
    expect(OrdersDesktopView.detailWidthFor(1000), 400);
    expect(
      OrdersDesktopView.detailWidthFor(2000),
      OrdersDesktopView.detailWidth,
    );
  });

  test('columns drop Delivery, then Items, as the table narrows', () {
    expect(ordersColumnsFor(700), OrdersColumn.values);
    expect(ordersColumnsFor(600), isNot(contains(OrdersColumn.delivery)));
    expect(ordersColumnsFor(600), contains(OrdersColumn.items));
    expect(ordersColumnsFor(500), [
      OrdersColumn.branch,
      OrdersColumn.requested,
      OrdersColumn.qty,
      OrdersColumn.status,
    ]);
  });

  testWidgets('a full page of requests reads as 50+, not a total', (
    tester,
  ) async {
    _incoming = [
      for (var i = 0; i < stockRequestsPageSize; i++)
        _request('req-$i', 'Shop $i', [_item('i$i', 'Rice', 1)]),
    ];
    await _pump(tester);

    expect(find.text('50+'), findsOneWidget);
    expect(pagedCountLabel(0), '0');
    expect(pagedCountLabel(2), '2');
    expect(pagedCountLabel(100), '100+');
  });

  testWidgets('a short list shows its exact count', (tester) async {
    await _pump(tester);

    expect(find.text('2'), findsWidgets);
    expect(find.text('2+'), findsNothing);
  });

  testWidgets('Approve is the page brand blue', (tester) async {
    await _pump(tester);

    final approve = find.descendant(
      of: find.byType(OrdersRequestDetail),
      matching: find.text('Approve'),
    );
    final material = tester.widget<Material>(
      find.ancestor(of: approve, matching: find.byType(Material)).first,
    );
    expect(material.color, PosTokens.blue);
  });

  testWidgets('narrow windows keep the card list', (tester) async {
    await _pump(tester, size: const Size(700, 900));

    expect(find.byType(OrdersDesktopView), findsNothing);
    expect(find.byType(RequestCard), findsNWidgets(2));
    expect(find.text('Orders Management'), findsOneWidget);
  });
}

/// A column label in the table header (the detail pane has its own ITEMS).
Finder _header(String label) => find.descendant(
  of: find.byType(OrdersTableHeader),
  matching: find.text(label),
);
