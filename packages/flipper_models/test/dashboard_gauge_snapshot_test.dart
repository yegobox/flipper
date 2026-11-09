import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
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
}
