library ui;

import 'package:flutter/material.dart';

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
    // final buttonStyle = ElevatedButton.styleFrom(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(0),
    //   ),
    //   primary: color ?? colorBuilder?.call(Theme.of(context).colorScheme),
    //   onPrimary:
    //       labelColor ?? labelColorBuilder?.call(Theme.of(context).colorScheme),
    // );
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _disableButton ? null : onPressedCallback,
        child: Text(_buttonName),
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            );
          }),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Theme.of(context).colorScheme.primary;
              } else if (states.contains(MaterialState.disabled)) {
                return Colors.grey.withOpacity(0.5);
              }
              return Theme.of(context).colorScheme.primary;
            },
          ),
        ),
      ),
    );
  }
}
