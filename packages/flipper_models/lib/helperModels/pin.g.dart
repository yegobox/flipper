// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IPin _$IPinFromJson(Map<String, dynamic> json) => IPin(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      phoneNumber: json['phone_number'] as String,
      pin: (json['pin'] as num).toInt(),
      branchId: (json['branch_id'] as num).toInt(),
      businessId: (json['business_id'] as num).toInt(),
      ownerName: json['owner_name'] as String?,
      tokenUid: json['token_uid'] as String?,
    );

Map<String, dynamic> _$IPinToJson(IPin instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'phone_number': instance.phoneNumber,
      'pin': instance.pin,
      'branch_id': instance.branchId,
      'business_id': instance.businessId,
      'owner_name': instance.ownerName,
      'token_uid': instance.tokenUid,
    };
