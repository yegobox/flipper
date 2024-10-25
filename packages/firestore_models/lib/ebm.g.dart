// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ebm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EBMImpl _$$EBMImplFromJson(Map<String, dynamic> json) => _$EBMImpl(
      id: (json['id'] as num?)?.toInt(),
      bhfId: json['bhfId'] as String,
      tinNumber: (json['tinNumber'] as num).toInt(),
      dvcSrlNo: json['dvcSrlNo'] as String,
      userId: (json['userId'] as num).toInt(),
      taxServerUrl: json['taxServerUrl'] as String?,
      businessId: (json['businessId'] as num).toInt(),
      branchId: (json['branchId'] as num).toInt(),
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      action: json['action'] as String,
    );

const _$$EBMImplFieldMap = <String, String>{
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
};

// ignore: unused_element
abstract class _$$EBMImplPerFieldToJson {
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
}

Map<String, dynamic> _$$EBMImplToJson(_$EBMImpl instance) => <String, dynamic>{
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
    };
