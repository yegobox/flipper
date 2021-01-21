import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class AppColors {
  static MaterialColor black = AppColors.factoryColor(0xFF000000);

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

  static Color profileDialogBgColor = const Color(0xff73bfb8);
  static Color profileDialogIconColor = const Color(0xff8ac9c3);

  static Color chatDetailScaffoldBgColor = const Color(0xffe7e2db);

  static Color iconColor = const Color(0xff858b90);
  static Color textFieldHintColor = const Color(0xffcdcdcd);

  static Color messageBubbleColor = const Color(0xffe1ffc7);
  static Color blueCheckColor = const Color(0xff3fbbec);

  static Color statusThumbnailBorderColor = const Color(0xff21bfa6);

  static Color notificationBadgeColor = const Color(0xff08d160);
// done color inspired by whatsapp
  static MaterialColor darkBlue = AppColors.factoryColor(0xFF4169E1);
  static MaterialColor white = AppColors.factoryColor(0xffffffff);
  static MaterialColor gray = AppColors.factoryColor(0xffA9A9A9);
  static MaterialColor darkGray = AppColors.factoryColor(0xff78797B);
  static MaterialColor green = AppColors.factoryColor(0xff7EC518);
  static MaterialColor flipperGreen = AppColors.factoryColor(0xffffffff);
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
