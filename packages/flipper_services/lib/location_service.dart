library flipper_services;

// done here
import 'abstractions/location.dart';
import 'package:location/location.dart';

final defaultlocation = {"longitude": "11", "latitude": "11"};

class LocationService implements FlipperLocation {
  late PermissionStatus _serviceEnabled;
  late PermissionStatus _permissionGranted;

  @override
  Future<Map<String, String>> getLocations() async {
    try {
      final location = await getLocation();
      return {
        'longitude': location.longitude.toString(),
        'latitude': location.latitude.toString()
      };
    } catch (e) {
      // ignore: todo
      // TODO:keep checking as soon windows is supported to change this
      return {'longitude': "1.1", 'latitude': "1.1"};
    }
  }

  @override
  Future<bool> doWeHaveLocationPermission() async {
    _serviceEnabled = await getPermissionStatus();
    if (!_serviceEnabled.authorized) {
      return false;
    }
    _permissionGranted = await requestPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await requestPermission();
      if ((_permissionGranted != PermissionStatus.authorizedAlways) ||
          (_permissionGranted != PermissionStatus.authorizedWhenInUse)) {
        return false;
      }
    }
    return true;
  }
}
