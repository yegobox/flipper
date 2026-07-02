import 'package:flipper_dashboard/payment/payment_tokens.dart';
import 'package:flutter/material.dart';

abstract final class PaymentTypography {
  static const String sans = 'Geist';
  static const String mono = 'Geist Mono';

  static TextStyle introTitle({Color color = PaymentTokens.ink1}) =>
      TextStyle(
        fontFamily: sans,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.03 * 24,
        height: 1.12,
        color: color,
      );

  static TextStyle introSubtitle({Color color = PaymentTokens.ink2}) =>
      TextStyle(
        fontFamily: sans,
        fontSize: 14.5,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle headerTitle({Color color = PaymentTokens.ink1}) =>
      TextStyle(
        fontFamily: sans,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02 * 18,
        color: color,
      );

  static TextStyle sectionLabel({Color color = PaymentTokens.ink3}) =>
      TextStyle(
        fontFamily: sans,
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.09 * 11.5,
        color: color,
      );

  static TextStyle planName({Color color = PaymentTokens.ink1}) => TextStyle(
        fontFamily: sans,
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.01 * 15.5,
        color: color,
      );

  static TextStyle planPrice({Color color = PaymentTokens.ink3}) => TextStyle(
        fontFamily: sans,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle monoPrice({
    Color color = PaymentTokens.ink2,
    double size = 13,
    FontWeight weight = FontWeight.w600,
  }) =>
      TextStyle(
        fontFamily: mono,
        fontSize: size,
        fontWeight: weight,
        color: color,
      );

  static TextStyle totalLabel({Color color = PaymentTokens.ink3}) => TextStyle(
        fontFamily: sans,
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.06 * 12.5,
        color: color,
      );

  static TextStyle totalValue({Color color = PaymentTokens.blue}) => TextStyle(
        fontFamily: mono,
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02 * 22,
        color: color,
      );

  static TextStyle totalPeriod({Color color = PaymentTokens.ink3}) =>
      TextStyle(
        fontFamily: sans,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle segmentButton({Color color = PaymentTokens.ink2}) =>
      TextStyle(
        fontFamily: sans,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle segmentMono({Color color = PaymentTokens.ink2}) =>
      TextStyle(
        fontFamily: mono,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle primaryButton({Color color = Colors.white}) => TextStyle(
        fontFamily: sans,
        fontSize: 16.5,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.01 * 16.5,
        color: color,
      );

  static TextStyle hint({Color color = PaymentTokens.ink3}) => TextStyle(
        fontFamily: sans,
        fontSize: 12.5,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle heroHeadline({Color color = PaymentTokens.ink1}) =>
      TextStyle(
        fontFamily: sans,
        fontSize: 25,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.03 * 25,
        color: color,
      );

  static TextStyle body({Color color = PaymentTokens.ink2}) => TextStyle(
        fontFamily: sans,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle cardTitle({Color color = PaymentTokens.blue700}) =>
      TextStyle(
        fontFamily: sans,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.01 * 16,
        color: color,
      );

  static TextStyle inlineLabel({Color color = PaymentTokens.ink1}) =>
      TextStyle(
        fontFamily: sans,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color,
      );
}
