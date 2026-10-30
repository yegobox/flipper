import 'dart:async';

import 'package:flipper_dashboard/features/admin/sections/admin_actions.dart';
import 'package:flipper_dashboard/features/admin/sections/admin_profile_card.dart';
import 'package:flipper_dashboard/features/admin/sections/admin_style.dart';
import 'package:flipper_dashboard/features/admin/sections/receipt_logo_card.dart';
import 'package:flipper_dashboard/features/admin/sections/sms_notifications_card.dart';
import 'package:flipper_dashboard/features/admin/widgets/cash_reset_dialog.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flipper_dashboard/features/admin/widgets/language_settings_card.dart';
import 'package:flipper_dashboard/features/admin/widgets/sms_bridge_page.dart';
import 'package:flipper_dashboard/features/online_shop/online_shop_page.dart';
import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mode_admin_section.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_mode_admin_section.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_mode_switch.dart';
import 'package:flipper_dashboard/features/service_mode_device_section.dart';
import 'package:flipper_dashboard/features/service_mode_shell.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_dashboard/features/till_hardware_section.dart';
import 'package:flipper_dashboard/ReinitializeEbm.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/TaxSettingsModal.dart';
import 'package:flipper_dashboard/TenantManagement.dart';
import 'package:flipper_dashboard/widgets/transaction_delegation_settings.dart';
import 'package:flipper_models/account_mode/account_mode.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'modals/_isBranchEnableForPayment.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/widgets/admin_dashboard_svgs.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

bool _adminControlOpen = false;

/// Opens [AdminControl] unless it is already open.
///
/// Every entry point (POS rail gear, bar floor, hotel rooms) goes through here.
/// A plain `navigateTo` per tap stacked one Admin screen per click, and each
/// one re-ran the printer scan in [TillHardwareSection], which froze the till.
/// `navigateTo` completes when the route pops, so the latch clears on close.
/// Callers fire this from tap handlers without awaiting it, so a navigation
/// failure is logged here rather than surfacing as an unhandled async error.
Future<void> openAdminControl({RouterService? router}) async {
  if (_adminControlOpen) return;
  _adminControlOpen = true;
  try {
    await (router ?? locator<RouterService>()).navigateTo(AdminControlRoute());
  } catch (e, s) {
    talker.error('openAdminControl: navigation failed', e, s);
  } finally {
    _adminControlOpen = false;
  }
}

class AdminControl extends ConsumerStatefulWidget {
  const AdminControl({super.key});

  @override
  ConsumerState<AdminControl> createState() => _AdminControlState();
}

class _AdminControlState extends ConsumerState<AdminControl> {
  final navigator = locator<RouterService>();
  bool isPosDefault = false;
  bool isOrdersDefault = true;
  bool enableDebug = false;
  bool filesDownloaded = false;
  bool forceUPSERT = false;
  bool stopTaxService = false;
  bool switchToCloudSync = false;
  bool enableAutoAddSearch = false;
  bool userLoggingEnabled = false;
  final settingsService = locator<SettingsService>();

  /// [serviceModeRevision] when this screen opened. The Bar / Hotel toggles and
  /// the device picker only change the mode; leaving Settings is what moves the
  /// terminal onto that mode's own screen.
  late final int _serviceModeRevisionAtOpen;

  final _profileCardKey = GlobalKey<AdminProfileCardState>();
  @override
  void initState() {
    super.initState();
    _serviceModeRevisionAtOpen = serviceModeRevision.value;
    final defaults = AdminActions.defaultApps();
    isPosDefault = defaults.pos;
    enableDebug = ProxyService.box.readBool(key: 'enableDebug') ?? false;
    isOrdersDefault = defaults.orders;
    filesDownloaded =
        ProxyService.box.readBool(key: 'doneDownloadingAsset') ?? true;
    forceUPSERT = ProxyService.box.forceUPSERT();
    stopTaxService = ProxyService.box.stopTaxService() ?? false;
    switchToCloudSync = ProxyService.box.switchToCloudSync() ?? false;
    enableAutoAddSearch = AdminActions.autoAddSearch();
    userLoggingEnabled = ProxyService.box.getUserLoggingEnabled() ?? false;
    settingsService.getAdminPinToggleState();
    settingsService.getPriceQuantityAdjustmentToggleState();
    settingsService.getCurrencyDecimalToggleState();
  }

  @override
  void dispose() {
    if (serviceModeRevision.value != _serviceModeRevisionAtOpen) {
      // After the frame, once this route is off the stack, so the sync sees
      // the shell underneath rather than Settings.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => syncServiceModeShell(),
      );
    }
    super.dispose();
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
      if (value) isOrdersDefault = false;
      AdminActions.setPosDefault(value);
    });
  }

  void toggleOrders(bool value) {
    setState(() {
      isOrdersDefault = value;
      if (value) isPosDefault = false;
      AdminActions.setOrdersDefault(value);
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
    await AdminActions.setAutoAddSearch(value);
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

  void togglePriceQuantityAdjustment(bool value) =>
      AdminActions.setPriceQuantityAdjustment(value);

  void toggleCurrencyDecimal(bool value) =>
      AdminActions.setCurrencyDecimal(value);

  void toggleTicketReviewWorkflow(bool value) =>
      AdminActions.setTicketReviewWorkflow(value);

  @override
  Widget build(BuildContext context) {
    final titleFontSize = MediaQuery.sizeOf(context).width < 600 ? 16.0 : 20.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        final horizontalPadding = isDesktop ? 24.0 : 12.0;

        return Scaffold(
          backgroundColor: kAdminScaffoldBg,
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
              style: adminAppBarCircleIconStyle(),
              // Go back to wherever Admin was opened from (POS, bar floor…).
              // Pushing a fresh FlipperAppRoute here stacked a second
              // dashboard and dropped bar-floor users out of bar mode.
              // A mode switched here is applied straight away: turning Bar
              // and Hotel off must land on POS, not back on the bar floor
              // this screen was opened from.
              onPressed: () async {
                if (!navigator.router.canPop()) {
                  await navigator.clearStackAndShow(FlipperAppRoute());
                  return;
                }
                final modeChanged =
                    serviceModeRevision.value != _serviceModeRevisionAtOpen;
                // `pop`, not `back`: back returns before the route is gone,
                // and the sync must see the screen underneath.
                final popped = await navigator.pop();
                if (popped && modeChanged) syncServiceModeShell();
              },
              icon: const Icon(Icons.close, size: 22),
              tooltip: context.flipperL10n.close,
            ),
            title: Text(
              context.flipperL10n.managementDashboard,
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
                      _profileCardKey.currentState?.reload();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          const Icon(Icons.refresh),
                          const SizedBox(width: 8),
                          Text(context.flipperL10n.refresh),
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
                      border: Border.all(color: kAdminAppBarIconCircleBorder),
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
                  _buildAdminProfileSection(context),
                  const SizedBox(height: 28),
                  _buildQuickActions(context),
                  const SizedBox(height: 28),
                  const BarModeAdminSection(),
                  const SizedBox(height: 28),
                  const HotelModeAdminSection(),
                  // Carries its own top gap: it collapses to nothing on a
                  // branch with no service mode on, and a fixed SizedBox here
                  // would leave a double gap in the common case.
                  const ServiceModeDeviceSection(),
                  // Desktop only; carries its own top gap like the one above.
                  const TillHardwareSection(),
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

  Widget _buildAdminProfileSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminSectionHeader(
          context,
          context.flipperL10n.adminProfile,
          kAdminBarBlue,
        ),
        const SizedBox(height: 4),
        AdminProfileCard(key: _profileCardKey),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminSectionHeader(
          context,
          context.flipperL10n.quickActions,
          kAdminBarBlue,
        ),
        Row(
          children: [
            Expanded(
              child: SwitchSettingsCard(
                title: context.flipperL10n.posDefault,
                subtitle: context.flipperL10n.setPosAsDefaultApp,
                leading: adminLeadingSvg(
                  AdminDashboardSvgs.posDefault,
                  kAdminBarBlue.withValues(alpha: 0.1),
                ),
                value: isPosDefault,
                onChanged: togglePos,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SwitchSettingsCard(
                title: context.flipperL10n.ordersDefault,
                subtitle: context.flipperL10n.setOrdersAsDefaultApp,
                leading: adminLeadingSvg(
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

  Widget _buildPreferencesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminSectionHeader(
          context,
          context.flipperL10n.preferences,
          kAdminBarPurple,
        ),
        const LanguageSettingsCard(),
      ],
    );
  }

  Widget _buildMainSections(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPreferencesSection(context),
        const SizedBox(height: 28),
        adminSectionHeader(
          context,
          context.flipperL10n.accountAndFinancial,
          kAdminBarBlue,
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // adminSubSectionHeader('Account management', kAdminBarBlue),
                  const SizedBox(height: 16),
                  SettingsCard(
                    title: context.flipperL10n.userManagement,
                    subtitle: context.flipperL10n.manageUsersAndPermissions,
                    leading: adminLeadingSvg(
                      AdminDashboardSvgs.userManagement,
                      kAdminBarBlue.withValues(alpha: 0.1),
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
                    title: context.flipperL10n.branchManagement,
                    subtitle: context.flipperL10n.manageBranchLocations,
                    leading: adminLeadingSvg(
                      AdminDashboardSvgs.branchManagement,
                      kAdminBarTeal.withValues(alpha: 0.1),
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
                  adminSubSectionHeader(
                    context.flipperL10n.financialControls,
                    kAdminBarOrange,
                  ),
                  const SizedBox(height: 16),
                  SettingsCard(
                    title: context.flipperL10n.taxSettings,
                    subtitle: context.flipperL10n.configureTaxRulesAndRates,
                    leading: adminLeadingSvg(
                      AdminDashboardSvgs.taxSettings,
                      kAdminBarOrange.withValues(alpha: 0.12),
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
                    title: context.flipperL10n.paymentMethods,
                    subtitle: context.flipperL10n.managePaymentOptions,
                    leading: adminLeadingSvg(
                      AdminDashboardSvgs.paymentMethods,
                      kAdminBarPurple.withValues(alpha: 0.1),
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
        const SizedBox(height: 12),
        _buildSmsBridgeCard(context),
        if (ref.watch(onlineShopAvailableProvider)) ...[
          const SizedBox(height: 12),
          _buildOnlineShopCard(context),
        ],
        const SizedBox(height: 28),
        _buildSecuritySection(context),
        const SizedBox(height: 28),
        _buildSystemSettings(context),
        const SizedBox(height: 28),
        _buildTransactionDelegationSection(context),
        const SizedBox(height: 28),
        _buildReceiptBrandingSection(context),
        const SizedBox(height: 28),
        _buildAccountModeCard(context),
        const SizedBox(height: 28),
        _buildDangerZoneSection(context),
      ],
    );
  }

  /// Pair a phone that forwards bank/MoMo SMS into the Cash Book review queue.
  Widget _buildSmsBridgeCard(BuildContext context) {
    return SettingsCard(
      title: context.flipperL10n.smsBridgeTitle,
      subtitle: context.flipperL10n.smsBridgeSubtitle,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kAdminBarBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.sms_outlined, color: kAdminBarBlue),
      ),
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const SmsBridgePage())),
    );
  }

  /// Publish the catalog on a public page customers order from.
  Widget _buildOnlineShopCard(BuildContext context) {
    return SettingsCard(
      key: const ValueKey('admin-online-shop'),
      title: context.flipperL10n.onlineShopTitle,
      subtitle: context.flipperL10n.onlineShopSubtitle,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kAdminBarBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.storefront_outlined, color: kAdminBarBlue),
      ),
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const OnlineShopPage())),
    );
  }

  /// Personal money management instead of a shop (`docs/personal_mode.md`).
  Widget _buildAccountModeCard(BuildContext context) {
    return SettingsCard(
      key: const ValueKey('admin-switch-to-personal'),
      title: context.flipperL10n.personalMoneySwitchToPersonal,
      subtitle: context.flipperL10n.signupUseForPersonalHint,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kAdminBarBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.account_balance_wallet_outlined,
          color: kAdminBarBlue,
        ),
      ),
      onTap: () async {
        if (!await AdminActions.verifyAdminPinIfEnabled(context)) return;
        if (!context.mounted) return;
        await confirmAndSwitchAccountMode(context, ref, AccountMode.personal);
      },
    );
  }

  Widget _buildDangerZoneSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminSectionHeader(
          context,
          context.flipperL10n.cashResetSectionTitle,
          kAdminBarRed,
        ),
        SettingsCard(
          title: context.flipperL10n.cashResetTitle,
          subtitle: context.flipperL10n.cashResetSubtitle,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kAdminBarRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.delete_sweep_outlined, color: kAdminBarRed),
          ),
          onTap: () => showCashResetDialog(
            context,
            verifyAdmin: AdminActions.verifyAdminPinIfEnabled,
          ),
        ),
      ],
    );
  }

  Widget _buildSmsConfigSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminSectionHeader(
          context,
          context.flipperL10n.smsNotifications,
          kAdminBarTeal,
        ),
        const SmsNotificationsCard(),
      ],
    );
  }

  /// Declarative list of every system toggle.
  ///
  /// Adding a setting is a single entry here — the panel handles grouping,
  /// search and layout, so the section grows without new full-size cards.
  List<_SettingsGroup> _systemSettingsGroups(BuildContext context) {
    final l10n = context.flipperL10n;
    return [
      _SettingsGroup(
        title: l10n.adminGroupSalesPricing,
        color: const Color(0xFF16A34A),
        items: [
          _SettingItem(
            title: l10n.decimals,
            subtitle: l10n.enableFractionalPricing,
            svg: AdminDashboardSvgs.decimalsCurrency,
            tint: const Color(0xFF16A34A),
            value: settingsService.isCurrencyDecimal,
            onChanged: toggleCurrencyDecimal,
          ),
          _SettingItem(
            title: l10n.priceQtyAdjustment,
            subtitle: l10n.autoAdjustQtyOnPriceChange,
            svg: AdminDashboardSvgs.priceQtyAdjustment,
            tint: kAdminBarRed,
            value: settingsService.enablePriceQuantityAdjustment,
            onChanged: togglePriceQuantityAdjustment,
          ),
          _SettingItem(
            title: l10n.autoAddSearch,
            subtitle: l10n.autoAddItemsWhenOneMatch,
            svg: AdminDashboardSvgs.autoAddSearch,
            tint: const Color(0xFFEC4899),
            value: enableAutoAddSearch,
            onChanged: toggleAutoAddSearch,
          ),
        ],
      ),
      _SettingsGroup(
        title: l10n.adminGroupWorkflow,
        color: kAdminBarPurple,
        items: [
          _SettingItem(
            title: l10n.ticketReviewAndHandover,
            subtitle: l10n.adminTicketReviewSubtitle,
            svg: AdminDashboardSvgs.leadsCheckmark,
            tint: kAdminBarPurple,
            value: settingsService.enableTicketReviewWorkflow,
            onChanged: toggleTicketReviewWorkflow,
          ),
          _SettingItem(
            title: l10n.adminSaleExchangeTitle,
            subtitle: l10n.adminSaleExchangeSubtitle,
            svg: AdminDashboardSvgs.leadsDollarCurrency,
            tint: kAdminBarPurple,
            value: settingsService.enableSaleExchange,
            onChanged: AdminActions.setSaleExchange,
          ),
        ],
      ),
      // EBM is unavailable in local mode.
      if (!LocalMode.isOn)
        _SettingsGroup(
          title: l10n.adminGroupTaxCompliance,
          color: kAdminBarTeal,
          items: [
            _SettingItem(
              title: l10n.ebm,
              subtitle: l10n.reinitializeEbm,
              svg: AdminDashboardSvgs.ebm,
              tint: kAdminBarTeal,
              value: switchToCloudSync,
              onChanged: (_) => showReInitializeEbmDialog(context),
            ),
            _SettingItem(
              title: l10n.taxService,
              subtitle: l10n.manageTaxServiceStatus,
              svg: AdminDashboardSvgs.taxService,
              tint: kAdminBarPurple,
              value: stopTaxService,
              onChanged: toggleTaxService,
            ),
          ],
        ),
      _SettingsGroup(
        title: l10n.adminGroupDataSync,
        color: kAdminBarBlue,
        items: [
          _SettingItem(
            title: l10n.hydrateData,
            subtitle: l10n.refreshAllLocalData,
            svg: AdminDashboardSvgs.hydrateData,
            tint: kAdminBarRed,
            value: forceUPSERT,
            onChanged: toggleForceUPSERT,
          ),
          _SettingItem(
            title: l10n.assetDownload,
            subtitle: l10n.manageImageDownloads,
            svg: AdminDashboardSvgs.assetDownload,
            tint: kAdminBarBlue,
            value: filesDownloaded,
            onChanged: toggleDownload,
          ),
        ],
      ),
      _SettingsGroup(
        title: l10n.adminGroupDiagnostics,
        color: kAdminBarOrange,
        items: [
          _SettingItem(
            title: l10n.userLogging,
            subtitle: l10n.enableExtensiveUserLogging,
            svg: AdminDashboardSvgs.userLogging,
            tint: const Color(0xFF6366F1),
            value: userLoggingEnabled,
            onChanged: toggleUserLogging,
          ),
          if (kDebugMode)
            _SettingItem(
              title: l10n.debugMode,
              subtitle: l10n.enableDebuggingFeatures,
              svg: AdminDashboardSvgs.debugMode,
              tint: kAdminBarOrange,
              value: enableDebug,
              onChanged: enableDebugFunc,
            ),
        ],
      ),
    ];
  }

  Widget _buildSystemSettings(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsService,
      builder: (context, _) {
        return _SystemSettingsPanel(
          title: context.flipperL10n.systemSettings,
          groups: _systemSettingsGroups(context),
        );
      },
    );
  }

  Widget _buildTransactionDelegationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminSectionHeader(
          context,
          context.flipperL10n.adminCrossDeviceFeatures,
          kAdminBarPurple,
        ),
        const TransactionDelegationSettings(),
      ],
    );
  }

  Widget _buildReceiptBrandingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminSectionHeader(
          context,
          context.flipperL10n.adminReceiptBranding,
          kAdminBarReceipt,
        ),
        const ReceiptLogoCard(),
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
            adminSectionHeader(
              context,
              context.flipperL10n.security,
              kAdminBarRed,
            ),
            Container(
              decoration: adminCardDecoration(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: AdminSwitchRow(
                      title: context.flipperL10n.administratorPin,
                      subtitle: context.flipperL10n.adminPinSubtitle,
                      leading: adminLeadingSvg(
                        AdminDashboardSvgs.administratorPin,
                        kAdminBarBlue.withValues(alpha: 0.1),
                      ),
                      value: settingsService.isAdminPinEnabled,
                      onChanged: (value) =>
                          AdminActions.setAdminPinEnabled(context, value),
                    ),
                  ),
                  if (settingsService.isAdminPinEnabled) ...[
                    Divider(height: 1, thickness: 1, color: kAdminCardBorder),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => AdminActions.resetAdminPin(context),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: AdminNavRow(
                            leading: adminLeadingSvg(
                              AdminDashboardSvgs.resetAdministratorPin,
                              kAdminBarBlue.withValues(alpha: 0.1),
                            ),
                            title: context.flipperL10n.resetAdministratorPin,
                            subtitle: context.flipperL10n.updateHighSecurityPin,
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
      decoration: adminCardDecoration(),
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
                          color: kAdminTitleText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: kAdminSubtitleText,
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

/// One toggle in the system-settings panel.
class _SettingItem {
  final String title;
  final String subtitle;
  final String svg;
  final Color tint;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.svg,
    required this.tint,
    required this.value,
    required this.onChanged,
  });

  bool matches(String query) =>
      title.toLowerCase().contains(query) ||
      subtitle.toLowerCase().contains(query);
}

class _SettingsGroup {
  final String title;
  final Color color;
  final List<_SettingItem> items;

  const _SettingsGroup({
    required this.title,
    required this.color,
    required this.items,
  });
}

/// Dense, grouped, searchable replacement for the old 3-up grid of large
/// switch cards. Rows stay a fixed compact height, so the section scales to any
/// number of settings instead of growing by one big card per toggle.
class _SystemSettingsPanel extends StatefulWidget {
  final String title;
  final List<_SettingsGroup> groups;

  const _SystemSettingsPanel({required this.title, required this.groups});

  @override
  State<_SystemSettingsPanel> createState() => _SystemSettingsPanelState();
}

class _SystemSettingsPanelState extends State<_SystemSettingsPanel> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Groups with non-matching items removed; empty groups dropped.
  List<_SettingsGroup> get _visibleGroups {
    final groups = widget.groups
        .map(
          (g) => _SettingsGroup(
            title: g.title,
            color: g.color,
            items: _query.isEmpty
                ? g.items
                : g.items.where((i) => i.matches(_query)).toList(),
          ),
        )
        .where((g) => g.items.isNotEmpty)
        .toList();
    return groups;
  }

  /// Splits groups into [columns] buckets, balanced by row count so the
  /// columns end up roughly the same height.
  List<List<_SettingsGroup>> _distribute(
    List<_SettingsGroup> groups,
    int columns,
  ) {
    final buckets = List.generate(columns, (_) => <_SettingsGroup>[]);
    final weights = List.filled(columns, 0);
    for (final group in groups) {
      var lightest = 0;
      for (var i = 1; i < columns; i++) {
        if (weights[i] < weights[lightest]) lightest = i;
      }
      buckets[lightest].add(group);
      // +1 for the group header row itself.
      weights[lightest] += group.items.length + 1;
    }
    return buckets;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _visibleGroups;
    final total = widget.groups.fold<int>(0, (sum, g) => sum + g.items.length);

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 900 ? 2 : 1;
        final buckets = _distribute(groups, columns);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (constraints.maxWidth < 560) ...[
              adminSectionHeader(context, widget.title, kAdminBarSlate),
              SizedBox(
                width: double.infinity,
                child: _SettingsSearchField(
                  controller: _searchController,
                  hintText: context.flipperL10n.adminSearchSettings(total),
                  expand: true,
                  onChanged: (value) =>
                      setState(() => _query = value.trim().toLowerCase()),
                ),
              ),
              const SizedBox(height: 12),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: adminSectionHeader(
                      context,
                      widget.title,
                      kAdminBarSlate,
                    ),
                  ),
                  _SettingsSearchField(
                    controller: _searchController,
                    hintText: context.flipperL10n.adminSearchSettings(total),
                    onChanged: (value) =>
                        setState(() => _query = value.trim().toLowerCase()),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            if (groups.isEmpty)
              Container(
                width: double.infinity,
                decoration: adminCardDecoration(),
                padding: const EdgeInsets.symmetric(vertical: 28),
                alignment: Alignment.center,
                child: Text(
                  context.flipperL10n.adminNoSettingMatches(
                    _searchController.text.trim(),
                  ),
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: kAdminSubtitleText,
                  ),
                ),
              )
            else if (columns == 1)
              Column(
                children: [
                  for (final group in groups) ...[
                    _SettingsGroupCard(group: group),
                    const SizedBox(height: 12),
                  ],
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < buckets.length; i++) ...[
                    if (i > 0) const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        children: [
                          for (final group in buckets[i]) ...[
                            _SettingsGroupCard(group: group),
                            const SizedBox(height: 14),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
          ],
        );
      },
    );
  }
}

class _SettingsSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool expand;
  final ValueChanged<String> onChanged;

  const _SettingsSearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: expand ? double.infinity : 220,
      height: 36,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.outfit(fontSize: 13, color: kAdminTitleText),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: GoogleFonts.outfit(
            fontSize: 13,
            color: kAdminSubtitleText,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 16,
            color: kAdminSubtitleText,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 34),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close, size: 14),
                  color: kAdminSubtitleText,
                  splashRadius: 14,
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: kAdminCardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: kAdminCardBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: PosLayoutBreakpoints.posAccentBlue,
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsGroupCard extends StatelessWidget {
  final _SettingsGroup group;

  const _SettingsGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: adminCardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            color: const Color(0xFFFAFAFB),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 12,
                  decoration: BoxDecoration(
                    color: group.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  group.title.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: kAdminSubtitleText,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: kAdminCardBorder),
          for (var i = 0; i < group.items.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.only(left: 52),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: kAdminCardBorder,
                ),
              ),
            _SettingRow(item: group.items[i]),
          ],
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final _SettingItem item;

  const _SettingRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => item.onChanged(!item.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: item.tint.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AdminDashboardSvgs.picture(item.svg, size: 15),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: kAdminTitleText,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: kAdminSubtitleText,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Transform.scale(
                scale: 0.78,
                child: Switch(
                  value: item.value,
                  onChanged: item.onChanged,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeTrackColor: PosLayoutBreakpoints.posAccentBlue,
                  inactiveTrackColor: const Color(0xFFE5E7EB),
                  inactiveThumbColor: Colors.white,
                  activeThumbColor: Colors.white,
                ),
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
      decoration: adminCardDecoration(),
      padding: const EdgeInsets.all(16),
      child: AdminSwitchRow(
        title: title,
        subtitle: subtitle,
        leading: leading,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
