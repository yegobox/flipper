import 'dart:io';

import 'package:logging/logging.dart';
import 'package:sqlite3/sqlite3.dart';

final _logger = Logger('TursoPreflightRepair');

/// Repairs known Turso migration corruption **before** Turso opens the replica.
///
/// Failed [AlterColumnHelper] rebuilds on `BranchSmsConfig` have left:
/// - indexes pointing at dropped `temp_branchsmsconfig`
/// - duplicate `sqlite_master` rows for `BranchSmsConfig` / `branchsmsconfig`
///
/// Those break Turso open with `table "branchsmsconfig" already exists` /
/// `no such table: main.temp_branchsmsconfig`. Local SMS config is cheap to
/// rebuild from Supabase; prefer an empty healthy table over a brick.
void repairTursoMigrationCorruptionIfNeeded(String localDbPath) {
  final file = File(localDbPath);
  if (!file.existsSync() || file.lengthSync() == 0) {
    return;
  }

  Database? db;
  try {
    db = sqlite3.open(localDbPath);
    final needsRepair = _needsBranchSmsConfigRepair(db);
    if (!needsRepair) {
      return;
    }

    _logger.warning(
      'Repairing BranchSmsConfig Turso migration corruption at $localDbPath',
    );

    db.execute('PRAGMA writable_schema=ON');
    db.execute(
      "DELETE FROM sqlite_master WHERE type='index' AND sql LIKE '%temp_%'",
    );
    // Keep one table entry; Turso case-folding can leave a ghost lowercase twin.
    final tables = db.select(
      "SELECT rowid, name FROM sqlite_master WHERE type='table' "
      "AND lower(name)='branchsmsconfig' ORDER BY rowid",
    );
    if (tables.length > 1) {
      for (var i = 1; i < tables.length; i++) {
        final rowid = tables[i]['rowid'];
        db.execute('DELETE FROM sqlite_master WHERE rowid=?', [rowid]);
      }
    }
    db.execute('PRAGMA writable_schema=OFF');

    // If schema is still unusable, recreate an empty BranchSmsConfig.
    // Channel flags rehydrate from Supabase `branch_sms_configs`.
    try {
      db.select('PRAGMA table_info(BranchSmsConfig)');
      db.select('SELECT COUNT(*) AS c FROM BranchSmsConfig');
    } catch (e) {
      _logger.warning(
        'BranchSmsConfig still unreadable ($e); recreating empty table',
      );
      db.execute('DROP TABLE IF EXISTS BranchSmsConfig');
      db.execute('DROP TABLE IF EXISTS branchsmsconfig');
      db.execute('''
        CREATE TABLE BranchSmsConfig (
          _brick_id INTEGER PRIMARY KEY AUTOINCREMENT,
          id VARCHAR UNIQUE,
          branch_id VARCHAR,
          sms_phone_number VARCHAR,
          enable_sms INTEGER,
          enable_whatsapp INTEGER
        )
      ''');
      db.execute(
        'CREATE UNIQUE INDEX IF NOT EXISTS index_BranchSmsConfig_on_id '
        'ON BranchSmsConfig ("id")',
      );
    }

    try {
      db.execute('PRAGMA wal_checkpoint(TRUNCATE)');
    } catch (_) {}
  } catch (e, s) {
    _logger.warning(
      'Turso preflight repair failed for $localDbPath: $e',
      e,
      s,
    );
  } finally {
    db?.dispose();
  }
}

bool _needsBranchSmsConfigRepair(Database db) {
  try {
    final badIndexes = db.select(
      "SELECT name, sql FROM sqlite_master WHERE type='index' "
      "AND sql LIKE '%temp_%'",
    );
    for (final row in badIndexes) {
      final sql = row['sql']?.toString() ?? '';
      if (sql.toLowerCase().contains('temp_')) {
        return true;
      }
    }

    final tables = db.select(
      "SELECT name FROM sqlite_master WHERE type='table' "
      "AND lower(name)='branchsmsconfig'",
    );
    if (tables.length > 1) {
      return true;
    }

    // Probe readability — malformed schema often surfaces here.
    db.select('SELECT 1 FROM BranchSmsConfig LIMIT 1');
    return false;
  } catch (e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('temp_branch') ||
        msg.contains('branchsmsconfig') ||
        msg.contains('malformed') ||
        msg.contains('already exists');
  }
}
