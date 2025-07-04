import 'package:flipper_dashboard/ActiveBranch.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'providers/navigation_providers.dart';
import 'package:flipper_routing/app.dialogs.dart';

class EnhancedSideMenu extends ConsumerWidget {
  const EnhancedSideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedMenuItemProvider);
    final _dialogService = locator<DialogService>();
    final _routerService = locator<RouterService>();

    return SideMenu(
      mode: SideMenuMode.compact,
      builder: (data) {
        return SideMenuData(
          header: Container(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              'assets/logo.png',
              package: 'flipper_dashboard',
              width: 40,
              height: 40,
            ),
          ),
          items: [
            SideMenuItemDataTile(
              hasSelectedLine: true,
              highlightSelectedColor: Colors.blue.withValues(alpha: 0.1),
              selectedTitleStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(8),
              title: 'Overview',
              isSelected: selectedItem == 0,
              icon: Icon(
                Icons.dashboard_outlined,
                color: selectedItem == 0 ? Colors.blue : Colors.grey.shade600,
                size: 20,
              ),
              onTap: () {
                ref.read(selectedMenuItemProvider.notifier).state = 0;
              },
            ),
            SideMenuItemDataTile(
              hasSelectedLine: true,
              highlightSelectedColor: Colors.blue.withValues(alpha: 0.1),
              selectedTitleStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(8),
              title: 'Chat',
              isSelected: selectedItem == 1,
              icon: Icon(
                Icons.chat_bubble,
                color: selectedItem == 1 ? Colors.blue : Colors.grey.shade600,
                size: 20,
              ),
              onTap: () {
                ref.read(selectedMenuItemProvider.notifier).state = 1;
              },
            ),
            SideMenuItemDataTile(
              hasSelectedLine: true,
              highlightSelectedColor: Colors.blue.withValues(alpha: 0.1),
              selectedTitleStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(8),
              title: 'Items',
              isSelected: selectedItem == 2,
              icon: Icon(
                FluentIcons.box_24_regular,
                color: selectedItem == 2 ? Colors.blue : Colors.grey.shade600,
                size: 20,
              ),
              onTap: () {
                ref.read(selectedMenuItemProvider.notifier).state = 2;
              },
            ),
            SideMenuItemDataTile(
              hasSelectedLine: true,
              highlightSelectedColor: Colors.blue.withValues(alpha: 0.1),
              selectedTitleStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(8),
              title: 'Kitchen Display',
              isSelected: selectedItem == 3,
              icon: Icon(
                Icons.restaurant_menu,
                color: selectedItem == 3 ? Colors.blue : Colors.grey.shade600,
                size: 20,
              ),
              onTap: () {
                ref.read(selectedMenuItemProvider.notifier).state = 3;
              },
            ),
            SideMenuItemDataTile(
              hasSelectedLine: true,
              isSelected: selectedItem == 4,
              highlightSelectedColor: Colors.red.withValues(alpha: 0.1),
              selectedTitleStyle: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(8),
              title: 'Log Out Shift',
              icon: Icon(
                Icons.logout,
                color: Colors.grey.shade600,
                size: 20,
              ),
              onTap: () async {
                final userId = ProxyService.box.getUserId();
                if (userId != null) {
                  final currentShift = await ProxyService.strategy
                      .getCurrentShift(userId: userId);
                  if (currentShift != null) {
                    final dialogResponse =
                        await _dialogService.showCustomDialog(
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
                      final closingBalance = (dialogResponse?.data
                                  as Map<dynamic, dynamic>)['closingBalance']
                              as double? ??
                          0.0;
                      await ProxyService.strategy.endShift(
                          shiftId: currentShift.id,
                          closingBalance: closingBalance);
                      _routerService.replaceWith(const LoginRoute());
                    }
                  } else {
                    // If no active shift, just navigate to login
                    _routerService.replaceWith(const LoginRoute());
                  }
                } else {
                  // If no user ID, just navigate to login
                  _routerService.replaceWith(const LoginRoute());
                }
              },
            ),
          ],
          footer: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const ActiveBranch(),
          ),
        );
      },
    );
  }
}
