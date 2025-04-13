import 'dart:async';
import 'dart:collection';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';

/// Manages database connections to prevent locking issues
class ConnectionManager {
  static final _logger = Logger('ConnectionManager');
  final DatabaseFactory _databaseFactory;
  final Map<String, Database> _connections = {};
  final Queue<_PendingOperation> _operationQueue = Queue();
  final int _maxConcurrentOperations;
  int _activeOperations = 0;
  bool _processingQueue = false;
  
  // Default busy timeout in milliseconds (5 seconds)
  static const int defaultBusyTimeout = 5000;

  ConnectionManager(this._databaseFactory, {int maxConcurrentOperations = 3})
      : _maxConcurrentOperations = maxConcurrentOperations;

  /// Get a database connection, creating it if it doesn't exist
  Future<Database> getConnection(String path, {int busyTimeout = defaultBusyTimeout}) async {
    if (_connections.containsKey(path)) {
      return _connections[path]!;
    }

    _logger.info('Opening new database connection: $path');
    final db = await _databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        singleInstance: true,
        onConfigure: (db) async {
          // Set busy timeout to prevent immediate "database locked" errors
          await db.execute('PRAGMA busy_timeout = $busyTimeout');
        },
      ),
    );
    _connections[path] = db;
    return db;
  }

  /// Close a specific database connection
  Future<void> closeConnection(String path) async {
    if (_connections.containsKey(path)) {
      _logger.info('Closing database connection: $path');
      await _connections[path]!.close();
      _connections.remove(path);
    }
  }

  /// Close all database connections
  Future<void> closeAllConnections() async {
    _logger.info('Closing all database connections');
    final paths = List.from(_connections.keys);
    for (final path in paths) {
      await closeConnection(path);
    }
  }

  /// Execute a database operation with controlled concurrency
  Future<T> executeOperation<T>(
    String path,
    Future<T> Function(Database) operation, {
    int busyTimeout = defaultBusyTimeout,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final completer = Completer<T>();
    final pendingOp = _PendingOperation(
      path: path,
      operation: operation,
      completer: completer,
      busyTimeout: busyTimeout,
      timeout: timeout,
    );
    
    _operationQueue.add(pendingOp);
    _processQueue();
    
    return completer.future;
  }

  /// Process the operation queue with controlled concurrency
  void _processQueue() async {
    if (_processingQueue) return;
    _processingQueue = true;
    
    while (_operationQueue.isNotEmpty && _activeOperations < _maxConcurrentOperations) {
      final op = _operationQueue.removeFirst();
      _activeOperations++;
      
      _executeOperation(op).whenComplete(() {
        _activeOperations--;
        _processQueue();
      });
    }
    
    _processingQueue = false;
  }

  /// Execute a single database operation with timeout
  Future<void> _executeOperation(_PendingOperation op) async {
    try {
      final db = await getConnection(op.path, busyTimeout: op.busyTimeout);
      
      // Create a timeout for the operation
      final result = await op.operation(db).timeout(
        op.timeout,
        onTimeout: () {
          _logger.severe('Database operation timed out after ${op.timeout.inSeconds}s');
          throw TimeoutException('Database operation timed out', op.timeout);
        },
      );
      
      op.completer.complete(result);
    } catch (e) {
      _logger.warning('Error executing database operation: $e');
      op.completer.completeError(e);
    }
  }

  /// Execute a database operation in a transaction with controlled concurrency
  Future<T> executeTransaction<T>(
    String path,
    Future<T> Function(Transaction) transactionOperation, {
    int busyTimeout = defaultBusyTimeout,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    return executeOperation(
      path,
      (db) => db.transaction(transactionOperation),
      busyTimeout: busyTimeout,
      timeout: timeout,
    );
  }
}

/// Represents a pending database operation
class _PendingOperation<T> {
  final String path;
  final Future<T> Function(Database) operation;
  final Completer<T> completer;
  final int busyTimeout;
  final Duration timeout;

  _PendingOperation({
    required this.path,
    required this.operation,
    required this.completer,
    required this.busyTimeout,
    required this.timeout,
  });
}
