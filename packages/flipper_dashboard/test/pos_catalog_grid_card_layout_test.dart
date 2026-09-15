// Renders the desktop product tile inside the exact cell size the catalog grid
// computes for 1280 / 1440 / 1920 windows and asserts nothing overflows with
// worst-case content (two-line name, big price, "Out of stock", long BCD).
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/pos_catalog_grid_card_layout_test.dart --dart-define=FLUTTER_TEST_ENV=true

import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/pos_product_tile.dart';
import 'package:flipper_dashboard/widgets/pos_catalog_grid_card.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const gridInset = 32.0;

  double catalogPane(double window) {
    final sales = window - PosTokens.sideMenuWidth;
    return sales - PosLayoutBreakpoints.cartColumnWidth(sales) - gridInset;
  }

  Widget host(double cellWidth, double cellHeight, PosStockVisual visual) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
      supportedLocales: FlipperAppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: cellWidth,
            height: cellHeight,
            child: PosCatalogGridCard(
              productName:
                  'Extra long product name that certainly wraps onto a second line and then some',
              bcdLabel: 'BCD: 6001234567890123456',
              currencySymbol: 'RWF',
              priceAmount: 12345678,
              stockVisual: visual,
              stockLabel: posStockLabel(visual, 1234567),
              inCartQty: 12,
              showSelectionBorder: visual == PosStockVisual.low,
              isOutOfStock: visual == PosStockVisual.out,
              thumb: posCatalogThumb(
                name: 'Extra long',
                hasImage: false,
                image: null,
                isOutOfStock: visual == PosStockVisual.out,
              ),
              onTap: () {},
              onLongPress: () {},
            ),
          ),
        ),
      ),
    );
  }

  for (final window in [1280.0, 1440.0, 1920.0]) {
    testWidgets('tile fits its grid cell at ${window.toInt()}px', (
      tester,
    ) async {
      tester.view.physicalSize = Size(window, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final pane = catalogPane(window);
      final cols = PosLayoutBreakpoints.productGridCrossAxisCountForPaneWidth(
        pane,
      );
      final gap = PosLayoutBreakpoints.desktopGridSpacing(pane);
      final cellWidth = (pane - gap * (cols - 1)) / cols;
      final cellHeight =
          cellWidth /
          PosLayoutBreakpoints.desktopGridChildAspectRatioForPane(pane);

      for (final visual in PosStockVisual.values) {
        await tester.pumpWidget(host(cellWidth, cellHeight, visual));
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '$visual overflowed');
        expect(find.byType(PosCatalogGridCard), findsOneWidget);
      }
      // Sanity: the tile is compact — well under the old 192px card.
      expect(cellHeight, lessThan(170));
      expect(cellWidth, greaterThanOrEqualTo(PosTokens.productTileMinWidth));
    });
  }

  testWidgets('customer colour drives the thumb; image still wins over it', (
    tester,
  ) async {
    Widget thumbHost({
      required bool hasImage,
      required Color? userColor,
      bool isOutOfStock = false,
    }) => MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 200,
          height: 56,
          child: posCatalogThumb(
            name: 'Coca Cola',
            hasImage: hasImage,
            image: hasImage
                ? const ColoredBox(
                    key: Key('product-image'),
                    color: Colors.black,
                  )
                : null,
            isOutOfStock: isOutOfStock,
            userColor: userColor,
          ),
        ),
      ),
    );

    // 1. Customer picked a colour -> the thumb uses it.
    await tester.pumpWidget(
      thumbHost(hasImage: false, userColor: const Color(0xFF673AB7)),
    );
    final painted = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((d) => (d.decoration as BoxDecoration).color)
        .toList();
    expect(painted, contains(const Color(0xFF673AB7)));

    // 2. No colour -> neutral band, never a hash colour.
    await tester.pumpWidget(thumbHost(hasImage: false, userColor: null));
    final neutral = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((d) => (d.decoration as BoxDecoration).color)
        .toList();
    expect(neutral, contains(PosTokens.neutralThumb));
    expect(neutral, isNot(contains(posTileColorForName('Coca Cola'))));

    // 3. An image outranks the colour.
    await tester.pumpWidget(
      thumbHost(hasImage: true, userColor: const Color(0xFF673AB7)),
    );
    expect(find.byKey(const Key('product-image')), findsOneWidget);

    // 4. Out of stock desaturates even a customer colour.
    await tester.pumpWidget(
      thumbHost(
        hasImage: false,
        userColor: const Color(0xFF673AB7),
        isOutOfStock: true,
      ),
    );
    final outOfStock = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((d) => (d.decoration as BoxDecoration).color)
        .toList();
    expect(outOfStock, isNot(contains(const Color(0xFF673AB7))));
  });
}
