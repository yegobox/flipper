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
