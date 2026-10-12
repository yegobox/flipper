import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_line_icon.dart';
import 'package:flipper_web/widgets/flipper_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BooksHomeSection extends StatelessWidget {
  const BooksHomeSection({super.key, required this.child, this.padding});

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
              padding:
                  padding ??
                  EdgeInsets.symmetric(
                    horizontal: gutter,
                    vertical: AppSpace.sectionY / 2,
                  ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Flipper's arc mark — the logo at the top of the mobile app — in its blue
/// gradient, or flat in [color] when one is given.
class FlipperMark extends StatelessWidget {
  const FlipperMark({super.key, this.size = 28, this.color});

  static const assetPath = 'assets/svg/flipper_arcs.svg';

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final glyph = SvgPicture.asset(
      assetPath,
      package: FlipperLogo.package,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color ?? AppGrad.onPanel, BlendMode.srcIn),
      excludeFromSemantics: true,
    );
    if (color != null) return glyph;
    // Untinted, it wears its own blue gradient, as in the mobile app.
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: AppGrad.mark.createShader,
      child: glyph,
    );
  }
}

/// The product name as a poster, with Flipper's mark as its first glyph.
///
/// On first paint the mark fades in alone at the centre, then the letters
/// slide out from behind it while it moves to the left: the word unfolds out
/// of the logo. Under reduced motion it starts in its final state.
class UnfoldingWordmark extends StatefulWidget {
  const UnfoldingWordmark({
    super.key,
    this.text = 'FLIPPER',
    this.color,
    this.duration = const Duration(milliseconds: 1700),
  });

  final String text;
  final Color? color;
  final Duration duration;

  @override
  State<UnfoldingWordmark> createState() => _UnfoldingWordmarkState();
}

class _UnfoldingWordmarkState extends State<UnfoldingWordmark>
    with SingleTickerProviderStateMixin {
  // Laid out at this size, then scaled to the available width.
  static const _fontSize = 200.0;

  // Archivo's cap height, as a share of the font size.
  static const _capHeight = 0.71;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.ink;
    final style = AppText.display(
      _fontSize,
      c: color,
    ).copyWith(height: 1, letterSpacing: -0.03 * _fontSize);
    final word = TextPainter(
      text: TextSpan(text: widget.text, style: style),
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
    )..layout();
    final baseline = word.computeDistanceToActualBaseline(
      TextBaseline.alphabetic,
    );
    final cap = _capHeight * _fontSize;
    final markSize = cap * 1.08;
    final markTop = baseline - cap - (markSize - cap) / 2;
    final gap = _fontSize * 0.1;
    final width = markSize + gap + word.width;
    final height = word.height;

    return Semantics(
      label: widget.text,
      child: ExcludeSemantics(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: SizedBox(
            width: width,
            height: height,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = _controller.value;
                final appear = Curves.easeOut.transform((t / 0.3).clamp(0, 1));
                final unfold = Curves.easeInOutCubic.transform(
                  ((t - 0.3) / 0.7).clamp(0, 1),
                );
                final markX = (width - markSize) / 2 * (1 - unfold);
                // Letters start tucked under the mark, their right edge on
                // its right edge, and are only drawn to the right of it.
                final start = markX + markSize - word.width;
                final lettersX = start + (markSize + gap - start) * unfold;
                final edge = markX + markSize + gap / 2;
                return Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRect(
                        clipper: _RightOf(edge),
                        child: Stack(
                          children: [
                            Positioned(
                              left: lettersX,
                              top: 0,
                              child: Text(
                                widget.text,
                                style: style,
                                maxLines: 1,
                                softWrap: false,
                                textScaler: TextScaler.noScaling,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: markX,
                      top: markTop,
                      child: Opacity(
                        opacity: appear,
                        child: FlipperMark(size: markSize, color: widget.color),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _RightOf extends CustomClipper<Rect> {
  const _RightOf(this.left);

  final double left;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(left.clamp(0, size.width), 0, size.width, size.height);

  @override
  bool shouldReclip(_RightOf oldClipper) => oldClipper.left != left;
}

class BooksWordmark extends StatelessWidget {
  const BooksWordmark({super.key, this.logoSize = 28, this.compact = false});

  final double logoSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlipperMark(size: logoSize),
          const SizedBox(width: 10),
          Text(
            'Flipper',
            style: AppText.title(
              21,
            ).copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.7),
          ),
          if (!compact) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lineStrong),
              ),
              child: Text(
                'BOOKS',
                style: AppText.label(size: 10, c: AppColors.ink),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Rebuilds [builder] with whether a mouse is over it.
class HoverBuilder extends StatefulWidget {
  const HoverBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, bool hover) builder;

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: widget.builder(context, _hover),
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
      child: HoverBuilder(
        builder: (context, hover) => Text(
          label.toUpperCase(),
          style: AppText.label(
            size: 11.5,
            c: hover ? AppColors.ink : AppColors.muted,
          ),
        ),
      ),
    );
  }
}

/// A headline in heavy sans with one serif-italic phrase:
/// "Three apps. One ledger. *Zero double-entry.*"
class EditorialHeadline extends StatelessWidget {
  const EditorialHeadline({
    super.key,
    required this.lead,
    required this.accent,
    required this.size,
    this.accentOnNewLine = false,
    this.textAlign = TextAlign.start,
    this.color,
  });

  final String lead;
  final String accent;
  final double size;
  final bool accentOnNewLine;
  final TextAlign textAlign;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final display = AppText.display(size, c: color);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: lead, style: display),
          TextSpan(text: accentOnNewLine ? '\n' : ' ', style: display),
          TextSpan(
            text: accent,
            style: AppText.accent(size, c: color),
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}

/// `01 / PLATFORM` over a full-width rule — the head of every section.
class SectionIndex extends StatelessWidget {
  const SectionIndex({
    super.key,
    required this.number,
    required this.label,
    this.trailing,
  });

  final String number;
  final String label;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.lineStrong)),
      ),
      child: Row(
        children: [
          Text(number, style: AppText.label(c: AppColors.ink)),
          Text('  /  ', style: AppText.label(c: AppColors.faint)),
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: AppText.label(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Both halves expand so the trailing label sits on the right edge.
          if (trailing != null)
            Expanded(
              child: Text(
                trailing!.toUpperCase(),
                style: AppText.label(c: AppColors.faint),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
        ],
      ),
    );
  }
}

/// A full-bleed `▪ item ▪ item` band that scrolls sideways forever.
///
/// It holds still when the platform asks for reduced motion, and only ticks
/// while on screen.
class MarqueeTicker extends StatefulWidget {
  const MarqueeTicker({
    super.key,
    required this.items,
    this.height = 68,
    this.loop = const Duration(seconds: 40),
  });

  final List<String> items;
  final double height;

  /// Time for one full copy of [items] to pass.
  final Duration loop;

  @override
  State<MarqueeTicker> createState() => _MarqueeTickerState();
}

class _MarqueeTickerState extends State<MarqueeTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.loop,
  );
  late final Key _detectorKey = UniqueKey();
  bool _visible = false;
  bool _still = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _still = MediaQuery.disableAnimationsOf(context);
    _sync();
  }

  void _sync() {
    final run = _visible && !_still;
    if (run && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!run && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _copy() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final item in widget.items) ...[
        Container(width: 8, height: 8, color: AppColors.accent),
        const SizedBox(width: 18),
        Text(
          item,
          style: AppText.title(22).copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          softWrap: false,
        ),
        const SizedBox(width: 44),
      ],
    ],
  );

  @override
  Widget build(BuildContext context) {
    // Three copies so a single copy narrower than the viewport still fills it
    // while the first one slides out.
    final runs = Flow(
      delegate: _MarqueeDelegate(_controller),
      children: [_copy(), _copy(), _copy()],
    );

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.lineStrong),
        ),
      ),
      child: ClipRect(
        child: _still
            ? runs
            : VisibilityDetector(
                key: _detectorKey,
                onVisibilityChanged: (info) {
                  if (!mounted) return;
                  _visible = info.visibleFraction > 0;
                  _sync();
                },
                child: RepaintBoundary(child: runs),
              ),
      ),
    );
  }
}

class _MarqueeDelegate extends FlowDelegate {
  _MarqueeDelegate(this.progress) : super(repaint: progress);

  final Animation<double> progress;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) =>
      BoxConstraints(maxHeight: constraints.maxHeight);

  @override
  void paintChildren(FlowPaintingContext context) {
    final width = context.getChildSize(0)?.width ?? 0;
    if (width == 0) return;
    final dx = -progress.value * width;
    for (var i = 0; i < context.childCount; i++) {
      final h = context.getChildSize(i)!.height;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          dx + i * width,
          (context.size.height - h) / 2,
          0,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(_MarqueeDelegate oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Cells laid out in rows of [columns] that share their hairlines: the grid
/// draws the outer top and left edge, each cell its own right and bottom, so
/// no rule is ever doubled. Every cell in a row takes the tallest one's height.
class RuledGrid extends StatelessWidget {
  const RuledGrid({
    super.key,
    required this.columns,
    required this.children,
    this.color,
  });

  final int columns;
  final List<Widget> children;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final side = BorderSide(color: color ?? AppColors.lineStrong);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: side, left: side),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var start = 0; start < children.length; start += columns)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = start; i < start + columns; i++)
                    Expanded(
                      child: DecoratedBox(
                        // Foreground, so a filled cell cannot paint over it.
                        position: DecorationPosition.foreground,
                        decoration: BoxDecoration(
                          border: Border(right: side, bottom: side),
                        ),
                        child: i < children.length
                            ? children[i]
                            : const SizedBox.shrink(),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// One numbered cell of a [RuledGrid]: a tag or icon top-left, its number
/// top-right, then a title and body. Inverts on hover.
class IndexCell extends StatelessWidget {
  const IndexCell({
    super.key,
    required this.number,
    required this.title,
    required this.body,
    this.tag,
    this.icon,
    this.subtitle,
  });

  final String number;
  final String title;
  final String body;
  final String? tag;
  final BooksIcon? icon;

  /// A serif-italic line under [title].
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return HoverBuilder(
      builder: (context, hover) {
        final fg = hover ? AppColors.invertFg : AppColors.ink;
        final soft = hover
            ? AppColors.invertFg.withValues(alpha: 0.7)
            : AppColors.muted;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          color: hover ? AppColors.invertBg : AppColors.invertBg.withAlpha(0),
          padding: const EdgeInsets.fromLTRB(26, 22, 26, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null)
                    BooksLineIcon(icon!, size: 18, color: soft)
                  else if (tag != null)
                    Flexible(
                      child: Text(
                        tag!.toUpperCase(),
                        style: AppText.label(c: soft),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const Spacer(),
                  Text(number, style: AppText.label(c: soft)),
                ],
              ),
              const SizedBox(height: 44),
              Text(title, style: AppText.title(26, c: fg)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: AppText.accent(20, c: soft).copyWith(height: 1.25),
                ),
              ],
              const SizedBox(height: 14),
              Text(
                body,
                style: AppText.body.copyWith(fontSize: 14.5, color: soft),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ButtonLabel extends StatelessWidget {
  const _ButtonLabel(this.label, {required this.color, required this.arrow});

  final String label;
  final Color color;
  final bool arrow;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppText.button(c: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (arrow) ...[
          const SizedBox(width: 8),
          Icon(Icons.arrow_outward_rounded, size: 18, color: color),
        ],
      ],
    );
  }
}

/// The primary button, as on the sign-in screens: the violet gradient, rounded,
/// with its soft shadow. Lifts a little on hover.
class InkButton extends StatelessWidget {
  const InkButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = AppText.buttonHeight,
    this.arrow = false,
    this.onInverse = false,
  });

  final String label;

  /// Null disables the button: it greys out and ignores taps.
  final VoidCallback? onTap;
  final double height;
  final bool arrow;

  /// Set when the button sits on a brand panel: a white button, blue label.
  final bool onInverse;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpace.rButton);
    final fg = onInverse ? AppColors.accentInk : AppGrad.onPanel;
    final onTap = this.onTap;

    Widget body(bool hover) => AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      transform: Matrix4.translationValues(0, hover ? -1 : 0, 0),
      decoration: BoxDecoration(
        gradient: onTap == null || onInverse ? null : AppGrad.button,
        color: onTap == null
            ? AppColors.lineStrong
            : onInverse
            ? AppGrad.onPanel
            : null,
        borderRadius: radius,
        boxShadow: onTap == null || onInverse ? null : AppGrad.buttonShadow,
      ),
      // Sized to the label unless the parent forces a width.
      child: Center(
        widthFactor: 1,
        child: _ButtonLabel(
          label,
          color: onTap == null ? AppColors.faint : fg,
          arrow: arrow,
        ),
      ),
    );

    if (onTap == null) return body(false);
    return PressScale(
      onTap: onTap,
      child: HoverBuilder(builder: (context, hover) => body(hover)),
    );
  }
}

/// The secondary button: hairline and rounded on the page, white-ruled on a
/// brand panel. Fills faintly on hover.
class LineButton extends StatelessWidget {
  const LineButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = AppText.buttonHeight,
    this.arrow = false,
    this.onInverse = false,
  });

  final String label;
  final VoidCallback onTap;
  final double height;
  final bool arrow;

  /// Set when the button sits on a brand panel.
  final bool onInverse;

  @override
  Widget build(BuildContext context) {
    final fg = onInverse ? AppGrad.onPanel : AppColors.ink;
    final rest = onInverse ? AppGrad.onPanelLine : AppColors.lineStrong;
    final fill = onInverse
        ? AppGrad.onPanel.withValues(alpha: 0.12)
        : AppColors.bgRaised;
    return PressScale(
      onTap: onTap,
      child: HoverBuilder(
        builder: (context, hover) => AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: hover ? fill : fill.withAlpha(0),
            borderRadius: BorderRadius.circular(AppSpace.rButton),
            border: Border.all(color: hover && !onInverse ? fg : rest),
          ),
          child: Center(
            widthFactor: 1,
            child: _ButtonLabel(label, color: fg, arrow: arrow),
          ),
        ),
      ),
    );
  }
}

class MostPopularTag extends StatelessWidget {
  const MostPopularTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppGrad.onPanel,
        borderRadius: BorderRadius.circular(AppSpace.rPill),
      ),
      child: Text(
        '★ ${booksHomeL10n(context).webHomeMostPopular.toUpperCase()}',
        style: AppText.label(size: 10, c: AppColors.accentInk),
      ),
    );
  }
}

/// 1px rules every 3px behind [child], like an old monitor.
class ScanlineBackground extends StatelessWidget {
  const ScanlineBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _ScanlinePainter(color: AppColors.scanline),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  _ScanlinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var y = 0.0; y < size.height; y += 3) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScanlinePainter oldDelegate) =>
      oldDelegate.color != color;
}

/// A word set as wide as its parent allows, for the hero backdrop and the
/// footer.
class GiantWord extends StatelessWidget {
  const GiantWord(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
        text,
        maxLines: 1,
        softWrap: false,
        style: AppText.display(200, c: color).copyWith(height: 0.82),
      ),
    );
  }
}

class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child, this.delay = Duration.zero});

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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _checkInitialVisibility(),
    );
  }

  void _scheduleShow() {
    if (_shown || !mounted) return;
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _shown = true);
    });
  }

  void _checkInitialVisibility() {
    // Under reduced motion the child is shown as-is; nothing to schedule.
    if (_shown || !mounted || MediaQuery.disableAnimationsOf(context)) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.height <= 0) return;

    final topLeft = box.localToGlobal(Offset.zero);
    final bottom = topLeft.dy + box.size.height;
    final viewportHeight = MediaQuery.sizeOf(context).height;

    final visibleTop = topLeft.dy.clamp(0.0, viewportHeight);
    final visibleBottom = bottom.clamp(0.0, viewportHeight);
    final visibleHeight = (visibleBottom - visibleTop).clamp(
      0.0,
      box.size.height,
    );

    if (visibleHeight / box.size.height >= 0.12) {
      _scheduleShow();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;

    // A fixed 14px rise, not a fraction of the child: a tall section would
    // otherwise travel a long way.
    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: (info) {
        if (!_shown && info.visibleFraction > 0.12) {
          _scheduleShow();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: AppCurves.reveal,
        transform: Matrix4.translationValues(0, _shown ? 0 : 14, 0),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          curve: AppCurves.reveal,
          opacity: _shown ? 1 : 0,
          child: widget.child,
        ),
      ),
    );
  }
}

class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child, required this.onTap});

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

/// Landing-page strings. Falls back to [FlipperL10n.current] when the page is
/// pumped without localization delegates (some widget tests).
FlipperAppLocalizations booksHomeL10n(BuildContext context) =>
    Localizations.of<FlipperAppLocalizations>(
      context,
      FlipperAppLocalizations,
    ) ??
    FlipperL10n.current;
