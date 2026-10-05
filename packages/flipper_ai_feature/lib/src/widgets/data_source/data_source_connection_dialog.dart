/// Data Source Connection Dialog
///
/// Dialog for adding or editing a data source connection.

import 'package:flipper_localize/flipper_localize.dart';
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
            child: Text(isEditing
                ? context.flipperL10n.aiDataSourceEdit
                : context.flipperL10n.aiDataSourceConnectTitle),
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
                decoration: InputDecoration(
                  labelText: context.flipperL10n.aiDataSourceType,
                  prefixIcon: const Icon(Icons.storage),
                  border: const OutlineInputBorder(),
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
              decoration: InputDecoration(
                labelText: context.flipperL10n.aiDataSourceConnectionName,
                hintText: context.flipperL10n.aiDataSourceConnectionNameHint,
                prefixIcon: Icon(Icons.label),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Supabase URL
            if (dataSourceType.value == DataSourceType.supabase) ...[
              TextField(
                controller: supabaseUrlController,
                decoration: InputDecoration(
                  labelText: context.flipperL10n.aiDataSourceSupabaseUrl,
                  hintText: 'https://xxxxx.supabase.co',
                  prefixIcon: const Icon(Icons.link),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              // Anon Key
              TextField(
                controller: anonKeyController,
                decoration: InputDecoration(
                  labelText: context.flipperL10n.aiDataSourceAnonKey,
                  hintText: 'eyJhbGc...',
                  prefixIcon: const Icon(Icons.key),
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // Service Key (optional)
              TextField(
                controller: serviceKeyController,
                decoration: InputDecoration(
                  labelText: context.flipperL10n.aiDataSourceServiceKey,
                  hintText: 'eyJhbGc...',
                  prefixIcon: const Icon(Icons.vpn_key),
                  border: const OutlineInputBorder(),
                  helperText: context.flipperL10n.aiDataSourceServiceKeyHelper,
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
                              final l10n = context.flipperL10n;
                              isTestingConnection.value = true;
                              testResult.value = null;
                              errorMessage.value = null;

                              try {
                                final anon = anonKeyController.text.trim();
                                final service =
                                    serviceKeyController.text.trim();
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
                                      l10n.aiDataSourceTestFailedCredentials;
                                }
                              } catch (e) {
                                errorMessage.value =
                                    l10n.aiDataSourceTestFailed('$e');
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
                          ? context.flipperL10n.aiDataSourceTesting
                          : context.flipperL10n.aiDataSourceTestConnection),
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
                      context.flipperL10n.aiDataSourcePrivacyNote,
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
          child: Text(context.flipperL10n.cancel),
        ),
        FilledButton.icon(
          onPressed: isLoading.value
              ? null
              : () async {
                  // Validate inputs
                  if (nameController.text.trim().isEmpty) {
                    errorMessage.value =
                        context.flipperL10n.aiDataSourceEnterName;
                    return;
                  }

                  if (dataSourceType.value == DataSourceType.supabase) {
                    if (supabaseUrlController.text.trim().isEmpty) {
                      errorMessage.value =
                          context.flipperL10n.aiDataSourceEnterUrl;
                      return;
                    }
                    final hasAnon = anonKeyController.text.trim().isNotEmpty;
                    final hasService =
                        serviceKeyController.text.trim().isNotEmpty;
                    if (!hasAnon && !hasService) {
                      errorMessage.value =
                          context.flipperL10n.aiDataSourceEnterKey;
                      return;
                    }
                  }

                  final l10n = context.flipperL10n;
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
                                ? l10n.aiDataSourceUpdated
                                : l10n.aiDataSourceConnected,
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      );
                    }
                  } catch (e) {
                    errorMessage.value = l10n.aiDataSourceConnectFailed('$e');
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
              ? context.flipperL10n.aiDataSourceConnecting
              : (isEditing
                  ? context.flipperL10n.aiDataSourceUpdate
                  : context.flipperL10n.aiDataSourceConnect)),
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
        label = context.flipperL10n.aiDataSourceStatusConnected;
        icon = Icons.check_circle;
        break;
      case DataSourceStatus.connecting:
        backgroundColor = Theme.of(context).colorScheme.tertiaryContainer;
        textColor = Theme.of(context).colorScheme.onTertiaryContainer;
        label = context.flipperL10n.aiDataSourceStatusConnecting;
        icon = Icons.sync;
        break;
      case DataSourceStatus.error:
        backgroundColor = Theme.of(context).colorScheme.errorContainer;
        textColor = Theme.of(context).colorScheme.onErrorContainer;
        label = context.flipperL10n.aiDataSourceStatusError;
        icon = Icons.error;
        break;
      case DataSourceStatus.disconnected:
        backgroundColor = Theme.of(context).colorScheme.surfaceContainerHighest;
        textColor = Theme.of(context).colorScheme.onSurfaceVariant;
        label = context.flipperL10n.aiDataSourceStatusDisconnected;
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
