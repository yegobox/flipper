import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_dashboard/tax_configuration.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';

/// Material guideline: window class compact vs medium+ (`shortestSide` in logical px).
const double _kCompactLayoutBreakpoint = 600;

Widget SettingLayout({
  required SettingViewModel model,
  required BuildContext context,
}) {
  final _routerService = locator<RouterService>();
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  // `MediaQuery.sizeOf.shortestSide` is the usual Flutter signal for handset vs tablet.
  final isCompactLayout =
      MediaQuery.sizeOf(context).shortestSide < _kCompactLayoutBreakpoint;

  final bgColor = isDarkMode ? Colors.black : const Color(0xFFF2F2F7);
  final cardColor = isDarkMode ? const Color(0xFF1C1C1E) : Colors.white;
  final textColor = isDarkMode ? Colors.white : Colors.black87;
  final dividerColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;

  // Compact handsets: day-to-day ops (devices, printing, security, users, close day).
  // Wider/taller windows: tax only here. If you unify the list, update both branches deliberately.
  final List<_SettingsItem> settingsItems = isCompactLayout
      ? [
          _SettingsItem(
            icon: FluentIcons.desktop_24_regular,
            iconColor: Colors.white,
            iconBgColor: const Color(0xFF5856D6),
            title: 'Linked Devices',
            onTap: () async {
              final Tenant? tenant = await ProxyService.strategy.getTenant(
                userId: ProxyService.box.getUserId()!,
              );
              _routerService.navigateTo(DevicesRoute(pin: tenant?.pin));
            },
          ),
          _SettingsItem(
            icon: FluentIcons.print_24_regular,
            iconColor: Colors.white,
            iconBgColor: const Color(0xFFFF9500),
            title: 'Printing configuration',
            onTap: () {
              _routerService.navigateTo(const PrintingRoute());
            },
          ),
          _SettingsItem(
            icon: FluentIcons.lock_closed_32_regular,
            iconColor: Colors.white,
            iconBgColor: const Color(0xFF34C759),
            title: 'Security',
            onTap: () {
              _routerService.navigateTo(SecurityRoute());
            },
          ),
          _SettingsItem(
            icon: FluentIcons.people_add_24_regular,
            iconColor: Colors.white,
            iconBgColor: const Color(0xFF007AFF),
            title: 'User Management',
            onTap: () {
              _routerService.navigateTo(TenantManagementRoute());
            },
          ),
          _SettingsItem(
            icon: FluentIcons.paint_brush_24_regular,
            iconColor: Colors.white,
            iconBgColor: const Color(0xFFAF52DE),
            title: 'Close a day',
            onTap: () {},
          ),
        ]
      : [
          _SettingsItem(
            icon: FluentIcons.calculator_24_regular,
            iconColor: Colors.white,
            iconBgColor: const Color(0xFFFF9500),
            title: 'Tax Configuration',
            onTap: () {
              showModalBottomSheet<void>(
                isScrollControlled: false,
                backgroundColor: Colors.white,
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                ),
                useRootNavigator: true,
                builder: (BuildContext context) {
                  return const SystemConfig(showheader: true);
                },
              );
            },
          ),
        ];

  return Container(
    color: bgColor,
    child: Column(
      children: [
        const SizedBox(height: 24),
        // User Profile Section
        if (model.branch != null)
          Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ProfileWidget(
                    branch: model.branch!,
                    sessionActive: true,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  model.branch!.name ?? "Business",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Manage your business settings",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildSettingsGroup(
                context: context,
                cardColor: cardColor,
                textColor: textColor,
                dividerColor: dividerColor,
                items: settingsItems,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SettingsItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final VoidCallback onTap;

  _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.onTap,
  });
}

Widget _buildSettingsGroup({
  required BuildContext context,
  required Color cardColor,
  required Color textColor,
  required Color dividerColor,
  required List<_SettingsItem> items,
}) {
  return Container(
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: items.asMap().entries.map((entry) {
        final int index = entry.key;
        final _SettingsItem item = entry.value;

        return Column(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.vertical(
                  top: index == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: index == items.length - 1
                      ? const Radius.circular(16)
                      : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: item.iconBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(item.icon, color: item.iconColor, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.3,
                            color: textColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey.shade400,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (index < items.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 66.0),
                child: Divider(height: 1, thickness: 1, color: dividerColor),
              ),
          ],
        );
      }).toList(),
    ),
  );
}
