import 'dart:async';

import 'package:flipper_accounting/accounting_ledger_repository.dart';
import 'package:flipper_accounting/accounting_transaction_semantics.dart';
import 'package:flipper_accounting/audit_trail_recorder.dart';
import 'package:flipper_accounting/ditto_accounting_ledger_repository.dart';
import 'package:flipper_accounting/transaction_to_accounts.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/modules/accounting/data/repository/ditto_accounting_repository.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:talker/talker.dart';

/// Posts double-entry journal entries to the shared accounting ledger at
/// transaction time, so the Books module (flipper_web) finds them already
/// recorded whether or not it is running — the POS is a first-class citizen
/// of the accounting system.
///
/// Entry ids are deterministic so concurrent posters (this service and the
/// Books auto-poster, possibly on different Ditto peers) converge on the same
/// document instead of duplicating:
///   - sale/expense entry:  `je_<businessId>_<transactionId>_sale`
///   - loan payment entry:  `je_<businessId>_<transactionId>_pay_<paymentKey>`
///
/// The local Ditto write is the durability mechanism: it survives offline and
/// replicates to the Big Peer when connectivity returns.
class PosJournalPoster {
  PosJournalPoster._();

  static final Talker _talker = Talker();
  static bool _coaSeeded = false;

  static String saleEntryId(String businessId, String transactionId) =>
      'je_${businessId}_${transactionId}_sale';

  static String paymentEntryId(
    String businessId,
    String transactionId,
    int paymentKey,
  ) =>
      'je_${businessId}_${transactionId}_pay_$paymentKey';

  /// Fire-and-forget hook for `collectPayment`. Never throws.
  ///
  /// Posts the sale/expense entry on the first finalizing event and a
  /// Dr liquid / Cr AR payment entry for each later loan repayment.
  /// [eventCashReceived] is the tender of THIS event (not the cumulative
  /// `transaction.cashReceived`).
  static Future<void> onTransactionFinalized({
    required ITransaction transaction,
    required List<TransactionItem> items,
    required double eventCashReceived,
    String? completionStatus,
    bool isProformaMode = false,
    bool isTrainingMode = false,
  }) async {
    try {
      if (isProformaMode || isTrainingMode) return;
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null || businessId.isEmpty) return;
      final ditto = DittoService.instance;
      if (!ditto.isReady()) return;

      final txnRow = transactionToAccountingRow(
        transaction,
        statusOverride: completionStatus,
      );
      if (!isAccountingRecognizedTransaction(txnRow)) return;

      final ledger = DittoAccountingLedgerRepository(ditto);
      await _ensureCoaSeeded(ledger, businessId);

      final txnId = transaction.id;
      final saleId = saleEntryId(businessId, txnId);
      final saleExists = await _saleEntryExists(
        ledger,
        businessId: businessId,
        transactionId: txnId,
        saleId: saleId,
      );

      if (!saleExists) {
        final entries = TransactionToAccounts.toJournal(
          [txnRow],
          items.map(itemToAccountingRow).toList(),
        );
        if (entries.isEmpty) return;
        await ledger.createJournalEntry(
          businessId: businessId,
          entry: entries.first,
          transactionId: txnId,
          journalCode: entries.first.src == 'Expense' ? 'misc' : 'sales',
          entryId: saleId,
        );
        await ledger.postJournalEntry(businessId: businessId, entryId: saleId);
        await AuditTrailRecorder(ditto).record(
          businessId: businessId,
          id: 'audit_$saleId',
          action: 'Posted',
          target: entries.first.id,
          detail: entries.first.memo,
          user: _actor(),
          role: 'Cashier',
          tone: 'green',
          src: 'POS',
        );
        _talker.info('[PosJournalPoster] posted sale entry $saleId');
        return;
      }

      // Sale entry already posted → a further cash event on a loan is a
      // repayment: move the paid amount out of Accounts Receivable.
      if (transaction.isLoan == true && eventCashReceived > 0) {
        final paymentDate =
            transaction.lastPaymentDate ?? DateTime.now().toUtc();
        final payId = paymentEntryId(
          businessId,
          txnId,
          paymentDate.millisecondsSinceEpoch,
        );
        final payExists =
            await ledger.entryExists(businessId: businessId, entryId: payId);
        if (payExists) return;
        final entry = TransactionToAccounts.paymentToEntry(
          txn: txnRow,
          amount: eventCashReceived.round(),
          dateIso: paymentDate.toIso8601String(),
        );
        await ledger.createJournalEntry(
          businessId: businessId,
          entry: entry,
          transactionId: txnId,
          journalCode: 'sales',
          entryId: payId,
        );
        await ledger.postJournalEntry(businessId: businessId, entryId: payId);
        await AuditTrailRecorder(ditto).record(
          businessId: businessId,
          id: 'audit_$payId',
          action: 'Loan payment',
          target: entry.id,
          detail: entry.memo,
          user: _actor(),
          role: 'Cashier',
          tone: 'green',
          src: 'POS',
        );
        _talker.info('[PosJournalPoster] posted loan payment entry $payId');
      }
    } catch (e, s) {
      // Posting must never break the sale; the startup sweep backfills.
      _talker.error('[PosJournalPoster] posting failed: $e', s);
    }
  }

  /// Idempotent startup backfill: posts sale entries for recent finalized
  /// transactions that were missed (crash, pre-rollout data). Never throws.
  ///
  /// Loan repayment events missed by a crash are not reconstructed here;
  /// the per-event tender lives in `transaction_payment_records` — a later
  /// enhancement could rebuild payment entries from those rows.
  static Future<void> sweepUnposted({
    required String branchId,
    int lookbackDays = 90,
  }) async {
    try {
      if (branchId.isEmpty) return;
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null || businessId.isEmpty) return;
      final ditto = DittoService.instance;
      if (!ditto.isReady()) return;

      final repo = DittoAccountingRepository(ditto);
      final txns = await repo.fetchTransactions(
        branchId: branchId,
        startDate:
            DateTime.now().toUtc().subtract(Duration(days: lookbackDays)),
      );
      if (txns.isEmpty) return;

      final ledger = DittoAccountingLedgerRepository(ditto);
      await _ensureCoaSeeded(ledger, businessId);

      var created = 0;
      for (final txnRow in txns) {
        if (!isAccountingRecognizedTransaction(txnRow)) continue;
        final txnId = (txnRow['id'] ?? txnRow['_id'] ?? '').toString();
        if (txnId.isEmpty) continue;
        final saleId = saleEntryId(businessId, txnId);
        final exists = await _saleEntryExists(
          ledger,
          businessId: businessId,
          transactionId: txnId,
          saleId: saleId,
        );
        if (exists) continue;

        final itemRows =
            await repo.fetchTransactionItems(transactionIds: [txnId]);
        final entries = TransactionToAccounts.toJournal([txnRow], itemRows);
        if (entries.isEmpty) continue;
        await ledger.createJournalEntry(
          businessId: businessId,
          entry: entries.first,
          transactionId: txnId,
          journalCode: entries.first.src == 'Expense' ? 'misc' : 'sales',
          entryId: saleId,
        );
        await ledger.postJournalEntry(businessId: businessId, entryId: saleId);
        await AuditTrailRecorder(ditto).record(
          businessId: businessId,
          id: 'audit_$saleId',
          action: 'Posted',
          target: entries.first.id,
          detail: '${entries.first.memo} (startup backfill)',
          user: _actor(),
          role: 'Cashier',
          src: 'POS backfill',
        );
        created++;
      }
      if (created > 0) {
        _talker.info(
          '[PosJournalPoster] sweep backfilled $created journal entries '
          '(branch=$branchId, lookback=${lookbackDays}d)',
        );
      }
    } catch (e, s) {
      _talker.error('[PosJournalPoster] sweep failed: $e', s);
    }
  }

  /// A transaction's sale entry exists when the deterministic id is present
  /// or any legacy (random-id) entry carries its transactionId. Payment
  /// entries also carry the transactionId, but they are only ever created
  /// after the sale entry, so the inference holds.
  static Future<bool> _saleEntryExists(
    AccountingLedgerRepository ledger, {
    required String businessId,
    required String transactionId,
    required String saleId,
  }) async {
    if (await ledger.entryExists(businessId: businessId, entryId: saleId)) {
      return true;
    }
    final legacy = await ledger.findEntryIdByTransactionId(
      businessId: businessId,
      transactionId: transactionId,
    );
    return legacy != null;
  }

  /// Who performed the POS action, for the audit trail (best effort).
  static String _actor() {
    try {
      return ProxyService.box.getUserPhone() ??
          ProxyService.box.getUserId() ??
          'POS';
    } catch (_) {
      return 'POS';
    }
  }

  static Future<void> _ensureCoaSeeded(
    AccountingLedgerRepository ledger,
    String businessId,
  ) async {
    if (_coaSeeded) return;
    await ledger.ensureSeeded(businessId: businessId);
    _coaSeeded = true;
  }

  /// camelCase raw map in the shape the accounting semantics layer reads
  /// (mirrors the Ditto `transactions` document convention).
  static Map<String, dynamic> transactionToAccountingRow(
    ITransaction t, {
    String? statusOverride,
  }) {
    final status = statusOverride ?? t.status;
    // A parked sale IS a loan/credit sale (the POS parks partial-tender and
    // "mark as loan" sales). transaction.isLoan may not be persisted on the
    // in-memory object yet at posting time (markTransactionAsCompleted sets it
    // afterward), so derive it from the parked status for the AR split.
    final isLoan = t.isLoan == true ||
        (status?.trim().toLowerCase() == 'parked' && t.isExpense != true);
    return {
        'id': t.id,
        'status': status,
        'subTotal': t.subTotal,
        'taxAmount': t.taxAmount,
        'isLoan': isLoan,
        'isExpense': t.isExpense,
        'remainingBalance': t.remainingBalance,
        'paymentType': t.paymentType,
        'receiptNumber': t.receiptNumber,
        'createdAt': t.createdAt?.toIso8601String(),
        'customerId': t.customerId,
        'customerName': t.customerName,
        'note': t.note,
        'reference': t.reference,
      };
  }

  static Map<String, dynamic> itemToAccountingRow(TransactionItem i) => {
        'id': i.id,
        'transactionId': i.transactionId,
        'splyAmt': i.splyAmt,
      };
}
