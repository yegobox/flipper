// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IUser _$IUserFromJson(Map<String, dynamic> json) => IUser(
  id: json['id'] as String,
  phoneNumber: json['phone_number'] as String?,
  token: json['token'] as String?,
  uid: json['uid'] as String?,
  businesses: (json['businesses'] as List<dynamic>?)
      ?.map((e) => IBusiness.fromJson(e as Map<String, dynamic>))
      .toList(),
  editId: json['edit_id'] as bool?,
  isExternal: json['is_external'] as bool?,
  ownership: json['ownership'] as String?,
  groupId: json['group_id'] as String?,
  external: json['external'] as bool?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  pin: (json['pin'] as num?)?.toInt(),
);

Map<String, dynamic> _$IUserToJson(IUser instance) => <String, dynamic>{
  'id': instance.id,
  'phone_number': instance.phoneNumber,
  'token': instance.token,
  'uid': instance.uid,
  'businesses': instance.businesses,
  'edit_id': instance.editId,
  'is_external': instance.isExternal,
  'ownership': instance.ownership,
  'group_id': instance.groupId,
  'external': instance.external,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'pin': instance.pin,
};
