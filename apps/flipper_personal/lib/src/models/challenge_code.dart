import 'package:uuid/uuid.dart';

/// Represents a challenge code created by a business for proximity-based claiming
class ChallengeCode {
  final String id;
  final String businessId;
  final String code;
  final Reward? reward;
  final DateTime validFrom;
  final DateTime validTo;
  final LocationConstraint? location;
  final DateTime createdAt;

  ChallengeCode({
    String? id,
    required this.businessId,
    required this.code,
    this.reward,
    required this.validFrom,
    required this.validTo,
    this.location,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  /// Creates a ChallengeCode from a JSON map (for Ditto storage)
  factory ChallengeCode.fromJson(Map<String, dynamic> json) {
    return ChallengeCode(
      id: json['_id'] as String? ?? json['id'] as String,
      businessId: json['businessId'] as String,
      code: json['code'] as String,
      reward: json['reward'] != null ? Reward.fromJson(json['reward']) : null,
      validFrom: DateTime.parse(json['validFrom'] as String),
      validTo: DateTime.parse(json['validTo'] as String),
      location: json['location'] != null
          ? LocationConstraint.fromJson(json['location'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Converts the ChallengeCode to a JSON map (for Ditto storage)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'businessId': businessId,
      'code': code,
      'reward': reward?.toJson(),
      'validFrom': validFrom.toIso8601String(),
      'validTo': validTo.toIso8601String(),
      'location': location?.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Checks if the challenge code is currently valid
  bool get isValid {
    final now = DateTime.now();
    return now.isAfter(validFrom) && now.isBefore(validTo);
  }

  /// Creates a copy with updated fields
  ChallengeCode copyWith({
    String? id,
    String? businessId,
    String? code,
    Reward? reward,
    DateTime? validFrom,
    DateTime? validTo,
    LocationConstraint? location,
    DateTime? createdAt,
  }) {
    return ChallengeCode(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      code: code ?? this.code,
      reward: reward ?? this.reward,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ChallengeCode(id: $id, businessId: $businessId, code: $code, isValid: $isValid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChallengeCode && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents a reward that can be claimed with a challenge code
class Reward {
  final String type; // 'coupon', 'points', 'badge'
  final String value; // e.g., '10% off', '100 points', 'Gold Badge'

  const Reward({required this.type, required this.value});

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(type: json['type'] as String, value: json['value'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'value': value};
  }

  @override
  String toString() => '$type: $value';
}

/// Represents location constraints for challenge codes
class LocationConstraint {
  final double lat;
  final double lng;
  final double radiusMeters;

  const LocationConstraint({
    required this.lat,
    required this.lng,
    required this.radiusMeters,
  });

  factory LocationConstraint.fromJson(Map<String, dynamic> json) {
    return LocationConstraint(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      radiusMeters: (json['radiusMeters'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng, 'radiusMeters': radiusMeters};
  }

  @override
  String toString() {
    return 'Location($lat, $lng, radius: ${radiusMeters}m)';
  }
}
