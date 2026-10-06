import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('serviceModeShellTarget', () {
    ServiceMode? target(
      ServiceMode? currentShell,
      ServiceMode wanted, {
      bool isPhone = false,
      bool currentShellOffered = true,
    }) => serviceModeShellTarget(
      currentShell: currentShell,
      wanted: wanted,
      isPhone: isPhone,
      currentShellOffered: currentShellOffered,
    );

    test('a mode left inside the POS shell moves to its own route', () {
      // Settings toggled Bar / Hotel on, then closed onto the dashboard.
      expect(target(ServiceMode.pos, ServiceMode.bar), ServiceMode.bar);
      expect(target(ServiceMode.pos, ServiceMode.hotel), ServiceMode.hotel);
    });

    test('a mode host whose mode was turned off goes back to POS', () {
      // Bar and Hotel both turned off from Settings opened on the host: the
      // close lands on POS straight away, not after an app restart.
      expect(
        target(ServiceMode.bar, ServiceMode.pos, currentShellOffered: false),
        ServiceMode.pos,
      );
      expect(
        target(ServiceMode.hotel, ServiceMode.pos, currentShellOffered: false),
        ServiceMode.pos,
      );
    });

    test('a terminal moved to POS by its own pick leaves the host too', () {
      expect(target(ServiceMode.bar, ServiceMode.pos), ServiceMode.pos);
      expect(target(ServiceMode.hotel, ServiceMode.pos), ServiceMode.pos);
    });

    test('one mode host hands over to the other', () {
      expect(target(ServiceMode.bar, ServiceMode.hotel), ServiceMode.hotel);
      expect(target(ServiceMode.hotel, ServiceMode.bar), ServiceMode.bar);
      // Bar turned off while Hotel stays on: the front desk takes over.
      expect(
        target(ServiceMode.bar, ServiceMode.hotel, currentShellOffered: false),
        ServiceMode.hotel,
      );
    });

    test('already on the right shell: stays put', () {
      for (final mode in ServiceMode.values) {
        expect(target(mode, mode), isNull);
      }
    });

    test('never pulls the operator out of Settings or another screen', () {
      for (final mode in ServiceMode.values) {
        expect(target(null, mode), isNull);
        expect(target(null, mode, currentShellOffered: false), isNull);
      }
    });

    test('a phone is never moved into a mode by itself', () {
      expect(target(ServiceMode.pos, ServiceMode.bar, isPhone: true), isNull);
      expect(target(ServiceMode.pos, ServiceMode.hotel, isPhone: true), isNull);
    });

    test('a phone keeps a mode it opened by hand while that mode is on', () {
      expect(target(ServiceMode.bar, ServiceMode.pos, isPhone: true), isNull);
      expect(target(ServiceMode.bar, ServiceMode.hotel, isPhone: true), isNull);
    });

    test('a phone leaves a mode that was turned off, to POS', () {
      expect(
        target(
          ServiceMode.bar,
          ServiceMode.pos,
          isPhone: true,
          currentShellOffered: false,
        ),
        ServiceMode.pos,
      );
      // Never into the other mode: a phone opens those only on request.
      expect(
        target(
          ServiceMode.bar,
          ServiceMode.hotel,
          isPhone: true,
          currentShellOffered: false,
        ),
        ServiceMode.pos,
      );
      expect(
        target(
          ServiceMode.hotel,
          ServiceMode.pos,
          isPhone: true,
          currentShellOffered: false,
        ),
        ServiceMode.pos,
      );
    });
  });
}
