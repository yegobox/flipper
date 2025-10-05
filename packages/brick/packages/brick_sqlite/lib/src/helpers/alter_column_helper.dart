import 'package:brick_sqlite/src/db/migration_commands/drop_column.dart';
import 'package:brick_sqlite/src/db/migration_commands/insert_column.dart';
import 'package:brick_sqlite/src/db/migration_commands/migration_command.dart';
import 'package:brick_sqlite/src/db/migration_commands/rename_column.dart';
import 'package:sqflite_common/sqlite_api.dart' show Database;

/// Workaround for SQLite commands that require altering the table instead of the column.
///
/// Supports [DropColumn], [RenameColumn], [InsertColumn]
class AlterColumnHelper {
  /// The command to restructure the table
  final MigrationCommand command;

  ///
  bool get isDrop => command is DropColumn;

  ///
  bool get isRename => command is RenameColumn;

  ///
  bool get isUniqueInsert =>
      command is InsertColumn && (command as InsertColumn).unique;

  /// Declares if this command requires extra SQLite work to be migrated
  bool get requiresSchema => isDrop || isRename || isUniqueInsert;

  ///
  String get tableName {
    assert(requiresSchema, 'Command does not require schema');

    if (isDrop) {
      return (command as DropColumn).onTable;
    }

    if (isRename) {
      return (command as RenameColumn).onTable;
    }

    return (command as InsertColumn).onTable;
  }

  /// Workaround for SQLite commands that require altering the table instead of the column.
  ///
  /// Supports [DropColumn], [RenameColumn], [InsertColumn]
  const AlterColumnHelper(this.command);

  /// Get info about existing columns
  Future<List<Map<String, dynamic>>> tableInfo(Database db) async =>
      await db.rawQuery('PRAGMA table_info("$tableName");');

  /// Create new table with updated column data
  List<Map<String, dynamic>> _newColumns(List<Map<String, dynamic>> columns) {
    Map<String, dynamic>? convertColumn(Map<String, dynamic> column) {
      final newColumn = Map<String, dynamic>.from(column);

      if (isDrop) {
        final oldColumnName = (command as DropColumn).name;
        if (column['name'] == oldColumnName) {
          return null;
        }
      }

      if (isRename) {
        final oldColumnName = (command as RenameColumn).oldName;
        final newColumnName = (command as RenameColumn).newName;
        if (column['name'] == oldColumnName) {
          newColumn['name'] = newColumnName;
        }
      }

      if (isUniqueInsert) {
        final name = (command as InsertColumn).name;
        if (column['name'] == name) {
          newColumn['unique'] = true;
        }
      }

      return newColumn;
    }

    return columns
        .map(convertColumn)
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  /// Given new columns, create the SQLite statement
  String _newColumnsExpression(List<Map<String, dynamic>> columns) =>
      columns.map((Map<String, dynamic> column) {
        final definition = [column['name'] as String, column['type'] as String];

        if (column['notnull'] == 1) {
          definition.add('NOT NULL');
        }

        if (column['dflt_value'] != null) {
          definition.add('DEFAULT ${column['dflt_value']}');
        }

        if (column['pk'] == 1) {
          definition.add('PRIMARY KEY');
        }

        if (column['unique'] == true) {
          definition.add('UNIQUE');
        }

        return definition.join(' ');
      }).join(', ');

  /// Perform the necessary SQLite operation
  Future<void> execute(Database db) async {
    // For unique insert columns, check if column already exists before attempting to add it
    if (isUniqueInsert && command.statement != null) {
      final columns = await tableInfo(db);
      final columnName = (command as InsertColumn).name;

      // Check if column already exists
      final columnExists = columns.any((col) => col['name'] == columnName);

      if (columnExists) {
        // Column already exists, check if it needs UNIQUE constraint
        final existingColumn =
            columns.firstWhere((col) => col['name'] == columnName);

        // If column exists but doesn't have unique constraint, we need to add it
        // This requires the full table reconstruction below
        if (existingColumn['unique'] != true && existingColumn['pk'] != 1) {
          // Continue with table reconstruction to add UNIQUE constraint
        } else {
          // Column already exists with proper constraints, skip this migration
          return;
        }
      } else {
        // Column doesn't exist, add it first
        try {
          await db.execute(command.statement!);
        } catch (e) {
          if (e.toString().contains('duplicate column name')) {
            // Column was just added by another process, continue
          } else {
            rethrow;
          }
        }
      }
    }

    final columns = await tableInfo(db);
    final newColumns = _newColumns(columns);
    final newColumnsExpression = _newColumnsExpression(newColumns);
    final oldColumnNames = columns.map((c) => c['name']).join(', ');
    final newColumnNames = newColumns.map((c) => c['name']).join(', ');
    final selectExpression = isDrop ? newColumnNames : oldColumnNames;

    await db.execute('PRAGMA foreign_keys = OFF');
    await db.execute('PRAGMA legacy_alter_table = ON');
    await db.transaction((txn) async {
      // Rename existing table
      await txn.execute('ALTER TABLE `$tableName` RENAME TO `temp_$tableName`');

      // Setup new table
      await txn.execute('CREATE TABLE `$tableName` ($newColumnsExpression)');

      // Copy data
      await txn.execute(
        'INSERT INTO `$tableName`($newColumnNames) SELECT $selectExpression FROM `temp_$tableName`',
      );

      // Drop old table
      await txn.execute('DROP TABLE `temp_$tableName`');
    });
    await db.execute('PRAGMA legacy_alter_table = OFF');
    await db.execute('PRAGMA foreign_keys = ON');
  }
}
