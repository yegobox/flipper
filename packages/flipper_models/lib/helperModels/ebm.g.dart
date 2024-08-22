// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ebm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EBM _$EBMFromJson(Map<String, dynamic> json) => EBM(
      action: json['action'] as String,
      bhfId: json['bhfId'] as String,
      tinNumber: json['tinNumber'] as int,
      dvcSrlNo: json['dvcSrlNo'] as String,
      userId: json['userId'] as int,
      businessId: json['businessId'] as int,
      branchId: json['branchId'] as int,
      taxServerUrl: json['taxServerUrl'] as String?,
    )
      ..id = json['id'] as int?
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String)
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String);

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
