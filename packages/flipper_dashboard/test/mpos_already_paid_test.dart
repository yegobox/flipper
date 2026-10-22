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

  group('mposSaveSplitForCharge', () {
    List<Payment> split() => [
      Payment(
        amount: 2000,
        method: 'CASH',
        controller: TextEditingController(text: '2000'),
      ),
      Payment(
        amount: 600,
        method: 'MOBILE MONEY',
        controller: TextEditingController(text: '600'),
      ),
    ];
    List<(String, double)> rows(List<Payment> l) => [
      for (final p in l) (p.method, p.amount),
    ];

    test('a failed charge puts the split back, so the retry shows change', () {
      final payments = split();
      var lines = payments;
      final putBack = mposSaveSplitForCharge(
        payments: payments,
        owed: 1600,
        readLines: () => lines,
        writeLines: (next) => lines = next,
      );
      // Charge saves the cash net of change.
      expect(rows(lines), [('CASH', 1000.0), ('MOBILE MONEY', 600.0)]);
      expect(mposCheckoutTender(lines, 1600).change, isNull);

      putBack!();
      expect(rows(lines), [('CASH', 2000.0), ('MOBILE MONEY', 600.0)]);
      expect([for (final p in lines) p.controller.text], ['2000', '600']);
      expect(mposCheckoutTender(lines, 1600).change, 1000.0);
    });

    test('an all-change cash row comes back too', () {
      final payments = [
        Payment(amount: 400, method: 'CASH'),
        Payment(amount: 1600, method: 'MOBILE MONEY'),
      ];
      var lines = payments;
      final putBack = mposSaveSplitForCharge(
        payments: payments,
        owed: 1600,
        readLines: () => lines,
        writeLines: (next) => lines = next,
      );
      expect(rows(lines), [('MOBILE MONEY', 1600.0)]);
      putBack!();
      expect(rows(lines), [('CASH', 400.0), ('MOBILE MONEY', 1600.0)]);
    });

    test('lines a completed sale reset are left alone', () {
      var lines = split();
      final putBack = mposSaveSplitForCharge(
        payments: lines,
        owed: 1600,
        readLines: () => lines,
        writeLines: (next) => lines = next,
      );
      final fresh = [Payment(amount: 0, method: 'CASH')];
      lines = fresh;
      putBack!();
      expect(identical(lines, fresh), isTrue);
    });

    test('one line is not a split: nothing is rewritten', () {
      var writes = 0;
      final putBack = mposSaveSplitForCharge(
        payments: [Payment(amount: 2000, method: 'CASH')],
        owed: 1600,
        readLines: () => const [],
        writeLines: (_) => writes++,
      );
      expect((putBack, writes), (null, 0));
    });
  });

  group('mposChargedCash', () {
    test('change is measured against what was still owed', () {
      // 500 already paid on a 1,600 ticket: 2,000 handed over for 1,100.
      final r = mposChargedCash([
        Payment(
          amount: 2000,
          method: 'CASH',
          controller: TextEditingController(text: '2000'),
        ),
      ], 1100);
      expect((r.tendered, r.change), (2000.0, 900.0));
    });

    test('exact cash with nothing typed gives no change', () {
      final r = mposChargedCash([
        Payment(
          amount: 1100,
          method: 'CASH',
          controller: TextEditingController(text: '0.00'),
        ),
      ], 1100);
      expect((r.tendered, r.change), (1100.0, 0.0));
    });

    test('a split shows its change; MoMo alone shows none', () {
      final r = mposChargedCash([
        Payment(amount: 2000, method: 'CASH'),
        Payment(amount: 600, method: 'MOBILE MONEY'),
      ], 1600);
      expect((r.tendered, r.change), (2600.0, 1000.0));
      final momo = mposChargedCash([
        Payment(amount: 1600, method: 'MOBILE MONEY'),
      ], 1600);
      expect((momo.tendered, momo.change), (null, null));
    });
  });

  test('a split MoMo row asks for a phone only once it carries money', () {
    expect(
      mposHasMomoTender([Payment(amount: 0, method: 'MOBILE MONEY')]),
      isTrue,
    );
    expect(
      mposHasMomoTender([
        Payment(amount: 1600, method: 'CASH'),
        Payment(amount: 0, method: 'MOBILE MONEY'),
      ]),
      isFalse,
    );
    expect(
      mposHasMomoTender([
        Payment(amount: 1000, method: 'CASH'),
        Payment(amount: 600, method: 'MTN MOMO'),
      ]),
      isTrue,
    );
  });
}
