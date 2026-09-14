import 'package:flipper_dashboard/inventory_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SalesSurface.resolve', () {
    test('plain POS when no service mode is enabled', () {
      expect(
        SalesSurface.resolve(hotelEnabled: false, barEnabled: false),
        SalesSurface.pos,
      );
    });

    test('hotel wins over a stale bar setting', () {
      expect(
        SalesSurface.resolve(hotelEnabled: true, barEnabled: true),
        SalesSurface.hotel,
      );
    });

    test('bar mode is selected on a bar branch', () {
      expect(
        SalesSurface.resolve(hotelEnabled: false, barEnabled: true),
        SalesSurface.bar,
      );
    });
  });

  group('ownsWholePane', () {
    test('every service mode takes the full sales pane', () {
      // Regression: Bar Mode was rendered into the cart half of the
      // catalog+cart split, leaving the POS product grid beside its lock
      // screen. Any surface that is not plain POS must own the whole pane.
      for (final surface in SalesSurface.values) {
        expect(
          surface.ownsWholePane,
          surface != SalesSurface.pos,
          reason: '$surface',
        );
      }
    });

    test('plain POS keeps the catalog+cart split', () {
      expect(SalesSurface.pos.ownsWholePane, isFalse);
    });
  });
}
