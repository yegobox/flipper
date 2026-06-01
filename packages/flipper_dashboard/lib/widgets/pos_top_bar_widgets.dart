import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/pos_handoff_icon.dart';
import 'package:flutter/material.dart';

/// Square tool control (38×38, radius 10) — handoff `.pos-tool`.
class PosTopToolButton extends StatelessWidget {
  const PosTopToolButton({
    super.key,
    required this.iconName,
    required this.tooltip,
    required this.onPressed,
    this.iconSize = 19,
    this.isActive = false,
  });

  final String iconName;
  final String tooltip;
  final VoidCallback onPressed;
  final double iconSize;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? PosTokens.blue : PosTokens.ink2;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(PosTokens.radiusSm),
          hoverColor: PosTokens.surface2,
          child: SizedBox(
            width: 38,
            height: 38,
            child: Center(
              child: PosHandoffIcons.svg(iconName, size: iconSize, color: color),
            ),
          ),
        ),
      ),
    );
  }
}

/// Primary nav tab — handoff `.pos-navitem`.
class PosTopNavItem extends StatelessWidget {
  const PosTopNavItem({
    super.key,
    required this.iconName,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.onDoubleTap,
  });

  final String iconName;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final fg = isSelected ? PosTokens.blue : PosTokens.ink2;
    final bg = isSelected ? PosTokens.blueTint : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        borderRadius: BorderRadius.circular(PosTokens.radiusSm),
        hoverColor: PosTokens.surface2,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(PosTokens.radiusSm),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PosHandoffIcons.svg(iconName, size: 18, color: fg),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: fg,
                      letterSpacing: -0.01,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular icon control — handoff `.pos-iconbtn`.
class PosTopCircleIconButton extends StatelessWidget {
  const PosTopCircleIconButton({
    super.key,
    required this.iconName,
    required this.tooltip,
    required this.onPressed,
    this.iconSize = 20,
    this.badge,
  });

  final String iconName;
  final String tooltip;
  final VoidCallback onPressed;
  final double iconSize;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          hoverColor: PosTokens.surface2,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                PosHandoffIcons.svg(
                  iconName,
                  size: iconSize,
                  color: PosTokens.ink2,
                ),
                if (badge != null)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 16),
                      height: 16,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: PosTokens.loss,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: PosTokens.surface, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
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
