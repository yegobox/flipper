/// Supabase Data Source Connector
///
/// Implements connection to Supabase databases for AI feature.

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logging/logging.dart';

import 'data_source_connector.dart';
import '../../models/data_source/data_source_models.dart';

/// Supabase implementation of data source connector
class SupabaseDataSourceConnector extends BaseDataSourceConnector {
  static final _logger = Logger('SupabaseDataSourceConnector');

  @override
  DataSourceType get supportedType => DataSourceType.supabase;

  /// Map to track Supabase clients per config
  final Map<String, SupabaseClient> _clients = {};

  @override
  Future<DataSourceConnectionStatus> connect(DataSourceConfig config) async {
    try {
      _logger.info('Connecting to Supabase: ${config.name}');

      // Validate configuration
      validateConfig(config);

      final supabaseUrl = getCredential<String>(config, 'supabaseUrl')!;
      final anonKey = getCredential<String>(config, 'anonKey')!;

      // Create or get existing client
      final clientKey = config.id;
      SupabaseClient? client;

      if (_clients.containsKey(clientKey)) {
        client = _clients[clientKey];
        // Verify client is still valid
        try {
          if (client != null) {
            await _testClient(client);
            _logger.info('Reusing existing Supabase client');
          } else {
            client = null;
          }
        } catch (e) {
          _logger.warning('Existing client invalid, creating new one: $e');
          _clients.remove(clientKey);
          client = null;
        }
      }

      if (client == null) {
        // Create new client
        client = SupabaseClient(supabaseUrl, anonKey);
        _clients[clientKey] = client;
        _logger.info('Created new Supabase client');
      }

      // Test the connection
      final isConnected = await _testClient(client);

      if (isConnected) {
        _logger.info('Successfully connected to Supabase: ${config.name}');
        return DataSourceConnectionStatus(
          dataSourceId: config.id,
          status: DataSourceStatus.connected,
          lastConnectedAt: DateTime.now(),
        );
      } else {
        _logger.warning('Connection test failed for Supabase: ${config.name}');
        return DataSourceConnectionStatus(
          dataSourceId: config.id,
          status: DataSourceStatus.error,
          errorMessage: 'Connection test failed',
          lastErrorAt: DateTime.now(),
        );
      }
    } catch (e) {
      _logger.severe('Error connecting to Supabase: $e');
      return DataSourceConnectionStatus(
        dataSourceId: config.id,
        status: DataSourceStatus.error,
        errorMessage: e.toString(),
        lastErrorAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> disconnect(DataSourceConfig config) async {
    try {
      _logger.info('Disconnecting from Supabase: ${config.name}');

      final clientKey = config.id;
      if (_clients.containsKey(clientKey)) {
        // Note: Supabase Flutter client doesn't have explicit dispose
        // but we remove it from our cache
        _clients.remove(clientKey);
        _logger.info('Disconnected from Supabase: ${config.name}');
      }
    } catch (e) {
      _logger.severe('Error disconnecting from Supabase: $e');
      rethrow;
    }
  }

  @override
  Future<List<DataSourceTable>> getTables(
    DataSourceConfig config, {
    String? schema,
  }) async {
    try {
      final client = await _getClient(config);

      // Query information schema for tables
      final schemas = getOption<List<String>>(config, 'schemas') ?? ['public'];
      final targetSchemas = schema != null ? [schema] : schemas;

      final tables = <DataSourceTable>[];

      for (final tableSchema in targetSchemas) {
        final response = await client
            .from('information_schema.tables')
            .select('table_name, table_type')
            .eq('table_schema', tableSchema)
            .eq('table_type', 'BASE TABLE');

        for (final tableData in response) {
          final tableName = tableData['table_name'] as String;

          // Get columns for this table
          final columns = await _getTableColumns(client, tableName, tableSchema);

          // Get row count
          final rowCount = await _getTableRowCount(client, tableName, tableSchema);

          tables.add(DataSourceTable(
            name: tableName,
            schema: tableSchema,
            columns: columns,
            rowCount: rowCount,
            metadata: {
              'table_type': tableData['table_type'],
            },
          ));
        }
      }

      _logger.info('Retrieved ${tables.length} tables from Supabase');
      return tables;
    } catch (e) {
      _logger.severe('Error getting tables: $e');
      rethrow;
    }
  }

  @override
  Future<DataSourceTable> getTableSchema(
    DataSourceConfig config,
    String tableName, {
    String? schema,
  }) async {
    try {
      final client = await _getClient(config);
      final tableSchema = schema ?? getOption<List<String>>(config, 'schemas')?.first ?? 'public';

      final columns = await _getTableColumns(client, tableName, tableSchema);
      final rowCount = await _getTableRowCount(client, tableName, tableSchema);

      return DataSourceTable(
        name: tableName,
        schema: tableSchema,
        columns: columns,
        rowCount: rowCount,
      );
    } catch (e) {
      _logger.severe('Error getting table schema: $e');
      rethrow;
    }
  }

  @override
  Future<DataSourceQueryResult> executeQuery(
    DataSourceConfig config,
    String query, {
    List<dynamic>? params,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      final client = await _getClient(config);

      // Note: Supabase Flutter client has limited raw SQL support
      // For complex queries, you may need to use RPC functions
      // This is a simplified implementation

      _logger.info('Executing query: $query');

      // For now, we'll use the query builder approach
      // In production, you might want to use Supabase RPC functions
      final response = await _executeSupabaseQuery(client, query, params);

      stopwatch.stop();

      return DataSourceQueryResult(
        data: response,
        columns: [], // Would need to infer from response
        totalRows: response.length,
        executionTime: stopwatch.elapsed,
        query: query,
      );
    } catch (e) {
      _logger.severe('Error executing query: $e');
      return DataSourceQueryResult.error(e.toString());
    }
  }

  @override
  Future<DataSourceQueryResult> getTableSample(
    DataSourceConfig config,
    String tableName, {
    String? schema,
    int limit = 10,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      final client = await _getClient(config);
      final tableSchema = schema ?? 'public';

      _logger.info('Getting sample data from $tableSchema.$tableName (limit: $limit)');

      final response = await client
          .from(tableName)
          .select()
          .limit(limit);

      stopwatch.stop();

      // Get column info
      final columns = await _getTableColumns(client, tableName, tableSchema);

      return DataSourceQueryResult(
        data: response,
        columns: columns,
        totalRows: response.length,
        executionTime: stopwatch.elapsed,
        query: 'SELECT * FROM $tableSchema.$tableName LIMIT $limit',
      );
    } catch (e) {
      _logger.severe('Error getting table sample: $e');
      return DataSourceQueryResult.error(e.toString());
    }
  }

  @override
  Future<List<DataSourceQueryResult>> searchData(
    DataSourceConfig config,
    String searchTerm, {
    List<String>? tables,
    int limit = 100,
  }) async {
    try {
      final client = await _getClient(config);
      final results = <DataSourceQueryResult>[];

      // Get available tables
      final availableTables = tables ?? (await getTables(config)).map((t) => t.name).toList();

      _logger.info('Searching for "$searchTerm" in ${availableTables.length} tables');

      // Search in each table (simplified - in production use full-text search)
      for (final tableName in availableTables.take(10)) { // Limit to prevent overload
        try {
          final tableSchema = await getTableSchema(config, tableName);
          final textColumns = tableSchema.columns
              .where((col) => col.type.toLowerCase().contains('text') ||
                  col.type.toLowerCase().contains('varchar') ||
                  col.type.toLowerCase().contains('string'))
              .map((col) => col.name)
              .toList();

          if (textColumns.isEmpty) continue;

          // Build search query (simplified - fetch and filter client-side)
          // For production, implement proper full-text search with Supabase functions
          final response = await client
              .from(tableName)
              .select()
              .limit(limit);
          
          // Filter client-side for search term
          final filtered = response.where((row) {
            final value = row[textColumns.first]?.toString() ?? '';
            return value.toLowerCase().contains(searchTerm.toLowerCase());
          }).toList();

          if (filtered.isNotEmpty) {
            results.add(DataSourceQueryResult(
              data: filtered,
              columns: tableSchema.columns,
              totalRows: filtered.length,
              executionTime: Duration.zero,
              query: 'SEARCH $searchTerm IN $tableName',
            ));
          }
        } catch (e) {
          _logger.warning('Error searching table $tableName: $e');
          // Continue with other tables
        }
      }

      _logger.info('Search completed: ${results.length} tables with matches');
      return results;
    } catch (e) {
      _logger.severe('Error searching data: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getMetadata(DataSourceConfig config) async {
    try {
      final client = await _getClient(config);

      // Get Supabase project info
      final tables = await getTables(config);
      final totalRows = await _getTotalRowCount(client, tables);

      return {
        'type': 'supabase',
        'url': getCredential<String>(config, 'supabaseUrl'),
        'tableCount': tables.length,
        'totalRows': totalRows,
        'connectedAt': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      _logger.severe('Error getting metadata: $e');
      rethrow;
    }
  }

  // Helper methods

  Future<SupabaseClient> _getClient(DataSourceConfig config) async {
    final clientKey = config.id;

    if (!_clients.containsKey(clientKey)) {
      await connect(config);
    }

    return _clients[clientKey]!;
  }

  Future<bool> _testClient(SupabaseClient client) async {
    try {
      // Try to query a system table to verify connection
      await client.from('information_schema.tables').select('table_name').limit(1);
      return true;
    } catch (e) {
      _logger.warning('Client test failed: $e');
      return false;
    }
  }

  Future<List<DataSourceColumn>> _getTableColumns(
    SupabaseClient client,
    String tableName,
    String schema,
  ) async {
    final response = await client
        .from('information_schema.columns')
        .select()
        .eq('table_name', tableName)
        .eq('table_schema', schema)
        .order('ordinal_position');

    return response.map((col) {
      // Check if primary key
      final isPrimaryKey = col['column_key'] == 'PRI';

      return DataSourceColumn(
        name: col['column_name'] as String,
        type: col['data_type'] as String,
        isNullable: col['is_nullable'] == 'YES',
        isPrimaryKey: isPrimaryKey,
        defaultValue: col['column_default'],
        metadata: {
          'character_maximum_length': col['character_maximum_length'],
          'numeric_precision': col['numeric_precision'],
          'is_identity': col['is_identity'],
        },
      );
    }).toList();
  }

  Future<int> _getTableRowCount(
    SupabaseClient client,
    String tableName,
    String schema,
  ) async {
    try {
      // Simple approach - just get the response length
      // For accurate count, use count(*) query via RPC
      final response = await client
          .from(tableName)
          .select()
          .limit(1);

      // This is a rough estimate - in production use count query
      return response.length > 0 ? response.length : 0;
    } catch (e) {
      _logger.warning('Error getting row count for $tableName: $e');
      return 0;
    }
  }

  Future<int> _getTotalRowCount(
    SupabaseClient client,
    List<DataSourceTable> tables,
  ) async {
    int total = 0;
    for (final table in tables.take(20)) { // Limit to prevent overload
      total += await _getTableRowCount(client, table.name, table.schema ?? 'public');
    }
    return total;
  }

  Future<List<Map<String, dynamic>>> _executeSupabaseQuery(
    SupabaseClient client,
    String query,
    List<dynamic>? params,
  ) async {
    // Simplified query execution
    // For production, implement proper SQL parsing or use RPC functions
    // This is a placeholder - Supabase Flutter client doesn't support raw SQL directly

    throw UnimplementedError(
      'Raw SQL execution not directly supported. Use Supabase RPC functions or query builder.',
    );
  }
}
