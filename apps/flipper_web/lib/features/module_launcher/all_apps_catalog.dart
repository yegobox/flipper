import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';

class AllAppTile {
  const AllAppTile({
    required this.page,
    required this.label,
    required this.icon,
    required this.color,
    this.badge,
    this.available = true,
  });

  final String page;
  final String label;
  final IconData icon;
  final Color color;
  final String? badge;
  final bool available;
}

class AllAppSection {
  const AllAppSection({required this.label, required this.apps});

  final String label;
  final List<AllAppTile> apps;
}

List<AllAppSection> webAllAppsCatalog([FlipperAppLocalizations? l10n]) {
  final t = l10n ?? FlipperL10n.current;
  return [
    AllAppSection(
      label: t.webAppsFinance,
      apps: [
        const AllAppTile(
          page: 'Accounting',
          label: 'Books',
          icon: Icons.menu_book_outlined,
          color: Color(0xFF2563EB),
          available: true,
        ),
      ],
    ),
    AllAppSection(
      label: t.webAppsSell,
      apps: [
        AllAppTile(
          page: 'POS',
          label: t.quickSell,
          icon: Icons.shopping_cart_outlined,
          color: const Color(0xFF2563EB),
        ),
        AllAppTile(
          page: 'Transactions',
          label: t.invoices,
          icon: Icons.receipt_long_outlined,
          color: const Color(0xFF7C3AED),
        ),
        AllAppTile(
          page: 'Inventory',
          label: t.inventory,
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFF0891B2),
          badge: '3',
        ),
      ],
    ),
    AllAppSection(
      label: t.insights,
      apps: [
        AllAppTile(
          page: 'Reports',
          label: t.reports,
          icon: Icons.bar_chart_outlined,
          color: const Color(0xFF16A34A),
        ),
        AllAppTile(
          page: 'Tax',
          label: t.booksTaxVat,
          icon: Icons.verified_user_outlined,
          color: const Color(0xFFB45309),
        ),
      ],
    ),
    AllAppSection(
      label: t.business,
      apps: [
        AllAppTile(
          page: 'Settings',
          label: t.settings,
          icon: Icons.settings_outlined,
          color: const Color(0xFF64748B),
        ),
      ],
    ),
  ];
}
