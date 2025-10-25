import 'dart:async';
import 'dart:math' as math;
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_models/models/challenge_code.dart';
import 'package:flipper_models/models/claim.dart';

/// Service for managing challenge codes and claims
class ChallengeService {
  final DittoService _dittoService;

  ChallengeService(this._dittoService);

  /// Stream of available challenge codes (for providers that don't have location context)
  Stream<List<ChallengeCode>> get availableChallengeCodes {
    // Return all valid challenge codes without location filtering
    return _dittoService.observeChallengeCodes().map((challengeMaps) {
      return challengeMaps
          .map((map) {
            try {
              return ChallengeCode.fromJson(map);
            } catch (e) {
              return null;
            }
          })
          .whereType<ChallengeCode>()
          .toList();
    });
  }

  /// Get nearby challenges for a specific location
  Stream<List<ChallengeCode>> getNearbyChallenges(
    double latitude,
    double longitude,
  ) {
    return _dittoService.observeChallengeCodes().map((challengeMaps) {
      final challengeCodes = challengeMaps
          .map((map) {
            try {
              return ChallengeCode.fromJson(map);
            } catch (e) {
              return null;
            }
          })
          .whereType<ChallengeCode>()
          .toList();

      // Filter by location in Dart code
      return challengeCodes.where((challenge) {
        final lat = challenge.latitude;
        final lng = challenge.longitude;
        final rad = challenge.radius;
        if (lat == null || lng == null || rad == null) return false;

        final distance = _calculateDistance(latitude, longitude, lat, lng);

        return distance <= rad;
      }).toList();
    });
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

  /// Get claims for a specific user
  Future<List<Claim>> getClaimsForUser(String userId) async {
    try {
      final claimMaps = await _dittoService.getClaimsForUser(userId);
      return claimMaps.map((map) => Claim.fromJson(map)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get challenge codes for a business
  Future<List<ChallengeCode>> getChallengeCodesForBusiness(
    String businessId,
  ) async {
    try {
      final challengeMaps = await _dittoService.getChallengeCodes(
        businessId: businessId,
      );
      return challengeMaps.map((map) => ChallengeCode.fromJson(map)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Claim a challenge code for a user
  Future<bool> claimChallengeCode(String userId, String challengeCodeId) async {
    try {
      // Check if already claimed
      final alreadyClaimed = await _dittoService.isChallengeCodeClaimed(
        userId,
        challengeCodeId,
      );
      if (alreadyClaimed) {
        return false; // Already claimed
      }

      // Create claim
      final claim = {
        'id':
            '${userId}_${challengeCodeId}_${DateTime.now().millisecondsSinceEpoch}',
        'userId': userId,
        'challengeCodeId': challengeCodeId,
        'claimedAt': DateTime.now().toIso8601String(),
        'status': 'claimed',
      };

      await _dittoService.saveClaim(claim);
      return true;
    } catch (e) {
      return false;
    }
  }
}
