// ignore_for_file: constant_identifier_names

library customappbar;

import 'package:flipper_ui/style_widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

enum CLOSEBUTTON { ICON, BUTTON, WIDGET }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cupertino = _useCupertinoStyle(context);

    return SafeArea(
      top: true,
      bottom: false,
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
                              child: Flippertext(
                                widget.title!,
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
            if (widget.additionalText != null) widget.additionalText!,
            if (widget.bottomWidget != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: widget.bottomWidget!,
              ),
            if (widget.isDividerVisible ?? true)
              Divider(
                height: 1,
                thickness: cupertino ? 0.0 : 1,
                color: cupertino
                    ? CupertinoColors.separator.resolveFrom(context)
                    : colorScheme.outlineVariant,
              ),
          ],
        ),
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
        final iconData =
            widget.icon ?? (cupertino ? CupertinoIcons.clear : Icons.close);
        final loc = MaterialLocalizations.of(context);
        final isClose =
            widget.icon == null ||
            widget.icon == Icons.close ||
            widget.icon == CupertinoIcons.clear;

        if (cupertino) {
          return SizedBox(
            width: 44,
            height: 44,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: widget.onPop,
              child: Icon(
                iconData,
                size: 22,
                color: CupertinoColors.label.resolveFrom(context),
              ),
            ),
          );
        }

        return IconButton(
          tooltip: isClose ? loc.closeButtonTooltip : null,
          style: IconButton.styleFrom(
            foregroundColor: colorScheme.onSurface,
            visualDensity: VisualDensity.standard,
          ),
          icon: Icon(iconData, size: 24),
          onPressed: widget.onPop,
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
