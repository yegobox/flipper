import 'package:flipper_accounting/accounting_transaction_semantics.dart';
import 'package:flipper_accounting/bill_payments.dart';
import 'package:flipper_accounting/default_chart_of_accounts_seed.dart';
import 'package:flipper_accounting/purchase_journal_poster.dart';
import 'package:flipper_accounting/purchase_posting_input.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_accounting_store.dart';

const _biz = 'biz';
final _billId = PurchaseJournalPoster.billDocId(_biz, 'p1');

/// A credit purchase of 118,000 from Kigali Wholesale, approved.
Future<InMemoryAccountingStore> _creditPurchase() async {
  final store = InMemoryAccountingStore();
  await PurchaseJournalPoster(store).postPurchaseRecorded(
    businessId: _biz,
    purchase: PurchasePostingInput(
      purchaseId: 'p1',
      supplierName: 'Kigali Wholesale',
      invoiceNo: 42,
      pmtTyCd: '02',
      totAmt: 118000,
      totTaxAmt: 18000,
      purchaseDate: DateTime(2026, 10, 1),
      lines: const [
        PurchasePostingLine(description: 'Rice 25kg', qty: 4, unitPrice: 29500),
      ],
    ),
    accounts: defaultChartOfAccountsSeed,
    postToLedger: true,
  );
  return store;
}

Future<BillBalance> _pay(
  InMemoryAccountingStore store,
  int amount, {
  String account = '1010',
  String paymentId = 'pay1',
  BillPaymentCashOut? cashOut = const BillPaymentCashOut(
    branchId: 'branch1',
    agentId: 'user1',
  ),
}) => BillPaymentPoster(store).recordPayment(
  businessId: _biz,
  billDocId: _billId,
  amount: amount,
  paymentAccount: account,
  accounts: defaultChartOfAccountsSeed,
  paymentId: paymentId,
  paidAt: DateTime(2026, 10, 8, 0, 30),
  cashOut: cashOut,
);

void main() {
  group('supplier payment cash-out', () {
    test('a payment shows with the expenses like a cash-out', () async {
      final store = await _creditPurchase();
      final after = await _pay(store, 50000);

      expect(after.balance, 68000);
      final txn = store.doc('transactions', 'bill_pay_pay1')!;
      expect(txn['branchId'], 'branch1');
      expect(txn['agentId'], 'user1');
      expect(txn['status'], 'completed');
      expect(txn['isExpense'], isTrue);
      expect(txn['isIncome'], isFalse);
      expect(txn['isOriginalTransaction'], isTrue);
      expect(txn['subTotal'], 50000);
      expect(txn['paymentType'], 'CASH');
      expect(txn['transactionType'], 'Supplier payment');
      expect(txn['customerName'], 'Kigali Wholesale');
      expect(
        store.doc(billPaymentsCollection, 'pay1')!['cashbookTxnId'],
        'bill_pay_pay1',
      );
    });

    test('dated in local time, so it lands on the day it was paid', () async {
      final store = await _creditPurchase();
      await _pay(store, 1000);
      final txn = store.doc('transactions', 'bill_pay_pay1')!;
      // Report windows compare local wall-clock strings: 00:30 on the 8th
      // must not become the 7th in UTC.
      expect(txn['createdAt'], '2026-10-08T00:30:00.000');
      expect(txn['lastTouched'], '2026-10-08T00:30:00.000');
    });

    test('neither ledger poster books it: the payment already did', () async {
      final store = await _creditPurchase();
      await _pay(store, 1000);
      final txn = store.doc('transactions', 'bill_pay_pay1')!;
      expect(isPurchaseExpenseMirror(txn), isTrue);
      expect(isAccountingExpense(txn), isTrue);
    });

    test('bank and MoMo payments carry their method', () async {
      final store = await _creditPurchase();
      await _pay(store, 1000, account: '1020', paymentId: 'b');
      await _pay(store, 1000, account: '1030', paymentId: 'm');
      expect(
        store.doc('transactions', 'bill_pay_b')!['paymentType'],
        'BANK CHECK',
      );
      expect(
        store.doc('transactions', 'bill_pay_m')!['paymentType'],
        'MOBILE MONEY',
      );
    });

    test('without a branch, no cash-out is written', () async {
      final store = await _creditPurchase();
      await _pay(store, 1000, cashOut: null);
      expect(store.all('transactions'), isEmpty);
      expect(
        store.doc(billPaymentsCollection, 'pay1')!['cashbookTxnId'],
        isNull,
      );
    });
  });

  group('backfillCashOut', () {
    test('gives an older payment its cash-out once', () async {
      final store = await _creditPurchase();
      await _pay(store, 20000, cashOut: null);
      final payment = BillPayment.fromRow(
        store.doc(billPaymentsCollection, 'pay1')!,
      );
      final poster = BillPaymentPoster(store);
      const cashOut = BillPaymentCashOut(branchId: 'branch1');

      expect(
        await poster.backfillCashOut(payment: payment, cashOut: cashOut),
        isTrue,
      );
      expect(
        await poster.backfillCashOut(payment: payment, cashOut: cashOut),
        isFalse,
      );
      final txn = store.doc('transactions', 'bill_pay_pay1')!;
      expect(txn['subTotal'], 20000);
      expect(txn['customerName'], 'Kigali Wholesale');
      // Stored in UTC on the payment, written back in local time.
      expect(txn['createdAt'].toString().endsWith('Z'), isFalse);
      expect(
        store.doc(billPaymentsCollection, 'pay1')!['cashbookTxnId'],
        'bill_pay_pay1',
      );
    });
  });

  group('purchaseCashOut', () {
    test("uses the purchase's own branch", () async {
      final store = await _creditPurchase();
      await store.upsertPartyDoc('purchases', 'p1', {'branchId': 'branchA'});
      final cashOut = await BillPaymentPoster(
        store,
      ).purchaseCashOut(_billId, agentId: 'u', fallbackBranchId: 'branchB');
      expect(cashOut!.branchId, 'branchA');
      expect(cashOut.agentId, 'u');
    });

    test('falls back when the purchase is not on this device', () async {
      final store = await _creditPurchase();
      final cashOut = await BillPaymentPoster(
        store,
      ).purchaseCashOut(_billId, fallbackBranchId: 'branchB');
      expect(cashOut!.branchId, 'branchB');
    });

    test('bills not raised from a purchase never touch a till', () async {
      final store = InMemoryAccountingStore();
      await store.upsertAccountingDocument(_biz, {'doc_kind': 'bill'}, 'b1');
      expect(
        await BillPaymentPoster(
          store,
        ).purchaseCashOut('b1', fallbackBranchId: 'branchB'),
        isNull,
      );
    });
  });

  group('bill balances for the purchases list', () {
    test('read from the summary every payment caches on the bill', () {
      final b = BillBalance.fromBillRow({
        'total': 200,
        'paid_upfront': 20,
        'amount_paid': 70,
      });
      expect(b.total, 200);
      expect(b.paidUpfront, 20);
      expect(b.paidLater, 50);
      expect(b.balance, 130);
    });

    test('older bills without a total use the fallback', () {
      expect(BillBalance.fromBillRow({}, fallbackTotal: 500).balance, 500);
    });

    test('an overpaid bill owes nothing', () {
      final b = BillBalance.fromBillRow({'total': 100, 'amount_paid': 150});
      expect(b.balance, 0);
      expect(b.isSettled, isTrue);
    });

    test('keyed by purchase; drafts and plain bills are left out', () {
      final bills = purchaseBillsFromRows([
        {'_id': 'b1', 'purchase_id': 'p1', 'total': 200, 'amount_paid': 50},
        {'_id': 'b2', 'purchaseId': 'p2', 'total': 300, 'amount_paid': 300},
        {'_id': 'b3', 'purchase_id': 'p3', 'total': 90, 'status': 'draft'},
        {'_id': 'b4', 'total': 40},
      ]);
      expect(bills.keys, unorderedEquals(['p1', 'p2']));
      expect(bills['p1']!.docId, 'b1');
      expect(bills['p1']!.balance.balance, 150);
      expect(bills['p2']!.balance.isSettled, isTrue);
    });
  });
}
