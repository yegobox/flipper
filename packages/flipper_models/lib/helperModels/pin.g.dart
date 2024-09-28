// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IPin _$IPinFromJson(Map<String, dynamic> json) => IPin(
      id: (json['id'] as num?)?.toInt(),
      userId: json['userId'] as String,
      phoneNumber: json['phoneNumber'] as String,
      pin: (json['pin'] as num).toInt(),
      branchId: (json['branchId'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
    );

Map<String, dynamic> _$IPinToJson(IPin instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'phoneNumber': instance.phoneNumber,
      'pin': instance.pin,
      'branchId': instance.branchId,
      'businessId': instance.businessId,
    };
