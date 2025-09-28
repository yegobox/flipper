import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/models.dart';

/// Service for handling location-based proximity detection
class LocationService {
  /// Check if location permissions are granted
  Future<bool> checkLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Request location permissions
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// Get current device position
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        final granted = await requestLocationPermission();
        if (!granted) return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  /// Calculate distance between two points using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Earth's radius in meters

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Check if user is within range of a challenge code's location constraint
  Future<bool> isWithinRange(ChallengeCode challengeCode) async {
    // If no location constraint, consider it always in range
    if (challengeCode.location == null) return true;

    final currentPosition = await getCurrentPosition();
    if (currentPosition == null) return false;

    final distance = calculateDistance(
      currentPosition.latitude,
      currentPosition.longitude,
      challengeCode.location!.lat,
      challengeCode.location!.lng,
    );

    return distance <= challengeCode.location!.radiusMeters;
  }

  /// Check if user is within range of multiple challenge codes
  Future<List<ChallengeCode>> filterNearbyChallenges(
    List<ChallengeCode> challenges,
  ) async {
    final nearbyChallenges = <ChallengeCode>[];

    for (final challenge in challenges) {
      if (await isWithinRange(challenge)) {
        nearbyChallenges.add(challenge);
      }
    }

    return nearbyChallenges;
  }

  /// Start location monitoring for proximity detection
  Stream<Position> startLocationMonitoring() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }
}
