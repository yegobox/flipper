import 'package:flipper_dashboard/theme/mpos_motion.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Customer-attached toast ([ANIMATIONS.md] §2 `mpToast`).
class MposToast {
  static OverlayEntry? _entry;

  static void show(
    BuildContext context, {
    required String message,
  }) {
    dismiss();

    final reduced = MposMotion.reducedMotion(context);
    final overlay = Overlay.of(context);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _MposToastWidget(
        message: message,
        reducedMotion: reduced,
        onDismissed: () {
          entry.remove();
          if (_entry == entry) _entry = null;
        },
      ),
    );
    _entry = entry;
    overlay.insert(entry);
    HapticFeedback.selectionClick();
  }

  static void dismiss() {
    _entry?.remove();
    _entry = null;
  }
}

class _MposToastWidget extends StatefulWidget {
  const _MposToastWidget({
    required this.message,
    required this.reducedMotion,
    required this.onDismissed,
  });

  final String message;
  final bool reducedMotion;
  final VoidCallback onDismissed;

  @override
  State<_MposToastWidget> createState() => _MposToastWidgetState();
}

class _MposToastWidgetState extends State<_MposToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: MposMotion.toastEnter,
    );
    _opacity = CurvedAnimation(parent: _controller, curve: MposMotion.decelerate);
    _slide = Tween<Offset>(
      begin: widget.reducedMotion ? Offset.zero : const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: MposMotion.decelerate));

    _controller.forward();
    Future<void>.delayed(MposMotion.toastDismiss, () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom + 92;
    return Positioned(
      left: 16,
      right: 16,
      bottom: bottom,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _opacity,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              decoration: BoxDecoration(
                color: PosTokens.ink1,
                borderRadius: BorderRadius.circular(MposTokens.radiusMd),
                boxShadow: PosTokens.shadow2,
              ),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: Color(0xFF16A34A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
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
