import 'dart:math';
import 'dart:io';
import 'package:flipper_services/DeviceType.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime? {
  bool isNewDateCompareTo(DateTime? other) {
    if (this == null || other == null) return false;
    return this!.compareTo(other) > 0;
  }
}

extension ColorExtension on Color {
  String toHex({bool includeAlpha = false}) {
    final alphaHex =
        includeAlpha ? alpha.toRadixString(16).padLeft(2, '0') : '';
    return '#$alphaHex${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
  }
}

extension StringToIntList on String {
  List<int> toIntList() {
    return this.split(',').map((e) => int.parse(e.trim())).toList();
  }

  List<String> toStringList() {
    return this.split(',').map((e) => e.trim()).toList();
  }
}

extension DateTimeFormatting on DateTime {
  /// Convert DateTime to local time if it's in UTC
  DateTime get _localDateTime => isUtc ? toLocal() : this;

  /// Returns date in format: January 1, 2024
  String get fullDate => DateFormat('MMMM d, y').format(_localDateTime);

  /// Returns date in format: Jan 1, 2024
  String get shortDate => DateFormat('MMM d, y').format(_localDateTime);

  /// Returns time in format: 2:30 PM
  String get time12Hour => DateFormat('h:mm a').format(_localDateTime);

  /// Returns time in format: 14:30
  String get time24Hour => DateFormat('HH:mm').format(_localDateTime);

  /// Returns full date and time in format: January 1, 2024 2:30:45 PM
  String get fullDateTime =>
      DateFormat('MMMM d, y h:mm:ss a').format(_localDateTime);

  /// Returns short date and time in format: Jan 1, 2024 2:30:45 PM
  String get shortDateTime =>
      DateFormat('MMM d, y h:mm:ss a').format(_localDateTime);

  /// Returns ISO format with local timezone: 2024-01-01 14:30:45
  String get isoDateTime =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(_localDateTime);

  /// Returns ISO format with timezone offset: 2024-01-01 14:30:45 +0200
  String get isoDateTimeWithOffset =>
      DateFormat('yyyy-MM-dd HH:mm:ss Z').format(_localDateTime);

  /// Returns relative time like "2 minutes ago", "1 hour ago", etc.
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(_localDateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  /// Returns weekday name: Monday, Tuesday, etc.
  String get weekday => DateFormat('EEEE').format(_localDateTime);

  /// Returns short weekday name: Mon, Tue, etc.
  String get shortWeekday => DateFormat('EEE').format(_localDateTime);

  /// Returns month name: January, February, etc.
  String get month => DateFormat('MMMM').format(_localDateTime);

  /// Returns short month name: Jan, Feb, etc.
  String get shortMonth => DateFormat('MMM').format(_localDateTime);

  /// Custom format using DateFormat pattern
  String format(String pattern) => DateFormat(pattern).format(_localDateTime);
}

extension StringExtensions on String {
  /// Extracts the part of the string before the first '(' and the number after the first '(' and before the first ')'.
  ///
  /// For example:
  ///   'Product Name (123)' -> 'Product Name, 123'
  ///   'Product Name' -> 'Product Name, '
  ///
  /// Returns a string with the name and number separated by a comma and a space.
  String extractNameAndNumber() {
    String name = split('(')[0];
    String number = '';

    if (contains('(')) {
      number = split('(')[1].split(')')[0];
    }

    return '$name $number'; // Concatenate name and number with a comma and space
  }
}

extension CurrencyFormatExtension on num {
  String toRwf({String? symbol}) {
    final numberFormat = NumberFormat.currency(
      locale: 'en',
      symbol: symbol ?? 'RWF ',
      decimalDigits: 2,
    );

    // Check if the number is 0 or 0.0
    if (this == 0 || this == 0.0) {
      return symbol ?? 'RWF';
    }

    return numberFormat.format(this);
  }

  String toNoCurrencyFormatted({String? symbol}) {
    // Convert `num` to `String` and clean the input
    String cleanedInput = toString().replaceAll(',', '');

    // Parse the cleaned string to a double
    final double? parsedNumber = double.tryParse(cleanedInput);

    // Handle cases where parsing fails
    if (parsedNumber == null) {
      throw FormatException('Invalid double value: $this');
    }

    // Use the intl package's NumberFormat to format the number correctly
    final numberFormat = NumberFormat.currency(
      locale: 'en',
      symbol: symbol ?? '',
      decimalDigits: 2,
    );

    // Check if the number is 0
    if (parsedNumber == 0.0) {
      return symbol ?? '';
    }

    return numberFormat.format(parsedNumber);
  }

  String toNoCurrency({String? symbol}) {
    // Use the intl package's NumberFormat to format the number correctly
    final numberFormat = NumberFormat.currency(
      locale: 'en',
      symbol: symbol ?? '',
      decimalDigits: 2,
    );

    // Check if the number is 0 or 0.0
    if (this == 0 || this == 0.0) {
      return symbol ??
          '0.00'; // Return 0.00 instead of empty string for zero values
    }

    // Function to abbreviate large numbers
    String abbreviateNumber(num number) {
      final isNegative = number < 0;
      final absNumber = number.abs();
      String result;

      if (absNumber >= 1e9) {
        // Billions
        result = '${(absNumber / 1e9).toStringAsFixed(2)}B';
      } else if (absNumber >= 1e6) {
        // Millions
        result = '${(absNumber / 1e6).toStringAsFixed(2)}M';
      } else if (absNumber >= 1e3) {
        // Thousands
        result = '${(absNumber / 1e3).toStringAsFixed(2)}K';
      } else {
        // If the number is less than 1,000, format it with the numberFormat
        return numberFormat.format(number).trim();
      }

      // Add the symbol and negative sign if necessary
      return '${symbol ?? ''}${isNegative ? '-' : ''}$result';
    }

    // Check if the number should be abbreviated (now handling 1000 and above)
    if (this.abs() >= 1e3) {
      return abbreviateNumber(this);
    } else {
      // If the number is smaller than 1000, format it normally
      return numberFormat.format(this).trim();
    }
  }
}

extension DoubleExtension on double {
  double toPrecision(int fractionDigits) {
    final factor = pow(10, fractionDigits);
    return (this * factor).round() / factor;
  }
}

extension DateOnly on DateTime {
  String get formattedDate {
    final localDate = this.toLocal();
    return "${localDate.year}-${localDate.month.toString().padLeft(2, '0')}-${localDate.day.toString().padLeft(2, '0')}";
  }
}

extension TimeOnly on DateTime {
  String get formattedTime {
    final localDate = this.toLocal();
    return "${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}:${localDate.second.toString().padLeft(2, '0')}";
  }
}

extension DateTimeToDateTimeString on DateTime {
  String toDateTimeString() {
    final localDateTime = this.toLocal();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm:ss');
    final dateString = dateFormat.format(localDateTime);
    final timeString = timeFormat.format(localDateTime);
    return '$dateString $timeString';
  }
}

extension StringToDashedString on String {
  /// for RcptSign it is always 16 characters
  /// we group them into 4 characters separated by dash
  String toDashedStringRcptSign() {
    if (length != 16) return this;
    return '${substring(0, 4)}-'
        '${substring(4, 8)}-'
        '${substring(8, 12)}-'
        '${substring(12, 16)}';
  }

  /// for internal data is is always 26 characters, we group them into 4 characters separated by dash
  /// the last characters are 2
  String toDashedStringInternalData() {
    if (length != 26) return this;

    return '${substring(0, 4)}-'
        '${substring(4, 8)}-'
        '${substring(8, 12)}-'
        '${substring(12, 16)}-'
        '${substring(16, 20)}-'
        '${substring(20, 24)}-'
        '${substring(24)}';
  }
}

extension AccessInnerController on Widget {
  Widget eligibleToSee(WidgetRef ref, List<String> accessLevels) {
    return Consumer(
      builder: (context, ref, child) {
        for (final level in accessLevels) {
          final hasAccess = ref.watch(featureAccessLevelProvider(level));
          if (hasAccess) return this;
        }
        return const SizedBox.shrink();
      },
    );
  }
}

extension AccessControlWidget on Widget {
  Widget shouldSeeTheApp(WidgetRef ref, String featureName) {
    return Consumer(
      builder: (context, ref, child) {
        final hasAccess = ref.watch(featureAccessProvider(featureName));
        return hasAccess ? this : SizedBox.shrink();
      },
    );
  }
}

/// I need extension when given MTN MOMO to return M-PAY
/// and when given CARD  tu return C-PAY
/// and when given bannk to return B-PAY
extension PaymentTypeExtension on String {
  String toPaymentType() {
    if (this.contains("MTN")) {
      return "MOMO-PAY";
    } else if (this.contains("Card")) {
      return "CARD-PAY";
    } else if (this.contains("Bank")) {
      return "BANK-PAY";
    } else if (this.contains("Credit")) {
      return "Credit-PAY";
    }
    return "CASH";
  }
}

extension PercentageFormatter on double {
  String toFormattedPercentage() {
    final formatter = NumberFormat.percentPattern();
    return formatter.format(this / 100); // Divide by 100 before formatting
  }
}

extension StringExtension on String {
  String toFlipperEmail() {
    if (this.contains('@')) {
      return this;
    }
    // return a defaul email
    return 'yegobox@gmail.com';
    // return this.replaceFirst('+', '') + '@flipper.rw';
  }
}

String camelToSnakeCase(String input) {
  return input.replaceAllMapped(
    RegExp(r'([A-Z])'),
    (match) => '_${match.group(1)!.toLowerCase()}',
  );
}

extension StringSingularize on String {
  String singularize() {
    // Handle common irregular plurals
    final irregulars = {
      'people': 'person',
      'children': 'child',
      'feet': 'foot',
      'teeth': 'tooth',
      'geese': 'goose',
      'mice': 'mouse',
    };

    if (irregulars.containsKey(this.toLowerCase())) {
      return irregulars[this.toLowerCase()]!;
    }

    // Handle regular plurals
    if (endsWith('ies')) {
      return substring(0, length - 3) + 'y';
    } else if (endsWith('es')) {
      return substring(0, length - 2);
    } else if (endsWith('s') && !endsWith('ss')) {
      return substring(0, length - 1);
    }

    // If no rule applies, return the original string
    return this;
  }
}

extension FlipperClip on DateTime {
  String generateFlipperClip({String prefix = "FLIPPER-"}) {
    return prefix + this.microsecondsSinceEpoch.toString().substring(0, 5);
  }
}

extension DeviceTypeExtension on BuildContext {
  String getDeviceType() {
    return DeviceType.getDeviceType(this);
  }

  bool get isSmallDevice {
    final deviceType = getDeviceType();
    return (deviceType == "Phone" ||
            deviceType == "Phablet" ||
            deviceType == "Tablet") &&
        !(Platform.isMacOS ||
            Platform.isWindows ||
            Platform.isLinux ||
            Platform.isFuchsia);
  }
}

/// extennsion to convert DateTime to yyyMMdd
extension DateTimeToYYYMMdd on DateTime {
  String toYYYMMdd() {
    final localDateTime = this.toLocal();
    final dateFormat = DateFormat('yyyyMMdd');
    return dateFormat.format(localDateTime);
  }

  String toYYYMMddHHmmss() {
    final localDateTime = this.toLocal();
    final dateFormat = DateFormat('yyyyMMddHHmmss');
    return dateFormat.format(localDateTime);
  }

  String toYYYYMMddHHmmss() {
    return DateFormat('yyyyMMddHHmmss').format(this);
  }
}

/// validate a string tin is valid tin
/// valid tin 999909695 invalid tin: 783054874
extension StringToTin on String {
  bool isValidTin() {
    if (this.length != 10) return false;
    return RegExp(r'^\d{9}$').hasMatch(this);
  }
}
