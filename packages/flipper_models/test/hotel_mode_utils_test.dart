import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flutter_test/flutter_test.dart';

HotelRoom _room({
  String id = 'r1',
  String name = '101',
  HotelHousekeeping housekeeping = HotelHousekeeping.clean,
}) {
  return HotelRoom(
    id: id,
    branchId: 'b1',
    floorId: 'ground',
    floorName: 'Ground Floor',
    name: name,
    roomType: 'Double',
    capacity: 2,
    nightlyRate: 50000,
    housekeeping: housekeeping,
  );
}

HotelStay _stay({
  String roomId = 'r1',
  HotelStayStatus status = HotelStayStatus.inHouse,
  DateTime? checkIn,
  DateTime? checkOut,
}) {
  final start = checkIn ?? DateTime.utc(2026, 1, 10, 14);
  return HotelStay(
    id: 's1',
    branchId: 'b1',
    roomId: roomId,
    roomName: '101',
    transactionId: 't1',
    guestName: 'Aline Uwase',
    checkInAt: start,
    expectedCheckOutAt: checkOut ?? DateTime.utc(2026, 1, 12, 11),
    nightlyRate: 50000,
    status: status,
  );
}

void main() {
  group('hotelRoomState', () {
    test('out of order beats an occupant', () {
      final state = hotelRoomState(
        room: _room(housekeeping: HotelHousekeeping.outOfOrder),
        stay: _stay(),
      );
      expect(state, HotelRoomState.outOfOrder);
      expect(hotelRoomAcceptsCheckIn(state), isFalse);
    });

    test('an in-house stay makes the room occupied even when clean', () {
      expect(
        hotelRoomState(room: _room(), stay: _stay()),
        HotelRoomState.occupied,
      );
    });

    test('a reserved stay holds the room', () {
      expect(
        hotelRoomState(
          room: _room(),
          stay: _stay(status: HotelStayStatus.reserved),
        ),
        HotelRoomState.reserved,
      );
    });

    test('dirty rooms are not sellable until housekeeping releases them', () {
      final state = hotelRoomState(
        room: _room(housekeeping: HotelHousekeeping.dirty),
      );
      expect(state, HotelRoomState.dirty);
      expect(hotelRoomAcceptsCheckIn(state), isFalse);
    });

    test('a clean room with no stay is vacant and sellable', () {
      final state = hotelRoomState(room: _room());
      expect(state, HotelRoomState.vacant);
      expect(hotelRoomAcceptsCheckIn(state), isTrue);
    });
  });

  group('hotelStayForRoom', () {
    test('ignores closed stays', () {
      final room = _room();
      final stays = [
        _stay(status: HotelStayStatus.checkedOut),
        _stay(status: HotelStayStatus.cancelled),
      ];
      expect(hotelStayForRoom(room, stays), isNull);
    });

    test('matches on room id only', () {
      final room = _room(id: 'r2');
      expect(hotelStayForRoom(room, [_stay(roomId: 'r1')]), isNull);
      expect(hotelStayForRoom(room, [_stay(roomId: 'r2')]), isNotNull);
    });
  });

  group('nights', () {
    test('a same-day stay still bills one night', () {
      final stay = _stay(
        checkIn: DateTime.utc(2026, 1, 10, 9),
        checkOut: DateTime.utc(2026, 1, 10, 18),
      );
      expect(stay.nights, 1);
    });

    test('partial days round up to a whole night', () {
      expect(
        hotelNightsBetween(
          DateTime.utc(2026, 1, 10, 14),
          DateTime.utc(2026, 1, 12, 11),
        ),
        2,
      );
    });
  });

  group('hotelDefaultCheckOut', () {
    test('lands on the house checkout hour n days later', () {
      final out = hotelDefaultCheckOut(
        checkIn: DateTime(2026, 1, 10, 19, 40),
        nights: 3,
        checkOutHour: 11,
      );
      expect(out, DateTime(2026, 1, 13, 11));
    });

    test('clamps a zero-night booking to one night', () {
      final out = hotelDefaultCheckOut(
        checkIn: DateTime(2026, 1, 10),
        nights: 0,
        checkOutHour: 11,
      );
      expect(out, DateTime(2026, 1, 11, 11));
    });
  });

  group('occupancy', () {
    test('counts each room exactly once and excludes blocked from the rate', () {
      final rooms = [
        _room(id: 'r1', name: '101'),
        _room(id: 'r2', name: '102'),
        _room(id: 'r3', name: '103', housekeeping: HotelHousekeeping.dirty),
        _room(
          id: 'r4',
          name: '104',
          housekeeping: HotelHousekeeping.outOfOrder,
        ),
      ];
      final stays = [_stay(roomId: 'r1')];

      final counts = hotelOccupancy(rooms: rooms, stays: stays);
      expect(counts.total, 4);
      expect(counts.occupied, 1);
      expect(counts.vacant, 1);
      expect(counts.dirty, 1);
      expect(counts.blocked, 1);

      // 1 occupied of 3 sellable rooms.
      expect(hotelOccupancyRate(rooms: rooms, stays: stays), closeTo(1 / 3, 1e-9));
    });

    test('rate is zero when nothing is sellable', () {
      final rooms = [
        _room(id: 'r1', housekeeping: HotelHousekeeping.outOfOrder),
      ];
      expect(hotelOccupancyRate(rooms: rooms, stays: const []), 0);
    });
  });

  group('hotelStayIsDue', () {
    test('true once departure has passed', () {
      final stay = _stay(checkOut: DateTime.utc(2026, 1, 12, 11));
      expect(hotelStayIsDue(stay, now: DateTime.utc(2026, 1, 12, 11)), isTrue);
      expect(hotelStayIsDue(stay, now: DateTime.utc(2026, 1, 12, 10)), isFalse);
    });

    test('a checked-out stay is never due', () {
      final stay = _stay(
        status: HotelStayStatus.checkedOut,
        checkOut: DateTime.utc(2020, 1, 1),
      );
      expect(hotelStayIsDue(stay), isFalse);
    });
  });

  group('round-trip json', () {
    test('room survives Ditto string coercion', () {
      final raw = _room().toJson().map(
        (k, v) => MapEntry(k, v is bool ? v : v.toString()),
      );
      final room = HotelRoom.fromJson(raw);
      expect(room.capacity, 2);
      expect(room.nightlyRate, 50000);
      expect(room.housekeeping, HotelHousekeeping.clean);
    });

    test('stay survives Ditto string coercion', () {
      final raw = _stay().toJson().map(
        (k, v) => MapEntry(k, v is bool ? v : v.toString()),
      );
      final stay = HotelStay.fromJson(raw);
      expect(stay.adults, 1);
      expect(stay.nightlyRate, 50000);
      expect(stay.status, HotelStayStatus.inHouse);
      expect(stay.nights, 2);
    });
  });

  test('room charge line names the room and its nights', () {
    expect(
      hotelRoomChargeName(roomName: '204', nights: 1),
      'Room 204 · 1 night',
    );
    expect(
      hotelRoomChargeName(roomName: '204', nights: 3),
      'Room 204 · 3 nights',
    );
  });

  test('default plan ids are deterministic and unique', () {
    final a = defaultHotelRoomPlan(branchId: 'b1');
    final b = defaultHotelRoomPlan(branchId: 'b1');
    expect(a.map((r) => r.id), b.map((r) => r.id));
    expect(a.map((r) => r.id).toSet().length, a.length);
  });
}
