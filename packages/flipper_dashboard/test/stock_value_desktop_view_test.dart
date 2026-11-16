import 'package:flipper_dashboard/features/stock_value/stock_value_report_desktop_screen.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/stock_value_report_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// [count] products. Every 10th is out of stock, every 7th (otherwise) is
/// low, and products alternate between two categories.
StockValueReportData _report(int count) {
  final variants = <Variant>[];
  final stocks = <String, Map<String, dynamic>>{};
  for (var i = 0; i < count; i++) {
    final id = 'v$i';
    variants.add(
      Variant(
        id: id,
        name: 'Item ${i.toString().padLeft(4, '0')}',
        branchId: 'b1',
        stockId: 's$id',
        retailPrice: 100.0 + i,
        categoryName: i.isEven ? 'Drinks' : 'Snacks',
      ),
    );
    final qty = i % 10 == 0 ? 0.0 : (i % 7 == 0 ? 4.0 : 50.0);
    stocks['s$id'] = {
      'currentStock': qty,
      'lowStock': 5.0,
      'showLowStockAlert': true,
    };
  }
  return buildStockValueReport(
    branchId: 'b1',
    variants: variants,
    stockById: stocks,
  );
}

/// [count] products, all out of stock with a min-stock alert: every alert
/// is `out`, none `low` or `critical`.
StockValueReportData _allOut(int count) => buildStockValueReport(
  branchId: 'b1',
  variants: [
    for (var i = 0; i < count; i++)
      Variant(
        id: 'o$i',
        name: 'Empty $i',
        branchId: 'b1',
        stockId: 'so$i',
        retailPrice: 100,
        categoryName: i.isEven ? 'Drinks' : 'Snacks',
      ),
  ],
  stockById: {
    for (var i = 0; i < count; i++)
      'so$i': {'currentStock': 0.0, 'lowStock': 5.0, 'showLowStockAlert': true},
  },
);

Future<void> _pump(
  WidgetTester tester,
  StockValueReportData report, {
  Size size = const Size(1440, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Scaffold(
        body: StockValueDesktopView(
          report: report,
          onClose: () {},
          onRefresh: () async {},
        ),
      ),
    ),
  );
  await tester.pump();
}

String _rowsShown(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('stockValueRowsShown'))).data!;

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('a big catalogue builds only the rows on screen', (tester) async {
    await _pump(tester, _report(3000));

    expect(_rowsShown(tester), '3000 of 3000');
    final built = find.textContaining('Item ').evaluate().length;
    expect(built, greaterThan(0));
    expect(built, lessThan(60));
    expect(tester.takeException(), isNull);
  });

  testWidgets('rows start most valuable first and sort by header', (
    tester,
  ) async {
    await _pump(tester, _report(8));

    // Same units, so the dearer Item 0002 is worth more than Item 0001.
    double topOf(String a, String b) =>
        tester.getTopLeft(find.text(a)).dy - tester.getTopLeft(find.text(b)).dy;
    expect(topOf('Item 0002', 'Item 0001'), lessThan(0));

    await tester.tap(find.byKey(const Key('stockValueSort_name')));
    await tester.pump();
    expect(topOf('Item 0001', 'Item 0002'), lessThan(0));
  });

  testWidgets('search narrows the rows after a short pause', (tester) async {
    await _pump(tester, _report(200));

    await tester.enterText(
      find.byKey(const Key('stockValueSearch')),
      'item 0043',
    );
    await tester.pump(const Duration(milliseconds: 50));
    expect(_rowsShown(tester), '200 of 200');

    await tester.pump(const Duration(milliseconds: 250));
    expect(_rowsShown(tester), '1 of 200');
    expect(find.text('Item 0043'), findsOneWidget);
  });

  testWidgets('status chips show counts and filter; out of stock is its own', (
    tester,
  ) async {
    await _pump(tester, _report(100));

    final out = find.byKey(const Key('stockValueFilter_out'));
    expect(
      find.descendant(of: out, matching: find.textContaining('· 10')),
      findsOneWidget,
    );
    await tester.tap(out);
    await tester.pump();
    expect(_rowsShown(tester), '10 of 100');
    expect(find.text('Item 0011'), findsNothing);
  });

  testWidgets('a category in the legend filters the table and clears', (
    tester,
  ) async {
    await _pump(tester, _report(40));

    await tester.tap(find.byKey(const Key('stockValueCategory_Snacks')));
    await tester.pump();
    expect(_rowsShown(tester), '20 of 40');
    expect(find.byKey(const Key('stockValueCategoryChip')), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('stockValueCategoryChip')),
        matching: find.byTooltip('Clear'),
      ),
    );
    await tester.pump();
    expect(_rowsShown(tester), '40 of 40');
  });

  testWidgets('View all lists every restock alert, out of stock included', (
    tester,
  ) async {
    await _pump(tester, _allOut(9));
    // Narrowed first: View all must not leave alerts hidden.
    await tester.tap(find.byKey(const Key('stockValueCategory_Snacks')));
    await tester.enterText(find.byKey(const Key('stockValueSearch')), 'x');
    await tester.pump();

    final viewAll = find.text('View all →');
    await tester.ensureVisible(viewAll);
    await tester.tap(viewAll);
    await tester.pump(const Duration(milliseconds: 250));

    expect(_rowsShown(tester), '9 of 9');
    expect(find.byKey(const Key('stockValueCategoryChip')), findsNothing);
    final search = tester.widget<TextField>(
      find.byKey(const Key('stockValueSearch')),
    );
    expect(search.controller!.text, isEmpty);

    final chip = find.byKey(const Key('stockValueRestockChip'));
    expect(chip, findsOneWidget);
    await tester.tap(
      find.descendant(of: chip, matching: find.byTooltip('Clear')),
    );
    await tester.pump();
    expect(find.byKey(const Key('stockValueRestockChip')), findsNothing);
    expect(_rowsShown(tester), '9 of 9');
  });

  testWidgets('View all on a mixed catalogue shows low, critical and out', (
    tester,
  ) async {
    final report = _report(100);
    await _pump(tester, report);

    final viewAll = find.text('View all →');
    await tester.ensureVisible(viewAll);
    await tester.tap(viewAll);
    await tester.pump();

    expect(_rowsShown(tester), '${report.lowAndCriticalItems.length} of 100');
  });

  test('the table drops low-priority columns as it narrows', () {
    String shown(double w) {
      final c = StockValueTableColumns.forWidth(w);
      return [
        if (c.category) 'category',
        if (c.bcd) 'bcd',
        if (c.unitPrice) 'price',
        if (c.stock) 'stock',
        if (c.status) 'status',
        if (c.value) 'value',
      ].join(',');
    }

    expect(shown(800), 'category,bcd,price,stock,status,value');
    expect(shown(650), 'category,price,stock,status,value');
    expect(shown(560), 'category,stock,status,value');
    expect(shown(460), 'stock,status,value');
    expect(shown(400), 'status,value');
    expect(shown(300), 'value');
    // Value narrows to what Product leaves, then goes.
    expect(StockValueTableColumns.forWidth(200).valueWidth, 80);
    expect(shown(150), '');
  });

  test('the fixed columns never overflow, however narrow the table', () {
    for (var w = 0.0; w <= 1200; w += 2) {
      final c = StockValueTableColumns.forWidth(w);
      expect(c.fixedWidth, lessThanOrEqualTo(w), reason: 'width $w');
    }
  });

  testWidgets('a narrow view keeps the table on screen without overflow', (
    tester,
  ) async {
    await _pump(tester, _report(20), size: const Size(520, 900));

    // Below 1100 the insights sit above the table: scroll down to the rows.
    await tester.dragUntilVisible(
      find.text('Item 0019'),
      find.byType(CustomScrollView),
      const Offset(0, -300),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('BCD'), findsNothing);
    expect(find.text('Item 0019'), findsOneWidget);
  });
}
