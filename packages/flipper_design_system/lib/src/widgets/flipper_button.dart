import 'package:flipper_design_system/src/tokens/flipper_colors.dart';
import 'package:flipper_design_system/src/widgets/flipper_text.dart';
import 'package:flutter/material.dart';

class FlipperButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final double? radius;
  final BorderRadius? borderRadius;
  final bool busy;
  final bool isLoading;

  const FlipperButton({
    super.key,
    required this.text,
    this.width = 200,
    this.color,
    this.height = 50,
    this.radius = 10,
    this.borderRadius,
    this.textColor,
    this.onPressed,
    this.busy = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = busy || isLoading;
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(radius ?? 10.0);

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: isDisabled ? null : onPressed,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey;
              }
              return color ?? FlipperColors.primary;
            },
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.hovered)) {
                return FlipperColors.primary.withValues(alpha: 0.04);
              }
              if (states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed)) {
                return FlipperColors.primary.withValues(alpha: 0.12);
              }
              return null;
            },
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isDisabled)
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? FlipperColors.onPrimary,
                  ),
                ),
              ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isDisabled ? 0.0 : 1.0,
              child: Text(
                text,
                style: TextStyle(color: textColor ?? FlipperColors.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlipperButtonFlat extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final bool busy;
  final bool isLoading;

  const FlipperButtonFlat({
    super.key,
    required this.text,
    this.textColor,
    this.onPressed,
    this.busy = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = busy || isLoading;

    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.hovered)) {
              return FlipperColors.primary.withValues(alpha: 0.04);
            }
            return null;
          },
        ),
      ),
      onPressed: isDisabled ? null : onPressed,
      child: isDisabled
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  textColor ?? FlipperColors.primary,
                ),
              ),
            )
          : Flippertext(
              text,
              color: textColor,
            ),
    );
  }
}

class FlipperIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String? text;
  final Color? textColor;
  final VoidCallback? onPressed;
  final double? iconSize;
  final double? width;
  final double? height;
  final Color? color;
  final bool busy;
  final bool isLoading;

  const FlipperIconButton({
    super.key,
    required this.icon,
    this.iconColor,
    this.textColor,
    this.text,
    this.width = 200,
    this.height = 50,
    this.color,
    this.onPressed,
    this.iconSize = 24.0,
    this.busy = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = busy || isLoading;

    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) => color ?? FlipperColors.veryLightGrey,
          ),
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.hovered)) {
                return FlipperColors.primary.withValues(alpha: 0.04);
              }
              return null;
            },
          ),
        ),
        onPressed: isDisabled ? null : onPressed,
        child: isDisabled
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    iconColor ?? Colors.black,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: iconColor ?? Colors.black,
                    size: iconSize,
                  ),
                  if (text != null) ...[
                    const SizedBox(width: 8),
                    Flippertext(
                      text!,
                      color: textColor,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
