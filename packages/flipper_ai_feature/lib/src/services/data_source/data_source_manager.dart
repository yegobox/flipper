/// Data Source Manager
///
/// Manages multiple data source connections and provides
/// a unified interface for querying across data sources.

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'data_source_connector.dart';
import 'supabase_data_source_connector.dart';
import '../../models/data_source/data_source_models.dart';

/// Manages data source connections and configurations
class DataSourceManager {
  static final _logger = Logger('DataSourceManager');
  static final DataSourceManager _instance = DataSourceManager._internal();

  factory DataSourceManager() => _instance;

  DataSourceManager._internal();

  /// Registered connectors
  final Map<DataSourceType, DataSourceConnector> _connectors = {};

  /// Active data source configurations
  final Map<String, DataSourceConfig> _dataSources = {};

  /// Connection status for each data source
  final Map<String, DataSourceConnectionStatus> _connectionStatus = {};

  /// SharedPreferences key
  static const String _prefsKey = 'data_source_configs';

  /// Initialize the data source manager
  ///
  /// Registers default connectors and loads saved configurations.
  Future<void> initialize() async {
    _logger.info('Initializing DataSourceManager');

    // Register default connectors
    registerConnector(SupabaseDataSourceConnector());

    // Load saved configurations
    await loadConfigurations();

    _logger.info('DataSourceManager initialized with ${_dataSources.length} data sources');
  }

  /// Register a data source connector
  ///
  /// Call this to add support for new data source types.
  void registerConnector(DataSourceConnector connector) {
    _connectors[connector.supportedType] = connector;
    _logger.info('Registered connector for ${connector.supportedType}');
  }

  /// Get connector for a specific type
  DataSourceConnector? getConnector(DataSourceType type) {
    return _connectors[type];
  }

  /// Get connector for a specific data source
  DataSourceConnector? getConnectorForDataSource(String dataSourceId) {
    final config = _dataSources[dataSourceId];
    if (config == null) return null;
    return _connectors[config.type];
  }

  /// Add a new data source configuration
  Future<void> addDataSource(DataSourceConfig config) async {
    _logger.info('Adding data source: ${config.name} (${config.type})');

    // Validate connector exists
    final connector = _connectors[config.type];
    if (connector == null) {
      throw UnsupportedError('No connector registered for ${config.type}');
    }

    // Test connection before saving
    _logger.info('Testing connection...');
    final isConnected = await connector.testConnection(config);
    if (!isConnected) {
      throw Exception('Failed to connect to data source');
    }

    // Save configuration
    _dataSources[config.id] = config;
    await _saveConfigurations();

    _logger.info('Data source added successfully: ${config.name}');
  }

  /// Update an existing data source configuration
  Future<void> updateDataSource(DataSourceConfig config) async {
    _logger.info('Updating data source: ${config.name}');

    if (!_dataSources.containsKey(config.id)) {
      throw ArgumentError('Data source not found: ${config.id}');
    }

    // Validate connector exists
    final connector = _connectors[config.type];
    if (connector == null) {
      throw UnsupportedError('No connector registered for ${config.type}');
    }

    // Test connection if credentials changed
    if (config.credentials != _dataSources[config.id]!.credentials) {
      _logger.info('Credentials changed, testing connection...');
      final isConnected = await connector.testConnection(config);
      if (!isConnected) {
        throw Exception('Failed to connect to data source with new credentials');
      }
    }

    // Update configuration
    _dataSources[config.id] = config;
    await _saveConfigurations();

    _logger.info('Data source updated successfully: ${config.name}');
  }

  /// Remove a data source configuration
  Future<void> removeDataSource(String dataSourceId) async {
    _logger.info('Removing data source: $dataSourceId');

    // Disconnect first
    await disconnect(dataSourceId);

    // Remove configuration
    _dataSources.remove(dataSourceId);
    _connectionStatus.remove(dataSourceId);
    await _saveConfigurations();

    _logger.info('Data source removed: $dataSourceId');
  }

  /// Get all data source configurations
  List<DataSourceConfig> getDataSources() {
    return _dataSources.values.toList();
  }

  /// Get a specific data source configuration
  DataSourceConfig? getDataSource(String dataSourceId) {
    return _dataSources[dataSourceId];
  }

  /// Connect to a data source
  Future<DataSourceConnectionStatus> connect(String dataSourceId) async {
    _logger.info('Connecting to data source: $dataSourceId');

    final config = _dataSources[dataSourceId];
    if (config == null) {
      throw ArgumentError('Data source not found: $dataSourceId');
    }

    final connector = _connectors[config.type];
    if (connector == null) {
      throw UnsupportedError('No connector registered for ${config.type}');
    }

    // Update status to connecting
    _connectionStatus[dataSourceId] = DataSourceConnectionStatus(
      dataSourceId: dataSourceId,
      status: DataSourceStatus.connecting,
    );

    try {
      final status = await connector.connect(config);
      _connectionStatus[dataSourceId] = status;
      return status;
    } catch (e) {
      _logger.severe('Connection failed: $e');
      _connectionStatus[dataSourceId] = DataSourceConnectionStatus(
        dataSourceId: dataSourceId,
        status: DataSourceStatus.error,
        errorMessage: e.toString(),
        lastErrorAt: DateTime.now(),
      );
      rethrow;
    }
  }

  /// Disconnect from a data source
  Future<void> disconnect(String dataSourceId) async {
    _logger.info('Disconnecting from data source: $dataSourceId');

    final config = _dataSources[dataSourceId];
    if (config == null) {
      _logger.warning('Data source not found: $dataSourceId');
      return;
    }

    final connector = _connectors[config.type];
    if (connector == null) {
      _logger.warning('No connector for ${config.type}');
      return;
    }

    try {
      await connector.disconnect(config);
      _connectionStatus[dataSourceId] = DataSourceConnectionStatus(
        dataSourceId: dataSourceId,
        status: DataSourceStatus.disconnected,
      );
    } catch (e) {
      _logger.severe('Disconnect failed: $e');
      rethrow;
    }
  }

  /// Get connection status for a data source
  DataSourceConnectionStatus? getConnectionStatus(String dataSourceId) {
    return _connectionStatus[dataSourceId];
  }

  /// Get all connection statuses
  Map<String, DataSourceConnectionStatus> getAllConnectionStatuses() {
    return Map.unmodifiable(_connectionStatus);
  }

  /// Get tables from a data source
  Future<List<DataSourceTable>> getTables(
    String dataSourceId, {
    String? schema,
  }) async {
    _logger.info('Getting tables for data source: $dataSourceId');

    final config = _dataSources[dataSourceId];
    if (config == null) {
      throw ArgumentError('Data source not found: $dataSourceId');
    }

    final connector = _connectors[config.type];
    if (connector == null) {
      throw UnsupportedError('No connector registered for ${config.type}');
    }

    // Ensure connected
    final status = _connectionStatus[dataSourceId];
    if (status == null || !status.isConnected) {
      _logger.info('Not connected, attempting to connect...');
      await connect(dataSourceId);
    }

    return connector.getTables(config, schema: schema);
  }

  /// Get table schema
  Future<DataSourceTable> getTableSchema(
    String dataSourceId,
    String tableName, {
    String? schema,
  }) async {
    final config = _dataSources[dataSourceId];
    if (config == null) {
      throw ArgumentError('Data source not found: $dataSourceId');
    }

    final connector = _connectors[config.type];
    if (connector == null) {
      throw UnsupportedError('No connector registered for ${config.type}');
    }

    return connector.getTableSchema(config, tableName, schema: schema);
  }

  /// Execute a query on a data source
  Future<DataSourceQueryResult> executeQuery(
    String dataSourceId,
    String query, {
    List<dynamic>? params,
  }) async {
    _logger.info('Executing query on data source: $dataSourceId');

    final config = _dataSources[dataSourceId];
    if (config == null) {
      throw ArgumentError('Data source not found: $dataSourceId');
    }

    final connector = _connectors[config.type];
    if (connector == null) {
      throw UnsupportedError('No connector registered for ${config.type}');
    }

    return connector.executeQuery(config, query, params: params);
  }

  /// Get sample data from a table
  Future<DataSourceQueryResult> getTableSample(
    String dataSourceId,
    String tableName, {
    String? schema,
    int limit = 10,
  }) async {
    final config = _dataSources[dataSourceId];
    if (config == null) {
      throw ArgumentError('Data source not found: $dataSourceId');
    }

    final connector = _connectors[config.type];
    if (connector == null) {
      throw UnsupportedError('No connector registered for ${config.type}');
    }

    return connector.getTableSample(config, tableName, schema: schema, limit: limit);
  }

  /// Search for data across tables
  Future<List<DataSourceQueryResult>> searchData(
    String dataSourceId,
    String searchTerm, {
    List<String>? tables,
    int limit = 100,
  }) async {
    _logger.info('Searching for "$searchTerm" in data source: $dataSourceId');

    final config = _dataSources[dataSourceId];
    if (config == null) {
      throw ArgumentError('Data source not found: $dataSourceId');
    }

    final connector = _connectors[config.type];
    if (connector == null) {
      throw UnsupportedError('No connector registered for ${config.type}');
    }

    return connector.searchData(config, searchTerm, tables: tables, limit: limit);
  }

  /// Get metadata for a data source
  Future<Map<String, dynamic>> getMetadata(String dataSourceId) async {
    final config = _dataSources[dataSourceId];
    if (config == null) {
      throw ArgumentError('Data source not found: $dataSourceId');
    }

    final connector = _connectors[config.type];
    if (connector == null) {
      throw UnsupportedError('No connector registered for ${config.type}');
    }

    return connector.getMetadata(config);
  }

  /// Test connection for a data source configuration
  Future<bool> testConnection(DataSourceConfig config) async {
    final connector = _connectors[config.type];
    if (connector == null) {
      throw UnsupportedError('No connector registered for ${config.type}');
    }

    return connector.testConnection(config);
  }

  /// Save configurations to SharedPreferences
  Future<void> _saveConfigurations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configs = _dataSources.values.map((config) {
        return {
          'id': config.id,
          'name': config.name,
          'type': config.type.index,
          'credentials': config.credentials,
          'options': config.options,
          'isActive': config.isActive,
          'createdAt': config.createdAt?.toIso8601String(),
          'updatedAt': config.updatedAt?.toIso8601String(),
        };
      }).toList();

      await prefs.setString(_prefsKey, jsonEncode(configs));
      _logger.info('Saved ${configs.length} data source configurations');
    } catch (e) {
      _logger.severe('Failed to save configurations: $e');
      rethrow;
    }
  }

  /// Load configurations from SharedPreferences
  Future<void> loadConfigurations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configsJson = prefs.getString(_prefsKey);

      if (configsJson == null) {
        _logger.info('No saved configurations found');
        return;
      }

      final configsList = jsonDecode(configsJson) as List;
      final configs = configsList.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return DataSourceConfig(
          id: map['id'] as String,
          name: map['name'] as String,
          type: DataSourceType.values[map['type'] as int],
          credentials: Map<String, dynamic>.from(map['credentials'] as Map),
          options: Map<String, dynamic>.from(map['options'] as Map),
          isActive: map['isActive'] as bool,
          createdAt: map['createdAt'] != null
              ? DateTime.parse(map['createdAt'] as String)
              : null,
          updatedAt: map['updatedAt'] != null
              ? DateTime.parse(map['updatedAt'] as String)
              : null,
        );
      }).toList();

      _dataSources.addEntries(configs.map((c) => MapEntry(c.id, c)));
      _logger.info('Loaded ${configs.length} data source configurations');
    } catch (e) {
      _logger.severe('Failed to load configurations: $e');
      rethrow;
    }
  }

  /// Clear all configurations and connections
  Future<void> clearAll() async {
    _logger.info('Clearing all data source configurations');

    // Disconnect all
    for (final dataSourceId in _dataSources.keys.toList()) {
      await disconnect(dataSourceId);
    }

    // Clear maps
    _dataSources.clear();
    _connectionStatus.clear();

    // Clear saved
    await _saveConfigurations();

    _logger.info('All data source configurations cleared');
  }
}
