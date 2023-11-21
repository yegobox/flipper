library flipper_services;

// done here
import 'abstractions/location.dart';
import 'package:location/location.dart';

class LocationService implements FlipperLocation {
  Future<Map<String, String>> getLocations() async {
    try {
      final location = await getLocation();
      return {
        'longitude': location.longitude.toString(),
        'latitude': location.latitude.toString()
      };
    } catch (e) {
      return {'longitude': "1.1", 'latitude': "1.1"};
    }
  }

  Future<bool> hasLocationPermission() async {
    final permissionStatus = await requestPermission();
    return permissionStatus == PermissionStatus.authorizedAlways ||
        permissionStatus == PermissionStatus.authorizedWhenInUse;
  }
}
