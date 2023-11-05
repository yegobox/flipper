import 'package:flutter/material.dart';

extension DateTimeExtensions on DateTime {
  bool isFutureDateCompareTo(DateTime? other) {
    if (other == null) return false;
    return compareTo(other) > 0;
  }
}


extension NullableDateTimeExtensions on DateTime? {
  bool isFutureDateCompareTo(DateTime? other) {
    if (this == null) return false;
    return this!.isFutureDateCompareTo(other);
  }
}


extension ColorExtension on Color {
  String toHex() {
    return '#${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}';
  }
}

