import 'package:uuid/uuid.dart';

/// Nights between arrival and departure, counted on the calendar at the
/// property (device local time), floor-clamped to 1.
///
/// Calendar days, not elapsed hours: a guest who arrives at 09:00 and leaves at
/// 11:00 the next day stayed one night, not ceil(26h / 24) = 2. The daily
/// report (data-connector `hotel_daily.rs`) counts nights the same way.
int hotelCalendarNights(DateTime arrival, DateTime departure) {
  final a = arrival.toLocal();
  final d = departure.toLocal();
  // UTC midnights so a DST shift cannot turn a day into 23 or 25 hours.
  final nights = DateTime.utc(
    d.year,
    d.month,
    d.day,
  ).difference(DateTime.utc(a.year, a.month, a.day)).inDays;
  return nights < 1 ? 1 : nights;
}

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

/// Where an advance stands.
///
/// `held` until checkout or cancellation; then `applied` to the folio, or
/// `refunded` to the guest. Nothing is ever deleted, so the desk can always see
/// what a guest paid and what became of it.
enum HotelAdvanceStatus { held, applied, refunded }

HotelAdvanceStatus hotelAdvanceStatusFromString(String? raw) {
  switch (raw?.trim()) {
    case 'applied':
      return HotelAdvanceStatus.applied;
    case 'refunded':
      return HotelAdvanceStatus.refunded;
    default:
      return HotelAdvanceStatus.held;
  }
}

/// Money a guest paid towards a stay before it was invoiced — a booking
/// deposit, or a part payment during a long stay.
///
/// It is recorded on the day it is paid as a Cash Book "Booking advance" Cash
/// In ([cashMovementId]), so the drawer reconciles that day. It is not revenue:
/// the stay is invoiced once, in full, at checkout, where the advance is
/// applied and only the balance is collected.
class HotelAdvance {
  const HotelAdvance({
    required this.id,
    required this.amount,
    required this.paymentMethod,
    required this.paidAt,
    this.status = HotelAdvanceStatus.held,
    this.clerkTenantId,
    this.clerkName,
    this.cashMovementId,
    this.settlementMovementId,
  });

  final String id;
  final double amount;

  /// Wire value of the tender (`Cash`, `MOBILE MONEY`, `DEBIT&CREDIT CARD`).
  final String paymentMethod;
  final DateTime paidAt;
  final HotelAdvanceStatus status;
  final String? clerkTenantId;
  final String? clerkName;

  /// The "Booking advance" Cash In that received the money.
  final String? cashMovementId;

  /// The Cash Out that applied it at checkout or refunded it. Set once that
  /// movement is written, so a retried checkout never writes a second one.
  final String? settlementMovementId;

  bool get isHeld => status == HotelAdvanceStatus.held;

  HotelAdvance copyWith({
    HotelAdvanceStatus? status,
    String? cashMovementId,
    String? settlementMovementId,
  }) {
    return HotelAdvance(
      id: id,
      amount: amount,
      paymentMethod: paymentMethod,
      paidAt: paidAt,
      status: status ?? this.status,
      clerkTenantId: clerkTenantId,
      clerkName: clerkName,
      cashMovementId: cashMovementId ?? this.cashMovementId,
      settlementMovementId: settlementMovementId ?? this.settlementMovementId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'paymentMethod': paymentMethod,
    'paidAt': paidAt.toUtc().toIso8601String(),
    'status': status.name,
    if (clerkTenantId != null) 'clerkTenantId': clerkTenantId,
    if (clerkName != null) 'clerkName': clerkName,
    if (cashMovementId != null) 'cashMovementId': cashMovementId,
    if (settlementMovementId != null)
      'settlementMovementId': settlementMovementId,
  };

  /// Null for an entry too damaged to trust (no id, or no finite positive
  /// amount): skipping it beats inventing money the guest never paid.
  static HotelAdvance? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString().trim() ?? '';
    final amountRaw = raw['amount'];
    final amount = amountRaw is num
        ? amountRaw.toDouble()
        : double.tryParse(amountRaw?.toString() ?? '') ?? 0;
    if (id.isEmpty || !amount.isFinite || amount <= 0) return null;
    final paidAt =
        DateTime.tryParse(raw['paidAt']?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    return HotelAdvance(
      id: id,
      amount: amount,
      paymentMethod: (raw['paymentMethod'] ?? 'Cash').toString(),
      paidAt: paidAt,
      status: hotelAdvanceStatusFromString(raw['status']?.toString()),
      clerkTenantId: raw['clerkTenantId']?.toString(),
      clerkName: raw['clerkName']?.toString(),
      cashMovementId: raw['cashMovementId']?.toString(),
      settlementMovementId: raw['settlementMovementId']?.toString(),
    );
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
    this.guestEmail,
    this.adults = 1,
    this.children = 0,
    this.status = HotelStayStatus.inHouse,
    this.checkedOutAt,
    this.openedByTenantId,
    this.openedByName,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.advances = const [],
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

  /// Where a booking confirmation is emailed. Optional — plenty of guests give
  /// only a phone number, and a stay is valid with neither.
  final String? guestEmail;

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

  /// Every advance paid towards this stay, whatever became of it.
  final List<HotelAdvance> advances;

  /// Advances still held — what checkout deducts from the folio.
  double get advanceHeld => advances
      .where((a) => a.isHeld)
      .fold<double>(0, (sum, a) => sum + a.amount);

  bool get hasHeldAdvance => advances.any((a) => a.isHeld);

  /// A reservation holds no folio until the guest arrives, so the billing
  /// transaction is only created at check-in.
  bool get hasFolio => transactionId.isNotEmpty;

  /// Whether the stay still holds the room.
  bool get isOpen =>
      status == HotelStayStatus.inHouse || status == HotelStayStatus.reserved;

  int get guests => adults + children;

  /// Contracted nights, floor-clamped to 1 — a same-day stay still bills a night.
  int get nights => hotelCalendarNights(checkInAt, expectedCheckOutAt);

  HotelStay copyWith({
    String? id,
    String? branchId,
    String? roomId,
    String? roomName,
    String? transactionId,
    String? guestName,
    String? guestPhone,
    String? guestEmail,
    bool clearGuestEmail = false,
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
    List<HotelAdvance>? advances,
  }) {
    return HotelStay(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      transactionId: transactionId ?? this.transactionId,
      guestName: guestName ?? this.guestName,
      guestPhone: guestPhone ?? this.guestPhone,
      guestEmail: clearGuestEmail ? null : (guestEmail ?? this.guestEmail),
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
      advances: advances ?? this.advances,
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
      // Written even when null, unlike its neighbours above. `saveHotelStay`
      // upserts with ON ID CONFLICT DO UPDATE, which leaves omitted fields
      // untouched — so omitting a cleared email would resurrect the old one on
      // every other device. Same trap as hotel_branch_settings.dart:95-97.
      'guestEmail': guestEmail,
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
      // [advances] is deliberately absent: the upsert leaves omitted fields
      // untouched, so a save from a stay read before an advance was taken
      // (checkout, an edit, an older build) can never wipe it. Advances are
      // written on their own, from a fresh read — see [advancesJson].
    };
  }

  /// The `advances` field, written by its own UPDATE (never by [toJson]).
  List<Map<String, dynamic>> advancesJson() => [
    for (final a in advances) a.toJson(),
  ];

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
      guestEmail: raw['guestEmail']?.toString(),
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
      advances: [
        if (raw['advances'] is List)
          for (final entry in raw['advances'] as List)
            ?HotelAdvance.fromJson(entry),
      ],
    );
  }
}
