/// Data Source models for AI feature
///
/// These models define the structure for connecting to various data sources
/// that users can ask questions about.

import 'package:equatable/equatable.dart';

/// Supported data source types
enum DataSourceType {
  supabase,
  postgresql,
  mysql,
  mongodb,
  restApi,
  googleSheets,
  csv,
  json,
}

/// Status of a data source connection
enum DataSourceStatus {
  disconnected,
  connecting,
  connected,
  error,
}

/// Configuration for a data source connection
class DataSourceConfig extends Equatable {
  final String id;
  final String name;
  final DataSourceType type;
  final Map<String, dynamic> credentials;
  final Map<String, dynamic> options;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DataSourceConfig({
    required this.id,
    required this.name,
    required this.type,
    required this.credentials,
    this.options = const {},
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  /// Create a Supabase configuration
  factory DataSourceConfig.supabase({
    required String id,
    required String name,
    required String supabaseUrl,
    required String anonKey,
    String? serviceKey,
    List<String>? schemas,
    bool isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DataSourceConfig(
      id: id,
      name: name,
      type: DataSourceType.supabase,
      credentials: {
        'supabaseUrl': supabaseUrl,
        'anonKey': anonKey,
        if (serviceKey != null) 'serviceKey': serviceKey,
      },
      options: {
        if (schemas != null) 'schemas': schemas,
      },
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Get a specific credential value
  T? getCredential<T>(String key) {
    return credentials[key] as T?;
  }

  /// Get a specific option value
  T? getOption<T>(String key) {
    return options[key] as T?;
  }

  /// Copy with updated values
  DataSourceConfig copyWith({
    String? id,
    String? name,
    DataSourceType? type,
    Map<String, dynamic>? credentials,
    Map<String, dynamic>? options,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DataSourceConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      credentials: credentials ?? this.credentials,
      options: options ?? this.options,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        credentials,
        options,
        isActive,
        createdAt,
        updatedAt,
      ];
}

/// Information about a table/collection in a data source
class DataSourceTable extends Equatable {
  final String name;
  final String? schema;
  final List<DataSourceColumn> columns;
  final int? rowCount;
  final Map<String, dynamic>? metadata;

  const DataSourceTable({
    required this.name,
    this.schema,
    required this.columns,
    this.rowCount,
    this.metadata,
  });

  /// Get primary key column if exists
  DataSourceColumn? get primaryKeyColumn {
    return columns.firstWhere((col) => col.isPrimaryKey, orElse: () => columns.first);
  }

  @override
  List<Object?> get props => [name, schema, columns, rowCount, metadata];
}

/// Information about a column in a data source table
class DataSourceColumn extends Equatable {
  final String name;
  final String type;
  final bool isNullable;
  final bool isPrimaryKey;
  final bool isForeignKey;
  final String? referencedTable;
  final String? referencedColumn;
  final dynamic defaultValue;
  final Map<String, dynamic>? metadata;

  const DataSourceColumn({
    required this.name,
    required this.type,
    this.isNullable = true,
    this.isPrimaryKey = false,
    this.isForeignKey = false,
    this.referencedTable,
    this.referencedColumn,
    this.defaultValue,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        name,
        type,
        isNullable,
        isPrimaryKey,
        isForeignKey,
        referencedTable,
        referencedColumn,
        defaultValue,
        metadata,
      ];
}

/// Result of a data source query
class DataSourceQueryResult extends Equatable {
  final List<Map<String, dynamic>> data;
  final List<DataSourceColumn> columns;
  final int totalRows;
  final Duration executionTime;
  final String? query;
  final String? error;

  const DataSourceQueryResult({
    required this.data,
    required this.columns,
    required this.totalRows,
    required this.executionTime,
    this.query,
    this.error,
  });

  /// Create an error result
  factory DataSourceQueryResult.error(String error, {Duration executionTime = Duration.zero}) {
    return DataSourceQueryResult(
      data: [],
      columns: [],
      totalRows: 0,
      executionTime: executionTime,
      error: error,
    );
  }

  /// Check if query was successful
  bool get isSuccess => error == null;

  @override
  List<Object?> get props => [data, columns, totalRows, executionTime, query, error];
}

/// Connection status for a data source
class DataSourceConnectionStatus extends Equatable {
  final String dataSourceId;
  final DataSourceStatus status;
  final String? errorMessage;
  final DateTime? lastConnectedAt;
  final DateTime? lastErrorAt;

  const DataSourceConnectionStatus({
    required this.dataSourceId,
    required this.status,
    this.errorMessage,
    this.lastConnectedAt,
    this.lastErrorAt,
  });

  /// Check if currently connected
  bool get isConnected => status == DataSourceStatus.connected;

  /// Check if there's an error
  bool get hasError => status == DataSourceStatus.error;

  @override
  List<Object?> get props => [
        dataSourceId,
        status,
        errorMessage,
        lastConnectedAt,
        lastErrorAt,
      ];
}
