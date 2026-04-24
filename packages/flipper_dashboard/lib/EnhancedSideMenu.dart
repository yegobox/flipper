import 'package:flipper_dashboard/ActiveBranch.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'providers/navigation_providers.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_services/constants.dart'; // Import for AppFeature

class EnhancedSideMenu extends ConsumerWidget {
  const EnhancedSideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedMenuItemProvider);
    final _dialogService = locator<DialogService>();
    final _routerService = locator<RouterService>();

    final hasKDS = ref.watch(hasFeatureProvider("KDS"));
    final hasInventory = ref.watch(hasFeatureProvider("INVENTORY"));
    final hasOrdering = ref.watch(hasFeatureProvider("ORDERING"));
    final hasManufacturing = ref.watch(hasFeatureProvider("MANUFACTURING"));
    final hasShiftHistory = ref.watch(hasFeatureProvider("SHIFT_HISTORY"));
    final hasAccess = ref.watch(hasFeatureProvider("PRINTING_DELEGATION"));

    final isAdminAsyncValue = ref.watch(
      isAdminProvider(
        ProxyService.box.getUserId() ?? "",
        featureName: AppFeature.ShiftHistory,
      ),
    );

    final menuItems = [
      _SideMenuItem(
        iconBuilder: (_) =>
            SvgPicture.string(_SideMenuSvgs.appGrid, width: 24, height: 24),
        isSelected: selectedItem == 0,
        onTap: () {
          ref.read(selectedMenuItemProvider.notifier).state = 0;
          ref.read(selectedPageProvider.notifier).state =
              DashboardPage.inventory;
        },
        tooltip: 'Overview',
      ),
      _SideMenuItem(
        iconBuilder: (_) =>
            SvgPicture.string(_SideMenuSvgs.aiChat, width: 24, height: 24),
        isSelected: selectedItem == 1,
        onTap: () {
          ref.read(selectedMenuItemProvider.notifier).state = 1;
          ref.read(selectedPageProvider.notifier).state = DashboardPage.ai;
        },
        tooltip: 'Chat',
      ),
      if (hasInventory)
        _SideMenuItem(
          iconBuilder: (_) =>
              SvgPicture.string(_SideMenuSvgs.inventory, width: 24, height: 24),
          isSelected: selectedItem == 2,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 2;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.reports;
          },
          tooltip: 'Items',
        ),
      if (hasKDS)
        _SideMenuItem(
          iconBuilder: (c) => Icon(Icons.restaurant_menu, color: c, size: 24),
          isSelected: selectedItem == 3,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 3;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.kitchen;
          },
          tooltip: 'Kitchen Display',
        ),
      if (hasInventory)
        _SideMenuItem(
          iconBuilder: (_) => SvgPicture.string(
            _SideMenuSvgs.stockRecount,
            width: 24,
            height: 24,
          ),
          isSelected: selectedItem == 6,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 6;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.stockRecount;
          },
          tooltip: 'Stock Recount',
        ),
      if (hasAccess)
        _SideMenuItem(
          iconBuilder: (c) => Icon(Icons.print_outlined, color: c, size: 24),
          isSelected: selectedItem == 7,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 7;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.delegations;
          },
          tooltip: 'Delegations',
        ),
      if (hasOrdering || hasInventory)
        _SideMenuItem(
          iconBuilder: (_) => SvgPicture.string(
            _SideMenuSvgs.inboxImport,
            width: 24,
            height: 24,
          ),
          isSelected: selectedItem == 8,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 8;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.incomingOrders;
          },
          tooltip: 'Incoming Orders',
        ),
      if (hasManufacturing)
        _SideMenuItem(
          iconBuilder: (_) => SvgPicture.string(
            _SideMenuSvgs.production,
            width: 24,
            height: 24,
          ),
          isSelected: selectedItem == 9,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 9;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.productionOutput;
          },
          tooltip: 'Production Output',
        ),
      if (isAdminAsyncValue.value == true && hasShiftHistory)
        _SideMenuItem(
          iconBuilder: (_) =>
              SvgPicture.string(_SideMenuSvgs.history, width: 24, height: 24),
          isSelected: selectedItem == 5,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 5;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.shiftHistory;
          },
          tooltip: 'Shift History',
        ),
      _SideMenuItem(
        iconBuilder: (_) =>
            SvgPicture.string(_SideMenuSvgs.logout, width: 24, height: 24),
        isSelected: selectedItem == 4,
        onTap: () async {
          final userId = ProxyService.box.getUserId();
          if (userId != null) {
            try {
              final currentShift = await ProxyService.strategy.getCurrentShift(
                userId: userId,
              );
              if (currentShift != null) {
                final dialogResponse = await _dialogService.showCustomDialog(
                  variant: DialogType.closeShift,
                  title: 'Close Shift',
                  data: {
                    'openingBalance': currentShift.openingBalance,
                    'cashSales': currentShift.cashSales,
                    'expectedCash': currentShift.expectedCash,
                  },
                );

                if (dialogResponse?.confirmed == true &&
                    dialogResponse?.data != null) {
                  final closingBalance =
                      (dialogResponse?.data
                              as Map<dynamic, dynamic>)['closingBalance']
                          as double? ??
                      0.0;
                  final notes =
                      (dialogResponse?.data as Map<dynamic, dynamic>)['notes']
                          as String?;
                  await ProxyService.strategy.endShift(
                    shiftId: currentShift.id,
                    closingBalance: closingBalance,
                    note: notes,
                  );
                  _routerService.replaceWith(const LoginRoute());
                } else {
                  // If dialog is cancelled or no data, still redirect to login
                  _routerService.replaceWith(const LoginRoute());
                }
              } else {
                _routerService.replaceWith(const LoginRoute());
              }
            } catch (e) {
              // Log the error
              print('Error during logout flow: $e');

              // Show error dialog to user
              await _dialogService.showCustomDialog(
                variant: DialogType.info,
                title: 'Error',
                description: 'An error occurred during logout: $e',
              );

              // Ensure user is redirected to login in case of error
              _routerService.replaceWith(const LoginRoute());
            }
          } else {
            _routerService.replaceWith(const LoginRoute());
          }
        },
        tooltip: 'Log Out Shift',
        isLogout: true,
      ),
    ];

    // Width, border, and header logo live in [DashboardLayout] so the logo shares
    // one row with [UnifiedTopBar] / FLIPPER.
    return Column(
      children: [
        Expanded(
          child: Column(
            children: menuItems.map((item) => Expanded(child: item)).toList(),
          ),
        ),
        Column(
          children: [
            IconButton(
              icon: SvgPicture.string(
                _SideMenuSvgs.appGrid,
                width: 24,
                height: 24,
              ),
              onPressed: () {
                _dialogService.showCustomDialog(
                  variant: DialogType.appChoice,
                  title: 'Choose Your Default App',
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const ActiveBranch(),
            ),
          ],
        ),
      ],
    );
  }
}

class _SideMenuSvgs {
  _SideMenuSvgs._();

  static const inventory =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 2L2 7l10 5 10-5-10-5z" stroke="#5B6478" stroke-width="1.7" stroke-linejoin="round" stroke-linecap="round"/>
  <path d="M2 17l10 5 10-5" stroke="#5B6478" stroke-width="1.7" stroke-linejoin="round" stroke-linecap="round"/>
  <path d="M2 12l10 5 10-5" stroke="#5B6478" stroke-width="1.7" stroke-linejoin="round" stroke-linecap="round"/>
</svg>''';

  static const stockRecount =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" stroke="#5B6478" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="9" y="3" width="6" height="4" rx="1" stroke="#5B6478" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M9 12h1M12 12h1M15 12h1" stroke="#5B6478" stroke-width="1.8" stroke-linecap="round"/>
  <path d="M9 15.5h1M12 15.5h1" stroke="#5B6478" stroke-width="1.8" stroke-linecap="round"/>
  <path d="M14.5 14.5l1.5 1.5-1.5 1.5" stroke="#5B6478" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const inboxImport =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="4" width="20" height="16" rx="2" stroke="#5B6478" stroke-width="1.7"/>
  <path d="M2 9h20" stroke="#5B6478" stroke-width="1.7" stroke-linecap="round"/>
  <path d="M12 13v4M10 15l2 2 2-2" stroke="#5B6478" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const history =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M20.5 12A8.5 8.5 0 1112 3.5" stroke="#5B6478" stroke-width="1.7" stroke-linecap="round"/>
  <path d="M12 3.5V7M9 5h6" stroke="#5B6478" stroke-width="1.7" stroke-linecap="round"/>
  <path d="M12 8v4l3 2" stroke="#5B6478" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const logout =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M9 4H5a1 1 0 00-1 1v14a1 1 0 001 1h4" stroke="#E24B4A" stroke-width="1.7" stroke-linecap="round"/>
  <path d="M15 16l4-4-4-4" stroke="#E24B4A" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M9 12h10" stroke="#E24B4A" stroke-width="1.7" stroke-linecap="round"/>
</svg>''';

  static const appGrid =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="5" cy="5" r="1.5" fill="#5B6478"/>
  <circle cx="12" cy="5" r="1.5" fill="#5B6478"/>
  <circle cx="19" cy="5" r="1.5" fill="#5B6478"/>
  <circle cx="5" cy="12" r="1.5" fill="#5B6478"/>
  <circle cx="12" cy="12" r="1.5" fill="#5B6478"/>
  <circle cx="19" cy="12" r="1.5" fill="#5B6478"/>
  <circle cx="5" cy="19" r="1.5" fill="#5B6478"/>
  <circle cx="12" cy="19" r="1.5" fill="#5B6478"/>
  <circle cx="19" cy="19" r="1.5" fill="#5B6478"/>
</svg>''';

  static const aiChat =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z" stroke="#7C3AED" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="8.5" cy="11" r="1" fill="#7C3AED"/>
  <circle cx="12" cy="11" r="1" fill="#7C3AED"/>
  <circle cx="15.5" cy="11" r="1" fill="#7C3AED"/>
</svg>''';

  static const production =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="7" width="20" height="13" rx="2" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M2 10h20" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/>
  <path d="M6 4h12" stroke="#2563EB" stroke-width="1.6" stroke-linecap="round"/>
  <rect x="5" y="14" width="3" height="2" rx="0.5" fill="#2563EB"/>
  <rect x="10" y="14" width="3" height="2" rx="0.5" fill="#2563EB"/>
  <rect x="15" y="14" width="4" height="2" rx="0.5" fill="#2563EB"/>
</svg>''';
}

class _SideMenuItem extends StatelessWidget {
  final Widget Function(Color iconColor) iconBuilder;
  final bool isSelected;
  final VoidCallback onTap;
  final String tooltip;
  final bool isLogout;

  const _SideMenuItem({
    required this.iconBuilder,
    required this.isSelected,
    required this.onTap,
    required this.tooltip,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = PosLayoutBreakpoints.posAccentBlue;
    final color = isLogout
        ? Colors.red
        : (isSelected ? accent : const Color(0xFF64748B));

    final content = Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isLogout
                    ? Colors.red.withValues(alpha: 0.08)
                    : accent.withValues(alpha: 0.1))
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: iconBuilder(color),
        ),
      ),
    );

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: isSelected
            ? Row(
                children: [
                  Container(
                    width: 4,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isLogout ? Colors.red : accent,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                  ),
                  Expanded(child: content),
                ],
              )
            : content,
      ),
    );
  }
}
