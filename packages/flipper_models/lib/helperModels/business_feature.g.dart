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
    );

Map<String, dynamic> _$BusinessFeatureToJson(BusinessFeature instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'businessId': instance.businessId,
      'features': instance.features,
    };
