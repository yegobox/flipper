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
                child: Container(
                  color: const Color(0x6B0B1220),
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

    final maxHeight = MediaQuery.sizeOf(context).height * 0.86;

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'All apps',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Everything in $subtitle',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFF4F6FB),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    children: [
                      for (final section in sections) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 12),
                          child: Text(
                            section.label.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.72,
                          ),
                          itemCount: section.apps.length,
                          itemBuilder: (context, index) {
                            final tile = section.apps[index];
                            String? badge = tile.badge;
                            if (tile.page == 'Inventory' &&
                                lowStockCount > 0) {
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

  Color get _iconBg =>
      Color.alphaBlend(
        widget.tile.color.withValues(alpha: 0.13),
        Colors.white,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.ease,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: _iconBg,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(
                    widget.tile.icon,
                    color: widget.tile.color,
                    size: 24,
                  ),
                ),
                if (widget.badge != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5484D),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        widget.badge!,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              widget.tile.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
