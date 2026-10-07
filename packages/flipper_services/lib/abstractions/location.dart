abstract class FlipperLocation {
  Future<Map<String, String>> getLocations(); //map<longitude,latitude>
  Future<bool> hasLocationPermission();

  /// The device's position, asking for permission when needed. Unlike
  /// [getLocations] this returns null when the position is unavailable
  /// (permission denied, location off, timeout) instead of a placeholder.
  Future<({double latitude, double longitude})?> currentPosition({
    Duration timeout = const Duration(seconds: 20),
  });
}
