import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'dart:async';

import 'package:flipper_models/sync/capella/mixins/transaction_item_mixin.dart'
    show mergeTransactionItemsById;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardGaugeSnapshot', () {
    test('a day with only a cash-out still has expenses to show', () {
      const snap = DashboardGaugeSnapshot(grossProfit: 0, deductions: 5000);
      expect(snap.isEmpty, isTrue, reason: 'no sales yet');
      expect(snap.hasDeductions, isTrue);
      expect(snap.hasActivity, isTrue);
      expect(snap.netProfit, -5000);
    });

    test('an empty day shows nothing', () {
      const snap = DashboardGaugeSnapshot(grossProfit: 0, deductions: 0);
      expect(snap.hasRevenue, isFalse);
      expect(snap.hasDeductions, isFalse);
      expect(snap.hasActivity, isFalse);
    });

    test('sales count as activity and revenue', () {
      const snap = DashboardGaugeSnapshot(
        grossProfit: 400,
        deductions: 0,
        revenue: 1000,
        transactionCount: 1,
      );
      expect(snap.hasRevenue, isTrue);
      expect(snap.hasActivity, isTrue);
      expect(snap.hasDeductions, isFalse);
    });
  });

  group('isBookingAdvanceTransaction', () {
    ITransaction tx(String? type, String? receipt, {String? categoryId}) =>
        ITransaction(
          id: 't',
          agentId: 'a',
          branchId: 'b',
          status: 'completed',
          transactionType: type,
          receiptType: receipt,
          paymentType: 'Cash',
          cashReceived: 0,
          customerChangeDue: 0,
          updatedAt: DateTime(2026),
          isIncome: receipt == 'Cash In',
          isExpense: receipt == 'Cash Out',
          categoryId: categoryId,
        );

    test('a hotel advance is kept out of revenue and expenses', () {
      expect(
        isBookingAdvanceTransaction(tx('Booking advance', 'Cash In')),
        isTrue,
      );
      expect(
        isBookingAdvanceTransaction(tx('Booking advance applied', 'Cash Out')),
        isTrue,
      );
    });

    test('other movements and sales still count', () {
      expect(
        isBookingAdvanceTransaction(tx('Owner deposit', 'Cash In')),
        isFalse,
      );
      expect(isBookingAdvanceTransaction(tx('Rent', 'Cash Out')), isFalse);
      expect(isBookingAdvanceTransaction(tx('Sale', 'NS')), isFalse);
      // The owner's own "Booking advance" category is ordinary Cash In.
      expect(
        isBookingAdvanceTransaction(
          tx('Booking advance', 'Cash In', categoryId: 'cat-1'),
        ),
        isFalse,
      );
    });
  });

  group('dashboardGaugeSnapshotFrom', () {
    ITransaction tx(
      String id, {
      String status = 'completed',
      bool expense = false,
      double subTotal = 0,
      String? type,
      String? receipt,
    }) => ITransaction(
      id: id,
      agentId: 'a',
      branchId: 'b',
      status: status,
      transactionType: type,
      receiptType: receipt ?? (expense ? 'Cash Out' : 'NS'),
      paymentType: 'Cash',
      cashReceived: 0,
      customerChangeDue: 0,
      updatedAt: DateTime(2026),
      isIncome: !expense,
      isExpense: expense,
      subTotal: subTotal,
    );

    TransactionItem line(String transactionId, {double price = 1000}) =>
        TransactionItem(
          name: 'Item',
          qty: 1,
          price: price,
          discount: 0,
          prc: price,
          ttCatCd: 'B',
          transactionId: transactionId,
        );

    test('only lines of completed sales count; expenses add up', () {
      final all = [
        tx('sale', subTotal: 1000),
        tx('pending', status: 'pending', subTotal: 500),
        tx('rent', expense: true, subTotal: 300),
        tx(
          'advance',
          type: 'Booking advance',
          receipt: 'Cash In',
          subTotal: 9000,
        ),
      ];
      final sales = dashboardGaugeSales(all);
      final expenses = dashboardGaugeExpenses(all);
      final counted = line('sale');
      final snap = dashboardGaugeSnapshotFrom(
        items: [counted, line('pending'), line('advance'), line('unknown')],
        sales: sales,
        expenses: expenses,
      );

      expect(sales.map((t) => t.id), ['sale']);
      expect(expenses.map((t) => t.id), ['rent']);
      expect(snap.transactionCount, 1);
      expect(snap.revenue, 1000);
      expect(snap.grossProfit, TransactionItemPluMetrics.profitMade(counted));
      expect(
        snap.deductions,
        TransactionItemPluMetrics.taxPayable(counted) + 300,
      );
    });

    test('no sales and no expenses is an empty gauge', () {
      final snap = dashboardGaugeSnapshotFrom(
        items: [line('x')],
        sales: const [],
        expenses: const [],
      );
      expect(snap.hasActivity, isFalse);
      expect(snap.grossProfit, 0);
    });
  });

  test('line items are re-read for a new sale, not for a cart edit', () async {
    ITransaction sale(String id, double subTotal) => ITransaction(
      id: id,
      agentId: 'a',
      branchId: 'b',
      status: 'completed',
      paymentType: 'Cash',
      cashReceived: 0,
      customerChangeDue: 0,
      updatedAt: DateTime(2026),
      transactionType: 'Sale',
      isIncome: true,
      isExpense: false,
      subTotal: subTotal,
    );
    final sales = StreamController<List<ITransaction>>();
    var refreshes = 0;
    final sub = dashboardGaugeLineRefreshes(
      sales.stream,
      window: const Duration(milliseconds: 20),
    ).listen((_) => refreshes++);

    sales.add([sale('s1', 100)]);
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(refreshes, 1, reason: 'first load');

    // Same completed sales, e.g. a cart tap that moved another document.
    sales.add([sale('s1', 100)]);
    sales.add([sale('s1', 100)]);
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(refreshes, 1);

    sales.add([sale('s1', 100), sale('s2', 50)]);
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(refreshes, 2, reason: 'a new completed sale');

    await sub.cancel();
    await sales.close();
  });

  group('dashboardGaugeLinesWithRetry', () {
    TransactionItem line(String tid) => TransactionItem(
      name: 'Item',
      qty: 1,
      price: 100,
      discount: 0,
      prc: 100,
      ttCatCd: 'B',
      transactionId: tid,
    );
    Duration noWait(int _) => Duration.zero;

    test(
      'a failed read emits nothing (keeps the last lines) and retries',
      () async {
        var calls = 0;
        final out = await dashboardGaugeLinesWithRetry(
          fetch: () async => ++calls < 3 ? null : [line('s1')],
          saleIds: {'s1'},
          backoff: noWait,
        ).toList();
        expect(calls, 3);
        expect(out, hasLength(1));
        expect(out.single.single.transactionId, 's1');
      },
    );

    test('a sale whose lines have not synced yet is read again', () async {
      var calls = 0;
      final out = await dashboardGaugeLinesWithRetry(
        fetch: () async =>
            ++calls == 1 ? [line('s1')] : [line('s1'), line('s2')],
        saleIds: {'s1', 's2'},
        backoff: noWait,
      ).toList();
      expect(calls, 2);
      expect(out.map((l) => l.length), [
        1,
        2,
      ], reason: 'partial shown, then full');
    });

    test('recovers after the fifth failure with no new sale', () async {
      var calls = 0;
      final out = await dashboardGaugeLinesWithRetry(
        fetch: () async => ++calls <= 5 ? null : [line('s1')],
        saleIds: {'s1'},
        backoff: noWait,
      ).toList();
      expect(calls, 6, reason: 'no attempt limit by default');
      expect(out.single.single.transactionId, 's1');
    });

    test('mergeTransactionItemsById keeps one copy per line', () {
      TransactionItem withId(String id, String tid) => TransactionItem(
        id: id,
        name: 'Item',
        qty: 1,
        price: 100,
        discount: 0,
        prc: 100,
        ttCatCd: 'B',
        transactionId: tid,
      );
      final merged = mergeTransactionItemsById(
        [withId('a', 's1'), withId('b', 's1')],
        [withId('b', 's1'), withId('c', 's1')],
      );
      expect(merged.map((i) => i.id), ['a', 'b', 'c']);
    });

    test('gives up after the last attempt', () async {
      var calls = 0;
      final out = await dashboardGaugeLinesWithRetry(
        fetch: () async {
          calls++;
          return null;
        },
        saleIds: {'s1'},
        maxAttempts: 3,
        backoff: noWait,
      ).toList();
      expect(calls, 3);
      expect(out, isEmpty);
    });

    test('a complete first read stops at once', () async {
      var calls = 0;
      await dashboardGaugeLinesWithRetry(
        fetch: () async {
          calls++;
          return [line('s1')];
        },
        saleIds: {'s1'},
        backoff: noWait,
      ).toList();
      expect(calls, 1);
    });
  });

  group('dashboardPreviousPeriodTransactions', () {
    final sale = ITransaction(
      id: 'prev-1',
      agentId: 'a',
      branchId: 'b',
      status: 'completed',
      paymentType: 'Cash',
      cashReceived: 0,
      customerChangeDue: 0,
      updatedAt: DateTime(2026),
      transactionType: 'Sale',
      isIncome: true,
      isExpense: false,
      subTotal: 100,
    );

    test('returns the first result from a ready store', () async {
      final all = await dashboardPreviousPeriodTransactions(
        storeReady: true,
        read: () => Stream.value([sale]),
      );
      expect(all.single.id, 'prev-1');
    });

    test('a quiet period is still an empty list, not a failure', () async {
      final all = await dashboardPreviousPeriodTransactions(
        storeReady: true,
        read: () => Stream.value(const <ITransaction>[]),
      );
      expect(all, isEmpty);
    });

    test('fails, without reading, before the store is up', () async {
      var reads = 0;
      await expectLater(
        dashboardPreviousPeriodTransactions(
          storeReady: false,
          read: () {
            reads++;
            return Stream.value(const <ITransaction>[]);
          },
        ),
        throwsA(isA<DashboardPreviousPeriodUnavailable>()),
      );
      expect(reads, 0);
    });

    test('fails on timeout and cancels the read', () async {
      var cancelled = false;
      final never = StreamController<List<ITransaction>>(
        onCancel: () => cancelled = true,
      );
      await expectLater(
        dashboardPreviousPeriodTransactions(
          storeReady: true,
          read: () => never.stream,
          timeout: const Duration(milliseconds: 20),
        ),
        throwsA(isA<DashboardPreviousPeriodUnavailable>()),
      );
      expect(cancelled, isTrue);
    });

    test('fails when the read closes with no result', () async {
      await expectLater(
        dashboardPreviousPeriodTransactions(
          storeReady: true,
          read: () => const Stream<List<ITransaction>>.empty(),
        ),
        throwsA(isA<DashboardPreviousPeriodUnavailable>()),
      );
    });

    test('the failure is an Exception, so Riverpod retries it', () {
      expect(const DashboardPreviousPeriodUnavailable('x'), isA<Exception>());
    });
  });
}
