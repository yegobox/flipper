import 'package:flutter/material.dart';

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
