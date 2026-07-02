import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract final class DelegationHelpers {
  /// Platform / theme fonts only — no Google Fonts runtime fetch (see FlipperTheme).
  static TextStyle sans({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) =>
      TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  /// Display-style text (Spectral in the handoff); uses the same bundled font with stronger weight.
  static TextStyle serif({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) =>
      TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w700,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  static String formatWhen(DateTime dateTime) =>
      DateFormat('MMM dd, yyyy · HH:mm').format(dateTime.toLocal());

  static String formatAmount(double amount) {
    final formatted = NumberFormat('#,##0.00', 'en_US').format(amount);
    return 'RWF $formatted';
  }

  static String statusLabel(String status) => switch (status) {
        'completed' => 'Completed',
        'delegated' => 'Delegated',
        'failed' => 'Failed',
        _ => status,
      };

  static IconData statusIcon(String status) => switch (status) {
        'completed' => Icons.check_rounded,
        'delegated' => Icons.arrow_forward_rounded,
        'failed' => Icons.close_rounded,
        _ => Icons.info_outline_rounded,
      };

  static TextStyle mono({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) =>
      FlipperFonts.mono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );

  static String displayName(String? customerName, String transactionId) {
    if (customerName != null && customerName.trim().isNotEmpty) {
      return customerName.trim();
    }
    if (transactionId.length > 8) {
      return 'Transaction ${transactionId.substring(0, 8)}';
    }
    return 'Transaction $transactionId';
  }
}
