import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flipper_dashboard/ReinitializeEbm.dart';
import 'package:flipper_dashboard/TaxSettingsModal.dart';
import 'package:flipper_dashboard/TenantManagement.dart';
import 'package:flipper_dashboard/widgets/transaction_delegation_settings.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/sms/sms_notification_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'modals/_isBranchEnableForPayment.dart';

class AdminControl extends StatefulWidget {
  const AdminControl({super.key});

  @override
  State<AdminControl> createState() => _AdminControlState();
}

class _AdminControlState extends State<AdminControl> {
  final navigator = locator<RouterService>();
  bool isPosDefault = false;
  bool isOrdersDefault = true;
  bool enableDebug = false;
  bool filesDownloaded = false;
  bool forceUPSERT = false;
  bool stopTaxService = false;
  bool switchToCloudSync = false;
  String? smsPhoneNumber;
  bool enableSmsNotification = false;
  bool enableAutoAddSearch = false;
  late final TextEditingController phoneController;
  String? phoneError;
  Uint8List? receiptLogoBytes;
  bool isUpdatingReceiptLogo = false;
  bool isRemovingReceiptLogo = false;

  bool _isValidPhoneNumber(String phone) {
    // Remove any spaces or special characters
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it starts with + and has 10-15 digits
    if (cleanPhone.startsWith('+')) {
      return RegExp(r'^\+\d{10,15}$').hasMatch(cleanPhone);
    }

    // If no +, check if it has a valid length for international numbers (including country code)
    return RegExp(r'^\d{10,15}$').hasMatch(cleanPhone);
  }

  String _formatPhoneNumber(String phone) {
    // Remove any spaces or special characters
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // If it doesn't start with +, add it
    if (!cleanPhone.startsWith('+')) {
      return '+$cleanPhone';
    }
    return cleanPhone;
  }

  Future<void> _updateSmsConfig({String? phone, bool? enable}) async {
    if (phone != null && phone.isNotEmpty) {
      if (!_isValidPhoneNumber(phone)) {
        setState(() {
          phoneError =
              'Please enter a valid phone number with country code (e.g., +250783054874)';
        });
        return;
      }
      phone = _formatPhoneNumber(phone);
    }

    try {
      await SmsNotificationService.updateBranchSmsConfig(
        branchId: ProxyService.box.getBranchId()!,
        smsPhoneNumber: phone,
        enableNotification: enable,
      );

      setState(() {
        if (phone != null) smsPhoneNumber = phone;
        if (enable != null) enableSmsNotification = enable;
        phoneError = null;
      });
    } catch (e) {
      print('Error updating SMS config: $e');
      setState(() {
        phoneError = 'Failed to update SMS configuration';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isPosDefault = ProxyService.box.readBool(key: 'isPosDefault') ?? false;
    enableDebug = ProxyService.box.readBool(key: 'enableDebug') ?? false;
    isOrdersDefault = ProxyService.box.readBool(key: 'isOrdersDefault') ?? true;
    filesDownloaded =
        ProxyService.box.readBool(key: 'doneDownloadingAsset') ?? true;
    forceUPSERT = ProxyService.box.forceUPSERT();
    stopTaxService = ProxyService.box.stopTaxService() ?? false;
    switchToCloudSync = ProxyService.box.switchToCloudSync() ?? false;
    enableAutoAddSearch =
        ProxyService.box.readBool(key: 'enableAutoAddSearch') ?? false;
    phoneController = TextEditingController();
    final logoBase64 = ProxyService.box.receiptLogoBase64();
    if (logoBase64 != null && logoBase64.isNotEmpty) {
      try {
        receiptLogoBytes = base64Decode(logoBase64);
      } catch (_) {
        receiptLogoBytes = null;
      }
    }
    _loadSmsConfig();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadSmsConfig() async {
    try {
      final config = await SmsNotificationService.getBranchSmsConfig(
        ProxyService.box.getBranchId()!,
      );
      if (config != null) {
        setState(() {
          smsPhoneNumber = config.smsPhoneNumber;
          enableSmsNotification = config.enableOrderNotification;
          phoneController.text = config.smsPhoneNumber ?? '';
        });
      }
    } catch (e) {
      print('Error loading SMS config: $e');
    }
  }

  Future<void> _pickReceiptLogo() async {
    try {
      setState(() {
        isUpdatingReceiptLogo = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['png', 'jpg', 'jpeg'],
        withData: false,
      );

      if (!mounted) return;

      if (result == null) {
        setState(() {
          isUpdatingReceiptLogo = false;
        });
        return;
      }

      final platformFile = result.files.single;
      Uint8List? bytes = platformFile.bytes;

      // If bytes is null (e.g., on desktop), read from file path
      if (bytes == null && platformFile.path != null) {
        try {
          final file = File(platformFile.path!);
          bytes = await file.readAsBytes();
        } catch (e) {
          setState(() {
            isUpdatingReceiptLogo = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to read selected file. Please try again.'),
            ),
          );
          return;
        }
      }

      if (bytes == null || bytes.isEmpty) {
        setState(() {
          isUpdatingReceiptLogo = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selected file has no data. Please pick another.'),
          ),
        );
        return;
      }

      const maxSizeBytes = 295 * 1024; // 295KB, plenty for a logo
      if (bytes.length > maxSizeBytes) {
        setState(() {
          isUpdatingReceiptLogo = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Please choose an image under 200KB for best print quality.'),
          ),
        );
        return;
      }

      final encoded = base64Encode(bytes);
      await ProxyService.box.setReceiptLogoBase64(encoded);

      if (!mounted) return;

      setState(() {
        receiptLogoBytes = bytes;
        isUpdatingReceiptLogo = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Receipt logo updated.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isUpdatingReceiptLogo = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update logo: $e'),
        ),
      );
    }
  }

  Future<void> _removeReceiptLogo() async {
    try {
      setState(() {
        isRemovingReceiptLogo = true;
      });

      await ProxyService.box.clearReceiptLogo();

      if (!mounted) return;

      setState(() {
        receiptLogoBytes = null;
        isRemovingReceiptLogo = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Receipt logo removed. Default logo will be used.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isRemovingReceiptLogo = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove logo: $e'),
        ),
      );
    }
  }

  Future<void> toggleDownload(bool value) async {
    await ProxyService.box.writeBool(
        key: 'doneDownloadingAsset',
        value: !ProxyService.box.doneDownloadingAsset());
    ProxyService.strategy.reDownloadAsset();
    setState(() {
      filesDownloaded = ProxyService.box.doneDownloadingAsset();
    });
  }

  Future<void> toggleForceUPSERT(bool value) async {
    try {
      final isVatEnabled = ProxyService.box.vatEnabled();
      ProxyService.strategy
          .migrateToNewDateTime(branchId: ProxyService.box.getBranchId()!);
      await ProxyService.strategy.variants(
          taxTyCds: isVatEnabled ? ['A', 'B', 'C'] : ['D'],
          branchId: ProxyService.box.getBranchId()!,
          fetchRemote: true);
      await ProxyService.box.writeBool(
          key: 'forceUPSERT', value: !ProxyService.box.forceUPSERT());

      setState(() {
        forceUPSERT = ProxyService.box.forceUPSERT();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleTaxService(bool value) async {
    await ProxyService.box.writeBool(
        key: 'stopTaxService', value: !ProxyService.box.stopTaxService()!);
    //TODO: put this behind payment plan

    setState(() {
      stopTaxService = ProxyService.box.stopTaxService()!;
    });
  }

  void togglePos(bool value) {
    setState(() {
      isPosDefault = value;
      if (value) {
        isOrdersDefault = false;
        ProxyService.box.writeBool(key: 'isOrdersDefault', value: false);
      }
      ProxyService.box.writeBool(key: 'isPosDefault', value: value);
    });
  }

  void toggleOrders(bool value) {
    setState(() {
      isOrdersDefault = value;
      if (value) {
        isPosDefault = false;
        ProxyService.box.writeBool(key: 'isPosDefault', value: false);
      }
      ProxyService.box.writeBool(key: 'isOrdersDefault', value: value);
    });
  }

  void showReInitializeEbmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ReInitializeEbmDialog(),
    );
  }

  void enableDebugFunc(bool value) async {
    // ProxyService.setStrategy(Strategy.capella);
    // ProxyService.strategy.whoAmI();
    await ProxyService.box
        .writeBool(key: 'enableDebug', value: !ProxyService.box.enableDebug()!);

    setState(() {
      enableDebug = ProxyService.box.enableDebug()!;
    });
  }

  void toggleAutoAddSearch(bool value) async {
    await DittoSyncCoordinator.instance.hydrate<Stock>();
    await ProxyService.box.writeBool(key: 'enableAutoAddSearch', value: value);
    setState(() {
      enableAutoAddSearch = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigator.navigateTo(FlipperAppRoute());
          },
          tooltip: 'Back',
        ),
        title: const Text(
          'Management Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildMainSections(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
          child: Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SwitchSettingsCard(
                title: 'POS Default',
                subtitle: 'Set POS as default app',
                icon: Icons.point_of_sale,
                value: isPosDefault,
                onChanged: togglePos,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SwitchSettingsCard(
                title: 'Orders Default',
                subtitle: 'Set Orders as default app',
                icon: Icons.receipt_long,
                value: isOrdersDefault,
                onChanged: toggleOrders,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainSections(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildSection(
                context,
                'Account Management',
                [
                  SettingsCard(
                    title: 'User Management',
                    subtitle: 'Manage users and permissions',
                    icon: Icons.people,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => TenantManagement(),
                      );
                    },
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 16),
                  SettingsCard(
                    title: 'Branch Management',
                    subtitle: 'Manage Branch (Locations)',
                    icon: Icons.business,
                    onTap: () {
                      locator<RouterService>().navigateTo(AddBranchRoute());
                    },
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildSection(
                context,
                'Financial Controls',
                [
                  SettingsCard(
                    title: 'Tax Settings',
                    subtitle: 'Configure tax rules and rates',
                    icon: Icons.account_balance,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => TaxSettingsModal(
                          branchId: ProxyService.box.getBranchId()!,
                        ),
                      );
                    },
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  SettingsCard(
                    title: 'Payment Methods',
                    subtitle: 'Manage payment options',
                    icon: Icons.payments,
                    onTap: () {
                      showPaymentSettingsModal(context);
                    },
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildSmsConfigSection(context),
        const SizedBox(height: 32),
        _buildSystemSettings(context),
        const SizedBox(height: 32),
        _buildTransactionDelegationSection(context),
        const SizedBox(height: 32),
        _buildReceiptBrandingSection(context),
      ],
    );
  }

  Widget _buildSmsConfigSection(BuildContext context) {
    return SettingsSection(
      title: 'SMS Notifications',
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.phone,
                        size: 24,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SMS Phone Number',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Phone number with country code (e.g., +250783054874)',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          hintText: 'Enter phone number',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          errorText: phoneError,
                        ),
                        onChanged: (value) {
                          setState(() {
                            smsPhoneNumber = value.isEmpty ? null : value;
                            phoneError = null;
                          });
                        },
                        onSubmitted: (value) {
                          final phone = value.isEmpty ? null : value;
                          _updateSmsConfig(phone: phone);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SwitchSettingsCard(
          title: 'Enable Order Notification',
          subtitle: 'Receive SMS notifications for orders',
          icon: Icons.notifications,
          value: enableSmsNotification,
          onChanged: (value) => _updateSmsConfig(enable: value),
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildSystemSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
          child: Text(
            'System Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            if (kDebugMode)
              SwitchSettingsCard(
                title: 'Debug Mode',
                subtitle: 'Enable debugging features',
                icon: Icons.bug_report,
                value: enableDebug,
                onChanged: enableDebugFunc,
                color: Colors.orange,
              ),
            SwitchSettingsCard(
              title: 'EBM',
              subtitle: 'Re-initialize',
              icon: Icons.cloud_sync,
              value: switchToCloudSync,
              onChanged: (bool value) {
                showReInitializeEbmDialog(context);
              },
              color: Colors.cyan,
            ),
            SwitchSettingsCard(
              title: 'Tax Service',
              subtitle: 'Manage tax service status',
              icon: Icons.receipt,
              value: stopTaxService,
              onChanged: toggleTaxService,
              color: Colors.deepPurple,
            ),
            SwitchSettingsCard(
              title: 'Hydrate Data',
              subtitle: 'Refresh Data',
              icon: Icons.sync_problem,
              value: forceUPSERT,
              onChanged: toggleForceUPSERT,
              color: Colors.brown,
            ),
            SwitchSettingsCard(
              title: 'Asset Download',
              subtitle: 'Manage image downloads',
              icon: Icons.cloud_download,
              value: filesDownloaded,
              onChanged: toggleDownload,
              color: Colors.blueGrey,
            ),
            SwitchSettingsCard(
              title: 'Auto-Add Search',
              subtitle: 'Auto-add items when 1 match found',
              icon: Icons.auto_awesome,
              value: enableAutoAddSearch,
              onChanged: toggleAutoAddSearch,
              color: Colors.pink,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionDelegationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
          child: Text(
            'Cross-Device Features',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const TransactionDelegationSettings(),
      ],
    );
  }

  Widget _buildReceiptBrandingSection(BuildContext context) {
    final theme = Theme.of(context);
    return SettingsSection(
      title: 'Receipt Branding',
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receipt Logo',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      child: receiptLogoBytes != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                receiptLogoBytes!,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Icon(
                              Icons.image_outlined,
                              color: theme.primaryColor,
                              size: 32,
                            ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        'Upload a transparent PNG or JPG under 200KB. The logo appears at the center of printed receipts and falls back to the default if none is provided.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed:
                              isUpdatingReceiptLogo ? null : _pickReceiptLogo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          icon: isUpdatingReceiptLogo
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.upload),
                          label: Text(
                            isUpdatingReceiptLogo
                                ? 'Uploading...'
                                : 'Upload Logo',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed:
                              receiptLogoBytes != null && !isRemovingReceiptLogo
                                  ? _removeReceiptLogo
                                  : null,
                          child: isRemovingReceiptLogo
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Remove logo'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    required this.title,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class SettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Widget? trailing;

  const SettingsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.color,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SwitchSettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color color;

  const SwitchSettingsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }
}
