library flipper_services;

// done here
import 'abstractions/location.dart';
import 'package:location/location.dart';

class LocationService implements FlipperLocation {
  @override
  Future<Map<String, String>> getLocations() async {
    Location location = new Location();
    try {
      final loc = await location.getLocation();
      return {
        'longitude': loc.longitude.toString(),
        'latitude': loc.latitude.toString()
      };
    } catch (e) {
      return {'longitude': "1.1", 'latitude': "1.1"};
    }
  }

  bool _serviceEnabled = false;
  @override
  Future<bool> hasLocationPermission() async {
    Location location = new Location();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }
}
