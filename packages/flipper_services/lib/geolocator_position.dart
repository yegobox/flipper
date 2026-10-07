import 'package:geolocator/geolocator.dart';

/// Shared by every [FlipperLocation] implementation: geolocator covers
/// Android, iOS, macOS, Windows and web.
Future<bool> geolocatorHasPermission() async {
  if (!await Geolocator.isLocationServiceEnabled()) return false;
  final permission = await Geolocator.checkPermission();
  return permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
}

Future<({double latitude, double longitude})?> geolocatorCurrentPosition({
  required Duration timeout,
}) async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      return null;
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: timeout,
      ),
    );
    return (latitude: position.latitude, longitude: position.longitude);
  } catch (_) {
    return null;
  }
}
