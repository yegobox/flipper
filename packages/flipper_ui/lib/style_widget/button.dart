import 'package:flipper_ui/style_widget/text.dart';
import 'package:flutter/material.dart';

class FlipperButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final double? radius; // Individual corner radius (for backward compatibility)
  final BorderRadius? borderRadius; // Customizable corner radius
  final bool busy;
  final bool isLoading;

  const FlipperButton({
    Key? key,
    required this.text,
    this.width = 200,
    this.color,
    this.height = 50,
    this.radius = 10, // Default radius for backward compatibility
    this.borderRadius, // Customizable borderRadius
    this.textColor,
    this.onPressed,
    this.busy = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = busy || isLoading;

    // Use borderRadius if provided, otherwise fall back to radius
    final BorderRadius effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(radius ?? 10.0);

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Loading or busy indicator
            if (isDisabled)
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.white,
                  ),
                ),
              ),

            // Button text with opacity animation
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isDisabled ? 0.0 : 1.0,
              child: Text(
                text,
                style: TextStyle(color: textColor ?? Colors.white),
              ),
            ),
          ],
        ),
        style: ButtonStyle(
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: effectiveBorderRadius, // Use effectiveBorderRadius
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey; // Color when button is disabled
              }
              return color ?? const Color(0xffF2F2F2);
            },
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.blue.withValues(alpha: 0.04);
              }
              if (states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed)) {
                return Colors.blue.withValues(alpha: 0.12);
              }
              return null; // Defer to the widget's default.
            },
          ),
        ),
        onPressed: isDisabled ? null : onPressed,
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
    Key? key,
    required this.text,
    this.textColor,
    this.onPressed,
    this.busy = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = busy || isLoading;

    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.blue.withValues(alpha: 0.04);
            }
            return null; // Defer to the widget's default.
          },
        ),
      ),
      child: isDisabled
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(textColor ?? Colors.blue),
              ),
            )
          : Flippertext(
              text,
              color: textColor,
            ),
      onPressed: isDisabled ? null : onPressed,
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
    Key? key,
    required this.icon,
    this.iconColor,
    this.textColor,
    this.text,
    this.width = 200,
    this.height = 50,
    this.color,
    this.onPressed,
    this.iconSize = 24.0, // Default icon size
    this.busy = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = busy || isLoading;

    return Container(
      height: height,
      width: width,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              return color ??
                  const Color(0xffF2F2F2); // Use provided color or default
            },
          ),
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.blue.withValues(alpha: 0.04);
              }
              return null; // Defer to the widget's default.
            },
          ),
        ),
        child: isDisabled
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(iconColor ?? Colors.black),
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
                    SizedBox(width: 8),
                    Flippertext(
                      text!,
                      color: textColor,
                    ),
                  ],
                ],
              ),
        onPressed: isDisabled ? null : onPressed,
      ),
    );
  }
}
