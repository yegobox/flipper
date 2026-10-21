import 'package:flipper_dashboard/TaxSettingsModal.dart';
import 'package:flipper_dashboard/features/admin/mobile/settings_list.dart';
import 'package:flipper_dashboard/features/admin/sections/admin_actions.dart';
import 'package:flipper_dashboard/features/admin/sections/admin_profile_card.dart';
import 'package:flipper_dashboard/features/admin/sections/receipt_logo_card.dart';
import 'package:flipper_dashboard/features/admin/sections/sms_notifications_card.dart';
import 'package:flipper_dashboard/features/admin/widgets/cash_reset_dialog.dart';
import 'package:flipper_dashboard/features/admin/widgets/language_settings_card.dart';
import 'package:flipper_dashboard/features/admin/widgets/sms_bridge_page.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mode_admin_section.dart';
import 'package:flipper_dashboard/features/daily_report_recipients/daily_report_recipients_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_mode_admin_section.dart';
import 'package:flipper_dashboard/features/personal_finance/personal_mode_switch.dart';
import 'package:flipper_dashboard/modals/_isBranchEnableForPayment.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_dashboard/widgets/transaction_delegation_settings.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/account_mode/account_mode.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

/// Settings on a phone: one quiet grouped list.
///
/// Admins (the same check as the desktop gear) get everything Admin Control
/// offers that makes sense on a phone. Till hardware, the service-mode device
/// picker and the data-sync / diagnostics tools stay desktop-only. Everyone
/// else gets their own short list in the same design.
class MobileSettingsHub extends ConsumerStatefulWidget {
  const MobileSettingsHub({
    super.key,
    this.branchName,
    this.branchId,
    this.userId,
  });

  /// Shown in the header card; the branch the user is in.
  final String? branchName;

  /// The branch whose tax settings the Tax row opens.
  final String? branchId;

  /// Defaults to the signed-in user. Tests pass one.
  final String? userId;

  @override
  ConsumerState<MobileSettingsHub> createState() => _MobileSettingsHubState();
}

class _MobileSettingsHubState extends ConsumerState<MobileSettingsHub> {
  final _settings = locator<SettingsService>();
  late ({bool pos, bool orders}) _defaults;

  @override
  void initState() {
    super.initState();
    _defaults = AdminActions.defaultApps();
    _settings.getAdminPinToggleState();
  }

  void _setPosDefault(bool value) {
    AdminActions.setPosDefault(value);
    setState(() => _defaults = AdminActions.defaultApps());
  }

  void _setOrdersDefault(bool value) {
    AdminActions.setOrdersDefault(value);
    setState(() => _defaults = AdminActions.defaultApps());
  }

  void _open(String title, Widget child) =>
      SettingsSubpage.push(context, title: title, child: child);

  @override
  Widget build(BuildContext context) {
    final userId = widget.userId ?? currentDashboardUserId();
    final isAdmin = userId.isEmpty
        ? false
        : ref
                  .watch(
                    isAdminProvider(userId, featureName: AppFeature.Settings),
                  )
                  .value ??
              false;

    return ColoredBox(
      color: MposTokens.bg,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _HeaderCard(branchName: widget.branchName),
          const SizedBox(height: 24),
          ..._groups(
            context,
            isAdmin,
          ).expand((g) => [g, const SizedBox(height: 24)]),
        ],
      ),
    );
  }

  List<Widget> _groups(BuildContext context, bool isAdmin) {
    final l10n = context.flipperL10n;
    final language = SettingsRow(
      icon: Icons.translate_rounded,
      title: l10n.language,
      onTap: () => _open(l10n.language, const LanguageSettingsCard()),
    );
    final users = SettingsRow(
      icon: Icons.people_outline_rounded,
      title: l10n.userManagement,
      onTap: () => locator<RouterService>().navigateTo(TenantManagementRoute()),
    );

    if (!isAdmin) {
      return [
        SettingsGroup(label: l10n.account, children: [users, language]),
      ];
    }

    return [
      SettingsGroup(
        label: l10n.account,
        children: [
          SettingsRow(
            icon: Icons.person_outline_rounded,
            title: l10n.adminProfile,
            onTap: () => _open(
              l10n.adminProfile,
              const AdminProfileCard(
                quiet: true,
                showDailyReportRecipients: false,
              ),
            ),
          ),
          users,
          SettingsRow(
            icon: Icons.storefront_outlined,
            title: l10n.branchManagement,
            onTap: () => locator<RouterService>().navigateTo(AddBranchRoute()),
          ),
          language,
          SettingsRow(
            key: const ValueKey('settings-switch-to-personal'),
            icon: Icons.account_balance_wallet_outlined,
            title: l10n.personalMoneySwitchToPersonal,
            onTap: () async {
              if (!await AdminActions.verifyAdminPinIfEnabled(context)) return;
              if (!context.mounted) return;
              await confirmAndSwitchAccountMode(
                context,
                ref,
                AccountMode.personal,
              );
            },
          ),
        ],
      ),
      SettingsGroup(
        label: l10n.settingsGroupMoney,
        children: [
          if (widget.branchId != null)
            SettingsRow(
              icon: Icons.percent_rounded,
              title: l10n.taxSettings,
              onTap: () => showDialog<void>(
                context: context,
                builder: (_) => TaxSettingsModal(branchId: widget.branchId!),
              ),
            ),
          SettingsRow(
            icon: Icons.credit_card_outlined,
            title: l10n.paymentMethods,
            onTap: () => showPaymentSettingsModal(context),
          ),
        ],
      ),
      SettingsGroup(
        label: l10n.sales,
        children: [
          SettingsSwitchRow(
            icon: Icons.point_of_sale_outlined,
            title: l10n.posDefault,
            subtitle: l10n.setPosAsDefaultApp,
            value: _defaults.pos,
            onChanged: _setPosDefault,
          ),
          SettingsSwitchRow(
            icon: Icons.receipt_long_outlined,
            title: l10n.ordersDefault,
            subtitle: l10n.setOrdersAsDefaultApp,
            value: _defaults.orders,
            onChanged: _setOrdersDefault,
          ),
          SettingsRow(
            icon: Icons.tune_rounded,
            title: l10n.adminGroupSalesPricing,
            onTap: () =>
                _open(l10n.adminGroupSalesPricing, const _SalesSettingsPage()),
          ),
          SettingsRow(
            icon: Icons.local_bar_outlined,
            title: l10n.barTableServiceTitle,
            onTap: () =>
                _open(l10n.barTableServiceTitle, const BarModeAdminSection()),
          ),
          SettingsRow(
            icon: Icons.hotel_outlined,
            title: l10n.hotelModeTitle,
            onTap: () =>
                _open(l10n.hotelModeTitle, const HotelModeAdminSection()),
          ),
        ],
      ),
      SettingsGroup(
        label: l10n.settingsGroupNotifications,
        children: [
          SettingsRow(
            icon: Icons.sms_outlined,
            title: l10n.smsNotifications,
            onTap: () => _open(
              l10n.smsNotifications,
              const SmsNotificationsCard(compact: true),
            ),
          ),
          SettingsRow(
            icon: Icons.phonelink_ring_outlined,
            title: l10n.smsBridgeTitle,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SmsBridgePage()),
            ),
          ),
          SettingsRow(
            icon: Icons.mail_outline_rounded,
            title: l10n.dailyReportRecipientsTitle,
            onTap: () => _open(
              l10n.dailyReportRecipientsTitle,
              const DailyReportRecipientsSettings(),
            ),
          ),
        ],
      ),
      SettingsGroup(
        label: l10n.settingsGroupDevices,
        children: [
          SettingsRow(
            icon: Icons.print_outlined,
            title: l10n.printDelegationTitle,
            onTap: () => _open(
              l10n.printDelegationTitle,
              const TransactionDelegationSettings(),
            ),
          ),
        ],
      ),
      ListenableBuilder(
        listenable: _settings,
        builder: (context, _) => SettingsGroup(
          label: l10n.security,
          children: [
            SettingsSwitchRow(
              icon: Icons.lock_outline_rounded,
              title: l10n.administratorPin,
              subtitle: l10n.adminPinSubtitle,
              value: _settings.isAdminPinEnabled,
              onChanged: (value) =>
                  AdminActions.setAdminPinEnabled(context, value),
            ),
            if (_settings.isAdminPinEnabled)
              SettingsRow(
                icon: Icons.password_rounded,
                title: l10n.resetAdministratorPin,
                onTap: () => AdminActions.resetAdminPin(context),
              ),
          ],
        ),
      ),
      SettingsGroup(
        label: l10n.settingsGroupReceipts,
        children: [
          SettingsRow(
            icon: Icons.image_outlined,
            title: l10n.adminReceiptLogo,
            onTap: () => _open(
              l10n.adminReceiptLogo,
              const ReceiptLogoCard(compact: true),
            ),
          ),
        ],
      ),
      SettingsGroup(
        label: l10n.cashResetSectionTitle,
        children: [
          SettingsRow(
            key: const ValueKey('settings-clear-cash-book'),
            icon: Icons.delete_outline_rounded,
            title: l10n.cashResetTitle,
            destructive: true,
            onTap: () => showCashResetSheet(
              context,
              verifyAdmin: AdminActions.verifyAdminPinIfEnabled,
            ),
          ),
        ],
      ),
    ];
  }
}

/// Business / branch summary at the top of the list. Plain on purpose: no
/// avatar, no colour.
class _HeaderCard extends StatelessWidget {
  const _HeaderCard({this.branchName});

  final String? branchName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PosTokens.surface,
        borderRadius: BorderRadius.circular(MposTokens.radiusMd),
        border: Border.all(color: PosTokens.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (branchName?.trim().isNotEmpty ?? false)
                  ? branchName!.trim()
                  : l10n.business,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: PosTokens.ink1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.settingsManageBusiness,
              style: const TextStyle(fontSize: 13.5, color: PosTokens.ink3),
            ),
          ],
        ),
      ),
    );
  }
}

/// The phone-relevant toggles of the desktop "System settings" panel:
/// pricing and the ticket workflow. Data sync and diagnostics stay on desktop.
class _SalesSettingsPage extends StatefulWidget {
  const _SalesSettingsPage();

  @override
  State<_SalesSettingsPage> createState() => _SalesSettingsPageState();
}

class _SalesSettingsPageState extends State<_SalesSettingsPage> {
  final _settings = locator<SettingsService>();
  late bool _autoAddSearch;

  @override
  void initState() {
    super.initState();
    _autoAddSearch = AdminActions.autoAddSearch();
    _settings.getPriceQuantityAdjustmentToggleState();
    _settings.getCurrencyDecimalToggleState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsGroup(
            label: l10n.adminGroupSalesPricing,
            children: [
              SettingsSwitchRow(
                icon: Icons.exposure_outlined,
                title: l10n.decimals,
                subtitle: l10n.enableFractionalPricing,
                value: _settings.isCurrencyDecimal,
                onChanged: AdminActions.setCurrencyDecimal,
              ),
              SettingsSwitchRow(
                icon: Icons.swap_vert_rounded,
                title: l10n.priceQtyAdjustment,
                subtitle: l10n.autoAdjustQtyOnPriceChange,
                value: _settings.enablePriceQuantityAdjustment,
                onChanged: AdminActions.setPriceQuantityAdjustment,
              ),
              SettingsSwitchRow(
                icon: Icons.manage_search_rounded,
                title: l10n.autoAddSearch,
                subtitle: l10n.autoAddItemsWhenOneMatch,
                value: _autoAddSearch,
                onChanged: (value) async {
                  await AdminActions.setAutoAddSearch(value);
                  if (mounted) setState(() => _autoAddSearch = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          SettingsGroup(
            label: l10n.adminGroupWorkflow,
            children: [
              SettingsSwitchRow(
                icon: Icons.fact_check_outlined,
                title: l10n.ticketReviewAndHandover,
                subtitle: l10n.adminTicketReviewSubtitle,
                value: _settings.enableTicketReviewWorkflow,
                onChanged: AdminActions.setTicketReviewWorkflow,
              ),
              SettingsSwitchRow(
                icon: Icons.swap_horiz_rounded,
                title: l10n.adminSaleExchangeTitle,
                subtitle: l10n.adminSaleExchangeSubtitle,
                value: _settings.enableSaleExchange,
                onChanged: AdminActions.setSaleExchange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
