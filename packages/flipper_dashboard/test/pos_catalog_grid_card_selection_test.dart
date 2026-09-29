// Tap gating on the desktop product tile: out-of-stock tiles never sell, but
// must still toggle while the catalog is multi-selecting for bulk delete.
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/pos_catalog_grid_card_selection_test.dart --dart-define=FLUTTER_TEST_ENV=true

import 'package:flipper_dashboard/utils/pos_product_tile.dart';
import 'package:flipper_dashboard/widgets/pos_catalog_grid_card.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host({
    required bool isOutOfStock,
    required bool selectionMode,
    required VoidCallback onTap,
    required VoidCallback onLongPress,
    bool passSelectionMode = true,
  }) {
    final visual = isOutOfStock ? PosStockVisual.out : PosStockVisual.ok;
    final thumb = posCatalogThumb(
      name: 'Tile',
      hasImage: false,
      image: null,
      isOutOfStock: isOutOfStock,
    );
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
      supportedLocales: FlipperAppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 200,
            height: 180,
            child: passSelectionMode
                ? PosCatalogGridCard(
                    productName: 'Tile',
                    bcdLabel: null,
                    currencySymbol: 'RWF',
                    priceAmount: 100,
                    stockVisual: visual,
                    stockLabel: posStockLabel(visual, isOutOfStock ? 0 : 5),
                    inCartQty: 0,
                    showSelectionBorder: false,
                    isOutOfStock: isOutOfStock,
                    thumb: thumb,
                    onTap: onTap,
                    onLongPress: onLongPress,
                    selectionMode: selectionMode,
                  )
                : PosCatalogGridCard(
                    productName: 'Tile',
                    bcdLabel: null,
                    currencySymbol: 'RWF',
                    priceAmount: 100,
                    stockVisual: visual,
                    stockLabel: posStockLabel(visual, isOutOfStock ? 0 : 5),
                    inCartQty: 0,
                    showSelectionBorder: false,
                    isOutOfStock: isOutOfStock,
                    thumb: thumb,
                    onTap: onTap,
                    onLongPress: onLongPress,
                  ),
          ),
        ),
      ),
    );
  }

  testWidgets('in-stock tile: tap and long-press both fire (unchanged)', (
    tester,
  ) async {
    var taps = 0, longPresses = 0;
    await tester.pumpWidget(
      host(
        isOutOfStock: false,
        selectionMode: false,
        passSelectionMode: false,
        onTap: () => taps++,
        onLongPress: () => longPresses++,
      ),
    );
    await tester.tap(find.byType(PosCatalogGridCard));
    await tester.pumpAndSettle();
    await tester.longPress(find.byType(PosCatalogGridCard));
    await tester.pumpAndSettle();
    expect(taps, 1);
    expect(longPresses, 1);
  });

  testWidgets('out-of-stock tile ignores taps outside selection (unchanged)', (
    tester,
  ) async {
    var taps = 0, longPresses = 0;
    await tester.pumpWidget(
      host(
        isOutOfStock: true,
        selectionMode: false,
        passSelectionMode: false,
        onTap: () => taps++,
        onLongPress: () => longPresses++,
      ),
    );
    await tester.tap(find.byType(PosCatalogGridCard));
    await tester.pumpAndSettle();
    await tester.longPress(find.byType(PosCatalogGridCard));
    await tester.pumpAndSettle();
    expect(taps, 0, reason: 'an out-of-stock tile must never sell on tap');
    expect(longPresses, 1, reason: 'long-press still starts a selection');
  });

  testWidgets('out-of-stock tile accepts taps while multi-selecting', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      host(
        isOutOfStock: true,
        selectionMode: true,
        onTap: () => taps++,
        onLongPress: () {},
      ),
    );
    await tester.tap(find.byType(PosCatalogGridCard));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('selectionMode on an in-stock tile changes nothing', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      host(
        isOutOfStock: false,
        selectionMode: true,
        onTap: () => taps++,
        onLongPress: () {},
      ),
    );
    await tester.tap(find.byType(PosCatalogGridCard));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });
}
