import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
  const DashboardAllAppSection({
    required this.label,
    required this.apps,
  });

  final String label;
  final List<DashboardAllAppTile> apps;
}

/// Grouped launcher catalog — maps design handoff sections to real Flipper routes.
const List<DashboardAllAppSection> dashboardAllAppsCatalog = [
  DashboardAllAppSection(
    label: 'Sell',
    apps: [
      DashboardAllAppTile(
        page: 'POS',
        label: 'Quick Sell',
        icon: FluentIcons.cart_24_regular,
        color: Color(0xFF2563EB),
        feature: 'Sales',
      ),
      DashboardAllAppTile(
        page: 'Transactions',
        label: 'Invoices',
        icon: FluentIcons.receipt_24_regular,
        color: Color(0xFF7C3AED),
        feature: 'Transactions',
      ),
      DashboardAllAppTile(
        page: 'POS',
        label: 'Pricing',
        icon: FluentIcons.tag_24_regular,
        color: Color(0xFFE5484D),
        feature: 'Sales',
      ),
      DashboardAllAppTile(
        page: 'Cashbook',
        label: 'Payments',
        icon: FluentIcons.wallet_24_regular,
        color: Color(0xFF0891B2),
        feature: 'Cashbook',
      ),
    ],
  ),
  DashboardAllAppSection(
    label: 'Manage',
    apps: [
      DashboardAllAppTile(
        page: 'Inventory',
        label: 'Inventory',
        icon: FluentIcons.box_24_regular,
        color: Color(0xFF10B981),
        feature: 'Sales',
      ),
      DashboardAllAppTile(
        page: 'Orders',
        label: 'Purchases',
        icon: FluentIcons.vehicle_truck_profile_24_regular,
        color: Color(0xFFF59E0B),
        feature: 'Orders',
      ),
      DashboardAllAppTile(
        page: 'Contacts',
        label: 'Customers',
        icon: FluentIcons.people_24_regular,
        color: Color(0xFF0D9488),
        feature: 'Contacts',
      ),
      DashboardAllAppTile(
        page: 'Leads',
        label: 'Leads',
        icon: FluentIcons.people_team_24_regular,
        color: Color(0xFF4F46E5),
        feature: 'Leads',
      ),
    ],
  ),
  DashboardAllAppSection(
    label: 'Insights',
    apps: [
      DashboardAllAppTile(
        page: 'Transactions',
        label: 'Reports',
        icon: FluentIcons.data_histogram_24_regular,
        color: Color(0xFF2563EB),
        feature: 'Transactions',
      ),
      DashboardAllAppTile(
        page: 'DailyReports',
        label: 'Daily Reports',
        icon: FluentIcons.document_multiple_24_regular,
        color: Color(0xFF0D9488),
        feature: 'Transactions',
      ),
      DashboardAllAppTile(
        page: 'AgentCommission',
        label: 'Commissions',
        icon: FluentIcons.coin_multiple_24_regular,
        color: Color(0xFFF59E0B),
        feature: 'AgentCommission',
      ),
      DashboardAllAppTile(
        page: 'ProductionOutput',
        label: 'Production',
        icon: Icons.factory_outlined,
        color: Color(0xFF7C3AED),
        feature: 'ProductionOutput',
      ),
    ],
  ),
  DashboardAllAppSection(
    label: 'Business',
    apps: [
      DashboardAllAppTile(
        page: 'ServicesGigs',
        label: 'Services hub',
        icon: FluentIcons.handshake_24_regular,
        color: Color(0xFF0D9488),
        feature: 'ServicesGigs',
      ),
      DashboardAllAppTile(
        page: 'PersonalGoals',
        label: 'Goals',
        icon: FluentIcons.savings_24_regular,
        color: Color(0xFF7C3AED),
        feature: 'Cashbook',
      ),
      DashboardAllAppTile(
        page: 'Chat',
        label: 'AI Chat',
        icon: FluentIcons.chat_24_regular,
        color: Color(0xFF9333EA),
        feature: 'Chat',
      ),
      DashboardAllAppTile(
        page: 'Settings',
        label: 'Settings',
        icon: FluentIcons.settings_24_regular,
        color: Color(0xFF64748B),
        feature: 'Settings',
      ),
    ],
  ),
];
