import 'package:sqlite3/sqlite3.dart';

class SqliteService {
  /// Safely adds a column to a table only if it doesn't already exist.
  static void addColumnIfNotExists(String dbPath, String tableName,
      String columnName, String columnDefinition) {
    Database? db;
    try {
      db = sqlite3.open(dbPath);

      // Get existing columns in the table
      final result = db.select('PRAGMA table_info($tableName)');
      final columnExists = result.any((row) => row['name'] == columnName);

      if (!columnExists) {
        final alterSql =
            'ALTER TABLE $tableName ADD COLUMN $columnName $columnDefinition';
        db.execute(alterSql);
      } else {
        print(
            'Column "$columnName" already exists in table "$tableName". Skipping ALTER.');
      }
    } catch (e) {
      print('SQLite addColumnIfNotExists error: $e');
      rethrow;
    } finally {
      db?.dispose();
    }
  }

  /// Executes a raw SQL statement on the given database path.
  /// [dbPath]: Path to the SQLite database file.
  /// [sql]: The SQL statement to execute.
  /// [params]: Optional parameters for the SQL statement.
  /// Returns the number of affected rows (for update/delete statements).
  /// Throws an exception if the execution fails.
  static int execute(String dbPath, String sql,
      [List<Object?> params = const []]) {
    Database? db;
    try {
      db = sqlite3.open(dbPath);
      final stmt = db.prepare(sql);
      try {
        stmt.execute(params);
        // SQLite implicitly commits transactions after each statement
        // unless a transaction is explicitly started.  We don't need COMMIT.
        return db.updatedRows; // Return number of rows affected.
      } finally {
        stmt.dispose();
      }
    } catch (e) {
      // Log the error and rethrow for the caller to handle.
      print('SQLite execute error: $e');
      rethrow; // Important: rethrow the exception
    } finally {
      db?.dispose(); // Ensure disposal even on error.
    }
  }

  /// Executes a raw select query and returns the result as a list of maps.
  /// Throws an exception if the query fails.
  static List<Map<String, Object?>> select(String dbPath, String sql,
      [List<Object?> params = const []]) {
    Database? db;
    try {
      db = sqlite3.open(dbPath);
      final result = db.select(sql, params);
      return result.map((row) => Map<String, Object?>.from(row)).toList();
    } catch (e) {
      // Log the error and rethrow.
      print('SQLite select error: $e');
      rethrow;
    } finally {
      db?.dispose(); // Ensure disposal.
    }
  }

  /// Executes a batch of SQL statements within a transaction. This is
  /// crucial for maintaining data consistency when multiple operations
  /// need to be performed atomically.
  ///
  /// [dbPath]: Path to the SQLite database file.
  /// [statements]: A list of SQL statements to execute.
  /// [paramsList]: A list of parameters for each SQL statement, corresponding
  ///               to the order of the statements in the [statements] list.
  ///               If a statement doesn't require parameters, provide an empty
  ///               list for it.
  ///
  /// Throws an exception if any statement fails, rolling back the entire
  /// transaction.  Returns the number of rows changed across the whole transaction.
  static int executeTransaction(
      String dbPath, List<String> statements, List<List<Object?>> paramsList) {
    if (statements.length != paramsList.length) {
      throw ArgumentError(
          'The number of statements must match the number of parameter lists.');
    }

    Database? db;
    int totalChanges = 0;

    try {
      db = sqlite3.open(dbPath);
      db.execute('BEGIN TRANSACTION');

      for (int i = 0; i < statements.length; i++) {
        final stmt = db.prepare(statements[i]);
        try {
          stmt.execute(paramsList[i]);
          totalChanges += db.updatedRows; // Accumulate changes.
        } finally {
          stmt.dispose();
        }
      }

      db.execute('COMMIT TRANSACTION');
      return totalChanges;
    } catch (e) {
      print('SQLite transaction error: $e');
      db?.execute('ROLLBACK TRANSACTION'); // Rollback on error.
      rethrow; // Rethrow to signal failure to the caller.
    } finally {
      db?.dispose();
    }
  }
}
