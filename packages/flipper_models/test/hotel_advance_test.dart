import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

HotelStay _stay({
  List<HotelAdvance> advances = const [],
  DateTime? updatedAt,
  DateTime? checkOut,
  String roomName = '101',
}) => HotelStay(
  id: 's1',
  branchId: 'b1',
  roomId: 'r1',
  roomName: roomName,
  transactionId: 't1',
  guestName: 'Aline Uwase',
  checkInAt: DateTime.utc(2026, 1, 10, 14),
  expectedCheckOutAt: checkOut ?? DateTime.utc(2026, 1, 12, 11),
  nightlyRate: 50000,
  advances: advances,
  updatedAt: updatedAt,
);

HotelAdvance _advance(
  String id, {
  double amount = 20000,
  HotelAdvanceStatus status = HotelAdvanceStatus.held,
}) => HotelAdvance(
  id: id,
  amount: amount,
  paymentMethod: 'Cash',
  paidAt: DateTime.utc(2026, 1, 5, 9),
  status: status,
  clerkTenantId: 'c1',
  clerkName: 'Richie',
  cashMovementId: 'cm-$id',
);

TransactionItem _line(String name, num qty) => TransactionItem(
  name: name,
  qty: qty,
  price: 50000,
  discount: 0,
  prc: 50000,
  ttCatCd: 'TT',
);

void main() {
  group('HotelAdvance JSON', () {
    test('round-trips every field', () {
      final a = _advance(
        'a1',
        status: HotelAdvanceStatus.applied,
      ).copyWith(settlementMovementId: 'cm-out');
      final back = HotelAdvance.fromJson(a.toJson())!;
      expect(back.id, 'a1');
      expect(back.amount, 20000);
      expect(back.paymentMethod, 'Cash');
      expect(back.paidAt, DateTime.utc(2026, 1, 5, 9));
      expect(back.status, HotelAdvanceStatus.applied);
      expect(back.clerkTenantId, 'c1');
      expect(back.clerkName, 'Richie');
      expect(back.cashMovementId, 'cm-a1');
      expect(back.settlementMovementId, 'cm-out');
    });

    test('reads Ditto string numbers and defaults what is missing', () {
      final back = HotelAdvance.fromJson({'id': 'a1', 'amount': '15000'})!;
      expect(back.amount, 15000);
      expect(back.paymentMethod, 'Cash');
      expect(back.status, HotelAdvanceStatus.held);
      expect(back.paidAt, DateTime.fromMillisecondsSinceEpoch(0, isUtc: true));
    });

    test('drops entries it cannot trust instead of inventing money', () {
      expect(HotelAdvance.fromJson(null), isNull);
      expect(HotelAdvance.fromJson('x'), isNull);
      expect(HotelAdvance.fromJson({'amount': 100}), isNull);
      expect(HotelAdvance.fromJson({'id': 'a', 'amount': 0}), isNull);
      expect(HotelAdvance.fromJson({'id': 'a', 'amount': 'junk'}), isNull);
      // Non-finite money would throw on formatting and poison settlement.
      expect(HotelAdvance.fromJson({'id': 'a', 'amount': 'NaN'}), isNull);
      expect(
        HotelAdvance.fromJson({'id': 'a', 'amount': double.infinity}),
        isNull,
      );
    });

    test('unknown status reads as held', () {
      expect(hotelAdvanceStatusFromString('weird'), HotelAdvanceStatus.held);
      expect(hotelAdvanceStatusFromString(null), HotelAdvanceStatus.held);
      expect(
        hotelAdvanceStatusFromString('refunded'),
        HotelAdvanceStatus.refunded,
      );
    });
  });

  group('HotelStay advances', () {
    test('an old document without advances reads as none', () {
      final stay = HotelStay.fromJson(_stay().toJson());
      expect(stay.advances, isEmpty);
      expect(stay.advanceHeld, 0);
      expect(stay.hasHeldAdvance, isFalse);
    });

    test('toJson never carries advances; advancesJson does', () {
      final stay = _stay(advances: [_advance('a1')]);
      expect(stay.toJson().containsKey('advances'), isFalse);
      final read = HotelStay.fromJson({
        ...stay.toJson(),
        'advances': [
          ...stay.advancesJson(),
          {'id': 'bad'},
        ],
      });
      expect(read.advances.map((a) => a.id), ['a1']);
    });

    test('only held advances count towards checkout', () {
      final stay = _stay(
        advances: [
          _advance('a1'),
          _advance('a2', amount: 5000, status: HotelAdvanceStatus.refunded),
          _advance('a3', amount: 7000, status: HotelAdvanceStatus.applied),
          _advance('a4', amount: 1000),
        ],
      );
      expect(stay.advanceHeld, 21000);
      expect(stay.hasHeldAdvance, isTrue);
    });

    test('copyWith keeps or replaces the advances', () {
      final stay = _stay(advances: [_advance('a1')]);
      expect(stay.copyWith(guestName: 'X').advances, hasLength(1));
      expect(stay.copyWith(advances: const []).advances, isEmpty);
    });
  });

  group('HotelAdvanceSettlement', () {
    test('no advance: the whole folio is due', () {
      final p = HotelAdvanceSettlement.of(total: 100000, held: 0);
      expect((p.applied, p.balance, p.surplus), (0, 100000, 0));
    });

    test('a part advance leaves the rest due', () {
      final p = HotelAdvanceSettlement.of(total: 100000, held: 30000);
      expect((p.applied, p.balance, p.surplus), (30000, 70000, 0));
    });

    test('an exact advance leaves nothing due', () {
      final p = HotelAdvanceSettlement.of(total: 100000, held: 100000);
      expect((p.applied, p.balance, p.surplus), (100000, 0, 0));
    });

    test('an advance above the folio is refunded the difference', () {
      final p = HotelAdvanceSettlement.of(total: 80000, held: 100000);
      expect((p.applied, p.balance, p.surplus), (80000, 0, 20000));
    });

    test('half a franc either way counts as settled', () {
      final under = HotelAdvanceSettlement.of(total: 100000.4, held: 100000);
      expect(under.balance, 0);
      final over = HotelAdvanceSettlement.of(total: 100000, held: 100000.4);
      expect(over.surplus, 0);
    });

    test('negative inputs are treated as zero', () {
      final p = HotelAdvanceSettlement.of(total: -5, held: -5);
      expect((p.applied, p.balance, p.surplus), (0, 0, 0));
    });
  });

  group('room-night lines', () {
    test('only this room\'s night lines are counted', () {
      final stay = _stay();
      final lines = [
        _line('Room 101 · 2 nights', 2),
        _line('Beer', 3),
        _line('Room 1010 · 1 night', 1),
        _line('Room 101 · 1 night', 1),
      ];
      expect(hotelRoomChargeLines(stay, lines), hasLength(2));
      expect(hotelBilledNights(stay, lines), 3);
      expect(hotelBilledNights(stay, const []), 0);
    });
  });

  group('notes', () {
    test('advance note names the room and guest', () {
      expect(hotelAdvanceNote(_stay()), 'Room 101 · Aline Uwase');
    });

    test('credit note names the room and the dates', () {
      final note = hotelCreditNote(_stay());
      expect(note, startsWith('Hotel · Room 101 · '));
      expect(note, contains('2026-01-1'));
      expect(note, contains(' → '));
    });
  });

  group('hotelStayWithLiveDetails', () {
    final t0 = DateTime.utc(2026, 1, 10, 15);
    final t1 = DateTime.utc(2026, 1, 10, 16);

    test('another stay leaves the active one untouched', () {
      final active = _stay(updatedAt: t0);
      final other = HotelStay.fromJson({...active.toJson(), 'id': 'zz'});
      expect(
        identical(hotelStayWithLiveDetails(active, other), active),
        isTrue,
      );
    });

    test('an unchanged newer copy returns the same instance', () {
      final active = _stay(updatedAt: t0, advances: [_advance('a1')]);
      final live = _stay(updatedAt: t1, advances: [_advance('a1')]);
      expect(identical(hotelStayWithLiveDetails(active, live), active), isTrue);
    });

    test('a newer copy brings advances and departure from elsewhere', () {
      final active = _stay(updatedAt: t0);
      final live = _stay(
        updatedAt: t1,
        advances: [_advance('a1')],
        checkOut: DateTime.utc(2026, 1, 14, 11),
      );
      final merged = hotelStayWithLiveDetails(active, live);
      expect(merged.advanceHeld, 20000);
      expect(merged.expectedCheckOutAt, DateTime.utc(2026, 1, 14, 11));
      expect(merged.updatedAt, t1);
    });

    test('an older copy cannot undo the desk\'s own write', () {
      final active = _stay(updatedAt: t1, advances: [_advance('a1')]);
      final lagging = _stay(updatedAt: t0, roomName: '102');
      final merged = hotelStayWithLiveDetails(active, lagging);
      expect(merged.advanceHeld, 20000);
      // The room name always follows the stream.
      expect(merged.roomName, '102');
    });

    test('an older copy with the same name is a no-op', () {
      final active = _stay(updatedAt: t1);
      final lagging = _stay(updatedAt: t0);
      expect(
        identical(hotelStayWithLiveDetails(active, lagging), active),
        isTrue,
      );
    });

    test('a status change on an advance counts as a change', () {
      final active = _stay(updatedAt: t0, advances: [_advance('a1')]);
      final live = _stay(
        updatedAt: t1,
        advances: [_advance('a1', status: HotelAdvanceStatus.applied)],
      );
      expect(
        hotelStayWithLiveDetails(active, live).advances.single.status,
        HotelAdvanceStatus.applied,
      );
    });

    test('a corrected method or clerk on an advance counts as a change', () {
      final original = _advance('a1');
      final active = _stay(updatedAt: t0, advances: [original]);
      HotelAdvance with_({
        String method = 'Cash',
        DateTime? paidAt,
        String? clerkTenantId = 'c1',
        String? clerkName = 'Richie',
        String? cashMovementId = 'cm-a1',
      }) => HotelAdvance(
        id: 'a1',
        amount: original.amount,
        paymentMethod: method,
        paidAt: paidAt ?? original.paidAt,
        clerkTenantId: clerkTenantId,
        clerkName: clerkName,
        cashMovementId: cashMovementId,
      );
      for (final changed in [
        with_(method: 'MOBILE MONEY'),
        with_(paidAt: DateTime.utc(2026, 1, 6)),
        with_(clerkTenantId: 'c2'),
        with_(clerkName: 'Aline'),
        with_(cashMovementId: 'cm-other'),
      ]) {
        final live = _stay(updatedAt: t1, advances: [changed]);
        final merged = hotelStayWithLiveDetails(active, live);
        expect(identical(merged, active), isFalse);
        expect(merged.advances.single, same(changed));
      }
    });

    test('an active stay with no timestamp takes the stream copy', () {
      final active = _stay();
      final live = _stay(updatedAt: t0, advances: [_advance('a1')]);
      expect(hotelStayWithLiveDetails(active, live).advanceHeld, 20000);
    });
  });

  group('hotelAdvanceSurplusByMethod', () {
    HotelAdvance paid(String id, double amount, String method) => HotelAdvance(
      id: id,
      amount: amount,
      paymentMethod: method,
      paidAt: DateTime.utc(2026, 1, 5),
    );

    test('takes the surplus from the latest advances, per method', () {
      final held = [
        paid('a1', 90000, 'Cash'),
        paid('a2', 10000, 'DEBIT&CREDIT CARD'),
      ];
      // RWF 100,000 held against a RWF 20,000 folio: 80,000 goes back.
      final parts = hotelAdvanceSurplusByMethod(held, 80000);
      expect(parts.map((p) => (p.method, p.amount, p.advanceIds.join(','))), [
        ('DEBIT&CREDIT CARD', 10000, 'a2'),
        ('Cash', 70000, 'a1'),
      ]);
    });

    test('advances of one method share one refund', () {
      final held = [
        paid('a1', 30000, 'Cash'),
        paid('a2', 30000, 'Cash'),
        paid('a3', 30000, 'MOBILE MONEY'),
      ];
      final parts = hotelAdvanceSurplusByMethod(held, 50000);
      expect(parts.map((p) => (p.method, p.amount, p.advanceIds.join(','))), [
        ('MOBILE MONEY', 30000, 'a3'),
        ('Cash', 20000, 'a2'),
      ]);
      expect(hotelAdvanceSurplusByMethod(held, 0), isEmpty);
    });
  });

  test('hotelTenderIsCash', () {
    expect(hotelTenderIsCash('Cash'), isTrue);
    expect(hotelTenderIsCash(' CASH '), isTrue);
    expect(hotelTenderIsCash('MOBILE MONEY'), isFalse);
    expect(hotelTenderIsCash('DEBIT&CREDIT CARD'), isFalse);
  });
}
