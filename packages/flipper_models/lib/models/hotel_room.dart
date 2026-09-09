import 'package:uuid/uuid.dart';

/// Housekeeping state of a room — independent of whether a guest occupies it.
enum HotelHousekeeping { clean, dirty, inspected, outOfOrder }

HotelHousekeeping hotelHousekeepingFromString(String? raw) {
  switch (raw?.trim()) {
    case 'dirty':
      return HotelHousekeeping.dirty;
    case 'inspected':
      return HotelHousekeeping.inspected;
    case 'outOfOrder':
    case 'out_of_order':
      return HotelHousekeeping.outOfOrder;
    default:
      return HotelHousekeeping.clean;
  }
}

String hotelHousekeepingToString(HotelHousekeeping value) => value.name;

/// A sellable room (Ditto `hotel_rooms` collection).
///
/// Mirrors the shape of [BarTable]: a branch-scoped, ordinal-sorted unit
/// grouped under a "zone" (here, a floor or wing).
class HotelRoom {
  const HotelRoom({
    required this.id,
    required this.branchId,
    required this.floorId,
    required this.floorName,
    required this.name,
    required this.roomType,
    required this.capacity,
    required this.nightlyRate,
    this.housekeeping = HotelHousekeeping.clean,
    this.ordinal = 0,
    this.variantId,
  });

  final String id;
  final String branchId;

  /// Floor / wing grouping — the hotel analogue of a bar zone.
  final String floorId;
  final String floorName;

  /// Room number as guests see it ("204").
  final String name;

  /// "Single", "Double", "Twin", "Suite" — free text, shown on the card.
  final String roomType;

  /// Maximum guests (adults + children).
  final int capacity;

  /// Rack rate per night in branch currency.
  final double nightlyRate;

  final HotelHousekeeping housekeeping;
  final int ordinal;

  /// The RRA tourism-tax service item this room is registered as.
  ///
  /// A room is not a good; RRA takes accommodation as an `itemTyCd` `3`
  /// service at 3% TT. Until this is set the room exists only to us, and its
  /// nightly charge cannot be invoiced correctly. See `hotel_room_rra.dart`.
  final String? variantId;

  bool get isRegisteredWithRra =>
      variantId != null && variantId!.trim().isNotEmpty;

  /// A room under maintenance can never be sold, whatever its stay state is.
  bool get isSellable => housekeeping != HotelHousekeeping.outOfOrder;

  HotelRoom copyWith({
    String? id,
    String? branchId,
    String? floorId,
    String? floorName,
    String? name,
    String? roomType,
    int? capacity,
    double? nightlyRate,
    HotelHousekeeping? housekeeping,
    int? ordinal,
    String? variantId,
  }) {
    return HotelRoom(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      floorId: floorId ?? this.floorId,
      floorName: floorName ?? this.floorName,
      name: name ?? this.name,
      roomType: roomType ?? this.roomType,
      capacity: capacity ?? this.capacity,
      nightlyRate: nightlyRate ?? this.nightlyRate,
      housekeeping: housekeeping ?? this.housekeeping,
      ordinal: ordinal ?? this.ordinal,
      variantId: variantId ?? this.variantId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'branchId': branchId,
      'floorId': floorId,
      'floorName': floorName,
      'name': name,
      'roomType': roomType,
      'capacity': capacity,
      'nightlyRate': nightlyRate,
      'housekeeping': hotelHousekeepingToString(housekeeping),
      'ordinal': ordinal,
      'variantId': variantId,
    };
  }

  static HotelRoom fromJson(Map<String, dynamic> raw) {
    int toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    return HotelRoom(
      id: (raw['id'] ?? raw['_id'] ?? const Uuid().v4()).toString(),
      branchId: (raw['branchId'] ?? '').toString(),
      floorId: (raw['floorId'] ?? '').toString(),
      floorName: (raw['floorName'] ?? '').toString(),
      name: (raw['name'] ?? '').toString(),
      roomType: (raw['roomType'] ?? '').toString(),
      capacity: toInt(raw['capacity']),
      nightlyRate: toDouble(raw['nightlyRate']),
      housekeeping: hotelHousekeepingFromString(raw['housekeeping']?.toString()),
      ordinal: toInt(raw['ordinal']),
      variantId: (raw['variantId']?.toString().trim().isEmpty ?? true)
          ? null
          : raw['variantId'].toString().trim(),
    );
  }
}

/// Starter room list seeded on first launch of Hotel Mode for a branch.
///
/// Deterministic ids (`<branch>_<floor>_<room>`) so re-seeding is idempotent
/// even if the guard in `seedDefaultRooms` is bypassed.
List<HotelRoom> defaultHotelRoomPlan({required String branchId}) {
  final rooms = <HotelRoom>[];
  var ordinal = 0;

  void addFloor(
    String floorId,
    String floorName,
    List<(String number, String type, int capacity, double rate)> defs,
  ) {
    for (final def in defs) {
      rooms.add(
        HotelRoom(
          id: '${branchId}_${floorId}_${def.$1}',
          branchId: branchId,
          floorId: floorId,
          floorName: floorName,
          name: def.$1,
          roomType: def.$2,
          capacity: def.$3,
          nightlyRate: def.$4,
          ordinal: ordinal++,
        ),
      );
    }
  }

  addFloor('ground', 'Ground Floor', [
    ('101', 'Single', 1, 35000),
    ('102', 'Single', 1, 35000),
    ('103', 'Double', 2, 55000),
    ('104', 'Double', 2, 55000),
    ('105', 'Twin', 2, 55000),
    ('106', 'Twin', 2, 55000),
  ]);
  addFloor('first', 'First Floor', [
    ('201', 'Double', 2, 60000),
    ('202', 'Double', 2, 60000),
    ('203', 'Twin', 2, 60000),
    ('204', 'Deluxe', 3, 85000),
    ('205', 'Deluxe', 3, 85000),
    ('206', 'Deluxe', 3, 85000),
  ]);
  addFloor('suites', 'Suites', [
    ('301', 'Junior Suite', 3, 120000),
    ('302', 'Executive Suite', 4, 160000),
    ('303', 'Presidential', 4, 250000),
  ]);

  return rooms;
}
