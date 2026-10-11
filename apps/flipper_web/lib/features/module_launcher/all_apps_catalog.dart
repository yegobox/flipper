import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';

class AllAppTile {
  const AllAppTile({
    required this.route,
    required this.label,
    required this.icon,
    required this.color,
  });

  /// The flipper_web route the tile opens.
  final String route;
  final String label;
  final IconData icon;
  final Color color;
}

class AllAppSection {
  const AllAppSection({required this.label, required this.apps});

  final String label;
  final List<AllAppTile> apps;
}

/// The apps that run on the web: Books and the POS. Nothing else is listed
/// until it actually opens here.
List<AllAppSection> webAllAppsCatalog([FlipperAppLocalizations? l10n]) {
  final t = l10n ?? FlipperL10n.current;
  return [
    AllAppSection(
      label: t.webAppsFinance,
      apps: const [
        AllAppTile(
          route: '/accounting',
          label: 'Books',
          icon: Icons.menu_book_outlined,
          color: Color(0xFF2563EB),
        ),
      ],
    ),
    AllAppSection(
      label: t.webAppsSell,
      apps: const [
        AllAppTile(
          route: '/pos',
          label: 'POS',
          icon: Icons.shopping_cart_outlined,
          color: Color(0xFF7C3AED),
        ),
      ],
    ),
  ];
}
