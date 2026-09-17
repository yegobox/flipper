import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PosLayoutBreakpoints grid', () {
    test('cart drawer width capped at cart panel width', () {
      expect(PosLayoutBreakpoints.cartDrawerWidth(2000), 460);
    });

    test('cart column is a clamped share of the sales pane', () {
      // 1280 window → 1216 pane → 36% = 438.
      expect(PosLayoutBreakpoints.cartColumnWidth(1216), closeTo(437.8, 0.1));
      // Narrow split floors at 400 …
      expect(PosLayoutBreakpoints.cartColumnWidth(1100), 400);
      // … and wide windows cap at the handoff 460.
      expect(PosLayoutBreakpoints.cartColumnWidth(1856), 460);
    });

    test('grid packs 168px tiles: 4 @1280, 5 @1440, 7 @1920', () {
      // Catalog pane = window − rail − cart column − 32px grid inset.
      const rail = PosTokens.sideMenuWidth;
      double pane(double window) =>
          window -
          rail -
          PosLayoutBreakpoints.cartColumnWidth(window - rail) -
          32;
      expect(
        PosLayoutBreakpoints.productGridCrossAxisCountForPaneWidth(pane(1280)),
        4,
      );
      expect(
        PosLayoutBreakpoints.productGridCrossAxisCountForPaneWidth(pane(1440)),
        5,
      );
      expect(
        PosLayoutBreakpoints.productGridCrossAxisCountForPaneWidth(pane(1920)),
        7,
      );
    });

    test('grid never drops below 2 or above 8 columns', () {
      expect(
        PosLayoutBreakpoints.productGridCrossAxisCountForPaneWidth(200),
        2,
      );
      expect(
        PosLayoutBreakpoints.productGridCrossAxisCountForPaneWidth(4000),
        8,
      );
    });
    test('grid rows fill the viewport without counting a trailing gap', () {
      final rowExtent =
          PosLayoutBreakpoints.productCardTotalHeight() + PosTokens.gridGap;

      // Exactly three rows (two gaps) fits three, not two.
      final threeRows = rowExtent * 3 - PosTokens.gridGap;
      expect(
        PosLayoutBreakpoints.productGridRowsForViewportHeight(threeRows, 1200),
        3,
      );
      // One pixel short of the third row still only fits two.
      expect(
        PosLayoutBreakpoints.productGridRowsForViewportHeight(
          threeRows - 1,
          1200,
        ),
        2,
      );
      // A pane too short for a single row still asks for one.
      expect(
        PosLayoutBreakpoints.productGridRowsForViewportHeight(10, 1200),
        1,
      );
      expect(
        PosLayoutBreakpoints.productGridRowsForViewportHeight(
          double.infinity,
          1200,
        ),
        1,
      );
    });

    test('page size fills the measured grid: rows x columns', () {
      const paneWidth = 1200.0;
      final cols = PosLayoutBreakpoints.productGridCrossAxisCountForPaneWidth(
        paneWidth,
      );
      const viewportHeight = 880.0;
      final rows = PosLayoutBreakpoints.productGridRowsForViewportHeight(
        viewportHeight,
        paneWidth,
      );
      expect(
        PosLayoutBreakpoints.productGridPageSizeForViewport(
          viewportHeight: viewportHeight,
          paneWidth: paneWidth,
        ),
        cols * rows,
      );
      // A 1200x880 catalog pane holds well over the old fixed 15-item page.
      expect(cols * rows, greaterThan(15));
    });
  });

  group('PosLayoutBreakpoints checkout layout', () {
    test('useSingleScrollCheckoutPane below threshold', () {
      expect(PosLayoutBreakpoints.useSingleScrollCheckoutPane(559), isTrue);
      expect(PosLayoutBreakpoints.useSingleScrollCheckoutPane(560), isFalse);
    });

    test('checkoutFlexForPaneHeight favors cart on short desktop', () {
      final short = PosLayoutBreakpoints.checkoutFlexForPaneHeight(720);
      expect(short.items, PosLayoutBreakpoints.checkoutItemsFormFlexShortItems);
      expect(short.form, PosLayoutBreakpoints.checkoutItemsFormFlexShortForm);

      final tall = PosLayoutBreakpoints.checkoutFlexForPaneHeight(900);
      expect(tall.items, PosLayoutBreakpoints.checkoutItemsFormFlexTallItems);
      expect(tall.form, PosLayoutBreakpoints.checkoutItemsFormFlexTallForm);
    });

    test('checkoutFlexForPaneHeight switches at short desktop max', () {
      final atMax = PosLayoutBreakpoints.checkoutFlexForPaneHeight(
        PosLayoutBreakpoints.checkoutShortDesktopMaxHeight - 1,
      );
      expect(atMax.items, PosLayoutBreakpoints.checkoutItemsFormFlexShortItems);

      final above = PosLayoutBreakpoints.checkoutFlexForPaneHeight(
        PosLayoutBreakpoints.checkoutShortDesktopMaxHeight,
      );
      expect(above.items, PosLayoutBreakpoints.checkoutItemsFormFlexTallItems);
    });
  });
}
