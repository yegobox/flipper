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
        _transparent = transparent,
        super(key: key);

  final VoidCallback onPressedCallback;
  final bool _disableButton;
  final bool _transparent;
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
    final buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      primary: color ?? colorBuilder?.call(Theme.of(context).colorScheme),
      onPrimary:
          labelColor ?? labelColorBuilder?.call(Theme.of(context).colorScheme),
    );
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: _disableButton ? null : onPressedCallback,
        child: Text(
          _buttonName,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.lato(
            fontStyle: FontStyle.normal,
            color: _transparent ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
