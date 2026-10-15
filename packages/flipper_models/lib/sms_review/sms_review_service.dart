import 'package:flipper_models/sms_review/sms_review_item.dart';

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

  /// Marks a Books bank line as matched to a journal entry.
  Future<void> matchBankLine(String bankLineId, String journalEntryId);
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
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final SmsReviewStore store;
  final SmsMovementRecorder recordMovement;

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

  /// Not a business transaction (a duplicate, a personal transfer). The bank
  /// line stays for Books to categorise.
  Future<void> ignore(SmsReviewItem item) =>
      _close(item, SmsReviewItem.ignored);

  /// Between the business's own accounts (bank → MoMo): no Cash Book entry.
  Future<void> markTransfer(SmsReviewItem item) =>
      _close(item, SmsReviewItem.transfer);

  Future<void> _close(SmsReviewItem item, String status) async {
    final now = _clock().toIso8601String();
    await store.setStatus(
      item.id,
      status,
      extra: {'reviewedAt': now, 'lastTouched': now},
    );
  }
}
