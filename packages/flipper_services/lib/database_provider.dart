import 'dart:io';
import 'dart:async';
import 'package:flipper_services/file_system.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/foundation.dart';

class DatabaseProvider {
  DatabaseProvider();

  //database information
  final String dbName = 'flipper';
  //index names
  final String documentTypeIndexName = 'idxDocumentType';
  final String documentTypeAttributeName = 'documentType';

  //directory and file information
  String cblPreBuiltDatabasePath = "";

  late Directory cblLogsDirectory;
  late Directory cblDatabaseDirectory;

  //database pointers
  AsyncDatabase? flipperDatabase;

  bool isInitialized = false;
  bool isReplicatorStarted = false;

  Future<void> initialize() async {
    //init Couchbase Lite for use with databases
    if (!isInitialized) {
      isInitialized = true;
      await Future.wait([
        setupFileSystem(),
        CouchbaseLiteFlutter.init(),
      ]);
      // _setupCouchbaseLogging();
    }
  }

  String getDatabasepath() => '${cblDatabaseDirectory.path}/$dbName';

  /* setupFileSystem - used to calculate the path to save database and log files on the device */
  Future<void> setupFileSystem() async {
    final databaseDirectory = await getApplicationDocumentsDirectory();
    final logsDirectory = await getApplicationDocumentsDirectory();
    cblDatabaseDirectory = databaseDirectory.subDirectory('databases');
    cblLogsDirectory = logsDirectory.subDirectory('logs').subDirectory('cbl');
    cblPreBuiltDatabasePath = "${cblDatabaseDirectory.path}/$dbName.cblite2";
  }

  //setup and open the database file(s)
  Future<void> initDatabases() async {
    try {
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] info: initializing databases');

      final dbConfig =
          DatabaseConfiguration(directory: cblDatabaseDirectory.path);

      //open the warehouse database
      flipperDatabase = await Database.openAsync(dbName, dbConfig);

      //create indexes for queries
      await _createDocumentTypeIndex();

      debugPrint(
          '${DateTime.now()} [DatabaseProvider] info: databases initialized');
    } catch (e) {
      debugPrint('${DateTime.now()} [DatabaseProvider] error: ${e.toString()}');
    }
  }

  /* closeDatabases - close the databases */
  Future<void> closeDatabases() async {
    try {
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] info: closing databases');

      if (flipperDatabase != null) {
        await flipperDatabase?.close();
      }
      debugPrint('${DateTime.now()} [DatabaseProvider] info: databases closed');
    } catch (e) {
      debugPrint(
          '${DateTime.now()} [DatabaseProvider] error: trying to close databases ${e.toString()}');
    }
    flipperDatabase = null;
  }

  Future<void> _createDocumentTypeIndex() async {
    final expression = Expression.property(documentTypeAttributeName);
    final valueIndexItems = {ValueIndexItem.expression(expression)};
    final index = IndexBuilder.valueIndex(valueIndexItems);

    //copy to local per working with nullable fields
    //https://dart.dev/null-safety/understanding-null-safety#working-with-nullable-fields
    var flipperDb = flipperDatabase;
    if (flipperDb != null) {
      final defaultCollection = await flipperDb.defaultCollection;
      final indexes = await defaultCollection.indexes;
      if (!(indexes.contains(documentTypeIndexName))) {
        await defaultCollection.createIndex(documentTypeIndexName, index);
      }
    }
  }

  /* _setupCouchbaseLogging - For Flutter apps `Database.log.custom` is setup with a logger, which logs to `print`, but only at log level `warning`. */
  void _setupCouchbaseLogging() {
    //use for dev builds only!!
    Database.log.custom!.level = LogLevel.verbose;
    Database.log.file.config = LogFileConfiguration(
        directory: cblLogsDirectory.path, usePlainText: true);
  }
}
