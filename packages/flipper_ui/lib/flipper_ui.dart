library ui;

import 'package:apptheme/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FLipperButton extends StatelessWidget {
  const FLipperButton(
      {Key key,
         bool transparent = false,
      @required bool disableButton,
      @required Function onPressedCallback,
      @required String buttonName})
      : _disableButton = disableButton,
        _buttonName = buttonName,
        _transparent = transparent,
        _onPressedCallback = onPressedCallback,
        super(key: key);

  final Function _onPressedCallback;
  final bool _disableButton;
  final bool _transparent;
  final String _buttonName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Container(
        color:!_transparent?  _disableButton != null && _disableButton
            ? HexColor('#b2bec3')
            : HexColor('#0984e3'): Colors.transparent,
        child: FlatButton(
          onPressed: _disableButton ? null : _onPressedCallback,
          child: Text(
            _buttonName,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontStyle: FontStyle.normal,
              color: _transparent? Colors.black:Colors.white,
              // fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
