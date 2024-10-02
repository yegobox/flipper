// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICounter _$ICounterFromJson(Map<String, dynamic> json) => ICounter(
      id: (json['id'] as num?)?.toInt(),
      businessId: (json['businessId'] as num).toInt(),
      branchId: (json['branchId'] as num).toInt(),
      receiptType: json['receiptType'] as String,
      totRcptNo: (json['totRcptNo'] as num).toInt(),
      curRcptNo: (json['curRcptNo'] as num).toInt(),
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      action: json['action'] as String? ?? "created",
    )..deletedAt = json['deletedAt'] == null
        ? null
        : DateTime.parse(json['deletedAt'] as String);

const _$ICounterFieldMap = <String, String>{
  'deletedAt': 'deletedAt',
  'id': 'id',
  'businessId': 'businessId',
  'branchId': 'branchId',
  'receiptType': 'receiptType',
  'totRcptNo': 'totRcptNo',
  'curRcptNo': 'curRcptNo',
  'lastTouched': 'lastTouched',
  'action': 'action',
};

// ignore: unused_element
abstract class _$ICounterPerFieldToJson {
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int instance) => instance;
  // ignore: unused_element
  static Object? branchId(int instance) => instance;
  // ignore: unused_element
  static Object? receiptType(String instance) => instance;
  // ignore: unused_element
  static Object? totRcptNo(int instance) => instance;
  // ignore: unused_element
  static Object? curRcptNo(int instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? action(String instance) => instance;
}

Map<String, dynamic> _$ICounterToJson(ICounter instance) => <String, dynamic>{
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'id': instance.id,
      'businessId': instance.businessId,
      'branchId': instance.branchId,
      'receiptType': instance.receiptType,
      'totRcptNo': instance.totRcptNo,
      'curRcptNo': instance.curRcptNo,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'action': instance.action,
    };
