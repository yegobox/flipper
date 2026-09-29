import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_desk_nav.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FixedHotelNotifier extends HotelModeNotifier {
  @override
  HotelModeState build() => const HotelModeState(screen: HotelScreen.dashboard);
}

/// [HotelDeskNav] in a window [windowWidth] wide, optionally under the
/// host's own mobile flag.
Widget _nav({required double windowWidth, bool? hostMobile}) {
  const nav = HotelDeskNav();
  return ProviderScope(
    overrides: [hotelModeProvider.overrideWith(_FixedHotelNotifier.new)],
    child: MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(windowWidth, 800)),
        child: Scaffold(
          body: Center(
            child: hostMobile == null
                ? nav
                : HotelLayoutScope(mobile: hostMobile, child: nav),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('resolveStartupServiceMode', () {
    test('a phone opens on its own home even when the branch runs both', () {
      for (final device in [null, ...ServiceMode.values]) {
        expect(
          resolveStartupServiceMode(
            isPhone: true,
            hotelEnabled: true,
            barEnabled: true,
            deviceMode: device,
          ),
          ServiceMode.pos,
          reason: 'device pick $device',
        );
      }
    });

    test('a desktop keeps the device pick and the hotel-first fallback', () {
      expect(
        resolveStartupServiceMode(
          isPhone: false,
          hotelEnabled: true,
          barEnabled: true,
        ),
        ServiceMode.hotel,
      );
      expect(
        resolveStartupServiceMode(
          isPhone: false,
          hotelEnabled: true,
          barEnabled: true,
          deviceMode: ServiceMode.bar,
        ),
        ServiceMode.bar,
      );
    });
  });

  test('isPhoneWidth matches the mobile shell cut at 600px', () {
    expect(isPhoneWidth(390), isTrue);
    expect(isPhoneWidth(599.9), isTrue);
    expect(isPhoneWidth(600), isFalse);
    expect(isPhoneWidth(1440), isFalse);
  });

  testWidgets('isPhoneLayout reads the real view size', (tester) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 3;
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    expect(isPhoneLayout, isTrue);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 900);
    expect(isPhoneLayout, isFalse);
  });

  testWidgets('an unsized view is not a phone', (tester) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size.zero;
    expect(currentViewLogicalWidth, isNull);
    expect(isPhoneLayout, isFalse);
  });

  testWidgets('waitForViewSize completes when the view gets a size', (
    tester,
  ) async {
    addTearDown(tester.view.reset);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size.zero;

    var done = false;
    final wait = waitForViewSize(
      timeout: const Duration(minutes: 1),
    ).then((_) => done = true);
    await tester.pump();
    expect(done, isFalse);

    tester.view.physicalSize = const Size(390, 844);
    await tester.pump();
    await wait;
    expect(done, isTrue);
    expect(isPhoneLayout, isTrue);
  });

  group('HotelDeskNav', () {
    testWidgets('follows the host flag, not the window width', (tester) async {
      // A 900px window whose host pane (beside the side menu) is under 600px.
      await tester.pumpWidget(_nav(windowWidth: 900, hostMobile: true));
      expect(find.text('Today'), findsNothing);
      expect(find.text('Rooms'), findsOneWidget);

      await tester.pumpWidget(_nav(windowWidth: 400, hostMobile: false));
      await tester.pump();
      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('falls back to the window width outside the host', (
      tester,
    ) async {
      await tester.pumpWidget(_nav(windowWidth: 400));
      expect(find.text('Today'), findsNothing);

      await tester.pumpWidget(_nav(windowWidth: 900));
      await tester.pump();
      expect(find.text('Today'), findsOneWidget);
    });
  });

  group('hotelVisibleScreen', () {
    test('a phone draws Rooms instead of the Today dashboard', () {
      expect(
        hotelVisibleScreen(HotelScreen.dashboard, mobile: true),
        HotelScreen.rooms,
      );
    });

    test('desktop keeps the dashboard; other screens are untouched', () {
      expect(
        hotelVisibleScreen(HotelScreen.dashboard, mobile: false),
        HotelScreen.dashboard,
      );
      for (final s in HotelScreen.values.where(
        (s) => s != HotelScreen.dashboard,
      )) {
        expect(hotelVisibleScreen(s, mobile: true), s);
      }
    });
  });
}
