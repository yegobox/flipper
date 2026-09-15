import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/pos_handoff_icon.dart';
import 'package:flutter/material.dart';

/// Square tool control (36×36, radius 6) for contextual top-bar actions.
class PosTopToolButton extends StatelessWidget {
  const PosTopToolButton({
    super.key,
    required this.iconName,
    required this.tooltip,
    required this.onPressed,
    this.iconSize = 18,
    this.isActive = false,
  });

  final String iconName;
  final String tooltip;
  final VoidCallback onPressed;
  final double iconSize;
  final bool isActive;

  static const double size = 36;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? PosTokens.blue : PosTokens.ink2;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: isActive ? PosTokens.blueTint : Colors.transparent,
        borderRadius: BorderRadius.circular(PosTokens.radiusSm),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(PosTokens.radiusSm),
          hoverColor: PosTokens.surface2,
          focusColor: PosTokens.blueTint,
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: PosHandoffIcons.svg(
                iconName,
                size: iconSize,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular icon control (notifications, sync). Round is the one shape kept
/// for icon-only status buttons; everything else uses [PosTokens.radiusSm].
class PosTopCircleIconButton extends StatelessWidget {
  const PosTopCircleIconButton({
    super.key,
    required this.iconName,
    required this.tooltip,
    required this.onPressed,
    this.iconSize = 18,
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
          focusColor: PosTokens.blueTint,
          child: SizedBox(
            width: 36,
            height: 36,
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
                    top: 1,
                    right: 1,
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
