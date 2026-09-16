import 'package:flipper_dashboard/features/service_mode_switch.dart';
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

    test('a hotel with a bar shows each terminal what it was set to', () {
      expect(
        SalesSurface.resolve(
          hotelEnabled: true,
          barEnabled: true,
          deviceMode: ServiceMode.bar,
        ),
        SalesSurface.bar,
      );
      expect(
        SalesSurface.resolve(
          hotelEnabled: true,
          barEnabled: true,
          deviceMode: ServiceMode.hotel,
        ),
        SalesSurface.hotel,
      );
    });

    test('a till pinned to POS keeps its catalog+cart in a hotel', () {
      expect(
        SalesSurface.resolve(
          hotelEnabled: true,
          barEnabled: true,
          deviceMode: ServiceMode.pos,
        ),
        SalesSurface.pos,
      );
    });

    test('a pick the branch no longer offers falls back', () {
      // The bar was shut down; the counter terminal must not sit on a floor
      // plan nobody maintains.
      expect(
        SalesSurface.resolve(
          hotelEnabled: true,
          barEnabled: false,
          deviceMode: ServiceMode.bar,
        ),
        SalesSurface.hotel,
      );
      expect(
        SalesSurface.resolve(
          hotelEnabled: false,
          barEnabled: false,
          deviceMode: ServiceMode.bar,
        ),
        SalesSurface.pos,
      );
    });
  });

  group('availableServiceModes', () {
    test('POS is always offered, services only when the branch runs them', () {
      expect(
        availableServiceModes(hotelEnabled: false, barEnabled: false),
        [ServiceMode.pos],
      );
      expect(
        availableServiceModes(hotelEnabled: true, barEnabled: true),
        [ServiceMode.pos, ServiceMode.bar, ServiceMode.hotel],
      );
      expect(
        availableServiceModes(hotelEnabled: true, barEnabled: false),
        [ServiceMode.pos, ServiceMode.hotel],
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
