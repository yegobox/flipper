import 'package:flipper_models/models/hotel_branch_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HotelBranchSettings', () {
    test('serialises roomChargeVariantId even when null', () {
      // Ditto's ON ID CONFLICT DO UPDATE leaves omitted fields untouched, so
      // omitting a cleared product would keep it alive on other devices.
      const settings = HotelBranchSettings(branchId: 'b1');
      expect(settings.toJson().containsKey('roomChargeVariantId'), isTrue);
      expect(settings.toJson()['roomChargeVariantId'], isNull);
    });

    test('clearRoomChargeVariantId actually clears it', () {
      const settings = HotelBranchSettings(
        branchId: 'b1',
        roomChargeVariantId: 'v1',
      );
      expect(
        settings.copyWith(roomChargeVariantId: null).roomChargeVariantId,
        'v1',
        reason: 'copyWith cannot express null; that is why the flag exists',
      );
      expect(
        settings.copyWith(clearRoomChargeVariantId: true).roomChargeVariantId,
        isNull,
      );
    });

    test('launchOnStart survives a round trip', () {
      const settings = HotelBranchSettings(
        branchId: 'b1',
        enabled: true,
        launchOnStart: false,
      );
      final parsed = HotelBranchSettings.fromJson(settings.toJson());
      expect(parsed.enabled, isTrue);
      expect(
        parsed.launchOnStart,
        isFalse,
        reason: 'a device opt-out must not be overwritten by a hydrate',
      );
    });

    test('a document written before launchOnStart existed follows enabled', () {
      final legacy = {'_id': 'b1', 'branchId': 'b1', 'enabled': true};
      expect(HotelBranchSettings.fromJson(legacy).launchOnStart, isTrue);

      final legacyOff = {'_id': 'b1', 'branchId': 'b1', 'enabled': false};
      expect(HotelBranchSettings.fromJson(legacyOff).launchOnStart, isFalse);
    });

    test('survives Ditto string coercion', () {
      const settings = HotelBranchSettings(
        branchId: 'b1',
        enabled: true,
        checkOutHour: 14,
      );
      final raw = settings.toJson().map(
        (k, v) => MapEntry(k, v?.toString()),
      );
      final parsed = HotelBranchSettings.fromJson(raw);
      expect(parsed.enabled, isTrue);
      expect(parsed.checkOutHour, 14);
    });

    group('guest notification flags', () {
      test('default to email only, so enabling the feature spends no credits',
          () {
        const settings = HotelBranchSettings(branchId: 'b1');
        expect(settings.notifyGuestEmail, isTrue, reason: 'email is free');
        expect(settings.notifyGuestSms, isFalse, reason: 'SMS costs credits');
        expect(settings.notifyOnReserve, isTrue);
        expect(settings.notifyOnCheckIn, isTrue);
        expect(settings.notifiesGuests, isTrue);
      });

      test('a document written before the feature existed keeps those defaults',
          () {
        final parsed = HotelBranchSettings.fromJson({
          'branchId': 'b1',
          'enabled': true,
        });
        expect(parsed.notifyGuestSms, isFalse);
        expect(parsed.notifyGuestEmail, isTrue);
        expect(parsed.notifyOnReserve, isTrue);
        expect(parsed.notifyOnCheckIn, isTrue);
      });

      test('survive a round trip', () {
        const settings = HotelBranchSettings(
          branchId: 'b1',
          notifyGuestSms: true,
          notifyGuestEmail: false,
          notifyOnReserve: false,
          notifyOnCheckIn: true,
        );
        final parsed = HotelBranchSettings.fromJson(settings.toJson());
        expect(parsed.notifyGuestSms, isTrue);
        expect(parsed.notifyGuestEmail, isFalse);
        expect(parsed.notifyOnReserve, isFalse);
        expect(parsed.notifyOnCheckIn, isTrue);
      });

      test('turning both channels off stops notifying entirely', () {
        const settings = HotelBranchSettings(
          branchId: 'b1',
          notifyGuestSms: false,
          notifyGuestEmail: false,
        );
        expect(settings.notifiesGuests, isFalse);
      });

      test('are written even when false, so an off switch replicates', () {
        // `false` and "absent" mean different things under ON ID CONFLICT DO
        // UPDATE: an omitted key leaves the other device's `true` in place.
        const settings = HotelBranchSettings(
          branchId: 'b1',
          notifyGuestEmail: false,
        );
        final json = settings.toJson();
        expect(json.containsKey('notifyGuestEmail'), isTrue);
        expect(json['notifyGuestEmail'], isFalse);
      });
    });
  });
}
