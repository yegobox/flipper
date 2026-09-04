import 'package:flipper_models/helperModels/talker.dart';

/// How much sales history a device keeps locally.
///
/// Ditto has no DQL indexes, so every `WHERE …` walks the collection at
/// roughly 0.2ms a document. At 5,789 line items and 9,984 transactions a
/// single cart write was spending 5.2s in three such walks. Query cost is a
/// function of how many documents live on the device, so the only fix that
/// helps *every* query rather than one code path is to keep fewer of them.
///
/// Older history is still reachable: a report that asks for a date range
/// registers its own subscription for that range (see the `createdAt` bound
/// exemption in [applyLocalHistoryWindow]), so it pulls what it needs when
/// online. What is dropped is the open-ended replication of all history to a
/// till that never asked for it.
const int kLocalHistoryRetentionDays = 30;

/// Collections whose open-ended subscriptions are windowed.
///
/// Only sales history grows without bound on a till. Catalog collections
/// (variants, products, stocks) are bounded by the size of the business and
/// must stay complete, or the POS cannot sell what it cannot see.
const Set<String> kWindowedHistoryCollections = {
  'transactions',
  'transaction_items',
};

/// Start of the retained window.
DateTime localHistoryWindowStart({DateTime? now}) {
  final from = now ?? DateTime.now();
  return from.subtract(const Duration(days: kLocalHistoryRetentionDays));
}

/// A subscription query, possibly narrowed to the retained window.
typedef WindowedDql = ({String dql, Map<String, dynamic> arguments});

/// Statuses that must never be evicted or fall outside a subscription.
///
/// An open ticket is live work, not history: it can be older than the window
/// (a ticket parked before a long weekend) and still be the thing an operator
/// is about to settle.
const Set<String> kNeverEvictedStatuses = {
  'pending',
  'parked',
  'waiting',
  'awaitingHandover',
  'pendingReview',
  'partiallyPaid',
};

/// Adds a retention floor to an open-ended history subscription.
///
/// Left alone:
/// - collections other than [kWindowedHistoryCollections];
/// - queries already bounded by `createdAt`, which is how a report asks for an
///   explicit date range — narrowing those would silently truncate reports;
/// - queries pinned to a single row (`_id`, `id`, `transactionId`), which are
///   about one known document and cost nothing to sync.
///
/// The floor keeps any row whose status is still open, whatever its age.
WindowedDql applyLocalHistoryWindow(
  String dql,
  Map<String, dynamic> arguments, {
  DateTime? now,
}) {
  final unchanged = (dql: dql, arguments: arguments);
  final collection = _collectionOf(dql);
  if (collection == null || !kWindowedHistoryCollections.contains(collection)) {
    return unchanged;
  }

  final lower = dql.toLowerCase();
  if (lower.contains('createdat')) return unchanged;
  if (_pinsASingleRow(lower)) return unchanged;

  final windowStart = localHistoryWindowStart(now: now).toIso8601String();
  final openStatuses = kNeverEvictedStatuses.toList();
  final windowed =
      '${_withWhere(dql)}(createdAt >= :historyWindowStart '
      'OR status IN :openTicketStatuses)';

  return (
    dql: windowed,
    arguments: {
      ...arguments,
      'historyWindowStart': windowStart,
      'openTicketStatuses': openStatuses,
    },
  );
}

/// Drops history past the window from the local store.
///
/// Windowing subscriptions stops new history arriving; it does not remove what
/// a device already holds, and eviction without windowing is futile — an active
/// subscription pulls the document straight back. Both halves are needed.
///
/// Never evicts an open ticket ([kNeverEvictedStatuses]) whatever its age, and
/// never runs unless the caller says the device is online: a sale that has not
/// reached the cloud exists nowhere else, and evicting it would destroy it.
Future<void> evictAgedLocalHistory({
  required dynamic ditto,
  required bool isOnline,
  DateTime? now,
}) async {
  if (ditto == null) return;
  if (!isOnline) {
    talker.debug(
      '[local_store_retention] skipped: offline, so local history may not '
      'exist anywhere else yet',
    );
    return;
  }

  final cutoff = localHistoryWindowStart(now: now).toIso8601String();
  final openStatuses = kNeverEvictedStatuses.toList();

  for (final collection in kWindowedHistoryCollections) {
    try {
      final sw = Stopwatch()..start();
      // transaction_items carry no status of their own; they are evicted on
      // their own age, and a line item older than the window whose ticket is
      // still open is re-synced by that ticket's subscription.
      final guard = collection == 'transactions'
          ? 'AND (status IS NULL OR status NOT IN :openTicketStatuses)'
          : '';
      await ditto.store.execute(
        'EVICT FROM $collection WHERE createdAt < :cutoff $guard',
        arguments: {
          'cutoff': cutoff,
          if (guard.isNotEmpty) 'openTicketStatuses': openStatuses,
        },
      );
      talker.info(
        '[local_store_retention] evicted $collection older than $cutoff '
        'in ${sw.elapsedMilliseconds}ms',
      );
    } catch (e) {
      talker.warning('[local_store_retention] evicting $collection failed: $e');
    }
  }
}

String? _collectionOf(String dql) {
  final match = RegExp(
    r'\bfrom\s+([a-zA-Z_][a-zA-Z0-9_]*)',
    caseSensitive: false,
  ).firstMatch(dql);
  return match?.group(1);
}

bool _pinsASingleRow(String lowerDql) {
  return RegExp(
    r'\b(_id|id|transactionid)\s*=\s*:',
    caseSensitive: false,
  ).hasMatch(lowerDql);
}

String _withWhere(String dql) {
  final trimmed = dql.trimRight();
  final hasWhere = RegExp(
    r'\bwhere\b',
    caseSensitive: false,
  ).hasMatch(trimmed);
  return hasWhere ? '$trimmed AND ' : '$trimmed WHERE ';
}
