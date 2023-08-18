library ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FLipperButton extends StatelessWidget {
  const FLipperButton(
      {Key? key,
      bool transparent = false,
      required bool disableButton,
      required String buttonName,
      required this.onPressedCallback,
      this.colorBuilder,
      this.color,
      this.labelColor,
      this.labelColorBuilder})
      : _disableButton = disableButton,
        _buttonName = buttonName,
        super(key: key);

  final VoidCallback onPressedCallback;
  final bool _disableButton;
  final String _buttonName;

  /// Set button color.
  final Color Function(ColorScheme colorScheme)? colorBuilder;

  /// Set button color.
  final Color? color;

  /// Set button label color.
  final Color? labelColor;

  /// Set button label color.
  final Color Function(ColorScheme colorScheme)? labelColorBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: TextButton(
        onPressed: _disableButton ? null : onPressedCallback,
        child: Text(
          _buttonName,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400, fontSize: 20, color: Colors.white),
        ),
        style: !_disableButton
            ? ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0))),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xff006AFE)),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.blue.withOpacity(0.04);
                    }
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed)) {
                      return Colors.blue.withOpacity(0.12);
                    }
                    return null;
                  },
                ),
              )
            : ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0))),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 155, 157, 160)),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Color.fromARGB(255, 155, 157, 160)
                          .withOpacity(0.04);
                    }
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed)) {
                      return Color.fromARGB(255, 155, 157, 160)
                          .withOpacity(0.12);
                    }
                    return null;
                  },
                ),
              ),
      ),
    );
  }
}
