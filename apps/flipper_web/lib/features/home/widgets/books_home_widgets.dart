import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_line_icon.dart';
import 'package:flipper_web/widgets/flipper_logo.dart';
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

class FlipperMarkLogo extends StatelessWidget {
  const FlipperMarkLogo({super.key, this.size = 30});

  final double size;

  @override
  Widget build(BuildContext context) {
    return FlipperLogo(size: size);
  }
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
          FlipperMarkLogo(size: logoSize),
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
            label.toUpperCase(),
            style: AppText.label(size: 11.5, c: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (arrow) ...[
          const SizedBox(width: 10),
          Text('→', style: AppText.label(size: 14, c: color)),
        ],
      ],
    );
  }
}

/// Filled, square, mono-caps button in the inverted colour. Dims on hover.
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
  final VoidCallback onTap;
  final double height;
  final bool arrow;

  /// Set when the button sits on an [AppColors.invertBg] block.
  final bool onInverse;

  @override
  Widget build(BuildContext context) {
    final fill = onInverse ? AppColors.bg : AppColors.invertBg;
    final fg = onInverse ? AppColors.ink : AppColors.invertFg;
    return PressScale(
      onTap: onTap,
      child: HoverBuilder(
        builder: (context, hover) => AnimatedOpacity(
          opacity: hover ? 0.82 : 1,
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            color: fill,
            // Sized to the label unless the parent forces a width.
            child: Center(
              widthFactor: 1,
              child: _ButtonLabel(label, color: fg, arrow: arrow),
            ),
          ),
        ),
      ),
    );
  }
}

/// Hairline, square, mono-caps button that fills with the inverted colour on
/// hover.
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

  /// Set when the button sits on an [AppColors.invertBg] block.
  final bool onInverse;

  @override
  Widget build(BuildContext context) {
    final rest = onInverse
        ? AppColors.invertFg.withValues(alpha: 0.4)
        : AppColors.lineStrong;
    final fill = onInverse ? AppColors.invertFg : AppColors.invertBg;
    final fg = onInverse ? AppColors.invertFg : AppColors.ink;
    final fgHover = onInverse ? AppColors.invertBg : AppColors.invertFg;
    return PressScale(
      onTap: onTap,
      child: HoverBuilder(
        builder: (context, hover) => AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: hover ? fill : fill.withAlpha(0),
            border: Border.all(color: hover ? fill : rest),
          ),
          child: Center(
            widthFactor: 1,
            child: _ButtonLabel(
              label,
              color: hover ? fgHover : fg,
              arrow: arrow,
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: AppColors.accent,
      child: Text(
        '★ ${booksHomeL10n(context).webHomeMostPopular.toUpperCase()}',
        style: AppText.label(size: 10, c: AppColors.onAccent),
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

/// The pinned header's surface: solid paper, with a rule once the page has
/// scrolled under it.
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.ease,
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border(
          bottom: BorderSide(
            color: scrolled ? AppColors.lineStrong : AppColors.bg,
          ),
        ),
      ),
      child: child,
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
