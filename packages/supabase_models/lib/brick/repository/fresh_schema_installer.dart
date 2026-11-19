import 'package:sqflite_common/sqlite_api.dart';
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';

import 'fresh_schema_snapshot.g.dart';

final _logger = Logger('FreshSchemaInstaller');

/// Brick's migration bookkeeping table. Created by
/// `SqliteProvider.lastMigrationVersion()` before any migration runs.
const migrationVersionsTable = 'MigrationVersions';

/// Tables that may already exist in a database that has never been migrated.
/// The repository creates the analytics table before it migrates. Lowercase:
/// SQLite names are case-insensitive, and Turso reports them lowercased.
const _bootstrapTables = {'migrationversions', 'pendinganalyticsevents'};

bool _isBootstrapTable(Object? name) =>
    _bootstrapTables.contains((name! as String).toLowerCase());

/// Builds a brand-new main database in one transaction from
/// [freshSchemaStatements], the exact DDL that replaying every migration
/// produces, and records [freshSchemaMigrationVersions] as applied.
///
/// Replaying the migrations instead means about 1,000 statements, each its
/// own commit. On a slow phone or a Turso replica that takes longer than the
/// startup budget, so a first launch used to fail until it had been
/// restarted a few times.
///
/// Returns false and leaves [db] untouched when it already holds tables or
/// migration versions (those take the normal migration path), or when the
/// install fails. A failure rolls the transaction back, so the caller can
/// still migrate the usual way.
Future<bool> installFreshSchemaIfEmpty(
  Database db, {
  List<String> statements = freshSchemaStatements,
  List<int> versions = freshSchemaMigrationVersions,
}) async {
  if (statements.isEmpty || versions.isEmpty) {
    return false;
  }
  try {
    if (!await isUnmigratedDatabase(db)) {
      return false;
    }
    // A batch on the database commits as one transaction on sqflite and on
    // Turso, so it is all or nothing. Not a batch inside db.transaction():
    // Turso's batch opens its own transaction, which would nest.
    final batch = db.batch();
    for (final statement in statements) {
      batch.execute(statement);
    }
    batch.execute(
      'CREATE TABLE IF NOT EXISTS $migrationVersionsTable'
      '(version INTEGER PRIMARY KEY)',
    );
    for (final version in versions) {
      batch.rawInsert(
        'INSERT OR IGNORE INTO $migrationVersionsTable(version) VALUES(?)',
        [version],
      );
    }
    await batch.commit(noResult: true);
    return true;
  } catch (e, s) {
    _logger.warning(
      'Fresh schema install failed; falling back to migrations: $e',
      e,
      s,
    );
    return false;
  }
}

/// True when [db] has no migration versions and no tables besides the ones
/// that exist before the first migration.
Future<bool> isUnmigratedDatabase(DatabaseExecutor db) async {
  final tables = await db.rawQuery(
    "SELECT name FROM sqlite_master WHERE type = 'table' "
    "AND name NOT LIKE 'sqlite_%'",
  );
  if (!tables.every((row) => _isBootstrapTable(row['name']))) {
    return false;
  }
  final hasVersionsTable = tables.any(
    (row) =>
        (row['name']! as String).toLowerCase() ==
        migrationVersionsTable.toLowerCase(),
  );
  if (!hasVersionsTable) {
    return true;
  }
  final versions = await db.rawQuery(
    'SELECT version FROM $migrationVersionsTable LIMIT 1',
  );
  return versions.isEmpty;
}

/// The schema of [db] as runnable, idempotent DDL: tables first, then
/// indexes, each group sorted by name. SQLite-internal objects, implicit
/// indexes and the bootstrap tables are left out. Used to generate and check
/// [freshSchemaStatements].
Future<List<String>> captureSchemaStatements(DatabaseExecutor db) async {
  final rows = await db.rawQuery(
    "SELECT type, name, sql FROM sqlite_master "
    "WHERE sql IS NOT NULL AND name NOT LIKE 'sqlite_%' "
    "ORDER BY CASE type WHEN 'table' THEN 0 ELSE 1 END, name",
  );
  return [
    for (final row in rows)
      if (!_isBootstrapTable(row['name'])) _idempotent(row['sql']! as String),
  ];
}

final _createPrefix = RegExp(
  r'^CREATE\s+(UNIQUE\s+)?(TABLE|INDEX|VIEW|TRIGGER)\s+(?!IF\s+NOT\s+EXISTS)',
  caseSensitive: false,
);

/// SQLite stores DDL without `IF NOT EXISTS`. Putting it back means a
/// statement replayed against a schema that already has the object (a Turso
/// replica that synced first) is a no-op instead of an error.
String _idempotent(String sql) => sql.replaceFirstMapped(
      _createPrefix,
      (m) =>
          'CREATE ${m[1] == null ? '' : 'UNIQUE '}${m[2]!.toUpperCase()} IF NOT EXISTS ',
    );
