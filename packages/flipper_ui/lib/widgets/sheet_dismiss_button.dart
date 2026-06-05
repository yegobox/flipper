import 'package:flutter/material.dart';

/// Close control for modal sheets with a 48×48 hit target (touch + cursor).
class SheetDismissButton extends StatelessWidget {
  const SheetDismissButton({
    super.key,
    this.onPressed,
    this.backgroundColor = const Color(0xFFF3F4F6),
    this.foregroundColor = const Color(0xFF111827),
  });

  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final label = MaterialLocalizations.of(context).closeButtonLabel;

    return Tooltip(
      message: label,
      child: IconButton(
        onPressed: onPressed,
        tooltip: label,
        iconSize: 22,
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor,
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.35),
          shape: const CircleBorder(),
        ),
        icon: const Icon(Icons.close_rounded),
      ),
    );
  }
}
