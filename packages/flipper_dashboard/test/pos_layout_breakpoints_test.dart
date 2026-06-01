import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PosLayoutBreakpoints grid', () {
    test('cart drawer width capped at cart panel width', () {
      expect(PosLayoutBreakpoints.cartDrawerWidth(2000), 460);
    });

    test('wide pane uses 4 columns max', () {
      expect(
        PosLayoutBreakpoints.productGridCrossAxisCountForPaneWidth(1200),
        4,
      );
    });
  });

  group('PosLayoutBreakpoints checkout layout', () {
    test('useSingleScrollCheckoutPane below threshold', () {
      expect(
        PosLayoutBreakpoints.useSingleScrollCheckoutPane(559),
        isTrue,
      );
      expect(
        PosLayoutBreakpoints.useSingleScrollCheckoutPane(560),
        isFalse,
      );
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
