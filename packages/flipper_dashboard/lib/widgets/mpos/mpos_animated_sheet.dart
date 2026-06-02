import 'package:flipper_dashboard/theme/mpos_motion.dart';
import 'package:flutter/material.dart';

/// Bottom sheet with [ANIMATIONS.md] §1: scrim 200ms ease, sheet 320ms decelerate.
Future<T?> showMposAnimatedSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
}) {
  final reduced = MposMotion.reducedMotion(context);
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: isDismissible,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.transparent,
    transitionDuration: reduced ? MposMotion.scrimFade : MposMotion.sheetSlide,
    pageBuilder: (ctx, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: builder(ctx),
      );
    },
    transitionBuilder: (ctx, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: reduced ? Curves.ease : MposMotion.decelerate,
      );
      final scrim = Color.fromRGBO(11, 18, 32, 0.42 * curved.value);

      final slide = reduced
          ? const AlwaysStoppedAnimation<Offset>(Offset.zero)
          : Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved);

      return Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: isDismissible ? () => Navigator.of(ctx).pop() : null,
            child: ColoredBox(color: scrim),
          ),
          SlideTransition(position: slide, child: child),
        ],
      );
    },
  );
}
