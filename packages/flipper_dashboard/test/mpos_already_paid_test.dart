import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_dashboard/utils/split_tender.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ITransaction _ticket({bool loan = false, double cashReceived = 0}) =>
    ITransaction(
      id: 't1',
      branchId: 'b1',
      status: PENDING,
      transactionType: 'sale',
      paymentType: 'CASH',
      cashReceived: cashReceived,
      customerChangeDue: 0,
      updatedAt: DateTime.utc(2026, 1, 1),
      isIncome: true,
      isExpense: false,
      isLoan: loan,
      agentId: 'agent-test',
      subTotal: 1000,
    );

void main() {
  test('an unread payment counts as nothing paid outside loans', () {
    expect(mposAlreadyPaid(_ticket(cashReceived: 400), null), 0);
  });

  test('a loan never drops below what was already received', () {
    final loan = _ticket(loan: true, cashReceived: 400);
    expect(mposAlreadyPaid(loan, null), 400);
    expect(mposAlreadyPaid(loan, 250), 400);
    expect(mposAlreadyPaid(loan, 600), 600);
  });

  group('MposPaidRead', () {
    test('a read that started before a charge cannot land after it', () {
      final read = MposPaidRead();
      final preCharge = read.start();
      read.invalidate(); // the charge starts while that read is in flight
      expect(read.isCurrent(preCharge), isFalse);
      expect(read.txnId, isNull);
    });

    test('only the newest read may set the cart', () {
      final read = MposPaidRead();
      final first = read.start();
      final second = read.start();
      expect(read.isCurrent(first), isFalse);
      expect(read.isCurrent(second), isTrue);
    });
  });

  group('mposCashChangeAndDue', () {
    test('exact cash gives no change, even though nothing was typed', () {
      final r = mposCashChangeAndDue(tender: 1600, outstanding: 1600);
      expect((r.change, r.due), (null, null));
    });

    test('change is what was handed over beyond the bill', () {
      final r = mposCashChangeAndDue(tender: 2000, outstanding: 1600);
      expect((r.change, r.due), (400.0, null));
    });

    test('a short tender leaves the rest due', () {
      final r = mposCashChangeAndDue(tender: 1000, outstanding: 1600);
      expect((r.change, r.due), (null, 600.0));
    });
  });

  group('mposCheckoutTender', () {
    test('the screenshot case: exact cash pre-filled, field shows 0.00', () {
      final pay = mposCheckoutTender([
        Payment(
          amount: 1600,
          method: 'CASH',
          controller: TextEditingController(text: '0.00'),
        ),
      ], 1600);
      expect((pay.change, pay.due, pay.tenderOk), (null, null, true));
    });

    test('a split decides change, balance due and readiness', () {
      final ready = mposCheckoutTender([
        Payment(amount: 1000, method: 'CASH'),
        Payment(amount: 600, method: 'MOBILE MONEY'),
      ], 1600);
      expect((ready.isCash, ready.change, ready.tenderOk), (false, null, true));

      final short = mposCheckoutTender([
        Payment(amount: 500, method: 'CASH'),
        Payment(amount: 600, method: 'MOBILE MONEY'),
      ], 1600);
      expect((short.due, short.tenderOk), (500.0, false));
    });
  });

  test('a split is saved net of change, one line per tender', () {
    final payments = [
      Payment(amount: 1500, method: 'CASH'),
      Payment(amount: 600, method: 'MOBILE MONEY'),
    ];
    final split = splitSummary(mposSplitTenders(payments), 1600);
    final saved = mposSplitSavedLines(payments, split);
    expect(
      [for (final p in saved) (p.method, p.amount)],
      [('CASH', 1000.0), ('MOBILE MONEY', 600.0)],
    );
    expect(saved.first.id, payments.first.id);
  });
}
