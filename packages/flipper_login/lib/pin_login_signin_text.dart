import 'package:flipper_login/signin_tokens.dart';
import 'package:flutter/material.dart';

/// Sign-in screen text uses [ThemeData.textTheme] (Outfit via [FlipperTheme]).
extension PinLoginSignInText on BuildContext {
  TextStyle signInText({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return Theme.of(this).textTheme.bodyMedium!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color ?? SignInTokens.ink1,
          letterSpacing: letterSpacing,
          height: height,
        );
  }

  TextStyle signInPinDigit({double fontSize = 24}) {
    return Theme.of(this).textTheme.headlineSmall!.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: SignInTokens.ink1,
          letterSpacing: 2,
        );
  }
}
