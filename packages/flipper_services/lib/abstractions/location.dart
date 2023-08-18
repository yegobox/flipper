abstract class FlipperLocation {
  Future<Map<String, String>> getLocations(); //map<longitude,latitude>
  Future<bool> doWeHaveLocationPermission();
}
