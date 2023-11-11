import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

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

extension IsarO<ID, OBJ> on IsarCollection<ID, OBJ> {
  void onPut(OBJ object) {
    print('Putting object: ${object}');
    put(object);
  }
}
