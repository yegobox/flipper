import 'dart:io';

import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/db.dart';
import 'package:brick_sqlite/testing.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supabase_models/brick/db/schema.g.dart';
import 'package:supabase_models/brick/repository/fresh_schema_installer.dart';
import 'package:supabase_models/brick/repository/fresh_schema_snapshot.g.dart';
import 'package:test/test.dart';

const _snapshotFile = 'lib/brick/repository/fresh_schema_snapshot.g.dart';
const _regenerate =
    'cd packages/supabase_models && UPDATE_FRESH_SCHEMA=1 flutter test '
    'test/fresh_schema_installer_test.dart';

SqliteProvider _provider(String path) => SqliteProvider(
      path,
      databaseFactory: databaseFactoryFfi,
      modelDictionary: const SqliteModelDictionary({}),
    );

// ignore: invalid_use_of_protected_member
Future<Database> _db(SqliteProvider provider) => provider.getDb();

/// Replays [only] (default: every migration) the slow way, as a fresh install
/// did before the snapshot existed.
Future<SqliteProvider> _legacyMigrate(String path,
    {Set<Migration>? only}) async {
  final provider = _provider(path);
  final manager = MigrationManager(only ?? migrations);
  await provider.migrate(
    manager.migrationsSince(await provider.lastMigrationVersion()),
  );
  return provider;
}

/// The column, index and foreign-key layout of every table, for comparing two
/// databases structurally rather than by DDL text.
Future<Map<String, Object?>> _layout(Database db) async {
  final tables = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type = 'table' "
    "AND name NOT LIKE 'sqlite_%' ORDER BY name",
  );
  final layout = <String, Object?>{};
  for (final row in tables) {
    final t = row['name']! as String;
    final indexes = await db.rawQuery('PRAGMA index_list("$t")');
    layout[t] = {
      'columns': await db.rawQuery('PRAGMA table_info("$t")'),
      'fks': await db.rawQuery('PRAGMA foreign_key_list("$t")'),
      'indexes': {
        for (final i in indexes)
          i['name']: {
            'unique': i['unique'],
            'columns': (await db.rawQuery('PRAGMA index_info("${i['name']}")'))
                .map((c) => c['name'])
                .toList(),
          },
      },
    };
  }
  return layout;
}

/// Tables, columns (name, type, not-null, primary key) and indexes, with
/// names lowercased: comparable across sqflite and Turso.
Future<Map<String, Object?>> _shape(Database db) async {
  final tables = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type = 'table' "
    "AND name NOT LIKE 'sqlite_%'",
  );
  final shape = <String, Object?>{};
  for (final row in tables) {
    final t = row['name']! as String;
    if (t.toLowerCase() == 'pendinganalyticsevents') continue;
    final columns = await db.rawQuery('PRAGMA table_info("$t")');
    final indexes = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'index' "
      'AND tbl_name = ? AND sql IS NOT NULL',
      [t],
    );
    shape[t.toLowerCase()] = {
      'columns': [
        for (final c in columns)
          '${(c['name']! as String).toLowerCase()} '
              '${(c['type'] as String? ?? '').toUpperCase()} '
              'notnull=${c['notnull']} pk=${c['pk']}',
      ]..sort(),
      'indexes': [
        for (final i in indexes) (i['name']! as String).toLowerCase(),
      ]..sort(),
    };
  }
  return shape;
}

String _dartString(String s) =>
    "'${s.replaceAll(r'\', r'\\').replaceAll("'", r"\'").replaceAll(r'$', r'\$').replaceAll('\n', r'\n')}'";

String _snapshotSource(List<int> versions, List<String> statements) => '''
// GENERATED CODE - DO NOT EDIT BY HAND.
//
// The exact DDL that replaying every Brick migration in
// `lib/brick/db/schema.g.dart` produces. A new install runs it in one
// transaction (see fresh_schema_installer.dart) instead of ~1,000 separate
// migration statements. test/fresh_schema_installer_test.dart fails when this
// file no longer matches the migrations. After adding a migration, run:
//
//   $_regenerate

/// Migrations already applied by [freshSchemaStatements].
const freshSchemaMigrationVersions = <int>[
${versions.map((v) => '  $v,').join('\n')}
];

/// The schema after [freshSchemaMigrationVersions], as idempotent DDL.
const freshSchemaStatements = <String>[
${statements.map((s) => '  ${_dartString(s)},').join('\n')}
];
''';

void main() {
  sqfliteFfiInit();

  late Directory dir;
  setUp(() async {
    dir = await Directory.systemTemp.createTemp('fresh_schema');
  });
  tearDown(() async {
    await dir.delete(recursive: true);
  });

  String path(String name) => p.join(dir.path, name);

  test('the snapshot matches what the migrations build', () async {
    final legacy = await _legacyMigrate(path('legacy.sqlite'));
    final statements = await captureSchemaStatements(await _db(legacy));
    final versions = migrations.map((m) => m.version).toList()..sort();

    if (Platform.environment['UPDATE_FRESH_SCHEMA'] == '1') {
      File(_snapshotFile).writeAsStringSync(
        _snapshotSource(versions, statements),
      );
      await Process.run('dart', ['format', _snapshotFile]);
      return;
    }

    expect(
      freshSchemaMigrationVersions,
      versions,
      reason: 'A migration was added or removed. Regenerate: $_regenerate',
    );
    expect(
      freshSchemaStatements,
      statements,
      reason: 'The migrations changed the schema. Regenerate: $_regenerate',
    );
  });

  test('a fresh install gets the same database as replaying migrations',
      () async {
    final legacyWatch = Stopwatch()..start();
    final legacy = await _legacyMigrate(path('legacy.sqlite'));
    legacyWatch.stop();

    // Same order as Repository: the migration table and the analytics table
    // exist before the schema goes in.
    final fresh = _provider(path('fresh.sqlite'));
    expect(await fresh.lastMigrationVersion(), -1);
    final db = await _db(fresh);
    await db.execute(
      'CREATE TABLE IF NOT EXISTS PendingAnalyticsEvents '
      '(id INTEGER PRIMARY KEY AUTOINCREMENT)',
    );

    final freshWatch = Stopwatch()..start();
    expect(await installFreshSchemaIfEmpty(db), isTrue);
    freshWatch.stop();
    // ignore: avoid_print
    print('replaying migrations: ${legacyWatch.elapsedMilliseconds}ms, '
        'fresh install: ${freshWatch.elapsedMilliseconds}ms');

    await db.execute('DROP TABLE PendingAnalyticsEvents');
    expect(await _layout(db), await _layout(await _db(legacy)));
    expect(
      await fresh.lastMigrationVersion(),
      MigrationManager.latestMigrationVersion(migrations),
    );
    expect(
      MigrationManager(migrations)
          .migrationsSince(await fresh.lastMigrationVersion()),
      isEmpty,
    );
  });

  // Desktop's main DB is Turso, not sqflite: the snapshot must run there too,
  // inside one transaction, and give the same tables.
  test('the snapshot installs on Turso', () async {
    const backend = BrickDatabaseBackend.turso;
    await initDatabaseBackend(backend);
    final turso = SqliteProvider(
      databasePathFor(backend, name: 'fresh.db'),
      databaseFactory: databaseFactoryFor(backend),
      modelDictionary: const SqliteModelDictionary({}),
    );
    expect(await turso.lastMigrationVersion(), -1);
    final db = await _db(turso);
    final watch = Stopwatch()..start();
    expect(await installFreshSchemaIfEmpty(db), isTrue);
    // ignore: avoid_print
    print('fresh install on Turso: ${watch.elapsedMilliseconds}ms');

    // Turso lowercases names in sqlite_master, so compare the shape of each
    // table case-insensitively against sqflite replaying the migrations.
    final legacy = await _legacyMigrate(path('legacy.sqlite'));
    expect(await _shape(db), await _shape(await _db(legacy)));
    expect(
      await turso.lastMigrationVersion(),
      MigrationManager.latestMigrationVersion(migrations),
    );
    // Nothing left to migrate, and migrate() itself still runs cleanly.
    await turso.migrate(
      MigrationManager(migrations)
          .migrationsSince(await turso.lastMigrationVersion()),
    );
    await db.close();
  });

  test('a stale snapshot is finished by the newer migrations', () async {
    final sorted = migrations.toList()
      ..sort((a, b) => a.version.compareTo(b.version));
    final older = sorted.take(sorted.length - 1).toSet();
    final snapshotDb = await _db(
      await _legacyMigrate(path('older.sqlite'), only: older),
    );
    final olderStatements = await captureSchemaStatements(snapshotDb);

    final fresh = _provider(path('fresh.sqlite'));
    final db = await _db(fresh);
    expect(
      await installFreshSchemaIfEmpty(
        db,
        statements: olderStatements,
        versions: older.map((m) => m.version).toList(),
      ),
      isTrue,
    );
    await fresh.migrate(
      MigrationManager(migrations)
          .migrationsSince(await fresh.lastMigrationVersion()),
    );

    final legacy = await _legacyMigrate(path('legacy.sqlite'));
    expect(await _layout(db), await _layout(await _db(legacy)));
  });

  test('leaves a database that has been migrated alone', () async {
    final legacy = await _legacyMigrate(path('legacy.sqlite'));
    final db = await _db(legacy);
    final before = await captureSchemaStatements(db);

    expect(await installFreshSchemaIfEmpty(db), isFalse);
    expect(await captureSchemaStatements(db), before);
  });

  test('leaves tables without migration versions to the migrations', () async {
    final db = await _db(_provider(path('orphan.sqlite')));
    await db.execute('CREATE TABLE `Business` (_brick_id INTEGER PRIMARY KEY)');

    expect(await isUnmigratedDatabase(db), isFalse);
    expect(await installFreshSchemaIfEmpty(db), isFalse);
  });

  test('a failing statement rolls the whole install back', () async {
    final provider = _provider(path('broken.sqlite'));
    final db = await _db(provider);

    expect(
      await installFreshSchemaIfEmpty(
        db,
        statements: ['CREATE TABLE `A` (x INTEGER)', 'NOT VALID SQL'],
        versions: [1],
      ),
      isFalse,
    );
    expect(await isUnmigratedDatabase(db), isTrue);
    expect(await provider.lastMigrationVersion(), -1);
  });
}
