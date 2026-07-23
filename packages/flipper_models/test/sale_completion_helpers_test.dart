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
}
