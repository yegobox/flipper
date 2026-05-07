/// Ditto 5 [Sync.registerSubscription] rejects `ORDER BY`, `LIMIT`, and
/// `OFFSET` on subscription queries by default.
///
/// Strip those clauses so replication requests a superset of matching rows.
/// Keep ordering and limits on [Store.registerObserver] / [Store.execute] only.

typedef DqlSyncPrepared = ({String dql, Map<String, dynamic> arguments});

Set<String> _placeholderNamesInDql(String dql) {
  final names = <String>{};
  for (final m in RegExp(r':([a-zA-Z_][a-zA-Z0-9_]*)').allMatches(dql)) {
    names.add(m.group(1)!);
  }
  return names;
}

/// Only binds that still appear in [subscriptionDql] after sanitization.
///
/// Extra keys (e.g. `limit` / `offset` removed with `LIMIT` / `OFFSET`, or
/// unused `status` when the query inlines literals) cause Ditto 5 to reject
/// the subscription.
Map<String, dynamic> dqlArgumentsForSubscription(
  String subscriptionDql,
  Map<String, dynamic>? arguments,
) {
  if (arguments == null || arguments.isEmpty) {
    return const <String, dynamic>{};
  }
  final needed = _placeholderNamesInDql(subscriptionDql);
  if (needed.isEmpty) {
    return const <String, dynamic>{};
  }
  return Map<String, dynamic>.fromEntries(
    arguments.entries.where((e) => needed.contains(e.key)),
  );
}

/// Sanitized DQL and matching arguments for [Sync.registerSubscription].
DqlSyncPrepared prepareDqlSyncSubscription(
  String query,
  Map<String, dynamic>? arguments,
) {
  final dql = dqlForSyncSubscription(query);
  return (
    dql: dql,
    arguments: dqlArgumentsForSubscription(dql, arguments),
  );
}

/// Log-oriented snapshot when [Sync.registerSubscription] throws (wrap with
/// [talker.warning] / [debugPrint] at the call site). Keeps previews bounded.
String describeDqlSyncSubscriptionAttempt(
  String rawQuery,
  Map<String, dynamic>? arguments, {
  int maxChars = 1200,
}) {
  final p = prepareDqlSyncSubscription(rawQuery, arguments);
  String clip(String s) {
    if (s.length <= maxChars) return s;
    return '${s.substring(0, maxChars)}… (${s.length} chars total)';
  }

  return 'DqlSyncSubscription attempt:\n'
      '  raw (${rawQuery.length} chars): ${clip(rawQuery)}\n'
      '  sanitized (${p.dql.length} chars): ${clip(p.dql)}\n'
      '  args_in: $arguments\n'
      '  args_out: ${p.arguments}';
}

String dqlForSyncSubscription(String query) {
  var q = query.trim();
  if (q.isEmpty) return q;

  // NBSP and other odd spaces before ORDER BY can bypass `\s` in sources/paste.
  q = q.replaceAll('\u00A0', ' ');

  if (q.endsWith(';')) {
    q = q.substring(0, q.length - 1).trimRight();
  }

  // Remove the last ORDER BY clause (handles multiline queries where `\nORDER BY`
  // would not match a simple `lastIndexOf(' order by ')` search).
  final orderBy = RegExp(r'\s+order\s+by\b', caseSensitive: false);
  Match? lastOrder;
  for (final m in orderBy.allMatches(q)) {
    lastOrder = m;
  }
  if (lastOrder != null) {
    q = q.substring(0, lastOrder.start).trimRight();
  }

  for (;;) {
    final before = q;
    q = q
        .replaceFirst(
          RegExp(
            r'\s+limit\s+:\w+\s+offset\s+:\w+\s*$',
            caseSensitive: false,
          ),
          '',
        )
        .replaceFirst(
          RegExp(r'\s+limit\s+\d+\s+offset\s+\d+\s*$', caseSensitive: false),
          '',
        )
        .replaceFirst(
          RegExp(r'\s+offset\s+\d+\s+limit\s+\d+\s*$', caseSensitive: false),
          '',
        )
        // SQL standard-style pagination (if emitted by tools)
        .replaceFirst(
          RegExp(
            r'\s+offset\s+\d+\s+rows\s+fetch\s+first\s+\d+\s+rows\s+only\s*$',
            caseSensitive: false,
          ),
          '',
        )
        .replaceFirst(
          RegExp(r'\s+fetch\s+first\s+\d+\s+rows\s+only\s*$', caseSensitive: false),
          '',
        )
        .replaceFirst(
          RegExp(r'\s+limit\s+:\w+\s*$', caseSensitive: false),
          '',
        )
        .replaceFirst(
          RegExp(r'\s+limit\s+\d+\s*$', caseSensitive: false),
          '',
        )
        .replaceFirst(
          RegExp(r'\s+offset\s+:\w+\s*$', caseSensitive: false),
          '',
        )
        .replaceFirst(
          RegExp(r'\s+offset\s+\d+\s*$', caseSensitive: false),
          '',
        );
    q = q.trimRight();
    if (q == before) break;
  }

  return q;
}
