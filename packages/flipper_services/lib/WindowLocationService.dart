import 'package:geolocator/geolocator.dart';

import 'abstractions/location.dart';

class WindowsLocationService implements FlipperLocation {
  @override
  Future<Map<String, String>> getLocations() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _defaultLocationValues(); // Use a separate method for default values
    }

    // Check if location permissions are granted.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are denied, we cannot request permissions.');
      }
    }

    // Get the current position if permissions are granted.
    Position position = await Geolocator.getCurrentPosition();
    return {
      "longitude": position.longitude.toString(),
      "latitude": position.latitude.toString(),
    };
  }

  @override
  Future<bool> hasLocationPermission() async {
    // Check if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check if location permissions are granted.
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Map<String, String> _defaultLocationValues() {
    return {
      "longitude": "11",
      "latitude": "11",
    };
  }
}
