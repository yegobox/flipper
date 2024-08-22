// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IPin _$IPinFromJson(Map<String, dynamic> json) => IPin(
      id: json['id'] as int?,
      userId: json['userId'] as String,
      phoneNumber: json['phoneNumber'] as String,
      pin: json['pin'] as int,
      branchId: json['branchId'] as int,
      businessId: json['businessId'] as int,
    );

Map<String, dynamic> _$IPinToJson(IPin instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'phoneNumber': instance.phoneNumber,
      'pin': instance.pin,
      'branchId': instance.branchId,
      'businessId': instance.businessId,
    };
