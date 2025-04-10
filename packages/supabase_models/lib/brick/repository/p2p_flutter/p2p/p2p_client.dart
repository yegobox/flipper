// lib/src/p2p/p2p_client.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../../../repository.dart';
import '../bluetooth/bluetooth_manager.dart';
import '../models/peer.dart';
import '../models/message.dart';
import '../models/sync_document.dart';
import '../models/sync_document_model.dart';
import '../models/connection_status.dart';

// Extended MessageType enum to include dbChange
enum P2PMessageType {
  text,
  image,
  file,
  syncData,
  dbChange,
}

// Helper method to convert between P2PMessageType and MessageType
MessageType convertToMessageType(P2PMessageType type) {
  switch (type) {
    case P2PMessageType.text:
      return MessageType.text;
    case P2PMessageType.syncData:
      return MessageType.syncData;
    default:
      return MessageType.text;
  }
}

// Helper method to check message type
bool isMessageOfType(P2PMessage message, P2PMessageType type) {
  if (type == P2PMessageType.text && message.type == MessageType.text) {
    return true;
  } else if (type == P2PMessageType.syncData && message.type == MessageType.syncData) {
    return true;
  } else if (type == P2PMessageType.dbChange && message.type == MessageType.control) {
    // We'll use the control message type for database changes
    return message.metadata != null && message.metadata!['type'] == 'dbChange';
  }
  return false;
}

/// Configuration for P2P client
class P2PConfig {
  final bool enableBluetooth;
  final bool enableCloudSync;
  final String? supabaseUrl;
  final String? supabaseKey;
  final int syncInterval; // in seconds
  final int maxDocumentSize; // in bytes

  const P2PConfig({
    this.enableBluetooth = true,
    this.enableCloudSync = false,
    this.supabaseUrl,
    this.supabaseKey,
    this.syncInterval = 60,
    this.maxDocumentSize = 1024 * 1024, // 1MB default
  });
}

/// Sync status enum
enum SyncStatus {
  idle,
  syncing,
  completed,
  error,
  cancelled
}

/// Main client class for P2P communication.
/// This is the primary API that developers will interact with.
class P2PClient {
  late BluetoothManager _bluetoothManager;
  late Repository _repository;
  final P2PConfig _config;
  
  // Database change listener
  StreamSubscription? _dbChangeSubscription;
  
  // Tables to monitor for changes
  final List<String> _monitoredTables = [
    'products',
    'customers',
    'transactions',
    'transaction_items',
    'stock_items',
    'variants',
    // Add other tables you want to monitor
  ];
  
  // Stream controllers for exposing events
  final _peerController = StreamController<List<Peer>>.broadcast();
  final _messageController = StreamController<P2PMessage>.broadcast();
  final _connectionStatusController = StreamController<ConnectionStatus>.broadcast();
  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  
  // Current list of peers
  List<Peer> _currentPeers = [];
  
  /// Initialize the P2P client
  Future<void> _initialize() async {
    try {
      // Initialize the Bluetooth manager if enabled
      if (_config.enableBluetooth) {
        await _bluetoothManager.start();
      }
      
      // Set up event listeners for Bluetooth events
      _setupEventListeners();
      
      // Ensure the sync_documents table exists
      await _ensureSyncDocumentsTableExists();
      
      // Set up database change listener
      await _setupDatabaseChangeListener();
    } catch (e) {
      debugPrint('Error initializing P2P client: $e');
    }
  }
  
  /// Stream of available peers
  Stream<List<Peer>> get peers => _peerController.stream;
  
  /// Stream of incoming messages
  Stream<P2PMessage> get messages => _messageController.stream;
  
  /// Stream of connection status updates
  Stream<ConnectionStatus> get connectionStatus => _connectionStatusController.stream;
  
  /// Stream of sync status updates
  Stream<SyncStatus> get syncStatus => _syncStatusController.stream;
  
  /// Current connection state
  ConnectionStatus _currentStatus = ConnectionStatus.disconnected;
  
  /// List of currently known peers
  List<Peer> _currentPeers = [];

  /// Initialize the P2P client
  P2PClient({
    required Repository repository,
    required BluetoothManager bluetoothManager,
    P2PConfig? config,
  }) : _repository = repository,
       _bluetoothManager = bluetoothManager,
       _config = config ?? const P2PConfig() {
    // Initialize the client
    _initialize();
  }

  /// Initialize and listen to Bluetooth events
  void _initializeBluetoothListeners() {
    _bluetoothManager.peersStream.listen((peers) {
      _currentPeers = peers;
      _peerController.add(peers);
    });
    
    _bluetoothManager.messageStream.listen((message) {
      _messageController.add(message);
      
      // If this is a sync message, process it
      if (message.type == MessageType.syncData) {
        _processIncomingSyncData(message);
      }
    });
    
    _bluetoothManager.connectionStatusStream.listen((status) {
      _currentStatus = status;
      _connectionStatusController.add(status);
    });
  }
  
  /// Helper method to get direct database connection
  Future<Database> _getDatabaseConnection() async {
    try {
      // The SqliteProvider doesn't expose a direct database getter
      // Instead, we'll use the query method to access the database
      // This is a workaround to get the database connection
      return await _repository.sqliteProvider.executor.database;
    } catch (e) {
      // If that fails, log the error and rethrow
      debugPrint('Error accessing database directly: $e');
      throw Exception('Could not access database: $e');
    }
  }
  
  /// Ensure the sync_documents table exists in the database
  Future<void> _ensureSyncDocumentsTableExists() async {
    try {
      // Get direct access to the database
      final db = await _getDatabaseConnection();
      await db.execute('''
        CREATE TABLE IF NOT EXISTS sync_documents (
          id TEXT PRIMARY KEY,
          collection TEXT NOT NULL,
          data TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          created_by TEXT NOT NULL,
          updated_by TEXT NOT NULL,
          version INTEGER NOT NULL DEFAULT 1,
          deleted INTEGER NOT NULL DEFAULT 0,
          UNIQUE(id, collection)
        )
      ''');
      
      // Create indices for better performance
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_sync_documents_collection ON sync_documents(collection)'
      );
      
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_sync_documents_deleted ON sync_documents(deleted)'
      );
      
      // Create change tracking triggers for monitored tables
      await _createChangeTrackingTriggers(db);
    } catch (e) {
      debugPrint('Error creating sync_documents table: $e');
    }
  }
  
  /// Store a document in the local database
  Future<void> storeDocument({
    required String id,
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    final doc = SyncDocument(
      id: id,
      collection: collection,
      data: data,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      createdBy: _bluetoothManager.deviceId,
      updatedBy: _bluetoothManager.deviceId,
    );
    
    // Convert to model and store the document
    final model = SyncDocumentModel.fromSyncDocument(doc);
    
    // Use repository to execute raw SQL insert
    final db = await _getDatabaseConnection();
    await db.insert(
      'sync_documents',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
  
  /// Update an existing document in the local database
  Future<void> updateDocument({
    required String id,
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    // Get the existing document to preserve creation info
    final existingDoc = await getDocument(collection, id);
    if (existingDoc == null) {
      // If document doesn't exist, create it instead
      return storeDocument(id: id, collection: collection, data: data);
    }
    
    final updatedDoc = existingDoc.copyWith(
      data: data,
      updatedAt: DateTime.now().toUtc(),
      updatedBy: _bluetoothManager.deviceId,
    );
    
    // Convert to model and update the document
    final model = SyncDocumentModel.fromSyncDocument(updatedDoc);
    
    // Use repository to execute raw SQL update
    final db = await _getDatabaseConnection();
    await db.update(
      'sync_documents',
      {
        'data': model.data,
        'updated_at': model.updatedAt.toIso8601String(),
        'updated_by': model.updatedBy,
        'version': model.version,
        'deleted': model.deleted ? 1 : 0,
      },
      where: 'id = ? AND collection = ?',
      whereArgs: [model.documentId, model.collection]
    );
  }
  
  /// Start the P2P client
  /// This will start Bluetooth discovery and make the device discoverable
  Future<bool> start() async {
    bool started = true;
    
    if (_config.enableBluetooth) {
      started = await _bluetoothManager.start();
    }
    
    return started;
  }
  
  /// Stop the P2P client
  Future<void> stop() async {
    if (_config.enableBluetooth) {
      await _bluetoothManager.stop();
    }
  }
  
  /// Connect to a specific peer
  Future<bool> connectToPeer(Peer peer) async {
    if (!_config.enableBluetooth) return false;
    return await _bluetoothManager.connectToPeer(peer);
  }
  
  /// Disconnect from a specific peer
  Future<void> disconnectFromPeer(Peer peer) async {
    if (!_config.enableBluetooth) return;
    await _bluetoothManager.disconnectFromPeer(peer);
  }
  
  /// Send a message to a specific peer
  Future<bool> sendMessage(Peer peer, String content, {P2PMessageType type = P2PMessageType.text}) async {
    if (!_config.enableBluetooth) return false;
    
    // Create message with appropriate type and metadata
    final Map<String, dynamic>? metadata = 
        (type == P2PMessageType.dbChange) ? {'type': 'dbChange'} : null;
    
    final message = P2PMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _bluetoothManager.deviceId,
      receiverId: peer.id,
      content: content,
      timestamp: DateTime.now(),
      type: convertToMessageType(type),
      metadata: metadata,
    );
    
    return await _bluetoothManager.sendMessage(peer, message);
  }
  
  /// Get a document by ID
  Future<SyncDocument?> getDocument(String collection, String id) async {
    try {
      // Get direct access to the database
      final db = await _getDatabaseConnection();
      final results = await db.query(
        'sync_documents',
        where: 'id = ? AND collection = ? AND deleted = 0',
        whereArgs: [id, collection],
      );
      
      if (results.isEmpty) {
        return null;
      }
      
      // Convert the result to a SyncDocument using our model
      final model = SyncDocumentModel.fromMap(results.first);
      return model.toSyncDocument();
    } catch (e) {
      debugPrint('Error retrieving document: $e');
      return null;
    }
  }
  
  /// Get all documents in a collection
  Future<List<SyncDocument>> getDocuments(String collection) async {
    try {
      // Get direct access to the database
      final db = await _getDatabaseConnection();
      final results = await db.query(
        'sync_documents',
        where: 'collection = ? AND deleted = 0',
        whereArgs: [collection],
      );
      
      // Convert results to SyncDocuments using our model
      return results.map((result) {
        final model = SyncDocumentModel.fromMap(result);
        return model.toSyncDocument();
      }).toList();
    } catch (e) {
      debugPrint('Error retrieving documents: $e');
      return [];
    }
  }
  
  /// Delete a document
  Future<bool> deleteDocument(String collection, String id) async {
    try {
      // Soft delete by marking as deleted
      final db = await _getDatabaseConnection();
      await db.update(
        'sync_documents',
        {
          'deleted': 1,
          'updated_at': DateTime.now().toIso8601String(),
          'updated_by': _bluetoothManager.deviceId,
        },
        where: 'id = ? AND collection = ?',
        whereArgs: [
          id,
          collection,
        ]
      );
      
      // The repository will handle cloud sync automatically
      
      return true;
    } catch (e) {
      debugPrint('Error deleting document: $e');
      return false;
    }
  }
  
  /// Process incoming sync data from other peers
  void _processIncomingSyncData(P2PMessage message) async {
    try {
      // Parse the sync data
      final Map<String, dynamic> syncData = 
          Map<String, dynamic>.from(jsonDecode(message.content));
      
      if (syncData.containsKey('document')) {
        final docData = syncData['document'];
        final doc = SyncDocument.fromJson(docData);
        
        // Check if we have a newer version
        final existingDoc = await getDocument(doc.collection, doc.id);
        if (existingDoc == null || existingDoc.updatedAt.isBefore(doc.updatedAt)) {
          // Store the document
          await storeDocument(
            id: doc.id,
            collection: doc.collection,
            data: doc.data, // Use the data directly, it's already a Map<String, dynamic>
          );
        }
      } else if (syncData.containsKey('deletion')) {
        final deletionData = syncData['deletion'];
        await deleteDocument(
          deletionData['collection'], 
          deletionData['id'],
        );
      }
    } catch (e) {
      debugPrint('Error processing sync data: $e');
    }
  }
  
  /// Sync all local documents with connected peers
  Future<void> syncWithPeers() async {
    if (!_config.enableBluetooth) return;
    
    // Get all documents from all collections
    final db = await _getDatabaseConnection();
    final results = await db.query(
      'sync_documents',
      where: 'deleted = 0'
    );
    
    // Convert rows to SyncDocuments
    final allDocs = results.map((row) => SyncDocument(
      id: row['id'] as String,
      collection: row['collection'] as String,
      data: jsonDecode(row['data'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
      createdBy: row['created_by'] as String,
      updatedBy: row['updated_by'] as String,
      version: row['version'] as int,
      deleted: (row['deleted'] as int) == 1,
    )).toList();
    
    for (final peer in _currentPeers) {
      if (peer.isConnected) {
        for (final doc in allDocs) {
          final syncData = {
            'document': doc.toJson(),
          };
          
          await sendMessage(
            peer, 
            jsonEncode(syncData),
            type: P2PMessageType.syncData,
          );
        }
      }
    }
  }
  
  /// Set up event listeners for Bluetooth events
  void _setupEventListeners() {
    if (_config.enableBluetooth) {
      // Listen for peer discovery events
      _bluetoothManager.peersStream.listen((peers) {
        _currentPeers = peers;
        _peerController.add(peers);
      });
      
      // Listen for incoming messages
      _bluetoothManager.messageStream.listen((message) {
        _messageController.add(message);
        _handleIncomingMessage(message);
      });
      
      // Listen for connection status changes
      _bluetoothManager.connectionStatusStream.listen((status) {
        _connectionStatusController.add(status);
      });
    }
  }
  
  /// Handle incoming messages from peers
  void _handleIncomingMessage(P2PMessage message) {
    // Process the message based on its type
    if (isMessageOfType(message, P2PMessageType.syncData)) {
      _processIncomingSyncData(message);
    } else if (isMessageOfType(message, P2PMessageType.dbChange)) {
      _processIncomingDatabaseChange(message);
    } else {
      debugPrint('Unknown message type: ${message.type}');
    }
  }
  
  /// Process incoming database change message
  Future<void> _processIncomingDatabaseChange(P2PMessage message) async {
    try {
      // Parse the database change data
      final Map<String, dynamic> changeData = 
          Map<String, dynamic>.from(jsonDecode(message.content));
      
      final dbChange = DatabaseChange.fromJson(changeData);
      
      // Apply the change to the local database
      final db = await _getDatabaseConnection();
      
      if (dbChange.operation == 'insert') {
        await db.insert(dbChange.table, dbChange.data);
      } else if (dbChange.operation == 'update') {
        if (dbChange.id != null) {
          await db.update(
            dbChange.table, 
            dbChange.data,
            where: 'id = ?',
            whereArgs: [dbChange.id]
          );
        }
      } else if (dbChange.operation == 'delete') {
        if (dbChange.id != null) {
          await db.delete(
            dbChange.table,
            where: 'id = ?',
            whereArgs: [dbChange.id]
          );
        }
      }
    } catch (e) {
      debugPrint('Error processing database change: $e');
    }
  }
  
  /// Set up database change listener
  Future<void> _setupDatabaseChangeListener() async {
    try {
      final db = await _getDatabaseConnection();
      
      // Create a table to track changes if it doesn't exist
      await db.execute('''
        CREATE TABLE IF NOT EXISTS db_changes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          table_name TEXT NOT NULL,
          operation TEXT NOT NULL,
          row_id TEXT,
          data TEXT NOT NULL,
          timestamp TEXT NOT NULL
        )
      ''');
      
      // Set up a periodic check for changes
      _dbChangeSubscription = Stream.periodic(Duration(seconds: 2)).listen((_) {
        _checkForDatabaseChanges();
      });
      
    } catch (e) {
      debugPrint('Error setting up database change listener: $e');
    }
  }
  
  /// Create triggers to track changes in monitored tables
  Future<void> _createChangeTrackingTriggers(Database db) async {
    for (final table in _monitoredTables) {
      // Create after insert trigger
      await db.execute('''
        CREATE TRIGGER IF NOT EXISTS ${table}_after_insert 
        AFTER INSERT ON $table
        BEGIN
          INSERT INTO db_changes (table_name, operation, row_id, data, timestamp)
          VALUES ('$table', 'insert', new.id, json_object('id', new.id), datetime('now'));
        END;
      ''');
      
      // Create after update trigger
      await db.execute('''
        CREATE TRIGGER IF NOT EXISTS ${table}_after_update 
        AFTER UPDATE ON $table
        BEGIN
          INSERT INTO db_changes (table_name, operation, row_id, data, timestamp)
          VALUES ('$table', 'update', new.id, json_object('id', new.id), datetime('now'));
        END;
      ''');
      
      // Create after delete trigger
      await db.execute('''
        CREATE TRIGGER IF NOT EXISTS ${table}_after_delete 
        AFTER DELETE ON $table
        BEGIN
          INSERT INTO db_changes (table_name, operation, row_id, data, timestamp)
          VALUES ('$table', 'delete', old.id, json_object('id', old.id), datetime('now'));
        END;
      ''');
    }
  }
  
  /// Check for database changes and sync them
  Future<void> _checkForDatabaseChanges() async {
    try {
      final db = await _getDatabaseConnection();
      
      // Get changes since last check
      final changes = await db.query(
        'db_changes',
        orderBy: 'id ASC',
        limit: 100 // Process in batches
      );
      
      if (changes.isEmpty) return;
      
      // Process each change
      for (final change in changes) {
        final tableName = change['table_name'] as String;
        final operation = change['operation'] as String;
        final rowId = change['row_id'] as String?;
        // Get the timestamp but we don't need to use it directly
        // final timestamp = change['timestamp'] as String;
        
        // Get the actual row data from the table
        Map<String, dynamic> rowData = {};
        
        if (operation != 'delete' && rowId != null) {
          final rows = await db.query(
            tableName,
            where: 'id = ?',
            whereArgs: [rowId]
          );
          
          if (rows.isNotEmpty) {
            rowData = rows.first;
          }
        }
        
        // Create database change object
        final dbChange = DatabaseChange(
          table: tableName,
          operation: operation,
          data: rowData,
          id: rowId
        );
        
        // Broadcast to connected peers
        await _broadcastDatabaseChange(dbChange);
      }
      
      // Delete processed changes
      if (changes.isNotEmpty) {
        final lastId = changes.last['id'] as int;
        await db.delete(
          'db_changes',
          where: 'id <= ?',
          whereArgs: [lastId]
        );
      }
    } catch (e) {
      debugPrint('Error checking for database changes: $e');
    }
  }
  
  /// Send a message to all connected peers
  Future<void> broadcastMessage(String content, {P2PMessageType type = P2PMessageType.text}) async {
    if (!_config.enableBluetooth) return;
    
    for (final peer in _currentPeers) {
      if (peer.isConnected) {
        await sendMessage(peer, content, type: type);
      }
    }
  }
  
  /// Broadcast a database change to all connected peers
  Future<void> _broadcastDatabaseChange(DatabaseChange change) async {
    if (!_config.enableBluetooth) return;
    
    for (final peer in _currentPeers) {
      if (peer.isConnected) {
        await sendMessage(
          peer,
          jsonEncode(change.toJson()),
          type: P2PMessageType.dbChange
        );
      }
    }
  }
  
  /// Add a database change listener to the Repository
  /// This method should be called when you want to start monitoring database changes
  Future<void> addDatabaseChangeListener() async {
    // Set up the database change listener if not already set up
    if (_dbChangeSubscription == null) {
      await _setupDatabaseChangeListener();
    }
  }
  
  /// Remove the database change listener
  void removeDatabaseChangeListener() {
    _dbChangeSubscription?.cancel();
    _dbChangeSubscription = null;
  }
  
  /// Clean up resources when the client is disposed
  void dispose() {
    _peerController.close();
    _messageController.close();
    _connectionStatusController.close();
    _syncStatusController.close();
    
    // Dispose of database change listener
    _dbChangeSubscription?.cancel();
    
    if (_config.enableBluetooth) {
      _bluetoothManager.dispose();
    }
    
    // We don't dispose the repository as it's managed externally
  }
}


/// Helper to decode JSON in an isolate
dynamic jsonDecode(String source) => json.decode(source);

/// Database change notification
class DatabaseChange {
  final String table;
  final String operation; // insert, update, delete
  final Map<String, dynamic> data;
  final String? id;
  
  DatabaseChange({
    required this.table,
    required this.operation,
    required this.data,
    this.id,
  });
  
  Map<String, dynamic> toJson() => {
    'table': table,
    'operation': operation,
    'data': data,
    'id': id,
  };
  
  factory DatabaseChange.fromJson(Map<String, dynamic> json) => DatabaseChange(
    table: json['table'],
    operation: json['operation'],
    data: json['data'],
    id: json['id'],
  );
}
