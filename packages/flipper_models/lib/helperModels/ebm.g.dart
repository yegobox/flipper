// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ebm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EBM _$EBMFromJson(Map<String, dynamic> json) => EBM(
      action: json['action'] as String,
      bhfId: json['bhfId'] as String,
      tinNumber: (json['tinNumber'] as num).toInt(),
      dvcSrlNo: json['dvcSrlNo'] as String,
      userId: (json['userId'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      branchId: (json['branchId'] as num).toInt(),
      taxServerUrl: json['taxServerUrl'] as String?,
    )
      ..id = (json['id'] as num?)?.toInt()
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String)
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String);

const _$EBMFieldMap = <String, String>{
  'id': 'id',
  'bhfId': 'bhfId',
  'tinNumber': 'tinNumber',
  'dvcSrlNo': 'dvcSrlNo',
  'userId': 'userId',
  'taxServerUrl': 'taxServerUrl',
  'businessId': 'businessId',
  'branchId': 'branchId',
  'lastTouched': 'lastTouched',
  'action': 'action',
  'deletedAt': 'deletedAt',
};

// ignore: unused_element
abstract class _$EBMPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? bhfId(String instance) => instance;
  // ignore: unused_element
  static Object? tinNumber(int instance) => instance;
  // ignore: unused_element
  static Object? dvcSrlNo(String instance) => instance;
  // ignore: unused_element
  static Object? userId(int instance) => instance;
  // ignore: unused_element
  static Object? taxServerUrl(String? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int instance) => instance;
  // ignore: unused_element
  static Object? branchId(int instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$EBMToJson(EBM instance) => <String, dynamic>{
      'id': instance.id,
      'bhfId': instance.bhfId,
      'tinNumber': instance.tinNumber,
      'dvcSrlNo': instance.dvcSrlNo,
      'userId': instance.userId,
      'taxServerUrl': instance.taxServerUrl,
      'businessId': instance.businessId,
      'branchId': instance.branchId,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'action': instance.action,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
