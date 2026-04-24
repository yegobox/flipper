import 'dart:convert';
import 'dart:io';

import 'package:flipper_dashboard/ReinitializeEbm.dart';
import 'package:flipper_dashboard/TaxSettingsModal.dart';
import 'package:flipper_dashboard/TenantManagement.dart';
import 'package:flipper_dashboard/widgets/transaction_delegation_settings.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/sms/sms_notification_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flipper_ui/dialogs/AdminPinDialog.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'modals/_isBranchEnableForPayment.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _kAdminCardBorder = Color(0xFFE5E7EB);
/// Matches [TicketsScreen] scaffold / app bar chrome.
const Color _kAdminScaffoldBg = Color(0xFFF2F4F7);
const Color _kAdminAppBarIconCircleBorder = Color(0xFFE0E4EB);

ButtonStyle _adminAppBarCircleIconStyle() {
  return IconButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black87,
    shape: const CircleBorder(),
    side: const BorderSide(color: _kAdminAppBarIconCircleBorder, width: 1),
    padding: const EdgeInsets.all(10),
    minimumSize: const Size(40, 40),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}
const Color _kAdminBarBlue = Color(0xFF2563EB);
const Color _kAdminBarOrange = Color(0xFFD97706);
const Color _kAdminBarTeal = Color(0xFF0D9488);
const Color _kAdminBarRed = Color(0xFFDC2626);
const Color _kAdminBarSlate = Color(0xFF64748B);
const Color _kAdminBarPurple = Color(0xFF7C3AED);
const Color _kAdminBarReceipt = Color(0xFFEA580C);
const Color _kAdminTitleText = Color(0xFF111827);
const Color _kAdminSubtitleText = Color(0xFF6B7280);

BoxDecoration _adminCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: _kAdminCardBorder),
  );
}

Widget _adminSectionHeader(BuildContext context, String title, Color barColor) {
  return Padding(
    padding: const EdgeInsets.only(left: 2, bottom: 12),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: _kAdminTitleText,
          ),
        ),
      ],
    ),
  );
}

Widget _adminSubSectionHeader(String title, Color barColor) {
  return Row(
    children: [
      Container(
        width: 3,
        height: 14,
        decoration: BoxDecoration(
          color: barColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: _kAdminTitleText,
        ),
      ),
    ],
  );
}

Widget _adminLeadingSvg(String svg, Color backgroundTint) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: backgroundTint,
      borderRadius: BorderRadius.circular(10),
    ),
    child: AdminDashboardSvgs.picture(svg, size: 24),
  );
}

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
  bool userLoggingEnabled = false;
  final settingsService = locator<SettingsService>();

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
    userLoggingEnabled = ProxyService.box.getUserLoggingEnabled() ?? false;
    phoneController = TextEditingController();
    final logoBase64 = ProxyService.box.receiptLogoBase64();
    if (logoBase64 != null && logoBase64.isNotEmpty) {
      try {
        receiptLogoBytes = base64Decode(logoBase64);
      } catch (_) {
        receiptLogoBytes = null;
      }
    }
    settingsService.getAdminPinToggleState();
    settingsService.getPriceQuantityAdjustmentToggleState();
    settingsService.getCurrencyDecimalToggleState();
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
          showErrorNotification(
            context,
            'Failed to read selected file. Please try again.',
          );
          return;
        }
      }

      if (bytes == null || bytes.isEmpty) {
        setState(() {
          isUpdatingReceiptLogo = false;
        });
        showErrorNotification(
          context,
          'Selected file has no data. Please pick another.',
        );
        return;
      }

      const maxSizeBytes = 295 * 1024; // 295KB, plenty for a logo
      if (bytes.length > maxSizeBytes) {
        setState(() {
          isUpdatingReceiptLogo = false;
        });
        showErrorNotification(
          context,
          'Please choose an image under 200KB for best print quality.',
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

      showSuccessNotification(context, 'Receipt logo updated.');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isUpdatingReceiptLogo = false;
      });
      showErrorNotification(context, 'Failed to update logo: $e');
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

      showSuccessNotification(
        context,
        'Receipt logo removed. Default logo will be used.',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isRemovingReceiptLogo = false;
      });
      showErrorNotification(context, 'Failed to remove logo: $e');
    }
  }

  Future<void> toggleDownload(bool value) async {
    await ProxyService.box.writeBool(
      key: 'doneDownloadingAsset',
      value: !ProxyService.box.doneDownloadingAsset(),
    );
    ProxyService.strategy.reDownloadAsset();
    setState(() {
      filesDownloaded = ProxyService.box.doneDownloadingAsset();
    });
  }

  Future<void> toggleForceUPSERT(bool value) async {
    try {
      final isVatEnabled = ProxyService.box.vatEnabled();
      ProxyService.strategy.migrateToNewDateTime(
        branchId: ProxyService.box.getBranchId()!,
      );
      await ProxyService.strategy.variants(
        taxTyCds: isVatEnabled ? ['A', 'B', 'C'] : ['D'],
        branchId: ProxyService.box.getBranchId()!,
        fetchRemote: true,
      );
      await ProxyService.box.writeBool(
        key: 'forceUPSERT',
        value: !ProxyService.box.forceUPSERT(),
      );

      setState(() {
        forceUPSERT = ProxyService.box.forceUPSERT();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleTaxService(bool value) async {
    await ProxyService.box.writeBool(
      key: 'stopTaxService',
      value: !ProxyService.box.stopTaxService()!,
    );
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
    showDialog(context: context, builder: (context) => ReInitializeEbmDialog());
  }

  void enableDebugFunc(bool value) async {
    // await DittoSyncCoordinator.instance.hydrate<Stock>();
    await ProxyService.box.writeBool(
      key: 'enableDebug',
      value: !ProxyService.box.enableDebug()!,
    );

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

  void toggleUserLogging(bool value) async {
    await ProxyService.box.setUserLoggingEnabled(value);
    setState(() {
      userLoggingEnabled = value;
    });
  }

  void togglePriceQuantityAdjustment(bool value) async {
    await settingsService.togglePriceQuantityAdjustment(
      enabled: value,
      businessId: ProxyService.box.getBusinessId()!,
    );
  }

  void toggleCurrencyDecimal(bool value) async {
    await settingsService.toggleCurrencyDecimal(
      enabled: value,
      businessId: ProxyService.box.getBusinessId()!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleFontSize = MediaQuery.sizeOf(context).width < 600 ? 16.0 : 20.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        final horizontalPadding = isDesktop ? 24.0 : 12.0;

        return Scaffold(
          backgroundColor: _kAdminScaffoldBg,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: false,
            titleSpacing: 12,
            leadingWidth: 56,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.shade200,
              ),
            ),
            leading: IconButton(
              style: _adminAppBarCircleIconStyle(),
              onPressed: () => navigator.navigateTo(FlipperAppRoute()),
              icon: const Icon(Icons.close, size: 22),
              tooltip: 'Close',
            ),
            title: Text(
              'Management Dashboard',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: titleFontSize,
                color: Colors.black,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  splashRadius: 22,
                  onSelected: (value) {
                    if (value == 'refresh') {
                      setState(() {});
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 8),
                          Text('Refresh'),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: _kAdminAppBarIconCircleBorder),
                    ),
                    child: Icon(
                      Icons.more_vert,
                      size: 22,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                20,
                horizontalPadding,
                32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickActions(context),
                  const SizedBox(height: 28),
                  _buildMainSections(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _adminSectionHeader(context, 'Quick actions', _kAdminBarBlue),
        Row(
          children: [
            Expanded(
              child: SwitchSettingsCard(
                title: 'POS Default',
                subtitle: 'Set POS as default app',
                leading: _adminLeadingSvg(
                  AdminDashboardSvgs.posDefault,
                  _kAdminBarBlue.withValues(alpha: 0.1),
                ),
                value: isPosDefault,
                onChanged: togglePos,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SwitchSettingsCard(
                title: 'Orders Default',
                subtitle: 'Set Orders as default app',
                leading: _adminLeadingSvg(
                  AdminDashboardSvgs.ordersDefault,
                  const Color(0xFF16A34A).withValues(alpha: 0.1),
                ),
                value: isOrdersDefault,
                onChanged: toggleOrders,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainSections(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _adminSectionHeader(context, 'Account & financial', _kAdminBarBlue),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _adminSubSectionHeader(
                    'Account management',
                    _kAdminBarBlue,
                  ),
                  const SizedBox(height: 16),
                  SettingsCard(
                    title: 'User Management',
                    subtitle: 'Manage users and permissions',
                    leading: _adminLeadingSvg(
                      AdminDashboardSvgs.userManagement,
                      _kAdminBarBlue.withValues(alpha: 0.1),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => TenantManagement(),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SettingsCard(
                    title: 'Branch Management',
                    subtitle: 'Manage branch locations',
                    leading: _adminLeadingSvg(
                      AdminDashboardSvgs.branchManagement,
                      _kAdminBarTeal.withValues(alpha: 0.1),
                    ),
                    onTap: () {
                      locator<RouterService>().navigateTo(AddBranchRoute());
                    },
                  ),
                  ],
                ),
              ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _adminSubSectionHeader(
                    'Financial controls',
                    _kAdminBarOrange,
                  ),
                  const SizedBox(height: 16),
                  SettingsCard(
                    title: 'Tax Settings',
                    subtitle: 'Configure tax rules and rates',
                    leading: _adminLeadingSvg(
                      AdminDashboardSvgs.taxSettings,
                      _kAdminBarOrange.withValues(alpha: 0.12),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => TaxSettingsModal(
                          branchId: ProxyService.box.getBranchId()!,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SettingsCard(
                    title: 'Payment Methods',
                    subtitle: 'Manage payment options',
                    leading: _adminLeadingSvg(
                      AdminDashboardSvgs.paymentMethods,
                      _kAdminBarPurple.withValues(alpha: 0.1),
                    ),
                    onTap: () {
                      showPaymentSettingsModal(context);
                    },
                  ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 28),
        _buildSmsConfigSection(context),
        const SizedBox(height: 28),
        _buildSecuritySection(context),
        const SizedBox(height: 28),
        _buildSystemSettings(context),
        const SizedBox(height: 28),
        _buildTransactionDelegationSection(context),
        const SizedBox(height: 28),
        _buildReceiptBrandingSection(context),
      ],
    );
  }

  Widget _buildSmsConfigSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _adminSectionHeader(context, 'SMS notifications', _kAdminBarTeal),
        Container(
          decoration: _adminCardDecoration(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _adminLeadingSvg(
                      AdminDashboardSvgs.smsPhone,
                      _kAdminBarTeal.withValues(alpha: 0.1),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SMS Phone Number',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: _kAdminTitleText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Phone number with country code (e.g. +250783054874)',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: _kAdminSubtitleText,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: phoneController,
                        style: GoogleFonts.outfit(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Enter phone number',
                          hintStyle: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFAFAFA),
                          errorText: phoneError,
                          errorMaxLines: 2,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: _kAdminBarBlue,
                              width: 1.2,
                            ),
                          ),
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
              ),
              Divider(height: 1, thickness: 1, color: _kAdminCardBorder),
              Padding(
                padding: const EdgeInsets.all(16),
                child: _AdminSwitchRow(
                  title: 'Enable Order Notifications',
                  subtitle: 'Receive SMS notifications for orders',
                  leading: _adminLeadingSvg(
                    AdminDashboardSvgs.enableNotifications,
                    const Color(0xFF16A34A).withValues(alpha: 0.1),
                  ),
                  value: enableSmsNotification,
                  onChanged: (value) => _updateSmsConfig(enable: value),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSystemSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _adminSectionHeader(context, 'System settings', _kAdminBarSlate),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 2.45,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          children: [
            if (kDebugMode)
              SwitchSettingsCard(
                title: 'Debug Mode',
                subtitle: 'Enable debugging features',
                leading: _adminLeadingSvg(
                  AdminDashboardSvgs.debugMode,
                  _kAdminBarOrange.withValues(alpha: 0.12),
                ),
                value: enableDebug,
                onChanged: enableDebugFunc,
              ),
            SwitchSettingsCard(
              title: 'EBM',
              subtitle: 'Re-initialize EBM',
              leading: _adminLeadingSvg(
                AdminDashboardSvgs.ebm,
                _kAdminBarTeal.withValues(alpha: 0.1),
              ),
              value: switchToCloudSync,
              onChanged: (bool value) {
                showReInitializeEbmDialog(context);
              },
            ),
            SwitchSettingsCard(
              title: 'Tax Service',
              subtitle: 'Manage tax service status',
              leading: _adminLeadingSvg(
                AdminDashboardSvgs.taxService,
                _kAdminBarPurple.withValues(alpha: 0.1),
              ),
              value: stopTaxService,
              onChanged: toggleTaxService,
            ),
            SwitchSettingsCard(
              title: 'Hydrate Data',
              subtitle: 'Refresh all local data',
              leading: _adminLeadingSvg(
                AdminDashboardSvgs.hydrateData,
                _kAdminBarRed.withValues(alpha: 0.1),
              ),
              value: forceUPSERT,
              onChanged: toggleForceUPSERT,
            ),
            SwitchSettingsCard(
              title: 'Asset Download',
              subtitle: 'Manage image downloads',
              leading: _adminLeadingSvg(
                AdminDashboardSvgs.assetDownload,
                _kAdminBarBlue.withValues(alpha: 0.1),
              ),
              value: filesDownloaded,
              onChanged: toggleDownload,
            ),
            SwitchSettingsCard(
              title: 'Auto-Add Search',
              subtitle: 'Auto-add items when 1 match',
              leading: _adminLeadingSvg(
                AdminDashboardSvgs.autoAddSearch,
                const Color(0xFFEC4899).withValues(alpha: 0.1),
              ),
              value: enableAutoAddSearch,
              onChanged: toggleAutoAddSearch,
            ),
            SwitchSettingsCard(
              title: 'User Logging',
              subtitle: 'Enable extensive user logging',
              leading: _adminLeadingSvg(
                AdminDashboardSvgs.userLogging,
                const Color(0xFF6366F1).withValues(alpha: 0.12),
              ),
              value: userLoggingEnabled,
              onChanged: toggleUserLogging,
            ),
            ListenableBuilder(
              listenable: settingsService,
              builder: (context, child) {
                return SwitchSettingsCard(
                  title: 'Price-Qty Adj',
                  subtitle: 'Auto-adjust qty on price change',
                  leading: _adminLeadingSvg(
                    AdminDashboardSvgs.priceQtyAdjustment,
                    _kAdminBarRed.withValues(alpha: 0.1),
                  ),
                  value: settingsService.enablePriceQuantityAdjustment,
                  onChanged: togglePriceQuantityAdjustment,
                );
              },
            ),
            ListenableBuilder(
              listenable: settingsService,
              builder: (context, child) {
                return SwitchSettingsCard(
                  title: 'Decimals',
                  subtitle: 'Enable fractional pricing',
                  leading: _adminLeadingSvg(
                    AdminDashboardSvgs.decimalsCurrency,
                    const Color(0xFF16A34A).withValues(alpha: 0.1),
                  ),
                  value: settingsService.isCurrencyDecimal,
                  onChanged: toggleCurrencyDecimal,
                );
              },
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
        _adminSectionHeader(
          context,
          'Cross-device features',
          _kAdminBarPurple,
        ),
        const TransactionDelegationSettings(),
      ],
    );
  }

  Widget _buildReceiptBrandingSection(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _adminSectionHeader(
          context,
          'Receipt branding',
          _kAdminBarReceipt,
        ),
        Container(
          decoration: _adminCardDecoration(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Receipt Logo',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: _kAdminTitleText,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kAdminCardBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomPaint(
                      foregroundPainter: _ReceiptLogoDashedBorderPainter(
                        color: Colors.grey.shade400,
                      ),
                      child: Container(
                        width: 88,
                        height: 88,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(4),
                        child: receiptLogoBytes != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  receiptLogoBytes!,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : AdminDashboardSvgs.picture(
                                AdminDashboardSvgs.receiptLogoPlaceholder,
                                size: 36,
                              ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        'Upload a transparent PNG or JPG under 200KB. The logo appears at the center of printed receipts and falls back to the default if none is provided.',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: _kAdminSubtitleText,
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: isUpdatingReceiptLogo
                              ? null
                              : _pickReceiptLogo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isUpdatingReceiptLogo)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              else
                                SvgPicture.string(
                                  AdminDashboardSvgs.uploadIconWhite,
                                  width: 16,
                                  height: 16,
                                ),
                              const SizedBox(width: 8),
                              Text(
                                isUpdatingReceiptLogo
                                    ? 'Uploading...'
                                    : 'Upload Logo',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
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
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Remove logo',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: _kAdminSubtitleText,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsService,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _adminSectionHeader(context, 'Security', _kAdminBarRed),
            Container(
              decoration: _adminCardDecoration(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _AdminSwitchRow(
                      title: 'Administrator PIN',
                      subtitle:
                          'Secure sensitive actions like deleting or editing products',
                      leading: _adminLeadingSvg(
                        AdminDashboardSvgs.administratorPin,
                        _kAdminBarBlue.withValues(alpha: 0.1),
                      ),
                      value: settingsService.isAdminPinEnabled,
                      onChanged: (value) async {
                        if (value) {
                          final setting = await settingsService.settings();
                          if (setting?.adminPin == null) {
                            await showAdminPinDialog(
                              context: context,
                              mode: AdminPinMode.set,
                            );
                          } else {
                            await settingsService.toggleAdminPin(
                              enabled: true,
                              businessId: ProxyService.box.getBusinessId()!,
                            );
                          }
                        } else {
                          final setting = await settingsService.settings();
                          if (setting?.adminPin != null) {
                            final confirmed = await showAdminPinDialog(
                              context: context,
                              mode: AdminPinMode.verify,
                              expectedPin: setting!.adminPin,
                            );
                            if (confirmed == true) {
                              await settingsService.toggleAdminPin(
                                enabled: false,
                                businessId: ProxyService.box.getBusinessId()!,
                              );
                            }
                          } else {
                            await settingsService.toggleAdminPin(
                              enabled: false,
                              businessId: ProxyService.box.getBusinessId()!,
                            );
                          }
                        }
                      },
                    ),
                  ),
                  if (settingsService.isAdminPinEnabled) ...[
                    Divider(height: 1, thickness: 1, color: _kAdminCardBorder),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          final setting = await settingsService.settings();
                          final confirmed = await showAdminPinDialog(
                            context: context,
                            mode: AdminPinMode.verify,
                            expectedPin: setting?.adminPin,
                          );
                          if (confirmed == true) {
                            await showAdminPinDialog(
                              context: context,
                              mode: AdminPinMode.set,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _AdminNavRow(
                            leading: _adminLeadingSvg(
                              AdminDashboardSvgs.resetAdministratorPin,
                              _kAdminBarBlue.withValues(alpha: 0.1),
                            ),
                            title: 'Reset Administrator PIN',
                            subtitle:
                                'Update your high-security 4-digit PIN',
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Light dashed border for receipt logo drop zone (matches reference UI).
class _ReceiptLogoDashedBorderPainter extends CustomPainter {
  _ReceiptLogoDashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(10),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        final extract = metric.extractPath(d, d + 5);
        canvas.drawPath(extract, paint);
        d += 8;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ReceiptLogoDashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _AdminSwitchRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _AdminSwitchRow({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leading,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: _kAdminTitleText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: _kAdminSubtitleText,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: PosLayoutBreakpoints.posAccentBlue,
          inactiveTrackColor: const Color(0xFFE5E7EB),
          inactiveThumbColor: Colors.white,
          activeThumbColor: Colors.white,
        ),
      ],
    );
  }
}

class _AdminNavRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;

  const _AdminNavRow({
    required this.leading,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leading,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: _kAdminTitleText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: _kAdminSubtitleText,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        SvgPicture.string(
          AdminDashboardSvgs.chevronRight,
          width: 14,
          height: 14,
        ),
      ],
    );
  }
}

class SettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final VoidCallback onTap;
  final Widget? trailing;

  const SettingsCard({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.onTap,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _adminCardDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leading,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: _kAdminTitleText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: _kAdminSubtitleText,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[trailing!, const SizedBox(width: 8)],
                SvgPicture.string(
                  AdminDashboardSvgs.chevronRight,
                  width: 14,
                  height: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SwitchSettingsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchSettingsCard({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _adminCardDecoration(),
      padding: const EdgeInsets.all(16),
      child: _AdminSwitchRow(
        title: title,
        subtitle: subtitle,
        leading: leading,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
