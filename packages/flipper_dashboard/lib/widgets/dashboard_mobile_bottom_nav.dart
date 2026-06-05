import 'package:flipper_dashboard/dashboard_mobile_pos_navigation.dart';
import 'package:flipper_dashboard/dashboard_quick_apps_navigation.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_sheet.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum DashboardMobileTab { home, sales, inventory, more }

class DashboardMobileBottomNav extends ConsumerWidget {
  const DashboardMobileBottomNav({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  final DashboardMobileTab activeTab;
  final ValueChanged<DashboardMobileTab> onTabSelected;

  static const Color _blue = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: bottomPad > 0 ? bottomPad : 8),
      child: SizedBox(
        height: 64,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: FluentIcons.home_24_regular,
                  label: FLocalization.of(context).home,
                  selected: activeTab == DashboardMobileTab.home,
                  onTap: () => onTabSelected(DashboardMobileTab.home),
                ),
                _NavItem(
                  icon: FluentIcons.cart_24_regular,
                  label: FLocalization.of(context).sales,
                  selected: activeTab == DashboardMobileTab.sales,
                  onTap: () async {
                    onTabSelected(DashboardMobileTab.sales);
                    await navigateToDashboardAppPage(
                      context: context,
                      isBigScreen: false,
                      page: 'Transactions',
                    );
                  },
                ),
                const SizedBox(width: 72),
                _NavItem(
                  icon: FluentIcons.box_24_regular,
                  label: FLocalization.of(context).inventory,
                  selected: activeTab == DashboardMobileTab.inventory,
                  onTap: () async {
                    onTabSelected(DashboardMobileTab.inventory);
                    await navigateToDashboardAppPage(
                      context: context,
                      isBigScreen: false,
                      page: 'Inventory',
                    );
                  },
                ),
                _NavItem(
                  icon: FluentIcons.grid_24_regular,
                  label: FLocalization.of(context).more,
                  selected: activeTab == DashboardMobileTab.more,
                  onTap: () async {
                    onTabSelected(DashboardMobileTab.more);
                    await DashboardAllAppsSheet.show(context, ref);
                  },
                ),
              ],
            ),
            Positioned(
              top: -28,
              child: _NewSaleFab(
                onTap: () => openMobilePosCheckout(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? DashboardMobileBottomNav._blue
        : Colors.grey.shade600;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewSaleFab extends StatefulWidget {
  const _NewSaleFab({required this.onTap});

  final Future<void> Function() onTap;

  @override
  State<_NewSaleFab> createState() => _NewSaleFabState();
}

class _NewSaleFabState extends State<_NewSaleFab> {
  bool _pressed = false;
  bool _opening = false;

  Future<void> _open() async {
    if (_opening) return;
    setState(() {
      _opening = true;
      _pressed = true;
    });

    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    try {
      await widget.onTap();
    } finally {
      if (mounted) {
        setState(() {
          _opening = false;
          _pressed = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) {
            if (!_opening) setState(() => _pressed = true);
          },
          onTapUp: (_) {
            if (!_opening) setState(() => _pressed = false);
          },
          onTapCancel: () {
            if (!_opening) setState(() => _pressed = false);
          },
          onTap: _open,
          child: AnimatedScale(
            scale: _pressed ? 0.94 : 1,
            duration: const Duration(milliseconds: 120),
            curve: Curves.ease,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF22D3EE),
                    Color(0xFF2563EB),
                    Color(0xFF4F46E5),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                    offset: const Offset(0, 6),
                    blurRadius: 16,
                  ),
                ],
                border: Border.all(color: const Color(0xFFF4F6FB), width: 4),
              ),
              child: _opening
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.6,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.add, color: Colors.white, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'New sale',
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
