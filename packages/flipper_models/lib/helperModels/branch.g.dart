// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IBranch _$IBranchFromJson(Map<String, dynamic> json) => IBranch(
      isDefault: json['isDefault'] as bool,
      id: (json['id'] as num?)?.toInt(),
      active: json['active'] as bool?,
      description: json['description'] as String?,
      name: json['name'] as String?,
      businessId: (json['businessId'] as num?)?.toInt(),
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      location: json['location'] as String?,
    )
      ..action = json['action'] as String
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String);

const _$IBranchFieldMap = <String, String>{
  'action': 'action',
  'id': 'id',
  'active': 'active',
  'description': 'description',
  'name': 'name',
  'businessId': 'businessId',
  'longitude': 'longitude',
  'latitude': 'latitude',
  'location': 'location',
  'isDefault': 'isDefault',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
};

// ignore: unused_element
abstract class _$IBranchPerFieldToJson {
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? active(bool? instance) => instance;
  // ignore: unused_element
  static Object? description(String? instance) => instance;
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? longitude(String? instance) => instance;
  // ignore: unused_element
  static Object? latitude(String? instance) => instance;
  // ignore: unused_element
  static Object? location(String? instance) => instance;
  // ignore: unused_element
  static Object? isDefault(bool instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$IBranchToJson(IBranch instance) => <String, dynamic>{
      'action': instance.action,
      'id': instance.id,
      'active': instance.active,
      'description': instance.description,
      'name': instance.name,
      'businessId': instance.businessId,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'location': instance.location,
      'isDefault': instance.isDefault,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
