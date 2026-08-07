import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:test/test.dart';

void main() {
  group('deriveSaleCompletionState', () {
    test('full cash sale completes when tender equals total', () {
      final d = deriveSaleCompletionState(
        transactionCashReceived: 100,
        finalSubTotal: 100,
        paymentMethods: const [
          PaymentLineForSaleCompletion(amount: 100, method: 'CASH'),
        ],
      );
      expect(d.shouldBeLoan, false);
      expect(d.status, saleCompletionStatusComplete);
      expect(d.remainingBalance, 0.0);
    });

    test('credit line parks sale', () {
      final d = deriveSaleCompletionState(
        transactionCashReceived: 0,
        finalSubTotal: 100,
        paymentMethods: const [
          PaymentLineForSaleCompletion(amount: 100, method: 'CREDIT'),
        ],
      );
      expect(d.shouldBeLoan, true);
      expect(d.status, saleCompletionStatusParked);
      expect(d.totalCredit, 100);
    });

    test('underpay parks with remaining balance', () {
      final d = deriveSaleCompletionState(
        transactionCashReceived: 50,
        finalSubTotal: 100,
        paymentMethods: const [
          PaymentLineForSaleCompletion(amount: 50, method: 'CASH'),
        ],
      );
      expect(d.shouldBeLoan, true);
      expect(d.status, saleCompletionStatusParked);
      expect(d.remainingBalance, closeTo(50.0, 0.001));
    });

    test('when cashReceived is zero uses split payment sum', () {
      final d = deriveSaleCompletionState(
        transactionCashReceived: 0,
        finalSubTotal: 100,
        paymentMethods: const [
          PaymentLineForSaleCompletion(amount: 60, method: 'CASH'),
          PaymentLineForSaleCompletion(amount: 40, method: 'MOMO'),
        ],
      );
      expect(d.shouldBeLoan, false);
      expect(d.status, saleCompletionStatusComplete);
    });

    test('stale in-memory cashReceived yields to lower payment rows', () {
      final d = deriveSaleCompletionState(
        transactionCashReceived: 100,
        finalSubTotal: 100,
        paymentMethods: const [
          PaymentLineForSaleCompletion(amount: 40, method: 'CASH'),
        ],
      );
      expect(d.shouldBeLoan, true);
      expect(d.status, saleCompletionStatusParked);
      expect(d.remainingBalance, closeTo(60.0, 0.001));
    });

    test('unknown tender does not assume full payment', () {
      final d = deriveSaleCompletionState(
        transactionCashReceived: 0,
        finalSubTotal: 100,
        paymentMethods: const [],
      );
      expect(d.shouldBeLoan, true);
      expect(d.status, saleCompletionStatusParked);
      expect(d.remainingBalance, closeTo(100.0, 0.001));
    });

    test('resumed loan installment that clears balance completes', () {
      // Ticket 708, prior paid 8, cashier tenders remaining 700.
      final d = deriveSaleCompletionState(
        transactionCashReceived: 8,
        finalSubTotal: 708,
        paymentMethods: const [
          PaymentLineForSaleCompletion(amount: 700, method: 'CASH'),
        ],
        priorAlreadyPaidNonCredit: 8,
      );
      expect(d.shouldBeLoan, false);
      expect(d.status, saleCompletionStatusComplete);
      expect(d.remainingBalance, 0.0);
      // cashReceived persisted on the ticket must be cumulative.
      expect(d.nonCreditCashReceived, closeTo(708.0, 0.001));
    });

    test('resumed loan with cumulative cashReceived still completes', () {
      // collectPayment may have already summed prior+tender in memory (8+700)
      // before markTransactionAsCompleted runs.
      final d = deriveSaleCompletionState(
        transactionCashReceived: 708,
        finalSubTotal: 708,
        paymentMethods: const [
          PaymentLineForSaleCompletion(amount: 700, method: 'CASH'),
        ],
        priorAlreadyPaidNonCredit: 8,
      );
      expect(d.shouldBeLoan, false);
      expect(d.status, saleCompletionStatusComplete);
      expect(d.remainingBalance, 0.0);
      expect(d.nonCreditCashReceived, closeTo(708.0, 0.001));
    });

    test('partial resumed installment parks with remaining balance', () {
      final d = deriveSaleCompletionState(
        transactionCashReceived: 8,
        finalSubTotal: 708,
        paymentMethods: const [
          PaymentLineForSaleCompletion(amount: 100, method: 'CASH'),
        ],
        priorAlreadyPaidNonCredit: 8,
      );
      expect(d.shouldBeLoan, true);
      expect(d.status, saleCompletionStatusParked);
      expect(d.remainingBalance, closeTo(600.0, 0.001));
      expect(d.nonCreditCashReceived, closeTo(108.0, 0.001));
    });
  });

  group('normalizePaymentLinesToSaleTotal', () {
    test('scales non-credit rows down when sum exceeds sale total', () {
      final normalized = normalizePaymentLinesToSaleTotal(
        paymentMethods: const [
          PaymentLineForSaleCompletion(amount: 60, method: 'CASH'),
          PaymentLineForSaleCompletion(amount: 60, method: 'MOMO'),
        ],
        saleTotal: 100,
        shouldBeLoan: false,
      );
      final sum = normalized.fold<double>(0, (s, p) => s + p.amount);
      expect(sum, closeTo(100.0, 0.02));
      expect(normalized.length, 2);
    });

    test('leaves credit rows untouched when scaling', () {
      final normalized = normalizePaymentLinesToSaleTotal(
        paymentMethods: const [
          PaymentLineForSaleCompletion(amount: 50, method: 'CASH'),
          PaymentLineForSaleCompletion(amount: 50, method: 'CREDIT'),
        ],
        saleTotal: 40,
        shouldBeLoan: false,
      );
      final credit = normalized.firstWhere((p) => p.method == 'CREDIT');
      expect(credit.amount, 50);
      final cash = normalized.firstWhere((p) => p.method == 'CASH');
      expect(cash.amount, closeTo(40.0, 0.02));
    });
  });

  group('saleLineQtyByVariantId', () {
    SaleCartQtyRow row(String variantId, num qty, {bool? active}) => (
      variantId: variantId,
      qty: qty,
      active: active,
    );

    test('skips inactive rows', () {
      final map = saleLineQtyByVariantId([
        row('a', 2, active: false),
        row('b', 1),
      ]);
      expect(map, {'b': 1});
    });

    test('sums qty per variant', () {
      final map = saleLineQtyByVariantId([
        row('a', 2),
        row('a', 1),
        row('b', 3),
      ]);
      expect(map, {'a': 3, 'b': 3});
    });
  });

  group('saleLineQtyMapsMatch', () {
    test('matches identical maps', () {
      expect(
        saleLineQtyMapsMatch({'a': 2, 'b': 1}, {'a': 2, 'b': 1}),
        isTrue,
      );
    });

    test('rejects missing variant', () {
      expect(
        saleLineQtyMapsMatch({'a': 1, 'b': 1}, {'a': 1}),
        isFalse,
      );
    });

    test('rejects qty drift', () {
      expect(
        saleLineQtyMapsMatch({'a': 3}, {'a': 2}),
        isFalse,
      );
    });
  });

  group('applyTicketReviewWorkflowRedirect', () {
    test('passthrough when workflow disabled', () {
      expect(
        applyTicketReviewWorkflowRedirect(
          derivedStatus: saleCompletionStatusComplete,
          ticketReviewWorkflowEnabled: false,
        ),
        saleCompletionStatusComplete,
      );
    });

    test('redirects completed to pendingReview when enabled', () {
      expect(
        applyTicketReviewWorkflowRedirect(
          derivedStatus: saleCompletionStatusComplete,
          ticketReviewWorkflowEnabled: true,
        ),
        saleCompletionStatusPendingReview,
      );
    });

    test('never redirects parked/loan outcomes even when enabled', () {
      expect(
        applyTicketReviewWorkflowRedirect(
          derivedStatus: saleCompletionStatusParked,
          ticketReviewWorkflowEnabled: true,
        ),
        saleCompletionStatusParked,
      );
    });
  });

  group('isFinanciallySettledSaleStatus', () {
    test('recognizes completed, pendingReview, and awaitingHandover', () {
      expect(
        isFinanciallySettledSaleStatus(saleCompletionStatusComplete),
        isTrue,
      );
      expect(
        isFinanciallySettledSaleStatus(saleCompletionStatusPendingReview),
        isTrue,
      );
      expect(
        isFinanciallySettledSaleStatus(saleCompletionStatusAwaitingHandover),
        isTrue,
      );
    });

    test('rejects parked and null', () {
      expect(
        isFinanciallySettledSaleStatus(saleCompletionStatusParked),
        isFalse,
      );
      expect(isFinanciallySettledSaleStatus(null), isFalse);
    });
  });

  group('posSettlementCreatedAtStamp', () {
    // The shared pending cart is minted when the previous sale finishes, so its
    // createdAt is yesterday's last sale for the first sale of a new day.
    final yesterdayCart = DateTime(2026, 8, 6, 18, 30);
    final settledNow = DateTime(2026, 8, 7, 9, 15);

    test('re-stamps the sale date when the cart leaves pending', () {
      expect(
        posSettlementCreatedAtStamp(
          priorStatus: saleCompletionStatusPending,
          newStatus: saleCompletionStatusComplete,
          settledAt: settledNow,
        ),
        settledNow,
      );
    });

    test('re-stamps for parked, pendingReview and awaitingHandover too', () {
      for (final status in [
        saleCompletionStatusParked,
        saleCompletionStatusPendingReview,
        saleCompletionStatusAwaitingHandover,
      ]) {
        expect(
          posSettlementCreatedAtStamp(
            priorStatus: saleCompletionStatusPending,
            newStatus: status,
            settledAt: settledNow,
          ),
          settledNow,
          reason: 'leaving the pending cart for $status owns the report date',
        );
      }
    });

    test('preserves the sale date on later writes (refund, counters, RRA)', () {
      // Prior row is already settled — createdAt must not move.
      expect(
        posSettlementCreatedAtStamp(
          priorStatus: saleCompletionStatusComplete,
          newStatus: saleCompletionStatusComplete,
          settledAt: settledNow,
        ),
        isNull,
      );
      expect(
        posSettlementCreatedAtStamp(
          priorStatus: saleCompletionStatusParked,
          newStatus: saleCompletionStatusComplete,
          settledAt: settledNow,
        ),
        isNull,
      );
    });

    test('does not stamp when the row stays a pending cart', () {
      // e.g. resumeSaleTicketFast (parked → pending) and cart edits.
      expect(
        posSettlementCreatedAtStamp(
          priorStatus: saleCompletionStatusPending,
          newStatus: saleCompletionStatusPending,
          settledAt: settledNow,
        ),
        isNull,
      );
      expect(
        posSettlementCreatedAtStamp(
          priorStatus: saleCompletionStatusPending,
          newStatus: null,
          settledAt: settledNow,
        ),
        isNull,
      );
    });

    test('normalizes a UTC settlement time to local', () {
      // Report windows are local wall-clock strings with no `Z`, compared
      // lexicographically — a UTC stamp would file the sale in the wrong day.
      final stamp = posSettlementCreatedAtStamp(
        priorStatus: saleCompletionStatusPending,
        newStatus: saleCompletionStatusComplete,
        settledAt: settledNow.toUtc(),
      );
      expect(stamp!.isUtc, isFalse);
      expect(stamp, settledNow);
      expect(stamp.toIso8601String(), isNot(endsWith('Z')));
    });

    test("the stale cart date is never what lands on the sale", () {
      final stamp = posSettlementCreatedAtStamp(
        priorStatus: saleCompletionStatusPending,
        newStatus: saleCompletionStatusComplete,
        settledAt: settledNow,
      );
      expect(stamp, isNot(yesterdayCart));
      expect(stamp!.day, 7, reason: 'sold on the 7th, not the cart-mint day');
    });
  });
}
