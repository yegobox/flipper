import 'dart:io';
import 'dart:async';
import 'dart:convert' show utf8;
import 'package:crypto/crypto.dart' show sha256;
import 'package:path_provider/path_provider.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// A provider class for managing Couchbase Lite database operations
class DatabaseProvider {
  // Constants
  static const String _dbName = 'flipper_remote_v1';
  static const int _maxLogFileSize = 1024 * 1024; // 1MB
  static const int _maxLogRotateCount = 5;

  // Private fields
  late final Directory _databaseDirectory;
  late final Directory _logsDirectory;
  AsyncDatabase? _database;
  Uint8List? _encryptionKeyBytes;
  bool _isInitialized = false;
  bool _isInitializing = false;

  // Private constructor
  DatabaseProvider._({
    required List<String> encryptionKey,
  }) : _userEncryptionKey = encryptionKey;

  // Singleton instance
  static DatabaseProvider? _instance;
  final List<String> _userEncryptionKey;

  /// Factory constructor enforcing singleton pattern
  factory DatabaseProvider({required List<String> encryptionKey}) {
    return _instance ??= DatabaseProvider._(encryptionKey: encryptionKey);
  }

  /// Initializes the database provider
  Future<DatabaseProvider> initialize() async {
    if (_isInitializing) {
      throw DatabaseException('Initialization already in progress');
    }

    if (_isInitialized) {
      return this;
    }

    _isInitializing = true;

    try {
      await _initializeCore();
      await _initializeDatabase();
      _isInitialized = true;
      return this;
    } catch (e, stackTrace) {
      _logError('Initialization failed', e, stackTrace);
      _isInitialized = false;
      throw DatabaseException('Failed to initialize DatabaseProvider: $e');
    } finally {
      _isInitializing = false;
    }
  }

  /// Initializes core components
  Future<void> _initializeCore() async {
    try {
      await _setupFileSystem();
      await CouchbaseLiteFlutter.init();
      await _setupLogging();
    } catch (e) {
      throw DatabaseException('Failed to initialize core components: $e');
    }
  }

  /// Sets up the file system for database and logs
  Future<void> _setupFileSystem() async {
    final appDir = await getApplicationDocumentsDirectory();

    _databaseDirectory =
        await Directory('${appDir.path}/databases').create(recursive: true);

    _logsDirectory =
        await Directory('${appDir.path}/logs/cbl').create(recursive: true);

    if (!await _databaseDirectory.exists() || !await _logsDirectory.exists()) {
      throw DatabaseException('Failed to create required directories');
    }
  }

  /// Configures database logging
  Future<void> _setupLogging() async {
    try {
      Database.log.file.config = LogFileConfiguration(
        directory: _logsDirectory.path,
        usePlainText: true,
        maxSize: _maxLogFileSize,
        maxRotateCount: _maxLogRotateCount,
      );

      if (kDebugMode) {
        Database.log.console.level = LogLevel.info;
      }

      final customLogger = Database.log.custom;
      if (customLogger != null) {
        customLogger.level = LogLevel.verbose;
      }
    } catch (e) {
      _logWarning('Logging setup failed', e);
    }
  }

  /// Initializes the database
  Future<void> _initializeDatabase() async {
    if (_database != null) {
      _logInfo('Database already initialized');
      return;
    }

    try {
      final dbConfig = DatabaseConfiguration(
        directory: _databaseDirectory.path,
        // encryptionKey: await _getEncryptionKey(),
      );

      _database = await Database.openAsync(_dbName, dbConfig);

      if (_database == null) {
        throw DatabaseException('Failed to open database: null instance');
      }

      await _createCollections();
      _logInfo('Database initialized successfully');
    } catch (e) {
      await _handleDatabaseError(e);
      throw DatabaseException('Failed to initialize database: $e');
    }
  }

  /// Creates database collections
  Future<void> _createCollections() async {
    final db = _database;
    if (db == null) return;

    try {
      await db.createCollection('counters', "_default");
      // Add other collections as needed
    } catch (e) {
      _logError('Failed to create collections', e);
      rethrow;
    }
  }

  /// Processes and returns the encryption key
  Future<EncryptionKey?> _getEncryptionKey() async {
    if (_userEncryptionKey.isEmpty) {
      _logWarning('No encryption key provided', null);
      return null;
    }

    try {
      if (_encryptionKeyBytes == null) {
        _encryptionKeyBytes = await _processEncryptionKey();
      }

      if (_encryptionKeyBytes!.length != 32) {
        throw DatabaseException('Invalid encryption key length');
      }

      return await EncryptionKey.key(_encryptionKeyBytes!);
    } catch (e) {
      throw DatabaseException('Failed to process encryption key: $e');
    }
  }

  /// Processes the encryption key parts
  Future<Uint8List> _processEncryptionKey() async {
    try {
      final combinedKey = _userEncryptionKey.join();
      final keyBytes = utf8.encode(combinedKey);
      return Uint8List.fromList(await _hashKey(keyBytes));
    } catch (e) {
      throw DatabaseException('Failed to process encryption key: $e');
    }
  }

  /// Hashes the encryption key
  Future<List<int>> _hashKey(List<int> keyBytes) async {
    return compute((List<int> bytes) => sha256.convert(bytes).bytes, keyBytes);
  }

  /// Closes the database
  Future<void> close() async {
    try {
      if (_database != null) {
        await _database?.close();
        _database = null;
        _isInitialized = false;
        await clearEncryptionKey();
      }
    } catch (e) {
      throw DatabaseException('Failed to close database: $e');
    }
  }

  /// Clears the encryption key from memory
  Future<void> clearEncryptionKey() async {
    if (_encryptionKeyBytes != null) {
      _encryptionKeyBytes!.fillRange(0, _encryptionKeyBytes!.length, 0);
      _encryptionKeyBytes = null;
    }
  }

  /// Handles database errors
  Future<void> _handleDatabaseError(dynamic error) async {
    _logError('Database error occurred', error);
    await close();
  }

  // Logging utilities
  void _logInfo(String message) {
    debugPrint('${DateTime.now()} [DatabaseProvider] info: $message');
  }

  void _logWarning(String message, dynamic error) {
    debugPrint(
        '${DateTime.now()} [DatabaseProvider] warning: $message ${error ?? ''}');
  }

  void _logError(String message, dynamic error, [StackTrace? stackTrace]) {
    debugPrint('${DateTime.now()} [DatabaseProvider] error: $message: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }

  // Getters
  String get databasePath => '${_databaseDirectory.path}/$_dbName';
  bool get isInitialized => _isInitialized;
  AsyncDatabase? get database => _database;
}

/// Custom exception for database-related errors
class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}
