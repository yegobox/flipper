import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

class Database {
  inBatch(Function() fn) {}
}

class ReplicatorProvider {
  final DatabaseProvider databaseProvider;

  ReplicatorProvider({required this.databaseProvider});

  Future<void> init() async {}
  Future<void> startReplicator() async {}

  // Future<AsyncCollection> get defaultCollection;
}

class DatabaseProvider {
  bool isInitialized = false;
  bool isReplicatorStarted = false;

  // Add singleton pattern to ensure single instance

  final List<String> userEncryptionKey;

  DatabaseProvider._internal(this.userEncryptionKey);

  static DatabaseProvider? _instance;

  factory DatabaseProvider(List<String> userEncryptionKey) {
    _instance ??= DatabaseProvider._internal(userEncryptionKey);
    return _instance!;
  }

  Future<DatabaseProvider> initialize() async {
    throw UnimplementedError();
  }

  Future<DatabaseProvider> initDatabases() async {
    throw UnimplementedError();
  }

  AsyncDatabase? flipperDatabase;
}

class AsyncDatabase {
  Future createCollection(String name) async {}
  Future document(String id) async {}
}

class AsyncCollection {
  Future document(String id) async {}
  Future<bool> saveDocument(MutableDocument document) async {
    throw UnimplementedError();
  }
}

abstract interface class Query {
  /// The values with which to substitute the parameters defined in the query.
  ///
  /// All parameters defined in the query must be given values before running
  /// the query, or the query will fail.
  ///
  /// The returned [Parameters] will be readonly.
  Parameters? get parameters;

  /// Sets the [parameters] of this query.
  FutureOr<void> setParameters(Parameters? value);

  /// Executes this query.
  ///
  /// Returns a [ResultSet] that iterates over [Result] rows one at a time. You
  /// can run the query any number of times, and you can have multiple
  /// [ResultSet]s active at once.
  ///
  /// The results come from a snapshot of the database taken at the moment
  /// [execute] is called, so they will not reflect any changes made to the
  /// database afterwards.
  // FutureOr<ResultSet> execute();

  /// Returns a string describing the implementation of the compiled query.
  ///
  /// This is intended to be read by a developer for purposes of optimizing the
  /// query, especially to add database indexes. It's not machine-readable and
  /// its format may change.
  ///
  /// As currently implemented, the result has three sections, separated by two
  /// newlines:
  ///
  /// - The first section is this query compiled into an SQLite query.
  /// - The second section is the output of SQLite's "EXPLAIN QUERY PLAN"
  ///   command applied to that query; for help interpreting this, see
  ///   https://www.sqlite.org/eqp.html . The most important thing to know is
  ///   that if you see "SCAN TABLE", it means that SQLite is doing a slow
  ///   linear scan of the documents instead of using an index.
  /// - The third sections is this queries JSON representation. This is the data
  ///   structure that is built to describe this query, either by the the query
  ///   builder or when an SQL++ query is compiled.
  FutureOr<String> explain();

  /// Adds a [listener] to be notified of changes to the results of this query.
  ///
  /// A new listener will be called with the current results, after being added.
  /// Subsequently it will only be called when the results change, either
  /// because the contents of the database have changed or this query's
  /// [parameters] have been changed through [setParameters].
  ///
  /// {@macro cbl.Collection.addChangeListener}
  ///
  /// See also:
  ///
  /// - [QueryChange] for the change event given to [listener].
  /// - [removeChangeListener] for removing a previously added listener.
  // FutureOr<ListenerToken> addChangeListener(QueryChangeListener listener);

  /// {@macro cbl.Collection.removeChangeListener}
  ///
  /// See also:
  ///
  /// - [addChangeListener] for listening to changes in the results of this
  ///   query.
  // FutureOr<void> removeChangeListener(ListenerToken token);

  /// Returns a [Stream] to be notified of changes to the results of this query.
  ///
  /// This is an alternative stream based API for the [addChangeListener] API.
  ///
  /// {@macro cbl.Collection.AsyncListenStream}
  Stream<QueryChange> changes();

  /// The JSON representation of this query.
  ///
  /// This value can be used to recreate this query with [Database.createQuery]
  /// and the parameter `json` set to `true`.
  ///
  /// Is `null`, if this query was created from an SQL++ query.
  String? get jsonRepresentation;

  /// The SQL++ representation of this query.
  ///
  /// This value can be used to recreate this query with [Database.createQuery].
  ///
  /// Is `null`, if this query was created through the builder API or from the
  /// JSON representation.
  String? get sqlRepresentation;
}

class MutableDocument {
  /// Creates a new [MutableDocument] with a given [id], optionally initialized
  /// with [data].
  ///
  /// {@macro cbl.MutableArray.allowedValueTypes}
  MutableDocument.withId(String id, [Map<String, Object?>? data]) {}
}

abstract interface class ResultSet {
  /// Returns a stream which consumes this result set and emits its results.
  ///
  /// A result set can only be consumed once and listening to the returned
  /// stream counts as consuming it. Other methods for consuming this result set
  /// must not be used when using a stream.
  Stream<dynamic> asStream();

  /// Returns a stream which consumes this result set and emits its results as
  /// typed dictionaries of type [D].
  ///
  /// A result set can only be consumed once and listening to the returned
  /// stream counts as consuming it. Other methods for consuming this result set
  /// must not be used when using a stream.
  // @experimental
  // Stream<D> asTypedStream<D extends TypedDictionaryObject>();

  /// Consumes this result set and returns a list of all its [Result]s.
  // FutureOr<List<Result>> allResults();

  /// Consumes this result set and returns a list of all its results as typed
  /// dictionaries of type [D].
  // @experimental
  // FutureOr<List<D>> allTypedResults<D extends TypedDictionaryObject>();
}

class Parameters {
  Object? value(String name) {}

  void setValue(Object? value, {required String name}) {}
}

@immutable
final class QueryChange<R extends ResultSet> {
  /// Creates a [Query] change event.
  const QueryChange(this.query, this.results);

  /// The query that changed.
  final Query query;

  /// The new query results.
  final R results;

  @override
  String toString() => 'QueryChange(query: $query)';
}

class AsyncQuery implements Query {
  @override
  Future<void> setParameters(Parameters? value) {
    throw UnimplementedError();
  }

  // @override
  // Future<ResultSet> execute();

  @override
  Future<String> explain() {
    throw UnimplementedError();
  }

  @override
  // TODO: implement jsonRepresentation
  String? get jsonRepresentation => throw UnimplementedError();

  @override
  // TODO: implement parameters
  Parameters? get parameters => throw UnimplementedError();

  @override
  // TODO: implement sqlRepresentation
  String? get sqlRepresentation => throw UnimplementedError();

  @override
  Stream<QueryChange<ResultSet>> changes() {
    // TODO: implement changes
    throw UnimplementedError();
  }

  // @override
  // Future<ListenerToken> addChangeListener(QueryChangeListener listener){}

  // @override
  // Future<void> removeChangeListener(ListenerToken token){}
}
