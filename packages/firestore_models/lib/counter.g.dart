// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CounterImpl _$$CounterImplFromJson(Map<String, dynamic> json) =>
    _$CounterImpl(
      id: (json['id'] as num?)?.toInt(),
      businessId: (json['businessId'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      receiptType: json['receiptType'] as String?,
      totRcptNo: (json['totRcptNo'] as num?)?.toInt(),
      curRcptNo: (json['curRcptNo'] as num?)?.toInt(),
      invcNo: (json['invcNo'] as num?)?.toInt(),
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
    );

const _$$CounterImplFieldMap = <String, String>{
  'id': 'id',
  'businessId': 'businessId',
  'branchId': 'branchId',
  'receiptType': 'receiptType',
  'totRcptNo': 'totRcptNo',
  'curRcptNo': 'curRcptNo',
  'invcNo': 'invcNo',
  'lastTouched': 'lastTouched',
};

// ignore: unused_element
abstract class _$$CounterImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? receiptType(String? instance) => instance;
  // ignore: unused_element
  static Object? totRcptNo(int? instance) => instance;
  // ignore: unused_element
  static Object? curRcptNo(int? instance) => instance;
  // ignore: unused_element
  static Object? invcNo(int? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$$CounterImplToJson(_$CounterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'branchId': instance.branchId,
      'receiptType': instance.receiptType,
      'totRcptNo': instance.totRcptNo,
      'curRcptNo': instance.curRcptNo,
      'invcNo': instance.invcNo,
      'lastTouched': instance.lastTouched?.toIso8601String(),
    };
