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

/// A remembered position older than this may be from somewhere else, and
/// the branch prompt saves only where the user is standing now.
const Duration maxLastKnownAge = Duration(minutes: 2);

/// The device's position. Asks for permission when needed. A precise GPS fix
/// often never arrives indoors (in a shop), so when the first part of
/// [timeout] passes without one, it falls back to a Wi-Fi/cell fix and then
/// to a position the device read in the last [maxLastKnownAge].
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
    final preciseLimit = timeout * 0.6;
    final position =
        await _read(LocationAccuracy.high, preciseLimit) ??
        await _read(LocationAccuracy.medium, timeout - preciseLimit) ??
        await _recentLastKnown();
    if (position == null) {
      return const LocationOutcome.failed(LocationFailure.unavailable);
    }
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
    return const LocationOutcome.failed(LocationFailure.unavailable);
  }
}

/// One position read. Null on timeout, no signal or a missing platform
/// declaration (PermissionDefinitionsNotFoundException). Location being
/// switched off or permission being refused still throw, so the caller can
/// say why.
Future<Position?> _read(LocationAccuracy accuracy, Duration limit) async {
  try {
    return await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: accuracy, timeLimit: limit),
    );
  } on LocationServiceDisabledException {
    rethrow;
  } on PermissionDeniedException {
    rethrow;
  } catch (_) {
    return null;
  }
}

Future<Position?> _recentLastKnown() async {
  try {
    final last = await Geolocator.getLastKnownPosition();
    if (last == null) return null;
    final age = DateTime.now().difference(last.timestamp);
    // abs(): a fix stamped slightly ahead of the phone clock is still fresh.
    return age.abs() > maxLastKnownAge ? null : last;
  } catch (_) {
    // Not supported on web, or nothing remembered.
    return null;
  }
}

Future<bool> geolocatorOpenSettingsFor(LocationFailure failure) async {
  try {
    // No fix with location on and allowed: the location settings screen is
    // where Android turns on Wi-Fi/cell positioning (Location Accuracy).
    return switch (failure) {
      LocationFailure.serviceDisabled ||
      LocationFailure.unavailable => await Geolocator.openLocationSettings(),
      LocationFailure.denied ||
      LocationFailure.deniedForever => await Geolocator.openAppSettings(),
    };
  } catch (_) {
    return false;
  }
}
