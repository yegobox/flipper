library flipper_services;

import 'abstractions/location.dart';
import 'package:location/location.dart';

final defaultlocation = {"longitude": "11", "latitude": "11"};

class LocationService implements FlipperLocation {
  Location location = new Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  @override
  Future<Map<String, String>> getLocation() async {
    _locationData = await location.getLocation();
    return {
      'longitude': _locationData.longitude.toString(),
      'latitude': _locationData.latitude.toString()
    };
  }

  @override
  Future<bool> doWeHaveLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
}
