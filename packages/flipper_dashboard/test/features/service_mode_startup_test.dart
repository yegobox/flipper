import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

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
