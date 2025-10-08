import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/transaction_delegation_service.dart';
import 'dart:io';

/// Widget to manage transaction delegation settings
/// Allows users to enable/disable the feature where mobile devices
/// delegate transaction completion to desktop machines
class TransactionDelegationSettings extends StatefulWidget {
  const TransactionDelegationSettings({Key? key}) : super(key: key);

  @override
  State<TransactionDelegationSettings> createState() =>
      _TransactionDelegationSettingsState();
}

class _TransactionDelegationSettingsState
    extends State<TransactionDelegationSettings> {
  bool _isEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = ProxyService.box.readBool(
      key: 'enableTransactionDelegation',
    );

    setState(() {
      _isEnabled = enabled ?? false;
      _isLoading = false;
    });
  }

  Future<void> _toggleDelegation(bool value) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ProxyService.box.writeBool(
        key: 'enableTransactionDelegation',
        value: value,
      );

      // Start/stop monitoring service on desktop
      if (_isDesktopPlatform()) {
        final service = TransactionDelegationService();
        if (value) {
          await service.startMonitoring();
        } else {
          service.stopMonitoring();
        }
      }

      setState(() {
        _isEnabled = value;
        _isLoading = false;
      });

      // Show confirmation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              value
                  ? 'Transaction delegation enabled'
                  : 'Transaction delegation disabled',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  bool _isDesktopPlatform() {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  bool _isMobilePlatform() {
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sync,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Delegation',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getPlatformDescription(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isEnabled,
                  onChanged: _toggleDelegation,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoSection(context),
            if (_isDesktopPlatform() && _isEnabled) ...[
              const SizedBox(height: 16),
              _buildDesktopMonitoringStatus(context),
            ],
          ],
        ),
      ),
    );
  }

  String _getPlatformDescription() {
    if (_isMobilePlatform()) {
      return 'Delegate receipt printing to desktop when EBM server is unavailable';
    } else if (_isDesktopPlatform()) {
      return 'Process receipts delegated from mobile devices';
    }
    return 'Cross-device transaction processing';
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'How it works',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isMobilePlatform()) ...[
            _buildInfoItem(
              '• Mobile completes transaction but delegates receipt generation',
            ),
            _buildInfoItem(
              '• Desktop picks up the transaction via Ditto sync',
            ),
            _buildInfoItem(
              '• Desktop generates receipt and communicates with EBM server',
            ),
            _buildInfoItem(
              '• Mobile is notified when processing is complete',
            ),
          ] else if (_isDesktopPlatform()) ...[
            _buildInfoItem(
              '• Desktop monitors for delegated transactions every 10 seconds',
            ),
            _buildInfoItem(
              '• Automatically processes receipts from mobile devices',
            ),
            _buildInfoItem(
              '• Handles EBM server communication',
            ),
            _buildInfoItem(
              '• Syncs results back to mobile via Ditto',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildDesktopMonitoringStatus(BuildContext context) {
    final service = TransactionDelegationService();
    final isMonitoring = service.isMonitoring;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMonitoring ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMonitoring ? Colors.green[200]! : Colors.orange[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isMonitoring ? Icons.check_circle : Icons.warning,
            color: isMonitoring ? Colors.green[700] : Colors.orange[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isMonitoring
                  ? 'Desktop monitoring is active'
                  : 'Desktop monitoring is inactive',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isMonitoring ? Colors.green[900] : Colors.orange[900],
              ),
            ),
          ),
          if (isMonitoring)
            TextButton.icon(
              onPressed: () async {
                try {
                  await service.checkNow();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Checked for delegated transactions'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Check Now'),
            ),
        ],
      ),
    );
  }
}
