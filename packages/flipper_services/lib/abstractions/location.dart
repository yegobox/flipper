abstract class FlipperLocation {
  Future<Map<String, String>> getLocation(); //map<longitude,latitude>
  Future<bool> doWeHaveLocationPermission();
}
