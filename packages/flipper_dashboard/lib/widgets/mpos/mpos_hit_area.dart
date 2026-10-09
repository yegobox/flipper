import 'package:flutter/material.dart';

/// Grows the touch target of a small control (a 34–44dp icon circle) to
/// [size] without changing how it looks.
///
/// Taps in the margin around [child] call [onTap] too; taps on [child] reach
/// its own [InkWell] first, so its ripple still shows.
class MposHitArea extends StatelessWidget {
  const MposHitArea({
    super.key,
    required this.onTap,
    required this.child,
    this.semanticLabel,
    this.size = 48,
  });

  final VoidCallback? onTap;
  final Widget child;
  final String? semanticLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: child),
        ),
      ),
    );
  }
}
