import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';

/// Ditto collection for tender lines / partial payments on a sale.
///
/// Capella writes these with [store.execute], but peers only receive documents
/// that match a [Sync.registerSubscription]. Without that subscription, Machine A
/// can record a partial payment that Machine B never sees — while the parent
/// `transactions` row still syncs (Layaway badge, totals).
const kTransactionPaymentRecordsCollection = 'transaction_payment_records';

const kTransactionPaymentRecordsAllSql =
    'SELECT * FROM $kTransactionPaymentRecordsCollection';

final Set<String> _paymentRecordsSyncSubscriptionKeys = <String>{};

/// Ensures collection-wide replication of payment records (idempotent).
///
/// Payment rows have no `branchId`; scoping by open ticket ids would require
/// re-registering on every park/collect. Collection-wide matches other
/// append-only Capella collections (e.g. shifts broad sync).
void ensureTransactionPaymentRecordsSyncSubscription(dynamic ditto) {
  if (ditto == null) return;
  const key = 'transaction_payment_records|all';
  if (_paymentRecordsSyncSubscriptionKeys.contains(key)) return;
  try {
    final prepared = prepareDqlSyncSubscription(
      kTransactionPaymentRecordsAllSql,
      null,
    );
    ditto.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );
    _paymentRecordsSyncSubscriptionKeys.add(key);
    talker.debug('transaction_payment_records: registered sync subscription');
  } catch (e, s) {
    talker.warning(
      'transaction_payment_records: sync subscription failed: $e\n$s',
    );
  }
}

/// Test-only: clear the dedupe set so subscription registration can be asserted.
void resetTransactionPaymentRecordsSyncSubscriptionKeysForTest() {
  _paymentRecordsSyncSubscriptionKeys.clear();
}
