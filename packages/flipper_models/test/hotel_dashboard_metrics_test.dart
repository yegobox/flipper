import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_dashboard_metrics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

final _now = DateTime(2026, 1, 10, 9);

HotelRoom _room({
  required String id,
  HotelHousekeeping housekeeping = HotelHousekeeping.clean,
}) => HotelRoom(
  id: id,
  branchId: 'b1',
  floorId: 'ground',
  floorName: 'Ground Floor',
  name: id,
  roomType: 'Double',
  capacity: 2,
  nightlyRate: 50000,
  housekeeping: housekeeping,
);

HotelStay _stay({
  required String id,
  required String roomId,
  HotelStayStatus status = HotelStayStatus.inHouse,
  DateTime? checkIn,
  DateTime? checkOut,
  double rate = 50000,
  int adults = 2,
  int children = 0,
}) => HotelStay(
  id: id,
  branchId: 'b1',
  roomId: roomId,
  roomName: roomId,
  transactionId: 't_$id',
  guestName: 'Guest $id',
  checkInAt: checkIn ?? DateTime(2026, 1, 9, 14),
  expectedCheckOutAt: checkOut ?? DateTime(2026, 1, 12, 11),
  nightlyRate: rate,
  adults: adults,
  children: children,
  status: status,
);

ITransaction _folio(double subTotal) => ITransaction(
  branchId: 'b1',
  status: 'parked',
  transactionType: 'sale',
  paymentType: 'Cash',
  subTotal: subTotal,
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: _now,
  isIncome: true,
  isExpense: false,
  agentId: 'c1',
);

void main() {
  group('room counts and occupancy', () {
    test('occupancy is measured against sellable rooms, not all rooms', () {
      // 4 rooms, one blocked. One guest in house => 1 of 3 sellable.
      final m = hotelDeskMetrics(
        rooms: [
          _room(id: 'r1'),
          _room(id: 'r2'),
          _room(id: 'r3'),
          _room(id: 'r4', housekeeping: HotelHousekeeping.outOfOrder),
        ],
        stays: [_stay(id: 's1', roomId: 'r1')],
        now: _now,
      );

      expect(m.totalRooms, 4);
      expect(m.blocked, 1);
      expect(m.sellableRooms, 3);
      expect(m.occupied, 1);
      expect(m.occupancyRate, closeTo(1 / 3, 0.0001));
    });

    test('a property with every room blocked reports zero, not NaN', () {
      final m = hotelDeskMetrics(
        rooms: [_room(id: 'r1', housekeeping: HotelHousekeeping.outOfOrder)],
        stays: const [],
        now: _now,
      );
      expect(m.occupancyRate, 0);
      expect(m.revPar, 0);
    });

    test('an empty property produces zeroes throughout', () {
      final m = hotelDeskMetrics(rooms: const [], stays: const [], now: _now);
      expect(m.totalRooms, 0);
      expect(m.occupancyRate, 0);
      expect(m.adr, 0);
      expect(m.revPar, 0);
    });
  });

  group('arrivals and departures', () {
    test('counts reservations arriving today', () {
      final m = hotelDeskMetrics(
        rooms: [_room(id: 'r1'), _room(id: 'r2')],
        stays: [
          _stay(
            id: 's1',
            roomId: 'r1',
            status: HotelStayStatus.reserved,
            checkIn: DateTime(2026, 1, 10, 14),
            checkOut: DateTime(2026, 1, 12, 11),
          ),
          _stay(
            id: 's2',
            roomId: 'r2',
            status: HotelStayStatus.reserved,
            checkIn: DateTime(2026, 1, 11, 14),
            checkOut: DateTime(2026, 1, 13, 11),
          ),
        ],
        now: _now,
      );
      expect(m.arrivalsToday, 1);
      expect(m.arrivalsNextSevenDays, 2);
    });

    test('a walk-in checked in today also counts as an arrival', () {
      final m = hotelDeskMetrics(
        rooms: [_room(id: 'r1')],
        stays: [
          _stay(
            id: 's1',
            roomId: 'r1',
            checkIn: DateTime(2026, 1, 10, 8),
            checkOut: DateTime(2026, 1, 12, 11),
          ),
        ],
        now: _now,
      );
      expect(m.arrivalsToday, 1);
      expect(m.occupied, 1);
    });

    test('counts in-house stays leaving today', () {
      final m = hotelDeskMetrics(
        rooms: [_room(id: 'r1'), _room(id: 'r2')],
        stays: [
          _stay(
            id: 's1',
            roomId: 'r1',
            checkOut: DateTime(2026, 1, 10, 11),
          ),
          _stay(
            id: 's2',
            roomId: 'r2',
            checkOut: DateTime(2026, 1, 14, 11),
          ),
        ],
        now: _now,
      );
      expect(m.departuresToday, 1);
    });

    test('flags overstays separately from today departures', () {
      // Departure was 11:00 on the 9th; it is now 09:00 on the 10th.
      final m = hotelDeskMetrics(
        rooms: [_room(id: 'r1')],
        stays: [
          _stay(id: 's1', roomId: 'r1', checkOut: DateTime(2026, 1, 9, 11)),
        ],
        now: _now,
      );
      expect(m.dueOut, 1);
      expect(m.departuresToday, 0);
    });

    test('a checked-out stay is invisible to every counter', () {
      final m = hotelDeskMetrics(
        rooms: [_room(id: 'r1')],
        stays: [
          _stay(id: 's1', roomId: 'r1', status: HotelStayStatus.checkedOut),
        ],
        now: _now,
      );
      expect(m.occupied, 0);
      expect(m.inHouseGuests, 0);
      expect(m.departuresToday, 0);
    });
  });

  group('revenue', () {
    test('ADR averages in-house rates, RevPAR spreads over sellable rooms', () {
      final m = hotelDeskMetrics(
        rooms: [_room(id: 'r1'), _room(id: 'r2'), _room(id: 'r3'), _room(id: 'r4')],
        stays: [
          _stay(id: 's1', roomId: 'r1', rate: 60000),
          _stay(id: 's2', roomId: 'r2', rate: 40000),
        ],
        now: _now,
      );

      expect(m.roomRevenueToday, 100000);
      expect(m.adr, 50000);
      expect(m.revPar, 25000); // 100,000 over 4 sellable rooms
    });

    test('a reservation is not revenue until the guest arrives', () {
      final m = hotelDeskMetrics(
        rooms: [_room(id: 'r1')],
        stays: [
          _stay(
            id: 's1',
            roomId: 'r1',
            status: HotelStayStatus.reserved,
            rate: 90000,
          ),
        ],
        now: _now,
      );
      expect(m.roomRevenueToday, 0);
      expect(m.adr, 0);
    });

    test('open folios total into pending payments', () {
      final m = hotelDeskMetrics(
        rooms: [_room(id: 'r1')],
        stays: [_stay(id: 's1', roomId: 'r1')],
        folios: [_folio(120000), _folio(45000)],
        now: _now,
      );
      expect(m.openFolioCount, 2);
      expect(m.openFolioValue, 165000);
    });

    test('a folio with no subtotal yet contributes nothing', () {
      final m = hotelDeskMetrics(
        rooms: [_room(id: 'r1')],
        stays: const [],
        folios: [_folio(0)],
        now: _now,
      );
      expect(m.openFolioValue, 0);
      expect(m.openFolioCount, 1);
    });
  });

  group('guests', () {
    test('counts adults and children in house', () {
      final m = hotelDeskMetrics(
        rooms: [_room(id: 'r1'), _room(id: 'r2')],
        stays: [
          _stay(id: 's1', roomId: 'r1', adults: 2, children: 1),
          _stay(id: 's2', roomId: 'r2', adults: 1),
        ],
        now: _now,
      );
      expect(m.inHouseGuests, 4);
    });
  });

  group('quotations', () {
    HotelQuotation quote({
      required String id,
      HotelQuotationStatus status = HotelQuotationStatus.sent,
      DateTime? validUntil,
    }) => HotelQuotation(
      id: id,
      branchId: 'b1',
      reference: 'Q-$id',
      guestName: 'Guest',
      roomId: 'r1',
      roomName: '101',
      roomType: 'Double',
      checkInAt: DateTime(2026, 1, 20, 14),
      checkOutAt: DateTime(2026, 1, 22, 11),
      nightlyRate: 50000,
      status: status,
      validUntil: validUntil,
    );

    test('only quotes still open for acceptance are counted', () {
      final m = hotelDeskMetrics(
        rooms: const [],
        stays: const [],
        quotations: [
          quote(id: 'a'),
          quote(id: 'b', status: HotelQuotationStatus.converted),
          quote(id: 'c', validUntil: DateTime(2026, 1, 5)),
        ],
        now: _now,
      );
      expect(m.liveQuotes, 1);
      expect(m.liveQuoteValue, 100000);
    });
  });

  group('list helpers', () {
    test('arrivals for the day are reservations, sorted by time', () {
      final late = _stay(
        id: 'late',
        roomId: 'r1',
        status: HotelStayStatus.reserved,
        checkIn: DateTime(2026, 1, 10, 18),
      );
      final early = _stay(
        id: 'early',
        roomId: 'r2',
        status: HotelStayStatus.reserved,
        checkIn: DateTime(2026, 1, 10, 12),
      );
      final inHouse = _stay(id: 'in', roomId: 'r3');

      final arrivals = hotelArrivalsForDay(
        stays: [late, early, inHouse],
        day: _now,
      );
      expect(arrivals.map((s) => s.id), ['early', 'late']);
    });

    test('departures for the day are in-house stays, sorted by time', () {
      final departures = hotelDeparturesForDay(
        stays: [
          _stay(id: 'a', roomId: 'r1', checkOut: DateTime(2026, 1, 10, 11)),
          _stay(id: 'b', roomId: 'r2', checkOut: DateTime(2026, 1, 10, 8)),
          _stay(id: 'c', roomId: 'r3', checkOut: DateTime(2026, 1, 14, 11)),
        ],
        day: _now,
      );
      expect(departures.map((s) => s.id), ['b', 'a']);
    });

    test('overdue stays are listed longest overdue first', () {
      final overdue = hotelOverdueStays(
        stays: [
          _stay(id: 'a', roomId: 'r1', checkOut: DateTime(2026, 1, 9, 11)),
          _stay(id: 'b', roomId: 'r2', checkOut: DateTime(2026, 1, 8, 11)),
          _stay(id: 'c', roomId: 'r3', checkOut: DateTime(2026, 1, 20, 11)),
        ],
        now: _now,
      );
      expect(overdue.map((s) => s.id), ['b', 'a']);
    });
  });
}
