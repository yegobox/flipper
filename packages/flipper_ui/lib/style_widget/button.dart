import 'package:flipper_ui/style_widget/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlipperButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? color;

  const FlipperButton({
    Key? key,
    required this.text,
    this.width = 200,
    this.color,
    this.height = 50,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width!,
      height: height!,
      child: TextButton(
        child: FlowyText(
          text,
          color: Colors.white,
        ),
        style: ButtonStyle(
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            color ?? Color(0xffF2F2F2),
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.blue.withOpacity(0.04);
              }
              if (states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed)) {
                return Colors.blue.withOpacity(0.12);
              }
              return null; // Defer to the widget's default.
            },
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class FlipperButtonFlat extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  const FlipperButtonFlat({
    Key? key,
    required this.text,
    this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              return Colors.blue.withOpacity(0.04);
            }

            return null; // Defer to the widget's default.
          },
        ),
      ),
      child: FlowyText(
        text,
        color: textColor,
      ),
      onPressed: onPressed,
    );
  }
}

class FlipperIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String? text;
  final Color? textColor;
  final VoidCallback onPressed;
  final double? iconSize;
  final double? width;
  final double? height;

  const FlipperIconButton({
    Key? key,
    required this.icon,
    this.iconColor,
    this.textColor,
    this.text,
    this.width = 200,
    this.height = 50,
    required this.onPressed,
    this.iconSize = 24.0, // Default icon size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: TextButton.icon(
        style: ButtonStyle(
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.blue.withOpacity(0.04);
              }

              return null; // Defer to the widget's default.
            },
          ),
        ),
        icon: Icon(
          icon,
          color: iconColor ?? Colors.black, // Default icon color
          size: iconSize,
        ),
        label: text != null
            ? FlowyText(
                text!,
                color: textColor,
              )
            : const SizedBox(), // Add empty SizedBox if no text
        onPressed: onPressed,
      ),
    );
  }
}
