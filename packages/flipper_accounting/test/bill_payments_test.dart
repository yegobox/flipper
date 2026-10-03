import 'package:flipper_accounting/bill_payments.dart';
import 'package:flipper_accounting/default_chart_of_accounts_seed.dart';
import 'package:flipper_accounting/purchase_journal_poster.dart';
import 'package:flipper_accounting/purchase_posting_input.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_accounting_store.dart';

const _biz = 'biz';
final _billId = PurchaseJournalPoster.billDocId(_biz, 'BILL-42');

PurchasePostingInput _purchase(
  String pmtTyCd, {
  double? paidUpfront,
  DateTime? dueDate,
}) => PurchasePostingInput(
  purchaseId: 'p1',
  supplierName: 'Kigali Wholesale',
  invoiceNo: 42,
  pmtTyCd: pmtTyCd,
  totAmt: 118000,
  totTaxAmt: 18000,
  purchaseDate: DateTime(2026, 10, 1),
  paidUpfront: paidUpfront,
  dueDate: dueDate,
  lines: const [
    PurchasePostingLine(description: 'Rice 25kg', qty: 4, unitPrice: 29500),
  ],
);

Future<InMemoryAccountingStore> _record(
  PurchasePostingInput purchase, {
  bool postToLedger = true,
  InMemoryAccountingStore? store,
}) async {
  final s = store ?? InMemoryAccountingStore();
  await PurchaseJournalPoster(s).postPurchaseRecorded(
    businessId: _biz,
    purchase: purchase,
    accounts: defaultChartOfAccountsSeed,
    postToLedger: postToLedger,
  );
  return s;
}

Future<BillBalance> _pay(
  InMemoryAccountingStore store,
  int amount, {
  String account = '1010',
  String? paymentId,
}) => BillPaymentPoster(store).recordPayment(
  businessId: _biz,
  billDocId: _billId,
  amount: amount,
  paymentAccount: account,
  accounts: defaultChartOfAccountsSeed,
  paymentId: paymentId,
);

void main() {
  final purchaseJe = PurchaseJournalPoster.entryId(_biz, 'p1');

  group('BillBalance', () {
    test('balance is total less upfront and later payments', () {
      final b = BillBalance.from(
        total: 100,
        paidUpfront: 30,
        payments: [
          BillPayment(
            id: 'a',
            businessId: _biz,
            billDocId: 'x',
            amount: 20,
            accountCode: '1010',
            paidAt: DateTime(2026),
          ),
        ],
      );
      expect(b.amountPaid, 50);
      expect(b.balance, 50);
      expect(b.storedStatus, 'sent');
    });

    test('overpayment settles the bill without a negative balance', () {
      final b = BillBalance(total: 100, paidLater: 130);
      expect(b.balance, 0);
      expect(b.isSettled, isTrue);
      expect(b.storedStatus, 'paid');
    });
  });

  group('PurchaseJournalPoster payment types', () {
    test(
      'cash purchase writes a settled bill and credits cash, not AP',
      () async {
        final store = await _record(_purchase('01'));
        final bill = store.doc('accounting_documents', _billId)!;
        expect(bill['status'], 'paid');
        expect(bill['balance'], 0);
        expect(store.linesOf(purchaseJe), containsAll([('1010', 0, 118000)]));
        expect(store.creditBalance('2010'), 0);
      },
    );

    test('credit purchase books the whole total to Accounts Payable', () async {
      final store = await _record(
        _purchase('02', dueDate: DateTime(2026, 10, 20)),
      );
      final bill = store.doc('accounting_documents', _billId)!;
      expect(bill['status'], 'sent');
      expect(bill['total'], 118000);
      expect(bill['balance'], 118000);
      expect(bill['due_date'], '20 Oct 2026');
      expect(store.creditBalance('2010'), 118000);
      expect(store.creditBalance('1010'), 0);
    });

    test('cash/credit splits the credit line between cash and AP', () async {
      final store = await _record(_purchase('03', paidUpfront: 18000));
      final bill = store.doc('accounting_documents', _billId)!;
      expect(bill['paid_upfront'], 18000);
      expect(bill['balance'], 100000);
      expect(
        store.linesOf(purchaseJe),
        containsAll([
          ('1200', 100000, 0),
          ('2100', 18000, 0),
          ('2010', 0, 100000),
          ('1010', 0, 18000),
        ]),
      );
    });

    test('approval keeps the terms saved on the draft bill', () async {
      final store = await _record(
        _purchase('03', paidUpfront: 50000, dueDate: DateTime(2026, 11, 5)),
        postToLedger: false,
      );
      expect(store.doc('accounting_documents', _billId)!['status'], 'draft');
      expect(store.all('journal_entries'), isEmpty);

      // Approval from the purchases list knows nothing about the terms.
      await _record(_purchase('03'), store: store);
      final bill = store.doc('accounting_documents', _billId)!;
      expect(bill['status'], 'sent');
      expect(bill['balance'], 68000);
      expect(bill['due_date'], '5 Nov 2026');
      expect(store.creditBalance('2010'), 68000);
    });

    test('declining discards the draft bill but never a posted one', () async {
      final store = await _record(_purchase('02'), postToLedger: false);
      await PurchaseJournalPoster(
        store,
      ).discardDraftBill(businessId: _biz, invoiceNo: 42);
      expect(store.doc('accounting_documents', _billId), isNull);

      final posted = await _record(_purchase('02'));
      await PurchaseJournalPoster(
        posted,
      ).discardDraftBill(businessId: _biz, invoiceNo: 42);
      expect(posted.doc('accounting_documents', _billId), isNotNull);
    });
  });

  group('BillPaymentPoster', () {
    test(
      'part payments reduce the balance until the bill is settled',
      () async {
        final store = await _record(_purchase('02'));

        final first = await _pay(store, 50000);
        expect(first.balance, 68000);
        expect(store.doc('accounting_documents', _billId)!['status'], 'sent');
        expect(
          store.doc('accounting_documents', _billId)!['amount_paid'],
          50000,
        );

        final second = await _pay(store, 68000, account: '1030');
        expect(second.isSettled, isTrue);
        expect(store.doc('accounting_documents', _billId)!['status'], 'paid');

        // AP is cleared exactly; the money left from cash and MoMo.
        expect(store.creditBalance('2010'), 0);
        expect(store.creditBalance('1010'), 50000);
        expect(store.creditBalance('1030'), 68000);
        expect(store.all(billPaymentsCollection), hasLength(2));
      },
    );

    test('a retried payment with the same id posts once', () async {
      final store = await _record(_purchase('02'));
      await _pay(store, 40000, paymentId: 'pay-1');
      final again = await _pay(store, 40000, paymentId: 'pay-1');
      expect(again.balance, 78000);
      expect(store.creditBalance('2010'), 78000);
    });

    test(
      'payments made before approval survive a re-post of the bill',
      () async {
        final store = await _record(_purchase('02'));
        await _pay(store, 30000);
        // Re-running the poster (e.g. a second approval tap) keeps the payment.
        await _record(_purchase('02'), store: store);
        expect(store.doc('accounting_documents', _billId)!['balance'], 88000);
      },
    );

    test('ledger stays balanced across purchase and payments', () async {
      final store = await _record(_purchase('03', paidUpfront: 18000));
      await _pay(store, 60000);
      var dr = 0, cr = 0;
      for (final l in store.all('journal_lines')) {
        dr += (l['debit'] as num).round();
        cr += (l['credit'] as num).round();
      }
      expect(dr, cr);
      // AP equals what the bill says is still owed.
      expect(
        store.creditBalance('2010'),
        store.doc('accounting_documents', _billId)!['balance'],
      );
    });

    test('rejects a non-positive amount and an unknown bill', () async {
      final store = await _record(_purchase('02'));
      expect(() => _pay(store, 0), throwsArgumentError);
      expect(
        () => BillPaymentPoster(store).recordPayment(
          businessId: _biz,
          billDocId: 'missing',
          amount: 10,
          paymentAccount: '1010',
          accounts: defaultChartOfAccountsSeed,
        ),
        throwsStateError,
      );
    });
  });

  test('parseBillDueDate prefers ISO due_at, then the display date', () {
    expect(
      parseBillDueDate({'due_at': '2026-10-20T00:00:00.000Z'}),
      DateTime.utc(2026, 10, 20).toLocal(),
    );
    expect(parseBillDueDate({'due_date': '5 Nov 2026'}), DateTime(2026, 11, 5));
    expect(parseBillDueDate({}), isNull);
  });
}
