// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IITenant _$IITenantFromJson(Map<String, dynamic> json) => IITenant(
      id: json['id'] as int?,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      nfcEnabled: json['nfcEnabled'] as bool,
      businessId: json['businessId'] as int,
      userId: json['userId'] as int,
      isDefault: json['isDefault'] as bool,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      sessionActive: json['sessionActive'] as bool?,
      isLongPressed: json['isLongPressed'] as bool? ?? false,
      pin: json['pin'] as int?,
    )
      ..action = json['action'] as String
      ..imageUrl = json['imageUrl'] as String?
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String);

Map<String, dynamic> _$IITenantToJson(IITenant instance) => <String, dynamic>{
      'action': instance.action,
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'nfcEnabled': instance.nfcEnabled,
      'businessId': instance.businessId,
      'userId': instance.userId,
      'imageUrl': instance.imageUrl,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'pin': instance.pin,
      'sessionActive': instance.sessionActive,
      'isDefault': instance.isDefault,
      'isLongPressed': instance.isLongPressed,
    };
