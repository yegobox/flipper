import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar/utils.dart';
import 'package:isar/isar.dart';

extension StringExtensions on String {
  bool isFutureDateCompareTo(String? other) {
    return isGreaterThan(this, other) || this == other;
  }
}


