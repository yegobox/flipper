import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flutter_test/flutter_test.dart';

HotelRoom _room({
  String id = 'r1',
  int capacity = 2,
  HotelHousekeeping housekeeping = HotelHousekeeping.clean,
}) => HotelRoom(
  id: id,
  branchId: 'b1',
  floorId: 'ground',
  floorName: 'Ground Floor',
  name: id,
  roomType: 'Double',
  capacity: capacity,
  nightlyRate: 50000,
  housekeeping: housekeeping,
);

/// Stay in room [roomId] from the 10th to the 12th of Jan 2026 by default.
HotelStay _stay({
  String id = 's1',
  String roomId = 'r1',
  int fromDay = 10,
  int toDay = 12,
  HotelStayStatus status = HotelStayStatus.inHouse,
}) => HotelStay(
  id: id,
  branchId: 'b1',
  roomId: roomId,
  roomName: roomId,
  transactionId: 't1',
  guestName: 'Aline Uwase',
  checkInAt: DateTime(2026, 1, fromDay, 14),
  expectedCheckOutAt: DateTime(2026, 1, toDay, 11),
  nightlyRate: 50000,
  status: status,
);

DateTime _d(int day) => DateTime(2026, 1, day);

void main() {
  group('hotelStayCoversDay', () {
    test('covers the arrival night', () {
      expect(hotelStayCoversDay(_stay(), _d(10)), isTrue);
    });

    test('covers the middle night', () {
      expect(hotelStayCoversDay(_stay(), _d(11)), isTrue);
    });

    test('does NOT cover the departure day', () {
      // The guest leaves on the 12th by 11:00, so that night is sellable.
      expect(hotelStayCoversDay(_stay(), _d(12)), isFalse);
    });

    test('does not cover the day before arrival', () {
      expect(hotelStayCoversDay(_stay(), _d(9)), isFalse);
    });

    test('a closed stay covers nothing', () {
      final gone = _stay(status: HotelStayStatus.checkedOut);
      expect(hotelStayCoversDay(gone, _d(10)), isFalse);
      expect(hotelStayCoversDay(gone, _d(11)), isFalse);
    });
  });

  group('hotelStayOverlapsRange', () {
    final stay = _stay(); // [10, 12)

    test('back-to-back ranges do not clash', () {
      // Departing the 12th and arriving the 12th is the same room, same day.
      expect(hotelStayOverlapsRange(stay, _d(12), _d(14)), isFalse);
      expect(hotelStayOverlapsRange(stay, _d(8), _d(10)), isFalse);
    });

    test('a range straddling the stay clashes', () {
      expect(hotelStayOverlapsRange(stay, _d(9), _d(13)), isTrue);
    });

    test('a range inside the stay clashes', () {
      expect(hotelStayOverlapsRange(stay, _d(10), _d(11)), isTrue);
    });

    test('a range overlapping only the last night clashes', () {
      expect(hotelStayOverlapsRange(stay, _d(11), _d(15)), isTrue);
    });

    test('a fully separate range does not clash', () {
      expect(hotelStayOverlapsRange(stay, _d(20), _d(22)), isFalse);
    });
  });

  group('hotelDayState', () {
    test('out of order beats any booking', () {
      final state = hotelDayState(
        room: _room(housekeeping: HotelHousekeeping.outOfOrder),
        stays: [_stay()],
        day: _d(10),
      );
      expect(state, HotelDayState.blocked);
    });

    test('separates a reservation from an in-house guest', () {
      expect(
        hotelDayState(room: _room(), stays: [_stay()], day: _d(10)),
        HotelDayState.occupied,
      );
      expect(
        hotelDayState(
          room: _room(),
          stays: [_stay(status: HotelStayStatus.reserved)],
          day: _d(10),
        ),
        HotelDayState.reserved,
      );
    });

    test('ignores stays belonging to another room', () {
      expect(
        hotelDayState(
          room: _room(id: 'r2'),
          stays: [_stay(roomId: 'r1')],
          day: _d(10),
        ),
        HotelDayState.free,
      );
    });
  });

  group('hotelRoomAvailableForRange', () {
    test('a free room is available', () {
      expect(
        hotelRoomAvailableForRange(
          room: _room(),
          stays: const [],
          from: _d(10),
          to: _d(12),
        ),
        isTrue,
      );
    });

    test('a clashing stay makes it unavailable', () {
      expect(
        hotelRoomAvailableForRange(
          room: _room(),
          stays: [_stay()],
          from: _d(11),
          to: _d(13),
        ),
        isFalse,
      );
    });

    test('an out-of-order room is never available, even with no bookings', () {
      expect(
        hotelRoomAvailableForRange(
          room: _room(housekeeping: HotelHousekeeping.outOfOrder),
          stays: const [],
          from: _d(10),
          to: _d(12),
        ),
        isFalse,
      );
    });

    test('ignoreStayId lets a booking be edited without clashing itself', () {
      // Re-quoting the same reservation must not report its own room as taken.
      expect(
        hotelRoomAvailableForRange(
          room: _room(),
          stays: [_stay(id: 's1')],
          from: _d(10),
          to: _d(12),
          ignoreStayId: 's1',
        ),
        isTrue,
      );
    });
  });

  group('hotelAvailableRooms', () {
    final rooms = [
      _room(id: 'r1', capacity: 2),
      _room(id: 'r2', capacity: 4),
      _room(id: 'r3', capacity: 2, housekeeping: HotelHousekeeping.outOfOrder),
    ];

    test('excludes booked and blocked rooms', () {
      final free = hotelAvailableRooms(
        rooms: rooms,
        stays: [_stay(roomId: 'r1')],
        from: _d(10),
        to: _d(12),
      );
      expect(free.map((r) => r.id), ['r2']);
    });

    test('filters by party size', () {
      final free = hotelAvailableRooms(
        rooms: rooms,
        stays: const [],
        from: _d(20),
        to: _d(22),
        minimumCapacity: 3,
      );
      expect(free.map((r) => r.id), ['r2']);
    });
  });

  group('calendar helpers', () {
    test('hotelCalendarDays returns consecutive days from the start', () {
      final days = hotelCalendarDays(from: DateTime(2026, 1, 30, 18), days: 3);
      expect(days, [_d(30), _d(31), DateTime(2026, 2, 1)]);
    });

    test('free room count per day respects the departure night', () {
      final rooms = [_room(id: 'r1'), _room(id: 'r2')];
      final stays = [_stay(roomId: 'r1')]; // [10, 12)

      expect(
        hotelFreeRoomCountForDay(rooms: rooms, stays: stays, day: _d(11)),
        1,
      );
      expect(
        hotelFreeRoomCountForDay(rooms: rooms, stays: stays, day: _d(12)),
        2,
      );
    });
  });

  group('room plan editing', () {
    test('a duplicate room number is rejected, case and space insensitive', () {
      final rooms = [_room(id: 'r1'), _room(id: 'r2')];
      // _room() names the room after its id.
      expect(
        hotelRoomNumberIsTaken(rooms: rooms, name: ' R1 '),
        isTrue,
      );
      expect(hotelRoomNumberIsTaken(rooms: rooms, name: 'r9'), isFalse);
    });

    test('a room does not clash with itself while being renamed', () {
      final rooms = [_room(id: 'r1')];
      expect(
        hotelRoomNumberIsTaken(rooms: rooms, name: 'r1', excludeRoomId: 'r1'),
        isFalse,
      );
    });

    test('an empty name is not a duplicate, it is just invalid', () {
      expect(
        hotelRoomNumberIsTaken(rooms: [_room()], name: '   '),
        isFalse,
      );
    });

    test('a room holding a guest or a booking cannot be deleted', () {
      final room = _room(id: 'r1');
      expect(hotelRoomCanBeDeleted(room: room, stays: const []), isTrue);
      expect(
        hotelRoomCanBeDeleted(room: room, stays: [_stay(roomId: 'r1')]),
        isFalse,
      );
      expect(
        hotelRoomCanBeDeleted(
          room: room,
          stays: [_stay(roomId: 'r1', status: HotelStayStatus.reserved)],
        ),
        isFalse,
      );
      expect(
        hotelRoomCanBeDeleted(
          room: room,
          stays: [_stay(roomId: 'r1', status: HotelStayStatus.checkedOut)],
        ),
        isTrue,
      );
    });

    test('suggests the next number on a numeric floor', () {
      final floor = [
        _room(id: '101'),
        _room(id: '104'),
        _room(id: '102'),
      ];
      expect(hotelSuggestRoomNumber(floor), '105');
    });

    test('falls back to a count when the scheme is not numeric', () {
      expect(hotelSuggestRoomNumber([_room(id: 'Garden Suite')]), 'Room 2');
      expect(hotelSuggestRoomNumber(const []), 'Room 1');
    });
  });

  group('quotations', () {
    HotelQuotation quote({
      HotelQuotationStatus status = HotelQuotationStatus.sent,
      DateTime? validUntil,
      double extras = 0,
      double discount = 0,
    }) => HotelQuotation(
      id: 'q1',
      branchId: 'b1',
      reference: 'Q-ABC123',
      guestName: 'Aline Uwase',
      roomId: 'r1',
      roomName: '101',
      roomType: 'Double',
      checkInAt: DateTime(2026, 1, 10, 14),
      checkOutAt: DateTime(2026, 1, 12, 11),
      nightlyRate: 50000,
      status: status,
      validUntil: validUntil,
      extrasTotal: extras,
      discount: discount,
    );

    test('prices nights x rate plus extras less discount', () {
      final q = quote(extras: 15000, discount: 5000);
      expect(q.nights, 2);
      expect(q.roomTotal, 100000);
      expect(q.total, 110000);
    });

    test('a discount larger than the stay floors at zero', () {
      expect(quote(discount: 999999).total, 0);
    });

    test('expires only while still open for acceptance', () {
      final past = DateTime(2026, 1, 5);
      final now = DateTime(2026, 1, 6);

      expect(hotelQuotationIsExpired(quote(validUntil: past), now: now), isTrue);
      // Already converted: the validity date is history, not a blocker.
      expect(
        hotelQuotationIsExpired(
          quote(status: HotelQuotationStatus.converted, validUntil: past),
          now: now,
        ),
        isFalse,
      );
    });

    test('never converts twice, and not after being declined or expiring', () {
      final now = DateTime(2026, 1, 6);
      expect(hotelQuotationCanConvert(quote(), now: now), isTrue);
      expect(
        hotelQuotationCanConvert(
          quote(status: HotelQuotationStatus.converted),
          now: now,
        ),
        isFalse,
      );
      expect(
        hotelQuotationCanConvert(
          quote(status: HotelQuotationStatus.declined),
          now: now,
        ),
        isFalse,
      );
      expect(
        hotelQuotationCanConvert(
          quote(validUntil: DateTime(2026, 1, 5)),
          now: now,
        ),
        isFalse,
      );
    });

    test('a quote parked in the expired state can never be converted', () {
      // hotelQuotationIsExpired only inspects the validity date of a *live*
      // quote, so the expired status has to be rejected in its own right.
      expect(
        hotelQuotationCanConvert(quote(status: HotelQuotationStatus.expired)),
        isFalse,
      );
    });

    test('an accepted quote is still convertible until it expires', () {
      expect(
        hotelQuotationCanConvert(quote(status: HotelQuotationStatus.accepted)),
        isTrue,
      );
    });

    test('an expired quote reads as Expired whatever its stored status', () {
      expect(
        hotelQuotationStatusLabel(
          quote(validUntil: DateTime(2026, 1, 5)),
          now: DateTime(2026, 1, 6),
        ),
        'Expired',
      );
      expect(
        hotelQuotationStatusLabel(quote(status: HotelQuotationStatus.converted)),
        'Booked',
      );
    });

    test('survives Ditto string coercion', () {
      final raw = quote(extras: 15000).toJson().map(
        (k, v) => MapEntry(k, v.toString()),
      );
      final parsed = HotelQuotation.fromJson(raw);
      expect(parsed.nightlyRate, 50000);
      expect(parsed.extrasTotal, 15000);
      expect(parsed.adults, 1);
      expect(parsed.status, HotelQuotationStatus.sent);
      expect(parsed.total, 115000);
    });

    test('references are unique and human-quotable', () {
      final a = newHotelQuotationReference();
      final b = newHotelQuotationReference();
      expect(a, startsWith('Q-'));
      expect(a.length, 8);
      expect(a, isNot(b));
    });
  });
}
