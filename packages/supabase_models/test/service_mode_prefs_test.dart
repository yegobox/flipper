import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository/local_storage.dart';

// flutter test test/service_mode_prefs_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('service-mode preference keys survive a write/read round trip', () {
    late SharedPreferenceStorage box;

    setUp(() async {
      box = SharedPreferenceStorage();
      await box.initializePreferences();
      await box.clear();
    });

    tearDown(() async {
      await box.clear();
      box.dispose();
    });

    // Every write goes through an allowlist and silently no-ops for a key that
    // is missing from it, so a new settings key that was never added reads back
    // as its default forever — the toggle appears dead with no error anywhere.
    const boolKeys = <String>[
      // Bar Mode
      'barModeEnabled',
      'barModeLaunchOnStart',
      'barRequirePin',
      'barFloorFirst',
      'barManagerSettle',
      'barAutoLogout',
      // Hotel Mode
      'hotelModeEnabled',
      'hotelModeLaunchOnStart',
      'hotelAutoPostRoomCharge',
      'hotelManagerCheckout',
      'hotelRequirePin',
      'hotelAutoLogout',
    ];

    for (final key in boolKeys) {
      test('$key is writable', () async {
        expect(box.readBool(key: key), isNull, reason: 'cleared box');
        await box.writeBool(key: key, value: true);
        expect(
          box.readBool(key: key),
          isTrue,
          reason: '$key is missing from the LocalStorage allowlist',
        );
        await box.writeBool(key: key, value: false);
        expect(box.readBool(key: key), isFalse);
      });
    }

    test('hotelCheckOutHour is writable', () async {
      await box.writeInt(key: 'hotelCheckOutHour', value: 14);
      expect(
        box.readInt(key: 'hotelCheckOutHour'),
        14,
        reason: 'hotelCheckOutHour is missing from the LocalStorage allowlist',
      );
    });

    test('hotelRoomChargeVariantId is writable', () async {
      await box.writeString(
        key: 'hotelRoomChargeVariantId',
        value: 'variant-1',
      );
      expect(
        box.readString(key: 'hotelRoomChargeVariantId'),
        'variant-1',
        reason:
            'hotelRoomChargeVariantId is missing from the LocalStorage allowlist',
      );
    });
  });
}
