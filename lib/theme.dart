import 'package:flipper/util/HexColor.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const pixelMultiplier = 1.0;
  static const appMargin = 12.0 * pixelMultiplier;
  static const avatarSize = 36.0 * pixelMultiplier;
  static const appBarSize = 44.0;

  static const fontFamilyPoppinsExtraBold = "Poppins-ExtraBold";
  static const fontFamilyPoppinsRegular = "Poppins-Regular";
  static const fontFamilyEdmondsansRegular = "Edmondsans-Regular";
  static const fontFamilyEdmondsansMedium = "Edmondsans-Medium";
  static const fontFamilyHeeboThin = "Heboo-Regular";

  static const colorDarkBlue = Color.fromRGBO(23, 38, 157, 1.0);
  static const colorDarkBlueFont = Color.fromRGBO(4, 24, 138, 1.0);
  static final colorDarkBlueImageSelection = HexColor("#04188A");
  static const colorDarkGreen = Color.fromRGBO(33, 127, 125, 1.0);
  static const colorLightGreen = Color.fromRGBO(207, 244, 234, 1.0);
  static const colorMintGreen = Color.fromRGBO(54, 207, 166, 1.0);
  static const colorRed = Color.fromRGBO(255, 72, 103, 1.0);
  static const colorShadow = Color.fromRGBO(204, 204, 204, 1.0);
  static const colorTextDisabled = Color.fromRGBO(153, 153, 153, 1.0);
  static const colorTextEnabled = Color.fromRGBO(0, 0, 0, 1.0);
  static const colorTextLink = Color.fromRGBO(74, 144, 226, 1.0);
  static const colorGrey128 = Color.fromRGBO(128, 128, 128, 1.0);
  static const colorGrey128_25 = Color.fromRGBO(128, 128, 128, 0.25);
  static const colorGrey128_50 = Color.fromRGBO(128, 128, 128, 0.5);
  static const colorGrey155 = Color.fromRGBO(155, 155, 155, 1.0);
  static const colorGrey225 = Color.fromRGBO(225, 225, 225, 1.0);
  static const colorGrey241 = Color.fromRGBO(241, 241, 241, 1.0);
  static final colorWhite_50 = Colors.white.withOpacity(0.5);

  static ThemeData get theme {
    return ThemeData.light().copyWith(
      primaryColor: Colors.black,
      accentColor: Colors.black,
    );
  }

  static ThemeData get payableTheme {
    return ThemeData.light().copyWith(
      primaryColor: Colors.white,
      accentColor: Colors.white,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }

  static ThemeData get branchList {
    return ThemeData.light().copyWith(
      primaryColor: Colors.white,
      accentColor: Colors.white,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  static ThemeData get currentSale {
    return ThemeData.light().copyWith(
      primaryColor: Colors.black,
      accentColor: Colors.black,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 19,
        ),
      ),
    );
  }

  static ThemeData get addProduct {
    return ThemeData.light().copyWith(
      primaryColor: Colors.black,
      accentColor: Colors.black,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 19,
        ),
      ),
    );
  }

  static ThemeData get keypad {
    return ThemeData.light().copyWith(
      primaryColor: Colors.black,
      accentColor: Colors.black,
      textTheme: TextTheme(
        bodyText1: TextStyle(fontSize: 40, fontFamily: "Heebo-Thin"),
      ),
    );
  }

  static ThemeData get money {
    return ThemeData.light().copyWith(
      primaryColor: Colors.black,
      accentColor: Colors.black,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 19,
        ),
      ),
    );
  }

  static TextStyle get notificationBody {
    return theme.textTheme.bodyText1.copyWith(
      color: Colors.white,
      fontSize: 16,
      fontFamily: fontFamilyEdmondsansRegular,
    );
  }

  static ThemeData get addAnote {
    return ThemeData.light().copyWith(
      primaryColor: HexColor('#95a5a6'),
      accentColor: HexColor('#95a5a6'),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 19,
        ),
      ),
    );
  }

  static const fontFamily = "Heebo-Thin";

  /// Calendar

  static TextStyle get calendarDayTitle {
    return theme.textTheme.headline5.copyWith(
      color: colorDarkBlue,
      fontSize: 16,
      fontFamily: fontFamilyHeeboThin,
    );
  }

  static TextStyle get calendarListEventName {
    return theme.textTheme.headline5.copyWith(
      color: colorDarkBlue,
      fontSize: 16,
      fontFamily: fontFamilyEdmondsansMedium,
    );
  }

  static TextStyle get calendarListGroupName {
    return theme.textTheme.headline5.copyWith(
      color: colorDarkBlue.withAlpha(150),
      fontSize: 16,
      fontFamily: fontFamilyEdmondsansMedium,
    );
  }

  static TextStyle get calendarListTime {
    return theme.textTheme.headline5.copyWith(
      color: Colors.white,
      fontSize: 12,
      fontFamily: fontFamilyEdmondsansMedium,
    );
  }

  ///

  static get circleMenuAbbreviationText {
    return TextStyle(
      fontSize: 16 * pixelMultiplier,
      fontFamily: fontFamilyHeeboThin,
      color: colorTextEnabled,
    );
  }

  static TextStyle get circleTitle {
    return theme.textTheme.headline5.copyWith(
      color: colorDarkBlueFont,
      fontSize: 24,
      fontFamily: fontFamilyHeeboThin,
    );
  }

  static TextStyle get flipperSectionButtonTitle {
    return theme.textTheme.headline5.copyWith(
      color: colorDarkBlueFont,
      fontSize: 16,
      fontFamily: fontFamilyHeeboThin,
    );
  }

  static TextStyle get notificationTitle {
    return theme.textTheme.bodyText1.copyWith(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      fontFamily: fontFamilyPoppinsExtraBold,
    );
  }

  static TextStyle get notificationTime {
    return theme.textTheme.bodyText1.copyWith(
      color: Colors.white,
      fontSize: 12,
      fontFamily: fontFamilyEdmondsansRegular,
    );
  }

  static TextStyle get createItem {
    return theme.textTheme.bodyText1.copyWith(
      color: Colors.white,
      fontSize: 16 * pixelMultiplier,
      fontFamily: fontFamilyHeeboThin,
    );
  }

  static TextStyle get createDiscount {
    return theme.textTheme.bodyText1.copyWith(
      color: Colors.black,
      fontSize: 16 * pixelMultiplier,
      fontFamily: fontFamilyHeeboThin,
    );
  }

  static TextStyle get dismiss {
    return theme.textTheme.bodyText1.copyWith(
      color: Colors.black,
      fontSize: 16 * pixelMultiplier,
      fontFamily: fontFamilyHeeboThin,
    );
  }

  static TextStyle get buttonTextStyle {
    return TextStyle(
      fontSize: 16 * pixelMultiplier,
      fontFamily: fontFamilyHeeboThin,
    );
  }

  static TextStyle get linkTextStyle {
    return TextStyle(
      fontSize: 16 * pixelMultiplier,
      fontFamily: fontFamilyEdmondsansRegular,
      color: colorTextLink,
    );
  }

  static get systemMessageTextStyle {
    return TextStyle(
      fontSize: 12 * pixelMultiplier,
      fontFamily: fontFamilyEdmondsansMedium,
      color: colorTextDisabled,
    );
  }

  static get inputColor {
    return TextStyle(
      fontSize: 16,
      // fontFamily: fontFamilyHeeboThin,
      color: Colors.black,
    );
  }

  static get emojiReactionTextStyle {
    return TextStyle(
      fontSize: 12 * pixelMultiplier,
      fontFamily: fontFamilyHeeboThin,
      color: colorTextEnabled,
    );
  }

  static TextStyle get appBarTitleTextStyle {
    return TextStyle(
      fontSize: 20,
      fontFamily: fontFamilyHeeboThin,
      color: colorTextEnabled,
    );
  }

  static TextStyle get appBarSubtitleTextStyle {
    return TextStyle(
      fontSize: 16,
      fontFamily: fontFamilyEdmondsansRegular,
      color: colorTextEnabled,
    );
  }

  static TextStyle get appBarActionTextStyle {
    return TextStyle(
      fontSize: 16,
      fontFamily: fontFamilyHeeboThin,
      color: colorTextEnabled,
    );
  }

  static TextStyle get appBarActionDisabledTextStyle {
    return TextStyle(
      fontSize: 16,
      fontFamily: fontFamilyHeeboThin,
      color: colorTextDisabled,
    );
  }

  static InputDecorationTheme get inputDecorationEmptyTheme {
    return _inputDecorationTheme(
      baseColor: colorGrey128,
    );
  }

  static TextStyle get inputMediumTextStyle {
    return TextStyle(
      fontSize: 16,
      fontFamily: fontFamilyEdmondsansMedium,
      color: colorTextEnabled,
    );
  }

  static InputDecorationTheme get inputDecorationFilledTheme {
    return _inputDecorationTheme(
      baseColor: colorDarkBlueFont,
    );
  }

  static InputDecorationTheme get inputDecorationErrorTheme {
    return _inputDecorationTheme(
      baseColor: colorRed,
    );
  }

  static InputDecorationTheme _inputDecorationTheme({
    baseColor: Color,
    textColor: Color,
  }) {
    return InputDecorationTheme(
      border: OutlineInputBorder(borderSide: BorderSide(color: baseColor)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: baseColor)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: baseColor)),
      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: colorRed)),
      errorStyle: TextStyle(
        fontSize: 12,
        fontFamily: fontFamilyEdmondsansRegular,
        color: colorRed,
      ),
      focusedErrorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: colorRed)),
      labelStyle: TextStyle(
        fontSize: 16,
        fontFamily: fontFamilyEdmondsansMedium,
        color: baseColor,
      ),
      helperStyle: TextStyle(
        fontSize: 12,
        fontFamily: fontFamilyEdmondsansRegular,
        color: colorGrey128,
      ),
    );
  }
}
