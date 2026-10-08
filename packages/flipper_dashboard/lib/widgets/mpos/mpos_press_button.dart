import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Tappable wrapper for custom-painted mobile buttons (gradient fills, outlined
/// icon tiles) that can't host an [InkWell] ripple without being rebuilt.
///
/// Feedback is a press-scale plus a light haptic, and the hit area is grown to
/// at least [minTapSize] around the child even when it is drawn smaller — a
/// 34–40dp icon tile stays visually small but meets the 48dp touch target.
class MposPressButton extends StatefulWidget {
  const MposPressButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.semanticLabel,
    this.pressScale = 0.95,
    this.minTapSize = 48,
  });

  final VoidCallback? onPressed;
  final Widget child;

  /// Read by screen readers; set it when [child] is an icon with no text.
  final String? semanticLabel;
  final double pressScale;
  final double minTapSize;

  @override
  State<MposPressButton> createState() => _MposPressButtonState();
}

class _MposPressButtonState extends State<MposPressButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        onTap: enabled
            ? () {
                HapticFeedback.lightImpact();
                widget.onPressed!();
              }
            : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: widget.minTapSize,
            minHeight: widget.minTapSize,
          ),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: AnimatedScale(
              scale: _pressed ? widget.pressScale : 1,
              duration: const Duration(milliseconds: 100),
              curve: Curves.ease,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
