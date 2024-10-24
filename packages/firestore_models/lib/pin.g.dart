// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PinImpl _$$PinImplFromJson(Map<String, dynamic> json) => _$PinImpl(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      phoneNumber: json['phoneNumber'] as String?,
      pin: (json['pin'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      businessId: (json['businessId'] as num?)?.toInt(),
      ownerName: json['ownerName'] as String?,
      tokenUid: json['tokenUid'] as String?,
      uid: json['uid'] as String?,
    );

const _$$PinImplFieldMap = <String, String>{
  'id': 'id',
  'userId': 'userId',
  'phoneNumber': 'phoneNumber',
  'pin': 'pin',
  'branchId': 'branchId',
  'businessId': 'businessId',
  'ownerName': 'ownerName',
  'tokenUid': 'tokenUid',
  'uid': 'uid',
};

// ignore: unused_element
abstract class _$$PinImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? userId(int? instance) => instance;
  // ignore: unused_element
  static Object? phoneNumber(String? instance) => instance;
  // ignore: unused_element
  static Object? pin(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? ownerName(String? instance) => instance;
  // ignore: unused_element
  static Object? tokenUid(String? instance) => instance;
  // ignore: unused_element
  static Object? uid(String? instance) => instance;
}

Map<String, dynamic> _$$PinImplToJson(_$PinImpl instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'phoneNumber': instance.phoneNumber,
      'pin': instance.pin,
      'branchId': instance.branchId,
      'businessId': instance.businessId,
      'ownerName': instance.ownerName,
      'tokenUid': instance.tokenUid,
      'uid': instance.uid,
    };
