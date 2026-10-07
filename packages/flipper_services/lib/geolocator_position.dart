import 'package:geolocator/geolocator.dart';

import 'abstractions/location.dart';

/// Shared by every [FlipperLocation] implementation: geolocator covers
/// Android, iOS, macOS, Windows and web.
Future<bool> geolocatorHasPermission() async {
  if (!await Geolocator.isLocationServiceEnabled()) return false;
  final permission = await Geolocator.checkPermission();
  return permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
}

Future<LocationOutcome> geolocatorCurrentPosition({
  required Duration timeout,
}) async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return const LocationOutcome.failed(LocationFailure.serviceDisabled);
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        break;
      case LocationPermission.denied:
        return const LocationOutcome.failed(LocationFailure.denied);
      case LocationPermission.deniedForever:
      case LocationPermission.unableToDetermine:
        return const LocationOutcome.failed(LocationFailure.deniedForever);
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: timeout,
      ),
    );
    return LocationOutcome.fix(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy > 0 ? position.accuracy : null,
    );
  } on LocationServiceDisabledException {
    return const LocationOutcome.failed(LocationFailure.serviceDisabled);
  } on PermissionDeniedException {
    // Thrown when a request is already in flight or the OS refuses outright.
    return const LocationOutcome.failed(LocationFailure.denied);
  } catch (_) {
    // Timeout, no signal, or a missing platform declaration
    // (PermissionDefinitionsNotFoundException).
    return const LocationOutcome.failed(LocationFailure.unavailable);
  }
}

Future<bool> geolocatorOpenSettingsFor(LocationFailure failure) async {
  try {
    return failure == LocationFailure.serviceDisabled
        ? await Geolocator.openLocationSettings()
        : await Geolocator.openAppSettings();
  } catch (_) {
    return false;
  }
}
