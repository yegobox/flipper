import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_line_icon.dart';
import 'package:flutter/material.dart';
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

/// Flipper's ring mark — the logo at the top of the mobile app
/// (`assets/icons/flipper-logo.svg`) — painted from the same geometry so it
/// can draw itself in: [progress] runs each ring from its top end around.
class FlipperMark extends StatelessWidget {
  const FlipperMark({super.key, this.size = 28, this.color, this.progress = 1});

  final double size;

  /// Flat colour instead of the logo's gradient.
  final Color? color;

  /// 0 draws nothing, 1 the whole mark.
  final double progress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _FlipperMarkPainter(progress: progress, color: color),
    );
  }
}

class _FlipperMarkPainter extends CustomPainter {
  _FlipperMarkPainter({required this.progress, this.color});

  final double progress;
  final Color? color;

  // flipper-logo.svg, in its 48-unit box: an outer ring open at the top left
  // and a fainter inner ring open at the top right, both with round caps.
  static const _box = 48.0;
  static const _centre = Offset(24, 24);
  static const _outerR = 16.5;
  static const _outerStroke = 8.16;
  static const _outerSweep = 5.5021; // top, clockwise, to (12.4, 12.3)
  static const _innerR = 7.5;
  static const _innerStroke = 6.36;
  static const _innerSweep = -5.4978; // top, anticlockwise, to (29.3, 18.7)
  static const _innerOpacity = 0.55;
  static const _gradient = [
    Color(0xFF22D3EE),
    Color(0xFF2563EB),
    Color(0xFF4F46E5),
  ];

  /// The visible ring, outer stroke edge to edge, as a share of the box.
  static const visibleShare = 2 * (_outerR + _outerStroke / 2) / _box;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _box;
    canvas.scale(scale);

    final outer = Curves.easeInOutCubic.transform(
      (progress / 0.8).clamp(0.0, 1.0),
    );
    final inner = Curves.easeInOutCubic.transform(
      ((progress - 0.3) / 0.7).clamp(0.0, 1.0),
    );

    Paint stroke(double width, double opacity) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round;
      if (color != null) {
        paint.color = color!.withValues(alpha: color!.a * opacity);
      } else {
        paint
          ..color = Color.fromRGBO(0, 0, 0, opacity)
          ..shader = LinearGradient(colors: _gradient, stops: const [0, 0.5, 1])
              .createShader(
                Rect.fromPoints(const Offset(6, 8), const Offset(42, 40)),
              );
      }
      return paint;
    }

    void ring(double r, double sweep, double t, Paint paint) {
      if (t <= 0) return;
      final path = Path()
        ..addArc(Rect.fromCircle(center: _centre, radius: r), -1.5708, sweep);
      if (t >= 1) {
        canvas.drawPath(path, paint);
        return;
      }
      for (final metric in path.computeMetrics()) {
        canvas.drawPath(metric.extractPath(0, metric.length * t), paint);
      }
    }

    ring(_innerR, _innerSweep, inner, stroke(_innerStroke, _innerOpacity));
    ring(_outerR, _outerSweep, outer, stroke(_outerStroke, 1));
  }

  @override
  bool shouldRepaint(_FlipperMarkPainter old) =>
      old.progress != progress || old.color != color;
}

/// The mark drawing itself in, over and over: the loading state.
class FlipperMarkLoader extends StatefulWidget {
  const FlipperMarkLoader({super.key, this.size = 56});

  final double size;

  @override
  State<FlipperMarkLoader> createState() => _FlipperMarkLoaderState();
}

class _FlipperMarkLoaderState extends State<FlipperMarkLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      // Draw in over the first 70%, hold, start again.
      builder: (context, _) => FlipperMark(
        size: widget.size,
        progress: (_controller.value / 0.7).clamp(0.0, 1.0),
      ),
    );
  }
}

/// The product name as a poster, with Flipper's mark as its first glyph —
/// getartcraft.com's wordmark intro, on its timings.
///
/// The ring draws itself in alone at the centre. From 0.4s, over 0.85s, it
/// glides to its slot (ease in-out) while the letters shoot out from behind
/// it (ease out), clipped at its right edge so they never show beside it.
/// Under reduced motion it starts formed.
class UnfoldingWordmark extends StatefulWidget {
  const UnfoldingWordmark({super.key, this.text = 'FLIPPER', this.color});

  final String text;

  /// Letter colour; the ring keeps its gradient.
  final Color? color;

  @override
  State<UnfoldingWordmark> createState() => _UnfoldingWordmarkState();
}

class _UnfoldingWordmarkState extends State<UnfoldingWordmark>
    with SingleTickerProviderStateMixin {
  // Laid out at this size, then scaled to the available width.
  static const _fontSize = 200.0;

  // As Artcraft tunes theirs, in ems: cap height the ring matches, the gap
  // after it, and how far the word starts tucked behind it.
  static const _cap = 0.7;
  static const _pad = 0.05;
  static const _tuck = 0.12;

  // Seconds.
  static const _drawFor = 0.45;
  static const _wordAt = 0.4;
  static const _wordFor = 0.85;
  static const _total = _wordAt + _wordFor;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1250),
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
    final style = TextStyle(
      fontFamily: 'Archivo Expanded',
      fontFamilyFallback: const ['Archivo', 'Inter', 'sans-serif'],
      fontSize: _fontSize,
      fontWeight: FontWeight.w700,
      height: 1,
      letterSpacing: -0.01 * _fontSize,
      color: widget.color ?? AppColors.ink,
    );
    final word = TextPainter(
      text: TextSpan(text: widget.text, style: style),
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
    )..layout();
    final baseline = word.computeDistanceToActualBaseline(
      TextBaseline.alphabetic,
    );

    // The ring's box is bigger than the ring: size it so the visible ring is
    // cap-high, and measure gaps from the visible edge.
    final ring = _cap * _fontSize;
    final box = ring / _FlipperMarkPainter.visibleShare;
    final inset = (box - ring) / 2;
    final markTop = baseline - ring / 2 - _cap * _fontSize / 2 - inset;
    final lettersAt = box - inset + _pad * _fontSize;
    final width = lettersAt + word.width;
    final height = word.height;
    final homeX = (width - box) / 2;

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
                final s = _controller.value * _total;
                final draw = (s / _drawFor).clamp(0.0, 1.0);
                final w = ((s - _wordAt) / _wordFor).clamp(0.0, 1.0);
                final glide = Curves.easeInOutCubic.transform(w);
                final out = Curves.easeOutCubic.transform(w);

                final markX = homeX * (1 - glide);
                // Start with the word's right end on the ring's (final)
                // right edge, tucked a little further in.
                final from =
                    -(word.width + _pad * _fontSize + _tuck * _fontSize);
                final lettersX = lettersAt + from * (1 - out);
                final edge = markX + box - inset;
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
                      child: FlipperMark(size: box, progress: draw),
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
