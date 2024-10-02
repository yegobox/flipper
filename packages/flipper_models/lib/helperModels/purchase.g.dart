// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Purchase _$PurchaseFromJson(Map<String, dynamic> json) => Purchase(
      id: (json['id'] as num?)?.toInt(),
      itemIds:
          (json['itemIds'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      action: json['action'] as String,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      tin: json['tin'] as String?,
      bhfId: json['bhfId'] as String?,
      invcNo: (json['invcNo'] as num?)?.toInt(),
      orgInvcNo: (json['orgInvcNo'] as num?)?.toInt(),
      spplrTin: json['spplrTin'] as String?,
      spplrBhfId: json['spplrBhfId'] as String?,
      spplrNm: json['spplrNm'] as String?,
      spplrInvcNo: json['spplrInvcNo'] as String?,
      regTyCd: json['regTyCd'] as String?,
      pchsTyCd: json['pchsTyCd'] as String?,
      rcptTyCd: json['rcptTyCd'] as String?,
      pmtTyCd: json['pmtTyCd'] as String?,
      pchsSttsCd: json['pchsSttsCd'] as String?,
      cfmDt: json['cfmDt'] as String?,
      pchsDt: json['pchsDt'] as String?,
      wrhsDt: json['wrhsDt'] as String?,
      cnclReqDt: json['cnclReqDt'] as String?,
      cnclDt: json['cnclDt'] as String?,
      rfdDt: json['rfdDt'] as String?,
      totItemCnt: (json['totItemCnt'] as num?)?.toInt(),
      taxblAmtA: (json['taxblAmtA'] as num?)?.toDouble(),
      taxblAmtB: (json['taxblAmtB'] as num?)?.toDouble(),
      taxblAmtC: (json['taxblAmtC'] as num?)?.toDouble(),
      taxblAmtD: (json['taxblAmtD'] as num?)?.toDouble(),
      taxRtA: (json['taxRtA'] as num?)?.toDouble(),
      taxRtB: (json['taxRtB'] as num?)?.toDouble(),
      taxRtC: (json['taxRtC'] as num?)?.toDouble(),
      taxRtD: (json['taxRtD'] as num?)?.toDouble(),
      taxAmtA: (json['taxAmtA'] as num?)?.toDouble(),
      taxAmtB: (json['taxAmtB'] as num?)?.toDouble(),
      taxAmtC: (json['taxAmtC'] as num?)?.toDouble(),
      taxAmtD: (json['taxAmtD'] as num?)?.toDouble(),
      totTaxblAmt: (json['totTaxblAmt'] as num?)?.toDouble(),
      totTaxAmt: (json['totTaxAmt'] as num?)?.toDouble(),
      totAmt: (json['totAmt'] as num?)?.toDouble(),
      remark: json['remark'] as String?,
      modrId: (json['modrId'] as num?)?.toInt(),
      modrNm: json['modrNm'] as String?,
      regrId: (json['regrId'] as num?)?.toInt(),
    )..deletedAt = json['deletedAt'] == null
        ? null
        : DateTime.parse(json['deletedAt'] as String);

const _$PurchaseFieldMap = <String, String>{
  'deletedAt': 'deletedAt',
  'id': 'id',
  'itemIds': 'itemIds',
  'lastTouched': 'lastTouched',
  'createdAt': 'createdAt',
  'action': 'action',
  'tin': 'tin',
  'bhfId': 'bhfId',
  'invcNo': 'invcNo',
  'orgInvcNo': 'orgInvcNo',
  'spplrTin': 'spplrTin',
  'spplrBhfId': 'spplrBhfId',
  'spplrNm': 'spplrNm',
  'spplrInvcNo': 'spplrInvcNo',
  'regTyCd': 'regTyCd',
  'pchsTyCd': 'pchsTyCd',
  'rcptTyCd': 'rcptTyCd',
  'pmtTyCd': 'pmtTyCd',
  'pchsSttsCd': 'pchsSttsCd',
  'cfmDt': 'cfmDt',
  'pchsDt': 'pchsDt',
  'wrhsDt': 'wrhsDt',
  'cnclReqDt': 'cnclReqDt',
  'cnclDt': 'cnclDt',
  'rfdDt': 'rfdDt',
  'totItemCnt': 'totItemCnt',
  'taxblAmtA': 'taxblAmtA',
  'taxblAmtB': 'taxblAmtB',
  'taxblAmtC': 'taxblAmtC',
  'taxblAmtD': 'taxblAmtD',
  'taxRtA': 'taxRtA',
  'taxRtB': 'taxRtB',
  'taxRtC': 'taxRtC',
  'taxRtD': 'taxRtD',
  'taxAmtA': 'taxAmtA',
  'taxAmtB': 'taxAmtB',
  'taxAmtC': 'taxAmtC',
  'taxAmtD': 'taxAmtD',
  'totTaxblAmt': 'totTaxblAmt',
  'totTaxAmt': 'totTaxAmt',
  'totAmt': 'totAmt',
  'remark': 'remark',
  'modrId': 'modrId',
  'modrNm': 'modrNm',
  'regrId': 'regrId',
};

// ignore: unused_element
abstract class _$PurchasePerFieldToJson {
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? itemIds(List<String> instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? createdAt(DateTime instance) => instance.toIso8601String();
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? tin(String? instance) => instance;
  // ignore: unused_element
  static Object? bhfId(String? instance) => instance;
  // ignore: unused_element
  static Object? invcNo(int? instance) => instance;
  // ignore: unused_element
  static Object? orgInvcNo(int? instance) => instance;
  // ignore: unused_element
  static Object? spplrTin(String? instance) => instance;
  // ignore: unused_element
  static Object? spplrBhfId(String? instance) => instance;
  // ignore: unused_element
  static Object? spplrNm(String? instance) => instance;
  // ignore: unused_element
  static Object? spplrInvcNo(String? instance) => instance;
  // ignore: unused_element
  static Object? regTyCd(String? instance) => instance;
  // ignore: unused_element
  static Object? pchsTyCd(String? instance) => instance;
  // ignore: unused_element
  static Object? rcptTyCd(String? instance) => instance;
  // ignore: unused_element
  static Object? pmtTyCd(String? instance) => instance;
  // ignore: unused_element
  static Object? pchsSttsCd(String? instance) => instance;
  // ignore: unused_element
  static Object? cfmDt(String? instance) => instance;
  // ignore: unused_element
  static Object? pchsDt(String? instance) => instance;
  // ignore: unused_element
  static Object? wrhsDt(String? instance) => instance;
  // ignore: unused_element
  static Object? cnclReqDt(String? instance) => instance;
  // ignore: unused_element
  static Object? cnclDt(String? instance) => instance;
  // ignore: unused_element
  static Object? rfdDt(String? instance) => instance;
  // ignore: unused_element
  static Object? totItemCnt(int? instance) => instance;
  // ignore: unused_element
  static Object? taxblAmtA(double? instance) => instance;
  // ignore: unused_element
  static Object? taxblAmtB(double? instance) => instance;
  // ignore: unused_element
  static Object? taxblAmtC(double? instance) => instance;
  // ignore: unused_element
  static Object? taxblAmtD(double? instance) => instance;
  // ignore: unused_element
  static Object? taxRtA(double? instance) => instance;
  // ignore: unused_element
  static Object? taxRtB(double? instance) => instance;
  // ignore: unused_element
  static Object? taxRtC(double? instance) => instance;
  // ignore: unused_element
  static Object? taxRtD(double? instance) => instance;
  // ignore: unused_element
  static Object? taxAmtA(double? instance) => instance;
  // ignore: unused_element
  static Object? taxAmtB(double? instance) => instance;
  // ignore: unused_element
  static Object? taxAmtC(double? instance) => instance;
  // ignore: unused_element
  static Object? taxAmtD(double? instance) => instance;
  // ignore: unused_element
  static Object? totTaxblAmt(double? instance) => instance;
  // ignore: unused_element
  static Object? totTaxAmt(double? instance) => instance;
  // ignore: unused_element
  static Object? totAmt(double? instance) => instance;
  // ignore: unused_element
  static Object? remark(String? instance) => instance;
  // ignore: unused_element
  static Object? modrId(int? instance) => instance;
  // ignore: unused_element
  static Object? modrNm(String? instance) => instance;
  // ignore: unused_element
  static Object? regrId(int? instance) => instance;
}

Map<String, dynamic> _$PurchaseToJson(Purchase instance) => <String, dynamic>{
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'id': instance.id,
      'itemIds': instance.itemIds,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'action': instance.action,
      'tin': instance.tin,
      'bhfId': instance.bhfId,
      'invcNo': instance.invcNo,
      'orgInvcNo': instance.orgInvcNo,
      'spplrTin': instance.spplrTin,
      'spplrBhfId': instance.spplrBhfId,
      'spplrNm': instance.spplrNm,
      'spplrInvcNo': instance.spplrInvcNo,
      'regTyCd': instance.regTyCd,
      'pchsTyCd': instance.pchsTyCd,
      'rcptTyCd': instance.rcptTyCd,
      'pmtTyCd': instance.pmtTyCd,
      'pchsSttsCd': instance.pchsSttsCd,
      'cfmDt': instance.cfmDt,
      'pchsDt': instance.pchsDt,
      'wrhsDt': instance.wrhsDt,
      'cnclReqDt': instance.cnclReqDt,
      'cnclDt': instance.cnclDt,
      'rfdDt': instance.rfdDt,
      'totItemCnt': instance.totItemCnt,
      'taxblAmtA': instance.taxblAmtA,
      'taxblAmtB': instance.taxblAmtB,
      'taxblAmtC': instance.taxblAmtC,
      'taxblAmtD': instance.taxblAmtD,
      'taxRtA': instance.taxRtA,
      'taxRtB': instance.taxRtB,
      'taxRtC': instance.taxRtC,
      'taxRtD': instance.taxRtD,
      'taxAmtA': instance.taxAmtA,
      'taxAmtB': instance.taxAmtB,
      'taxAmtC': instance.taxAmtC,
      'taxAmtD': instance.taxAmtD,
      'totTaxblAmt': instance.totTaxblAmt,
      'totTaxAmt': instance.totTaxAmt,
      'totAmt': instance.totAmt,
      'remark': instance.remark,
      'modrId': instance.modrId,
      'modrNm': instance.modrNm,
      'regrId': instance.regrId,
    };
