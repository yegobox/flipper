import 'dart:async';

import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_models/sms_review/sms_review_service.dart';
import 'package:flipper_models/sms_review/sms_sale_match.dart';
import 'package:flipper_services/constants.dart' show COMPLETE;
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _pendingQuery =
    'SELECT * FROM ${SmsReviewItem.collection} '
    'WHERE branchId = :branchId AND status = :status';

/// Bank and mobile-money SMS waiting for review at [branchId], oldest first.
///
/// One Ditto observer for the whole list. The sync subscription is scoped to
/// pending items, so confirmed history does not accumulate on the till.
final smsReviewItemsProvider = StreamProvider.autoDispose
    .family<List<SmsReviewItem>, String>((ref, branchId) {
      if (branchId.isEmpty) return Stream.value(const []);
      final ditto = DittoService.instance.dittoInstance;
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
      final observer = ditto.store.registerObserver(
        _pendingQuery,
        arguments: args,
        onChange: (result) {
          if (controller.isClosed) return;
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
  Future<void> matchBankLine(String bankLineId, String journalEntryId) =>
      DittoService.instance.executeUpdate('bank_statement_lines', bankLineId, {
        'matchedJournalEntryId': journalEntryId,
        'matched_journal_entry_id': journalEntryId,
      });
}
