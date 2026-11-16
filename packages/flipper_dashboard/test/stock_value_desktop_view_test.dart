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

Future<void> _pump(WidgetTester tester, StockValueReportData report) async {
  tester.view.physicalSize = const Size(1440, 900);
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
}
