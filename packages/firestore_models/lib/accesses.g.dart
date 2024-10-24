// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accesses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccessesImpl _$$AccessesImplFromJson(Map<String, dynamic> json) =>
    _$AccessesImpl(
      id: (json['id'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      businessId: (json['businessId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      featureName: json['featureName'] as String?,
      userType: json['userType'] as String?,
      accessLevel: json['accessLevel'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      status: json['status'] as String?,
    );

const _$$AccessesImplFieldMap = <String, String>{
  'id': 'id',
  'branchId': 'branchId',
  'businessId': 'businessId',
  'userId': 'userId',
  'featureName': 'featureName',
  'userType': 'userType',
  'accessLevel': 'accessLevel',
  'createdAt': 'createdAt',
  'expiresAt': 'expiresAt',
  'status': 'status',
};

// ignore: unused_element
abstract class _$$AccessesImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? userId(int? instance) => instance;
  // ignore: unused_element
  static Object? featureName(String? instance) => instance;
  // ignore: unused_element
  static Object? userType(String? instance) => instance;
  // ignore: unused_element
  static Object? accessLevel(String? instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? expiresAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? status(String? instance) => instance;
}

Map<String, dynamic> _$$AccessesImplToJson(_$AccessesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'businessId': instance.businessId,
      'userId': instance.userId,
      'featureName': instance.featureName,
      'userType': instance.userType,
      'accessLevel': instance.accessLevel,
      'createdAt': instance.createdAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'status': instance.status,
    };
