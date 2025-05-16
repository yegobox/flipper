// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICustomer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICustomer _$ICustomerFromJson(Map<String, dynamic> json) => ICustomer(
      id: json['id'] as String?,
      custNm: json['custNm'] as String?,
      email: json['email'] as String?,
      telNo: json['telNo'] as String?,
      adrs: json['adrs'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      custNo: json['custNo'] as String?,
      custTin: json['custTin'] as String?,
      regrNm: json['regrNm'] as String?,
      regrId: json['regrId'] as String?,
      modrNm: json['modrNm'] as String?,
      modrId: json['modrId'] as String?,
      ebmSynced: json['ebmSynced'] as bool? ?? false,
      action: json['action'] as String?,
      tin: (json['tin'] as num?)?.toInt(),
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
      'custNo': instance.custNo,
      'custTin': instance.custTin,
      'regrNm': instance.regrNm,
      'regrId': instance.regrId,
      'modrNm': instance.modrNm,
      'modrId': instance.modrId,
      'ebmSynced': instance.ebmSynced,
      'action': instance.action,
      'tin': instance.tin,
      'bhfId': instance.bhfId,
      'useYn': instance.useYn,
      'customerType': instance.customerType,
    };
