/// Data Source Connector Interface
///
/// Defines the contract for connecting to various data sources
/// and querying data from them.

import 'package:flutter/foundation.dart';

import '../../models/data_source/data_source_models.dart';

/// Abstract interface for data source connectors
///
/// Implement this interface to add support for new data sources.
abstract class DataSourceConnector {
  /// Get the type of data source this connector supports
  DataSourceType get supportedType;

  /// Test connection to the data source
  ///
  /// Returns true if connection is successful, false otherwise.
  /// Throws exception if there's a critical error.
  Future<bool> testConnection(DataSourceConfig config);

  /// Connect to the data source
  ///
  /// Establishes connection and returns connection status.
  Future<DataSourceConnectionStatus> connect(DataSourceConfig config);

  /// Disconnect from the data source
  ///
  /// Closes any open connections.
  Future<void> disconnect(DataSourceConfig config);

  /// Get list of tables/collections in the data source
  ///
  /// Optionally filter by schema.
  Future<List<DataSourceTable>> getTables(
    DataSourceConfig config, {
    String? schema,
  });

  /// Get schema information for a specific table
  ///
  /// Returns detailed column information.
  Future<DataSourceTable> getTableSchema(
    DataSourceConfig config,
    String tableName, {
    String? schema,
  });

  /// Execute a query on the data source
  ///
  /// [query] - SQL query or native query language
  /// [params] - Query parameters to prevent injection
  Future<DataSourceQueryResult> executeQuery(
    DataSourceConfig config,
    String query, {
    List<dynamic>? params,
  });

  /// Get sample data from a table
  ///
  /// Useful for understanding data structure.
  Future<DataSourceQueryResult> getTableSample(
    DataSourceConfig config,
    String tableName, {
    String? schema,
    int limit = 10,
  });

  /// Search for data across tables
  ///
  /// [searchTerm] - Term to search for
  /// [tables] - Optional list of tables to search in (null = all tables)
  Future<List<DataSourceQueryResult>> searchData(
    DataSourceConfig config,
    String searchTerm, {
    List<String>? tables,
    int limit = 100,
  });

  /// Get metadata about the data source
  ///
  /// Returns information like version, size, etc.
  Future<Map<String, dynamic>> getMetadata(DataSourceConfig config);
}

/// Base implementation with common functionality
abstract class BaseDataSourceConnector implements DataSourceConnector {
  @override
  Future<bool> testConnection(DataSourceConfig config) async {
    try {
      final status = await connect(config);
      if (status.isConnected) {
        await disconnect(config);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Validate configuration before connecting
  @protected
  void validateConfig(DataSourceConfig config) {
    if (config.credentials.isEmpty) {
      throw ArgumentError('Credentials cannot be empty');
    }

    // Type-specific validation
    switch (supportedType) {
      case DataSourceType.supabase:
        _validateSupabaseConfig(config);
        break;
      case DataSourceType.postgresql:
      case DataSourceType.mysql:
      case DataSourceType.mongodb:
      case DataSourceType.restApi:
      case DataSourceType.googleSheets:
      case DataSourceType.csv:
      case DataSourceType.json:
        // Add validation for other types
        break;
    }
  }

  /// Validate Supabase-specific configuration
  void _validateSupabaseConfig(DataSourceConfig config) {
    final supabaseUrl = config.getCredential<String>('supabaseUrl');
    final anonKey = config.getCredential<String>('anonKey');
    final serviceKey = config.getCredential<String>('serviceKey');

    if (supabaseUrl == null || supabaseUrl.isEmpty) {
      throw ArgumentError('Supabase URL is required');
    }

    final hasAnon = anonKey != null && anonKey.isNotEmpty;
    final hasService = serviceKey != null && serviceKey.isNotEmpty;
    if (!hasAnon && !hasService) {
      throw ArgumentError('Supabase Anon Key or Service Key is required');
    }

    // Validate URL format
    if (!supabaseUrl.startsWith('http://') && !supabaseUrl.startsWith('https://')) {
      throw ArgumentError('Supabase URL must be a valid HTTP/HTTPS URL');
    }
  }

  /// Helper method to safely get credentials
  @protected
  T? getCredential<T>(DataSourceConfig config, String key) {
    return config.getCredential<T>(key);
  }

  /// Helper method to safely get options
  @protected
  T? getOption<T>(DataSourceConfig config, String key) {
    return config.getOption<T>(key);
  }
}
