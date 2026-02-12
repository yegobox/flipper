import 'package:flipper_dashboard/ActiveBranch.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'providers/navigation_providers.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_dashboard/layout.dart';
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
        icon: Icons.dashboard_outlined,
        isSelected: selectedItem == 0,
        onTap: () {
          ref.read(selectedMenuItemProvider.notifier).state = 0;
          ref.read(selectedPageProvider.notifier).state =
              DashboardPage.inventory;
        },
        tooltip: 'Overview',
      ),
      _SideMenuItem(
        icon: Icons.chat_bubble,
        isSelected: selectedItem == 1,
        onTap: () {
          ref.read(selectedMenuItemProvider.notifier).state = 1;
          ref.read(selectedPageProvider.notifier).state = DashboardPage.ai;
        },
        tooltip: 'Chat',
      ),
      if (hasInventory)
        _SideMenuItem(
          icon: FluentIcons.box_24_regular,
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
          icon: Icons.restaurant_menu,
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
          icon: Icons.inventory_2_outlined,
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
          icon: Icons.print_outlined,
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
          icon: Icons.move_to_inbox,
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
          icon: Icons.factory_outlined,
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
          icon: Icons.history,
          isSelected: selectedItem == 5,
          onTap: () {
            ref.read(selectedMenuItemProvider.notifier).state = 5;
            ref.read(selectedPageProvider.notifier).state =
                DashboardPage.shiftHistory;
          },
          tooltip: 'Shift History',
        ),
      _SideMenuItem(
        icon: Icons.logout,
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

    return Container(
      width: 80,
      color: Colors.white,
      child: Column(
        children: [
          // Header

          // Menu Items
          Expanded(
            child: Column(
              children: menuItems.map((item) => Expanded(child: item)).toList(),
            ),
          ),

          // Footer
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.apps),
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
      ),
    );
  }
}

class _SideMenuItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String tooltip;
  final bool isLogout;

  const _SideMenuItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.tooltip,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isLogout
        ? Colors.red
        : (isSelected ? Colors.blue : Colors.grey.shade600);

    final content = Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isLogout
                    ? Colors.red.withValues(alpha: 0.1)
                    : Colors.blue.withValues(alpha: 0.1))
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: color,
            size: 24, // Slightly larger for better visibility
          ),
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
                    height: 32, // Height of the selection indicator
                    decoration: BoxDecoration(
                      color: isLogout ? Colors.red : Colors.blue,
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
