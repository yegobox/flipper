import 'dart:io';
import 'dart:async';
import 'dart:convert' show utf8;
import 'package:crypto/crypto.dart' show sha256;
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/file_system.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/foundation.dart';

class DatabaseProvider {
  //database information
  final String dbName = 'flipper';

  //directory and file information
  String cblPreBuiltDatabasePath = "";

  late Directory cblLogsDirectory;
  late Directory cblDatabaseDirectory;

  //database pointers
  AsyncDatabase? flipperDatabase;

  bool isInitialized = false;
  bool isReplicatorStarted = false;

  // Add singleton pattern to ensure single instance
  Uint8List? _encryptionKeyBytes;
  final List<String> userEncryptionKey;

  DatabaseProvider._internal(this.userEncryptionKey);

  static DatabaseProvider? _instance;

  factory DatabaseProvider(List<String> userEncryptionKey) {
    _instance ??= DatabaseProvider._internal(userEncryptionKey);
    return _instance!;
  }

  Future<DatabaseProvider> initialize() async {
    try {
      if (!isInitialized) {
        isInitialized = true;

        await setupFileSystem();
        await CouchbaseLiteFlutter.init();
        await _setupCouchbaseLogging();

        // Check if database exists
        bool databaseExists =
            await File('${cblDatabaseDirectory.path}/$dbName.cblite2').exists();

        if (!databaseExists) {
          talker.warning('Database does not exist, creating new one');
          // If database doesn't exist, we'll create it and then pull data
          await initDatabases();
        } else {
          talker.warning('Database exists, opening existing one');
          await initDatabases();
        }

        debugPrint(
            '${DateTime.now()} [DatabaseProvider] info: Successfully initialized DatabaseProvider');
      }
      return this;
    } catch (e, stackTrace) {
      isInitialized = false;
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] error: Initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
      throw DatabaseException('Failed to initialize DatabaseProvider: $e');
    }
  }

  Future<DatabaseProvider> initDatabases() async {
    if (flipperDatabase != null) {
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] info: Database already initialized');
      return this;
    }

    try {
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] info: Initializing database');

      final dbConfig = DatabaseConfiguration(
        directory: cblDatabaseDirectory.path,
      );

      // Open or create the database
      flipperDatabase = await Database.openAsync(dbName, dbConfig);

      if (flipperDatabase == null) {
        throw DatabaseException(
            'Failed to open database: null database instance');
      }

      // Create collections after database is opened
      await _createCollections();

      debugPrint(
          '${DateTime.now()} [DatabaseProvider] info: Database initialized successfully');
    } catch (e, stackTrace) {
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] error: Failed to initialize database: $e');
      debugPrint('Stack trace: $stackTrace');
      await _handleDatabaseError(e);
      throw DatabaseException('Failed to initialize database: $e');
    }
    return this;
  }

  Future<void> _createCollections() async {
    try {
      final db = flipperDatabase;
      if (db != null) {
        // Create your collections here
        await db.createCollection('counters', 'user_data');
        // Add other collections as needed
      }
    } catch (e) {
      debugPrint('Error creating collections: $e');
      rethrow;
    }
  }

  String getDatabasePath() => '${cblDatabaseDirectory.path}/$dbName';

  Future<void> setupFileSystem() async {
    try {
      final databaseDirectory = await getApplicationDocumentsDirectory();
      final logsDirectory = await getApplicationDocumentsDirectory();

      // Create directories if they don't exist
      cblDatabaseDirectory = await databaseDirectory
          .subDirectory('databases')
          .create(recursive: true);

      cblLogsDirectory = await logsDirectory
          .subDirectory('logs')
          .subDirectory('cbl')
          .create(recursive: true);

      cblPreBuiltDatabasePath = "${cblDatabaseDirectory.path}/$dbName.cblite2";

      talker.warning('cblPreBuiltDatabasePath: $cblPreBuiltDatabasePath');

      // Verify directories are writable
      if (!await cblDatabaseDirectory.exists() ||
          !await cblLogsDirectory.exists()) {
        throw DatabaseException('Failed to create required directories');
      }
    } catch (e) {
      throw DatabaseException('Failed to setup file system: $e');
    }
  }

  Future<void> closeDatabases() async {
    try {
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] info: Closing databases');

      if (flipperDatabase != null) {
        await flipperDatabase?.close();
        flipperDatabase = null;
        isInitialized = false; // Reset initialization flag
      }

      debugPrint(
          '${DateTime.now()} [DatabaseProvider] info: Databases closed successfully');
    } catch (e, stackTrace) {
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] error: Failed to close databases: $e');
      debugPrint('Stack trace: $stackTrace');
      throw DatabaseException('Failed to close databases: $e');
    }
  }

  Future<void> _setupCouchbaseLogging() async {
    try {
      // Ensure directories exist before setting up logging
      if (!await cblLogsDirectory.exists()) {
        await cblLogsDirectory.create(recursive: true);
      }

      // Configure file logging with rotation and size limits
      Database.log.file.config = LogFileConfiguration(
        directory: cblLogsDirectory.path,
        usePlainText: true,
        maxSize: 1024 * 1024, // 1MB per file
        maxRotateCount: 5, // Keep 5 rotation files
      );

      // Configure custom logging if available
      final customLogger = Database.log.custom;
      if (customLogger != null) {
        customLogger.level = LogLevel.verbose;
      }

      // Enable console logging for development
      if (kDebugMode) {
        Database.log.console.level = LogLevel.info;
      }

      debugPrint(
          '${DateTime.now()} [DatabaseProvider] info: Logging setup completed');
    } catch (e) {
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] error: Failed to setup logging: $e');
      // Don't throw here - logging failure shouldn't stop initialization
    }
  }

  // Optional: Add encryption support
  Future<EncryptionKey?> _getEncryptionKey() async {
    try {
      if (userEncryptionKey.isEmpty) {
        debugPrint(
            '${DateTime.now()} [DatabaseProvider] warning: No encryption key provided');
        return null;
      }

      if (_encryptionKeyBytes == null) {
        _encryptionKeyBytes = await _processEncryptionKey(userEncryptionKey);
      }

      if (_encryptionKeyBytes!.length != 32) {
        throw DatabaseException(
            'Invalid encryption key length: ${_encryptionKeyBytes!.length} bytes. Required: 32 bytes');
      }

      return await EncryptionKey.key(_encryptionKeyBytes!);
    } catch (e, stackTrace) {
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] error: Encryption key processing failed: $e');
      debugPrint('Stack trace: $stackTrace');
      throw DatabaseException('Failed to process encryption key: $e');
    }
  }

  Future<Uint8List> _processEncryptionKey(List<String> keyParts) async {
    try {
      final combinedKey = keyParts.join();
      final keyBytes = utf8.encode(combinedKey);
      final digest = await _hashKey(keyBytes);

      // Convert List<int> to Uint8List
      return Uint8List.fromList(digest);
    } catch (e) {
      throw DatabaseException('Failed to process encryption key parts: $e');
    }
  }

  Future<List<int>> _hashKey(List<int> keyBytes) async {
    try {
      return await compute((List<int> bytes) {
        final digest = sha256.convert(bytes);
        return digest.bytes;
      }, keyBytes);
    } catch (e) {
      throw DatabaseException('Failed to hash encryption key: $e');
    }
  }

  // Add method to clear encryption key from memory when needed
  Future<void> clearEncryptionKey() async {
    try {
      if (_encryptionKeyBytes != null) {
        // Overwrite the bytes with zeros before clearing
        _encryptionKeyBytes!.fillRange(0, _encryptionKeyBytes!.length, 0);
        _encryptionKeyBytes = null;
      }
    } catch (e) {
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] error: Failed to clear encryption key: $e');
    }
  }

  // Optional: Handle database migrations
  Future<void> _performDatabaseMigrationIfNeeded() async {
    // Implement database schema migrations
  }

  Future<void> _handleDatabaseError(dynamic error) async {
    // Implement error recovery logic
    try {
      await closeDatabases();
      // Could add retry logic, backup recovery, etc.
    } catch (e) {
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] error: Error recovery failed: $e');
    }
  }
}

// Custom exception for database-related errors
class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}
