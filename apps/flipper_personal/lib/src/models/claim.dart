import 'package:uuid/uuid.dart';

/// Represents a user's claim of a challenge code
class Claim {
  final String id;
  final String userId;
  final String challengeCodeId;
  final DateTime claimedAt;
  final ClaimStatus status;

  Claim({
    String? id,
    required this.userId,
    required this.challengeCodeId,
    DateTime? claimedAt,
    this.status = ClaimStatus.claimed,
  }) : id = id ?? const Uuid().v4(),
       claimedAt = claimedAt ?? DateTime.now();

  /// Creates a Claim from a JSON map (for Ditto storage)
  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      id: json['_id'] as String? ?? json['id'] as String,
      userId: json['userId'] as String,
      challengeCodeId: json['challengeCodeId'] as String,
      claimedAt: DateTime.parse(json['claimedAt'] as String),
      status: ClaimStatus.values.firstWhere(
        (e) => e.toString() == 'ClaimStatus.${json['status']}',
        orElse: () => ClaimStatus.claimed,
      ),
    );
  }

  /// Converts the Claim to a JSON map (for Ditto storage)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'userId': userId,
      'challengeCodeId': challengeCodeId,
      'claimedAt': claimedAt.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  /// Creates a copy with updated fields
  Claim copyWith({
    String? id,
    String? userId,
    String? challengeCodeId,
    DateTime? claimedAt,
    ClaimStatus? status,
  }) {
    return Claim(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      challengeCodeId: challengeCodeId ?? this.challengeCodeId,
      claimedAt: claimedAt ?? this.claimedAt,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Claim(id: $id, userId: $userId, challengeCodeId: $challengeCodeId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Claim && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Status of a claim
enum ClaimStatus {
  claimed, // User has claimed the reward
  redeemed, // User has redeemed/used the reward
}
