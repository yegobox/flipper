/// Data Source Connection Dialog
///
/// Dialog for adding or editing a data source connection.

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/data_source/data_source_models.dart';
import '../../providers/data_source_provider.dart';

/// Dialog for connecting a data source
class DataSourceConnectionDialog extends HookConsumerWidget {
  final DataSourceConfig? initialConfig;
  final VoidCallback? onConnected;

  const DataSourceConnectionDialog({
    super.key,
    this.initialConfig,
    this.onConnected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = initialConfig != null;
    final nameController =
        useTextEditingController(text: initialConfig?.name ?? '');
    final supabaseUrlController = useTextEditingController(
      text: initialConfig?.getCredential<String>('supabaseUrl') ?? '',
    );
    final anonKeyController = useTextEditingController(
      text: initialConfig?.getCredential<String>('anonKey') ?? '',
    );
    final serviceKeyController = useTextEditingController(
      text: initialConfig?.getCredential<String>('serviceKey') ?? '',
    );

    final dataSourceType = useState<DataSourceType>(
        initialConfig?.type ?? DataSourceType.supabase);
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final isTestingConnection = useState(false);
    final testResult = useState<bool?>(null);

    final notifier = ref.watch(dataSourceNotifierProvider);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            isEditing ? Icons.edit : Icons.add_link,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(isEditing ? 'Edit Data Source' : 'Connect Data Source'),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Data Source Type
            if (!isEditing) ...[
              DropdownButtonFormField<DataSourceType>(
                value: dataSourceType.value,
                decoration: const InputDecoration(
                  labelText: 'Data Source Type',
                  prefixIcon: Icon(Icons.storage),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: DataSourceType.supabase,
                    child: Row(
                      children: [
                        Icon(Icons.cloud, size: 20),
                        SizedBox(width: 8),
                        Text('Supabase'),
                      ],
                    ),
                  ),
                  // Add more types here when supported
                ],
                onChanged: (value) {
                  if (value != null) {
                    dataSourceType.value = value;
                  }
                },
              ),
              const SizedBox(height: 16),
            ],

            // Name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Connection Name',
                hintText: 'e.g., Production Database',
                prefixIcon: Icon(Icons.label),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Supabase URL
            if (dataSourceType.value == DataSourceType.supabase) ...[
              TextField(
                controller: supabaseUrlController,
                decoration: const InputDecoration(
                  labelText: 'Supabase URL',
                  hintText: 'https://xxxxx.supabase.co',
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              // Anon Key
              TextField(
                controller: anonKeyController,
                decoration: const InputDecoration(
                  labelText: 'Anon/Public Key',
                  hintText: 'eyJhbGc...',
                  prefixIcon: Icon(Icons.key),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // Service Key (optional)
              TextField(
                controller: serviceKeyController,
                decoration: const InputDecoration(
                  labelText: 'Service Role Key (Optional)',
                  hintText: 'eyJhbGc...',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(),
                  helperText: 'Required for admin operations',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // Test Connection Button
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isTestingConnection.value
                          ? null
                          : () async {
                              isTestingConnection.value = true;
                              testResult.value = null;
                              errorMessage.value = null;

                              try {
                                final anon = anonKeyController.text.trim();
                                final service = serviceKeyController.text.trim();
                                final config = DataSourceConfig.supabase(
                                  id: initialConfig?.id ??
                                      DateTime.now().toString(),
                                  name: nameController.text,
                                  supabaseUrl: supabaseUrlController.text,
                                  anonKey: anon.isNotEmpty ? anon : '',
                                  serviceKey:
                                      service.isNotEmpty ? service : null,
                                );

                                final result =
                                    await notifier.testConnection(config);
                                testResult.value = result;

                                if (!result) {
                                  errorMessage.value =
                                      'Connection test failed. Please check your credentials.';
                                }
                              } catch (e) {
                                errorMessage.value =
                                    'Connection test failed: $e';
                                testResult.value = false;
                              } finally {
                                isTestingConnection.value = false;
                              }
                            },
                      icon: isTestingConnection.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.wifi_find),
                      label: Text(isTestingConnection.value
                          ? 'Testing...'
                          : 'Test Connection'),
                    ),
                  ),
                  if (testResult.value != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      testResult.value! ? Icons.check_circle : Icons.error,
                      color: testResult.value! ? Colors.green : Colors.red,
                    ),
                  ],
                ],
              ),
              if (errorMessage.value != null) ...[
                const SizedBox(height: 8),
                Text(
                  errorMessage.value!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ],
            ],

            // Info message
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'When connected, the assistant can use schema and sample rows from '
                      'this source in your chats. Credentials are stored only on this device.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: isLoading.value
              ? null
              : () async {
                  // Validate inputs
                  if (nameController.text.trim().isEmpty) {
                    errorMessage.value = 'Please enter a connection name';
                    return;
                  }

                  if (dataSourceType.value == DataSourceType.supabase) {
                    if (supabaseUrlController.text.trim().isEmpty) {
                      errorMessage.value = 'Please enter the Supabase URL';
                      return;
                    }
                    final hasAnon = anonKeyController.text.trim().isNotEmpty;
                    final hasService = serviceKeyController.text.trim().isNotEmpty;
                    if (!hasAnon && !hasService) {
                      errorMessage.value =
                          'Please enter an Anon/Public Key or Service Role Key';
                      return;
                    }
                  }

                  isLoading.value = true;
                  errorMessage.value = null;

                  try {
                    final config = DataSourceConfig.supabase(
                      id: initialConfig?.id ?? DateTime.now().toString(),
                      name: nameController.text.trim(),
                      supabaseUrl: supabaseUrlController.text.trim(),
                      anonKey: anonKeyController.text.trim().isNotEmpty
                          ? anonKeyController.text.trim()
                          : '', // Service key used when anon empty
                      serviceKey: serviceKeyController.text.trim().isNotEmpty
                          ? serviceKeyController.text.trim()
                          : null,
                      isActive: true,
                      createdAt: initialConfig?.createdAt,
                      updatedAt: DateTime.now(),
                    );

                    if (isEditing) {
                      await notifier.updateDataSource(config);
                    } else {
                      await notifier.addDataSource(config);
                    }

                    if (context.mounted) {
                      Navigator.of(context).pop();
                      onConnected?.call();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isEditing
                                ? 'Data source updated successfully'
                                : 'Data source connected successfully',
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      );
                    }
                  } catch (e) {
                    errorMessage.value = 'Failed to connect: $e';
                  } finally {
                    isLoading.value = false;
                  }
                },
          icon: isLoading.value
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.check),
          label: Text(isLoading.value
              ? 'Connecting...'
              : (isEditing ? 'Update' : 'Connect')),
        ),
      ],
    );
  }
}

/// Widget to display data source connection status
class DataSourceStatusChip extends StatelessWidget {
  final DataSourceStatus status;
  final String? errorMessage;

  const DataSourceStatusChip({
    super.key,
    required this.status,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;
    IconData icon;

    switch (status) {
      case DataSourceStatus.connected:
        backgroundColor = Theme.of(context).colorScheme.primaryContainer;
        textColor = Theme.of(context).colorScheme.onPrimaryContainer;
        label = 'Connected';
        icon = Icons.check_circle;
        break;
      case DataSourceStatus.connecting:
        backgroundColor = Theme.of(context).colorScheme.tertiaryContainer;
        textColor = Theme.of(context).colorScheme.onTertiaryContainer;
        label = 'Connecting';
        icon = Icons.sync;
        break;
      case DataSourceStatus.error:
        backgroundColor = Theme.of(context).colorScheme.errorContainer;
        textColor = Theme.of(context).colorScheme.onErrorContainer;
        label = 'Error';
        icon = Icons.error;
        break;
      case DataSourceStatus.disconnected:
        backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
        textColor = Theme.of(context).colorScheme.onSurfaceVariant;
        label = 'Disconnected';
        icon = Icons.cloud_off;
    }

    return Tooltip(
      message: errorMessage ?? label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
