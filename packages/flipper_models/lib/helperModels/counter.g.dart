// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICounter _$ICounterFromJson(Map<String, dynamic> json) => ICounter(
      id: json['id'] as int?,
      businessId: json['businessId'] as int,
      branchId: json['branchId'] as int,
      receiptType: json['receiptType'] as String,
      totRcptNo: json['totRcptNo'] as int,
      curRcptNo: json['curRcptNo'] as int,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      action: json['action'] as String? ?? "created",
    )..deletedAt = json['deletedAt'] == null
        ? null
        : DateTime.parse(json['deletedAt'] as String);

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
