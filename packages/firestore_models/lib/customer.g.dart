// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerImpl _$$CustomerImplFromJson(Map<String, dynamic> json) =>
    _$CustomerImpl(
      id: (json['id'] as num?)?.toInt(),
      custNm: json['custNm'] as String?,
      email: json['email'] as String?,
      telNo: json['telNo'] as String?,
      adrs: json['adrs'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      custNo: json['custNo'] as String?,
      custTin: json['custTin'] as String?,
      regrNm: json['regrNm'] as String?,
      regrId: json['regrId'] as String?,
      modrNm: json['modrNm'] as String? ?? "284746303937",
      modrId: json['modrId'] as String?,
      ebmSynced: json['ebmSynced'] as bool? ?? false,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      tin: (json['tin'] as num?)?.toInt(),
      bhfId: json['bhfId'] as String?,
      useYn: json['useYn'] as String?,
      customerType: json['customerType'] as String?,
    );

const _$$CustomerImplFieldMap = <String, String>{
  'id': 'id',
  'custNm': 'custNm',
  'email': 'email',
  'telNo': 'telNo',
  'adrs': 'adrs',
  'branchId': 'branchId',
  'updatedAt': 'updatedAt',
  'custNo': 'custNo',
  'custTin': 'custTin',
  'regrNm': 'regrNm',
  'regrId': 'regrId',
  'modrNm': 'modrNm',
  'modrId': 'modrId',
  'ebmSynced': 'ebmSynced',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
  'tin': 'tin',
  'bhfId': 'bhfId',
  'useYn': 'useYn',
  'customerType': 'customerType',
};

// ignore: unused_element
abstract class _$$CustomerImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? custNm(String? instance) => instance;
  // ignore: unused_element
  static Object? email(String? instance) => instance;
  // ignore: unused_element
  static Object? telNo(String? instance) => instance;
  // ignore: unused_element
  static Object? adrs(String? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? updatedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? custNo(String? instance) => instance;
  // ignore: unused_element
  static Object? custTin(String? instance) => instance;
  // ignore: unused_element
  static Object? regrNm(String? instance) => instance;
  // ignore: unused_element
  static Object? regrId(String? instance) => instance;
  // ignore: unused_element
  static Object? modrNm(String instance) => instance;
  // ignore: unused_element
  static Object? modrId(String? instance) => instance;
  // ignore: unused_element
  static Object? ebmSynced(bool instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? tin(int? instance) => instance;
  // ignore: unused_element
  static Object? bhfId(String? instance) => instance;
  // ignore: unused_element
  static Object? useYn(String? instance) => instance;
  // ignore: unused_element
  static Object? customerType(String? instance) => instance;
}

Map<String, dynamic> _$$CustomerImplToJson(_$CustomerImpl instance) =>
    <String, dynamic>{
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
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'tin': instance.tin,
      'bhfId': instance.bhfId,
      'useYn': instance.useYn,
      'customerType': instance.customerType,
    };
