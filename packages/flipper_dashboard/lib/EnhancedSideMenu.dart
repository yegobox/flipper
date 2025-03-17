import 'package:flipper_dashboard/ActiveBranch.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'providers/navigation_providers.dart';

class EnhancedSideMenu extends ConsumerWidget {
  const EnhancedSideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              highlightSelectedColor: Colors.blue.withOpacity(0.1),
              selectedTitleStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(8),
              title: 'Overview',
              isSelected: ref.watch(selectedMenuItemProvider) == 0,
              icon: Icon(
                Icons.dashboard_outlined,
                color: ref.watch(selectedMenuItemProvider) == 0
                    ? Colors.blue
                    : Colors.grey.shade600,
                size: 20,
              ),
              onTap: () {
                ref.read(selectedMenuItemProvider.notifier).state = 0;
              },
            ),
            SideMenuItemDataTile(
              hasSelectedLine: true,
              highlightSelectedColor: Colors.blue.withOpacity(0.1),
              selectedTitleStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(8),
              title: 'Products',
              isSelected: ref.watch(selectedMenuItemProvider) == 1,
              icon: Icon(
                FluentIcons.box_24_regular,
                color: ref.watch(selectedMenuItemProvider) == 1
                    ? Colors.blue
                    : Colors.grey.shade600,
                size: 20,
              ),
              onTap: () {
                ref.read(selectedMenuItemProvider.notifier).state = 1;
              },
            ),
            SideMenuItemDataTile(
              hasSelectedLine: true,
              highlightSelectedColor: Colors.blue.withOpacity(0.1),
              selectedTitleStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(8),
              title: 'Sales',
              isSelected: ref.watch(selectedMenuItemProvider) == 2,
              icon: Icon(
                FluentIcons.money_24_regular,
                color: ref.watch(selectedMenuItemProvider) == 2
                    ? Colors.blue
                    : Colors.grey.shade600,
                size: 20,
              ),
              onTap: () {
                ref.read(selectedMenuItemProvider.notifier).state = 2;
              },
            ),
            SideMenuItemDataTile(
              hasSelectedLine: true,
              highlightSelectedColor: Colors.blue.withOpacity(0.1),
              selectedTitleStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
              borderRadius: BorderRadius.circular(8),
              title: 'Tickets',
              isSelected: ref.watch(selectedMenuItemProvider) == 3,
              icon: Icon(
                FluentIcons.ticket_diagonal_24_regular,
                color: ref.watch(selectedMenuItemProvider) == 3
                    ? Colors.blue
                    : Colors.grey.shade600,
                size: 20,
              ),
              onTap: () {
                ref.read(selectedMenuItemProvider.notifier).state = 3;
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
