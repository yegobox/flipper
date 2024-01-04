library flipper_login;

import 'package:flutter/material.dart';
import 'dart:ui';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class AppColors {
  static MaterialColor black = AppColors.factoryColor(0xFF000000);
  static Color mainColor = HexColor('#955be9');

  /// WhatsApp's signature green color.
  static Color darkColor = const Color(0xff102e30);
  static Color primaryColor = const Color(0xff075e54);

  /// Secondary green color.
  static Color secondaryColor = const Color(0xff00897b);
  static Color highlightColor = const Color(0xff357c74);

  /// White-ish background color.
  static Color scaffoldBgColor = const Color(0xfffafafa);

  /// FloatingActionButton's background color
  static Color fabBgColor = const Color(0xff20c659);

  static Color fabBgSecondaryColor = const Color(0xff507578);

  static Color lightGrey = const Color(0xffe2e8ea);

  static Color iconColor = const Color(0xff858b90);

  static Color statusThumbnailBorderColor = const Color(0xff21bfa6);

  static Color notificationBadgeColor = const Color(0xff08d160);
// done color inspired by whatsapp
  static MaterialColor darkBlue = AppColors.factoryColor(0xFF4169E1);
  static MaterialColor white = AppColors.factoryColor(0xffffffff);
  static MaterialColor gray = AppColors.factoryColor(0xffA9A9A9);
  static MaterialColor darkGray = AppColors.factoryColor(0xff78797B);
  static MaterialColor green = AppColors.factoryColor(0xff7EC518);
  static MaterialColor flipperMainColor = AppColors.factoryColor(0xffffffff);
  static MaterialColor houseGreen = AppColors.factoryColor(0xFF1e3932);
  static MaterialColor warmNeutral = AppColors.factoryColor(0xfff2f0eb);
  static MaterialColor lightGreen = AppColors.factoryColor(0xffd4e9e2);
  static MaterialColor factoryColor(int color) {
    return MaterialColor(color, <int, Color>{
      50: Color(color),
      100: Color(color),
      200: Color(color),
      300: Color(color),
      400: Color(color),
      500: Color(color),
      600: Color(color),
      700: Color(color),
      800: Color(color),
      900: Color(color),
    });
  }
}
