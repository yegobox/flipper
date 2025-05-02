import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
    this.onPressed,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.backgroundColor,
    this.iconSize = 18.0,
    this.fontSize = 14.0,
    this.height = 48.0,
    this.width = 100.0,
    this.showText = true,
    this.text = 'Back',
    this.borderRadius = const BorderRadius.all(Radius.circular(0.0)),
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Color iconColor;
  final Color textColor;
  final Color? backgroundColor;
  final double iconSize;
  final double fontSize;
  final double height;
  final double width;
  final bool showText;
  final String text;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final _routerService = locator<RouterService>();

    return SizedBox(
      height: height,
      width: width,
      child: TextButton(
        style: primaryButtonStyle.copyWith(
          backgroundColor: backgroundColor != null
              ? WidgetStateProperty.all(backgroundColor)
              : null,
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: borderRadius,
          )),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
        ),
        onPressed: onPressed ?? () => _routerService.pop(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back,
              color: iconColor,
              size: iconSize,
            ),
            if (showText) const SizedBox(width: 8.0),
            if (showText)
              Text(
                text,
                style: primaryTextStyle.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
