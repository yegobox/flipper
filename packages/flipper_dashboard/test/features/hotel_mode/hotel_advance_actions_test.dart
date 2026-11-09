import 'package:flipper_dashboard/features/hotel_mode/hotel_desk_actions.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/cash_movement_rules.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import '../../test_helpers/mocks.dart';

// flutter test test/features/hotel_mode/hotel_advance_actions_test.dart

class _MockSync extends Mock implements DatabaseSyncInterface {}

/// One cash movement the desk wrote.
class _Movement {
  _Movement(Map<Symbol, dynamic> a)
    : amount = a[#cashReceived] as double,
      income = a[#isIncome] as bool,
      kind = a[#transactionTypeForRecord] as String,
      method = a[#paymentType] as String,
      note = a[#note] as String?,
      skipGoalSweep = (a[#skipPersonalGoalAutoSweep] as bool?) ?? false,
      updateShift = (a[#updateShift] as bool?) ?? true;

  final double amount;
  final bool income;
  final String kind;
  final String method;
  final String? note;
  final bool skipGoalSweep;
  final bool updateShift;
}

HotelStay _stay({List<HotelAdvance> advances = const []}) => HotelStay(
  id: 's1',
  branchId: 'b1',
  roomId: 'r1',
  roomName: '101',
  transactionId: 't1',
  guestName: 'Aline',
  checkInAt: DateTime.utc(2026, 1, 10, 14),
  expectedCheckOutAt: DateTime.utc(2026, 1, 12, 11),
  nightlyRate: 50000,
  advances: advances,
);

HotelAdvance _advance(
  String id,
  double amount, {
  String method = 'MOBILE MONEY',
  HotelAdvanceStatus status = HotelAdvanceStatus.held,
}) => HotelAdvance(
  id: id,
  amount: amount,
  paymentMethod: method,
  paidAt: DateTime.utc(2026, 1, 5),
  status: status,
);

void main() {
  late _MockSync sync;
  late List<_Movement> movements;
  late HotelStay stored;

  setUpAll(() {
    registerFallbackValue(_advance('fallback', 1));
    registerFallbackValue(<HotelAdvance>[]);
    registerFallbackValue(_stay());
    registerFallbackValue(DateTime.utc(2026));
  });

  setUp(() async {
    await getIt.reset();
    movements = [];
    stored = _stay();
    sync = _MockSync();
    final box = MockBox();
    when(() => box.getBranchId()).thenReturn('b1');
    when(() => box.bhfId()).thenAnswer((_) async => '00');
    when(() => box.isProformaMode()).thenReturn(false);
    when(() => box.isTrainingMode()).thenReturn(false);
    getIt.registerSingleton<LocalStorage>(box);
    final strategy = MockSyncStrategy();
    when(() => strategy.getStrategy(Strategy.capella)).thenReturn(sync);
    when(() => strategy.getStrategy(any())).thenReturn(sync);
    getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');

    when(
      () => sync.completeCashMovement(
        branchId: any(named: 'branchId'),
        bhfId: any(named: 'bhfId'),
        cashReceived: any(named: 'cashReceived'),
        isIncome: any(named: 'isIncome'),
        utilityVariantName: any(named: 'utilityVariantName'),
        paymentType: any(named: 'paymentType'),
        discount: any(named: 'discount'),
        countryCode: any(named: 'countryCode'),
        isProformaMode: any(named: 'isProformaMode'),
        isTrainingMode: any(named: 'isTrainingMode'),
        transactionTypeForRecord: any(named: 'transactionTypeForRecord'),
        categoryId: any(named: 'categoryId'),
        note: any(named: 'note'),
        skipPersonalGoalAutoSweep: any(named: 'skipPersonalGoalAutoSweep'),
        occurredAt: any(named: 'occurredAt'),
        updateShift: any(named: 'updateShift'),
      ),
    ).thenAnswer((inv) async {
      final m = _Movement(inv.namedArguments);
      movements.add(m);
      expect(
        inv.namedArguments[#utilityVariantName],
        m.income ? TransactionType.cashIn : TransactionType.cashOut,
      );
      return ITransaction(
        id: 'cm-${movements.length}',
        agentId: 'c1',
        branchId: 'b1',
        status: COMPLETE,
        transactionType: m.kind,
        paymentType: m.method,
        cashReceived: m.amount,
        customerChangeDue: 0,
        updatedAt: DateTime.utc(2026),
        isIncome: m.income,
        isExpense: !m.income,
      );
    });
    when(
      () => sync.hotelStayById(id: any(named: 'id')),
    ).thenAnswer((_) async => stored);
    when(
      () => sync.saveHotelAdvance(
        stayId: any(named: 'stayId'),
        advance: any(named: 'advance'),
      ),
    ).thenAnswer((inv) async {
      final advance = inv.namedArguments[#advance] as HotelAdvance;
      final list = [...stored.advances];
      final at = list.indexWhere((a) => a.id == advance.id);
      at >= 0 ? list[at] = advance : list.add(advance);
      stored = stored.copyWith(advances: list);
      return stored;
    });
    when(
      () => sync.saveHotelAdvances(
        stayId: any(named: 'stayId'),
        advances: any(named: 'advances'),
      ),
    ).thenAnswer((inv) async {
      final list = [...stored.advances];
      for (final advance
          in inv.namedArguments[#advances] as List<HotelAdvance>) {
        final at = list.indexWhere((a) => a.id == advance.id);
        at >= 0 ? list[at] = advance : list.add(advance);
      }
      stored = stored.copyWith(advances: list);
      return stored;
    });
    when(
      () => sync.hotelStaysStream(branchId: any(named: 'branchId')),
    ).thenAnswer((_) => Stream.value(const <HotelStay>[]));
    when(
      () => sync.hotelRoomsStream(branchId: any(named: 'branchId')),
    ).thenAnswer((_) => Stream.value(const <HotelRoom>[]));
  });

  tearDown(() async => getIt.reset());

  group('settleHeldAdvances', () {
    test('applies the advance under the sale tender, off the drawer', () async {
      stored = _stay(advances: [_advance('a1', 30000), _advance('a2', 10000)]);

      final after = await HotelDeskActions.settleHeldAdvances(
        stay: stored,
        total: 100000,
        tender: 'Cash',
      );

      expect(movements, hasLength(1));
      final m = movements.single;
      expect(m.kind, kBookingAdvanceApplied);
      expect(m.income, isFalse);
      expect(m.amount, 40000);
      expect(m.method, 'Cash');
      expect(m.updateShift, isFalse, reason: 'no money crosses the drawer');
      expect(m.note, 'Room 101 · Aline');
      expect(after.advances.map((a) => a.status), [
        HotelAdvanceStatus.applied,
        HotelAdvanceStatus.applied,
      ]);
      expect(after.advances.map((a) => a.settlementMovementId), [
        'cm-1',
        'cm-1',
      ]);
    });

    test('hands back what the advance exceeds the folio by', () async {
      stored = _stay(
        advances: [_advance('a1', 120000, method: 'DEBIT&CREDIT CARD')],
      );

      await HotelDeskActions.settleHeldAdvances(
        stay: stored,
        total: 100000,
        tender: 'DEBIT&CREDIT CARD',
      );

      expect(movements.map((m) => (m.kind, m.amount, m.updateShift)), [
        (kBookingAdvanceApplied, 100000, false),
        // Back onto the card: no drawer cash moves.
        (kBookingAdvanceRefunded, 20000, false),
      ]);
      expect(movements.last.method, 'DEBIT&CREDIT CARD');
      expect(stored.advanceHeld, 0);
    });

    test(
      'without a tender, each advance is applied in its own method',
      () async {
        stored = _stay(
          advances: [
            _advance('a1', 30000),
            _advance('a2', 10000, method: 'Cash'),
          ],
        );

        await HotelDeskActions.settleHeldAdvances(
          stay: stored,
          total: 100000,
          tender: null,
        );

        expect(movements.map((m) => (m.amount, m.method, m.updateShift)), [
          (30000, 'MOBILE MONEY', false),
          (10000, 'Cash', false),
        ]);
        expect(stored.advances.map((a) => a.settlementMovementId), [
          'cm-1',
          'cm-2',
        ]);
      },
    );

    test('nothing held means nothing written — safe to call again', () async {
      stored = _stay(
        advances: [
          _advance('a1', 30000, status: HotelAdvanceStatus.applied),
          _advance('a2', 5000, status: HotelAdvanceStatus.refunded),
        ],
      );

      await HotelDeskActions.settleHeldAdvances(
        stay: stored,
        total: 100000,
        tender: 'Cash',
      );

      expect(movements, isEmpty);
      verifyNever(
        () => sync.saveHotelAdvance(
          stayId: any(named: 'stayId'),
          advance: any(named: 'advance'),
        ),
      );
      verifyNever(
        () => sync.saveHotelAdvances(
          stayId: any(named: 'stayId'),
          advances: any(named: 'advances'),
        ),
      );
    });

    test('the surplus goes back in the methods it came in by', () async {
      stored = _stay(
        advances: [
          _advance('a1', 90000, method: 'Cash'),
          _advance('a2', 10000, method: 'DEBIT&CREDIT CARD'),
        ],
      );

      await HotelDeskActions.settleHeldAdvances(
        stay: stored,
        total: 20000,
        tender: 'Cash',
      );

      expect(
        movements.map((m) => (m.kind, m.amount, m.method, m.updateShift)),
        [
          (kBookingAdvanceApplied, 20000, 'Cash', false),
          (kBookingAdvanceRefunded, 10000, 'DEBIT&CREDIT CARD', false),
          (kBookingAdvanceRefunded, 70000, 'Cash', true),
        ],
      );
      expect(stored.advances.map((a) => a.status), [
        HotelAdvanceStatus.applied,
        HotelAdvanceStatus.applied,
      ]);
    });

    test('a settlement marks every advance in one write', () async {
      stored = _stay(advances: [_advance('a1', 30000), _advance('a2', 10000)]);

      await HotelDeskActions.settleHeldAdvances(
        stay: stored,
        total: 100000,
        tender: 'Cash',
      );

      verify(
        () => sync.saveHotelAdvances(
          stayId: 's1',
          advances: any(named: 'advances'),
        ),
      ).called(1);
      verifyNever(
        () => sync.saveHotelAdvance(
          stayId: any(named: 'stayId'),
          advance: any(named: 'advance'),
        ),
      );
    });

    test('a free folio refunds the whole advance', () async {
      stored = _stay(advances: [_advance('a1', 30000)]);

      await HotelDeskActions.settleHeldAdvances(
        stay: stored,
        total: 0,
        tender: 'Cash',
      );

      expect(movements.map((m) => (m.kind, m.amount)), [
        (kBookingAdvanceRefunded, 30000),
      ]);
      expect(stored.advances.single.settlementMovementId, 'cm-1');
      expect(stored.advances.single.status, HotelAdvanceStatus.refunded);
    });
  });

  group('refundAdvances', () {
    test('refunds each held advance in its own method, once', () async {
      stored = _stay(
        advances: [
          _advance('a1', 30000),
          _advance('a2', 5000, status: HotelAdvanceStatus.applied),
          _advance('a3', 7000, method: 'Cash'),
        ],
      );

      await HotelDeskActions.refundAdvances(stay: stored);
      await HotelDeskActions.refundAdvances(stay: stored);

      expect(
        movements.map((m) => (m.kind, m.amount, m.method, m.updateShift)),
        [
          // MoMo goes back by MoMo: only the cash one leaves the drawer.
          (kBookingAdvanceRefunded, 30000, 'MOBILE MONEY', false),
          (kBookingAdvanceRefunded, 7000, 'Cash', true),
        ],
      );
      expect(stored.advances.map((a) => a.status), [
        HotelAdvanceStatus.refunded,
        HotelAdvanceStatus.applied,
        HotelAdvanceStatus.refunded,
      ]);
    });
  });

  group('desk actions with a ref', () {
    Future<WidgetRef> pumpRef(WidgetTester tester) async {
      late WidgetRef captured;
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (context, ref, _) {
              captured = ref;
              return const SizedBox();
            },
          ),
        ),
      );
      return captured;
    }

    testWidgets('recording an advance writes a Cash In, then the advance', (
      tester,
    ) async {
      final ref = await pumpRef(tester);

      final updated = await HotelDeskActions.recordAdvance(
        ref: ref,
        stay: stored,
        clerk: Tenant(id: 'c1', name: 'Richie'),
        amount: 25000,
        paymentMethod: 'MOBILE MONEY',
      );

      expect(movements, hasLength(1));
      final m = movements.single;
      expect(m.kind, kBookingAdvance);
      expect(m.income, isTrue);
      expect(m.amount, 25000);
      expect(m.method, 'MOBILE MONEY');
      expect(m.updateShift, isFalse, reason: 'MoMo never reaches the drawer');
      expect(m.skipGoalSweep, isTrue, reason: 'a deposit is not income');
      expect(updated!.advances.single.cashMovementId, 'cm-1');
      expect(updated.advances.single.clerkName, 'Richie');
      expect(updated.advanceHeld, 25000);
      expect(ref.read(hotelModeProvider).toastMessage, contains('25,000'));
    });

    testWidgets('a cash advance counts in the drawer', (tester) async {
      final ref = await pumpRef(tester);
      await HotelDeskActions.recordAdvance(
        ref: ref,
        stay: stored,
        clerk: Tenant(id: 'c1', name: 'Richie'),
        amount: 10000,
        paymentMethod: 'Cash',
      );
      expect(movements.single.updateShift, isTrue);
    });

    testWidgets('no money is taken for a stay closed elsewhere', (
      tester,
    ) async {
      final ref = await pumpRef(tester);
      // Cancelled on another terminal while this sheet was open.
      stored = _stay().copyWith(status: HotelStayStatus.cancelled);

      final updated = await HotelDeskActions.recordAdvance(
        ref: ref,
        stay: _stay(),
        clerk: Tenant(id: 'c1', name: 'Richie'),
        amount: 10000,
        paymentMethod: 'Cash',
      );

      expect(updated, isNull);
      expect(movements, isEmpty);
      expect(
        ref.read(hotelModeProvider).toastMessage,
        contains('already closed'),
      );
    });

    testWidgets('checkout stops when an advance changed since the dialog', (
      tester,
    ) async {
      final ref = await pumpRef(tester);
      final folio = ITransaction(
        id: 't1',
        agentId: 'c1',
        branchId: 'b1',
        status: PARKED,
        transactionType: 'sale',
        paymentType: 'Cash',
        cashReceived: 0,
        customerChangeDue: 0,
        updatedAt: DateTime.utc(2026),
        isIncome: true,
        isExpense: false,
        subTotal: 100000,
      );
      when(
        () => sync.refreshFolioSubTotal(
          transactionId: any(named: 'transactionId'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => sync.hotelFolio(transactionId: any(named: 'transactionId')),
      ).thenAnswer((_) async => folio);
      when(
        () => sync.hotelFolioLines(transactionId: any(named: 'transactionId')),
      ).thenAnswer((_) async => const []);
      // Another terminal took RWF 30,000 while the dialog asked for 100,000.
      stored = _stay(advances: [_advance('a1', 30000)]);

      await expectLater(
        HotelDeskActions.checkOut(
          ref: ref,
          stay: _stay(),
          folio: folio,
          paymentType: 'Cash',
          cashReceived: 100000,
          customerChangeDue: 0,
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('changed on another device'),
          ),
        ),
      );
      expect(movements, isEmpty);
    });

    testWidgets('nothing is recorded for zero', (tester) async {
      final ref = await pumpRef(tester);
      final updated = await HotelDeskActions.recordAdvance(
        ref: ref,
        stay: stored,
        clerk: Tenant(id: 'c1', name: 'Richie'),
        amount: 0,
        paymentMethod: 'Cash',
      );
      expect(updated, isNull);
      expect(movements, isEmpty);
    });

    testWidgets('a failed advance is reported, not thrown', (tester) async {
      final ref = await pumpRef(tester);
      when(
        () => sync.saveHotelAdvance(
          stayId: any(named: 'stayId'),
          advance: any(named: 'advance'),
        ),
      ).thenThrow(StateError('disk full'));

      final updated = await HotelDeskActions.recordAdvance(
        ref: ref,
        stay: stored,
        clerk: Tenant(id: 'c1', name: 'Richie'),
        amount: 5000,
        paymentMethod: 'Cash',
      );

      expect(updated, isNull);
      expect(ref.read(hotelModeProvider).toastMessage, contains('disk full'));
    });

    test('advances follow the checkout type, even after a loan is paid', () {
      ITransaction folio({
        bool isLoan = false,
        DateTime? dueDate,
        String paymentType = 'Cash',
      }) => ITransaction(
        id: 't1',
        agentId: 'c1',
        branchId: 'b1',
        status: COMPLETE,
        transactionType: 'sale',
        paymentType: paymentType,
        cashReceived: 0,
        customerChangeDue: 0,
        updatedAt: DateTime.utc(2026),
        isIncome: true,
        isExpense: false,
        isLoan: isLoan,
        dueDate: dueDate,
        subTotal: 100000,
      );

      expect(HotelDeskActions.advanceTenderFor(folio()), 'Cash');
      expect(
        HotelDeskActions.advanceTenderFor(
          folio(
            isLoan: true,
            dueDate: DateTime.utc(2026, 2),
            paymentType: 'CREDIT',
          ),
        ),
        isNull,
      );
      // Paid off in cash: still a credit checkout, so each advance keeps
      // its own method.
      expect(
        HotelDeskActions.advanceTenderFor(
          folio(dueDate: DateTime.utc(2026, 2)),
        ),
        isNull,
      );
    });

    testWidgets('cancelling refunds the advance before the stay goes', (
      tester,
    ) async {
      final ref = await pumpRef(tester);
      stored = _stay(advances: [_advance('a1', 30000)]);
      final order = <String>[];
      when(() => sync.cancelHotelStay(stay: any(named: 'stay'))).thenAnswer((
        _,
      ) async {
        order.add('cancel:${movements.length}');
      });

      await HotelDeskActions.cancelStay(ref: ref, stay: stored);

      expect(order, ['cancel:1']);
      expect(movements.single.kind, kBookingAdvanceRefunded);
    });

    testWidgets('changing departure reports the new night count', (
      tester,
    ) async {
      final ref = await pumpRef(tester);
      when(
        () => sync.changeHotelStayDeparture(
          stay: any(named: 'stay'),
          checkOutAt: any(named: 'checkOutAt'),
        ),
      ).thenAnswer(
        (_) async =>
            stored.copyWith(expectedCheckOutAt: DateTime.utc(2026, 1, 14, 11)),
      );

      final updated = await HotelDeskActions.changeDeparture(
        ref: ref,
        stay: stored,
        checkOutAt: DateTime.utc(2026, 1, 14, 11),
      );

      expect(updated!.nights, 4);
      expect(ref.read(hotelModeProvider).toastMessage, contains('4 nights'));
    });

    testWidgets('a clash on the new dates is shown, not thrown', (
      tester,
    ) async {
      final ref = await pumpRef(tester);
      when(
        () => sync.changeHotelStayDeparture(
          stay: any(named: 'stay'),
          checkOutAt: any(named: 'checkOutAt'),
        ),
      ).thenThrow(StateError('Room 101 is booked by Bo'));

      final updated = await HotelDeskActions.changeDeparture(
        ref: ref,
        stay: stored,
        checkOutAt: DateTime.utc(2026, 1, 14, 11),
      );

      expect(updated, isNull);
      expect(
        ref.read(hotelModeProvider).toastMessage,
        'Room 101 is booked by Bo',
      );
    });
  });
}
