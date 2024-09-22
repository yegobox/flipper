import 'dart:collection';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flipper_models/power_sync/powersync.dart';

class DatabaseQueue {
  final Queue<Map<String, dynamic>> _queue = Queue();
  final int _maxConcurrentOperations;
  int _activeOperations = 0;
  final String _queueFileName = 'database_queue.json';
  bool _isProcessing = false;

  DatabaseQueue(this._maxConcurrentOperations);

  Future<void> initialize() async {
    await _loadQueueFromDisk();
    _processQueue();
  }

  Future<void> addToQueue({
    required String tableName,
    required Map<String, dynamic> data,
    String? returningClause,
    Map<String, dynamic>? where,
  }) async {
    final operation = {
      'tableName': tableName,
      'data': data,
      'returningClause': returningClause,
    };
    _queue.add(operation);
    await _saveQueueToDisk();
    _processQueue();
  }

  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    while (_activeOperations < _maxConcurrentOperations && _queue.isNotEmpty) {
      final params = _queue.removeFirst();
      _activeOperations++;
      await _saveQueueToDisk();
      _startOperation(params);
    }

    _isProcessing = false;
  }

  void _startOperation(Map<String, dynamic> params) async {
    try {
      if (params['where'] == null) {
        // Perform insert
        await genericInsert(
          tableName: params['tableName'],
          data: params['data'],
          returningClause: params['returningClause'],
        );
      } else {
        // Perform update
        // await genericUpdate(
        //   tableName: params['tableName'],
        //   data: params['data'],
        //   where: params['where'],
        //   returningClause: params['returningClause'],
        // );
      }
      print('Operation completed for ${params['tableName']}');
    } catch (e) {
      print('Error processing operation for ${params['tableName']}: $e');
      // Handle error (e.g., retry logic or logging)
    } finally {
      _operationCompleted();
    }
  }

  void _operationCompleted() {
    _activeOperations--;
    _processQueue();
  }

  Future<void> _saveQueueToDisk() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_queueFileName');
      print("QUEUENAME: ${file}");
      await file.writeAsString(jsonEncode(_queue.toList()));
    } catch (e) {
      print('Error saving queue to disk: $e');
    }
  }

  Future<void> _loadQueueFromDisk() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_queueFileName');
      print("QUEUENAME: ${file}");
      if (await file.exists()) {
        final queueData = await file.readAsString();
        final List<dynamic> loadedQueue = jsonDecode(queueData);
        _queue.addAll(loadedQueue.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      print('Error loading queue from disk: $e');
    }
  }

  static Future<Map<String, dynamic>> genericInsert({
    required String tableName,
    required Map<String, dynamic> data,
    String? returningClause,
  }) async {
    // Convert keys from camelCase to snake_case
    final convertedData =
        data.map((key, value) => MapEntry(camelToSnakeCase(key), value));

    final values = <dynamic>[];

    convertedData.forEach((key, value) {
      if (key != 'id') {
        values.add(value);
      }
    });

    // Generate column names
    final columns = ['id'] +
        convertedData.keys
            .where((key) => key != 'id')
            .map(camelToSnakeCase)
            .toList();
    final placeHolders = ['uuid()'] +
        convertedData.keys.where((key) => key != 'id').map((e) => '?').toList();

    // Construct the SQL query
    final sql = '''
      INSERT INTO
        $tableName (${columns.join(', ')})
        VALUES (${placeHolders.join(', ')})
      ${returningClause != null ? 'RETURNING $returningClause' : ''}
    ''';

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
