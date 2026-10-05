/// Data Source Detail Screen
///
/// Shows detailed information about a data source including tables and schema.

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/data_source/data_source_models.dart';
import '../../providers/data_source_provider.dart';
import 'data_source_connection_dialog.dart';

/// Detail screen for a data source
class DataSourceDetailScreen extends HookConsumerWidget {
  final String dataSourceId;

  const DataSourceDetailScreen({
    super.key,
    required this.dataSourceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(dataSourceProvider(dataSourceId));
    final connectionStatus = ref.watch(connectionStatusProvider(dataSourceId));
    final tablesFuture = ref.watch(tablesProvider(dataSourceId));
    final metadataFuture = ref.watch(dataSourceMetadataProvider(dataSourceId));

    // Handle case where data source doesn't exist
    if (dataSource == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.flipperL10n.aiDataSourceTitle)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                context.flipperL10n.aiDataSourceNotFound,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.flipperL10n.aiDataSourceGoBack),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(dataSource.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => DataSourceConnectionDialog(
                  initialConfig: dataSource,
                ),
              );
            },
            tooltip: context.flipperL10n.edit,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(tablesProvider(dataSourceId));
              ref.invalidate(dataSourceMetadataProvider(dataSourceId));
            },
            tooltip: context.flipperL10n.refresh,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection Status Card
            _buildStatusCard(context, dataSource, connectionStatus),
            const SizedBox(height: 16),

            // Metadata Card
            _buildMetadataCard(context, metadataFuture),
            const SizedBox(height: 16),

            // Tables Section
            Text(
              context.flipperL10n.aiDataSourceTables,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _buildTablesList(context, tablesFuture, dataSourceId),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    DataSourceConfig dataSource,
    DataSourceConnectionStatus? status,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getDataSourceTypeIcon(dataSource.type),
                  color: _getDataSourceTypeColor(dataSource.type, context),
                  size: 32,
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
                      Text(
                        _getDataSourceTypeName(dataSource.type),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
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
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.flipperL10n.aiDataSourceUrl,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dataSource.getCredential<String>('supabaseUrl') ??
                            context.flipperL10n.aiDataSourceNotAvailable,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (status?.lastConnectedAt != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.flipperL10n.aiDataSourceLastConnected(
                      _formatDateTime(status!.lastConnectedAt!),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataCard(
    BuildContext context,
    Future<Map<String, dynamic>> metadataFuture,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.flipperL10n.aiDataSourceInformation,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            FutureBuilder<Map<String, dynamic>>(
              future: metadataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    context.flipperL10n
                        .aiDataSourceMetadataFailed('${snapshot.error}'),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  );
                }
                final metadata = snapshot.data ?? {};
                return Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    _buildMetadataItem(
                      context,
                      context.flipperL10n.aiDataSourceTables,
                      '${metadata['tableCount'] ?? 0}',
                      Icons.table_chart,
                    ),
                    _buildMetadataItem(
                      context,
                      context.flipperL10n.aiDataSourceTotalRows,
                      '${metadata['totalRows'] ?? 0}',
                      Icons.storage,
                    ),
                    _buildMetadataItem(
                      context,
                      context.flipperL10n.aiDataSourceTypeLabel,
                      metadata['type']?.toString() ??
                          context.flipperL10n.aiDataSourceUnknown,
                      Icons.info,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTablesList(
    BuildContext context,
    Future<List<DataSourceTable>> tablesFuture,
    String dataSourceId,
  ) {
    return FutureBuilder<List<DataSourceTable>>(
      future: tablesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  context.flipperL10n
                      .aiDataSourceTablesFailed('${snapshot.error}'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          );
        }
        final tables = snapshot.data ?? [];
        if (tables.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.table_chart_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.flipperL10n.aiDataSourceNoTables,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tables.length,
          itemBuilder: (context, index) {
            final table = tables[index];
            return _buildTableCard(context, table, dataSourceId);
          },
        );
      },
    );
  }

  Widget _buildTableCard(
    BuildContext context,
    DataSourceTable table,
    String dataSourceId,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Icon(
          Icons.table_chart,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(table.name),
        subtitle: Text(
          table.rowCount != null
              ? '${context.flipperL10n.aiDataSourceColumnsCount(table.columns.length)} • ${context.flipperL10n.aiDataSourceRowsCount('${table.rowCount}')}'
              : context.flipperL10n
                  .aiDataSourceColumnsCount(table.columns.length),
        ),
        children: [
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.flipperL10n.aiDataSourceColumns,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ...table.columns
                    .map((column) => _buildColumnRow(context, column)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnRow(BuildContext context, DataSourceColumn column) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              column.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                column.type,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (column.isPrimaryKey)
            Icon(
              Icons.key,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          if (!column.isNullable)
            Text(
              context.flipperL10n.aiDataSourceNotNull,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 10,
                  ),
            ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return FlipperL10n.current.aiDataSourceJustNow;
    } else if (difference.inHours < 1) {
      return FlipperL10n.current
          .aiDataSourceMinutesAgo('${difference.inMinutes}');
    } else if (difference.inDays < 1) {
      return FlipperL10n.current.aiDataSourceHoursAgo('${difference.inHours}');
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Color _getDataSourceTypeColor(DataSourceType type, BuildContext context) {
    switch (type) {
      case DataSourceType.supabase:
        return const Color(0xFF3ECF8E);
      case DataSourceType.postgresql:
        return const Color(0xFF336791);
      case DataSourceType.mysql:
        return const Color(0xFF00758F);
      case DataSourceType.mongodb:
        return const Color(0xFF47A248);
      case DataSourceType.restApi:
        return const Color(0xFF6B5B95);
      case DataSourceType.googleSheets:
        return const Color(0xFF0F9D58);
      case DataSourceType.csv:
      case DataSourceType.json:
        return const Color(0xFF757575);
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
        return FlipperL10n.current.aiDataSourceCsvFile;
      case DataSourceType.json:
        return FlipperL10n.current.aiDataSourceJsonFile;
    }
  }
}
