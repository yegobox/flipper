/// Money and date formatting for the people directory.
///
/// Hand-rolled rather than `intl`: HR only needs thousands grouping and a
/// currency prefix, and `intl` is not a declared dependency of this app (it is
/// only transitively available through flipper_web).
library;

import 'package:flipper_hr/features/ui/hr_l10n.dart';
import 'package:flipper_localize/flipper_localize.dart';

/// `1250000` → `RWF 1,250,000`. Fractions are dropped for whole amounts and
/// shown to two places otherwise, which is how RWF payroll figures read.
String formatMoney(double amount, String currency) {
  final prefix = currency.trim().isEmpty ? '' : '${currency.trim()} ';
  return '$prefix${formatNumber(amount)}';
}

/// Compact form for tiles: `1250000` → `1.3M`, `48000` → `48K`.
String formatCompactMoney(double amount, String currency) {
  final prefix = currency.trim().isEmpty ? '' : '${currency.trim()} ';
  final abs = amount.abs();
  final sign = amount < 0 ? '-' : '';
  if (abs >= 1000000) {
    return '$prefix$sign${_trimZero(abs / 1000000)}M';
  }
  if (abs >= 10000) {
    return '$prefix$sign${(abs / 1000).round()}K';
  }
  return '$prefix${formatNumber(amount)}';
}

String formatNumber(double value) {
  final negative = value < 0;
  final abs = value.abs();
  final rounded = (abs * 100).round() / 100;
  final whole = rounded.truncate();
  final cents = ((rounded - whole) * 100).round();

  final digits = whole.toString();
  final grouped = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) grouped.write(',');
    grouped.write(digits[i]);
  }

  final body = cents == 0
      ? grouped.toString()
      : '$grouped.${cents.toString().padLeft(2, '0')}';
  return negative ? '-$body' : body;
}

String _trimZero(double value) {
  final oneDecimal = (value * 10).round() / 10;
  return oneDecimal == oneDecimal.truncate()
      ? oneDecimal.truncate().toString()
      : oneDecimal.toStringAsFixed(1);
}

/// `2026-03-04` → `4 Mar 2026`.
String formatShortDate(DateTime date) =>
    '${date.day} ${hrMonthShortName(FlipperL10n.current, date.month)} '
    '${date.year}';

/// Human tenure for the roster row: `3 yr 2 mo`, `5 mo`, `12 d`, `Starts soon`.
String formatTenure({required DateTime hireDate, required DateTime asOf}) {
  final hire = DateTime(hireDate.year, hireDate.month, hireDate.day);
  final now = DateTime(asOf.year, asOf.month, asOf.day);
  final l10n = FlipperL10n.current;
  if (hire.isAfter(now)) return l10n.hrTenureStarts(formatShortDate(hire));

  var months = (now.year - hire.year) * 12 + (now.month - hire.month);
  if (now.day < hire.day) months -= 1;
  if (months < 1) return l10n.hrTenureDays('${now.difference(hire).inDays}');

  final years = months ~/ 12;
  final remainder = months % 12;
  if (years == 0) return l10n.hrTenureMonths('$months');
  return remainder == 0
      ? l10n.hrTenureYears('$years')
      : l10n.hrTenureYearsMonths('$years', '$remainder');
}
