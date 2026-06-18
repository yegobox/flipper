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

List<AllAppSection> webAllAppsCatalog() => const [
  AllAppSection(
    label: 'Finance',
    apps: [
      AllAppTile(
        page: 'Accounting',
        label: 'Books',
        icon: Icons.menu_book_outlined,
        color: Color(0xFF2563EB),
        available: true,
      ),
    ],
  ),
  AllAppSection(
    label: 'Sell',
    apps: [
      AllAppTile(page: 'POS', label: 'Quick Sell', icon: Icons.shopping_cart_outlined, color: Color(0xFF2563EB)),
      AllAppTile(page: 'Transactions', label: 'Invoices', icon: Icons.receipt_long_outlined, color: Color(0xFF7C3AED)),
      AllAppTile(page: 'Inventory', label: 'Inventory', icon: Icons.inventory_2_outlined, color: Color(0xFF0891B2), badge: '3'),
    ],
  ),
  AllAppSection(
    label: 'Insights',
    apps: [
      AllAppTile(page: 'Reports', label: 'Reports', icon: Icons.bar_chart_outlined, color: Color(0xFF16A34A)),
      AllAppTile(page: 'Tax', label: 'Tax & VAT', icon: Icons.verified_user_outlined, color: Color(0xFFB45309)),
    ],
  ),
  AllAppSection(
    label: 'Business',
    apps: [
      AllAppTile(page: 'Settings', label: 'Settings', icon: Icons.settings_outlined, color: Color(0xFF64748B)),
    ],
  ),
];
