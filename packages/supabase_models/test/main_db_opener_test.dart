import 'dart:async';
import 'dart:io';

import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/db.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supabase_models/brick/db/schema.g.dart';
import 'package:supabase_models/brick/repository/main_db_opener.dart';
import 'package:test/test.dart';

/// Runs the app's Brick migrations the way OfflineFirstRepository.migrate
/// does, without the models (migrations don't need them).
Future<SqliteProvider> _migrate(String path, DatabaseFactory factory) async {
  final provider = SqliteProvider(
    path,
    databaseFactory: factory,
    modelDictionary: SqliteModelDictionary(const {}),
  );
  final manager = MigrationManager(migrations);
  await provider.migrate(
    manager.migrationsSince(await provider.lastMigrationVersion()),
  );
  return provider;
}

Future<void> _close(SqliteProvider provider) async =>
    // ignore: invalid_use_of_protected_member
    (await provider.getDb()).close();

Future<Map<String, List<String>>> _schema(String path) async {
  final db = await databaseFactoryFfi.openDatabase(path);
  try {
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' "
      "AND name NOT LIKE 'sqlite_%' ORDER BY name",
    );
    final schema = <String, List<String>>{};
    for (final row in tables) {
      final table = row['name']! as String;
      final columns = await db.rawQuery('PRAGMA table_info(`$table`)');
      schema[table] = [for (final c in columns) c['name']! as String]..sort();
    }
    return schema;
  } finally {
    await db.close();
  }
}

void main() {
  sqfliteFfiInit();

  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('main_db_opener_'));
  tearDown(() => dir.deleteSync(recursive: true));

  LocalDbTier tier(String name,
          {Future<bool> Function(List<LocalDbTierFailure>)? prepare,
          Duration? timeout}) =>
      LocalDbTier(
        name: name,
        path: p.join(dir.path, '$name.sqlite'),
        factory: () => databaseFactoryFfi,
        prepare: prepare,
        timeout: timeout ?? const Duration(seconds: 15),
      );

  group('openFirstWorkingTier', () {
    test('falls through to the next tier and records why', () async {
      final result = await openFirstWorkingTier<String>(
        tiers: [tier('a'), tier('b')],
        attempt: (t) async =>
            t.name == 'a' ? throw StateError('broken') : t.name,
      );
      expect(result.value, 'b');
      expect(result.tier.name, 'b');
      expect(result.failures.single.tier, 'a');
    });

    test('a prepare hook returning false skips the tier', () async {
      final tried = <String>[];
      final result = await openFirstWorkingTier<String>(
        tiers: [tier('a', prepare: (_) async => false), tier('b')],
        attempt: (t) async {
          tried.add(t.name);
          return t.name;
        },
      );
      expect(result.value, 'b');
      expect(tried, ['b']);
      expect(result.failures, isEmpty);
    });

    test('a hung tier times out and its late result is discarded', () async {
      final hung = Completer<String>();
      final discarded = <String>[];
      final result = await openFirstWorkingTier<String>(
        tiers: [
          tier('slow', timeout: const Duration(milliseconds: 50)),
          tier('b'),
        ],
        attempt: (t) => t.name == 'slow' ? hung.future : Future.value('b'),
        discardLate: (v) async => discarded.add(v),
      );
      expect(result.value, 'b');
      expect(result.failures.single.error, isA<TimeoutException>());

      hung.complete('late');
      await Future<void>.delayed(Duration.zero);
      expect(discarded, ['late']);
    });

    test('throws only when every tier fails', () async {
      expect(
        openFirstWorkingTier<String>(
          tiers: [tier('a'), tier('b')],
          attempt: (_) async => throw StateError('nope'),
        ),
        throwsA(isA<StateError>()
            .having((e) => e.message, 'message', contains('a: '))),
      );
    });
  });

  group('freshFileAfterCorruption', () {
    test('moves a corrupt database aside, keeping it for recovery', () async {
      final path = p.join(dir.path, 'main.sqlite');
      File(path).writeAsStringSync('not a database');
      File('$path-wal').writeAsStringSync('x');

      final proceed = await freshFileAfterCorruption(path)(
        [
          LocalDbTierFailure(
              'sqflite', Exception('file is not a database'), StackTrace.empty)
        ],
      );

      expect(proceed, isTrue);
      expect(File(path).existsSync(), isFalse);
      expect(File('$path-wal').existsSync(), isFalse);
      final moved = dir
          .listSync()
          .map((e) => p.basename(e.path))
          .where((n) => n.contains('.corrupt-'));
      expect(moved, hasLength(2));
    });

    test('leaves a locked or slow database alone', () async {
      final path = p.join(dir.path, 'main.sqlite');
      File(path).writeAsStringSync('healthy but busy');
      final hook = freshFileAfterCorruption(path);

      expect(
        await hook([
          LocalDbTierFailure(
              'sqflite', Exception('database is locked'), StackTrace.empty)
        ]),
        isFalse,
      );
      expect(
        await hook([
          LocalDbTierFailure(
              'sqflite', TimeoutException('slow'), StackTrace.empty)
        ]),
        isFalse,
      );
      expect(File(path).readAsStringSync(), 'healthy but busy');
    });
  });

  group('Brick migrations on phone SQLite', () {
    test('apply on a SQLite without RENAME/DROP COLUMN (Android 8–10)',
        () async {
      final modern = p.join(dir.path, 'modern.sqlite');
      final old = p.join(dir.path, 'old.sqlite');

      await _close(await _migrate(modern, databaseFactoryFfi));
      final oldFactory = _OldSqliteFactory(databaseFactoryFfi);
      await _close(await _migrate(old, oldFactory));

      expect(oldFactory.refused, isNotEmpty,
          reason: 'the migrations should exercise the fallback');
      expect(await _schema(old), await _schema(modern));
    });

    test('a corrupt file opens fresh on the next tier', () async {
      final path = p.join(dir.path, 'flipper_mobile.sqlite');
      File(path).writeAsStringSync('garbage, not sqlite' * 100);

      final result = await openFirstWorkingTier<SqliteProvider>(
        tiers: [
          LocalDbTier(
            name: 'sqflite',
            path: path,
            factory: () => databaseFactoryFfi,
          ),
          LocalDbTier(
            name: 'sqflite-fresh',
            path: path,
            factory: () => databaseFactoryFfi,
            prepare: freshFileAfterCorruption(path),
          ),
        ],
        attempt: (t) async {
          final provider = SqliteProvider(
            t.path,
            databaseFactory: t.factory(),
            modelDictionary: SqliteModelDictionary(const {}),
          );
          try {
            await provider.migrate(MigrationManager(migrations)
                .migrationsSince(await provider.lastMigrationVersion()));
            return provider;
          } catch (_) {
            try {
              await _close(provider);
            } catch (_) {}
            rethrow;
          }
        },
      );

      expect(result.tier.name, 'sqflite-fresh');
      expect(result.failures.single.tier, 'sqflite');
      expect(await result.value.lastMigrationVersion(),
          MigrationManager.latestMigrationVersion(migrations.toList()));
      await _close(result.value);
    });
  });
}

/// Refuses the ALTER forms that SQLite < 3.25 / < 3.35 do not have, the way
/// the system SQLite on older Android does.
class _OldSqliteFactory implements DatabaseFactory {
  _OldSqliteFactory(this._inner);
  final DatabaseFactory _inner;
  final refused = <String>[];

  @override
  Future<Database> openDatabase(String path,
          {OpenDatabaseOptions? options}) async =>
      _OldSqliteDatabase(
          await _inner.openDatabase(path, options: options), refused);

  @override
  Future<bool> databaseExists(String path) => _inner.databaseExists(path);

  @override
  Future<void> deleteDatabase(String path) => _inner.deleteDatabase(path);

  @override
  Future<String> getDatabasesPath() => _inner.getDatabasesPath();

  @override
  Future<void> setDatabasesPath(String path) => _inner.setDatabasesPath(path);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _OldSqliteDatabase implements Database {
  _OldSqliteDatabase(this._inner, this._refused);
  final Database _inner;
  final List<String> _refused;

  void _check(String sql) {
    final upper = sql.toUpperCase();
    if (upper.contains('RENAME COLUMN') || upper.contains('DROP COLUMN')) {
      _refused.add(sql);
      throw _SyntaxError('near "COLUMN": syntax error');
    }
  }

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) {
    _check(sql);
    return _inner.execute(sql, arguments);
  }

  @override
  Future<List<Map<String, Object?>>> rawQuery(String sql,
          [List<Object?>? arguments]) =>
      _inner.rawQuery(sql, arguments);

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) =>
      _inner.query(table,
          distinct: distinct,
          columns: columns,
          where: where,
          whereArgs: whereArgs,
          groupBy: groupBy,
          having: having,
          orderBy: orderBy,
          limit: limit,
          offset: offset);

  @override
  Future<int> insert(String table, Map<String, Object?> values,
          {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm}) =>
      _inner.insert(table, values,
          nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);

  @override
  Future<int> update(String table, Map<String, Object?> values,
          {String? where,
          List<Object?>? whereArgs,
          ConflictAlgorithm? conflictAlgorithm}) =>
      _inner.update(table, values,
          where: where,
          whereArgs: whereArgs,
          conflictAlgorithm: conflictAlgorithm);

  @override
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) =>
      _inner.delete(table, where: where, whereArgs: whereArgs);

  @override
  Future<int> rawInsert(String sql, [List<Object?>? arguments]) =>
      _inner.rawInsert(sql, arguments);

  @override
  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) =>
      _inner.rawUpdate(sql, arguments);

  @override
  Future<int> rawDelete(String sql, [List<Object?>? arguments]) =>
      _inner.rawDelete(sql, arguments);

  @override
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action,
          {bool? exclusive}) =>
      _inner.transaction(action, exclusive: exclusive);

  @override
  Batch batch() => _inner.batch();

  @override
  Future<void> close() => _inner.close();

  @override
  String get path => _inner.path;

  @override
  bool get isOpen => _inner.isOpen;

  @override
  Database get database => this;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SyntaxError implements Exception {
  _SyntaxError(this.message);
  final String message;
  @override
  String toString() => 'DatabaseException($message)';
}
