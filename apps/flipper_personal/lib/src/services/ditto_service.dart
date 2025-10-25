import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flipper_models/models/challenge_code.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';

class DittoService {
  Stream<List<ChallengeCode>> getNearbyChallenges(
    double latitude,
    double longitude,
  ) {
    final controller = StreamController<List<ChallengeCode>>.broadcast();
    dynamic observer;

    // Ensure Ditto is ready
    if (!ProxyService.ditto.isReady()) {
      ProxyService.ditto.startSync();
    }

    try {
      // Register observer for real-time updates of all challenge codes
      // Since Ditto doesn't support spatial queries, we'll fetch all and filter in Dart
      observer = ProxyService.ditto.store!.registerObserver(
        """
        SELECT * FROM challengeCodes
        WHERE validTo > :now AND validFrom < :now
        """,
        arguments: {"now": DateTime.now().toIso8601String()},
        onChange: (queryResult) {
          if (controller.isClosed) return;

          final allChallengeCodes = queryResult.items
              .map((doc) {
                try {
                  return ChallengeCode.fromJson(
                    jsonDecode(jsonEncode(doc.value)),
                  );
                } catch (e) {
                  debugPrint('Error parsing challenge code: $e');
                  return null;
                }
              })
              .whereType<ChallengeCode>()
              .toList();

          // Filter by location in Dart code
          final nearbyChallenges = allChallengeCodes.where((
            ChallengeCode challenge,
          ) {
            final lat = challenge.latitude;
            final lng = challenge.longitude;
            final rad = challenge.radius;
            if (lat == null || lng == null || rad == null) return false;

            final distance = _calculateDistance(latitude, longitude, lat, lng);

            return distance <= rad;
          }).toList();

          controller.add(nearbyChallenges);
        },
      );

      // Handle stream cancellation
      controller.onCancel = () async {
        await observer?.cancel();
        await controller.close();
      };
    } catch (e) {
      debugPrint('Error setting up challenge codes observer: $e');
      controller.addError(e);
    }

    return controller.stream;
  }

  /// Calculate distance between two points using Haversine formula
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // Earth's radius in meters

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }
}
