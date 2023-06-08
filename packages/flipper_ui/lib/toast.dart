import 'package:flutter/material.dart';
import 'package:flipper_services/constants.dart';

void showToast(BuildContext context, String message, {Object? color}) {
  Color? _color;
  if (color == null) {
    _color = Colors.grey[800];
  } else if (color is Color) {
    _color = color;
  } else if (color is String) {
    _color = Color(int.parse(color.substring(1), radix: 16) + 0xFF000000);
  } else {
    _color = Colors.grey[800];
  }

  final overlayState = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: Text(
                message,
                style: primaryTextStyle,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);
  Future.delayed(Duration(seconds: 5), () {
    overlayEntry.remove();
  });
}
