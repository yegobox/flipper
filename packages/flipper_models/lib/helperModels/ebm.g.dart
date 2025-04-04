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
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..id = (json['id'] as num?)?.toInt()
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String);

Map<String, dynamic> _$EBMToJson(EBM instance) => <String, dynamic>{
      'deletedAt': instance.deletedAt?.toIso8601String(),
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
