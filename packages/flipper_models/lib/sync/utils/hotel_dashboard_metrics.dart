import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

/// Everything the manager's dashboard shows, computed in one pass.
///
/// Pure data: no Flutter, no Ditto. The screen renders this and nothing else,
/// so the numbers can be tested without pumping a widget or standing up a
/// database.
class HotelDeskMetrics {
  const HotelDeskMetrics({
    required this.totalRooms,
    required this.occupied,
    required this.vacant,
    required this.reserved,
    required this.cleaning,
    required this.blocked,
    required this.occupancyRate,
    required this.arrivalsToday,
    required this.departuresToday,
    required this.dueOut,
    required this.inHouseGuests,
    required this.adr,
    required this.revPar,
    required this.roomRevenueToday,
    required this.openFolioValue,
    required this.openFolioCount,
    required this.liveQuotes,
    required this.liveQuoteValue,
    required this.arrivalsNextSevenDays,
  });

  /// Room counts by board state.
  final int totalRooms;
  final int occupied;
  final int vacant;
  final int reserved;
  final int cleaning;
  final int blocked;

  /// Occupied over *sellable* rooms (0.0–1.0). Blocked rooms are excluded —
  /// counting them would flatter a property that has half its rooms broken.
  final double occupancyRate;

  final int arrivalsToday;
  final int departuresToday;

  /// In-house stays whose departure has already passed.
  final int dueOut;

  /// Heads in beds, adults plus children.
  final int inHouseGuests;

  /// Average daily rate across in-house stays.
  final double adr;

  /// Revenue per available room: room revenue spread over sellable rooms.
  final double revPar;

  /// Contracted room revenue for tonight.
  final double roomRevenueToday;

  /// Money sitting on open folios — the "pending payments" figure.
  final double openFolioValue;
  final int openFolioCount;

  /// Quotations still open for the guest to accept.
  final int liveQuotes;
  final double liveQuoteValue;

  /// Confirmed arrivals in the coming week, today included.
  final int arrivalsNextSevenDays;

  /// Rooms a manager can actually sell right now.
  int get sellableRooms => totalRooms - blocked;

  static const empty = HotelDeskMetrics(
    totalRooms: 0,
    occupied: 0,
    vacant: 0,
    reserved: 0,
    cleaning: 0,
    blocked: 0,
    occupancyRate: 0,
    arrivalsToday: 0,
    departuresToday: 0,
    dueOut: 0,
    inHouseGuests: 0,
    adr: 0,
    revPar: 0,
    roomRevenueToday: 0,
    openFolioValue: 0,
    openFolioCount: 0,
    liveQuotes: 0,
    liveQuoteValue: 0,
    arrivalsNextSevenDays: 0,
  );
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Computes the manager dashboard in a single pass over the branch's data.
///
/// [folios] are the open (PARKED) transactions behind in-house stays; pass an
/// empty list and every money figure simply reads zero.
HotelDeskMetrics hotelDeskMetrics({
  required Iterable<HotelRoom> rooms,
  required Iterable<HotelStay> stays,
  Iterable<ITransaction> folios = const [],
  Iterable<HotelQuotation> quotations = const [],
  DateTime? now,
}) {
  final at = now ?? DateTime.now();
  final today = hotelDateOnly(at);
  final weekEnd = today.add(const Duration(days: 7));

  final roomList = rooms.toList(growable: false);
  final stayList = stays.toList(growable: false);

  final counts = hotelOccupancy(rooms: roomList, stays: stayList);

  var arrivalsToday = 0;
  var departuresToday = 0;
  var dueOut = 0;
  var inHouseGuests = 0;
  var arrivalsWeek = 0;
  var rateSum = 0.0;
  var inHouseCount = 0;

  for (final stay in stayList) {
    if (!stay.isOpen) continue;

    final arrival = hotelDateOnly(stay.checkInAt.toLocal());
    final departure = hotelDateOnly(stay.expectedCheckOutAt.toLocal());

    if (stay.status == HotelStayStatus.reserved) {
      if (_isSameDay(arrival, today)) arrivalsToday++;
      if (!arrival.isBefore(today) && arrival.isBefore(weekEnd)) {
        arrivalsWeek++;
      }
      continue;
    }

    // In house from here on.
    inHouseCount++;
    inHouseGuests += stay.guests;
    rateSum += stay.nightlyRate;

    // A walk-in checked in today counts as an arrival the desk handled.
    if (_isSameDay(arrival, today)) {
      arrivalsToday++;
      arrivalsWeek++;
    }
    if (_isSameDay(departure, today)) departuresToday++;
    if (hotelStayIsDue(stay, now: at.toUtc())) dueOut++;
  }

  final sellable = counts.total - counts.blocked;
  final adr = inHouseCount == 0 ? 0.0 : rateSum / inHouseCount;
  final revPar = sellable <= 0 ? 0.0 : rateSum / sellable;

  var openFolioValue = 0.0;
  var openFolioCount = 0;
  for (final folio in folios) {
    openFolioCount++;
    openFolioValue += (folio.subTotal ?? 0).toDouble();
  }

  var liveQuotes = 0;
  var liveQuoteValue = 0.0;
  for (final quote in quotations) {
    if (!hotelQuotationCanConvert(quote, now: at.toUtc())) continue;
    liveQuotes++;
    liveQuoteValue += quote.total;
  }

  return HotelDeskMetrics(
    totalRooms: counts.total,
    occupied: counts.occupied,
    vacant: counts.vacant,
    reserved: counts.reserved,
    cleaning: counts.dirty,
    blocked: counts.blocked,
    occupancyRate: sellable <= 0 ? 0 : counts.occupied / sellable,
    arrivalsToday: arrivalsToday,
    departuresToday: departuresToday,
    dueOut: dueOut,
    inHouseGuests: inHouseGuests,
    adr: adr,
    revPar: revPar,
    roomRevenueToday: rateSum,
    openFolioValue: openFolioValue,
    openFolioCount: openFolioCount,
    liveQuotes: liveQuotes,
    liveQuoteValue: liveQuoteValue,
    arrivalsNextSevenDays: arrivalsWeek,
  );
}

/// Reserved stays arriving on [day], soonest first — the arrivals list.
List<HotelStay> hotelArrivalsForDay({
  required Iterable<HotelStay> stays,
  DateTime? day,
}) {
  final target = hotelDateOnly(day ?? DateTime.now());
  final list = stays
      .where(
        (stay) =>
            stay.status == HotelStayStatus.reserved &&
            _isSameDay(hotelDateOnly(stay.checkInAt.toLocal()), target),
      )
      .toList();
  list.sort((a, b) => a.checkInAt.compareTo(b.checkInAt));
  return list;
}

/// In-house stays due to leave on [day], soonest first.
List<HotelStay> hotelDeparturesForDay({
  required Iterable<HotelStay> stays,
  DateTime? day,
}) {
  final target = hotelDateOnly(day ?? DateTime.now());
  final list = stays
      .where(
        (stay) =>
            stay.status == HotelStayStatus.inHouse &&
            _isSameDay(
              hotelDateOnly(stay.expectedCheckOutAt.toLocal()),
              target,
            ),
      )
      .toList();
  list.sort((a, b) => a.expectedCheckOutAt.compareTo(b.expectedCheckOutAt));
  return list;
}

/// In-house stays whose departure has already passed, longest overdue first.
List<HotelStay> hotelOverdueStays({
  required Iterable<HotelStay> stays,
  DateTime? now,
}) {
  final at = (now ?? DateTime.now()).toUtc();
  final list = stays.where((s) => hotelStayIsDue(s, now: at)).toList();
  list.sort((a, b) => a.expectedCheckOutAt.compareTo(b.expectedCheckOutAt));
  return list;
}
