import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';

/// One tile in the mobile "All apps" bottom sheet.
class DashboardAllAppTile {
  const DashboardAllAppTile({
    required this.page,
    required this.label,
    required this.icon,
    required this.color,
    this.badge,
    this.feature,
  });

  /// Route key passed to [navigateToDashboardAppPage].
  final String page;
  final String label;
  final IconData icon;
  final Color color;
  final String? badge;
  final String? feature;
}

class DashboardAllAppSection {
  const DashboardAllAppSection({required this.label, required this.apps});

  final String label;
  final List<DashboardAllAppTile> apps;
}

/// Grouped launcher catalog — maps design handoff sections to real Flipper routes.
List<DashboardAllAppSection> dashboardAllAppsCatalog(BuildContext context) => [
  DashboardAllAppSection(
    label: context.flipperL10n.sell,
    apps: [
      DashboardAllAppTile(
        page: 'POS',
        label: context.flipperL10n.quickSell,
        icon: FluentIcons.cart_24_regular,
        color: Color(0xFF2563EB),
        feature: 'Sales',
      ),
      DashboardAllAppTile(
        page: 'Transactions',
        label: context.flipperL10n.invoices,
        icon: FluentIcons.receipt_24_regular,
        color: Color(0xFF7C3AED),
        feature: 'Transactions',
      ),
      DashboardAllAppTile(
        page: 'Tickets',
        label: context.flipperL10n.tickets,
        icon: FluentIcons.clipboard_text_edit_24_regular,
        color: Color(0xFF006AFE),
        feature: 'Tickets',
      ),
      DashboardAllAppTile(
        page: 'POS',
        label: context.flipperL10n.pricing,
        icon: FluentIcons.tag_24_regular,
        color: Color(0xFFE5484D),
        feature: 'Sales',
      ),
      DashboardAllAppTile(
        page: 'Cashbook',
        label: context.flipperL10n.payments,
        icon: FluentIcons.wallet_24_regular,
        color: Color(0xFF0891B2),
        feature: 'Cashbook',
      ),
    ],
  ),
  DashboardAllAppSection(
    label: context.flipperL10n.manage,
    apps: [
      DashboardAllAppTile(
        page: 'Inventory',
        label: context.flipperL10n.inventory,
        icon: FluentIcons.box_24_regular,
        color: Color(0xFF10B981),
        feature: 'Sales',
      ),
      DashboardAllAppTile(
        page: 'Orders',
        label: context.flipperL10n.purchases,
        icon: FluentIcons.vehicle_truck_profile_24_regular,
        color: Color(0xFFF59E0B),
        feature: 'Orders',
      ),
      DashboardAllAppTile(
        page: 'Contacts',
        label: context.flipperL10n.customers,
        icon: FluentIcons.people_24_regular,
        color: Color(0xFF0D9488),
        feature: 'Contacts',
      ),
      DashboardAllAppTile(
        page: 'Leads',
        label: context.flipperL10n.leads,
        icon: FluentIcons.people_team_24_regular,
        color: Color(0xFF4F46E5),
        feature: 'Leads',
      ),
    ],
  ),
  DashboardAllAppSection(
    label: context.flipperL10n.insights,
    apps: [
      DashboardAllAppTile(
        page: 'Transactions',
        label: context.flipperL10n.reports,
        icon: FluentIcons.data_histogram_24_regular,
        color: Color(0xFF2563EB),
        feature: 'Transactions',
      ),
      DashboardAllAppTile(
        page: 'DailyReports',
        label: context.flipperL10n.dailyReports,
        icon: FluentIcons.document_multiple_24_regular,
        color: Color(0xFF0D9488),
        feature: 'Transactions',
      ),
      DashboardAllAppTile(
        page: 'AgentCommission',
        label: context.flipperL10n.commissions,
        icon: FluentIcons.coin_multiple_24_regular,
        color: Color(0xFFF59E0B),
        feature: 'AgentCommission',
      ),
      DashboardAllAppTile(
        page: 'ProductionOutput',
        label: context.flipperL10n.production,
        icon: Icons.factory_outlined,
        color: Color(0xFF7C3AED),
        feature: 'ProductionOutput',
      ),
    ],
  ),
  DashboardAllAppSection(
    label: context.flipperL10n.business,
    apps: [
      DashboardAllAppTile(
        page: 'ServicesGigs',
        label: context.flipperL10n.servicesHub,
        icon: FluentIcons.handshake_24_regular,
        color: Color(0xFF0D9488),
        feature: 'ServicesGigs',
      ),
      DashboardAllAppTile(
        page: 'PersonalGoals',
        label: context.flipperL10n.goals,
        icon: FluentIcons.savings_24_regular,
        color: Color(0xFF7C3AED),
        feature: 'Cashbook',
      ),
      DashboardAllAppTile(
        page: 'Chat',
        label: context.flipperL10n.aiChat,
        icon: FluentIcons.chat_24_regular,
        color: Color(0xFF9333EA),
        feature: 'Chat',
      ),
      DashboardAllAppTile(
        page: 'Settings',
        label: context.flipperL10n.settings,
        icon: FluentIcons.settings_24_regular,
        color: Color(0xFF64748B),
        feature: 'Settings',
      ),
    ],
  ),
];
