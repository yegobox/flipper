import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/providers/navigation_providers.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_models/providers/device_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

const _desktopOperatingSystems = {'windows', 'macos', 'linux'};

/// Widget to manage transaction delegation settings
/// Allows users to enable/disable the feature where mobile devices
/// delegate transaction completion to desktop machines
class TransactionDelegationSettings extends ConsumerStatefulWidget {
  const TransactionDelegationSettings({super.key});

  @override
  ConsumerState<TransactionDelegationSettings> createState() =>
      _TransactionDelegationSettingsState();
}

class _TransactionDelegationSettingsState
    extends ConsumerState<TransactionDelegationSettings> {
  bool _isEnabled = false;
  bool _isLoading = true;
  String? _selectedDeviceId;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = ProxyService.box.readBool(
      key: 'enableTransactionDelegation',
    );

    final selectedDeviceId = ProxyService.box.readString(
      key: 'selectedDelegationDeviceId',
    );

    final isEnabled = enabled ?? false;
    ref.read(transactionDelegationEnabledProvider.notifier).state = isEnabled;
    setState(() {
      _isEnabled = isEnabled;
      _selectedDeviceId = selectedDeviceId;
      _isLoading = false;
    });
  }

  Future<void> _selectDevice(String deviceId) async {
    try {
      await ProxyService.box.writeString(
        key: 'selectedDelegationDeviceId',
        value: deviceId,
      );

      setState(() {
        _selectedDeviceId = deviceId;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Delegation device selected'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting device: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
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

      ref.read(transactionDelegationEnabledProvider.notifier).state = value;
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
    const borderColor = Color(0xFFE5E7EB);

    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(20),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.string(
                  AdminDashboardSvgs.transactionDelegation,
                  width: 24,
                  height: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Delegation',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPlatformDescription(),
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isEnabled,
                onChanged: _toggleDelegation,
                activeTrackColor: PosLayoutBreakpoints.posAccentBlue,
                inactiveTrackColor: const Color(0xFFE5E7EB),
                inactiveThumbColor: Colors.white,
                activeThumbColor: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildInfoSection(context),
          if (_isDesktopPlatform() && _isEnabled) ...[
            const SizedBox(height: 16),
            _buildDeviceSelectionSection(context),
          ],
        ],
      ),
    );
  }

  String _getPlatformDescription() {
    if (_isMobilePlatform()) {
      return 'Delegate receipt printing to desktop when EBM server is unavailable';
    } else if (_isDesktopPlatform()) {
      return 'Process receipts delegated from mobile devices, or delegate printing to another desktop';
    }
    return 'Cross-device transaction processing';
  }

  Widget _buildDeviceSelectionSection(BuildContext context) {
    final branchId = ProxyService.box.getBranchId();

    if (branchId == null) {
      return const SizedBox.shrink();
    }

    final devicesAsync = ref.watch(
      devicesForBranchProvider(branchId: branchId),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.devices_rounded,
                  color: Color(0xFF0078D4),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Delegate printing to',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          devicesAsync.when(
            data: (devices) {
              final thisDeviceId = ProxyService.box.getThisDeviceId();
              final targetDevices = devices
                  .where(
                    (device) =>
                        device.id != thisDeviceId &&
                        _desktopOperatingSystems.contains(device.deviceName),
                  )
                  .toList();

              if (targetDevices.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'No other desktop devices found in this branch',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              }

              return RadioGroup<String>(
                groupValue: _selectedDeviceId,
                onChanged: (value) {
                  if (value != null) {
                    _selectDevice(value);
                  }
                },
                child: Column(
                  children: targetDevices.map((device) {
                    return RadioListTile<String>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        device.deviceName ?? 'Unknown Device',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: device.phone != null
                          ? Text('Phone: ${device.phone}')
                          : null,
                      value: device.id,
                      activeColor: const Color(0xFF0078D4),
                    );
                  }).toList(),
                ),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error loading devices: ${error.toString()}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    const infoBlue = Color(0xFF2563EB);
    const infoBg = Color(0xFFEFF6FF);
    const infoBorder = Color(0xFFBFDBFE);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: infoBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: infoBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.string(
                AdminDashboardSvgs.infoCircle,
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'How it works',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: infoBlue,
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
              '• Desktop monitors for delegated transactions in real-time',
            ),
            _buildInfoItem(
              '• Automatically processes receipts from mobile devices',
            ),
            _buildInfoItem(
              '• Optionally pick another desktop below to delegate this device\'s own printing to',
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
        style: GoogleFonts.outfit(
          fontSize: 13,
          color: const Color(0xFF1D4ED8),
          height: 1.4,
        ),
      ),
    );
  }
}
