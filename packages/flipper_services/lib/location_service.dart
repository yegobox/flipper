library flipper_services;

// done here
import 'abstractions/location.dart';
import 'geolocator_position.dart';
import 'package:location/location.dart';

class LocationService implements FlipperLocation {
  @override
  Future<Map<String, String>> getLocations() async {
    Location location = new Location();
    try {
      final loc = await location.getLocation();
      return {
        'longitude': loc.longitude.toString(),
        'latitude': loc.latitude.toString(),
      };
    } catch (e) {
      return {'longitude': "1.1", 'latitude': "1.1"};
    }
  }

  @override
  Future<bool> hasLocationPermission() => geolocatorHasPermission();

  @override
  Future<LocationOutcome> currentPosition({
    Duration timeout = const Duration(seconds: 20),
  }) => geolocatorCurrentPosition(timeout: timeout);

  @override
  Future<bool> openSettingsFor(LocationFailure failure) =>
      geolocatorOpenSettingsFor(failure);
}
