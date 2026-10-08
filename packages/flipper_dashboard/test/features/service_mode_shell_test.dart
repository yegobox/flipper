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

  group('shouldPinOpenedServiceMode', () {
    bool pin(
      ServiceMode host, {
      ServiceMode? atOpen,
      ServiceMode? now,
      bool stillOpen = true,
      bool enabled = true,
      bool isPhone = false,
    }) => shouldPinOpenedServiceMode(
      hostMode: host,
      pickAtOpen: atOpen,
      pickNow: now,
      stillOpen: stillOpen,
      serviceEnabled: enabled,
      isPhone: isPhone,
    );

    test('a host opened with no pick makes this the mode terminal', () {
      // The startup redirect's hotel-first fallback, or Back onto a host.
      expect(pin(ServiceMode.hotel), isTrue);
      expect(pin(ServiceMode.bar), isTrue);
    });

    test('a host replaced while hydrating never pins', () {
      expect(pin(ServiceMode.bar, stillOpen: false), isFalse);
      expect(pin(ServiceMode.hotel, stillOpen: false), isFalse);
    });

    test('a switch made while the host hydrated is not undone', () {
      // Bar opened by the hotkey, then the hotkey moved on to Hotel and POS.
      expect(
        pin(ServiceMode.bar, atOpen: ServiceMode.bar, now: ServiceMode.hotel),
        isFalse,
      );
      expect(
        pin(ServiceMode.hotel, atOpen: ServiceMode.hotel, now: ServiceMode.pos),
        isFalse,
      );
      expect(pin(ServiceMode.bar, now: ServiceMode.pos), isFalse);
    });

    test('already pinned to this host: no second write', () {
      // A redundant pin still bumps the revision and re-runs the shell sync.
      expect(
        pin(ServiceMode.bar, atOpen: ServiceMode.bar, now: ServiceMode.bar),
        isFalse,
      );
    });

    test('a phone or a service that is off is never pinned', () {
      expect(pin(ServiceMode.bar, isPhone: true), isFalse);
      expect(pin(ServiceMode.hotel, enabled: false), isFalse);
    });

    test('a quick Bar -> Hotel switch settles instead of bouncing', () {
      // Replays the hang: every host that finishes hydrating may pin, and a
      // pin that differs from the shell on screen opens that mode's host,
      // which hydrates and may pin in turn. Before the fix each late pin
      // reopened its own host and the two never stopped.
      ServiceMode? pick = ServiceMode.bar; // hotkey pinned Bar, opened it
      final pending = <({ServiceMode host, ServiceMode? atOpen})>[
        (host: ServiceMode.bar, atOpen: pick),
      ];
      pick = ServiceMode.hotel; // hotkey again before Bar finished hydrating
      var onScreen = ServiceMode.hotel;
      pending.add((host: ServiceMode.hotel, atOpen: pick));

      var navigations = 0;
      while (pending.isNotEmpty && navigations < 10) {
        final host = pending.removeAt(0);
        final pins = shouldPinOpenedServiceMode(
          hostMode: host.host,
          pickAtOpen: host.atOpen,
          pickNow: pick,
          stillOpen: host.host == onScreen,
          serviceEnabled: true,
          isPhone: false,
        );
        if (!pins) continue;
        pick = host.host;
        if (onScreen != pick) {
          onScreen = host.host;
          navigations++;
          pending.add((host: onScreen, atOpen: pick));
        }
      }

      expect(navigations, 0);
      expect(pick, ServiceMode.hotel);
      expect(onScreen, ServiceMode.hotel);
    });
  });
}
