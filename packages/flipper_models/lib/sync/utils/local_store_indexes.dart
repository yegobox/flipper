import 'package:flipper_models/helperModels/talker.dart';

/// Local DQL indexes for the fields the app filters on constantly.
///
/// Ditto indexes every document's `_id` and nothing else by default, so a
/// `WHERE transactionId = …` walks the whole collection. Measured on a real
/// till before these existed: ~0.2ms a document, 5,789 line items and 9,984
/// transactions, so a single cart write spent 5.1s in three scans and 15ms on
/// the actual insert.
///
/// Indexes are created by executing DQL (there is no index method on the SDK
/// object, which is why grepping for an API found nothing), are local to the
/// device, are not replicated, and persist across restarts. Available from SDK
/// 4.12.0; the project is on 5.0.3.
///
/// Single-field only: composite indexes need SDK 5.1.0. From 4.13.0 a query
/// can combine several single-field indexes through union/intersect scans, so
/// `WHERE transactionId = :t AND variantId = :v` uses both of the indexes
/// below rather than needing one composite index over the pair.
const Map<String, List<String>> kLocalStoreIndexedFields = {
  // The cart hot path: every tap looks a line up by transaction and variant.
  'transaction_items': ['transactionId', 'variantId', 'branchId'],
  // Cart, tickets, reports and every branch-wide observer filter these.
  'transactions': ['branchId', 'status', 'createdAt'],
  // Resolved per tap before a line is written.
  'variants': ['productId', 'branchId'],
  'stocks': ['variantId', 'branchId'],
};

/// `CREATE INDEX IF NOT EXISTS` statements for [kLocalStoreIndexedFields].
List<String> localStoreIndexStatements() {
  return [
    for (final entry in kLocalStoreIndexedFields.entries)
      for (final field in entry.value)
        'CREATE INDEX IF NOT EXISTS idx_${entry.key}_$field '
            'ON ${entry.key} ($field)',
  ];
}

/// Creates the local indexes, once, as early as the store is usable.
///
/// Best-effort per statement: an index that cannot be created is a slow query,
/// not a broken app, so a failure is logged and the rest still run.
Future<void> ensureLocalStoreIndexes({required dynamic ditto}) async {
  if (ditto == null) return;
  if (_ensured) return;
  _ensured = true;

  final sw = Stopwatch()..start();
  var created = 0;
  var failed = 0;
  for (final statement in localStoreIndexStatements()) {
    try {
      await ditto.store.execute(statement);
      created++;
    } catch (e) {
      // `IF NOT EXISTS` may not be accepted by every SDK version; a rejected
      // statement leaves the field unindexed and the failure silent, so try
      // the plain form before giving up on it.
      final plain = statement.replaceFirst('CREATE INDEX IF NOT EXISTS ', 'CREATE INDEX ');
      try {
        await ditto.store.execute(plain);
        created++;
      } catch (e2) {
        failed++;
        talker.warning('[local_store_index] failed: $plain — $e2');
      }
    }
  }
  talker.warning(
    '[local_store_index] created/ensured $created index(es), $failed failed, '
    'in ${sw.elapsedMilliseconds}ms',
  );
  await logLocalStoreIndexes(ditto: ditto);
}

/// Logs the indexes the store actually holds.
///
/// The only way to tell "the index was created" from "the query ignored it".
Future<void> logLocalStoreIndexes({required dynamic ditto}) async {
  if (ditto == null) return;
  try {
    final result = await ditto.store.execute('SELECT * FROM system:indexes');
    final described = result.items
        .map((doc) => Map<String, dynamic>.from(doc.value).toString())
        .join(' | ');
    talker.warning(
      '[local_store_index] store holds ${result.items.length}: $described',
    );
  } catch (e) {
    talker.warning('[local_store_index] cannot list system:indexes — $e');
  }
}

bool _ensured = false;

/// Lets a re-login rebuild indexes against a freshly opened store.
void resetLocalStoreIndexesForTest() => _ensured = false;
