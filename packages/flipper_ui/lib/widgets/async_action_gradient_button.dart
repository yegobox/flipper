import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const LinearGradient _kPrimaryGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF2C6BF0), Color(0xFF1D4ED8)],
);

const List<BoxShadow> _kPrimaryShadow = [
  BoxShadow(
    color: Color(0x402563EB),
    offset: Offset(0, 8),
    blurRadius: 20,
    spreadRadius: -4,
  ),
];

/// Gradient CTA that shows a spinner on the **same frame** as tap, then runs
/// [onPressed] after the next frame is painted (avoids macOS busy cursor flash).
class AsyncActionGradientButton extends StatefulWidget {
  const AsyncActionGradientButton({
    super.key,
    required this.idleLabel,
    required this.loadingLabel,
    required this.icon,
    required this.onPressed,
    this.syncNotifier,
    this.canStart,
  });

  final String idleLabel;
  final String loadingLabel;
  final IconData icon;
  final Future<void> Function()? onPressed;

  /// When set, called **before** loading UI; return false to abort (e.g. form invalid).
  final bool Function()? canStart;

  /// Optional footer chrome (progress bar) driven by the same loading flag.
  final ValueNotifier<bool>? syncNotifier;

  @override
  State<AsyncActionGradientButton> createState() =>
      _AsyncActionGradientButtonState();
}

class _AsyncActionGradientButtonState extends State<AsyncActionGradientButton> {
  bool _loading = false;

  Future<void> _paintLoadingChrome() async {
    await WidgetsBinding.instance.endOfFrame;
    await Future<void>.delayed(Duration.zero);
    await WidgetsBinding.instance.endOfFrame;
  }

  Future<void> _handleTap() async {
    if (_loading || widget.onPressed == null) return;
    if (widget.canStart != null && !widget.canStart!()) return;

    setState(() => _loading = true);
    widget.syncNotifier?.value = true;

    await _paintLoadingChrome();
    if (!mounted) {
      _resetLoading();
      return;
    }

    try {
      await widget.onPressed!();
    } finally {
      if (mounted) _resetLoading();
    }
  }

  void _resetLoading() {
    setState(() => _loading = false);
    widget.syncNotifier?.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final loading = _loading;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: _kPrimaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _kPrimaryShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: loading ? null : _handleTap,
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                else
                  Icon(widget.icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  loading ? widget.loadingLabel : widget.idleLabel,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.white,
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
