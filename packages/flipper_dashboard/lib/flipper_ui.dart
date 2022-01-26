library ui;

import 'package:flipper/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FLipperButton extends StatelessWidget {
  const FLipperButton(
      {Key? key,
      bool transparent = false,
      required bool disableButton,
      required String buttonName,
      required this.onPressedCallback})
      : _disableButton = disableButton,
        _buttonName = buttonName,
        _transparent = transparent,
        super(key: key);

  final VoidCallback onPressedCallback;
  final bool _disableButton;
  final bool _transparent;
  final String _buttonName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Container(
        color: !_transparent
            ? _disableButton
                ? HexColor('#b2bec3')
                : Colors.blueAccent
            : Colors.transparent,
        child: FlatButton(
          onPressed: _disableButton ? null : onPressedCallback,
          child: Text(
            _buttonName,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontStyle: FontStyle.normal,
              color: _transparent ? Colors.black : Colors.white,
              // fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
