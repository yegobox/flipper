import 'dart:async';

import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/ditto_accounting_ledger_repository.dart';
import 'package:flipper_models/sms_review/sms_debt_match.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_models/sms_review/sms_review_service.dart';
import 'package:flipper_models/sms_review/sms_sale_match.dart';
import 'package:flipper_models/sms_review/sms_transfer.dart';
import 'package:flipper_services/constants.dart' show COMPLETE;
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:ditto_live/ditto_live.dart' show Ditto;
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _pendingQuery =
    'SELECT * FROM ${SmsReviewItem.collection} '
    'WHERE branchId = :branchId AND status = :status';

/// The instance at every change of [addListener], `null` while there is none
/// or it is not [isUsable], without repeats. [addListener] must call back at
/// once with the current instance, as `DittoService.addDittoListener` does.
///
/// Generic so the bookkeeping is testable without a real Ditto.
@visibleForTesting
Stream<D?> usableInstances<D extends Object>({
  required void Function(void Function(D?) listener) addListener,
  required void Function(void Function(D?) listener) removeListener,
  required bool Function(D instance) isUsable,
}) {
  late final StreamController<D?> controller;
  Object? last = const _None();
  void onChange(D? instance) {
    final usable = instance != null && isUsable(instance) ? instance : null;
    if (identical(usable, last)) return;
    last = usable;
    controller.add(usable);
  }

  controller = StreamController<D?>(
    onListen: () => addListener(onChange),
    onCancel: () => removeListener(onChange),
  );
  return controller.stream;
}

class _None {
  const _None();
}

/// The app's Ditto instance, `null` until it is up. A provider rather than a
/// `DittoService.instance.dittoInstance` read, so whatever watches it re-runs
/// when Ditto starts or swaps instance: a review list built before Ditto was
/// ready used to stay empty for the whole session.
///
/// Skips the short-lived QR-login instance, which cannot read the business's
/// collections (same rule as `AppService._isLoginDitto`).
final usableDittoProvider = StreamProvider<Ditto?>((ref) {
  return usableInstances<Ditto>(
    addListener: DittoService.instance.addDittoListener,
    removeListener: DittoService.instance.removeDittoListener,
    isUsable: (ditto) {
      try {
        return !ditto.deviceName.contains('-login-');
      } catch (_) {
        return true;
      }
    },
  );
});

/// Bank and mobile-money SMS waiting for review at [branchId], oldest first.
///
/// One Ditto observer for the whole list. The sync subscription is scoped to
/// pending items, so confirmed history does not accumulate on the till.
final smsReviewItemsProvider = StreamProvider.autoDispose
    .family<List<SmsReviewItem>, String>((ref, branchId) {
      if (branchId.isEmpty) return Stream.value(const []);
      final ditto = ref.watch(usableDittoProvider).value;
      if (ditto == null) return Stream.value(const []);

      final args = {'branchId': branchId, 'status': SmsReviewItem.pending};
      try {
        final prepared = prepareDqlSyncSubscription(_pendingQuery, args);
        ditto.sync.registerSubscription(
          prepared.dql,
          arguments: prepared.arguments,
        );
      } catch (_) {
        // The observer still reads what is already on this device.
      }

      final controller = StreamController<List<SmsReviewItem>>.broadcast();
      var logged = false;
      final observer = ditto.store.registerObserver(
        _pendingQuery,
        arguments: args,
        onChange: (result) {
          if (controller.isClosed) return;
          if (!logged) {
            // One line per subscription, so "SMS not showing" can be read off
            // logcat: which branch the device asks for and what it holds.
            logged = true;
            talker.info(
              '[sms-review] branch=$branchId pending=${result.items.length} '
              'syncActive=${ditto.sync.isActive}',
            );
          }
          final items =
              result.items
                  .map(
                    (i) => SmsReviewItem.fromDitto(
                      Map<String, dynamic>.from(i.value),
                    ),
                  )
                  .where((i) => i.id.isNotEmpty && i.amount > 0)
                  .toList()
                ..sort(
                  (a, b) => (a.occurredAt ?? a.lineDate ?? '').compareTo(
                    b.occurredAt ?? b.lineDate ?? '',
                  ),
                );
          controller.add(items);
        },
      );
      ref.onDispose(() async {
        observer.cancel();
        await controller.close();
      });
      return controller.stream;
    });

const _salesNearQuery =
    'SELECT * FROM transactions WHERE branchId = :branchId '
    'AND status = :status AND subTotal = :amount '
    'AND createdAt >= :start AND createdAt <= :end';

const _linkedQuery =
    'SELECT * FROM ${SmsReviewItem.collection} WHERE transactionId IN :ids';

/// Completed sales at the item's branch that its money may already be paying
/// for (see [smsMatchingSales]), nearest in time first. Empty for money out,
/// charges, and SMS without a time.
///
/// One local read when the review opens, not an observer: a sale rung up
/// while the sheet is open shows the next time it opens.
final smsMatchingSalesProvider = FutureProvider.autoDispose
    .family<List<SmsSaleCandidate>, SmsReviewItem>((ref, item) async {
      final at = item.occurredAtDate;
      if (!smsCanMatchSale(item) || at == null) return const [];
      final ditto = DittoService.instance.dittoInstance;
      if (ditto == null) return const [];

      final sales = await ditto.store.execute(
        _salesNearQuery,
        arguments: {
          'branchId': item.branchId,
          'status': COMPLETE,
          'amount': item.amount,
          // Same local, offset-free ISO form transactions store createdAt in.
          'start': at.subtract(smsSaleMatchWindow).toIso8601String(),
          'end': at.add(smsSaleMatchWindow).toIso8601String(),
        },
      );
      final candidates = sales.items
          .map((i) => SmsSaleCandidate.fromDitto(Map.from(i.value)))
          .toList();
      if (candidates.isEmpty) return const [];

      final linked = await ditto.store.execute(
        _linkedQuery,
        arguments: {'ids': candidates.map((c) => c.transactionId).toList()},
      );
      final linkedIds = {
        for (final i in linked.items)
          if (i.value['_id'] != item.id && i.value['transactionId'] != null)
            i.value['transactionId'].toString(),
      };
      return smsMatchingSales(
        item,
        candidates,
        linkedTransactionIds: linkedIds,
      );
    });

const _openLoansQuery =
    'SELECT * FROM transactions WHERE branchId = :branchId '
    'AND isLoan = true AND remainingBalance > 0';

/// Credit sales at the item's branch still owed, that its money may be
/// repaying (see [smsMatchingDebts]), most likely first. Empty for money out
/// and charges. One local read when the review opens, like
/// [smsMatchingSalesProvider].
final smsMatchingDebtsProvider = FutureProvider.autoDispose
    .family<List<SmsDebtCandidate>, SmsReviewItem>((ref, item) async {
      if (!smsCanSettleDebt(item)) return const [];
      final ditto = DittoService.instance.dittoInstance;
      if (ditto == null) return const [];
      final loans = await ditto.store.execute(
        _openLoansQuery,
        arguments: {'branchId': item.branchId},
      );
      return smsMatchingDebts(item, [
        for (final i in loans.items)
          if (i.value['isExpense'] != true)
            SmsDebtCandidate.fromDitto(Map.from(i.value)),
      ]);
    });

/// [SmsReviewStore] over the app's Ditto instance.
class DittoSmsReviewStore implements SmsReviewStore {
  const DittoSmsReviewStore();

  @override
  Future<bool> claim(String id) => DittoService.instance.executeUpdateWhere(
    SmsReviewItem.collection,
    id,
    {
      'status': SmsReviewItem.confirming,
      'lastTouched': DateTime.now().toIso8601String(),
    },
    extraWhere: 'status = :expectedStatus',
    extraArgs: {'expectedStatus': SmsReviewItem.pending},
  );

  @override
  Future<void> setStatus(
    String id,
    String status, {
    Map<String, Object?> extra = const {},
  }) => DittoService.instance.executeUpdate(SmsReviewItem.collection, id, {
    'status': status,
    ...extra,
  });

  /// Both spellings, as `LedgerRowMapper.bankLineToRow` writes them.
  @override
  Future<void> matchBankLine(String bankLineId, String? journalEntryId) =>
      DittoService.instance.executeUpdate('bank_statement_lines', bankLineId, {
        'matchedJournalEntryId': journalEntryId,
        'matched_journal_entry_id': journalEntryId,
      });
}

/// Posts and voids SMS transfer entries in the Ditto ledger, the way
/// `PosJournalPoster` posts sales.
class DittoSmsTransferLedger {
  const DittoSmsTransferLedger();

  Future<void> post({
    required String entryId,
    required SmsReviewItem item,
    required String otherAccountCode,
  }) async {
    final ledger = DittoAccountingLedgerRepository(DittoService.instance);
    await ledger.ensureSeeded(businessId: item.businessId);
    await ledger.createJournalEntry(
      businessId: item.businessId,
      entry: smsTransferEntry(item, otherAccountCode),
      journalCode: 'misc',
      entryId: entryId,
    );
    await ledger.postJournalEntry(
      businessId: item.businessId,
      entryId: entryId,
    );
  }

  /// A draft with no lines: `updateJournalEntry` zeroes the old lines, so
  /// the entry stops counting. Recording the transfer again rewrites it.
  Future<void> voidEntry({
    required String entryId,
    required SmsReviewItem item,
  }) =>
      DittoAccountingLedgerRepository(DittoService.instance).updateJournalEntry(
        businessId: item.businessId,
        entryId: entryId,
        entry: smsTransferEntry(
          item,
          kSmsCashAccount,
          status: JournalStatus.draft,
        ),
      );
}
