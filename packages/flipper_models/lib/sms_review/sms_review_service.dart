import 'package:flipper_models/sms_review/sms_debt_match.dart';
import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_models/sms_review/sms_transfer.dart';

/// The Ditto writes the review flow needs. Behind an interface so the flow
/// is unit-tested without a Ditto instance.
abstract interface class SmsReviewStore {
  /// Moves [id] from `pending_review` to `confirming`. False when another
  /// till got there first (or the item is no longer pending).
  Future<bool> claim(String id);

  /// Sets the item's final status, plus any extra fields.
  Future<void> setStatus(
    String id,
    String status, {
    Map<String, Object?> extra = const {},
  });

  /// Marks a Books bank line as matched to a journal entry; null unmatches
  /// it (an undone transfer).
  Future<void> matchBankLine(String bankLineId, String? journalEntryId);
}

/// Records a Cash In/Out and returns the new transaction's id. Wraps
/// `completeCashMovement`, which needs till context (bhfId, modes) that only
/// the Cash Book has.
typedef SmsMovementRecorder =
    Future<String> Function({
      required SmsReviewItem item,
      required String? categoryId,
      required String? categoryName,
    });

/// Posts the transfer entry [entryId] (`smsTransferEntry`) to the ledger.
typedef SmsTransferPoster =
    Future<void> Function({
      required String entryId,
      required SmsReviewItem item,
      required String otherAccountCode,
    });

/// Takes a posted transfer entry back out of the books (undo).
typedef SmsTransferVoider =
    Future<void> Function({
      required String entryId,
      required SmsReviewItem item,
    });

/// A repayment recorded against a customer's debt: the sale it repaid, what
/// the customer still owes, and the journal entry the money lands in.
typedef SmsDebtSettlement = ({
  String transactionId,
  double remaining,
  String journalEntryId,
});

/// Records [item]'s money as an installment on [debt], as the POS would when
/// the customer pays at the till. Throws when the debt is no longer open.
typedef SmsDebtRepaymentRecorder =
    Future<SmsDebtSettlement> Function({
      required SmsReviewItem item,
      required SmsDebtCandidate debt,
    });

/// A recorded transfer: its entry, and the other account's SMS closed with
/// it (null when there was none), so Undo can reopen both.
typedef SmsTransferResult = ({String entryId, SmsReviewItem? pairedWith});

/// Turns a reviewed bank SMS into books.
///
/// **Confirm** records the Cash In/Out with the SMS's own date and payment
/// method, then matches the Books bank line to the movement's journal entry
/// (`PosJournalPoster.saleEntryId`). That match is what keeps the money from
/// being counted twice: the movement posts Dr/Cr the bank account, and a
/// matched bank line posts nothing more.
class SmsReviewService {
  SmsReviewService({
    required this.store,
    required this.recordMovement,
    required this.journalEntryId,
    required this.postTransfer,
    required this.voidTransfer,
    this.recordRepayment,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final SmsReviewStore store;
  final SmsMovementRecorder recordMovement;
  final SmsTransferPoster postTransfer;
  final SmsTransferVoider voidTransfer;

  /// Null where repayments cannot be recorded; [settleDebt] then throws.
  final SmsDebtRepaymentRecorder? recordRepayment;

  /// `PosJournalPoster.saleEntryId`, injected so this file has no poster
  /// dependency.
  final String Function(String businessId, String transactionId) journalEntryId;
  final DateTime Function() _clock;

  /// Records the movement. Returns its transaction id, or null when another
  /// till already took the item (nothing was recorded).
  Future<String?> confirm(
    SmsReviewItem item, {
    String? categoryId,
    String? categoryName,
  }) async {
    if (!await store.claim(item.id)) return null;

    final String transactionId;
    try {
      transactionId = await recordMovement(
        item: item,
        categoryId: categoryId,
        categoryName: categoryName,
      );
    } catch (_) {
      // Nothing was recorded: put the item back so it can be retried.
      await store.setStatus(item.id, SmsReviewItem.pending);
      rethrow;
    }

    final now = _clock().toIso8601String();
    await store.setStatus(
      item.id,
      SmsReviewItem.confirmed,
      extra: {
        'transactionId': transactionId,
        if (categoryId != null) 'categoryId': categoryId,
        'reviewedAt': now,
        'lastTouched': now,
      },
    );
    final lineId = item.bankLineId;
    if (lineId != null && lineId.isNotEmpty) {
      await store.matchBankLine(
        lineId,
        journalEntryId(item.businessId, transactionId),
      );
    }
    return transactionId;
  }

  /// The money was already rung up as a POS sale ([transactionId]): records
  /// nothing new, so reports and the dashboard count it once. The bank line
  /// is matched to that sale's journal entry. False when another till already
  /// took the item.
  Future<bool> linkToSale(SmsReviewItem item, String transactionId) async {
    if (!await store.claim(item.id)) return false;
    final now = _clock().toIso8601String();
    await store.setStatus(
      item.id,
      SmsReviewItem.matched,
      extra: {
        'transactionId': transactionId,
        'reviewedAt': now,
        'lastTouched': now,
      },
    );
    final lineId = item.bankLineId;
    if (lineId != null && lineId.isNotEmpty) {
      await store.matchBankLine(
        lineId,
        journalEntryId(item.businessId, transactionId),
      );
    }
    return true;
  }

  /// The money is a customer repaying [debt], a credit sale: records it as an
  /// installment on that sale (no new sale, no new receipt) and matches the
  /// bank line to the repayment's entry. Null when another till already took
  /// the item (nothing was recorded).
  Future<SmsDebtSettlement?> settleDebt(
    SmsReviewItem item,
    SmsDebtCandidate debt,
  ) async {
    final record = recordRepayment;
    if (record == null) {
      throw StateError('Debt repayments are not available here');
    }
    if (!await store.claim(item.id)) return null;

    final SmsDebtSettlement settled;
    try {
      settled = await record(item: item, debt: debt);
    } catch (_) {
      await store.setStatus(item.id, SmsReviewItem.pending);
      rethrow;
    }

    final now = _clock().toIso8601String();
    await store.setStatus(
      item.id,
      SmsReviewItem.matched,
      extra: {
        'transactionId': settled.transactionId,
        'settledDebt': true,
        'reviewedAt': now,
        'lastTouched': now,
      },
    );
    final lineId = item.bankLineId;
    if (lineId != null && lineId.isNotEmpty) {
      await store.matchBankLine(lineId, settled.journalEntryId);
    }
    return settled;
  }

  /// Not a business transaction (a duplicate, a personal transfer). The bank
  /// line stays for Books to categorise.
  Future<void> ignore(SmsReviewItem item) =>
      _close(item, SmsReviewItem.ignored);

  /// Money moved between the business's own accounts ([otherAccountCode]:
  /// cash, bank or mobile money). Not income or expense, so nothing goes to
  /// the Cash Book: one transfer entry is posted and the bank line matched to
  /// it. [counterpart], the SMS the other account sent for the same move, is
  /// closed against the same entry so the move is counted once. Null when
  /// another till already took the item (nothing was posted).
  Future<SmsTransferResult?> recordTransfer(
    SmsReviewItem item, {
    required String otherAccountCode,
    SmsReviewItem? counterpart,
  }) async {
    if (!await store.claim(item.id)) return null;
    final entryId = smsTransferEntryId(item.id);
    try {
      await postTransfer(
        entryId: entryId,
        item: item,
        otherAccountCode: otherAccountCode,
      );
    } catch (_) {
      await store.setStatus(item.id, SmsReviewItem.pending);
      rethrow;
    }
    await _closeTransfer(item, entryId, otherAccountCode);
    final paired =
        counterpart != null &&
            counterpart.bankAccountCode == otherAccountCode &&
            await store.claim(counterpart.id)
        ? counterpart
        : null;
    if (paired != null) {
      await _closeTransfer(paired, entryId, item.bankAccountCode);
    }
    return (entryId: entryId, pairedWith: paired);
  }

  /// Undo for [recordTransfer]: takes the entry out of the books and puts
  /// the SMS (and the one closed with it) back in the queue.
  Future<void> undoTransfer(
    SmsTransferResult transfer,
    SmsReviewItem item,
  ) async {
    await voidTransfer(entryId: transfer.entryId, item: item);
    await reopen(item);
    final paired = transfer.pairedWith;
    if (paired != null) await reopen(paired);
  }

  /// Puts a closed SMS back in the review queue (Undo after Ignore or
  /// Transfer), with its bank line unmatched.
  Future<void> reopen(SmsReviewItem item) async {
    await store.setStatus(
      item.id,
      SmsReviewItem.pending,
      extra: {
        'reviewedAt': null,
        'journalEntryId': null,
        'otherAccountCode': null,
        'lastTouched': _clock().toIso8601String(),
      },
    );
    final lineId = item.bankLineId;
    if (lineId != null && lineId.isNotEmpty) {
      await store.matchBankLine(lineId, null);
    }
  }

  Future<void> _closeTransfer(
    SmsReviewItem item,
    String entryId,
    String otherAccountCode,
  ) async {
    final now = _clock().toIso8601String();
    await store.setStatus(
      item.id,
      SmsReviewItem.transfer,
      extra: {
        'journalEntryId': entryId,
        'otherAccountCode': otherAccountCode,
        'reviewedAt': now,
        'lastTouched': now,
      },
    );
    final lineId = item.bankLineId;
    if (lineId != null && lineId.isNotEmpty) {
      await store.matchBankLine(lineId, entryId);
    }
  }

  Future<void> _close(SmsReviewItem item, String status) async {
    final now = _clock().toIso8601String();
    await store.setStatus(
      item.id,
      status,
      extra: {'reviewedAt': now, 'lastTouched': now},
    );
  }
}
