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
}
