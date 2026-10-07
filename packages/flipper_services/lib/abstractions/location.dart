/// Why [FlipperLocation.currentPosition] could not produce a position.
enum LocationFailure {
  /// Location services are switched off on the device.
  serviceDisabled,

  /// The user refused this time; asking again can still show the dialog.
  denied,

  /// Refused for good (or blocked by policy): the system will not ask again,
  /// so only the settings app can grant it.
  deniedForever,

  /// Permission is fine but no position arrived (timeout, no signal, error).
  unavailable,
}

/// Either a position or the reason there is none.
class LocationOutcome {
  const LocationOutcome.fix({
    required double this.latitude,
    required double this.longitude,
  }) : failure = null;

  const LocationOutcome.failed(LocationFailure this.failure)
    : latitude = null,
      longitude = null;

  final double? latitude;
  final double? longitude;
  final LocationFailure? failure;

  bool get hasFix => failure == null;
}

abstract class FlipperLocation {
  Future<Map<String, String>> getLocations(); //map<longitude,latitude>
  Future<bool> hasLocationPermission();

  /// The device's position, asking for permission when needed. Unlike
  /// [getLocations] a failure says why instead of returning a placeholder.
  Future<LocationOutcome> currentPosition({
    Duration timeout = const Duration(seconds: 20),
  });

  /// Opens the system screen that can fix [failure]: location settings when
  /// location is off, otherwise this app's permission settings. Returns
  /// whether a settings screen opened.
  Future<bool> openSettingsFor(LocationFailure failure);
}
