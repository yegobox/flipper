/// Data Source Providers
///
/// Riverpod providers for managing data source connections and operations.

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../models/data_source/data_source_models.dart';
import '../services/data_source/data_source_services.dart';

final _logger = Logger('DataSourceProvider');

/// Provider for the DataSourceManager singleton
final dataSourceManagerProvider = Provider<DataSourceManager>((ref) {
  return DataSourceManager();
});

/// Provider that initializes the DataSourceManager
final initDataSourceManagerProvider = FutureProvider<void>((ref) async {
  _logger.info('Initializing DataSourceManager');
  final manager = ref.read(dataSourceManagerProvider);
  await manager.initialize();
});

/// Provider for all data source configurations
final dataSourcesProvider = Provider<List<DataSourceConfig>>((ref) {
  final manager = ref.watch(dataSourceManagerProvider);
  return manager.getDataSources();
});

/// Provider for a specific data source configuration
final dataSourceProvider =
    Provider.family<DataSourceConfig?, String>((ref, dataSourceId) {
  final manager = ref.watch(dataSourceManagerProvider);
  return manager.getDataSource(dataSourceId);
});

/// Provider for all connection statuses
final connectionStatusesProvider =
    Provider<Map<String, DataSourceConnectionStatus>>((ref) {
  final manager = ref.watch(dataSourceManagerProvider);
  return manager.getAllConnectionStatuses();
});

/// Provider for a specific connection status
final connectionStatusProvider =
    Provider.family<DataSourceConnectionStatus?, String>((ref, dataSourceId) {
  final manager = ref.watch(dataSourceManagerProvider);
  return manager.getConnectionStatus(dataSourceId);
});

/// Provider to check if any data source is connected
final hasConnectedDataSourceProvider = Provider<bool>((ref) {
  final statuses = ref.watch(connectionStatusesProvider);
  return statuses.values.any((status) => status.isConnected);
});

/// Provider to get connected data sources
final connectedDataSourcesProvider = Provider<List<DataSourceConfig>>((ref) {
  final manager = ref.watch(dataSourceManagerProvider);
  final statuses = manager.getAllConnectionStatuses();

  return manager
      .getDataSources()
      .where((config) => statuses[config.id]?.isConnected ?? false)
      .toList();
});

/// Provider for tables in a data source
final tablesProvider =
    Provider.family<Future<List<DataSourceTable>>, String>((ref, dataSourceId) {
  final manager = ref.watch(dataSourceManagerProvider);
  return manager.getTables(dataSourceId);
});

/// Provider for table schema
final tableSchemaProvider =
    Provider.family<Future<DataSourceTable>, TableSchemaParams>((ref, params) {
  final manager = ref.watch(dataSourceManagerProvider);
  return manager.getTableSchema(
    params.dataSourceId,
    params.tableName,
    schema: params.schema,
  );
});

/// Parameters for table schema provider
class TableSchemaParams {
  final String dataSourceId;
  final String tableName;
  final String schema;

  TableSchemaParams({
    required this.dataSourceId,
    required this.tableName,
    this.schema = 'public',
  });
}

/// Provider for table sample data
final tableSampleProvider =
    Provider.family<Future<DataSourceQueryResult>, TableSampleParams>((ref, params) {
  final manager = ref.watch(dataSourceManagerProvider);
  return manager.getTableSample(
    params.dataSourceId,
    params.tableName,
    schema: params.schema,
    limit: params.limit,
  );
});

/// Parameters for table sample provider
class TableSampleParams {
  final String dataSourceId;
  final String tableName;
  final String schema;
  final int limit;

  TableSampleParams({
    required this.dataSourceId,
    required this.tableName,
    this.schema = 'public',
    this.limit = 10,
  });
}

/// Provider for search results
final searchResultsProvider =
    Provider.family<Future<List<DataSourceQueryResult>>, SearchParams>((ref, params) {
  final manager = ref.watch(dataSourceManagerProvider);
  return manager.searchData(
    params.dataSourceId,
    params.searchTerm,
    tables: params.tables,
    limit: params.limit,
  );
});

/// Parameters for search provider
class SearchParams {
  final String dataSourceId;
  final String searchTerm;
  final List<String>? tables;
  final int limit;

  SearchParams({
    required this.dataSourceId,
    required this.searchTerm,
    this.tables,
    this.limit = 100,
  });
}

/// Provider for data source metadata
final dataSourceMetadataProvider =
    Provider.family<Future<Map<String, dynamic>>, String>((ref, dataSourceId) {
  final manager = ref.watch(dataSourceManagerProvider);
  return manager.getMetadata(dataSourceId);
});

/// Notifier for managing data source operations
class DataSourceNotifier extends ChangeNotifier {
  final DataSourceManager manager;

  DataSourceNotifier(this.manager);

  bool isLoading = false;
  String? error;

  /// Add a new data source
  Future<void> addDataSource(DataSourceConfig config) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await manager.addDataSource(config);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Update an existing data source
  Future<void> updateDataSource(DataSourceConfig config) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await manager.updateDataSource(config);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Remove a data source
  Future<void> removeDataSource(String dataSourceId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await manager.removeDataSource(dataSourceId);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Connect to a data source
  Future<void> connect(String dataSourceId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await manager.connect(dataSourceId);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Disconnect from a data source
  Future<void> disconnect(String dataSourceId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await manager.disconnect(dataSourceId);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Test connection without saving
  Future<bool> testConnection(DataSourceConfig config) async {
    return manager.testConnection(config);
  }

  /// Clear all data sources
  Future<void> clearAll() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await manager.clearAll();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

/// Provider for the DataSourceNotifier
final dataSourceNotifierProvider = Provider<DataSourceNotifier>((ref) {
  final manager = ref.watch(dataSourceManagerProvider);
  return DataSourceNotifier(manager);
});
