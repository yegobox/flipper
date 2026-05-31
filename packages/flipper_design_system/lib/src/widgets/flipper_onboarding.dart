import 'package:flipper_design_system/src/tokens/flipper_colors.dart';
import 'package:flipper_design_system/src/tokens/flipper_radii.dart';
import 'package:flutter/material.dart';

class FlipperBrandBadge extends StatelessWidget {
  final double size;
  final IconData icon;

  const FlipperBrandBadge({
    super.key,
    this.size = 46,
    this.icon = Icons.storefront_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF22D3EE), Color(0xFF2563EB), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * .3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: .28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size * .52),
    );
  }
}

class FlipperRewardChip extends StatelessWidget {
  final int points;
  final String suffix;

  const FlipperRewardChip({
    super.key,
    required this.points,
    this.suffix = 'XP',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3DC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFD79A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, color: Color(0xFFFB9D00), size: 16),
          const SizedBox(width: 4),
          Text(
            '$points $suffix',
            style: const TextStyle(
              color: Color(0xFF8A5300),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class FlipperOnboardingPanel extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  const FlipperOnboardingPanel({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: FlipperColors.surface,
        borderRadius: Corners.s16Border,
        border: Border.all(color: const Color(0xFFE6ECF5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF102040).withValues(alpha: .08),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class FlipperProgressRewardCard extends StatelessWidget {
  final double progress;
  final int points;
  final int maxPoints;
  final String title;

  const FlipperProgressRewardCard({
    super.key,
    required this.progress,
    required this.points,
    this.maxPoints = 100,
    this.title = 'Finish setup to unlock welcome points',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF7E8), Color(0xFFEAF1FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: Corners.s16Border,
        border: Border.all(color: const Color(0xFFE6ECF5)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFC24B), Color(0xFFFB9D00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: Corners.s12Border,
            ),
            child: const Icon(Icons.card_giftcard_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0B1220),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0, 1),
                    minHeight: 7,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$points/$maxPoints',
            style: const TextStyle(
              color: Color(0xFF8A5300),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class FlipperGradientButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final bool isLoading;
  final VoidCallback? onPressed;

  const FlipperGradientButton({
    super.key,
    required this.text,
    this.icon,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  State<FlipperGradientButton> createState() => _FlipperGradientButtonState();
}

class _FlipperGradientButtonState extends State<FlipperGradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return Listener(
      onPointerDown: isEnabled
          ? (_) => setState(() => _isPressed = true)
          : null,
      onPointerUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onPointerCancel: isEnabled
          ? (_) => setState(() => _isPressed = false)
          : null,
      child: AnimatedScale(
        scale: _isPressed ? .975 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: isEnabled
                  ? const LinearGradient(
                      colors: [Color(0xFF6555F4), Color(0xFF4338CA)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : null,
              color: isEnabled ? null : const Color(0xFFD6DEEA),
              borderRadius: Corners.s12Border,
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: .34),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : null,
            ),
            child: TextButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: Corners.s12Border,
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (widget.icon != null) ...[
                          const SizedBox(width: 8),
                          Icon(widget.icon, color: Colors.white, size: 20),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
