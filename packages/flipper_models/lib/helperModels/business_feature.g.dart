// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_feature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessFeature _$BusinessFeatureFromJson(Map<String, dynamic> json) =>
    BusinessFeature(
        id: json['_id'] as String,
        businessId: json['businessId'] as String,
        features: (json['features'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
      )
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String)
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..action = json['action'] as String;

Map<String, dynamic> _$BusinessFeatureToJson(BusinessFeature instance) =>
    <String, dynamic>{
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'action': instance.action,
      '_id': instance.id,
      'businessId': instance.businessId,
      'features': instance.features,
    };
