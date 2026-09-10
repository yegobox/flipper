import 'dart:async';

/// An in-memory stand-in for the Ditto store, enough to exercise the DQL the
/// hotel and bar mixins actually issue.
///
/// The mixins reach Ditto through `dynamic`, so a plain Dart object satisfies
/// them. This is not a general DQL engine: it supports exactly the statement
/// shapes in use — see [_Where] for the grammar — and throws loudly on
/// anything else so an unsupported query fails the test rather than silently
/// matching nothing.
class FakeDitto {
  final store = FakeDittoStore();
  final sync = FakeDittoSync();
}

class FakeDittoSync {
  final registered = <({String dql, Map<String, dynamic>? arguments})>[];

  void registerSubscription(String dql, {Map<String, dynamic>? arguments}) {
    registered.add((dql: dql, arguments: arguments));
  }
}

class FakeDittoItem {
  FakeDittoItem(this.value);
  final Map<String, dynamic> value;
}

class FakeDittoResult {
  FakeDittoResult(this.items);
  final List<FakeDittoItem> items;
}

class FakeDittoObserver {
  FakeDittoObserver(this._onCancel);
  final void Function() _onCancel;
  bool cancelled = false;

  Future<void> cancel() async {
    cancelled = true;
    _onCancel();
  }
}

class _Registered {
  _Registered(this.sql, this.arguments, this.onChange);
  final String sql;
  final Map<String, dynamic> arguments;
  final void Function(FakeDittoResult) onChange;
}

class FakeDittoStore {
  /// collection -> documentId -> document
  final Map<String, Map<String, Map<String, dynamic>>> collections = {};

  final List<_Registered> _observers = [];

  /// Every statement executed, in order — lets a test assert that a code path
  /// did not, say, hydrate a model it did not need.
  final List<String> executed = [];

  List<Map<String, dynamic>> docs(String collection) =>
      collections[collection]?.values.toList() ?? const [];

  /// Seeds a document without going through DQL.
  void seed(String collection, Map<String, dynamic> doc) {
    final id = (doc['_id'] ?? doc['id']).toString();
    collections.putIfAbsent(collection, () => {})[id] = {...doc};
  }

  Future<FakeDittoResult> execute(
    String sql, {
    Map<String, dynamic>? arguments,
  }) async {
    executed.add(sql);
    final args = arguments ?? const <String, dynamic>{};
    final trimmed = sql.trim();
    final upper = trimmed.toUpperCase();

    if (upper.startsWith('SELECT')) return _select(trimmed, args);
    if (upper.startsWith('INSERT')) return _insert(trimmed, args);
    if (upper.startsWith('UPDATE')) return _update(trimmed, args);
    if (upper.startsWith('DELETE')) return _delete(trimmed, args);

    throw UnsupportedError('FakeDitto cannot run: $sql');
  }

  FakeDittoObserver registerObserver(
    String sql, {
    Map<String, dynamic>? arguments,
    required void Function(FakeDittoResult) onChange,
  }) {
    final entry = _Registered(sql, arguments ?? const {}, onChange);
    _observers.add(entry);
    return FakeDittoObserver(() => _observers.remove(entry));
  }

  void _notify() {
    for (final observer in List.of(_observers)) {
      unawaited(
        execute(observer.sql, arguments: observer.arguments)
            .then(observer.onChange),
      );
    }
  }

  // --- statements ---------------------------------------------------------

  static final _selectRe = RegExp(
    r'^SELECT\s+.+?\s+FROM\s+(\w+)(?:\s+WHERE\s+(.*?))?'
    r'(?:\s+ORDER\s+BY\s+(\w+)\s+(ASC|DESC))?(?:\s+LIMIT\s+(\d+))?$',
    caseSensitive: false,
    dotAll: true,
  );

  FakeDittoResult _select(String sql, Map<String, dynamic> args) {
    final m = _selectRe.firstMatch(sql.replaceAll(RegExp(r'\s+'), ' '));
    if (m == null) throw UnsupportedError('FakeDitto cannot parse: $sql');

    final collection = m.group(1)!;
    final where = m.group(2);
    final orderBy = m.group(3);
    final descending = (m.group(4) ?? 'ASC').toUpperCase() == 'DESC';
    final limit = m.group(5) == null ? null : int.parse(m.group(5)!);

    var rows = docs(collection)
        .where((doc) => _Where.matches(where, doc, args))
        .toList();

    if (orderBy != null) {
      rows.sort((a, b) {
        final l = _comparable(a[orderBy]);
        final r = _comparable(b[orderBy]);
        final cmp = l.compareTo(r);
        return descending ? -cmp : cmp;
      });
    }
    if (limit != null && rows.length > limit) rows = rows.sublist(0, limit);

    return FakeDittoResult([
      for (final row in rows) FakeDittoItem(Map<String, dynamic>.from(row)),
    ]);
  }

  static final _insertRe = RegExp(
    r'^INSERT\s+INTO\s+(\w+)\s+DOCUMENTS\s+\(:(\w+)\)(\s+ON\s+ID\s+CONFLICT\s+DO\s+UPDATE)?$',
    caseSensitive: false,
  );

  FakeDittoResult _insert(String sql, Map<String, dynamic> args) {
    final m = _insertRe.firstMatch(sql.replaceAll(RegExp(r'\s+'), ' ').trim());
    if (m == null) throw UnsupportedError('FakeDitto cannot parse: $sql');

    final collection = m.group(1)!;
    final doc = Map<String, dynamic>.from(args[m.group(2)!] as Map);
    final upsert = m.group(3) != null;
    final id = (doc['_id'] ?? doc['id']).toString();

    final store = collections.putIfAbsent(collection, () => {});
    if (store.containsKey(id) && !upsert) {
      // Real Ditto rejects a duplicate _id without ON ID CONFLICT.
      throw StateError('duplicate _id $id in $collection');
    }
    store[id] = doc;
    _notify();
    return FakeDittoResult(const []);
  }

  static final _updateRe = RegExp(
    r'^UPDATE\s+(\w+)\s+SET\s+(.*?)\s+WHERE\s+(.*)$',
    caseSensitive: false,
  );

  FakeDittoResult _update(String sql, Map<String, dynamic> args) {
    final m = _updateRe.firstMatch(sql.replaceAll(RegExp(r'\s+'), ' ').trim());
    if (m == null) throw UnsupportedError('FakeDitto cannot parse: $sql');

    final collection = m.group(1)!;
    final assignments = _parseAssignments(m.group(2)!, args);
    final where = m.group(3);

    for (final doc in docs(collection)) {
      if (!_Where.matches(where, doc, args)) continue;
      final id = (doc['_id'] ?? doc['id']).toString();
      collections[collection]![id] = {...doc, ...assignments};
    }
    _notify();
    return FakeDittoResult(const []);
  }

  static final _deleteRe = RegExp(
    r'^DELETE\s+FROM\s+(\w+)\s+WHERE\s+(.*)$',
    caseSensitive: false,
  );

  FakeDittoResult _delete(String sql, Map<String, dynamic> args) {
    final m = _deleteRe.firstMatch(sql.replaceAll(RegExp(r'\s+'), ' ').trim());
    if (m == null) throw UnsupportedError('FakeDitto cannot parse: $sql');

    final collection = m.group(1)!;
    final where = m.group(2);

    final doomed = docs(collection)
        .where((doc) => _Where.matches(where, doc, args))
        .map((doc) => (doc['_id'] ?? doc['id']).toString())
        .toList();
    for (final id in doomed) {
      collections[collection]!.remove(id);
    }
    _notify();
    return FakeDittoResult(const []);
  }

  Map<String, dynamic> _parseAssignments(
    String clause,
    Map<String, dynamic> args,
  ) {
    final out = <String, dynamic>{};
    for (final part in clause.split(',')) {
      final bits = part.split('=');
      if (bits.length != 2) {
        throw UnsupportedError('FakeDitto cannot parse assignment: $part');
      }
      out[bits[0].trim()] = _Where.value(bits[1].trim(), args);
    }
    return out;
  }

  static Comparable<Object> _comparable(dynamic v) {
    if (v is num) return v;
    return v?.toString() ?? '';
  }
}

/// Predicate grammar: conjunctions of terms, where a term is
/// `field = :param`, `field = 'literal'`, `field IN (…)`, `field IS NOT NULL`,
/// or a parenthesised `a OR b`.
abstract final class _Where {
  static bool matches(
    String? clause,
    Map<String, dynamic> doc,
    Map<String, dynamic> args,
  ) {
    if (clause == null || clause.trim().isEmpty) return true;
    return _and(clause.trim(), doc, args);
  }

  static bool _and(String clause, Map<String, dynamic> doc, Map<String, dynamic> args) {
    for (final part in _split(clause, ' AND ')) {
      if (!_or(part, doc, args)) return false;
    }
    return true;
  }

  static bool _or(String clause, Map<String, dynamic> doc, Map<String, dynamic> args) {
    final stripped = _stripParens(clause.trim());
    final parts = _split(stripped, ' OR ');
    if (parts.length > 1) {
      return parts.any((part) => _term(part, doc, args));
    }
    return _term(stripped, doc, args);
  }

  static final _isNotNull = RegExp(r'^(\w+)\s+IS\s+NOT\s+NULL$', caseSensitive: false);
  static final _inList = RegExp(r"^(\w+)\s+IN\s+\((.*)\)$", caseSensitive: false);
  static final _eq = RegExp(r'^(\w+)\s*=\s*(.+)$');

  static bool _term(String clause, Map<String, dynamic> doc, Map<String, dynamic> args) {
    final term = _stripParens(clause.trim());

    final nn = _isNotNull.firstMatch(term);
    if (nn != null) return doc[nn.group(1)!] != null;

    final inm = _inList.firstMatch(term);
    if (inm != null) {
      final field = doc[inm.group(1)!];
      final options = inm
          .group(2)!
          .split(',')
          .map((raw) => value(raw.trim(), args))
          .expand((v) => v is Iterable ? v : [v]);
      return options.any((option) => _same(field, option));
    }

    final eq = _eq.firstMatch(term);
    if (eq != null) {
      return _same(doc[eq.group(1)!], value(eq.group(2)!.trim(), args));
    }

    throw UnsupportedError('FakeDitto cannot parse predicate: $clause');
  }

  /// Ditto stores numbers as strings often enough that equality has to be
  /// forgiving, matching how the production adapters read documents back.
  static bool _same(dynamic a, dynamic b) {
    if (a == null || b == null) return a == b;
    if (a == b) return true;
    return a.toString() == b.toString();
  }

  static dynamic value(String token, Map<String, dynamic> args) {
    if (token.startsWith(':')) return args[token.substring(1)];
    if (token.startsWith("'") && token.endsWith("'")) {
      return token.substring(1, token.length - 1);
    }
    final asNum = num.tryParse(token);
    return asNum ?? token;
  }

  static String _stripParens(String s) {
    var out = s.trim();
    while (out.startsWith('(') && out.endsWith(')') && _balanced(out)) {
      out = out.substring(1, out.length - 1).trim();
    }
    return out;
  }

  static bool _balanced(String s) {
    var depth = 0;
    for (var i = 0; i < s.length; i++) {
      if (s[i] == '(') depth++;
      if (s[i] == ')') {
        depth--;
        if (depth == 0 && i != s.length - 1) return false;
      }
    }
    return depth == 0;
  }

  /// Splits on [sep] at paren depth zero, so `(a OR b) AND c` survives.
  static List<String> _split(String clause, String sep) {
    final out = <String>[];
    var depth = 0;
    var start = 0;
    final upper = clause.toUpperCase();
    for (var i = 0; i < clause.length; i++) {
      if (clause[i] == '(') depth++;
      if (clause[i] == ')') depth--;
      if (depth == 0 && upper.startsWith(sep, i)) {
        out.add(clause.substring(start, i));
        start = i + sep.length;
        i += sep.length - 1;
      }
    }
    out.add(clause.substring(start));
    return out.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }
}
