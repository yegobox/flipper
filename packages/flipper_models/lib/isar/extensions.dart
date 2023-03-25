import 'package:flipper_models/isar/utils.dart';

extension StringExtensions on String {
  bool isGreaterThanOrEqualTo(String? other) {
    return isGreaterThan(this, other) || this == other;
  }
}
