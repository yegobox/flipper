import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Exercises checkout flex selection used by [QuickSellingView._buildSharedView]
/// at common Windows (1280×720) and tall desktop heights.
void main() {
  group('QuickSellingView shared layout flex', () {
    testWidgets('720p-class pane height uses short-desktop cart flex', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const paneHeight = 580.0;
      final flex = PosLayoutBreakpoints.checkoutFlexForPaneHeight(paneHeight);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: paneHeight,
                  child: Column(
                    children: [
                      Expanded(
                        flex: flex.items,
                        child: const ColoredBox(color: Color(0xFFE5E7EB)),
                      ),
                      Expanded(
                        flex: flex.form,
                        child: const ColoredBox(color: Color(0xFFD1D5DB)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(
        flex.items,
        PosLayoutBreakpoints.checkoutItemsFormFlexShortItems,
      );
      expect(flex.form, PosLayoutBreakpoints.checkoutItemsFormFlexShortForm);
      expect(
        PosLayoutBreakpoints.useSingleScrollCheckoutPane(paneHeight),
        isFalse,
      );
    });

    testWidgets('tall pane uses 3:2 flex', (tester) async {
      const paneHeight = 900.0;
      final flex = PosLayoutBreakpoints.checkoutFlexForPaneHeight(paneHeight);

      expect(flex.items, PosLayoutBreakpoints.checkoutItemsFormFlexTallItems);
      expect(flex.form, PosLayoutBreakpoints.checkoutItemsFormFlexTallForm);
    });
  });
}
