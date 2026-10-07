/// Coordinate pairs older code wrote instead of a real location: signup sent
/// `1`/`1`, flipper-turbo fell back to `1.0`, Capella `saveBranch` wrote `0`,
/// and the location services returned `1.1` / `11` when GPS failed.
const List<num> _placeholderCoordinateValues = [0, 1, 1.1, 11];

/// Whether a branch's latitude/longitude point at a real place rather than a
/// missing value or one of the placeholders above.
bool hasRealBranchCoordinates(num? latitude, num? longitude) {
  if (latitude == null || longitude == null) return false;
  if (latitude.isNaN || longitude.isNaN) return false;
  if (latitude.abs() > 90 || longitude.abs() > 180) return false;
  if (latitude == longitude &&
      _placeholderCoordinateValues.contains(latitude)) {
    return false;
  }
  return true;
}
