import 'dart:math' as math;
import 'dart:ui';

import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_line_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Gates hero floats / band visuals (handoff `showDeviceMocks`, default true).
bool booksHomeShowDeviceMocks = true;

class BooksHomeSection extends StatelessWidget {
  const BooksHomeSection({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gutter = booksHomeGutter(constraints.maxWidth);
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSpace.maxW),
            child: Padding(
              padding: padding ??
                  EdgeInsets.symmetric(
                    horizontal: gutter,
                    vertical: AppSpace.sectionY,
                  ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class FlipperMarkLogo extends StatelessWidget {
  const FlipperMarkLogo({super.key, this.size = 30});

  final double size;

  static const _asset = 'assets/svg/flipper_mark.svg';

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(_asset, width: size, height: size);
  }
}

class BooksTag extends StatelessWidget {
  const BooksTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.cyan.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.25)),
      ),
      child: Text(
        'BOOKS',
        style: AppText.small.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.cyan,
          letterSpacing: 1.32,
        ),
      ),
    );
  }
}

class BooksWordmark extends StatelessWidget {
  const BooksWordmark({super.key, this.logoSize = 30, this.compact = false});

  final double logoSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final labelRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Flipper',
          style: AppText.h3.copyWith(
            fontSize: 21,
            letterSpacing: -0.42,
          ),
        ),
        if (!compact) ...[
          const SizedBox(width: 8),
          const BooksTag(),
        ],
      ],
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlipperMarkLogo(size: logoSize),
          const SizedBox(width: 11),
          labelRow,
        ],
      ),
    );
  }
}

class HeroTopBadge extends StatelessWidget {
  const HeroTopBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 13, 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.line2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGrad.brand,
            ),
          ),
          const SizedBox(width: 8),
          Text.rich(
            TextSpan(
              style: AppText.small.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.ink2),
              children: const [
                TextSpan(text: 'Flipper Books · powered by '),
                TextSpan(
                  text: 'Flow AI',
                  style: TextStyle(color: AppColors.ink0, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeroCheckItem extends StatelessWidget {
  const HeroCheckItem(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BooksLineIcon(BooksIcon.check, size: 15, color: AppColors.green),
        const SizedBox(width: 7),
        Text(label, style: AppText.small.copyWith(fontSize: 13, color: AppColors.ink3)),
      ],
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(this.text, {super.key, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (r) => AppGrad.brand.createShader(r),
      blendMode: BlendMode.srcIn,
      child: Text(text, style: style),
    );
  }
}

class NavTextLink extends StatelessWidget {
  const NavTextLink({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Text(
        label,
        style: AppText.small.copyWith(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          color: AppColors.ink2,
        ),
      ),
    );
  }
}

class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  bool _shown = false;
  late final Key _detectorKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkInitialVisibility());
  }

  void _scheduleShow() {
    if (_shown || !mounted) return;
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _shown = true);
    });
  }

  void _checkInitialVisibility() {
    if (_shown || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.height <= 0) return;

    final topLeft = box.localToGlobal(Offset.zero);
    final bottom = topLeft.dy + box.size.height;
    final viewportHeight = MediaQuery.sizeOf(context).height;

    final visibleTop = topLeft.dy.clamp(0.0, viewportHeight);
    final visibleBottom = bottom.clamp(0.0, viewportHeight);
    final visibleHeight = (visibleBottom - visibleTop).clamp(0.0, box.size.height);

    if (visibleHeight / box.size.height >= 0.12) {
      _scheduleShow();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;

    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: (info) {
        if (!_shown && info.visibleFraction > 0.12) {
          _scheduleShow();
        }
      },
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 700),
        curve: AppCurves.reveal,
        offset: _shown ? Offset.zero : const Offset(0, 0.14),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 700),
          curve: AppCurves.reveal,
          opacity: _shown ? 1 : 0,
          child: widget.child,
        ),
      ),
    );
  }
}

class Floaty extends StatefulWidget {
  const Floaty({
    super.key,
    required this.child,
    this.amplitude = 12,
    this.period = const Duration(seconds: 5),
    this.phase = 0,
  });

  final Widget child;
  final double amplitude;
  final Duration period;
  final double phase;

  @override
  State<Floaty> createState() => _FloatyState();
}

class _FloatyState extends State<Floaty> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _visible = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period);
  }

  void _setVisible(bool visible) {
    if (_disposed || !mounted) return;
    if (_visible == visible) return;
    _visible = visible;
    if (visible) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;

    return VisibilityDetector(
      key: Key('floaty_${widget.key ?? widget.child.runtimeType}'),
      onVisibilityChanged: (info) => _setVisible(info.visibleFraction > 0.04),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          final t = Curves.easeInOut.transform(
            (_controller.value + widget.phase) % 1.0,
          );
          return Transform.translate(
            offset: Offset(0, -widget.amplitude * math.sin(t * math.pi)),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class PressScale extends StatefulWidget {
  const PressScale({
    super.key,
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTap: () {
          setState(() => _down = false);
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _down ? 0.99 : 1,
          duration: const Duration(milliseconds: 150),
          curve: AppCurves.press,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: AppCurves.press,
            transform: Matrix4.translationValues(0, _down ? 1 : 0, 0),
            transformAlignment: Alignment.center,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class HoverLiftCard extends StatefulWidget {
  const HoverLiftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(26),
    this.radius = AppSpace.rMd,
    this.baseBorder,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? baseBorder;

  @override
  State<HoverLiftCard> createState() => _HoverLiftCardState();
}

class _HoverLiftCardState extends State<HoverLiftCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
        transform: Matrix4.translationValues(0, _hover ? -3 : 0, 0),
        padding: widget.padding,
        decoration: BoxDecoration(
          gradient: AppGrad.pricingCardFill,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(
            color: _hover ? AppColors.line2 : (widget.baseBorder ?? AppColors.line),
          ),
          boxShadow: _hover ? AppShadow.card : null,
        ),
        child: widget.child,
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        gradient: AppGrad.glassCard,
        border: Border.all(color: AppColors.line2),
        borderRadius: BorderRadius.circular(AppSpace.rLg),
        boxShadow: AppShadow.card,
      ),
      child: child,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = AppText.buttonHeightHero,
    this.compact = false,
    this.showArrow = false,
  });

  final String label;
  final VoidCallback onTap;
  final double height;
  final bool compact;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final padX = compact ? AppText.buttonPadXSm : AppText.buttonPadX;
    final fontSize = compact ? 14.5 : 15.5;

    return PressScale(
      onTap: onTap,
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: padX),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: AppGrad.button,
          borderRadius: BorderRadius.circular(999),
          boxShadow: AppShadow.violetGlow,
        ),
        // CSS .btn-primary uses an inset top highlight (rgba(255,255,255,.28)),
        // not a full outline. Flutter has no inset shadow, so approximate the
        // 1px top sheen with a faint top-fading overlay.
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.28),
              Colors.white.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.06],
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppText.buttonLabel.copyWith(fontSize: fontSize, color: AppColors.ink0),
            ),
            if (showArrow) ...[
              const SizedBox(width: 9),
              BooksLineIcon(
                BooksIcon.arrowRight,
                size: compact ? 16 : 18,
                color: AppColors.ink0,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = AppText.buttonHeightHero,
    this.compact = false,
    this.showArrow = false,
  });

  final String label;
  final VoidCallback onTap;
  final double height;
  final bool compact;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    final padX = compact ? AppText.buttonPadXSm : AppText.buttonPadX;
    final fontSize = compact ? 14.5 : 15.5;

    return PressScale(
      onTap: onTap,
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: padX),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.line2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppText.buttonLabel.copyWith(fontSize: fontSize, color: AppColors.ink1),
            ),
            if (showArrow) ...[
              const SizedBox(width: 9),
              BooksLineIcon(
                BooksIcon.arrowRight,
                size: compact ? 16 : 18,
                color: AppColors.ink1,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class WhiteButton extends StatelessWidget {
  const WhiteButton({
    super.key,
    required this.label,
    required this.onTap,
    this.showArrow = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        height: AppText.buttonHeightHero,
        padding: const EdgeInsets.symmetric(horizontal: AppText.buttonPadX),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.ink0,
          borderRadius: BorderRadius.circular(999),
          boxShadow: AppShadow.whiteCard,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppText.buttonLabel.copyWith(
                fontSize: 15.5,
                color: AppColors.whiteButtonText,
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: 9),
              const BooksLineIcon(
                BooksIcon.arrowRight,
                size: 18,
                color: AppColors.whiteButtonText,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class OutlineWhiteButton extends StatelessWidget {
  const OutlineWhiteButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        height: AppText.buttonHeightHero,
        padding: const EdgeInsets.symmetric(horizontal: AppText.buttonPadX),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        ),
        child: Text(
          label,
          style: AppText.buttonLabel.copyWith(
            fontSize: 15.5,
            color: AppColors.ink0,
          ),
        ),
      ),
    );
  }
}

class TrustChip extends StatelessWidget {
  const TrustChip({
    super.key,
    required this.icon,
    this.bold,
    required this.label,
  });

  final BooksIcon icon;
  final String? bold;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BooksLineIcon(icon, size: 17, color: AppColors.cyan),
          const SizedBox(width: 9),
          Text.rich(
            TextSpan(
              style: AppText.small.copyWith(fontSize: 13.5, color: AppColors.ink2),
              children: [
                if (bold != null && bold!.isNotEmpty) ...[
                  TextSpan(
                    text: bold,
                    style: const TextStyle(
                      color: AppColors.ink0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(text: ' '),
                ],
                TextSpan(text: label),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MostPopularTag extends StatelessWidget {
  const MostPopularTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('★', style: TextStyle(fontSize: 11.5, color: AppColors.popularTagInk)),
          const SizedBox(width: 4),
          Text(
            'Most Popular',
            style: AppText.small.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.popularTagInk,
            ),
          ),
        ],
      ),
    );
  }
}

/// Centered section header — mirrors `.sec-head` from the handoff CSS:
/// the whole block is capped at 680px (so the H2 wraps to balanced lines),
/// the eyebrow→H2 gap is 16, the H2→body gap is 18, the body is 17px capped
/// at 560px, and 56px of space follows before the section content.
class SectionHead extends StatelessWidget {
  const SectionHead({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.body,
  });

  final String eyebrow;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: Column(
        children: [
          EyebrowLabel(eyebrow),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppText.h2(booksHomeH2SizeOf(context)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              body,
              style: AppText.lead.copyWith(fontSize: 17),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class EyebrowLabel extends StatelessWidget {
  const EyebrowLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppGrad.brand,
            boxShadow: [
              BoxShadow(
                color: AppColors.blue.withValues(alpha: 0.8),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        const SizedBox(width: 9),
        Text(text.toUpperCase(), style: AppText.eyebrow.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

/// Hero section backdrop — 64px grid + three radial glows (handoff `.hero-bg`).
class HeroBackground extends StatelessWidget {
  const HeroBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          top: -240,
          left: 0,
          right: 0,
          child: Center(
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 1100,
                  height: 700,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppColors.blue.withValues(alpha: 0.30),
                        Colors.transparent,
                      ],
                      stops: const [0, 0.7],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 60,
          right: -180,
          child: IgnorePointer(
            child: Container(
              width: 620,
              height: 620,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.cyan.withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.7],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -200,
          left: -160,
          child: IgnorePointer(
            child: Container(
              width: 560,
              height: 560,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.violet.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.7],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: ShaderMask(
              shaderCallback: (rect) => RadialGradient(
                center: const Alignment(0, -0.4),
                radius: 0.85,
                colors: const [Colors.black, Colors.transparent],
                stops: const [0, 0.75],
              ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: CustomPaint(painter: _HeroGridPainter()),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _HeroGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;
    for (var x = 0.0; x <= size.width; x += 64) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += 64) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedOutlineContainer extends StatelessWidget {
  const DashedOutlineContainer({
    super.key,
    required this.child,
    this.radius = 999,
    this.color,
    this.padding,
  });

  final Widget child;
  final double radius;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRRectPainter(
        radius: radius,
        color: color ?? AppColors.line2,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({required this.radius, required this.color});

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + 6).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}

class StickyHeaderShell extends StatelessWidget {
  const StickyHeaderShell({
    super.key,
    required this.scrolled,
    required this.child,
  });

  final bool scrolled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.ease,
        decoration: BoxDecoration(
          color: scrolled
              ? AppColors.bg.withValues(alpha: 0.72)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: scrolled ? AppColors.line : Colors.transparent,
            ),
          ),
        ),
        child: scrolled
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: child,
              )
            : child,
      ),
    );
  }
}
