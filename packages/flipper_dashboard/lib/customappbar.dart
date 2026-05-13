// ignore_for_file: constant_identifier_names

library customappbar;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CLOSEBUTTON { ICON, BUTTON, WIDGET }

/// Cash Book / cash-in header: circular 44×44 tap target, grey outline, Material icon.
class AppBarRoundIconButton extends StatelessWidget {
  const AppBarRoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconColor,
    this.borderColor,
    this.iconSize = 22,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? iconColor;
  final Color? borderColor;
  final double iconSize;

  static const double diameter = 44;
  static const double borderWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    final ic = iconColor ?? Colors.grey.shade700;
    final bc = borderColor ?? Colors.grey.shade400;
    final inferredClose = icon == Icons.close || icon == CupertinoIcons.clear;
    final tip =
        tooltip ??
        (inferredClose
            ? MaterialLocalizations.of(context).closeButtonTooltip
            : null);

    Widget target = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: bc, width: borderWidth),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: ic, size: iconSize),
        ),
      ),
    );

    if (tip != null && tip.isNotEmpty) {
      target = Tooltip(message: tip, child: target);
    }
    return target;
  }
}

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
    this.barBackgroundColor,
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

  /// Defaults to white; set to match the scaffold when the bar should blend in.
  final Color? barBackgroundColor;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize {
    final toolbar = 80.0 * (multi ?? 1.0);
    // Built layout includes a [Divider] under the bar; omitting it caused a 1px overflow.
    final dividerExtent = (isDividerVisible ?? true) ? 1.0 : 0.0;
    return Size.fromHeight(toolbar + dividerExtent);
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  static const double _horizontalPadding = 8;

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
            color: widget.barBackgroundColor ?? Colors.white,
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
            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
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

        // Aligned with Material AppBar `leadingWidth: 56` and Cash Book header.
        return SizedBox(
          width: 56,
          child: Center(
            child: AppBarRoundIconButton(
              icon: iconData,
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
