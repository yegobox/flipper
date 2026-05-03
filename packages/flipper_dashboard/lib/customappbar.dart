// ignore_for_file: constant_identifier_names

library customappbar;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CLOSEBUTTON { ICON, BUTTON, WIDGET }

/// Matches the Tickets screen app bar: white surface, [GoogleFonts.outfit] title,
/// circular leading control with a light border (see [tickets_screen.dart]).
const Color kCustomAppBarIconCircleBorder = Color(0xFFE0E4EB);

/// Bold “X” with round caps (see close-button reference in product UI spec).
const Color _kCloseIconForeground = Color(0xFF0D0D0D);

bool _useCupertinoStyle(BuildContext context) {
  if (kIsWeb) return false;
  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return true;
    default:
      return false;
  }
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.showActionButton,
    this.title,
    this.icon,
    this.additionalText,
    this.disableButton,
    this.onActionButtonClicked,
    this.onPop,
    this.rightActionButtonName = "Save",
    this.leftActionButtonName = "Save",
    this.closeButton = CLOSEBUTTON.ICON,
    this.useTransparentButton = false,
    this.multi,
    this.bottomSpacer,
    this.customLeadingWidget,
    this.bottomWidget,
    this.customTrailingWidget,
    this.isDividerVisible,
  });

  final String? rightActionButtonName;
  final String? leftActionButtonName;
  final CLOSEBUTTON closeButton;
  final double? bottomSpacer;
  final bool? disableButton;
  final double? multi;
  final IconData? icon;
  final VoidCallback? onPop;
  final VoidCallback? onActionButtonClicked;
  final bool? showActionButton;
  final String? title;
  final bool useTransparentButton;

  final Widget? additionalText;
  final StatelessWidget? customLeadingWidget;
  final StatelessWidget? bottomWidget;
  final StatelessWidget? customTrailingWidget;
  final bool? isDividerVisible;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(80.0 * (multi ?? 1.0));
}

class _CustomAppBarState extends State<CustomAppBar> {
  static const double _horizontalPadding = 8;

  static ButtonStyle _headerCircleIconStyle() {
    return IconButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: _kCloseIconForeground,
      shape: const CircleBorder(),
      side: const BorderSide(
        color: kCustomAppBarIconCircleBorder,
        width: 1,
      ),
      padding: const EdgeInsets.all(9),
      minimumSize: const Size(40, 40),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cupertino = _useCupertinoStyle(context);
    final width = MediaQuery.sizeOf(context).width;
    final titleFontSize = width < 600 ? 16.0 : 20.0;

    return SafeArea(
      top: true,
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColoredBox(
            color: Colors.white,
            child: SizedBox(
              height: widget.bottomSpacer ?? 80.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _horizontalPadding,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildLeading(
                            cupertino: cupertino,
                            colorScheme: colorScheme,
                          ),
                          Expanded(
                            child: widget.title != null
                                ? Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text(
                                      widget.title!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w700,
                                        fontSize: titleFontSize,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          buildTrailing(
                            context: context,
                            cupertino: cupertino,
                            colorScheme: colorScheme,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.additionalText != null) widget.additionalText!,
          if (widget.bottomWidget != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: widget.bottomWidget!,
            ),
          if (widget.isDividerVisible ?? true)
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade200,
            ),
        ],
      ),
    );
  }

  Widget buildTrailing({
    required BuildContext context,
    required bool cupertino,
    required ColorScheme colorScheme,
  }) {
    if (widget.customTrailingWidget != null) {
      return widget.customTrailingWidget!;
    }

    if (widget.showActionButton == null || !widget.showActionButton!) {
      return const SizedBox.shrink();
    }

    final disabled = widget.disableButton ?? false;
    final label = widget.rightActionButtonName ?? "Save";
    final onPressed = disabled ? null : (widget.onActionButtonClicked ?? () {});

    if (cupertino) {
      return CupertinoTheme(
        data: CupertinoTheme.of(context).copyWith(
          primaryColor: CupertinoColors.activeBlue.resolveFrom(context),
        ),
        child: CupertinoButton(
          padding: const EdgeInsetsDirectional.only(start: 8, end: 4),
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 17,
              color: disabled
                  ? CupertinoColors.placeholderText.resolveFrom(context)
                  : CupertinoColors.activeBlue.resolveFrom(context),
            ),
          ),
        ),
      );
    }

    if (widget.useTransparentButton) {
      return TextButton(onPressed: onPressed, child: Text(label));
    }

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      child: Text(label),
    );
  }

  Widget buildLeading({
    required bool cupertino,
    required ColorScheme colorScheme,
  }) {
    switch (widget.closeButton) {
      case CLOSEBUTTON.WIDGET:
        return widget.customLeadingWidget!;
      case CLOSEBUTTON.ICON:
        final iconData = widget.icon ?? Icons.close;
        final loc = MaterialLocalizations.of(context);
        final isClose =
            widget.icon == null ||
            widget.icon == Icons.close ||
            widget.icon == CupertinoIcons.clear;

        final leadingIcon = isClose
            ? const _AppBarCloseGlyph()
            : Icon(iconData, size: 22, color: _kCloseIconForeground);

        // Aligned with Material AppBar `leadingWidth: 56` (see TicketsScreen).
        return SizedBox(
          width: 56,
          child: Center(
            child: IconButton(
              tooltip: isClose ? loc.closeButtonTooltip : null,
              style: _headerCircleIconStyle(),
              icon: leadingIcon,
              onPressed: widget.onPop,
            ),
          ),
        );
      case CLOSEBUTTON.BUTTON:
        final disabled = widget.disableButton ?? false;
        final label = widget.leftActionButtonName ?? '';
        final onPressed = disabled ? null : (widget.onPop ?? () {});

        if (cupertino) {
          return CupertinoButton(
            padding: const EdgeInsetsDirectional.only(start: 4, end: 8),
            onPressed: onPressed,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 17,
                color: disabled
                    ? CupertinoColors.placeholderText.resolveFrom(context)
                    : CupertinoColors.activeBlue.resolveFrom(context),
              ),
            ),
          );
        }

        return TextButton(onPressed: onPressed, child: Text(label));
    }
  }
}

/// Bold, evenly weighted X with rounded line caps, centered in the icon slot.
class _AppBarCloseGlyph extends StatelessWidget {
  const _AppBarCloseGlyph();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: _AppBarCloseGlyphPainter(),
      ),
    );
  }
}

class _AppBarCloseGlyphPainter extends CustomPainter {
  const _AppBarCloseGlyphPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    // Inset so strokes stay inside the 20x20 box with round caps.
    final inset = s * 0.14;
    final strokeW = s * 0.13;
    final paint = Paint()
      ..color = _kCloseIconForeground
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    final tl = Offset(inset, inset);
    final tr = Offset(s - inset, inset);
    final bl = Offset(inset, s - inset);
    final br = Offset(s - inset, s - inset);
    canvas.drawLine(tl, br, paint);
    canvas.drawLine(tr, bl, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
