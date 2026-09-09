import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/ditto_transaction_line.dart';
import 'package:flipper_models/sync/utils/rra_line_utils.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// Pure front-desk logic. No Flutter imports — everything here is reusable by
/// a future `flipper_web` hotel surface or by a headless night-audit job.

/// What the desk sees on a room card, in priority order.
enum HotelRoomState {
  /// Sellable right now.
  vacant,

  /// A guest is in the room.
  occupied,

  /// Held by a future/awaiting arrival booking.
  reserved,

  /// Guest gone, housekeeping has not released it.
  dirty,

  /// Maintenance — never sellable.
  outOfOrder,
}

/// Derives the card state from the room's housekeeping flag and its open stay.
///
/// Out-of-order wins over everything (a blocked room must never look sellable),
/// then an actual occupant, then a hold, then housekeeping.
HotelRoomState hotelRoomState({required HotelRoom room, HotelStay? stay}) {
  if (room.housekeeping == HotelHousekeeping.outOfOrder) {
    return HotelRoomState.outOfOrder;
  }
  if (stay != null && stay.status == HotelStayStatus.inHouse) {
    return HotelRoomState.occupied;
  }
  if (stay != null && stay.status == HotelStayStatus.reserved) {
    return HotelRoomState.reserved;
  }
  if (room.housekeeping == HotelHousekeeping.dirty) {
    return HotelRoomState.dirty;
  }
  return HotelRoomState.vacant;
}

String hotelRoomStateLabel(HotelRoomState state) {
  switch (state) {
    case HotelRoomState.vacant:
      return 'Vacant';
    case HotelRoomState.occupied:
      return 'Occupied';
    case HotelRoomState.reserved:
      return 'Reserved';
    case HotelRoomState.dirty:
      return 'Cleaning';
    case HotelRoomState.outOfOrder:
      return 'Out of order';
  }
}

/// Whether tapping the card should start a check-in.
bool hotelRoomAcceptsCheckIn(HotelRoomState state) =>
    state == HotelRoomState.vacant;

/// First open stay bound to [room], or null.
HotelStay? hotelStayForRoom(HotelRoom room, Iterable<HotelStay> stays) {
  for (final stay in stays) {
    if (stay.roomId == room.id && stay.isOpen) return stay;
  }
  return null;
}

/// Σ price × qty across folio lines.
double hotelFolioTotal(Iterable<TransactionItem> lines) => ticketLineTotal(lines);

/// Σ qty across folio lines.
int hotelFolioItemCount(Iterable<TransactionItem> lines) =>
    ticketItemCount(lines);

/// Inclusive VAT 18% breakdown of a folio total.
({double subtotal, double vat, double total}) hotelVatBreakdown(double total) =>
    inclusiveVatBreakdown(total);

/// Parses a Ditto `transaction_items` row for folios.
TransactionItem? hotelFolioLineFromDitto(Map<String, dynamic> data) =>
    transactionLineFromDitto(data);

/// Fills RRA-required fields on folio lines before invoicing.
Future<List<TransactionItem>> enrichHotelFolioLinesForRraReceipt(
  List<TransactionItem> lines,
) =>
    enrichLinesForRraReceipt(lines, context: 'folio invoice');

/// Billable nights between two instants, floor-clamped to 1.
int hotelNightsBetween(DateTime checkIn, DateTime checkOut) {
  final nights = (checkOut.difference(checkIn).inHours / 24).ceil();
  return nights < 1 ? 1 : nights;
}

/// Departure defaulted to house checkout time [checkOutHour], [nights] later.
DateTime hotelDefaultCheckOut({
  required DateTime checkIn,
  required int nights,
  required int checkOutHour,
}) {
  final safeNights = nights < 1 ? 1 : nights;
  final hour = checkOutHour.clamp(0, 23);
  final day = DateTime(
    checkIn.year,
    checkIn.month,
    checkIn.day,
  ).add(Duration(days: safeNights));
  return DateTime(day.year, day.month, day.day, hour);
}

/// Line description for the nightly room charge.
String hotelRoomChargeName({required String roomName, required int nights}) =>
    'Room $roomName · $nights night${nights == 1 ? '' : 's'}';

/// Whether a stay's departure has already passed (due out / overstay).
bool hotelStayIsDue(HotelStay stay, {DateTime? now}) {
  final at = now ?? DateTime.now().toUtc();
  return stay.status == HotelStayStatus.inHouse &&
      !stay.expectedCheckOutAt.isAfter(at);
}

/// Front-desk counters for the header strip.
({int total, int occupied, int vacant, int reserved, int dirty, int blocked})
hotelOccupancy({
  required Iterable<HotelRoom> rooms,
  required Iterable<HotelStay> stays,
}) {
  var occupied = 0, vacant = 0, reserved = 0, dirty = 0, blocked = 0, total = 0;
  final staysList = stays.toList(growable: false);

  for (final room in rooms) {
    total++;
    switch (hotelRoomState(room: room, stay: hotelStayForRoom(room, staysList))) {
      case HotelRoomState.occupied:
        occupied++;
      case HotelRoomState.vacant:
        vacant++;
      case HotelRoomState.reserved:
        reserved++;
      case HotelRoomState.dirty:
        dirty++;
      case HotelRoomState.outOfOrder:
        blocked++;
    }
  }

  return (
    total: total,
    occupied: occupied,
    vacant: vacant,
    reserved: reserved,
    dirty: dirty,
    blocked: blocked,
  );
}

/// Occupancy rate over sellable rooms (0.0–1.0); 0 when nothing is sellable.
double hotelOccupancyRate({
  required Iterable<HotelRoom> rooms,
  required Iterable<HotelStay> stays,
}) {
  final counts = hotelOccupancy(rooms: rooms, stays: stays);
  final sellable = counts.total - counts.blocked;
  if (sellable <= 0) return 0;
  return counts.occupied / sellable;
}

/// "2 nights · 1 adult" style summary for a folio header.
String hotelStaySummary(HotelStay stay) {
  final nights = stay.nights;
  final adults = '${stay.adults} adult${stay.adults == 1 ? '' : 's'}';
  final kids = stay.children > 0
      ? ' · ${stay.children} child${stay.children == 1 ? '' : 'ren'}'
      : '';
  return '$nights night${nights == 1 ? '' : 's'} · $adults$kids';
}

/// Initials for the clerk chip.
String hotelClerkInitials(String? name) => tenantInitials(name);

// --- Availability -----------------------------------------------------------

/// What a single room shows on a single day of the availability calendar.
enum HotelDayState { free, reserved, occupied, blocked }

/// Strips the time component so day comparisons are calendar-based.
DateTime hotelDateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// Whether [stay] holds its room on the calendar day [day].
///
/// Half-open by night, the way hotels actually sell: a stay departing on the
/// 12th does **not** occupy the 12th, so a new arrival can take the room that
/// same morning.
bool hotelStayCoversDay(HotelStay stay, DateTime day) {
  if (!stay.isOpen) return false;
  final d = hotelDateOnly(day);
  final start = hotelDateOnly(stay.checkInAt.toLocal());
  final end = hotelDateOnly(stay.expectedCheckOutAt.toLocal());
  return !d.isBefore(start) && d.isBefore(end);
}

/// Whether [stay] clashes with the half-open range `[from, to)`.
bool hotelStayOverlapsRange(HotelStay stay, DateTime from, DateTime to) {
  if (!stay.isOpen) return false;
  final start = hotelDateOnly(stay.checkInAt.toLocal());
  final end = hotelDateOnly(stay.expectedCheckOutAt.toLocal());
  final rangeStart = hotelDateOnly(from);
  final rangeEnd = hotelDateOnly(to);
  // Touching ends do not overlap: [10,12) and [12,14) are both sellable.
  return start.isBefore(rangeEnd) && rangeStart.isBefore(end);
}

/// Calendar cell state for [room] on [day].
HotelDayState hotelDayState({
  required HotelRoom room,
  required Iterable<HotelStay> stays,
  required DateTime day,
}) {
  if (room.housekeeping == HotelHousekeeping.outOfOrder) {
    return HotelDayState.blocked;
  }
  for (final stay in stays) {
    if (stay.roomId != room.id) continue;
    if (!hotelStayCoversDay(stay, day)) continue;
    return stay.status == HotelStayStatus.reserved
        ? HotelDayState.reserved
        : HotelDayState.occupied;
  }
  return HotelDayState.free;
}

/// Whether [room] can be sold for the whole half-open range `[from, to)`.
bool hotelRoomAvailableForRange({
  required HotelRoom room,
  required Iterable<HotelStay> stays,
  required DateTime from,
  required DateTime to,
  String? ignoreStayId,
}) {
  if (!room.isSellable) return false;
  for (final stay in stays) {
    if (stay.roomId != room.id) continue;
    if (ignoreStayId != null && stay.id == ignoreStayId) continue;
    if (hotelStayOverlapsRange(stay, from, to)) return false;
  }
  return true;
}

/// Every room sellable for the whole of `[from, to)`, in board order.
List<HotelRoom> hotelAvailableRooms({
  required Iterable<HotelRoom> rooms,
  required Iterable<HotelStay> stays,
  required DateTime from,
  required DateTime to,
  int minimumCapacity = 0,
  String? ignoreStayId,
}) {
  final staysList = stays.toList(growable: false);
  return rooms
      .where((room) => room.capacity >= minimumCapacity)
      .where(
        (room) => hotelRoomAvailableForRange(
          room: room,
          stays: staysList,
          from: from,
          to: to,
          ignoreStayId: ignoreStayId,
        ),
      )
      .toList();
}

/// [days] consecutive calendar days starting at [from].
List<DateTime> hotelCalendarDays({required DateTime from, required int days}) {
  final start = hotelDateOnly(from);
  return [for (var i = 0; i < days; i++) start.add(Duration(days: i))];
}

/// Rooms free on [day], used for the calendar's per-day footer count.
int hotelFreeRoomCountForDay({
  required Iterable<HotelRoom> rooms,
  required Iterable<HotelStay> stays,
  required DateTime day,
}) {
  final staysList = stays.toList(growable: false);
  var free = 0;
  for (final room in rooms) {
    if (hotelDayState(room: room, stays: staysList, day: day) ==
        HotelDayState.free) {
      free++;
    }
  }
  return free;
}

// --- Quotations -------------------------------------------------------------

/// A quotation past its validity can no longer be accepted.
bool hotelQuotationIsExpired(HotelQuotation quotation, {DateTime? now}) {
  final validUntil = quotation.validUntil;
  if (validUntil == null) return false;
  if (!quotation.isLive) return false;
  return (now ?? DateTime.now().toUtc()).isAfter(validUntil);
}

/// Whether the desk may still turn [quotation] into a reservation.
bool hotelQuotationCanConvert(HotelQuotation quotation, {DateTime? now}) {
  if (quotation.status == HotelQuotationStatus.converted) return false;
  if (quotation.status == HotelQuotationStatus.declined) return false;
  return !hotelQuotationIsExpired(quotation, now: now);
}

String hotelQuotationStatusLabel(
  HotelQuotation quotation, {
  DateTime? now,
}) {
  if (hotelQuotationIsExpired(quotation, now: now)) return 'Expired';
  switch (quotation.status) {
    case HotelQuotationStatus.draft:
      return 'Draft';
    case HotelQuotationStatus.sent:
      return 'Sent';
    case HotelQuotationStatus.accepted:
      return 'Accepted';
    case HotelQuotationStatus.declined:
      return 'Declined';
    case HotelQuotationStatus.expired:
      return 'Expired';
    case HotelQuotationStatus.converted:
      return 'Booked';
  }
}

// --- Room plan editing ------------------------------------------------------

/// Whether [name] is already used by another room on the branch.
///
/// Room numbers are what guests are told and what housekeeping sheets are
/// printed against, so two rooms sharing one is a real operational problem.
bool hotelRoomNumberIsTaken({
  required Iterable<HotelRoom> rooms,
  required String name,
  String? excludeRoomId,
}) {
  final candidate = name.trim().toLowerCase();
  if (candidate.isEmpty) return false;
  for (final room in rooms) {
    if (room.id == excludeRoomId) continue;
    if (room.name.trim().toLowerCase() == candidate) return true;
  }
  return false;
}

/// A room holding a guest or a booking cannot be deleted out from under it.
bool hotelRoomCanBeDeleted({
  required HotelRoom room,
  required Iterable<HotelStay> stays,
}) => hotelStayForRoom(room, stays) == null;

/// Suggests the next room number on a floor by incrementing the highest
/// numeric one, falling back to a count-based name for non-numeric schemes.
String hotelSuggestRoomNumber(Iterable<HotelRoom> floorRooms) {
  var highest = 0;
  var sawNumber = false;
  for (final room in floorRooms) {
    final parsed = int.tryParse(room.name.trim());
    if (parsed == null) continue;
    sawNumber = true;
    if (parsed > highest) highest = parsed;
  }
  if (sawNumber) return '${highest + 1}';
  return 'Room ${floorRooms.length + 1}';
}

/// Common room types offered in the editor; the field stays free text so a
/// property can name its own.
const hotelRoomTypePresets = <String>[
  'Single',
  'Double',
  'Twin',
  'Triple',
  'Deluxe',
  'Junior Suite',
  'Executive Suite',
  'Presidential',
];
