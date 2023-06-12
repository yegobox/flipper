extension StringExtensions on String {
  bool isFutureDateCompareTo(String? other) {
    if (other == null) return false;
    return compareTo(other) > 0;
  }
}
