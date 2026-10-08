import 'package:flipper_dashboard/dashboard_quick_apps_navigation.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_sheet.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static const double _barHeight = 64;

  /// How far the New sale button rises above the bar.
  static const double _fabRise = 28;

  /// Extra bottom padding scrolling content needs so its last item can clear
  /// the raised button.
  static const double fabRise = _fabRise;

  static double _barPad(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    return bottomPad > 0 ? bottomPad : 8.0;
  }

  /// Height of the solid bar. Content above should stop here and let the
  /// raised button overlap it — lay the nav over the content in a Stack.
  static double barExtent(BuildContext context) =>
      _barHeight + _barPad(context);

  /// Highlights [tab] while its screen or sheet is open, then hands the
  /// highlight back to Home — the other tabs open on top of the dashboard
  /// rather than replacing it.
  Future<void> _openTab(
    DashboardMobileTab tab,
    Future<void> Function() open,
  ) async {
    HapticFeedback.selectionClick();
    onTabSelected(tab);
    try {
      await open();
    } finally {
      onTabSelected(DashboardMobileTab.home);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barPad = _barPad(context);

    // The Stack is tall enough to contain the raised button. A child sticking
    // out of a Stack (negative top + Clip.none) still paints, but taps on the
    // overhang are never hit-tested — the top half of "+" used to be dead.
    return SizedBox(
      height: _fabRise + _barHeight + barPad,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: _barHeight + barPad,
            child: Container(
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
              padding: EdgeInsets.only(bottom: barPad),
              // Ink of the tab InkWells paints on this Material, above the
              // white fill, so taps visibly ripple.
              child: Material(
                type: MaterialType.transparency,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: FluentIcons.home_24_regular,
                      label: context.flipperL10n.home,
                      selected: activeTab == DashboardMobileTab.home,
                      onTap: () {
                        if (activeTab != DashboardMobileTab.home) {
                          HapticFeedback.selectionClick();
                        }
                        onTabSelected(DashboardMobileTab.home);
                      },
                    ),
                    _NavItem(
                      icon: FluentIcons.cart_24_regular,
                      label: context.flipperL10n.sales,
                      selected: activeTab == DashboardMobileTab.sales,
                      onTap: () => _openTab(
                        DashboardMobileTab.sales,
                        () => navigateToDashboardAppPage(
                          context: context,
                          isBigScreen: false,
                          page: 'Transactions',
                        ),
                      ),
                    ),
                    const SizedBox(width: 72),
                    _NavItem(
                      icon: FluentIcons.box_24_regular,
                      label: context.flipperL10n.inventory,
                      selected: activeTab == DashboardMobileTab.inventory,
                      onTap: () => _openTab(
                        DashboardMobileTab.inventory,
                        () => navigateToDashboardAppPage(
                          context: context,
                          isBigScreen: false,
                          page: 'Inventory',
                        ),
                      ),
                    ),
                    _NavItem(
                      icon: FluentIcons.grid_24_regular,
                      label: context.flipperL10n.more,
                      selected: activeTab == DashboardMobileTab.more,
                      onTap: () => _openTab(
                        DashboardMobileTab.more,
                        () => DashboardAllAppsSheet.show(context, ref),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: _NewSaleFab(
              onTap: () async {
                HapticFeedback.lightImpact();
                await navigateToDashboardAppPage(
                  context: context,
                  isBigScreen: false,
                  page: 'Inventory',
                );
              },
            ),
          ),
        ],
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
            // One line at any locale or text size, so every tab's icon stays
            // on the same baseline (Kinyarwanda labels are long).
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewSaleFab extends StatelessWidget {
  const _NewSaleFab({required this.onTap});

  final VoidCallback onTap;

  static final _radius = BorderRadius.circular(19);

  @override
  Widget build(BuildContext context) {
    final label = context.flipperL10n.mposNewSale;
    // The gradient and glow are a plain DecoratedBox, not Ink: Ink paints on
    // the enclosing Material and is clipped to its rectangle, which cut the
    // blur off into a pale box around the button and its label. Only the
    // ripple lives on a Material, and it is clipped to the rounded button.
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: _radius,
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
              child: Material(
                type: MaterialType.transparency,
                borderRadius: _radius,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: _radius,
                  child: const SizedBox(
                    width: 58,
                    height: 58,
                    child: Icon(Icons.add, color: Colors.white, size: 26),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
