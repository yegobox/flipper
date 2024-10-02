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
      ownerName: json['ownerName'] as String,
      tokenUid: json['tokenUid'] as String,
    );

const _$IPinFieldMap = <String, String>{
  'id': 'id',
  'userId': 'userId',
  'phoneNumber': 'phoneNumber',
  'pin': 'pin',
  'branchId': 'branchId',
  'businessId': 'businessId',
  'ownerName': 'ownerName',
  'tokenUid': 'tokenUid',
};

// ignore: unused_element
abstract class _$IPinPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? userId(String instance) => instance;
  // ignore: unused_element
  static Object? phoneNumber(String instance) => instance;
  // ignore: unused_element
  static Object? pin(int instance) => instance;
  // ignore: unused_element
  static Object? branchId(int instance) => instance;
  // ignore: unused_element
  static Object? businessId(int instance) => instance;
  // ignore: unused_element
  static Object? ownerName(String instance) => instance;
  // ignore: unused_element
  static Object? tokenUid(String instance) => instance;
}

Map<String, dynamic> _$IPinToJson(IPin instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'phoneNumber': instance.phoneNumber,
      'pin': instance.pin,
      'branchId': instance.branchId,
      'businessId': instance.businessId,
      'ownerName': instance.ownerName,
      'tokenUid': instance.tokenUid,
    };
