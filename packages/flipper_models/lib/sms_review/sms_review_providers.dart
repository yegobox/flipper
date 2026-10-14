import 'dart:async';

import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_models/sms_review/sms_review_service.dart';
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
