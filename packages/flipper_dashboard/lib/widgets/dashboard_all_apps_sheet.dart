import 'dart:ui';

import 'package:flipper_dashboard/dashboard_quick_apps_navigation.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_catalog.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// All apps launcher bottom sheet (More tab) per design handoff.
class DashboardAllAppsSheet {
  DashboardAllAppsSheet._();

  static const _sheetDuration = Duration(milliseconds: 320);

  static Future<void> show(BuildContext context, WidgetRef ref) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'All apps',
      barrierColor: Colors.transparent,
      transitionDuration: _sheetDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const _DashboardAllAppsSheetBody();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final reduceMotion = MediaQuery.disableAnimationsOf(context);
        final scrimCurve = reduceMotion ? Curves.linear : Curves.ease;
        final sheetCurve = reduceMotion ? Curves.linear : Curves.easeOutCubic;

        return Stack(
          fit: StackFit.expand,
          children: [
            FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Interval(0, 0.625, curve: scrimCurve),
                  reverseCurve: Interval(0, 0.625, curve: scrimCurve),
                ),
              ),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    color: const Color(0x6B0B1220),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: sheetCurve,
                    reverseCurve: sheetCurve,
                  ),
                ),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DashboardAllAppsSheetBody extends ConsumerWidget {
  const _DashboardAllAppsSheetBody();

  static const Color _lineStrong = Color(0xFFD1D5DB);
  static const Color _surface2 = Color(0xFFF4F6FB);
  static const Color _ink2 = Color(0xFF56554F);
  static const Color _ink3 = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = filterDashboardAllAppsCatalog(ref);
    final branchName = ref.watch(activeBranchProvider).maybeWhen(
          data: (b) => b.name?.trim(),
          orElse: () => null,
        );
    final subtitle = branchName != null && branchName.isNotEmpty
        ? branchName
        : 'your business';

    final stockSummary = ref.watch(stockValueSummaryProvider).maybeWhen(
          data: (s) => s,
          orElse: () => null,
        );
    final lowStockCount = stockSummary?.needsRestockCount ?? 0;

    final screenHeight = MediaQuery.sizeOf(context).height;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final maxHeight = screenHeight * 0.86;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B1220).withValues(alpha: 0.3),
              offset: const Offset(0, -16),
              blurRadius: 44,
              spreadRadius: -12,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: _lineStrong,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All apps',
                          style: GoogleFonts.outfit(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.02 * 19,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Everything in $subtitle',
                          style: GoogleFonts.outfit(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: _ink3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: _surface2,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: 34,
                        height: 34,
                        child: Icon(Icons.close, size: 17, color: _ink2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 22 + bottomInset),
                children: [
                  for (var i = 0; i < sections.length; i++) ...[
                    Padding(
                      padding: EdgeInsets.fromLTRB(6, i == 0 ? 0 : 16, 6, 12),
                      child: Text(
                        sections[i].label.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.08 * 11,
                          color: _ink3,
                        ),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 4,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: sections[i].apps.length,
                      itemBuilder: (context, index) {
                        final tile = sections[i].apps[index];
                        String? badge = tile.badge;
                        if (tile.page == 'Inventory' && lowStockCount > 0) {
                          badge = '$lowStockCount';
                        }
                        return _AppTile(
                          tile: tile,
                          badge: badge,
                          onTap: () async {
                            Navigator.of(context).pop();
                            await navigateToDashboardAppPage(
                              context: context,
                              isBigScreen: false,
                              page: tile.page,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppTile extends StatefulWidget {
  const _AppTile({
    required this.tile,
    required this.onTap,
    this.badge,
  });

  final DashboardAllAppTile tile;
  final VoidCallback onTap;
  final String? badge;

  @override
  State<_AppTile> createState() => _AppTileState();
}

class _AppTileState extends State<_AppTile> {
  bool _pressed = false;

  Color get _iconBg => Color.alphaBlend(
        widget.tile.color.withValues(alpha: 0.13),
        Colors.white,
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        onHighlightChanged: (pressed) => setState(() => _pressed = pressed),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.ease,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: _iconBg,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        widget.tile.icon,
                        color: widget.tile.color,
                        size: 24,
                      ),
                    ),
                    if (widget.badge != null)
                      Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 18),
                          height: 18,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5484D),
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.badge!,
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.tile.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
