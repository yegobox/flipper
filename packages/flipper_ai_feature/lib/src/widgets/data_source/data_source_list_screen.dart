/// Data Source List Screen
///
/// Screen for managing data source connections.

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/data_source/data_source_models.dart';
import '../../providers/data_source_provider.dart';
import 'data_source_connection_dialog.dart';
import 'data_source_detail_screen.dart';

/// Screen for managing data source connections
class DataSourceListScreen extends HookConsumerWidget {
  const DataSourceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSources = ref.watch(dataSourcesProvider);
    final connectionStatuses = ref.watch(connectionStatusesProvider);
    final notifier = ref.watch(dataSourceNotifierProvider);

    // Listen for initialization
    useEffect(() {
      ref.read(initDataSourceManagerProvider.future);
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Sources'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(dataSourcesProvider);
              ref.invalidate(connectionStatusesProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: dataSources.isEmpty
          ? _buildEmptyState(context, ref)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dataSources.length,
              itemBuilder: (context, index) {
                final dataSource = dataSources[index];
                final status = connectionStatuses[dataSource.id];

                return _buildDataSourceCard(
                  context,
                  ref,
                  notifier,
                  dataSource,
                  status,
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const DataSourceConnectionDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Data Source'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 24),
          Text(
            'No Data Sources Connected',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Connect your data source to ask questions\nabout your data in the AI chat',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const DataSourceConnectionDialog(),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Connect Your First Data Source'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSourceCard(
    BuildContext context,
    WidgetRef ref,
    DataSourceNotifier notifier,
    DataSourceConfig dataSource,
    DataSourceConnectionStatus? status,
  ) {
    final isConnected = status?.isConnected ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DataSourceDetailScreen(dataSourceId: dataSource.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon based on type
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getDataSourceTypeColor(dataSource.type, context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getDataSourceTypeIcon(dataSource.type),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataSource.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              _getDataSourceTypeName(dataSource.type),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            if (dataSource.isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Active',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DataSourceStatusChip(
                    status: status?.status ?? DataSourceStatus.disconnected,
                    errorMessage: status?.errorMessage,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (status?.lastConnectedAt != null) ...[
                    Text(
                      'Last connected: ${DateFormat('MMM d, y HH:mm').format(status!.lastConnectedAt!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                  const Spacer(),
                  // Action buttons
                  if (isConnected)
                    TextButton.icon(
                      onPressed: () => notifier.disconnect(dataSource.id),
                      icon: const Icon(Icons.link_off),
                      label: const Text('Disconnect'),
                    )
                  else
                    TextButton.icon(
                      onPressed: () => notifier.connect(dataSource.id),
                      icon: const Icon(Icons.link),
                      label: const Text('Connect'),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => DataSourceConnectionDialog(
                          initialConfig: dataSource,
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    onPressed: () => _confirmDelete(context, ref, notifier, dataSource),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    DataSourceNotifier notifier,
    DataSourceConfig dataSource,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Data Source'),
        content: Text(
          'Are you sure you want to delete "${dataSource.name}"? '
          'This will remove the connection and all associated data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await notifier.removeDataSource(dataSource.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Data source "${dataSource.name}" deleted'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getDataSourceTypeColor(DataSourceType type, BuildContext context) {
    switch (type) {
      case DataSourceType.supabase:
        return const Color(0xFF3ECF8E); // Supabase green
      case DataSourceType.postgresql:
        return const Color(0xFF336791); // PostgreSQL blue
      case DataSourceType.mysql:
        return const Color(0xFF00758F); // MySQL blue
      case DataSourceType.mongodb:
        return const Color(0xFF47A248); // MongoDB green
      case DataSourceType.restApi:
        return const Color(0xFF6B5B95); // Purple
      case DataSourceType.googleSheets:
        return const Color(0xFF0F9D58); // Google green
      case DataSourceType.csv:
        return const Color(0xFF757575); // Gray
      case DataSourceType.json:
        return const Color(0xFFFFA500); // Orange
    }
  }

  IconData _getDataSourceTypeIcon(DataSourceType type) {
    switch (type) {
      case DataSourceType.supabase:
        return Icons.cloud;
      case DataSourceType.postgresql:
      case DataSourceType.mysql:
      case DataSourceType.mongodb:
        return Icons.storage;
      case DataSourceType.restApi:
        return Icons.http;
      case DataSourceType.googleSheets:
        return Icons.table_chart;
      case DataSourceType.csv:
      case DataSourceType.json:
        return Icons.insert_drive_file;
    }
  }

  String _getDataSourceTypeName(DataSourceType type) {
    switch (type) {
      case DataSourceType.supabase:
        return 'Supabase';
      case DataSourceType.postgresql:
        return 'PostgreSQL';
      case DataSourceType.mysql:
        return 'MySQL';
      case DataSourceType.mongodb:
        return 'MongoDB';
      case DataSourceType.restApi:
        return 'REST API';
      case DataSourceType.googleSheets:
        return 'Google Sheets';
      case DataSourceType.csv:
        return 'CSV File';
      case DataSourceType.json:
        return 'JSON File';
    }
  }
}
