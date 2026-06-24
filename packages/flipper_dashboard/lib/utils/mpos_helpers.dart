import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:intl/intl.dart';

/// Stable 12-color palette from [design_handoff_mobile_pos/mpos/mpos-data.jsx].
const List<Color> _mposPalette = [
  Color(0xFF3B6FE0),
  Color(0xFF5457D6),
  Color(0xFF7A56E8),
  Color(0xFF9A5BC4),
  Color(0xFFC2557E),
  Color(0xFFC76B45),
  Color(0xFFB5893B),
  Color(0xFF5E8C3C),
  Color(0xFF2E9E83),
  Color(0xFF2C8FB0),
  Color(0xFF5B7488),
  Color(0xFF9A6248),
];

int _mposHash(String s) {
  var h = 0;
  for (var i = 0; i < s.length; i++) {
    h = (h * 31 + s.codeUnitAt(i)) & 0x7FFFFFFF;
  }
  return h;
}

Color mposColorForName(String name) {
  if (name.trim().isEmpty) return _mposPalette[0];
  return _mposPalette[_mposHash(name) % _mposPalette.length];
}

String mposAbbreviation(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length >= 2) {
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  final t = name.trim();
  if (t.length >= 2) return t.substring(0, 2).toUpperCase();
  if (t.isNotEmpty) return t[0].toUpperCase();
  return '?';
}

/// Thousands-separated amount without currency symbol (handoff `mpMoney`).
String mposMoneyLabel(double amount) {
  final v = amount.round();
  return NumberFormat('#,###', 'en_US').format(v);
}

TextStyle mposMonoStyle(
  TextTheme textTheme, {
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.w700,
  Color? color,
}) {
  return PosTokens.posMonoStyle(
    textTheme,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? PosTokens.ink1,
  );
}

String mposCheckoutTimeLabel(DateTime? createdAt) {
  final dt = createdAt ?? DateTime.now();
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
