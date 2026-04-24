import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_fonts/google_fonts.dart';
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
          ],
        ],
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
