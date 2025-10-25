// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reward _$RewardFromJson(Map<String, dynamic> json) => Reward(
      type: json['type'] as String,
      value: json['value'] as String,
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RewardToJson(Reward instance) => <String, dynamic>{
      'type': instance.type,
      'value': instance.value,
      'discountAmount': instance.discountAmount,
    };

ChallengeCode _$ChallengeCodeFromJson(Map<String, dynamic> json) =>
    ChallengeCode(
      id: json['id'] as String,
      code: json['code'] as String,
      businessId: json['businessId'] as String,
      reward: json['reward'] == null
          ? null
          : Reward.fromJson(json['reward'] as Map<String, dynamic>),
      validFrom: DateTime.parse(json['validFrom'] as String),
      validTo: DateTime.parse(json['validTo'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
      maxUsage: (json['maxUsage'] as num?)?.toInt() ?? 100,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ChallengeCodeToJson(ChallengeCode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'businessId': instance.businessId,
      'reward': instance.reward,
      'validFrom': instance.validFrom.toIso8601String(),
      'validTo': instance.validTo.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isActive': instance.isActive,
      'usageCount': instance.usageCount,
      'maxUsage': instance.maxUsage,
      'description': instance.description,
      'metadata': instance.metadata,
    };
