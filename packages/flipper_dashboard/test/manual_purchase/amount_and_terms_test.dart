import 'package:flipper_dashboard/manual_purchase/amount_input.dart';
import 'package:flipper_dashboard/manual_purchase/manual_purchase_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseAmount', () {
    test('decimal comma', () {
      expect(parseAmount('2,5'), 2.5);
      expect(parseAmount('0,75'), 0.75);
    });

    test('thousands separators', () {
      expect(parseAmount('2,500'), 2500);
      expect(parseAmount('12,500,000'), 12500000);
      expect(parseAmount('1,250.75'), 1250.75);
    });

    test('plain numbers, spaces and junk', () {
      expect(parseAmount(' 29500 '), 29500);
      expect(parseAmount('1 000'), 1000);
      expect(parseAmount(''), 0);
      expect(parseAmount('abc'), 0);
    });

    test('edit format keeps full precision and round-trips', () {
      expect(formatAmountForEdit(2.125), '2.125');
      expect(formatAmountForEdit(29500), '29500');
      expect(parseAmount(formatAmountForEdit(1234.5678)), 1234.5678);
    });
  });

  group('credit terms', () {
    test('default due date follows the purchase date', () {
      final n = ManualPurchaseNotifier();
      addTearDown(n.dispose);
      n.setPurchaseDate(DateTime(2026, 9, 1));
      n.setPaymentType('02');
      expect(n.state.effectiveDueDate, DateTime(2026, 10, 1));
      n.setPurchaseDate(DateTime(2026, 9, 10));
      expect(n.state.effectiveDueDate, DateTime(2026, 10, 10));
    });

    test('a picked due date stays, unless it falls before the purchase', () {
      final n = ManualPurchaseNotifier();
      addTearDown(n.dispose);
      n.setPurchaseDate(DateTime(2026, 9, 1));
      n.setPaymentType('02');
      n.setDueDate(DateTime(2026, 9, 20));
      n.setPurchaseDate(DateTime(2026, 9, 5));
      expect(n.state.effectiveDueDate, DateTime(2026, 9, 20));
      n.setPurchaseDate(DateTime(2026, 9, 25));
      expect(n.state.effectiveDueDate, DateTime(2026, 10, 25));
    });

    test('switching to cash drops credit terms', () {
      final n = ManualPurchaseNotifier();
      addTearDown(n.dispose);
      n.setPaymentType('03');
      n.setPaidUpfront(500);
      n.setDueDate(DateTime(2030));
      n.setPaymentType('01');
      expect(n.state.dueDate, isNull);
      expect(n.state.paidUpfront, 0);
      expect(n.state.isOnCredit, isFalse);
    });

    test('typing an invoice number marks it as the owner\'s', () {
      final n = ManualPurchaseNotifier();
      addTearDown(n.dispose);
      n.setInvoiceNo('77');
      expect(n.state.invoiceAutoFilled, isFalse);
    });
  });
}
