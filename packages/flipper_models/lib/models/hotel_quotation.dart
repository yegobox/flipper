import 'package:uuid/uuid.dart';

/// Lifecycle of a priced offer.
enum HotelQuotationStatus { draft, sent, accepted, declined, expired, converted }

HotelQuotationStatus hotelQuotationStatusFromString(String? raw) {
  switch (raw?.trim()) {
    case 'sent':
      return HotelQuotationStatus.sent;
    case 'accepted':
      return HotelQuotationStatus.accepted;
    case 'declined':
      return HotelQuotationStatus.declined;
    case 'expired':
      return HotelQuotationStatus.expired;
    case 'converted':
      return HotelQuotationStatus.converted;
    default:
      return HotelQuotationStatus.draft;
  }
}

/// A priced offer for a room over a date range (Ditto `hotel_quotations`).
///
/// A quotation holds no room and creates no folio — it is a document you send
/// a guest. Accepting one turns it into a `reserved` [HotelStay], which is the
/// point at which inventory is actually committed.
class HotelQuotation {
  const HotelQuotation({
    required this.id,
    required this.branchId,
    required this.reference,
    required this.guestName,
    required this.roomId,
    required this.roomName,
    required this.roomType,
    required this.checkInAt,
    required this.checkOutAt,
    required this.nightlyRate,
    this.guestPhone,
    this.guestEmail,
    this.adults = 1,
    this.children = 0,
    this.extrasTotal = 0,
    this.discount = 0,
    this.status = HotelQuotationStatus.draft,
    this.validUntil,
    this.note,
    this.createdByTenantId,
    this.createdByName,
    this.convertedStayId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String branchId;

  /// Short human code the guest quotes back ("Q-4F2A19").
  final String reference;

  final String guestName;
  final String? guestPhone;
  final String? guestEmail;

  final String roomId;
  final String roomName;
  final String roomType;

  final DateTime checkInAt;
  final DateTime checkOutAt;
  final double nightlyRate;

  final int adults;
  final int children;

  /// Extras quoted alongside the room (airport pickup, board basis, …).
  final double extrasTotal;

  /// Absolute discount off the room total, not a percentage.
  final double discount;

  final HotelQuotationStatus status;
  final DateTime? validUntil;
  final String? note;

  final String? createdByTenantId;
  final String? createdByName;

  /// Set once the quotation has been turned into a reservation.
  final String? convertedStayId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Contracted nights, floor-clamped to 1.
  int get nights {
    final whole = (checkOutAt.difference(checkInAt).inHours / 24).ceil();
    return whole < 1 ? 1 : whole;
  }

  double get roomTotal => nightlyRate * nights;

  /// Never negative — a discount larger than the stay cannot pay the guest.
  double get total {
    final gross = roomTotal + extrasTotal - discount;
    return gross < 0 ? 0 : gross;
  }

  /// Still open for the guest to accept.
  bool get isLive =>
      status == HotelQuotationStatus.draft ||
      status == HotelQuotationStatus.sent;

  HotelQuotation copyWith({
    String? id,
    String? branchId,
    String? reference,
    String? guestName,
    String? guestPhone,
    String? guestEmail,
    String? roomId,
    String? roomName,
    String? roomType,
    DateTime? checkInAt,
    DateTime? checkOutAt,
    double? nightlyRate,
    int? adults,
    int? children,
    double? extrasTotal,
    double? discount,
    HotelQuotationStatus? status,
    DateTime? validUntil,
    String? note,
    String? createdByTenantId,
    String? createdByName,
    String? convertedStayId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HotelQuotation(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      reference: reference ?? this.reference,
      guestName: guestName ?? this.guestName,
      guestPhone: guestPhone ?? this.guestPhone,
      guestEmail: guestEmail ?? this.guestEmail,
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      roomType: roomType ?? this.roomType,
      checkInAt: checkInAt ?? this.checkInAt,
      checkOutAt: checkOutAt ?? this.checkOutAt,
      nightlyRate: nightlyRate ?? this.nightlyRate,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      extrasTotal: extrasTotal ?? this.extrasTotal,
      discount: discount ?? this.discount,
      status: status ?? this.status,
      validUntil: validUntil ?? this.validUntil,
      note: note ?? this.note,
      createdByTenantId: createdByTenantId ?? this.createdByTenantId,
      createdByName: createdByName ?? this.createdByName,
      convertedStayId: convertedStayId ?? this.convertedStayId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'branchId': branchId,
      'reference': reference,
      'guestName': guestName,
      if (guestPhone != null) 'guestPhone': guestPhone,
      if (guestEmail != null) 'guestEmail': guestEmail,
      'roomId': roomId,
      'roomName': roomName,
      'roomType': roomType,
      'checkInAt': checkInAt.toUtc().toIso8601String(),
      'checkOutAt': checkOutAt.toUtc().toIso8601String(),
      'nightlyRate': nightlyRate,
      'adults': adults,
      'children': children,
      'extrasTotal': extrasTotal,
      'discount': discount,
      'status': status.name,
      if (validUntil != null)
        'validUntil': validUntil!.toUtc().toIso8601String(),
      if (note != null) 'note': note,
      if (createdByTenantId != null) 'createdByTenantId': createdByTenantId,
      if (createdByName != null) 'createdByName': createdByName,
      if (convertedStayId != null) 'convertedStayId': convertedStayId,
      if (createdAt != null) 'createdAt': createdAt!.toUtc().toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toUtc().toIso8601String(),
    };
  }

  static HotelQuotation fromJson(Map<String, dynamic> raw) {
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

    return HotelQuotation(
      id: (raw['id'] ?? raw['_id'] ?? const Uuid().v4()).toString(),
      branchId: (raw['branchId'] ?? '').toString(),
      reference: (raw['reference'] ?? '').toString(),
      guestName: (raw['guestName'] ?? '').toString(),
      guestPhone: raw['guestPhone']?.toString(),
      guestEmail: raw['guestEmail']?.toString(),
      roomId: (raw['roomId'] ?? '').toString(),
      roomName: (raw['roomName'] ?? '').toString(),
      roomType: (raw['roomType'] ?? '').toString(),
      checkInAt: checkIn,
      checkOutAt:
          toDate(raw['checkOutAt']) ?? checkIn.add(const Duration(days: 1)),
      nightlyRate: toDouble(raw['nightlyRate']),
      adults: toInt(raw['adults'], fallback: 1),
      children: toInt(raw['children']),
      extrasTotal: toDouble(raw['extrasTotal']),
      discount: toDouble(raw['discount']),
      status: hotelQuotationStatusFromString(raw['status']?.toString()),
      validUntil: toDate(raw['validUntil']),
      note: raw['note']?.toString(),
      createdByTenantId: raw['createdByTenantId']?.toString(),
      createdByName: raw['createdByName']?.toString(),
      convertedStayId: raw['convertedStayId']?.toString(),
      createdAt: toDate(raw['createdAt']),
      updatedAt: toDate(raw['updatedAt']),
    );
  }
}

/// Short, human-quotable reference ("Q-4F2A19").
String newHotelQuotationReference() =>
    'Q-${const Uuid().v4().replaceAll('-', '').substring(0, 6).toUpperCase()}';
