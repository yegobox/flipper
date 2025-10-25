import 'dart:math' as math;
import 'package:json_annotation/json_annotation.dart';

part 'challenge_code.g.dart';

/// Represents a reward for a challenge code
@JsonSerializable()
class Reward {
  final String type;
  final String value;
  final double? discountAmount;

  const Reward({
    required this.type,
    required this.value,
    this.discountAmount,
  });

  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);

  Map<String, dynamic> toJson() => _$RewardToJson(this);
}

/// Represents a challenge code used for location-based challenges
/// This model is used with Ditto for real-time synchronization
@JsonSerializable()
class ChallengeCode {
  final String id;
  final String code;
  final String businessId;
  final Reward? reward;
  final DateTime validFrom;
  final DateTime validTo;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final int usageCount;
  final int maxUsage;
  final String? description;
  final Map<String, dynamic>? metadata;

  const ChallengeCode({
    required this.id,
    required this.code,
    required this.businessId,
    this.reward,
    required this.validFrom,
    required this.validTo,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.usageCount = 0,
    this.maxUsage = 100,
    this.description,
    this.metadata,
  });

  factory ChallengeCode.fromJson(Map<String, dynamic> json) =>
      _$ChallengeCodeFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeCodeToJson(this);

  /// Get latitude from metadata.location
  double? get latitude => metadata?['location']?['latitude'] as double?;

  /// Get longitude from metadata.location
  double? get longitude => metadata?['location']?['longitude'] as double?;

  /// Get radius from metadata.location
  double? get radius => metadata?['location']?['radius'] as double?;

  /// Check if the challenge code is currently valid
  bool get isValid {
    final now = DateTime.now();
    return isActive && now.isAfter(validFrom) && now.isBefore(validTo);
  }

  /// Check if a location is within the challenge radius
  bool isLocationWithinRadius(double lat, double lng) {
    final challengeLat = latitude;
    final challengeLng = longitude;
    final challengeRadius = radius;
    if (challengeLat == null ||
        challengeLng == null ||
        challengeRadius == null) {
      return false;
    }
    // Simple distance calculation (Haversine formula approximation)
    const double earthRadius = 6371000; // meters
    final double dLat = (lat - challengeLat) * (math.pi / 180);
    final double dLng = (lng - challengeLng) * (math.pi / 180);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(challengeLat * math.pi / 180) *
            math.cos(lat * math.pi / 180) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double distance = earthRadius * c;

    return distance <= challengeRadius;
  }
}
