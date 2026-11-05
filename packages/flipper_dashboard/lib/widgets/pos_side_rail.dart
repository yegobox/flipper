import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The desktop left rail's building blocks.
///
/// [EnhancedSideMenu] (the POS) and Flipper HR's shell both draw their rail
/// from these, so the two apps share one look and cannot drift apart. Change
/// the rail here, never in a copy.

/// The rail's column: [PosLayoutBreakpoints.sideMenuWidth] wide, white, a hairline on its
/// right edge. The POS dashboard and the HR shell both mount their rail in it.
///
/// The opaque fill would hide ink painted on the Material behind it, so the
/// entries get a transparent Material of their own above the fill: their
/// hover and keyboard-focus highlights draw on that one and stay visible.
class PosRailFrame extends StatelessWidget {
  const PosRailFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: PosLayoutBreakpoints.sideMenuWidth,
      child: Container(
        decoration: const BoxDecoration(
          color: PosTokens.posRail,
          border: Border(right: BorderSide(color: PosTokens.line, width: 1)),
        ),
        child: Material(type: MaterialType.transparency, child: child),
      ),
    );
  }
}

/// The rail's entries: [groups] scroll, with a hairline between each
/// non-empty group; [bottom] is pinned below another hairline, one slot each;
/// [footer] sits under it at its own height.
class PosRailColumn extends StatelessWidget {
  const PosRailColumn({
    super.key,
    required this.groups,
    required this.bottom,
    this.footer,
  });

  final List<List<Widget>> groups;
  final List<Widget> bottom;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final nonEmpty = groups.where((g) => g.isNotEmpty).toList();
    final menuItems = <Widget>[
      for (var i = 0; i < nonEmpty.length; i++) ...[
        if (i > 0) const PosRailDivider(),
        ...nonEmpty[i],
      ],
    ];

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                for (final item in menuItems)
                  item is PosRailDivider
                      ? item
                      : SizedBox(height: PosRailItem.slotHeight, child: item),
              ],
            ),
          ),
        ),
        const PosRailDivider(),
        for (final item in bottom)
          SizedBox(height: PosRailItem.slotHeight, child: item),
        ?footer,
      ],
    );
  }
}

/// Hairline between rail groups.
class PosRailDivider extends StatelessWidget {
  const PosRailDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: Container(width: 24, height: 1, color: PosTokens.line),
      ),
    );
  }
}

class PosRailSvgs {
  PosRailSvgs._();

  static const inventory =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 2L2 7l10 5 10-5-10-5z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round" stroke-linecap="round"/>
  <path d="M2 17l10 5 10-5" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round" stroke-linecap="round"/>
  <path d="M2 12l10 5 10-5" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round" stroke-linecap="round"/>
</svg>''';

  static const stockRecount =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <rect x="9" y="3" width="6" height="4" rx="1" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M9 12h1M12 12h1M15 12h1" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
  <path d="M9 15.5h1M12 15.5h1" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
  <path d="M14.5 14.5l1.5 1.5-1.5 1.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const inboxImport =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="4" width="20" height="16" rx="2" stroke="currentColor" stroke-width="1.7"/>
  <path d="M2 9h20" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
  <path d="M12 13v4M10 15l2 2 2-2" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const history =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M20.5 12A8.5 8.5 0 1112 3.5" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
  <path d="M12 3.5V7M9 5h6" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
  <path d="M12 8v4l3 2" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

  static const logout =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M9 4H5a1 1 0 00-1 1v14a1 1 0 001 1h4" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
  <path d="M15 16l4-4-4-4" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M9 12h10" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/>
</svg>''';

  static const appGrid =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="5" cy="5" r="1.5" fill="currentColor"/>
  <circle cx="12" cy="5" r="1.5" fill="currentColor"/>
  <circle cx="19" cy="5" r="1.5" fill="currentColor"/>
  <circle cx="5" cy="12" r="1.5" fill="currentColor"/>
  <circle cx="12" cy="12" r="1.5" fill="currentColor"/>
  <circle cx="19" cy="12" r="1.5" fill="currentColor"/>
  <circle cx="5" cy="19" r="1.5" fill="currentColor"/>
  <circle cx="12" cy="19" r="1.5" fill="currentColor"/>
  <circle cx="19" cy="19" r="1.5" fill="currentColor"/>
</svg>''';

  static const aiChat =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="8.5" cy="11" r="1" fill="currentColor"/>
  <circle cx="12" cy="11" r="1" fill="currentColor"/>
  <circle cx="15.5" cy="11" r="1" fill="currentColor"/>
</svg>''';

  static const production =
      '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect x="2" y="7" width="20" height="13" rx="2" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M2 10h20" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
  <path d="M6 4h12" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
  <rect x="5" y="14" width="3" height="2" rx="0.5" fill="currentColor"/>
  <rect x="10" y="14" width="3" height="2" rx="0.5" fill="currentColor"/>
  <rect x="15" y="14" width="4" height="2" rx="0.5" fill="currentColor"/>
</svg>''';
}

Widget posRailSvg(String svg, Color color) {
  return SvgPicture.string(
    svg,
    width: PosTokens.iconMd,
    height: PosTokens.iconMd,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}

class PosRailItem extends StatelessWidget {
  final Widget Function(Color iconColor) iconBuilder;
  final bool isSelected;
  final VoidCallback onTap;
  final String tooltip;
  final bool isLogout;

  /// Row height per rail entry (40px hit target + breathing room).
  static const double slotHeight = 44;
  static const double hitSize = PosTokens.controlHeight;

  const PosRailItem({
    super.key,
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
        ? PosTokens.loss
        : (isSelected ? accent : PosTokens.ink3);

    final content = Center(
      child: AnimatedContainer(
        duration: PosTokens.hoverTransition,
        curve: Curves.ease,
        width: hitSize,
        height: hitSize,
        decoration: BoxDecoration(
          color: isSelected
              ? (isLogout ? PosTokens.lossTint : PosTokens.blueTint)
              : null,
          borderRadius: BorderRadius.circular(PosTokens.radiusSm),
        ),
        child: Center(
          child: IconTheme.merge(
            data: IconThemeData(size: PosTokens.iconMd, color: color),
            child: iconBuilder(color),
          ),
        ),
      ),
    );

    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 400),
      child: Semantics(
        button: true,
        selected: isSelected,
        label: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(PosTokens.radiusSm),
          hoverColor: isLogout ? PosTokens.lossTint : PosTokens.surface2,
          focusColor: isLogout ? PosTokens.lossTint : PosTokens.blueTint,
          child: Stack(
            children: [
              Positioned.fill(child: content),
              if (isSelected)
                Positioned(
                  left: 0,
                  top: (slotHeight - 20) / 2,
                  child: Container(
                    width: 3,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isLogout ? PosTokens.loss : accent,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(3),
                        bottomRight: Radius.circular(3),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
