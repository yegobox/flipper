import 'package:flutter/material.dart';

class Helpers {
  static const _konnectFont = 'Konnect';

  static const Color greyLigthColor = Color(0xffDEDEDE);
  static const Color principalColor = Color(0xff36446A);
  static const Color greenColor = Color(0xff5EBC7B);

  static const TextStyle txtHistoryStyle = TextStyle(
    fontFamily: _konnectFont,
    fontSize: 11,
  );

  static get font => _konnectFont;

  static const TextStyle txtBtnTabsNotifications = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle txtDefault = TextStyle(
    fontFamily: _konnectFont,
    color: principalColor,
    fontWeight: FontWeight.normal,
    fontSize: 15,
  );
}
