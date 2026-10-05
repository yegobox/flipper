import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// How far to slide the content up so [field] clears a keyboard whose top
/// edge is at [keyboardTop], leaving [margin] between them.
///
/// Never slides the field's top edge off the screen, and never slides down.
@visibleForTesting
double keyboardPanShift(Rect field, double keyboardTop, {double margin = 16}) {
  final needed = field.bottom + margin - keyboardTop;
  if (needed <= 0) return 0;
  return math.min(needed, math.max(0, field.top));
}

/// Slides [child] up while the on-screen keyboard covers the focused text
/// field, like Android's adjustPan: the layout keeps its full size (nothing
/// is squeezed) and slides back when the keyboard hides or focus moves to a
/// field that is not covered.
class KeyboardPan extends StatefulWidget {
  const KeyboardPan({
    required this.occlusion,
    required this.child,
    super.key,
  });

  /// The covered part of the view in logical pixels, or null while hidden.
  final ValueListenable<Rect?> occlusion;
  final Widget child;

  @override
  State<KeyboardPan> createState() => _KeyboardPanState();
}

class _KeyboardPanState extends State<KeyboardPan> {
  final GlobalKey _contentKey = GlobalKey();
  double _shift = 0;

  @override
  void initState() {
    super.initState();
    widget.occlusion.addListener(_scheduleUpdate);
    FocusManager.instance.addListener(_scheduleUpdate);
  }

  @override
  void didUpdateWidget(KeyboardPan oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.occlusion != widget.occlusion) {
      oldWidget.occlusion.removeListener(_scheduleUpdate);
      widget.occlusion.addListener(_scheduleUpdate);
      _scheduleUpdate();
    }
  }

  @override
  void dispose() {
    widget.occlusion.removeListener(_scheduleUpdate);
    FocusManager.instance.removeListener(_scheduleUpdate);
    super.dispose();
  }

  // Focus moves before the frame that lays the new field out; measure after.
  void _scheduleUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final shift = _measureShift();
      if (shift != _shift) setState(() => _shift = shift);
    });
    WidgetsBinding.instance.scheduleFrame();
  }

  double _measureShift() {
    final occluded = widget.occlusion.value;
    final focusContext = FocusManager.instance.primaryFocus?.context;
    if (occluded == null || focusContext == null || !focusContext.mounted) {
      return 0;
    }
    // Only text fields: a focused button under the keyboard stays put.
    if (focusContext.findAncestorWidgetOfExactType<EditableText>() == null) {
      return 0;
    }
    final field = focusContext.findRenderObject();
    final content = _contentKey.currentContext?.findRenderObject();
    if (field is! RenderBox ||
        content is! RenderBox ||
        !field.attached ||
        !field.hasSize) {
      return 0;
    }
    // Measured against the content root, below the slide, so the result does
    // not depend on how far the content is slid right now.
    final rect = MatrixUtils.transformRect(
      field.getTransformTo(content),
      Offset.zero & field.size,
    );
    return keyboardPanShift(rect, occluded.top);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _shift),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      builder: (context, shift, child) => Transform.translate(
        offset: Offset(0, -shift),
        child: child,
      ),
      child: KeyedSubtree(key: _contentKey, child: widget.child),
    );
  }
}
