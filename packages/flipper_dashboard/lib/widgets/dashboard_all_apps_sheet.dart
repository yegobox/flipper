import 'package:flipper_design_system/flipper_design_system.dart';

import 'package:flipper_dashboard/dashboard_quick_apps_navigation.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_catalog.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_hit_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// All apps launcher bottom sheet (More tab) per design handoff.
class DashboardAllAppsSheet {
  DashboardAllAppsSheet._();

  static const _sheetDuration = Duration(milliseconds: 320);

  /// A real modal bottom sheet, so the drag handle works (drag down to
  /// dismiss) along with the system back gesture and barrier semantics.
  static Future<void> show(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      barrierColor: const Color(0x6B0B1220),
      barrierLabel: context.flipperL10n.allApps,
      sheetAnimationStyle: AnimationStyle(
        duration: _sheetDuration,
        reverseDuration: _sheetDuration,
        curve: Curves.easeOutCubic,
      ),
      builder: (_) => const _DashboardAllAppsSheetBody(),
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
    final sections = filterDashboardAllAppsCatalog(context, ref);
    final branchName = ref
        .watch(activeBranchProvider)
        .maybeWhen(data: (b) => b.name?.trim(), orElse: () => null);
    final subtitle = branchName != null && branchName.isNotEmpty
        ? branchName
        : context.flipperL10n.dashboardAllAppsYourBusiness;

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
              padding: const EdgeInsets.fromLTRB(20, 4, 13, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.flipperL10n.allApps,
                          style: GoogleFonts.outfit(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.02 * 19,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          context.flipperL10n.dashboardAllAppsEverythingIn(
                            subtitle,
                          ),
                          style: GoogleFonts.outfit(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: _ink3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 34dp circle, 48dp hit area.
                  MposHitArea(
                    onTap: () => Navigator.of(context).pop(),
                    semanticLabel: MaterialLocalizations.of(
                      context,
                    ).closeButtonLabel,
                    child: Material(
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
                      // Height from content, not width: a fixed aspect ratio
                      // clipped two-line labels on 360dp phones and at large
                      // text sizes. 78 = vertical padding + 54 icon + gap.
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 4,
                        mainAxisExtent:
                            80 +
                            2 *
                                MediaQuery.textScalerOf(
                                  context,
                                ).scale(11.5 * 1.2),
                      ),
                      itemCount: sections[i].apps.length,
                      itemBuilder: (context, index) {
                        final tile = sections[i].apps[index];
                        return _AppTile(
                          tile: tile,
                          badge: tile.badge,
                          onTap: () async {
                            final navigator = Navigator.of(
                              context,
                              rootNavigator: true,
                            );
                            navigator.pop();
                            await navigateToDashboardAppPage(
                              context: navigator.context,
                              isBigScreen: false,
                              page: tile.page,
                              ref: ref,
                              navigator: navigator,
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
  const _AppTile({required this.tile, required this.onTap, this.badge});

  final DashboardAllAppTile tile;
  final VoidCallback onTap;
  final String? badge;

  @override
  State<_AppTile> createState() => _AppTileState();
}

class _AppTileState extends State<_AppTile> {
  bool _pressed = false;

  Color get _iconBg =>
      Color.alphaBlend(widget.tile.color.withValues(alpha: 0.13), Colors.white);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
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
                            style: FlipperFonts.mono(
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
