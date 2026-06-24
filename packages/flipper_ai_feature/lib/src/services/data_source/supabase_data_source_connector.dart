/// Supabase Data Source Connector
///
/// Implements connection to Supabase databases for AI feature.

import 'dart:convert';

import 'package:http/http.dart' as http;
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
      var anonKey = getCredential<String>(config, 'anonKey');
      final serviceKey = getCredential<String>(config, 'serviceKey');

      // Use service key if anon key is empty (e.g. user only has sb_secret_)
      if ((anonKey == null || anonKey.isEmpty) && serviceKey != null && serviceKey.isNotEmpty) {
        anonKey = serviceKey;
        _logger.info('Using service key for connection (anon key not provided)');
      }
      if (anonKey == null || anonKey.isEmpty) {
        throw ArgumentError('Supabase Anon Key or Service Key is required');
      }

      // Create or get existing client
      final clientKey = config.id;
      SupabaseClient? client;

      if (_clients.containsKey(clientKey)) {
        client = _clients[clientKey];
        // Verify client is still valid
        try {
          if (client != null) {
            await _testConnection(supabaseUrl, anonKey);
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
      final isConnected = await _testConnection(supabaseUrl, anonKey);

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
      final supabaseUrl = getCredential<String>(config, 'supabaseUrl')!;
      final apiKey = _getEffectiveKey(config);

      // PostgREST does NOT expose information_schema - use OpenAPI spec instead
      final openApi = await _fetchOpenApiSchema(supabaseUrl, apiKey);
      final targetSchema = schema ?? getOption<List<String>>(config, 'schemas')?.first ?? 'public';

      final tables = <DataSourceTable>[];

      final paths = openApi['paths'] as Map<String, dynamic>? ?? {};
      for (final path in paths.keys) {
        // Skip RPC and non-table paths (e.g. /rpc/function_name)
        if (path.startsWith('/rpc/') || path.contains('(')) continue;

        // Paths are like "/table_name" or "/schema.table_name"
        final pathContent = path.startsWith('/') ? path.substring(1) : path;
        final tableSchema = pathContent.contains('.') ? pathContent.split('.').first : 'public';
        final name = pathContent.contains('.') ? pathContent.split('.').last : pathContent;

        // Filter by schema when specific schema requested
        if (schema != null && tableSchema != schema) continue;
        if (schema == null && targetSchema != 'public' && tableSchema != targetSchema) continue;

        final tableRef = tableSchema == 'public' ? name : '$tableSchema.$name';
        final columns = _parseColumnsFromOpenApi(openApi, tableRef, tableSchema);
        final rowCount = await _getTableRowCount(client, name, tableSchema);

        tables.add(DataSourceTable(
          name: name,
          schema: tableSchema,
          columns: columns,
          rowCount: rowCount,
          metadata: {'table_type': 'BASE TABLE'},
        ));
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

      final columns = await _getTableColumns(config, client, tableName, tableSchema);
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
      final columns = await _getTableColumns(config, client, tableName, tableSchema);

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

  Future<bool> _testConnection(String supabaseUrl, String apiKey) async {
    try {
      // PostgREST does NOT expose information_schema.
      // Validate key by fetching OpenAPI schema - returns 401 if key is invalid.
      final baseUrl = supabaseUrl.endsWith('/') ? supabaseUrl : '$supabaseUrl/';
      final uri = Uri.parse('${baseUrl}rest/v1/');
      final response = await http.get(
        uri,
        headers: {
          'apikey': apiKey,
          'Authorization': 'Bearer $apiKey',
          'Accept': 'application/openapi+json',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      _logger.warning('Connection test failed: $e');
      return false;
    }
  }

  String _getEffectiveKey(DataSourceConfig config) {
    final anonKey = getCredential<String>(config, 'anonKey');
    final serviceKey = getCredential<String>(config, 'serviceKey');
    if (anonKey != null && anonKey.isNotEmpty) return anonKey;
    if (serviceKey != null && serviceKey.isNotEmpty) return serviceKey;
    throw ArgumentError('Supabase Anon Key or Service Key is required');
  }

  Future<Map<String, dynamic>> _fetchOpenApiSchema(String supabaseUrl, String apiKey) async {
    final baseUrl = supabaseUrl.endsWith('/') ? supabaseUrl : '$supabaseUrl/';
    final uri = Uri.parse('${baseUrl}rest/v1/');
    final response = await http.get(
      uri,
      headers: {
        'apikey': apiKey,
        'Authorization': 'Bearer $apiKey',
        'Accept': 'application/openapi+json',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch schema: ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  List<DataSourceColumn> _parseColumnsFromOpenApi(
    Map<String, dynamic> openApi,
    String tableRef,
    String schema,
  ) {
    // OpenAPI definitions: "public.table_name" or "table_name"
    final definitions = openApi['definitions'] as Map<String, dynamic>? ?? {};
    final schemaKey = tableRef.contains('.') ? tableRef : 'public.$tableRef';
    var def = definitions[schemaKey] ?? definitions[tableRef];

    if (def == null) {
      for (final key in definitions.keys) {
        if (key.toString().toLowerCase().endsWith('.${tableRef.toLowerCase()}')) {
          def = definitions[key];
          break;
        }
      }
    }

    final properties = def?['properties'] as Map<String, dynamic>? ?? {};
    return properties.entries.map((e) {
      final colName = e.key;
      final colDef = e.value as Map<String, dynamic>? ?? {};
      final type = colDef['type']?.toString() ?? 'unknown';
      final format = colDef['format']?.toString() ?? '';
      final pgType = format.isNotEmpty ? '$type ($format)' : type;

      return DataSourceColumn(
        name: colName,
        type: pgType,
        isNullable: colDef['nullable'] != false,
        isPrimaryKey: false, // OpenAPI doesn't expose PK directly
        defaultValue: colDef['default'],
        metadata: {'description': colDef['description']},
      );
    }).toList();
  }

  Future<List<DataSourceColumn>> _getTableColumns(
    DataSourceConfig config,
    SupabaseClient client,
    String tableName,
    String schema,
  ) async {
    final supabaseUrl = getCredential<String>(config, 'supabaseUrl')!;
    final apiKey = _getEffectiveKey(config);
    final openApi = await _fetchOpenApiSchema(supabaseUrl, apiKey);
    final tableRef = schema == 'public' ? tableName : '$schema.$tableName';
    return _parseColumnsFromOpenApi(openApi, tableRef, schema);
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
