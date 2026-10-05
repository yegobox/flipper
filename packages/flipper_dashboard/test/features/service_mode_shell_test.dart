import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('serviceModeShellTarget', () {
    ServiceMode? target(
      ServiceMode? currentShell,
      ServiceMode wanted, {
      bool isPhone = false,
    }) => serviceModeShellTarget(
      currentShell: currentShell,
      wanted: wanted,
      isPhone: isPhone,
    );

    test('a mode left inside the POS shell moves to its own route', () {
      // Settings toggled Bar / Hotel on, then closed onto the dashboard.
      expect(target(ServiceMode.pos, ServiceMode.bar), ServiceMode.bar);
      expect(target(ServiceMode.pos, ServiceMode.hotel), ServiceMode.hotel);
    });

    test('a mode host whose mode was turned off goes back to POS', () {
      expect(target(ServiceMode.bar, ServiceMode.pos), ServiceMode.pos);
      expect(target(ServiceMode.hotel, ServiceMode.pos), ServiceMode.pos);
    });

    test('one mode host hands over to the other', () {
      expect(target(ServiceMode.bar, ServiceMode.hotel), ServiceMode.hotel);
      expect(target(ServiceMode.hotel, ServiceMode.bar), ServiceMode.bar);
    });

    test('already on the right shell: stays put', () {
      for (final mode in ServiceMode.values) {
        expect(target(mode, mode), isNull);
      }
    });

    test('never pulls the operator out of Settings or another screen', () {
      for (final mode in ServiceMode.values) {
        expect(target(null, mode), isNull);
      }
    });

    test('a phone is never moved by itself', () {
      expect(target(ServiceMode.pos, ServiceMode.bar, isPhone: true), isNull);
      expect(target(ServiceMode.pos, ServiceMode.hotel, isPhone: true), isNull);
      expect(target(ServiceMode.bar, ServiceMode.pos, isPhone: true), isNull);
    });
  });
}
