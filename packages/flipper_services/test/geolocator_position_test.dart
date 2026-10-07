import 'package:flipper_services/abstractions/location.dart';
import 'package:flipper_services/geolocator_position.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// Scripted geolocator: what the device reports, and what was asked of it.
class _FakeGeolocator extends GeolocatorPlatform
    with MockPlatformInterfaceMixin {
  bool serviceEnabled = true;
  LocationPermission permission = LocationPermission.whileInUse;
  LocationPermission answerToRequest = LocationPermission.whileInUse;
  Object? positionError;
  int requests = 0;
  int appSettingsOpened = 0;
  int locationSettingsOpened = 0;

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async {
    requests++;
    return answerToRequest;
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    if (positionError != null) throw positionError!;
    return Position(
      latitude: -1.9441,
      longitude: 30.0619,
      timestamp: DateTime(2026),
      accuracy: 5,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  @override
  Future<bool> openAppSettings() async {
    appSettingsOpened++;
    return true;
  }

  @override
  Future<bool> openLocationSettings() async {
    locationSettingsOpened++;
    return true;
  }
}

void main() {
  late _FakeGeolocator geo;

  setUp(() {
    geo = _FakeGeolocator();
    GeolocatorPlatform.instance = geo;
  });

  Future<LocationOutcome> read() =>
      geolocatorCurrentPosition(timeout: const Duration(seconds: 1));

  test('returns the fix when permission is granted', () async {
    final outcome = await read();
    expect(outcome.hasFix, isTrue);
    expect(outcome.latitude, -1.9441);
    expect(outcome.longitude, 30.0619);
    expect(geo.requests, 0);
  });

  test('asks once when not yet decided, and uses the answer', () async {
    geo.permission = LocationPermission.denied;
    expect((await read()).hasFix, isTrue);
    expect(geo.requests, 1);
  });

  test('reports a refused dialog as denied', () async {
    geo
      ..permission = LocationPermission.denied
      ..answerToRequest = LocationPermission.denied;
    expect((await read()).failure, LocationFailure.denied);
  });

  test('reports "never ask again" as deniedForever without asking', () async {
    geo.permission = LocationPermission.deniedForever;
    expect((await read()).failure, LocationFailure.deniedForever);
    expect(geo.requests, 0);
  });

  test('reports location switched off before asking for permission', () async {
    geo.serviceEnabled = false;
    expect((await read()).failure, LocationFailure.serviceDisabled);
    expect(geo.requests, 0);
  });

  test('maps thrown platform errors', () async {
    geo.positionError = const PermissionDeniedException('refused');
    expect((await read()).failure, LocationFailure.denied);

    geo.positionError = const LocationServiceDisabledException();
    expect((await read()).failure, LocationFailure.serviceDisabled);

    geo.positionError = const PermissionDefinitionsNotFoundException('none');
    expect((await read()).failure, LocationFailure.unavailable);
  });

  test('opens the settings screen that fixes the failure', () async {
    await geolocatorOpenSettingsFor(LocationFailure.serviceDisabled);
    expect(geo.locationSettingsOpened, 1);

    await geolocatorOpenSettingsFor(LocationFailure.deniedForever);
    await geolocatorOpenSettingsFor(LocationFailure.denied);
    expect(geo.appSettingsOpened, 2);
  });
}
