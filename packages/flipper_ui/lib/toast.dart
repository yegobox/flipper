import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
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
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: Text(message),
            ),
          ),
        ),
      ),
    ),
  );

  overlayState.insert(overlayEntry);
  Future.delayed(Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}
