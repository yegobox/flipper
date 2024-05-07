// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICustomer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICustomer _$ICustomerFromJson(Map<String, dynamic> json) => ICustomer(
      id: json['id'] as int?,
      custNm: json['custNm'] as String?,
      email: json['email'] as String?,
      telNo: json['telNo'] as String?,
      adrs: json['adrs'] as String?,
      branchId: json['branchId'] as int?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      custNo: json['custNo'] as String?,
      custTin: json['custTin'] as String?,
      regrNm: json['regrNm'] as String?,
      regrId: json['regrId'] as String?,
      modrNm: json['modrNm'] as String?,
      modrId: json['modrId'] as String?,
      ebmSynced: json['ebmSynced'] as bool? ?? false,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      action: json['action'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      tin: json['tin'] as int?,
      bhfId: json['bhfId'] as String?,
      useYn: json['useYn'] as String?,
      customerType: json['customerType'] as String?,
    );

Map<String, dynamic> _$ICustomerToJson(ICustomer instance) => <String, dynamic>{
      'id': instance.id,
      'custNm': instance.custNm,
      'email': instance.email,
      'telNo': instance.telNo,
      'adrs': instance.adrs,
      'branchId': instance.branchId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'custNo': instance.custNo,
      'custTin': instance.custTin,
      'regrNm': instance.regrNm,
      'regrId': instance.regrId,
      'modrNm': instance.modrNm,
      'modrId': instance.modrId,
      'ebmSynced': instance.ebmSynced,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'action': instance.action,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'tin': instance.tin,
      'bhfId': instance.bhfId,
      'useYn': instance.useYn,
      'customerType': instance.customerType,
    };
