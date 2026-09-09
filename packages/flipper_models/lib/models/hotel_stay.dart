import 'package:uuid/uuid.dart';

/// Lifecycle of a booking against a room.
enum HotelStayStatus { reserved, inHouse, checkedOut, cancelled }

HotelStayStatus hotelStayStatusFromString(String? raw) {
  switch (raw?.trim()) {
    case 'reserved':
      return HotelStayStatus.reserved;
    case 'checkedOut':
    case 'checked_out':
      return HotelStayStatus.checkedOut;
    case 'cancelled':
      return HotelStayStatus.cancelled;
    default:
      return HotelStayStatus.inHouse;
  }
}

/// A guest's stay in a room (Ditto `hotel_stays` collection).
///
/// The stay is the hotel domain object; the money lives on a PARKED
/// [ITransaction] referenced by [transactionId] — the folio. Keeping the two
/// apart is what lets a folio carry guest/date fields that would never fit on
/// a transaction row, while still settling through the ordinary POS + RRA
/// completion path at checkout.
class HotelStay {
  const HotelStay({
    required this.id,
    required this.branchId,
    required this.roomId,
    required this.roomName,
    required this.transactionId,
    required this.guestName,
    required this.checkInAt,
    required this.expectedCheckOutAt,
    required this.nightlyRate,
    this.guestPhone,
    this.adults = 1,
    this.children = 0,
    this.status = HotelStayStatus.inHouse,
    this.checkedOutAt,
    this.openedByTenantId,
    this.openedByName,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String branchId;
  final String roomId;

  /// Denormalised room number so the folio reads correctly even if the room
  /// document is later renamed or deleted.
  final String roomName;

  /// PARKED transaction holding the folio charges.
  final String transactionId;

  final String guestName;
  final String? guestPhone;
  final int adults;
  final int children;

  final DateTime checkInAt;
  final DateTime expectedCheckOutAt;
  final DateTime? checkedOutAt;

  final double nightlyRate;
  final HotelStayStatus status;

  final String? openedByTenantId;
  final String? openedByName;
  final String? note;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// A reservation holds no folio until the guest arrives, so the billing
  /// transaction is only created at check-in.
  bool get hasFolio => transactionId.isNotEmpty;

  /// Whether the stay still holds the room.
  bool get isOpen =>
      status == HotelStayStatus.inHouse || status == HotelStayStatus.reserved;

  int get guests => adults + children;

  /// Contracted nights, floor-clamped to 1 — a same-day stay still bills a night.
  int get nights {
    final diff = expectedCheckOutAt.difference(checkInAt).inHours;
    final whole = (diff / 24).ceil();
    return whole < 1 ? 1 : whole;
  }

  HotelStay copyWith({
    String? id,
    String? branchId,
    String? roomId,
    String? roomName,
    String? transactionId,
    String? guestName,
    String? guestPhone,
    int? adults,
    int? children,
    DateTime? checkInAt,
    DateTime? expectedCheckOutAt,
    DateTime? checkedOutAt,
    double? nightlyRate,
    HotelStayStatus? status,
    String? openedByTenantId,
    String? openedByName,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HotelStay(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      transactionId: transactionId ?? this.transactionId,
      guestName: guestName ?? this.guestName,
      guestPhone: guestPhone ?? this.guestPhone,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      checkInAt: checkInAt ?? this.checkInAt,
      expectedCheckOutAt: expectedCheckOutAt ?? this.expectedCheckOutAt,
      checkedOutAt: checkedOutAt ?? this.checkedOutAt,
      nightlyRate: nightlyRate ?? this.nightlyRate,
      status: status ?? this.status,
      openedByTenantId: openedByTenantId ?? this.openedByTenantId,
      openedByName: openedByName ?? this.openedByName,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'branchId': branchId,
      'roomId': roomId,
      'roomName': roomName,
      'transactionId': transactionId,
      'guestName': guestName,
      if (guestPhone != null) 'guestPhone': guestPhone,
      'adults': adults,
      'children': children,
      'checkInAt': checkInAt.toUtc().toIso8601String(),
      'expectedCheckOutAt': expectedCheckOutAt.toUtc().toIso8601String(),
      if (checkedOutAt != null)
        'checkedOutAt': checkedOutAt!.toUtc().toIso8601String(),
      'nightlyRate': nightlyRate,
      'status': status.name,
      if (openedByTenantId != null) 'openedByTenantId': openedByTenantId,
      if (openedByName != null) 'openedByName': openedByName,
      if (note != null) 'note': note,
      if (createdAt != null) 'createdAt': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toUtc().toIso8601String(),
    };
  }

  static HotelStay fromJson(Map<String, dynamic> raw) {
    int toInt(dynamic v, {int fallback = 0}) {
      if (v == null) return fallback;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? fallback;
    }

    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    DateTime? toDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    final checkIn = toDate(raw['checkInAt']) ?? DateTime.now().toUtc();

    return HotelStay(
      id: (raw['id'] ?? raw['_id'] ?? const Uuid().v4()).toString(),
      branchId: (raw['branchId'] ?? '').toString(),
      roomId: (raw['roomId'] ?? '').toString(),
      roomName: (raw['roomName'] ?? '').toString(),
      transactionId: (raw['transactionId'] ?? '').toString(),
      guestName: (raw['guestName'] ?? '').toString(),
      guestPhone: raw['guestPhone']?.toString(),
      adults: toInt(raw['adults'], fallback: 1),
      children: toInt(raw['children']),
      checkInAt: checkIn,
      expectedCheckOutAt:
          toDate(raw['expectedCheckOutAt']) ??
          checkIn.add(const Duration(days: 1)),
      checkedOutAt: toDate(raw['checkedOutAt']),
      nightlyRate: toDouble(raw['nightlyRate']),
      status: hotelStayStatusFromString(raw['status']?.toString()),
      openedByTenantId: raw['openedByTenantId']?.toString(),
      openedByName: raw['openedByName']?.toString(),
      note: raw['note']?.toString(),
      createdAt: toDate(raw['createdAt']),
      updatedAt: toDate(raw['updatedAt']),
    );
  }
}
