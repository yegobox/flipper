import 'package:flipper_models/isar/utils.dart';

extension StringExtensions on String {
  bool isFutureDateCompareTo(String? other) {
    return isGreaterThan(this, other) || this == other;
  }
}
