// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BranchImpl _$$BranchImplFromJson(Map<String, dynamic> json) => _$BranchImpl(
      id: (json['id'] as num?)?.toInt(),
      serverId: (json['serverId'] as num?)?.toInt(),
      active: json['active'] as bool?,
      description: json['description'] as String?,
      name: json['name'] as String?,
      businessId: (json['businessId'] as num?)?.toInt(),
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      location: json['location'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isOnline: json['isOnline'] as bool? ?? false,
    );

const _$$BranchImplFieldMap = <String, String>{
  'id': 'id',
  'serverId': 'serverId',
  'active': 'active',
  'description': 'description',
  'name': 'name',
  'businessId': 'businessId',
  'longitude': 'longitude',
  'latitude': 'latitude',
  'location': 'location',
  'isDefault': 'isDefault',
  'isOnline': 'isOnline',
};

// ignore: unused_element
abstract class _$$BranchImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? serverId(int? instance) => instance;
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
  static Object? isOnline(bool instance) => instance;
}

Map<String, dynamic> _$$BranchImplToJson(_$BranchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serverId': instance.serverId,
      'active': instance.active,
      'description': instance.description,
      'name': instance.name,
      'businessId': instance.businessId,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'location': instance.location,
      'isDefault': instance.isDefault,
      'isOnline': instance.isOnline,
    };
