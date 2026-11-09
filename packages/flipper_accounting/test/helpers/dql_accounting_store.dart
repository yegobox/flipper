import 'dart:async';

import 'package:flipper_accounting/accounting_ditto_store.dart';

/// An [AccountingDittoStore] that evaluates the DQL the ledger reads use
/// (`SELECT * FROM c WHERE a = :x OR b IN :y …`), records every query, and
/// lets a test fire change feeds.
class DqlAccountingStore implements AccountingDittoStore {
  final Map<String, List<Map<String, dynamic>>> _rows = {};

  /// Every query run, in order.
  final List<String> queries = [];

  /// Runs before each query; may delay or throw.
  Future<void> Function(String query)? beforeQuery;

  final List<({String collection, StreamController<void> controller})> _feeds =
      [];

  void put(String collection, Map<String, dynamic> row) {
    final rows = _rows.putIfAbsent(collection, () => []);
    rows.removeWhere((r) => r['_id'] == row['_id']);
    rows.add(row);
  }

  int get activeChangeFeeds => _feeds.length;

  /// Queries against [collection] whose WHERE starts with [field].
  int queriesOf(String collection, String field) =>
      queries.where((q) => q.contains('FROM $collection WHERE $field ')).length;

  void notifyChange(String collection) {
    for (final f in List.of(_feeds)) {
      if (f.collection == collection) f.controller.add(null);
    }
  }

  /// Sends [error] down every change feed, or only [collection]'s.
  void failChangeFeeds(Object error, {String? collection}) {
    for (final f in List.of(_feeds)) {
      if (collection == null || f.collection == collection) {
        f.controller.addError(error);
      }
    }
  }

  /// Change feeds currently open on [collection].
  int changeFeedsOn(String collection) =>
      _feeds.where((f) => f.collection == collection).length;

  static final _select = RegExp(r'^SELECT \* FROM (\w+) WHERE (.+)$');
  static final _term = RegExp(r'^(\w+) (=|IN) :(\w+)$');

  @override
  Future<List<Map<String, dynamic>>> queryCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) async {
    queries.add(query);
    await beforeQuery?.call(query);
    final m = _select.firstMatch(query.trim());
    if (m == null) throw UnsupportedError('DQL not modelled: $query');
    final terms = [
      for (final t in m.group(2)!.split(' OR '))
        _term.firstMatch(t.trim()) ??
            (throw UnsupportedError('DQL term not modelled: $t')),
    ];
    bool matches(Map<String, dynamic> row) {
      for (final t in terms) {
        final value = row[t.group(1)!];
        final arg = args[t.group(3)!];
        if (t.group(2) == '=' ? value == arg : (arg as List).contains(value)) {
          return true;
        }
      }
      return false;
    }

    return [
      for (final row in _rows[m.group(1)!] ?? const <Map<String, dynamic>>[])
        if (matches(row)) Map<String, dynamic>.from(row),
    ];
  }

  @override
  Stream<List<Map<String, dynamic>>> watchCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) => Stream.fromFuture(queryCollection(collection, query, args));

  @override
  Stream<void> watchChanges(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) {
    late final ({String collection, StreamController<void> controller}) feed;
    final controller = StreamController<void>(
      onCancel: () => _feeds.remove(feed),
    );
    feed = (collection: collection, controller: controller);
    _feeds.add(feed);
    return controller.stream;
  }

  @override
  bool isReady() => true;

  @override
  bool isCloudReady() => true;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnsupportedError('${invocation.memberName} not used by reads');
}
