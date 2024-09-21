import 'dart:collection';
import 'dart:async';
import 'package:flipper_models/power_sync/powersync.dart';

class DatabaseQueue {
  final Queue<Map<String, dynamic>> _queue = Queue();
  final int _maxConcurrentOperations;
  int _activeOperations = 0;

  DatabaseQueue(this._maxConcurrentOperations);

  Future<void> addToQueue({
    required String tableName,
    required Map<String, dynamic> data,
    String? returningClause,
  }) async {
    _queue.add({
      'tableName': tableName,
      'data': data,
      'returningClause': returningClause,
    });
    await _processQueue();
  }

  Future<void> _processQueue() async {
    while (_activeOperations < _maxConcurrentOperations && _queue.isNotEmpty) {
      final params = _queue.removeFirst();
      _activeOperations++;
      await _startOperation(params);
    }
  }

  Future<void> _startOperation(Map<String, dynamic> params) async {
    try {
      await genericInsert(
        tableName: params['tableName'],
        data: params['data'],
        returningClause: params['returningClause'],
      );
      print('Insertion completed for ${params['tableName']}');
    } catch (e) {
      print('Error inserting into ${params['tableName']}: $e');
    } finally {
      _operationCompleted();
    }
  }

  void _operationCompleted() {
    _activeOperations--;
    _processQueue();
  }

  static Future<Map<String, dynamic>> genericInsert({
    required String tableName,
    required Map<String, dynamic> data,
    String? returningClause,
  }) async {
    // Convert keys from camelCase to snake_case
    final convertedData =
        data.map((key, value) => MapEntry(camelToSnakeCase(key), value));

    // Separate UUID fields and regular fields
    final uuidFields = <String>[];
    final regularFields = <String>[];
    final values = <dynamic>[];

    convertedData.forEach((key, value) {
      if (value == 'uuid()') {
        uuidFields.add(key);
      } else {
        regularFields.add(key);
        values.add(value);
      }
    });

    // Generate column names
    final allColumns = [...uuidFields, ...regularFields];
    final columns = allColumns.join(', ');

    // Generate placeholders
    final uuidPlaceholders = uuidFields.map((_) => 'uuid()').join(', ');
    final regularPlaceholders = regularFields.map((_) => '?').join(', ');
    final allPlaceholders = [
      if (uuidPlaceholders.isNotEmpty) uuidPlaceholders,
      if (regularPlaceholders.isNotEmpty) regularPlaceholders,
    ].join(', ');

    // Construct the SQL query
    var sql = 'INSERT INTO $tableName ($columns) VALUES ($allPlaceholders)';
    if (returningClause != null) {
      sql += ' RETURNING $returningClause';
    }

    // Execute the query
    final List<dynamic> result = await db.execute(sql, values);

    // Return the first row if RETURNING clause was used, otherwise an empty map
    return result.isNotEmpty ? result.first : {};
  }

  static String camelToSnakeCase(String input) {
    return input.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => '_${match.group(1)!.toLowerCase()}',
    );
  }
}
